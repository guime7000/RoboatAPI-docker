import json
import os
import time
import logging

"""
Concatenates all complete Roboats positions files to have fleet history over the duration of the race

script ran via a crontab task

"""
logFilePath = '/home/tom/Api/Logs/fleetArchived.log'
logFormat = '%(asctime)s %(message)s'

logging.basicConfig(filename = logFilePath, encoding = 'utf-8',level=logging.INFO, format=logFormat)
archiveDirectoryPath = '/var/www/api/Archives/'

fleetList = ["groziboat",
                "axelair",
                "shapeshifters",
                "modiababord",
                "millesabords",
                "chatboatez",
                "echeneis",
                "totorson",
                "deepsink",
                "robotak"]

fleetDict = {}
fleetDict["lastConcatTs"] = int(time.time())

for inName in fleetList :
    archivePositionFile = os.path.join(archiveDirectoryPath,inName + '_Arch.JSON')

    with open(archivePositionFile, 'r') as outJsonFile:
        response = json.load(outJsonFile)
    
    fleetDict[inName]= response

with open(os.path.join(archiveDirectoryPath,'fleet_Arch.JSON'),'w') as fleetFile:
    json.dump(fleetDict,fleetFile,indent=2)

logging.info("Fleet correctly Archived")
