#Launch EC2 instance Amazon Linux 2023,t3 small instance/ 15gb storage/subnet 1a/SG, allow protocols, 8080, 80 http
#sudo -s
#hostnamectl set-hostname jenkinsPC
#sudo -i
#yum update -y
#vi Jenkins.sh
#--------------------------------------------------------------------
##!/bin/bash
#STEP-1: Installing Git and Maven
yum install git maven -y
git -v
#STEP-2: Repo Information (jenkins.io --> download -- > redhat)
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
#STEP-3: Download Java 21 and Jenkins
sudo yum install java-21-amazon-corretto -y
java --version
yum install jenkins -y
jenkins --version
sudo mount -o remount,size=2G /tmp
df -h
#STEP-4: Start and check the JENKINS Status
systemctl start jenkins.service
systemctl status jenkins.service
#----------------------------------------------------------------------
#CTRL+Q - Copy paste instace public IP in browser with port
#cat /var/lib/jenkins/secrets/initialAdminPassword-->password---Install Suggested Plugins--un-amith pw-amith@123
#STEP-5: Auto-Start Jenkins after server reboot
chkconfig jenkins on
# sudo systemctl enable jenkins
