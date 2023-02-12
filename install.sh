#!/bin/bash

# Sets environment variables for fastAPI and apache containers config

# source setenv.sh
# Show env vars
 grep -v '^#' ./src/Docker/.env

# Export env vars
export $(grep -v '^#' ./src/Docker/.env | xargs)

if [ ! -d "./Docker_image" ] ; then
    mkdir ./Docker_image
    echo "tmp directory created"
fi

####################### APACHE container config ############################

######### Directory existence check and creation ################
if [ ! -d "./Docker_image/html" ] ; then
    echo "./Docker_image/html does NOT exist"
    mkdir ./Docker_image/html
    echo "./Docker_image/html directory created"
fi

if [ ! -d "./Docker_image/Apache_conf" ] ; then
    echo "./Docker_image/Apache_conf does NOT exist"
    mkdir ./Docker_image/Apache_conf
    echo "./Docker_image/Apache_conf directory created"
fi
##############################################

# Copies website's config source files to html Directory 
cp -R ./src/Apache/css ./Docker_image/html
cp -R ./src/Apache/Image ./Docker_image/html
echo "Websites CSS and Image directories copied from ./src/Apache/Image to ./Docker_image/html"

# If old index.html exists, removes it before creating a new one !
websiteIndexFile="./Docker_image/html/index.html"
if [ -f "$websiteIndexFile" ] ; then
    echo "Found old index.html in ./Docker_image/html, removing it !"
    rm -f "$websiteIndexFile"
    echo "Removed old index.html"
fi
# Creates website's index.html by replacing env_names_patterns by desired environment variables values before apache container build
sed 's@HOST_DOMAIN_NAME@'${HOST_DOMAIN_NAME}'@;s@UVICORN_PORT_NUMBER@'${UVICORN_PORT_NUMBER}'@' ./src/Apache/index_source.html >> $websiteIndexFile
echo "Created new index.html in ./Docker_image/html"

# If old virtualhosts.conf file exists, removes it before creating a new one !
virtualhostConfFile="./Docker_image/Apache_conf/${HOST_DOMAIN_NAME}.conf"
if [ -f "$virtualhostConfFile" ] ; then
    echo "Found old ${HOST_DOMAIN_NAME}.conf file in ./Docker_image/Apache_conf, removing it !"
    rm -f "$virtualhostConfFile"
    echo "Removed old ${HOST_DOMAIN_NAME}.conf"
fi
# Creates virtualhosts file config by replacing env_names_patterns by desired environment variables values before apache container build
sed 's@UVICORN_HOST_URL@'${HOST_DOMAIN_NAME}'@;s@APACHE_ROOT_DIRECTORY@'${VHOST_ROOT_DIRECTORY}'@' ./src/Apache/virtualhost_source.conf >> $virtualhostConfFile
echo "Created new ${HOST_DOMAIN_NAME}.conf in ./Docker_image/Apache_conf"

cp ./src/Apache/my-httpd.conf ./Docker_image/Apache_conf/

echo "####### End of Apache container config ############"
#################################

########### Roboat API files copy ###########################
cp -R ./src/App ./Docker_image/${CONTAINER_WORKING_DIR}
# cp -R ./src/App ./Docker_image/App

# Creation of data and log Directory structure on Host
#mkdir ${HOST_DATA_PATH}
#mkdir ${HOST_LOGS_PATH}
python3 ${PWD}/src/API_tools/Apifilesystem/apiFileSystemCreator.py

# cp -R ${HOST_DATA_PATH} ./Docker_image/App/Data
# cp -R ${HOST_LOGS_PATH} ./Docker_image/App/Logs

cp -R ${HOST_DATA_PATH} ./Docker_image/${CONTAINER_WORKING_DIR}/Data
cp -R ${HOST_LOGS_PATH} ./Docker_image/${CONTAINER_WORKING_DIR}/Logs


################################# Generating all requested files for Docker-compose ###########################

# Creates a Dockerfile_apache file with the right virtualhost conf file name
DockerFileApache="./Docker_image/Dockerfile_apache"
if [ -f "$DockerFileApache" ] ; then
    echo "Found old Dockerfile_apache file in ./Docker_image, removing it !"
    rm -f "$DockerFileApache"
    echo "Removed old Dockerfile_apache"
fi
sed 's@_VHOST_ROOT_DIRECTORY_@'${VHOST_ROOT_DIRECTORY}'@;s@_WEBSITE_CONF_FILENAME_@'${HOST_DOMAIN_NAME}.conf'@;s@_Apache_Conf_DIRECTORY_@'${APACHE_CONF_DIRECTORY}'@;s@_WEBSITE_CONF_FILENAME2_@'${HOST_DOMAIN_NAME}.conf'@' ./src/Docker/Dockerfile_apache_source >> ./Docker_image/Dockerfile_apache
echo "Created new file Dockerfile_apache for httpd image in ./Docker_image/"

cp ./src/Docker/.env ./Docker_image/

DockerFileRoboatapi="./Docker_image/Dockerfile_roboatapi"
if [ -f "$DockerFileRoboatapi" ] ; then
    echo "Found old Dockerfile_roboatapi file in ./Docker_image, removing it !"
    rm -f "$DockerFileRoboatapi"
    echo "Removed old Dockerfile_roboatapi"
fi
sed 's@_CONTAINER_WORKING_DIR_@'${CONTAINER_WORKING_DIR}'@;s@_CONTAINER_WORKING_DIR2_@'${CONTAINER_WORKING_DIR}'@' ./src/Docker/Dockerfile_roboatapi_source >> ./Docker_image/Dockerfile_roboatapi
# cp ./src/Docker/Dockerfile_roboatapi_source ./Docker_image/Dockerfile_roboatapi


cp ./src/Docker/requirements.txt ./Docker_image/requirements.txt



cp ./src/Docker/docker-compose_source.yml ./Docker_image/docker-compose.yml
echo "HTTPD image build files READY !"









