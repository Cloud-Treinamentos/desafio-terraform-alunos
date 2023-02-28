#!/bin/bash
sleep 2m
### FAZER UPDATE ###
sudo apt update -y
### INSTALAR O GIT LAB ###
sudo apt install git -y
### PACOTES NECESSARIOS PARA O EFS ###
sudo apt-get -y install binutils
git clone https://github.com/aws/efs-utils
cd efs-utils/
./build-deb.sh
sudo apt-get -y install ./build/amazon-efs-utils*deb
### CRIAR PASTA A SER MONTADA NO EFS ###
sudo mkdir /efs
### INSTALAR O DOCKER ###
sudo apt-get install docker.io -y
### COLOCAR USUARIO UBUNTU NO GRUPO DOCKER ###
sudo usermod -aG docker ubuntu
### INICIAR O SERVIÇO DO DOCKER ###
sudo service docker start
### BAIXAR O DOCKER-COMPOSE ###
sudo curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null
### DAR PERMISSAO DE EXECUÇÃO ###
sudo chmod +x /usr/local/bin/docker-compose
### CRIAR LINK SIMBOLICO ###
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
### COLOCAR USUARIO UBUNTU NO GRUPO DOCKER-COMPOSE ###
sudo usermod -a -G docker-compose ubuntu
### MONTAR O EFS ###
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_id}:/  /efs
### TORNAR A MONTAGEM PERMANENTE ESCREVENDO NO FSTAB ###
echo "${efs_id}:/ /efs nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport,_netdev 0 0"  | sudo cat >> /etc/fstab
### GARANTIR A MONTAGEM DO EFS ###
sleep 2m
sudo mount -a
### CRIAR AS PASTAS DO BANCO E DO WORDPRESS DENTRO DO EFS JA MONTADO ###
sudo mkdir /efs/db /efs/wordpress
### DAR PERMISSAO DE LEITURA E ESCRITA NO PONTO DE MONTAGEM ###
sudo chmod -R go+rw /efs
### BAIXAR OS ARQUIVOS DO GIT LAB E COLOCAR DENTRO DO EFS ###
cd /efs/
sudo git clone https://gitlab.com/m46nu5alexandre/wordpress-arq.git
### RODAR SCRIPT QUE GERA CERTIFICADO LETS ENCRIPTY TEMPORARIOS ###
cd /efs/wordpress-arq/
#sudo chmod +x init-letsencrypt.sh
#./init-letsencrypt.sh
### RODAR O DOCKER-COMPOSE ###
sudo docker-compose -f /efs/wordpress-arq/docker-compose.yml up --build -d