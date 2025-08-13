#!/bin/bash
apt-get update -y
apt-get upgrade -y
apt-get install -y docker.io docker-compose git
cd /home/ubuntu
git clone https://github.com/DefectDojo/django-DefectDojo.git
cd django-DefectDojo
docker-compose up -d
