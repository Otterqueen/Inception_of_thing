echo "toto"

sudo systemctl disable firewalld
sudo systemctl stop firewalld

sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*


curl -sfL https://get.k3s.io | sh -s - agent --server https://192.168.42.110:6443 --token-file=/vagrant/token --flannel-iface=eth1

sudo dnf install net-tools -y