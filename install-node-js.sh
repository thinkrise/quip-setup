#!/usr/bin/env bash

source ./privileges.sh
source ./common.sh

function download_node () 
{
  version=$1
  local filename="node-v$version-linux-x64.tar.gz"
  local url="http://nodejs.org/dist/v$version/$filename"
  local tmp_dir=/tmp/node.js
  local install_path="$2/v$version"

  if [ -f "$tmp_dir/$filename" ]; then
    echo "$tmp_dir/$filename already exists."
    echo "If there is a problem with this file, delete and re-run the script."
  else
    curl -sf $url -o "$version.tar.gz"
  fi
}

function install_node () 
{
  if [ $? -eq 0 ]; then
    if [ -d "$install_path" ]; then
      rm -rf "$install_path"
    fi

    tar xfz "$version.tar.gz" && mv "node-v$version-linux-x64" "$install_path"
    rm "$version.tar.gz"
  else
    echo "error: failed to install $version from $url"
  fi
}

function configure_node () 
{
  # Make sure we have a /var/app directory for app deployments.
  # This is used instead of traditional /var/www.
  mkdir -p $2
  chgrp $1 $2
  chmod g+rwxs $2
}

function remove_node ()
{
  echo "TODO: add node.js removal logic."
}

if has_root_permissions; then
  case $_MODE in
    "i")
      read -p "enter install path (/opt/node.js): " install_path
      read -p "enter node.js versions to install: " install_versions
      read -p "enter the privileged group name (app-data): " group_name
      read -p "enter application path (/var/app): " app_path

      if [ -z "$install_versions" ]; then
        exit 0
      fi

      IFS=" " versions=($install_versions)
      install_path=${install_path:-"/opt/node.js"}
      group_name=${group_name:-"app-data"}
      app_path=${app_path:-"/var/app"}

      if [ ! -d "$install_path" ]; then
        mkdir -p "$install_path"
      fi

      for version in "${versions[@]}"; do
        download_node $version
        install_node $version "$install_path/v$version"
        configure_node $group_name $app_path
      done
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
