''' arjel.py '''
import sys, argparse
import glob
import re
from auxiliary_functions import *
from log_processing_base import LogBase, LogProcessorBase, ActionBase

#######################################################################################################
#### Logging
#######################################################################################################
import logging.config
logger = logging.getLogger('log_processor')

#####################################################################################################################
### Global variables
#####################################################################################################################
__lday_first = '20221231'
__lday_last  = '20230103'
__environments = ['IOM']

#######################################################################################################
### Arjel
#######################################################################################################
class ArjelLogCommon(LogBase):
    def __init__(self, params):
        super().__init__(params)

    def _get_current_log_fullpath_pattern(self):
        if self.params['env_name'] == 'IOM':
            return r'\\${ip}$\y\LogsIOM\${ip}$\${date}$\d$\arjelhands'
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
## end class ArjelLogCommon

class ArjelHandsLog(ArjelLogCommon):
    def __init__(self, params):
        super().__init__(params)

    def get_list_of_logs_fullpath(self, date:str, env:str)->list:
        self.params['date'] = str(date)
        self.params['env_name'] = str(env)
        self.params['ip'] = self.get_ip(env)
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

## end class ArjelHandsLog

class ArjelTransportLog(ArjelLogCommon):
    def __init__(self, params):
        super().__init__(params)

    def get_list_of_logs_fullpath(self, date:str, env:str)->list:
        self.params['date'] = str(date)
        self.params['env_name'] = str(env)
        self.params['ip'] = self.get_ip(env)
        full_logs = list()

        logger.debug('\n--- date=%s, env=%s', date, env)
        ### active logs
        if self.is_active_logs():
            full_logs = glob.glob(self._get_current_log_fullpath() + '\\' + self.params['log_basename'] + '*.*.log.' + self.params['date'])

        ### historical logs
        if self.is_historical_logs():
            full_logs.extend(glob.glob(self._get_past_log_fullpath() + '\\' + self.params['log_basename'] + '*.*.log.' + self.params['date'] + '.gz'))
        logger.debug('\n%s', str(full_logs))
        return full_logs

## end class ArjelTransportLog


########################################################################################################################
### Processors
########################################################################################################################
class ArjelLogProcessor(LogProcessorBase):
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

#

########################################################################################################################
### Statistics
########################################################################################################################
class TransportStatistics(ActionBase):
    def __init__(self, params):
        super().__init__(params)
        self.__output_filename = params['output_filename']
        self.timeout_pattern = params['timeout_pattern']    ## timeout search pattern
        self.save_pattern = params['save_pattern']          ## msg successfully saved search pattern
        self.write_pattern = params['write_pattern']        ## msg received search pattern
        self.__results = dict()
        self.__results2 = dict()


    def __call__(self, params:dict):
        time_str = params['time_str']
        content = params['content']
        log_filename = params['log_filename']

        date_str = time_str[1:5] + time_str[6:8] + time_str[9:11]
        hour_str = str(time_str[12:14])
        ''' log_filename: Default.arjelTransportSB.29.log.20221116 '''
        idx = 1 + log_filename.find('.')
        instance_id = log_filename[idx:-13]

        # { 'date':{'instance_id':{'hour':{'saved':0, 'recvd':0, 'timeouts':0}} } }
        if date_str not in self.__results.keys():
            self.__results.update( { date_str: { instance_id: { hour_str: { 'saved':0, 'recvd':0, 'timeouts':0 } } } } )

        if instance_id not in self.__results[date_str].keys():
            self.__results[date_str].update( { instance_id: { hour_str: { 'saved':0, 'recvd':0, 'timeouts':0 } } } )

        if hour_str not in self.__results[date_str][instance_id].keys():
            self.__results[date_str][instance_id].update( { hour_str: { 'saved':0, 'recvd':0, 'timeouts':0 } } )

        # { 'date':{'hour'} : {instance_id':{'saved':0, 'recvd':0, 'timeouts':0}} } }
        if date_str not in self.__results2.keys():
            self.__results2.update( { date_str : { hour_str: { instance_id : {'saved':0, 'recvd':0, 'timeouts':0} } } } )
        if hour_str not in self.__results2[date_str].keys():
            self.__results2[date_str].update( { hour_str: { instance_id : {'saved':0, 'recvd':0, 'timeouts':0} } } )
        if instance_id not in self.__results2[date_str][hour_str].keys():
            self.__results2[date_str][hour_str].update( { instance_id: {'saved':0, 'recvd':0, 'timeouts':0} } )

        ''' Collections '''
        results = self.__results[date_str][instance_id][hour_str]
        results2 = self.__results2[date_str][hour_str][instance_id]
        if re.search(self.timeout_pattern, content):
            increment(results, 'timeouts')
            increment(results2, 'timeouts')

        if re.search(self.save_pattern, content):
            increment(results, 'saved')
            increment(results2, 'saved')

        if re.search(self.write_pattern, content):
            increment(results, 'recvd')
            increment(results2, 'recvd')

    def print_results(self):
        logger.debug(str(self.__results))
        self.__print_csv()
        #self.__print_txt()

    def __print_csv(self):
        check_path(self.output_path)
        output_filename =  self.output_path + self.__output_filename + '.csv'
        with open(output_filename, mode='a', encoding='utf8', errors='surrogateescape') as outfile:
            total_rcvd = 0
            total_saved = 0
            total_timeouts = 0

            for date_str, hour_dict in self.__results2.items():
                outfile.write('\n========================================================================')
                outfile.write('\n=== Date: ' + date_str)
                outfile.write('\n========================================================================')
                for hour_str, instance_dict in hour_dict.items():
                    outfile.write('\n-- Hour: ' + hour_str)
                    outfile.write('\nInstanceId, #timeouts, #saved, #received')
                    for instance_str, data in instance_dict.items():
                        saved = data.get('saved', 0)
                        timeouts = data.get('timeouts', 0)
                        received = data.get('recvd', 0)

                        result_line = '\n' + str(instance_str) + ',' + str(timeouts) + ',' + str(saved) + ',' + str(received)
                        outfile.write(result_line)
                    outfile.write('\n\n')
            outfile.write('\n\n\n')

            ''' { 'date':{'instance_id':{'hour':{'saved':0, 'recvd':0, 'timeouts':0}} } } '''
            for date_str, instance_dict in self.__results.items():
                daily_rcvd_accumulation = 0
                daily_saved_accumulation = 0
                daily_timeouts_accumulation = 0
                outfile.write('\n========================================================================')
                outfile.write('\n=== Date: ' + date_str)
                outfile.write('\n========================================================================')
                for instance_str, hour_dict in instance_dict.items():
                    outfile.write('\n-- Instance Id: ' + instance_str)
                    outfile.write('\nhour, #timeouts, #saved, #received, #recvd - #saved')
                    daily_rcvd_per_instance = 0
                    daily_saved_per_instance = 0
                    daily_timeouts_per_instance = 0
                    for hour, hourly_dict in hour_dict.items():
                        hourly_saved = hourly_dict.get('saved', 0)
                        hourly_timeouts = hourly_dict.get('timeouts', 0)
                        hourly_received = hourly_dict.get('recvd', 0)
                        hourly_diff = hourly_received - hourly_saved

                        result_line = '\n' + str(hour) + ',' + str(hourly_timeouts) + ',' + str(hourly_saved) + ',' + str(hourly_received) + ',' + str(hourly_diff)
                        outfile.write(result_line)

                        daily_rcvd_per_instance += hourly_received
                        daily_saved_per_instance += hourly_saved
                        daily_timeouts_per_instance += hourly_timeouts

                    outfile.write('\nDaily messages received: ' + str(daily_rcvd_per_instance))
                    outfile.write('\nDaily messages successfully saved: '  + str(daily_saved_per_instance))
                    outfile.write('\nDaily tcp timeouts: ' + str(daily_timeouts_per_instance) + '\n\n')

                    daily_rcvd_accumulation += daily_rcvd_per_instance
                    daily_saved_accumulation += daily_saved_per_instance
                    daily_timeouts_accumulation += daily_timeouts_per_instance

                total_rcvd += daily_rcvd_accumulation
                total_saved += daily_saved_accumulation
                total_timeouts +=daily_timeouts_accumulation

            outfile.write('\n* Total messages received (all instances): '  + str(total_rcvd))
            outfile.write('\n* Total messages successfully saved (all instances): '  + str(total_saved))
            outfile.write('\n* Total tcp timeouts (all instances): '  + str(total_timeouts) + '\n\n')


    def __print_txt(self):
        check_path(self.output_path)
        output_filename =  self.output_path + self.__output_filename + '.txt'
        with open(output_filename, mode='a', encoding='utf8', errors='surrogateescape') as outfile:
            total_rcvd = 0
            total_saved = 0
            total_timeouts = 0
            ''' { 'date':{'instance_id':{'hour':{'saved':0, 'recvd':0, 'timeouts':0}} } } '''
            for date_str, instance_dict in self.__results.items():
                daily_rcvd_accumulation = 0
                daily_saved_accumulation = 0
                daily_timeouts_accumulation = 0
                outfile.write('\n================== Date: ' + date_str + ' ===================')
                for instance_str, hour_dict in instance_dict.items():
                    outfile.write('\n==== Instance Id: ' + instance_str)
                    outfile.write('\nhour  #timeouts        #saved      #received    #recvd - #saved')
                    outfile.write('\n---------------------------------------------------------------')
                    daily_rcvd_per_instance = 0
                    daily_saved_per_instance = 0
                    daily_timeouts_per_instance = 0
                    for hour, hourly_dict in hour_dict.items():
                        hourly_saved = hourly_dict.get('saved', 0)
                        hourly_timeouts = hourly_dict.get('timeouts', 0)
                        hourly_received = hourly_dict.get('recvd', 0)
                        hourly_diff = hourly_received - hourly_saved

                        result_line = '\n' + str(hour).rjust(4) + str(hourly_timeouts).rjust(10) + str(hourly_saved).rjust(14) + str(hourly_received).rjust(16) + str(hourly_diff).rjust(16)
                        outfile.write(result_line)

                        daily_rcvd_per_instance += hourly_received
                        daily_saved_per_instance += hourly_saved
                        daily_timeouts_per_instance += hourly_timeouts

                    outfile.write('\n    Daily messages received: ' + str(daily_rcvd_per_instance))
                    outfile.write('\n    Daily messages successfully saved: ' + str(daily_saved_per_instance))
                    outfile.write('\n    Daily tcp timeouts: ' + str(daily_timeouts_per_instance) + '\n\n')

                    daily_rcvd_accumulation += daily_rcvd_per_instance
                    daily_saved_accumulation += daily_saved_per_instance
                    daily_timeouts_accumulation += daily_timeouts_per_instance

                total_rcvd += daily_rcvd_accumulation
                total_saved += daily_saved_accumulation
                total_timeouts +=daily_timeouts_accumulation

            outfile.write('\n* Total messages received (all instances): ' + str(total_rcvd))
            outfile.write('\n* Total messages successfully saved (all instances): ' + str(total_saved))
            outfile.write('\n* Total tcp timeouts (all instances): ' + str(total_timeouts) + '\n\n')

class ArjelHandsStatistics(ActionBase):
    def __init__(self, params:dict):
        super().__init__(params)
        self.__output_filename = params['output_filename']
        self.sent_pattern = params['sent_pattern']              ## messages sent to transport search pattern
        self.confirmed_pattern = params['confirmed_pattern']    ## successfully saved messages search pattern
        self.flush_pattern = params['flush_pattern']            ## dump files search pattern
        self.__results = dict()

    def __call__(self, params:dict):
        time_str = params['time_str']
        content = params['content']
        log_filename = params['log_filename']

        date_str = time_str[1:5] + time_str[6:8] + time_str[9:11]
        hour_str = str(time_str[12:14])
        filename = log_filename[0:-13]

        if date_str not in self.__results:
            self.__results.update({ date_str : {hour_str: { 'confirmed':0, 'sent':0, 'flush':0} } })

        if hour_str not in self.__results[date_str].keys():
            self.__results[date_str].update({ hour_str : { 'sent':0, 'confirmed':0, 'flush':0 } })

        results = self.__results[date_str][hour_str]
        if re.search(self.sent_pattern, content):
            increment(results, 'sent')

        if re.search(self.confirmed_pattern, content):
            increment(results, 'confirmed')

        if re.search(self.flush_pattern, content):
            increment(results, 'flush')

    def print_results(self):
        logger.debug(str(self.__results))
        self.__print_csv()
        #self.__print_txt()

    def __print_csv(self):
        total_sent = 0
        total_confirmed = 0
        total_flush = 0

        check_path(self.output_path)
        output_filename = self.output_path + self.__output_filename + '.csv'
        with open(output_filename, mode='a', encoding='utf8', errors='surrogateescape') as outfile:
            for date_str, hour_dict in self.__results.items():
                outfile.write('\n=== Date: ' + date_str)
                outfile.write('\nhour, #sent msg, #confirmed, #flush files, #sent - #confirmed')
                #outfile.write('\n---------------------------------------------------------------')
                daily_sent = 0
                daily_confirmed = 0
                daily_flush = 0
                for hour,hourly_data in hour_dict.items():
                    hourly_sent = hourly_data.get('sent', 0)
                    hourly_confirmed = hourly_data.get('confirmed', 0)
                    hourly_flush = hourly_data.get('flush', 0)
                    hourly_diff = hourly_sent - hourly_confirmed

                    result_line = '\n' + str(hour) + ',' + str(hourly_sent) + ',' + str(hourly_confirmed) +',' + str(hourly_flush) + ',' + str(hourly_diff)
                    outfile.write(result_line)
                    daily_sent += hourly_sent
                    daily_confirmed += hourly_confirmed
                    daily_flush += hourly_flush

                total_sent += daily_sent
                total_confirmed += daily_confirmed
                total_flush += daily_flush
                outfile.write('\nDaily messages sent: ' + str(daily_sent))
                outfile.write('\nDaily messages successfully saved: ' + str(daily_confirmed))
                outfile.write('\nDaily flush dump files: ' + str(daily_flush) + '\n\n')

            outfile.write('\n**Total messages sent: ' + str(total_sent))
            outfile.write('\n**Total messages successfully saved: ' + str(total_confirmed))
            outfile.write('\n**Total dumpfiles: ' + str(total_flush) + '\n\n')

    def __print_txt(self):
        total_sent = 0
        total_confirmed = 0
        total_flush = 0

        check_path(self.output_path)
        # { 'date':{'hour': {'confirmed':0, 'sent':0, 'flush':0} } }
        output_filename =  self.output_path + self.__output_filename + '.txt'
        with open(output_filename, mode='a', encoding='utf8', errors='surrogateescape') as outfile:
            for date_str, hour_dict in self.__results.items():
                outfile.write('\n======================= Date: ' + date_str + ' ========================')
                outfile.write('\nhour  #sent msg        #confirmed      #flush    #sent - #confirmed')
                outfile.write('\n---------------------------------------------------------------')
                daily_sent = 0
                daily_confirmed = 0
                daily_flush = 0
                for hour,hourly_data in hour_dict.items():
                    hourly_sent = hourly_data.get('sent', 0)
                    hourly_confirmed = hourly_data.get('confirmed', 0)
                    hourly_flush = hourly_data.get('flush', 0)
                    hourly_diff = hourly_sent - hourly_confirmed

                    result_line = str(hour).rjust(4) + str(hourly_sent).rjust(10) + str(hourly_confirmed).rjust(14) + str(hourly_flush).rjust(16) + str(hourly_diff).rjust(16)
                    outfile.write('\n' + result_line)
                    daily_sent += hourly_sent
                    daily_confirmed += hourly_confirmed
                    daily_flush += hourly_flush

                total_sent += daily_sent
                total_confirmed += daily_confirmed
                total_flush += daily_flush
                outfile.write('\n    Daily messages sent: ' + str(daily_sent))
                outfile.write('\n    Daily messages successfully saved: ' + str(daily_confirmed))
                outfile.write('\n    Daily flush dump files: ' + str(daily_flush) + '\n\n')

            outfile.write('\n* Total messages sent: ' + str(total_sent))
            outfile.write('\n* Total messages successfully saved: ' + str(total_confirmed))
            outfile.write('\n* Total dumpfiles: ' + str(total_flush) + '\n\n')



def collectStats(params:dict):
    #params = { 'env_name':'IOM', 'ip':'10.91.23.71', 'log_basename':'Default.arjelTransport', 'instance_id':1, 'date':startdate }
    #params = { 'log_basename':'Default.arjelTransport' }

    ''' arjel transports '''
    transportStats = [ TransportStatistics({'output_filename': str(__lday_first) + '_results.arjel_transport_stat.out',
                                            'output_path': os.getcwd() + '\\stats\\',
                                            'write_pattern':re.compile(r'Ewrite'),
                                            'timeout_pattern': re.compile(r'"Timeout"'),\
                                            'save_pattern': re.compile(r'Esave : \/SECRET\?eventId=') })
                      ]

    processor = ArjelLogProcessor({})
    processor.run({ 'log_object' : ArjelTransportLog({ 'log_basename':'Default.arjelTransport' }),
                    'env_name_list' : __environments,
                    'day_first' : __lday_first,
                    'day_last'  : __lday_last,
                    'instance_id' : 1,
                    'pattern' : re.compile(r'Ewrite : .*><\/\w+>|Timeout|Esave : \/SECRET\?eventId:'),
                    'result_filename_prefix' : 'results.arjel_transport_log',
                    'actions' : transportStats })

    ## print results
    for stat in transportStats:
        stat.print_results()

    ''' Arjelhands '''
    handsStats = [ ArjelHandsStatistics({'output_filename':str(__lday_first) + '_results.arjelhands_stat.out',
                                         'output_path':os.getcwd() + '\\stats\\',
                                         'sent_pattern':re.compile(r'saving:'),
                                         'confirmed_pattern':re.compile(r"saved: '\/SECRET\?eventId="),
                                         'flush_pattern':re.compile(r'ATTENTION: Wrote [0-9]* retry events') })
                 ]

    processor = ArjelLogProcessor({})
    processor.run({ 'log_object' : ArjelHandsLog({ 'log_basename':'ArjelHandsInstance' }),
                    'env_name_list' : __environments,
                    'day_first' : __lday_first,
                    'day_last'  : __lday_last,
                    'pattern' : re.compile(r"saving:|saved: '\/SECRET\?eventId:|ATTENTION: Wrote [0-9]* retry events"),
                    'result_filename_prefix' : 'results.arjelhands_log',
                    'actions' : handsStats })

    for stat in handsStats:
        stat.print_results()



''' main '''
if __name__ == '__main__':
    levels = ('DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL')
    script_name = 'log_processor.' + os.path.basename(__file__)
    ap = argparse.ArgumentParser(prog=script_name
                                , usage='%(prog)s [options]'
                                , description='create instance of server module with provided paramters'
                                , epilog='Usage: python main.py --env_name ["IOM"] --ip-address "10.91.23.71" --log_basename "Default.arjelTransport" --date_first 20221116 --date_last 20221201')

    ap.add_argument('--env_name',     type=list, dest='env_name_list', required=False, default=['IOM'], help='Environments to process logs - IOM|QA')
    ap.add_argument('--ip-address',   type=str, dest='ip',             required=False, default='', help='IP address of where logs were/are stored, format: 127.0.0.1')
    ap.add_argument('--log_basename', type=str, dest='log_basename',   required=False, default='',help='Log base filename')
    ap.add_argument('--date_first',   type=str, dest='date_first',     required=False, default='', help='First date to process')
    ap.add_argument('--date_last',    type=str, dest='date_last',      required=False, default='', help='Last date to process')
    ap.add_argument('--log_level',    dest='log_level',      required=False, default='INFO', choices=levels, help='log level: DEBUG|INFO|WARNING|ERROR|CRITICAL')
    args = ap.parse_args()

    logger = logging.getLogger('log_processor')
    logger.setLevel(args.log_level)

    sys.exit(collectStats( {} ))
#