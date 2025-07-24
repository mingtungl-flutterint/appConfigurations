# main.py
import sys, datetime, argparse
from italy import collectStats
#from caon_Monthly_Highest_Revenue import collectStats

#######################################################################################################
#### Logging
#######################################################################################################
import logging, logging.config
from logging_config import *

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

    ap.add_argument('--env_name',     type=str, dest='env_name_list',  required=True, default='IOM', help='Environments to process logs - IOM|QA')
    ap.add_argument('--ip-address',   type=str, dest='ip',             required=True, default='', help='IP address of where logs were/are stored, format: 127.0.0.1')
    ap.add_argument('--log_basename', type=str, dest='log_basename',   required=True, default='',help='Log base filename')
    ap.add_argument('--date_first',   type=str, dest='date_first',     required=True, default='', help='First date to process')
    ap.add_argument('--date_last',    type=str, dest='date_last',      required=False, default='', help='Last date to process')
    ap.add_argument('--log_level',    type=str, dest='log_level',      required=False, default='INFO', choices=levels, help='log level: DEBUG|INFO|WARNING|ERROR|CRITICAL')
    args = ap.parse_args()

    ''' Instantiate logger object '''
    logging.config.dictConfig(LOGGING_CONFIG)
    logger = logging.getLogger('log_processor')
    logger.setLevel(args.log_level)
    
    print(args)

    sys.exit(collectStats( vars(args) ))
#
