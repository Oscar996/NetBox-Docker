#!/bin/bash

#Atualizar e instalar os pacotes necessários
sudo apt update -y
sudo apt upgrade -y
sudo apt-get install -y \
   apt-transport-https -y \
   ca-certificates -y \
   curl -y \
   gnupg -y \
   lsb-release -y \
   git -y \
   docker -y \
   docker-compose -y \

#Validação da instalação do docker
sudo docker --version
sudo docker-compose --version

#Instalar NetBox
mkdir -p ~/projects && cd ~/projects
git clone -b release https://github.com/netbox-community/netbox-docker.git
cd netbox-docker

#Criar o composer override yml definindo versão e porta de acesso
tee docker-compose.override.yml <<EOF
version: '3.4'
services:
  netbox:
    ports:
      - 8000:8080
EOF

#Baixar os containers
docker-compose pull
#Subir os containers
docker-compose up -d

#Rotina de inicialização dos containers junto ao sistema
docker update --restart always netbox-docker_netbox_1 netbox-docker_postgres_1 netbox-docker_redis-cache_1 netbox-docker_netbox-worker_1 netbox-docker_redis_1

#Criar usuário
docker-compose exec netbox /opt/netbox/netbox/manage.py createsuperuser                           

#Mensagem personalizada
echo Acessar o IP da máquina com a porta 8000
echo Username: admin
echo Password: Definido anteriormente
echo Enjoy!!!
