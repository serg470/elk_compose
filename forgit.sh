#!/bin/bash

PASSWD=`head -n 1 .env | grep "=" | cut -d'=' -f2`
# Configure Kibana
echo "Configure ELK to git"
sed -i '$d' ./kibana/config/kibana.yml
echo "elasticsearch.password: changeme" >> ./kibana/config/kibana.yml
# Configure Logstash
sed -i '$d' ./logstash/config/logstash.yml
echo "xpack.monitoring.elasticsearch.password: changeme" >> ./logstash/config/logstash.yml
sed -i 's/password.*/password => changeme/g' ./logstash/pipeline/logstash.conf

git add .
git commit -m "Autocommit"
git push origin master


PASSWD=`head -n 1 .env | grep "=" | cut -d'=' -f2`
# Configure Kibana
echo "Configure ELK"
sed -i '$d' ./kibana/config/kibana.yml
echo "elasticsearch.password:" $PASSWD >> ./kibana/config/kibana.yml
# Configure Logstash
sed -i '$d' ./logstash/config/logstash.yml
echo "xpack.monitoring.elasticsearch.password:" $PASSWD >> ./logstash/config/logstash.yml
sed -i "s/password.*/password => $PASSWD/g" ./logstash/pipeline/logstash.conf