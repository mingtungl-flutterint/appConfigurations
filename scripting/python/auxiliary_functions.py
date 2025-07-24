''' auxilliary_functions.py '''

import datetime
import os
import re


#######################################################################################################
### Auxiliary functions
#######################################################################################################
def remove_file(filename):
    if os.path.exists(filename):
        os.remove(filename)
#

def exec(cmdline):
    #print(cmdline)
    os.system(cmdline)
#

def unzip_file(zipped_filename):
    cmdline = "7z e -y " + zipped_filename
    exec(cmdline)
#

def u2d(filename):
    tempfilename = filename + ".tmp"
    remove_file(tempfilename)
    cmdline = "gawk \'sub(\"$\", \"\\r\")\' " + filename + " > " + tempfilename
    exec(cmdline)
    remove_file(filename)
    os.rename(tempfilename, filename)
#

def str_replace_params(line, params):
    result = line
    for k, v in params.items():
        result = result.replace("${" + k + "}$", str(v))
    return result
#

def lday_to_date(lday_date):
    year = lday_date // 10000
    month = (lday_date % 10000) // 100
    day = lday_date % 100
    return datetime.date(year, month, day)
#

def make_date_list(lday_first:int, lday_last:int):  # both inclusive
    # sanity check
    if lday_first > lday_last:
        raise 'make_date_list: day_last < day_first'
    date_first = lday_to_date(lday_first)
    date_last = lday_to_date(lday_last)
    date_list = []
    for n in range(0, 300):
        date = date_first + datetime.timedelta(days=n)
        if date > date_last:
            break
        date_list.append(date)
    return date_list
#

def check_path(path:str):
    if len(path)>0 and not os.path.exists(path):
        os.mkdir(path)
        print("Directory '%s' created" %path)
#

def increment(dict_obj:dict, prop_name:str):
    dict_obj[prop_name] = dict_obj.get(prop_name, 0) + 1
#

def accumulate(dict_obj:dict, prop_name:str, delta):
    dict_obj[prop_name] = dict_obj.get(prop_name, 0) + delta
#

def is_match(pattern:re, line:str):
    if re.search(pattern, line) != None:
        return True
    return False
#

