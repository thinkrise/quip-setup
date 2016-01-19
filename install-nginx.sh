#!/usr/bin/env bash

source ./privileges.sh
source ./common.sh

function install_nginx () 
{
  add-apt-repository -y ppa:nginx/stable
  apt-get -y update
  apt-get -y install nginx
  mkdir /etc/nginx/ssl
}

function update_nginx ()
{
  apt-get -y install --only-upgrade nginx
}

function remove_nginx ()
{
  apt-get -y remove --purge nginx
  rm -f /etc/apt/sources.list.d/nginx-stable-trusty.list*
  apt-get -y autoremove
  rm -rf /etc/nginx/ssl
}

if has_root_permissions; then
  case $_MODE in
    "i") 
      install_nginx
      ;;
    "u")
      upgrade_nginx
      ;;
    "r") 
      remove_nginx
      ;;
    *)
      echo "No mode specified for install-nginx script."
      ;;
  esac
else
  exit 1
fi
