#!/bin/bash

#Atualizar e instalar os pacotes necessários
sudo apt-get update -y
sudo apt-get install -y \
   apt-transport-https -y \
   ca-certificates -y \
   curl -y \
   gnupg -y \
   lsb-release -y \
   git -y \



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

#Baixar os containers
docker-compose pull
#Subir os containers
docker-compose up -d

#Rotina de inicialização dos containers junto ao sistema
docker update --restart always netbox-docker_netbox_1 netbox-docker_postgres_1 netbox-docker_redis-cache_1 netbox-docker_netbox-worker_1 netbox-docker_redis_1

#Alteração de parametros de configuracao
#sed -e "s/^LOGIN_REQUIRED = environ.get('LOGIN_REQUIRED', 'False').lower() == 'true' .*/LOGIN_REQUIRED = True/g" \
#-e "s/^'LOGIN_TIMEOUT = int(environ.get('LOGIN_TIMEOUT', 1209600)) .*/LOGIN_TIMEOUT, 86400/g" \
#-e "s/^TIME_ZONE = environ.get('TIME_ZONE', 'UTC') .*/TIME_ZONE = 'America/Manaus'/g" \
#-e "s/^DATE_FORMAT = environ.get('DATE_FORMAT', 'N j, Y') .*/DATE_FORMAT = 'j N, Y'/g" \
#-e "s/^SHORT_DATE_FORMAT = environ.get('SHORT_DATE_FORMAT', 'Y-m-d') .*/SHORT_DATE_FORMAT = 'd/m/Y'/g" \
#-e "s/^TIME_FORMAT = environ.get('TIME_FORMAT', 'g:i a') .*/TIME_FORMAT = 'H:i'/g" \
#-e "s/^DATETIME_FORMAT = environ.get('DATETIME_FORMAT', 'N j, Y g:i a') .*/DATETIME_FORMAT = 'H:i - j/N/Y'/g" \
#-e "s:^;SHORT_DATETIME_FORMAT = environ.get('SHORT_DATETIME_FORMAT', 'Y-m-d H:i').*:SHORT_DATETIME_FORMAT = 'd-m-Y H:i':g" \
#-i /root/projects/netbox-docker/configuration/configuration.py


#Mensagem personalizada
echo Acessar o IP da máquina com a porta 8000
echo Username: admin
echo Password: admin
echo Enjoy!!!


