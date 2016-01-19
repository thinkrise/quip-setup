#!/usr/bin/env bash

source ./privileges.sh
source ./install-essentials.sh
source ./common.sh

function download_rust () 
{
  FILENAME=rustup.sh
  URL=https://static.rust-lang.org/$FILENAME
  TMP_DIR=/tmp/rust
  INSTALL_PREFIX=/opt

  if [ -f "$TMP_DIR/$FILENAME" ]; then
    echo "$TMP_DIR/$FILENAME already exists."
    echo "If there is a problem with this file, delete and re-run the script."
  else
    curl -sSf -L $URL -O
  fi
}

function install_rust () 
{
  # install latest rust.
  source ~/.bashrc
  echo y | sh rustup.sh
}

function update_rust ()
{
  remove_rust
  install_rust
}

function remove_rust ()
{
  exec /usr/local/lib/rustlib/uninstall.sh
}

if has_root_permissions; then
  case $_MODE in
    "i") 
      install_rust
      ;;
    "u")
      update_rust
      ;;
    "r")
      remove_rust
      ;;
    *)
      ;;
  esac
else
  exit 1
fi
