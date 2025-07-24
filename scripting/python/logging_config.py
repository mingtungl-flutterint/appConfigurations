''' logging_config.py '''
import os, time
import logging, logging.config


#######################################################################################################
#### Logging configurations
#######################################################################################################
def get_rotating_file_handler(filename:str, mode, maxBytes, backupCount=0, encoding=str):
    #filename = os.getcwd() + '\\logs\\' + time.strftime("%Y%m%d") + '_' + filename
    filename = time.strftime("%Y%m%d") + '_' + filename
    if not os.path.exists(filename):
        open(filename, mode).close()
    return logging.handlers.RotatingFileHandler(filename, mode, maxBytes, backupCount,encoding)

def get_file_handler(filename:str, mode='a', encoding=str):
    #filename = os.getcwd() + '\\logs\\' + time.strftime("%Y%m%d") + '_' + filename
    filename = time.strftime("%Y%m%d") + '_' + filename
    if not os.path.exists(filename):
        open(filename, mode).close()
    return logging.FileHandler(filename, mode, encoding)

LOGGING_CONFIG = {
    'version' : 1,
    'disable_existing_loggers': False,
    'formatters': {
        'file_fmt': {
            'class': 'logging.Formatter',
            'format': '%(asctime)s|[%(levelname)s]|%(name)s|%(module)s.%(funcName)s (%(lineno)04d) | %(message)s'
        },
        'default_fmt': {
            'class': 'logging.Formatter',
            'format': '%(asctime)s|[%(levelname)s]|%(module)s.%(funcName)s (%(lineno)04d) | %(message)s'
        },
    },
    'handlers': {
        'default_handler': {
            'level': 'ERROR',
            'formatter': 'default_fmt',
            'class': 'logging.StreamHandler',
            'stream': 'ext://sys.stderr',
        },
        'info_handler': {
            'level': 'INFO',
            'formatter': 'default_fmt',
            'class': 'logging.StreamHandler',
            'stream': 'ext://sys.stdout',
        },
        'rotating_file_handler': {
            'level': 'DEBUG',
            'formatter': 'file_fmt',
            '()': get_rotating_file_handler,
            # The values below are passed to the handler creator callable, rotating_file_handler
            'filename': 'log_processor.log',
            'mode': 'a',
            'encoding': 'utf-8',
            'maxBytes': 52428800, # file size = 50MB
            'backupCount': 20,
        }
    },
    'loggers': {
        '': { # root logger
            'handlers': ['default_handler'],
            'level': 'DEBUG',
            'propagate': False
        },
        'log_processor': {
            'handlers': ['rotating_file_handler', 'info_handler'],
            'level': 'DEBUG',
            'propagate': False
        },
        'log_processor.arjel': {
            'handlers': ['rotating_file_handler', 'info_handler'],
            'level': 'DEBUG',
            'propagate': False
        },
    }
}


