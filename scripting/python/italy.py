'''
italy.py
'''
import sys, argparse
import glob
import re,os
from auxiliary_functions import is_match, increment, check_path
from log_processing_base import LogBase, LogProcessorBase, ActionBase

#######################################################################################################
#### Logging
#######################################################################################################
import logging.config
logger = logging.getLogger('log_processor')

#####################################################################################################################
### Global variables
#####################################################################################################################

#######################################################################################################
### Italy
#######################################################################################################
class ItalyLogCommon(LogBase):
    def __init__(self, params):
        super().__init__(params)

    def _get_current_log_fullpath_pattern(self):
        if 'env_name' not in self.params.keys():
            raise 'Environment not found'

        if self.params['env_name'] == 'IOM':
            return r'\\10.42.35.239\y\LogsIOM\${ip}$\${date}$\d$\logs\poker'
        elif self.params['env_name'] == 'QA':
            return r'\\${ip}$\logs\poker'
        raise 'Unsupported environment'

    def _get_past_log_fullpath_pattern(self):
        if 'env_name' not in self.params.keys():
            raise 'Environment not found'

        if self.params['env_name'] == 'IOM':
            # W:\app_logs\10.42.20.196\logs\20240613\10.42.20.196\d$\logs\poker
            return r'W:\app_logs\${ip}$\logs\${date}$\${ip}$\d$\logs\poker'
        elif self.params['env_name'] == 'QA':
            return r'\\10.30.90.202\app_logs\QA\${ip}$\logs\${date}$\${ip}$\d$\logs\poker'
        raise 'Unsupported environment'

    def get_ip(self, env:str):
        if 'ip' not in self.params.keys():
            raise 'ip address not found'

        if len(self.params['ip']) == 0:
            raise 'Server ip is null'
        else:
            return self.params['ip']
## end class ItalyLogCommon


class AamsITLog(ItalyLogCommon):
    def __init__(self, params):
        super().__init__(params)

    def get_list_of_logs_fullpath(self, date:str, env:str)->list:
        self.params['date'] = str(date)
        self.params['env_name'] = str(env)
        full_logs = list()

        logger.debug('\n--- date=%s, env=%s', date, env)
        ### active logs
        if self.is_active_logs():
            full_logs = glob.glob(self._get_current_log_fullpath() + '\\' + self.params['log_basename'] + '.log.' + self.params['date'])

        ### historical logs
        if self.is_historical_logs():
            full_logs.extend(glob.glob(self._get_past_log_fullpath() + '\\' + self.params['log_basename'] + '.log.' + self.params['date'] + '.gz'))
        logger.debug('\n%s', str(full_logs))
        return full_logs

## class AamsITLog END


########################################################################################################################
### Processors
########################################################################################################################
class AamsItLogProcessor(LogProcessorBase):
    def __init__(self, params:dict):
        super().__init__(params)

# class AamsItLogProcessor END



########################################################################################################################
### Statistics
########################################################################################################################
class AamsItStatistics(ActionBase):
    def __init__(self, params):
        super().__init__(params)
        self.__output_filename = params['output_filename']
        self.__output_path = params['output_path']
        self.__results = dict()


    def __call__(self, params:dict):
        time_stamp = params['time_str'].strip()
        # DBM_Q_OLAP_REPLICATE_USER_FLAGS_PRIVS_CHANGED: 'hdjsjdjdio' 102206409, docVerified='n', privRMUdp='n'
        content = params['content'].strip().replace(',','').split()

        ''' Collections '''
        result = []
        result.append(time_stamp[1:-1])
        result.append(content[1].replace("'",""))
        result.append(content[2])

        log_date = time_stamp[1:11]
        if log_date in self.__results.keys():
            r = self.__results[log_date]
            r.append(result)
        else:
            self.__results[log_date] = [result]
        return

    def print_results(self):
        logger.debug(str(self.__results))
        self.__tofile()

    def __tofile(self):
        check_path(self.output_path)
        for k,v in self.__results.items():
            log_date = k.replace('/','') + '_'
            output_filename =  self.__output_path + log_date + self.__output_filename + '.csv'
            with open(output_filename, mode='a', encoding='utf8', errors='surrogateescape') as outfile:
                outfile.write('Timestamp,user,userIntId')
                for result in v:
                    outfile.write('\n' + result[0] + ',' + result[1] + ',' + result[2])
                outfile.write('\n\n*** Total: '  + str(len(v)))
        return

# class AamsItStatistics END


def collectStats(params:dict):

    replicatorStats = [ AamsItStatistics({'output_filename': params['log_basename'], 'output_path': os.getcwd() + '\\stats\\', }) ]

    processor = AamsItLogProcessor({})
    processor.run({ 'log_object' : AamsITLog(params),
                    'env_name_list' : [params['env_name']],
                    'day_first' : params['date_first'],
                    'day_last'  : params['date_last'],
                    'pattern' : re.compile(r'DBM_Q_OLAP_REPLICATE_USER_FLAGS_PRIVS_CHANGED:.*, docVerified=\'y\', privRMUdp=\'n\''),
                    'result_filename_prefix' : 'results_',
                    'actions' : replicatorStats })

    ## print results
    for stat in replicatorStats:
        stat.print_results()



#######################################################################################################
#### Main
#######################################################################################################
if __name__ == '__main__':
    levels = ('DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL')
    script_name = 'log_processor.' + os.path.basename(__file__)
    ap = argparse.ArgumentParser(prog=script_name
                                , usage='%(prog)s [options]'
                                , description='create instance of server module with provided paramters'
                                , epilog='Usage: python main.py --env_name IOM --ip-address 10.91.23.71 --log_basename Default.arjelTransport --date_first 20221116 --date_last 20221201')

    ap.add_argument('--env_name',     type=str, dest='env_name',       required=True, default='IOM', help='Environments to process logs - IOM|QA')
    ap.add_argument('--ip-address',   type=str, dest='ip',             required=True, default='', help='IP address of where logs were/are stored, format: 127.0.0.1')
    ap.add_argument('--log_basename', type=str, dest='log_basename',   required=True, default='',help='Log base filename')
    ap.add_argument('--date_first',   type=str, dest='date_first',     required=True, default='', help='First date to process')
    ap.add_argument('--date_last',    type=str, dest='date_last',      required=False, default='', help='Last date to process')
    ap.add_argument('--log_level',              dest='log_level',      required=False, default='INFO', choices=levels, help='log level: DEBUG|INFO|WARNING|ERROR|CRITICAL')
    args = ap.parse_args()

    logger = logging.getLogger('log_processor')
    logger.setLevel(args.log_level)

    sys.exit(collectStats(vars(args)))
#
