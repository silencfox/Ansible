# Docker-Ansible base image

[![Layers](https://images.microbadger.com/badges/image/pad92/ansible-alpine.svg)](https://microbadger.com/images/pad92/ansible-alpine) [![GitHub issues](https://img.shields.io/github/issues/pad92/docker-ansible-alpine.svg)](https://github.com/pad92/docker-ansible-alpine) [![Docker Automated build](https://img.shields.io/docker/automated/pad92/ansible-alpine.svg?maxAge=2592000)](https://hub.docker.com/r/pad92/ansible-alpine/) [![Docker Build Status](https://img.shields.io/docker/build/pad92/ansible-alpine.svg?maxAge=2592000)](https://hub.docker.com/r/pad92/ansible-alpine/) [![Docker Pulls](https://img.shields.io/docker/pulls/pad92/ansible-alpine.svg)](https://hub.docker.com/r/pad92/ansible-alpine/)

## Usage

### Environnement variable

| Variable             | Default Value    | Usage                                       |
|----------------------|------------------|---------------------------------------------|
| PIP_REQUIREMENTS     | requirements.txt | install python library requirements         |
| ANSIBLE_REQUIREMENTS | requirements.yml | install ansible galaxy roles requirements   |
| DEPLOY_KEY           |                  | pass an SSH private key to use in container |


### Run Playbook

```
docker run -it --rm \
  -v ${PWD}:/ansible \
  pad92/ansible-alpine:latest \
  ansible-playbook -i inventory playbook.yml
```

### Generate Base Role structure

```
docker run -it --rm \
  -v ${PWD}:/ansible \
  pad92/ansible-alpine:latest \
  ansible-galaxy init role-name
```

### Run with forwarding ssh agent

```
docker run -it --rm \
  -v $(readlink -f $SSH_AUTH_SOCK):/ssh-agent \
  -v ${PWD}:/ansible \
  -e SSH_AUTH_SOCK=/ssh-agent \
  pad92/ansible-alpine:latest \
  sh
```


VCENTER OS UID
windows9_64Guest	Windows 10 (64 bit)
rhel7_64Guest for virtual machine with RHEL7 64 bit.
centos64Guest for virtual machine with CentOS 64 bit.
ubuntu64Guest for virtual machine with Ubuntu 64 bit.
centos8_64Guest	CentOS 8 (64-bit)
oracleLinux7_64Guest	Oracle 7 (64-bit)
oracleLinux8_64Guest	Oracle 8 (64-bit)




###Correr imagen desde composer
docker compose -f docker-compose.yml up -d

### correr imagen desde dockerfile
docker build . -t ansipine:1.0.0

### abrir bash 
docker run -it --rm silencfox/ansible:latest /bin/sh


ansible-playbook -i plantillas/inventary/win/hosts2.yml plantillas/clonewin/tpl_clone.yml

### abrir bash como root
docker exec -it --user=root b714c28179b4 sh


### correr una plantilla
docker run -it --rm -v silencfox/ansible:/ansible/plantillas silencfox/ansible:latest ansible-playbook -i inventory playbook.yml

### hacer ping 
ansible web -m ping -i plantillas/inventory.txt
ansible your_server_hostname -m ping -vvv
### Ping windows machine
ansible win100 -i tools/hosts2.yml -m win_ping
ansible-playbook tools/pingwin.yml -i tools/hosts2.yml


### Actualizar alpine
apk upgrade --available && sync

### guardar cambios de un contenedor a una imagen
docker commit -a “Kelvin Alcala” -m ”Agregando dependencia Vmware y Pure Storage” ansible silencfox/ansible:0.1

### Copiar archivo DOcker

### Del Contenedor a Local
docker cp NOMBRE_CONTENEDOR:RUTA_DEL_CONTENEDOR RUTA_LOCAL
### De Local al Contenedor
docker cp RUTA_LOCAL NOMBRE_CONTENEDOR:RUTA_DEL_CONTENEDOR



### Preparar windows server
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "\ConfigureRemotingForAnsible.ps1"
(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
powershell.exe -ExecutionPolicy ByPass -File $file

##
##  opcional
<powershell>
Invoke-Expression ((New-Object -TypeName System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"))
Enable-WSManCredSSP -Role Server -Force
</powershell>


### Inventory windows server machine
[servername]
xx.xx.xx.xx

[servername:vars]
ansible_user= xxxxxxxx
ansible_password= xxxxxxx
ansible_connection= winrm
ansible_port= 5986
ansible_winrm_server_cert_validation= ignore
ansible_winrm_scheme= https
ansible_winrm_transport= ntlm

### agregar al ansible.cfg las lineas siguientes
[inventory]
enable_plugins = vmware_vm_inventory

### Llamar 
ansible-inventory -i inventory.vmware.yml --list


### Generate config file
ansible-config init --disabled > /etc/ansible/ansible.cfg
ansible-config init --disabled -t all > /etc/ansible/ansible.cfg
