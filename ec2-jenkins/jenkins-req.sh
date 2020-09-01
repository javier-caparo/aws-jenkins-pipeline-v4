#!/bin/bash

set -e

# Output colours
COL='\033[1;34m'
NOC='\033[0m'

echo -e "$COL>Installing aws , eksctl, kubectl,jenkins & docker version...$NOC"

echo -e "$COL>Check java version...$NOC"
java -version

echo -e "$COL># Installing NodeJS...$NOC"
curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
sudo apt install -y nodejs
sudo apt install -y build-essential
echo -e "$COL># NodeJS installed ...$NOC"

echo -e "$COL># Installing hadolint...$NOC"
sudo wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v1.18.0/hadolint-Linux-x86_64 
sudo chmod +x /bin/hadolint
echo -e "$COL># hadolint installed ...$NOC"

echo -e "$COL># Installing awscli v2...$NOC"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sleep 2
echo -e "$COL># awscli v2 installed ...$NOC"

echo -e "$COL># Installing eksctl...$NOC"
sudo curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
which eksctl
sleep 2
echo -e "$COL># eksctl installed ...$NOC"

echo -e "$COL># installing kubectl...$NOC"
sudo curl --silent -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.17.9/2020-08-04/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bash_profile
sleep 2
echo -e "$COL># kubectl installed ...$NOC"

echo -e "$COL>#Installing Jenkins$NOC"
sudo apt update -y
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
/etc/apt/sources.list.d/jenkins.list'
sudo apt update -y
sudo apt install -y jenkins
sudo usermod -aG root jenkins
sudo systemctl enable jenkins
sleep 5
echo -e "$COL># jenkins installed ...$NOC"

echo -e "$COL># Installing docker$NOC"
sudo apt update -y
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update -y
apt-cache policy docker-ce
sudo apt install -y docker-ce
sudo usermod -aG docker ubuntu
sudo usermod -aG docker jenkins
sleep 3
echo -e "$COL># docker installed ...$NOC"

echo -e "$COL># fixing docker errors with permissions$NOC"
newgrp docker
sudo usermod -aG docker ubuntu
sudo usermod -aG docker jenkins
echo -e "$COL># docker fixed permissions issue!!$NOC"

echo -e "$COL>Installation finished$NOC"
echo -e "$COL>Dont forget start jenkins and docker$NOC"
sudo systemctl restart jenkins
sudo systemctl restart docker

echo -e "$COL>Jenkins initial admin password$NOC"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

echo -e "$COL>Installation finished$NOC"