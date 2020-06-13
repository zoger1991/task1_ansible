#!/bin/sh
#TODO.md

dpkg_check_lock() {
  while fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
    echo "Waiting for dpkg lock release"
    sleep 1
  done
}

apt_install() {
  dpkg_check_lock && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    -o DPkg::Options::=--force-confold -o DPkg::Options::=--force-confdef "$@"
}

if [ -f /etc/debian_version ] || grep -qi ubuntu /etc/lsb-release || grep -qi ubuntu /etc/os-release; then
  
  # Add PPA Ansible repo
  apt-add-repository ppa:ansible/ansible -y
  dpkg_check_lock && apt-get update -q
  # Install required Python libs and pip
  apt_install python-pip python-yaml python-jinja2 python-httplib2 python-netaddr python-paramiko python-pkg-resources libffi-dev
  [ -n "$( dpkg_check_lock && apt-cache search python-keyczar )" ] && apt_install python-keyczar
  
  dpkg_check_lock && apt-cache search ^git$ | grep -q "^git\s" && apt_install git || apt_install git-core
  # If python-pip install failed and setuptools exists, try that
  if [ -z "$(which pip)" ] && [ -z "$(which easy_install)" ]; then
      apt_install python-setuptools
      easy_install pip
    elif [ -z "$(which pip)" ] && [ -n "$(which easy_install)" ]; then
      easy_install pip
    fi
    # If python-keyczar apt package does not exist, use pip
    [ -z "$( apt-cache search python-keyczar )" ] && sudo pip install python-keyczar

    # Install passlib for encrypt
    apt_install build-essential
    # [ X`lsb_release -c | grep trusty | wc -l` = X1 ] && pip install cryptography==2.0.3
    apt_install python-all-dev python-mysqldb sshpass && pip install pyrax pysphere boto passlib dnspython pyopenssl

    # Install Ansible module dependencies
    apt_install bzip2 file findutils git gzip mercurial procps subversion sudo tar debianutils unzip xz-utils zip python-selinux python-boto
    apt_install ansible
fi
