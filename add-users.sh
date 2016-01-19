#!/usr/bin/env bash

source ./privileges.sh

function add_user ()
{
  # only add user if username was passed.
  if [ "$1" ] ; then
    # add if user doesn't exist.
    id -u $1 &>/dev/null || useradd $1
    adduser $1 omni-data  
  fi
}

function add_sudo_user ()
{
  if [ "$1" ] ; then
    id -u $1 &>/dev/null || useradd $1
    useradd -s /bin/bash -m $1
    usermod -aG omni-data adm sudo
    #adduser $1 omni-data adm sudo
  fi
}

function add_key ()
{
  # only add SSH key if one was passed
  if [ "$1" ] ; then

    # make sure we have a place for known SSH keys
    mkdir -p ~/.ssh

    # create the authorized_keys file if it doesn't exist
    if [ ! -e ~/.ssh/authorized_keys ] ; then
      touch ~/.ssh/authorized_keys
    fi

    # add the SSH key in arg 1 to authorized_keys if not present
    if ! grep -q "$1" ~/.ssh/authorized_keys ; then 
      echo $1 >> ~/.ssh/authoized_keys
    fi

  fi
 
  # restart sshd to pick up new config
  service ssh restart
}
