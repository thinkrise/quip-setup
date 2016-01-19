#!/usr/bin/env bash

function has_root_permissions () 
{
  local response=0
  #if [[ $(/usr/bin/id -u) -ne 0 ]]; then
  if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or using sudo."
    response=1
  else
    response=0
  fi

  return $response
}
