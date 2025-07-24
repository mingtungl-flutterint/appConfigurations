''' spain.py '''
import sys, argparse, datetime, time
import glob
import re
from auxiliary_functions import *
from log_processing_base import LogBase, LogProcessorBase, ActionBase

#######################################################################################################
#### Logging
#######################################################################################################
import logging, logging.config
logger = logging.getLogger('log_processor')

#####################################################################################################################
### Global variables
#####################################################################################################################



#######################################################################################################
### Reports
#######################################################################################################
class CJDReport(LogBase):
    def __init__(self, params):
        super().__init__(params)

    def _get_current_log_fullpath_pattern(self):
        if self.params['env_name'] == 'IOM':
            return r'\\${ip}\y\LogsIOM\${ip}$\${date}$\d$\arjelhands'
        elif self.params['env_name'] == 'QA':
            return r'\\${ip}$\logs\poker'
        raise 'Unsupported environment'

    def _get_past_log_fullpath_pattern(self):
        if self.params['env_name'] == 'IOM':
            return r'W:\app_logs\${ip}$\logs\${date}$\${ip}$\d$\arjelhands'
        elif self.params['env_name'] == 'QA':
            return r'\\10.30.90.202\app_logs\QA\${ip}$\logs\${date}$\${ip}$\d$\logs\poker'
        raise 'Unsupported environment'

    def get_ip(self, env:str):
        if env == 'IOM':
            return '10.91.23.71'
        elif env == 'QA':
            return '10.30.20.71'
        raise 'Unknown env_name'

    def get_list_of_cjt_report_files(self, path:str)->list:
        reports = list()

        logger.debug(f'--- path={path}')
        
        #for file in glob.glob(path, recursive=True):
        #    reports.append(file)
        for (dir_path, dir_name, file_name) in os.walk(path):
            logger.info(f'\ndir_path={dir_path}')
            logger.info(f'\ndir_name={dir_name}')
            logger.info(f'\nfilename={file_name}')

        return reports

## end


########################################################################################################################
### Processors
########################################################################################################################
class CJTProcessor(LogProcessorBase):
    def __init__(self, params:dict):
        super().__init__(params)

    def _read_block(self, fh)->str:
        block_content = str()
        while True:
            line = fh.readline()
            if not line: # eof detected
                break
            block_content += line
            if is_match(line, self.block_end_pattern):
                break
        return block_content

    
    def _process_line(self, content:str, pattern:re, actions:list, extra:dict):
        ofile = extra['outfile_handle']
        
        match = re.search(pattern, content)
        if not match:
            return
        content = match[0]
        #logger.info(content)
        freeBet = r'<Unidad>FreeBet EUR</Unidad>'
        linea = r'Linea'
        cantidad = re.compile(f'(<Cantidad>)([+-.0-9]*)(</Cantidad>)')
        
        ''' search for Otros node first '''
        idx = content.find(freeBet)
        if idx > 0:
            idx_end = content.find(linea, idx, -1)
            if idx_end > 0:
                idx_end += 1 + len(linea)
            idx_start = content.rfind(linea, 0, idx)
            if idx_start > 0:
                idx_start -= 1
            content = content[idx_start:idx_end]
            logger.info(f'content={content}')
            match = re.search(cantidad, content)
            if match is not None:
                amount = match.group(2)
                amount = 100*float(amount)
                logger.info(f'amt={amount}')
                ofile.write(f'{amount}\n')
                [action(int(amount)) for action in actions]
            
            
        ''' data collections '''
        #params = {'time_str':time_str, 'content':line, 'log_filename':log_filename}
        #[action(params) for action in actions]

    def _process_file(self, logfile:str, log_filename:str, params:dict):
        log_object = params['log_object']
        pattern = params['pattern']
        actions = params.get('actions', [])
        is_block_processing = params.get('is_block_processing', False)

        logger.debug("\n=== lf=%s", logfile)
        with open(log_filename, 'r', encoding='utf-8', errors='surrogateescape') as f:
            ofile = open('amount.out', 'a', encoding='utf-8')
            while True:
                line = f.readline()
                if not line:
                    break
                self._process_line(line, pattern, actions, {'outfile_handle': ofile})

        
    def run(self, params:dict):
        log_object = params['log_object']
        result_filename_prefix = params.get('result_filename_prefix', None)

        path = r'D:/Users/mingtungl/wip/ES/TSO-15404/CJT_D_062022'
        
        logger.debug(str(params))
    
        for dir_path, dir_name, file_name in os.walk(path):
            for f in file_name:
                filename = os.path.join(dir_path, f)
                logger.debug(f"file: {filename}")
                #print(f'{filename}')
                self._process_file(filename, filename, params)

#

########################################################################################################################
### Statistics
########################################################################################################################
class CJTResult(ActionBase):
    def __init__(self, params:dict):
        super().__init__(params)
        self.__output_filename = params.get('output_filename', 'output.txt')
        self.__sum = 0

    def __call__(self, amount:int):
        self.__sum += amount

    def print_results(self):
        logger.info(f'\nTotal amount = {str(self.__sum)}')
        print(f'\nTotal amount = {str(self.__sum)}')




def collectStats(log_level:int, params:dict):

    action = CJTResult({})
    processor = CJTProcessor({})
    processor.run({ 'log_object' : CJDReport({}),
                    'pattern' : re.compile(r"saving:|saved: '\/SECRET\?eventId:|ATTENTION: Wrote [0-9]* retry events"),
                    'result_filename_prefix' : 'results.es_CJT_freebetEUR',
                    'pattern' : re.compile(r'<Otros>.*</Otros>'),
                    'is_block_processing' : False,
                    'actions' : [action] })
    action.print_results()
    
''' main '''
if __name__ == '__main__':
    argv_parser = argparse.ArgumentParser(prog='log_processor'
                                , usage='%(prog)s [options]'
                                , description='create instance of server module with provided paramters'
                                , epilog='Usage: python main.py --env_name ["IOM"] --ip-address "10.91.23.71" --log_basename "Default.arjelTransport" --date_first 20221116 --date_last 20221201')

    argv_parser.add_argument('--env_name',     type=list, dest='env_name_list', required=False, default=['IOM'], help='Environments to process logs - IOM|QA')
    argv_parser.add_argument('--ip-address',   type=str, dest='ip',             required=False, default='', help='IP address of where logs were/are stored, format: 127.0.0.1')
    argv_parser.add_argument('--log_basename', type=str, dest='log_basename',   required=False, default='',help='Log base filename')
    argv_parser.add_argument('--date_first',   type=str, dest='date_first',     required=False, default='', help='First date to process')
    argv_parser.add_argument('--date_last',    type=str, dest='date_last',      required=False, default='', help='Last date to process')
    argv_parser.add_argument('--log_level',    type=int, dest='log_level',      required=False, default=logging.INFO, help='log level: logging.DEBUG|logging.INFO|loggin.WARNING|etc.')
    args = argv_parser.parse_args()

    logger = logging.getLogger('log_processor')
    logger.setLevel(args.log_level)

    sys.exit(collectStats(args.log_level, {}))
#

