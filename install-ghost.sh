#!/usr/bin/env bash

source ./privileges.sh
source ./common.sh

function download_ghost ()
{
  version=$1
  local filename="Ghost-$version.zip"
  local url="https://github.com/TryGhost/Ghost/releases/download/$version/$filename"
  local tmp_dir=/tmp/ghost
  local install_path="$2"

  if [ -f "$tmp_dir/$filename" ]; then
    echo "$tmp_dir/$filename already exists."
    echo "If there is a problem with this file, delete and re-run the script."
  else
    curl -sf $url -o "$tmp_dir/$filename"
  fi
}

function install_ghost ()
{
  if [ $? -eq 0 ]; then
    if [ -d "$install_path" ]; then
      rm -rf "$install_path"
    fi

    unzip "$tmp_dir/$filename" -d "$install_path"
    rm "$tmp_dir/$filename"
  else
    echo "error: failed to install $version from $url"
  fi
}

function remove_ghost ()
{
  echo "TODO: add Ghost removal logic."
}

if has_root_permissions; then
  case $_MODE in
    "i")
      read -p "enter install path (/var/www/ghost): " install_path
      read -p "enter Ghost versions to install: " install_versions
      read -p "enter the privileged group name (www-data): " group_name

      if [ -z "$install_versions" ]; then
        exit 0
      fi

      IFS=" " versions=($install_versions)
      install_path=${install_path:-"/var/www/ghost"}
      group_name=${group_name:-"www-data"}

      if [ ! -d "$install_path" ]; then
        mkdir -p "$install_path"
      fi

      for version in "${versions[@]}"; do
        download_ghost $version
        install_ghost $version "$install_path/v$version"
      done
      ;;
    "u")
      ;;
    "r")
      remove_ghost
      ;;
    *)
      ;;
  esac
else
    exit 1
fi
