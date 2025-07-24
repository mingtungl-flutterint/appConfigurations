''' IT '''
#import sys, argparse, time
from datetime import datetime
#import os, re
import csv

class ItUserPersonalDetails:
	def __init__(self, params:list):
		self.player = dict()
		self.player['userIntId'] = params[0].strip() # UINT32
		self.player['taxCode'] = params[1].strip() # PString
		self.player['gender'] = params[2].strip() # PString
		self.player['countryOfBirth'] = params[3].strip() # PString
		self.player['stateOfBirth'] = params[4].strip() # PString
		self.player['cityOfBirth'] = params[5].strip() # PString
		self.player['migrated'] = params[6].strip() # BYTE
		self.player['surname'] = params[7].strip() # PString
		self.player['dateOfBirth'] = datetime.strptime(params[8].strip(), "%Y-%m-%d").date() # SrvDate
		self.player['provinceOfResidence'] = params[9].strip() # PString
		self.player['email'] = params[10].strip() # PString
		self.player['name'] = params[11].strip() # PString
		self.player['userId'] = params[12].strip() # PString
		self.player['ADMStatus'] = params[13].strip() # PString
		self.player['SRMStatus'] = params[14].strip() # BYTE
		self.player['isRMOK'] = params[15].strip() # BYTE
		self.player['isAv'] = params[16].strip() # BYTE
		self.player['isAuth'] = params[17].strip() # BYTE
		self.player['isBanned'] = params[18].strip() # BYTE
		self.player['isBannedByReg'] = params[19].strip() # BYTE
		self.player['isSelfExcluded'] = params[20].strip() # BYTE
		self.player['lastLogin'] = datetime.strptime("1990-1-1 0:0:0", "%Y-%m-%d %H:%M:%S") # SrvTime
		self.player['whenRMOK'] = datetime.strptime(params[22].strip(), "%Y-%m-%d %H:%M:%S") # SrvTime
		if len(params[21]) > 1:
			self.player['lastLogin'] = datetime.strptime(params[21].strip(), "%Y-%m-%d %H:%M:%S") # SrvTime

	def printPlayer(self):
		print(self.player)

	def __str__(self):
		out = (str(self.player['userIntId']) + ", " +
            str(self.player['taxCode']) + ", " +
            str(self.player['gender']) + ", " +
            str(self.player['countryOfBirth']) + ", " +
            str(self.player['stateOfBirth']) + ", " +
            str(self.player['cityOfBirth']) + ", " +
            str(self.player['migrated']) + ", " +
            str(self.player['surname']) + ", " +
            str(self.player['dateOfBirth']) + ", " +
            str(self.player['provinceOfResidence']) + ", " +
            str(self.player['email']) + ", " +
            str(self.player['name']) + ", " +
            str(self.player['userId']) + ", " +
            str(self.player['ADMStatus']) + ", " +
            str(self.player['SRMStatus']) + ", " +
            str(self.player['isRMOK']) + ", " +
            str(self.player['isAv']) + ", " +
            str(self.player['isAuth']) + ", " +
            str(self.player['isBanned']) + ", " +
            str(self.player['isBannedByReg']) + ", " +
            str(self.player['isSelfExcluded']) + ", " +
            str(self.player['lastLogin']) + ", " +
            str(self.player['whenRMOK']))
		return out

if __name__ == '__main__':
	filename = 'Personal_data_of_players_test.csv'
	psdata = []
	with open(filename, mode='r') as pscsv:
		# Skips the heading: use next() method
		header = next(pscsv)
		print(header)

		# Create reader object by passing the file
		# object to reader method
		psreader = csv.reader(pscsv)

		# Iterate over each row in the csv file
		# using reader object
		psdata = [ItUserPersonalDetails(row) for row in psreader]

	for e in psdata:
		#print(f'{str(e)}')
		e.printPlayer()

