#Launch EC2 instance Amazon Linux 2023,t3 micro instance/ 8gb storage/subnet 1a/SG, allow protocols, 8080, 80 http
#sudo -s
#hostnamectl set-hostname jenkinsPC
#sudo -i
#yum update -y
#Step 1
dnf install ansible -y
ansible --version
dnf install python3 python3-pip -y
python3 --version
#ansible -m ping localhost

#Step 2  set root password in master and host machines [enable root login multi exec]
passwd root
set new password: admin123
## enable all server to login as root
vi /etc/ssh/sshd_config (40 & 65 uncomment both lines) #PermitRootLogin yes  #PasswordAuthentication yes
systemctl restart sshd
systemctl status sshd
hostname -i #to see the private ip address\ exit multi exec   
# Go to Ansible Master/Generate SSH Keys/ using this KEY Ansible server will communicate with worker nodes
ssh-keygen  #Enter Enter Enter
ls -l ~/.ssh/
ssh-copy-id root@private ip of prod-1 -- > yes -- > password -- > ssh private ip [login host]-- > ctrl d [to logout host]
ssh-copy-id root@private ip of prod-2 -- > yes -- > password -- > ssh private ip -- > ctrl d

#Step 3 Inventory File in Master
vi /etc/ansible/hosts
[prod]
172.31.41.124
172.31.36.71
#cat /etc/ansible/hosts
#ansible-inventory --list  
ansible -m ping all




