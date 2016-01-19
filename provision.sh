#!/usr/bin/env bash

source ./privileges.sh

function install_ssh ()
{
  apt-get -y install openssh-server
}

function configure_ssh ()
{
  # turn off SSH password auth and disable root user to log in
  sed -i.bak '/PermitRootLogin/d' /etc/ssh/sshd_config
  sed -i.bak '/PasswordAuthentication/d' /etc/ssh/sshd_config
  echo PermitRootLogin no >> /etc/ssh/sshd_config
  echo PasswordAuthentication no >> /etc/ssh/sshd_config
  ufw allow 22
}

function update_base () 
{
  # update apt and pull dependencies
  apt-get -y update
}

if has_root_permissions; then
    update_base
    install_ssh
    configure_ssh
    service ssh restart
else 
    exit 1
fi
