### LIST-3226-CAON: Monthly_Highest_Revenue.
# python caon_Monthly_Highest_Revenue.py --log_level DEBUG --env_name 'IOM' --ip-address '10.91.23.71' --log_basename 'Default.arjelTransport' --date_first 20221116 --date_last 20221201

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
class Monthly_Highest_Revenue_Report(LogBase):
    def __init__(self, params):
        super().__init__(params)

    def _get_current_log_fullpath_pattern(self):
        return r' Y:\prodsupport\alexanderpy\TSO-20871'

    def _get_past_log_fullpath_pattern(self):
        raise NotImplementedError

    def get_ip(self, env:str):
        raise NotImplementedError

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
class Monthly_Highest_Revenue_Processor(LogProcessorBase):
    def __init__(self, params:dict):
        super().__init__(params)
        self.processed_logfiles_list = []

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
        #ofile = extra['outfile_handle']
        ''' data collections '''
        params = { 'content':content }
        [action(params) for action in actions]

    def _process_file(self, logfile:str, log_filename:str, params:dict):
        actions = params.get('actions', [])

        logger.debug("\n=== lf=%s", logfile)
        
        ofname = 'CAON_results\\'
        if re.match(r'Debug_PlayerActivityExtendedData_', logfile):
            ofname += params['pattern'] + '_PlayerActivityExtendedData' + '.txt'
        elif re.match('Debug_PlayerRakeBets_', logfile):
            ofname += params['pattern'] + '_PlayerRakeBets' + '.txt'
        else:
            raise Exception('Invalid log file')
            
        ofile = open(ofname, 'a+')
        
        with open(log_filename, 'r', encoding='utf-8', errors='surrogateescape') as infile:
        
            header = infile.readline().strip()
            
            if re.match(r'Debug_PlayerActivityExtendedData_', logfile):
                if 'PlayerActivityExtendedData' not in self.processed_logfiles_list:
                    self.processed_logfiles_list.append('PlayerActivityExtendedData')
                    ofile.write(header + '\n')
            
            if re.match('Debug_PlayerRakeBets_', logfile):
                if 'PlayerRakeBets' not in self.processed_logfiles_list:
                    self.processed_logfiles_list.append('PlayerRakeBets')
                    ofile.write(header + '\n')
                
            while True:
                line = infile.readline().strip()
                if not line:
                    break
                
                if re.search(params['pattern'], line):
                    ofile.write(line + '\n')
                    self._process_line(line, re.compile(r"params['pattern']"), actions, {'outfile_handle': ofile})
            ofile.close()    
        
    def run(self, params:dict):
        path = r'Y:\prodsupport\alexanderpy\TSO-20871'
        
        # Extract userintids
        filename = path + '/062023_OPIG1232716_MonthlyHighestRevenue_V2.csv'
        with open(filename, 'r', encoding='utf-8', errors='surrogateescape') as infile:
            line = infile.readline()
            uiids = []
            while True:
                line = infile.readline().strip()
                if not line:
                    break
                
                content = re.split(',', line)
                uiids.append(content[0])
                
            params['uiids'] = uiids
        logger.debug('### User int ids: ' + str(params['uiids']))
        
        logger.debug(str(params))
        for uid in params['uiids']:
            params['pattern'] = str(uid)
            logger.debug(f'userIntId: {params["pattern"]}')
            self.processed_logfiles_list.clear()
            for dir_path, dir_name, file_name in os.walk(path):
                for fname in file_name:
                    fname.strip()

                    if 'Debug_' in fname:            
                        filename = os.path.join(dir_path, fname)
                        logger.debug(f"file: {filename}")
                        self._process_file(fname, filename, params)

#

########################################################################################################################
### Statistics
########################################################################################################################
class Monthly_Highest_Revenue_Stats(ActionBase):
    def __init__(self, params:dict):
        super().__init__(params)
        self.__output_filename = params.get('output_filename', 'output.txt')
        self.playersData = dict({}) # userId -> dict('hiddenCasinoWagers':0, 'hiddenCasinoWins':0, 'hiddenSbWagers':0, 'hiddenSbWins':0, 'pokerRake':0, 'pokerBets':0, 'tournRake':0, 'tournBets':0)

    def __call__(self, params:dict):
        content = params['content']
        data = re.split(',', content) # list
        size = len(data)
        userId = 0
        if size > 6: # player activity data
            userId = str(data[2])
        elif size == 6: # rakes & bets
            userId = str(data[0])
            
        playerData = self.playersData.setdefault(userId, { 'hiddenCasinoWagers':0, 'hiddenCasinoWins':0, 'hiddenSbWagers':0, 'hiddenSbWins':0, 'pokerRake':0, 'pokerBets':0, 'tournRake':0, 'tournBets':0 } )

        if size > 6: # player activity data
            accumulate(playerData,'hiddenCasinoWagers', int(data[size - 5]))
            accumulate(playerData,'hiddenCasinoWagers', int( data[size - 4]))
            accumulate(playerData,'hiddenCasinoWins', int( data[size - 3]))
            accumulate(playerData,'hiddenSbWagers', int( data[size - 2]))
            accumulate(playerData,'hiddenSbWins', int( data[size - 1]))
        elif size == 6:
            accumulate(playerData,'pokerRake', int( data[size - 4]))
            accumulate(playerData,'pokerBets', int( data[size - 3]))
            accumulate(playerData,'tournRake', int(data[size - 2]))

        #print(str(self.playersData[userId]))


    def print_results(self):
        for uid in self.playersData.keys():
            logger.info(f'{uid} -> {self.playersData[uid]}')
            print(f'u={uid} -> {self.playersData[uid]}')




def collectStats(params:dict):

    action = Monthly_Highest_Revenue_Stats({})
    processor = Monthly_Highest_Revenue_Processor({})
    
    #userIntIds = {'uid' : [110474078]}
    processor.run({ 'log_object' : Monthly_Highest_Revenue_Report({}),
                    'result_filename_prefix' : 'results.caon_Monthly_Highest_Revenue',
                    'actions' : [action] })
    action.print_results()
    
''' main '''
if __name__ == '__main__':
    levels = ('DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL')
    argv_parser = argparse.ArgumentParser(prog='log_processor'
                                , usage='%(prog)s [options]'
                                , description='create instance of server module with provided paramters'
                                , epilog='Usage: python main.py --env_name ["IOM"] --ip-address "10.91.23.71" --log_basename "Default.arjelTransport" --date_first 20221116 --date_last 20221201')

    argv_parser.add_argument('--env_name',     type=list, dest='env_name_list', required=False, default=['IOM'], help='Environments to process logs - IOM|QA')
    argv_parser.add_argument('--ip-address',   type=str, dest='ip',             required=False, default='', help='IP address of where logs were/are stored, format: 127.0.0.1')
    argv_parser.add_argument('--log_basename', type=str, dest='log_basename',   required=False, default='',help='Log base filename')
    argv_parser.add_argument('--date_first',   type=str, dest='date_first',     required=False, default='', help='First date to process')
    argv_parser.add_argument('--date_last',    type=str, dest='date_last',      required=False, default='', help='Last date to process')
    argv_parser.add_argument('--log_level',    type=str, dest='log_level',      required=False, default=logging.INFO, help='log level: logging.DEBUG|logging.INFO|loggin.WARNING|etc.')
    args = argv_parser.parse_args()

    logger = logging.getLogger('log_processor')
    logger.setLevel(args.log_level)

    sys.exit(collectStats( {} ))
#
