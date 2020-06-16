# task1_ansible


## Usage:

Run _ansible_install.sh_ without parameters for install Ansible and requirements to debian-like OS (Tested on Linux Mint).

Run _./docker_setup.sh_ [docker_version] [docker_compose_version] [group_hosts] this script for run Ansible Playbook for installation Docker and Docker-Compose to CentOS and Linux Mint. 

_Example:_
./docker_setup.sh 18.03.1 1.25.5 DOCKER_HOSTS

**Group hosts** must be specified in your inventory Ansible file


