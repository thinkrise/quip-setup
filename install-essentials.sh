#!/usr/bin/env bash

source ./privileges.sh
source ./common.sh

function install_essentials () 
{
  apt-get -y update
  apt-get -y install build-essential libssl-dev curl git
}

function update_essentials () 
{
  apt-get -y update
  apt-get -y install --only-upgrade build-essential libssl-dev curl git 
}

function remove_essentials ()
{
    apt-get -y remove --purge build-essential libssl-dev curl git
    apt-get -y autoremove
}

if has_root_permissions; then
  case $_MODE in
    "i")
      install_essentials
      ;;
    "u")
      update_essentials
      ;;
    "r")
      remove_essentials
      ;;
    *)
      ;;
  esac    
else
    exit 1
fi
