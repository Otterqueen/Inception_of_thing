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

Dans les scripts de config on désactive les firewalls, on met à jour les mirror list afin d'installer k3s et le lancer avec les infos necessaires dont l'ip et le token.

## Part 2: K3s and three simple applications

**service**: Une manière abstraite d'exposer une application s'exécutant sur un ensemble de Pods en tant que service réseau, c'est un objet REST.

**ingress**: expose les routes HTTP et HTTPS de l'extérieur du cluster à des services au sein du cluster. Le routage du trafic est contrôlé par des règles définies sur la ressource Ingress.
```none
    internet
        |
   [ Ingress ]
   --|-----|--
   [ Services ]
```
**deployment** : fournit des mises à jour déclaratives pour Pods et ReplicaSets. Décrit un état désiré dans un déploiement et le controlleur déploiement change l'état réel à l'état souhaité à un rythme contrôlé.

`Pour avoir app1.com et app2.com (et app3.com) fonctionnels, il est nécessaire de modifier le fichier host de window afin d’y ajouter nos redirections ; attention cela peut prendre plusieurs minutes avant d’être fonctionnel
`  
`(Ouvrir bloc note en tant qu’administrateur, ouvrir le fichier C:\Windows\System32\drivers\etc\hosts  et y ajouter les lignes 192.168.42.110 app1/2/3.com )`


## Part 3: K3d and Argo CD

**K3d** comme k3s est une version allégée de k8s, avec cependant quelque différences : 

 - k3s déploie des cluster de machines virtuels tandis que k3d déploie des cluster k8s de containers k3s docker
 - k3d offre une version plus "scalable" de k3s
 - même si les applications sont similaire, k3d  semble etre une version plus flexible et améliorée de k3s
 - k3s est pensé pour être facilement deployable dans des environnements de production (environnement local) k3d quand a lui est pensé pour s'adapter a des environnements encore plus petit tel que Raspberry Pi, IoT et Edge...

### Étapes d'installation

 - Installer `Docker desktop`
 - Installer `Chocolatey`
	 - `Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`
 - Installer k3d (+outils)
	 - `choco install k3d -y`
	 - `choco install jq -y (lightweight and flexible command-line JSON processor)`
	 - `choco install yq -y (lightweight and portable command-line YAML processor)`
	 - `choco install kubernetes-helm -y (helps you manage Kubernetes applications )`
 - config profile powerShell 
	```
	# Create user profile file if it doesn't exist
	if ( -not ( Test-Path $Profile ) ) { New-Item -Path $Profile -Type File -Force }
	# Append the k3d completion to the end of the user profile 
	k3d completion powershell | Out-File -Append $Profile
	```
- Creation du cluster
	- `k3d cluster create mycluster`
- Verification
	- `kubectl get nodes`
- Installer argocd dans le namespace
	- `kubectl create namespace argocd`
	- `kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml`
