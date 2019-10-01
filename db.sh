#!/bin/bash

# Docker
curl -X POST "http://localhost:5601/api/spaces/space" -u elastic:$(head -n 1 .env | grep "=" | cut -d'=' -f2) -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d '{"id": "docker","name": "Docker and Nginx metrics","description" : "Docker and Nginx metrics (Extroxy, Proxy, Hetzner (only NGINX))","color": "#461a0a","initials": "DN"}'
# Linux Server
curl -X POST "http://localhost:5601/api/spaces/space" -u elastic:$(head -n 1 .env | grep "=" | cut -d'=' -f2) -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d '{"id": "linux-servers","name": "Linux Servers","description" : "Syslogs and Nginx Logs (Extproxy, Hetzner, Proxy)","color": "#f98510","initials": "LS"}'
# Samba Audit (Logstash)
curl -X POST "http://localhost:5601/api/spaces/space" -u elastic:$(head -n 1 .env | grep "=" | cut -d'=' -f2) -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d '{"id": "samba-audit","name": "Samba Audit","description" : "Samba Audit (Backup and Mario)","color": "#490092","initials": "SA"}'
# System Logs
curl -X POST "http://localhost:5601/api/spaces/space" -u elastic:$(head -n 1 .env | grep "=" | cut -d'=' -f2) -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d '{"id": "new-space","name": "Syslog","description" : "Syslogs for Mario and Backup","color": "#490092","initials": "S"}'
# Windows Logs
curl -X POST "http://localhost:5601/api/spaces/space" -u elastic:$(head -n 1 .env | grep "=" | cut -d'=' -f2) -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d '{"id": "windows-server","name": "Windows Server","description" : "All windows metrics","color": "#bfa180","initials": "WS"}'
# All Logs (Default Space)
curl -X PUT "http://localhost:5601/api/spaces/space/default" -u elastic:$(head -n 1 .env | grep "=" | cut -d'=' -f2) -H 'kbn-xsrf: true' -H 'Content-Type: application/json' -d '{"id": "default", "name": "Absolutly All Logs", "description" : "This is your default space!", "color": "#00bfb3", "initials": "AA"}'
