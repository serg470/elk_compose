#!/bin/bash

ELK_VERSION=7.2.0
ELASTIC_DATA="/opt/data/elk/elasticsearch/data/"
KIBANA_DATA="/opt/data/elk/kibana/data/"

docker-compose down
#docker images -a | grep docker.elastic.co | awk '{print $3}' | xargs docker rmi

# If ENV fies not exist wipe all data and create new credentials
if [ ! -f .env ]; then
    echo "ENV file does not exist"
    touch .env
# Genereate New Password
    echo "ELASTIC_PASSWORD="`openssl rand -base64 21` > .env
    echo "ELK_VERSION="$ELK_VERSION >> .env
fi

PASSWD=`head -n 1 .env | grep "=" | cut -d'=' -f2`
# Configure Kibana
echo "Configure ELK"
sed -i '$d' ./kibana/config/kibana.yml
echo "elasticsearch.password:" $PASSWD >> ./kibana/config/kibana.yml
# Configure Logstash
sed -i '$d' ./logstash/config/logstash.yml
echo "xpack.monitoring.elasticsearch.password:" $PASSWD >> ./logstash/config/logstash.yml
sed -i "s/password.*/password => $PASSWD/g" ./logstash/pipeline/logstash.conf
# Wipe Data For Elasticsearch
rm -r $ELASTIC_DATA


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
touch /opt/elk/fb.conf
echo "output.elasticsearch:" > /opt/elk/fb.conf
echo " hosts: [\""$HOSTNAME".intertransl.com:9200\"]" >> /opt/elk/fb.conf
echo " username: \"elastic\"" >> /opt/elk/fb.conf
echo " password: "$(head -n 1 .env | grep "=" | cut -d'=' -f2) >> /opt/elk/fb.conf
echo "setup.kibana:" >> /opt/elk/fb.conf
echo " host: \""$HOSTNAME".intertransl.com:5601\"" >> /opt/elk/fb.conf
echo " space.id: \"linux-servers\"" >> /opt/elk/fb.conf
