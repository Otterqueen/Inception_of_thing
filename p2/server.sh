echo "toto"

sudo systemctl disable firewalld
sudo systemctl stop firewalld

sudo sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

curl -sfL https://get.k3s.io | sh -s - server --flannel-iface=eth1 --write-kubeconfig-mode "0644"

sudo dnf install net-tools -y

echo 'alias k="kubectl"' >> /home/vagrant/.bashrc


/usr/local/bin/kubectl apply -Rf /vagrant/manifests/app1
/usr/local/bin/kubectl apply -Rf /vagrant/manifests/app2
/usr/local/bin/kubectl apply -Rf /vagrant/manifests/app3