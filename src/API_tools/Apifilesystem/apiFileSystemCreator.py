import json
import os

configPath = os.getenv("PWD") + "/src/API_tools/Apifilesystem"

with open(os.path.join(configPath,'configFile.JSON'), 'r') as inputConfigFile :
    config = json.load(inputConfigFile)

dataFilesPath = os.getenv("HOST_DATA_PATH")
boatsDirectoryPath = os.path.join(dataFilesPath,"Boats/")
archiveDirectoryPath = os.path.join(dataFilesPath,"Archives/")

logsDirectoryPath = os.getenv("HOST_LOGS_PATH")

fleetList = config["fleetList"]
dico = config["boatFileDataStructure"]

dico = {"ts" : 0,
        "lat" : 0,
        "lon" : 0,
        "distanceToEnd" : 0,
        "rank" : 0,
        "speed" : 0,
        "tws" : 0,
        "twa" : 0,
        "heading": 0
        },

def boatsFilesCreator(inBoatName, fileExtension, inDirectoryPath):
    """
    Creates a inBoatName named directory and an inBoatname+fileExtension init file for each inBoatName

    fileExtension is :
        ".JSON" for boat position (in Boats Directory)
        "_Arch.JSON" for boat position Archive file in Archives Directory
    """
    boatPath = inDirectoryPath + inBoatName
    os.mkdir(boatPath)

    filePath = os.path.join(boatPath,inBoatName + fileExtension)

    with open(filePath,'w+') as outFile :
        json.dump([dico], outFile, indent=2)

## Create Data Directory 
tmpPath = dataFilesPath
os.mkdir(tmpPath)

## Create Boats Directory 
tmpPath = dataFilesPath + "/Boats/"
os.mkdir(tmpPath)
# Creates Position Files DIrectories and initial Boat Files
for boat in fleetList :
    boatsFilesCreator(boat,".JSON", boatsDirectoryPath)

## Create Archives Directory
tmpPath = dataFilesPath + "/Archives/"
os.mkdir(tmpPath)
# Creates Archives Files DIrectories and initial archives Files
for boat in fleetList :
    boatsFilesCreator(boat,"_Arch.JSON", archiveDirectoryPath)

## Create Logss Directory 
tmpPath = logsDirectoryPath
os.mkdir(tmpPath)
