#!/usr/bin/env bash

#Atualizar e instalar os pacotes necessários
 apt update -y
 apt upgrade -y

# Add Docker's official GPG key:
 apt-get install ca-certificates curl
 install -m 0755 -d /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
 chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
   tee /etc/apt/sources.list.d/docker.list > /dev/null
 apt-get update

 apt-get install -y \
   apt-transport-https -y \
   ca-certificates -y \
   containerd.io -y \
   curl -y \
   docker-buildx-plugin -y \
   docker-ce -y \
   docker-ce-cli -y \
   docker-compose-plugin -y \
   git -y \
   gnupg -y \
   lsb-release -y \


#Validação da instalação do docker
 docker --version
 docker run hello-world

#Instalar NetBox
mkdir -p ~/projects && cd ~/projects
git clone -b release https://github.com/netbox-community/netbox-docker.git
cd netbox-docker

#Criar o composer override yml definindo versão e porta de acesso
tee docker-compose.override.yml <<EOF
services:
  netbox:
    ports:
      - 8000:8080
EOF

#Baixar os containers
docker compose pull
#Subir os containers
docker compose up -d

#Rotina de inicialização dos containers junto ao sistema
docker update --restart always netbox-docker-netbox_1 netbox-docker-postgres_1 netbox-docker-redis-cache_1 netbox-docker-netbox-worker_1 netbox-docker-redis_1

#Criar usuário
docker compose exec netbox /opt/netbox/netbox/manage.py createsuperuser                           

#Baixar conteiner com os Device type lib
docker pull ghcr.io/minitriga/netbox-device-type-library-import

#Mensagem personalizada
echo Acessar o IP da máquina com a porta 8000
echo Username: admin
echo Password: Definido anteriormente
echo Enjoy!!!

echo "Executar o seguinte comando substituindo a URL e o API Token"
echo "docker run -e "NETBOX_URL=http://netbox:8000/" -e "NETBOX_TOKEN=98765434567890" ghcr.io/minitriga/netbox-device-type-library-import"

