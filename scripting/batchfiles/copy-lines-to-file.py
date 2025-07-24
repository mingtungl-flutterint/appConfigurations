# $Id copy-lines-to-file.py
# Search input file, infilename, line-by-line for pattern, pat1, and write lines from line contained pat1
# to line contained pat2 or end of file to new file, oufilename

import time, sys, argparse

####
def doCopy(infilename:str, oufilename: str, pat1:str, pat2:str):
    start = False
    end = False
    with open(infilename, 'r') as infp:
        oufp = open(oufilename, 'w')
        for line in infp:
            if pat1 in line:
                start = True
            if pat2 in line:
                end = True
            if start == True:
                oufp.write(line)
            if end == True:
                break
    infp.close()
    oufp.close()

####
####
if __name__ == "__main__":
    parser = argparse.ArgumentParser(prog='copy-lines-to-file'
                                , usage='%(prog)s [options]'
                                , description='Read lines from file and write to output file'
                                , epilog='Usage: [-i|--infilename <inout filename>] [-o|--oufilename <output filename>]')

    if len(sys.argv) < 4:
        parser.print_help()

    parser.add_argument('-i', '--infilename', type=str, dest="ifname", required=True, default='', help='input filename')
    parser.add_argument('-o', '--oufilename', type=str, dest="ofname", required=True, default='', help='output filename')
    parser.add_argument('-1', '--pattern1', type=str, dest="pat1", required=True, default='', help='start pattern to match')
    parser.add_argument('-2', '--pattern2', type=str, dest="pat2", required=True, default='', help='end pattern to match')
    args = parser.parse_args()

    doCopy(args.ifname, args.ofname, args.pat1, args.pat2)

    sys.exit(0)
