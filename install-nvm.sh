#!/usr/bin/env bash

source ./privileges.sh
source ./common.sh

function download_nvm () 
{
  NAME=nvm
  VERSION=v0.25.3
  FILENAME=install.sh
  URL=https://raw.githubusercontent.com/creationix/$NAME/$VERSION/$FILENAME
  TMP_DIR=/tmp/node.js
  INSTALL_PREFIX=/opt

  if [ -f "$TMP_DIR/$FILENAME" ]; then
    echo "$TMP_DIR/$FILENAME already exists."
    echo "If there is a problem with this file, delete and re-run the script."
  else
    curl $URL | sh
        
  fi
}

function install_node () 
{
  # install node 0.12 and set as default, so node and npm are on the PasswordAuthentication.
  source ~/.bashrc
  nvm install 0.12
  nvm alias default 0.12
}

function configure_node () 
{
  # Make sure we have a /var/omni directory for app deployments.
  # This is used install of traditional /var/www.
  mkdir -p /var/omni
  chgrp omni-data /var/omni
  chmod g+rwxs /var/omni
}

function remove_node ()
{
  rm -rf $NVM_DIR ~/.npm ~/.bower
}

if has_root_permissions; then
  case $_MODE in
    "i") 
      download_nvm
      install_node
      configure_node
      ;;
    "u")
      ;;
    "r")
      remove_node
      ;;
    *)
      ;;
  esac
else
    exit 1
fi
