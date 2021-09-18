#!/bin/bash

#Atualizar e instalar os pacotes necessários
sudo apt-get update -y
sudo apt-get install -y \
   apt-transport-https -y \
   ca-certificates -y \
   curl -y \
   gnupg -y \
   lsb-release -y \
   git -y

#Chave Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
 "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

#Instalar Docker
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y

#Instalar Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
docker-compose --version

#Instalar NetBox
mkdir -p ~/projects && cd projects
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

#Subir os conteiners 
echo Enjoy!!!

#Entrar no diretório
cd netbox-docker/

#Baixar os containers
docker-compose pull
#Subir os containers
docker-compose up

#Mensagem personalizada
echo Acessar o IP da máquina com a porta 8001
echo Username: admin
echo Password: admin


