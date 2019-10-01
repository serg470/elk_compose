#!/bin/bash

ELK_VERSION=7.3.2
ELASTIC_DATA="/opt/data/elk/elasticsearch/data/"
KIBANA_DATA="/opt/data/elk/kibana/data/"

docker-compose down
#docker images -a | grep docker.elastic.co | awk '{print $3}' | xargs docker rmi

read -p "Dou you want to autogenerate password? (Y/N): " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
    then
    if [ ! -f .env ]; then
	# If ENV fies not exist wipe all data and create new credentials
	echo "ENV file does not exist"
	touch .env
	# Genereate New Password
	echo "ELASTIC_PASSWORD="`date +%s | sha256sum | base64 | head -c 21 ; echo` > .env
	echo "ELK_VERSION="$ELK_VERSION >> .env
	# Wipe Data For Elasticsearch
	rm -r $ELASTIC_DATA
    else
	echo "Password alredy generated"
    fi
else
    if [ ! -f .env ]; then
	read -p "Enter new password: " password
	echo "ELASTIC_PASSWORD="$password > .env
	echo "ELK_VERSION="$ELK_VERSION >> .env
	echo $password
	# Wipe Data For Elasticsearch
	rm -r $ELASTIC_DATA
    else
	echo "Password alredy generated"
    fi
fi

# If ENV fies not exist wipe all data and create new credentials

PASSWD=`head -n 1 .env | grep "=" | cut -d'=' -f2`
# Configure Kibana
echo "Configure ELK"
sed -i '$d' ./kibana/config/kibana.yml
echo "elasticsearch.password:" $PASSWD >> ./kibana/config/kibana.yml
# Configure Logstash
sed -i '$d' ./logstash/config/logstash.yml
echo "xpack.monitoring.elasticsearch.password:" $PASSWD >> ./logstash/config/logstash.yml
sed -i "s/password.*/password => $PASSWD/g" ./logstash/pipeline/logstash.conf


# Check Data Folder and Create If Not Exist
if [ ! -d $ELASTIC_DATA ]; then
    mkdir -p $ELASTIC_DATA
    chmod 777 $ELASTIC_DATA
fi

# Check Data Folder and Create If Not Exist
if [ ! -d $KIBANA_DATA ]; then
    mkdir -p $KIBANA_DATA
    chmod 777 $KIBANA_DATA
fi


docker-compose up -d

# Generate Filebeat config
touch fb.conf
echo "output.elasticsearch:" > fb.conf
echo " hosts: [\""$HOSTNAME".intertransl.com:9200\"]" >> fb.conf
echo " username: \"elastic\"" >> fb.conf
echo " password: "$(head -n 1 .env | grep "=" | cut -d'=' -f2) >> fb.conf
echo "setup.kibana:" >> fb.conf
echo " host: \""$HOSTNAME".intertransl.com:5601\"" >> fb.conf
echo " space.id: \"linux-servers\"" >> fb.conf
