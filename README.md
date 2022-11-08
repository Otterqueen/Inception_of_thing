<h1 align="center">
Inception_of_thing
</h1>

Ce projet a pour but de vous faire découvrir kubernetes d'un point de vue développeur. Vous allez devoir mettre en place des petits clusters et découvrir la mécanique de l'intégration continue. À la fin de ce projet vous serrez capable d'avoir un cluster fonctionnel rapidement dans docker et ainsi avoir une intégration continue utilisable pour vos applications.

## Part 1: K3s and Vagrant

**Kubernetes (K8s)** est un système open-source permettant d'automatiser le déploiement, la mise à l'échelle et la gestion des applications conteneurisées.
**K3s** est une version allégée de celui-ci.

**Vagrant** est un logiciel qui permet de paramétrer des environnements de développement virtuels. La configuration se fait dans un vagrantfile, avec une syntaxe similaire au ruby.

```
Vagrant.configure(2) do |config|									
    config.vm.box = "centos/8"						# Version de l'OS pour la vm
    config.vm.box_version = "2011.0"
    config.vm.box_download_insecure=true				# Permet une installation sans erreurs
    config.vm.define "mchapardS" do |control|				# Définition de la première VM
        control.vm.hostname = "mchapardS"				# nom de l'hote sur la VM
        control.vm.network "private_network", ip: "192.168.42.110"	# Ip de la VM
        control.vm.provider "virtualbox" do |v|				# Provider : Virtual Box
            v.cpus = 1							# CPU
            v.memory = 512						# MEM
            v.customize ["modifyvm", :id, "--name", "mchapardS"]	# Nom de la machine sur le provider
        end
        control.vm.provision "shell", path: "server.sh"			# Appel a un script de configuration
    end
    config.vm.define "shthevakSW" do |control|				# Définition de la deuxième VM
        control.vm.hostname = "shthevakSW"				# nom de l'hote sur la VM
        control.vm.network "private_network", ip: "192.168.42.111"	# Ip de la VM
        control.vm.provider "virtualbox" do |v|				# Provider : Virtual Box
            v.cpus = 1							# CPU
            v.memory = 512						# MEM
            v.customize ["modifyvm", :id, "--name", "shthevakSW"]	# Nom de la machine sur le provider
        end
        control.vm.provision "shell", path: "agent.sh"			# Appel a un script de configuration
    end
end
```

`vagrant up` : lance l'environnement a partir du vagrantfile  
`vagrant destroy` : détruit l'environnement décrit dans le vagrantfile  
`vagrant ssh [nom de la machine]` : permet de se connecter en ssh sans mot de passe  
`sudo journalctl -+f` : permet d'avoirs les logs de la machine  
