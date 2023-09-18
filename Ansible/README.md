# Ansible Kubeadm Setup

Build a Kubernetes cluster using Ansible with kubeadm. The goal is easily install a Kubernetes cluster on machines running:

  - Ubuntu 20.04
  - Ubuntu 16.04
  - CentOS 7
  - RedHat 8

System requirements:

  - Deployment environment must have Ansible
  - Node with atleast 2GB RAM and 2vCPU

# Usage

Add the system information gathered above into a file called `hosts`. You must have connectivity between all the nodes. We can use Multi-Cloud to launch the instance also either for master or slave node. 
For example:
```
[master]
#ip_of_master_node
65.2.35.218

[slave]
#ip_of_slave_nodes
65.1.148.10[2:5]
```

Edit `remote_user` and `private_key_file` in `ansible.cfg` before proceed to next steps. 

Before continuing, edit `group_vars/all.yml` to your specified configuration.

For example, I choose to run `crio` instead of docker, and thus:

```yaml
# container runtimes ('docker', 'crio')
container_runtime: crio
```

# Requirements

Some modules in roles is also dependent on some other ansible galaxy collection. So run the `requirements.yml` first...

```sh
$ ansible-galaxy collection install -r requirements.yml
...
Process install dependency map
Starting collection install process
Installing 'community.general:2.5.1' to '/root/.ansible/collections/ansible_collections/community/general'
```

# Playbook

```yaml
- name: Install Necessary Software
  hosts: all
  vars_files:
    - group_vars/all.yml
  roles:
  -  role: runtime/{{ container_runtime }}-setup
  -  role: common
- name: Setup Master node
  hosts: master
  roles:
  -  role: master
  -  role: cni
- name: Setup Slave  node
  hosts: slave
  roles:
  -  role: node
```

Run this playbook for provision cluster

```sh
$ ansible-playbook role-kube.yml
```
![image](https://user-images.githubusercontent.com/46498235/116075598-c6851f00-a6b0-11eb-943e-7c8bf7045c9c.png)

![image](https://user-images.githubusercontent.com/46498235/116075663-d69cfe80-a6b0-11eb-8e83-afd5015e98c0.png)

![image](https://user-images.githubusercontent.com/46498235/116075711-e74d7480-a6b0-11eb-97f1-aec5a2d17467.png)

![image](https://user-images.githubusercontent.com/46498235/116075741-f2a0a000-a6b0-11eb-9c58-0ca44727868d.png)

![image](https://user-images.githubusercontent.com/46498235/116075786-fdf3cb80-a6b0-11eb-95ca-b417c4e87f2e.png)

Now, Verify cluster running using Kubectl command in master node:

```sh
$ kubectl get nodes
```
![image](https://user-images.githubusercontent.com/46498235/116076414-d2bdac00-a6b1-11eb-9a72-9b91fb95bba1.png)
