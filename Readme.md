# What's this repo ?

Look at this repo and its files as an **exercise** to discover for the first time docker's ecosystem.

The aim of the exercise was to be set up a docker image to deploy the [fastAPI](https://github.com/guime7000/RoboatAPI) I wrote for the final race of [the Virtual Regatta IRoboat Challenge](https://www.virtualregatta.com/fr/deep-sea-the-iroboat-challenge/).

After following the entire setup stages you should be able to:
    - access a demo web page on port 8080 thanks to a httpd docker container
    - get the Roboat fastAPI working thanks to a fastapi docker container

#### Still on the TODO list :
    - setup a nginx reverse proxy container so that the containered services are correctly served..
    - let all config parameters being editable
    - explain the goal of the archive-fleet.py and concatenate_fleet.py files (in src/API_tools)

Written and built using ***debian 11*** with ***Docker version 20.10.22, build 3a2c30b*** and ***Docker Compose version v2.0.1***

#  Installation

1. Clone this repo

2. Edit src/Docker/.env following environments variables to fit your setup:

    - **HOST_DOMAIN_NAME** : the domain or ip address of the demo website (0.0.0.0 for local execution for eg.)

    - **UVICORN_PORT_NUMBER** : the port number to access your API (http://HOST_DOMAIN_NAME:UVICORN_PORT_NUMBER)
        
    - **HOST_APACHE_PORT** : The port to access the website page (host side) from outside

    - **CONTAINER_APACHE_PORT** : The port the httpd container vhost is listening to.…

    - **CONTAINER_WORKING_DIR** : The containers directory in which the roboatapi App will be stored

    - **HOST_DATA_PATH** : The path on the host where you want to save your boat positions files
        
    - **HOST_LOGS_PATH** : The path on the host where you want to save your log files

3. APIs Authentification config :

        edit the src/App/Secret/secret.JSON file (this is the file for API's POST method authentification) : as many "user":"password" couples as desired !
        
4. Boats positions files Directory and logs Directory setup :
   
         edit the src/API_tools/Apifilesystem/confifFile.JSON : fleetlist should reflect the user names of secret.JSON file. 
         
         !!! Be sure you keep a "fleet" user in the fleetlist field of configFile.JSON !!!
         
         boatFileDataStructure should not be edited until you 
         
 5. Make the install.sh bash script executable and....execute it ! 
         
         A Docker_image directory has been created. It contains all the files needed to build the image

6. ```
    cd Docker_image
    docker-compose up -d
    ```
7.  You should be able to access the demo website in your browser when typing ```HOST_DOMAIN_NAME:8080``` and access the API swagger page on ``` HOST_DOMAIN_NAME:UVICORN_PORT_NUMBER/docs```


 
 
