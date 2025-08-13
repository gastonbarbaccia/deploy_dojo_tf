#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

apt-get update -y
apt-get upgrade -y
apt-get install -y docker.io docker-compose git

systemctl enable docker
systemctl start docker

cd /home/ubuntu

# Clonar como usuario ubuntu para evitar problemas de permisos
sudo -u ubuntu git clone https://github.com/DefectDojo/django-DefectDojo.git

cd django-DefectDojo

# Ejecutar docker-compose como usuario ubuntu
sudo -u ubuntu docker-compose up -d
