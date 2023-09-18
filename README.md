# THE HARD WAY KUBERNETES IN AWS

## SUJET

Crée from scratch un VPC, subnet, 1 virtual machine (Controller), 2 virtural machine (Worker) sur aws en utilisant Terraform et installer kubernetes sur chaqu'une de vm en utilisant Ansible.



### PREREQUIS

Installer Python3

### Installation

Install my-project with npm

Pour Mac
```bash
-  brew tap hashicorp/tap
-  brew install hashicorp/tap/terraform
```
Pour linux
```bash
- wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
- echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
- sudo apt update && sudo apt install terraform
```
Pour windows 
install Binary download for Windows

[![Terraform](data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAkFBMVEUiKjVfQ+lAQLIfKStgROwmK0EeKSU9NIpMO7QiKjNhRO8fKSo/Pqs5NYRKOq4hKjEjKjglKz4kKztdQ+ZKPrpGOaRVP81XQdgnLk9SPcQ0NHgdKCMzM3NcQuAoLEpTPskvMGI/PaZDPq4+OZlGOaU9NYksLlgvMmwsMmdMP78lLEU9OJVYQtsrLVIsL1s0MW4PVBAWAAAFa0lEQVR4nO2c23abOhRFBQLbAhMZ41tTYseJL6l94vz/3x1JkBQbBKRNBkhdc+Shg4cOZtkrEmLvEp/4sfiZ+NOpPxE/sU/Ej195manL4lrxsq+/HBcvl/5izeWvvg0CAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/wwx4V3fwvdCo1+PodWONAqSuxVnXd/H9yEMnWC5n9Cub+TbkIaO5y3vua2lqgyFozM6WBrH3NBxgmS3Cm2M44ehY2scC4aOFyxS+1bHoqFwTEav1DLHa0MVxzW1Ko63hsLxv4jZ9BjLhjKOR4tWxwpD6ThbD2xxrDSUO4A7P+z63r4GjaFwXO5/WvEYtYaiVJcvNqwcekPp+Gtt/nOsM5Rx3J1M38jVG8o4RoY/xSZDJ7gz/Hdqo6EnDadfsJFjbPIF9/t5WhmG8zP/yzgyfhieOtnvtjIcjILFXx1zMDodumO/z4ae580uf7yR4/H92O27ofjDw271R3Hk9GXrugYYyveqIft0HBl/HbquIYZiA7D5ZBxVAF1zDOXJ6qfiyON07JplKOM4b3vMwfhx67rGGYo4PuzbrI6cv55d10hDUaot4shPkeuaaqiOOS61HwH4NN26JhvKUp2ftHHk9FjyM85Qro6aODK+Opf9DDQUpbpJK445uL+v8jPRUDqObldHzgoroPmG8iPAPB4U/MilIoDdGvI0aTjGqDWU3+SG73Fk4Xqo9evMkNDXWaC//2ZDuTqmqlT5tPIXTOeG4l/++MPTGzQaqlPHFSf8TRfArg3FY5xGD9pSbWEoSnVISfxUL9iloXjHic86x1aGnjDkDY+wU0ORofB1VB3H1oax/rdoHwzlTuutMo6tDad9rtIMEcdluVRbG7J+V6mChaf5w62LPVWq4IPHO+faprXhpP9VquD8/seVY2tDYkCVZtDJvhhHy6pUwei6EMf2z9CQKlWIOI7eS7V9Do2pUgXn6SZbHW2s0gzKhyqO7ddDk6o0IzztEu8TexqzqlTBB6uZF1hbpQoepssRtbZKFTS8MHurNIMTm6s0Z3BXe5STvwE3CLrbadceNYTRsv6kRj7DhiqN4l63HoXxvO7UUeWwtkrPh75PHvHBeqQ/kWuq0udL75uOQyY2cm8LXRzrq/Qp7XeBCsKnIaFys1p1zNFYpSKAPS9QkvVEUU4YP1XHsWbFf340YbhB9kQ56qsvp6uRUy5VbZU+P5ox2ZD1RCXz1UATR/V+WK7S8X3vA5iT72m85VCOflFSimNllY6jU/8DmPPRE+UtUi7juJ4n3q3hbZWaEcCcQk9UIuLI5EeAWdFRndNsr/2MmoK76onKJjE5SRe/dwC3J1HjaGqS3+27hbeMVBwnvzer11U6jtbGBDDnticq2GRxXL2vjldV+nwwbxCl3BOVzKQGCw9ZHAun+luzAphT1ROVqI7hPI4fVTqOTPTTvOO/x1Gsjt7717VobeiEja4napEyrr7JOeoL6fZk7Li7tifKU4PRfHB5EbX50vt3QD21PVEn9V5FiJkBzKnviYqooeErUN8TVd2iaBZNPVHOrJuRpq+jVU+U0bT7BmwyMIRh/4EhDPsPDGHYf2AIw/4DQxj2H/sNw13N6JcVhmRSM/plh6HsiSrNmthlSNjPg2b0yxZD2fd13NT1RNkAp7o42mJICI2fKx3tMRSlWjkYbZGh+j8vypOYVhlWxtEyQxFHf37taJ0h4eHhqmPYPkM1+lWYxLTRUI5+7ReB1YbZJGZgs6FcHS9Zx7C1hh+D0RYbqjguA6sNheN6npytNpSD0Y+mt5s0YXC/FwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHwH/wNdNGtuZRpFJQAAAABJRU5ErkJggg==)](https://developer.hashicorp.com/terraform/downloads)

installation Ansible

```bash
- pip3 install --include-deps ansible
```

## TERRAFORM

Pour build l'architecture aws :

Pour initialisé le projet en terraform

```bash
Terraform init
```
Pour crée un plan d'éxécution 

```bash
Terraform plan
```

Pour appliqué 


```bash
Terraform apply
```

## ANSIBLE

Pour se connecté à une instance

```bash
ssh -i ansible "<key.pem>" user@ipv4
```
Pour installer les dépendances sur chacune des instances 

```bash
ansible-playbook -i hosts role-kube.yml --verbose
```

### Tree



#### Dossiers 

 - Anisble/group_vars :

 - Ansible/roles/cni/tasks:
  Pour l'installation de kubctl

 - Ansible/roles/cni/vars :
  Pour l'installation de python2.7

 - Ansible/roles/common/ :
  Pour installer le setup kubernetes cluster
 
 - Ansible/roles/master : Pour installer le master node de kubernetes

 - Ansible/roles/node : Pour joindre le node master au node worker de kubernetes
 
 - Ansible/roles/os-facts : Pour installer les dépendences dans les différents Os

 - Ansible/roles/runtime :

 - Anisble/ansible.cfg: Fichier de configuration

 - Ansible/hosts : ip connection pour le master et les workers

 - Ansible/requirements.yml : Pour
 Build Kubernetes cluster avec kubeadm

 - Ansible/role-kube.yml : pour installer toutes les dépendences 

 - Terraform/compute.tf : Instances ec2 aws
 
 - Terraform/network.tf : [VPC, Subnet, route_table, security_groups]

 - Terraform/variables.tf : les variables utiliser pour les différents fichiers précédents

