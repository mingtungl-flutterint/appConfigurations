''' log_processros_base.py '''
from abc import ABC, abstractmethod
import datetime, time
import os, glob, copy
import re
from auxiliary_functions import *
import logging.config
logger = logging.getLogger('log_processor')

#######################################################################################################
#### Base classes
#######################################################################################################
class LogBase(ABC):
    def __init__(self, params:dict):
        self.params = copy.deepcopy(params)
        self.pattern_timestamp = re.compile(r'\[\d{4,4}\/\d\d\/\d\d[ 0-9:]+\]', re.M)

    ''' Public methods '''
    def get_list_of_logs_fullpath(self, date:str)->list:
        raise NotImplementedError

    def is_active_logs(self)->bool:
        log_path = self._get_current_log_fullpath()
        if os.path.exists(log_path):
            return True
        return False

    def is_historical_logs(self)->bool:
        log_path = self._get_past_log_fullpath()
        if os.path.exists(log_path):
            return True
        return False

    @abstractmethod
    def get_ip(self, env:str)->str:
        raise NotImplementedError

    ''' Protected methods '''
    def _get_current_log_fullpath(self)->str:
        pattern = self._get_current_log_fullpath_pattern()
        return str_replace_params(pattern, self.params)

    def _get_past_log_fullpath(self)->str:
        pattern = self._get_past_log_fullpath_pattern()
        return str_replace_params(pattern, self.params)

    @abstractmethod
    def _get_current_log_fullpath_pattern(self)->str:
        raise NotImplementedError

    @abstractmethod
    def _get_past_log_fullpath_pattern(self)->str:
        raise NotImplementedError

## end class LogBase


#######################################################################################################
#### Processors
#######################################################################################################
class LogProcessorBase:
    def __init__(self, params:dict):
        self.time_pattern = params.get('time_pattern', re.compile(r'\[\d{4,4}\/\d\d\/\d\d[ 0-9:]+\]'))
        self.block_start_pattern = params.get('block_start_pattern', None)
        self.block_end_pattern = params.get('block_end_pattern', None)

    def _read_block(self, fh)->str:
        raise NotImplementedError
    
    def _process_line(self, line:str, pattern:re, actions:list, extra:dict):
        time_str = extra.get('time_str', '')
        log_filename = extra.get('log_filename', '')
        match = re.search(pattern, line)
        if not match:
            return

        logger.debug(line)
        ''' data collections '''
        params = {'time_str':time_str, 'content':line, 'log_filename':log_filename}
        [action(params) for action in actions]

    ''' TODO '''
    def _process_block(self, time_str_before_block, block_lines: list, pattern, result_file):
        if not block_lines:
            return
        for line in block_lines:
            match = re.search(pattern, line)
            if match:
                result_file.write("\n>>> found:\n")
                result_file.write(time_str_before_block)
                for ln in block_lines:
                    result_file.write(ln)
                return

    def _get_dict_of_logs_fullpath(self, log_object, env_name, lday_first, lday_last):
        dict_of_logs_fullpath = {}

        for _date in make_date_list(lday_first, lday_last):
            ldate = str(_date.strftime("%Y%m%d"))
            dict_of_logs_fullpath[ldate] = log_object.get_list_of_logs_fullpath(ldate, env_name)

        return dict_of_logs_fullpath


    def _process_file(self, logfile:str, log_filename:str, params:dict):
        log_object = params['log_object']
        pattern = params['pattern']
        actions = params.get('actions', [])
        is_block_processing = params.get('is_block_processing', False)

        logger.debug("\n=== lf=%s", logfile)
        with open(log_filename, 'r', encoding='utf8', errors='surrogateescape') as f:
            if is_block_processing:     ## TODO
                time_str_last = ''
                time_str_before_block = ''
                time_str_seen_in_block = ''
                while True:
                    line = f.readline()
                    if not line: # eof detected
                        break
                    if is_match(line, self.time_pattern):
                        time_str_last = line
                        continue
                    if is_match(line, self.block_start_pattern):
                        time_str_before_block = time_str_last
                        content = line
                        content += self._read_block(f)
                        logger.debug("\n%s", content)
                        ''' process the block '''
                        #self._process_block()
                        continue
            else:
                time_str_last = ""
                while True:
                    line = f.readline()
                    if not line:
                        break
                    if is_match(log_object.pattern_timestamp, line):
                        time_str_last = line
                        continue
                    self._process_line(line, pattern, actions, {'time_str':time_str_last, 'log_filename': log_filename})


    def run(self, params:dict):
        log_object = params['log_object']
        env_name_list = params['env_name_list']
        lday_first = int(params['day_first'])
        lday_last = int(params['day_last'])
        result_filename_prefix = params.get('result_filename_prefix', None)
        starttime = datetime.datetime.now()
        start_time = starttime.strftime('%H:%M:%S')

        logger.debug(str(params))
        logger.debug("Start Time: %s", str(start_time))


        for env_name in env_name_list:
            dict_of_logs_fullpath = self._get_dict_of_logs_fullpath(log_object, env_name, lday_first, lday_last)
            logger.info("process_log: env=%s", log_object.params['env_name'])
            logger.info("dict has %s elements", str(len(dict_of_logs_fullpath)))
            for date,logfiles in dict_of_logs_fullpath.items():
                logger.info("Found %s log files on %s", str(len(logfiles)), date)

                for logfile in logfiles:
                    logger.debug("  lf: %s", logfile)

                    if logfile == '' or not os.path.exists(logfile):
                        logger.info("%s is not found", logfile)
                        continue

                    filename = os.path.basename(logfile)
                    if len(filename) == 36:
                        filename = filename[0:-12]
                    elif filename.endswith('.gz'):
                        filename = filename.replace('.gz', '')

                    log_filename = ''
                    if not logfile.endswith('.gz'):
                        log_filename = logfile
                    else:
                        unzip_file(logfile)

                        candidates = glob.glob('*' + filename)
                        logger.debug(str(candidates))
                        if len(candidates) != 1:
                            raise RuntimeError('Unexptected size of candidates')
                        log_filename = candidates[0]

                    self._process_file(logfile, log_filename, params)

                    if logfile.endswith('.gz'):
                        time.sleep(1)   # will cause file access violation if deleting too soon
                        logger.debug('removing %s', log_filename)
                        os.remove(log_filename)

## end class LogProcessorBase

#######################################################################################################
#### Actions
#######################################################################################################
class ActionBase(ABC):
    def __init__(self, params:dict):
        self.output_path = params.get('output_path', '')


    @abstractmethod
    def print_results(self):
        raise NotImplementedError


## end class ActionBase

