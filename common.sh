#!/usr/bin/env bash

_MODE="i" # Default mode = install.

#function load_opts () 
#{
  while getopts ":iur" optname;
    do
      case $optname in
        i)
          _MODE="i"
          ;;
        u)
          _MODE="u"
          ;;
        r)
          _MODE="r"
          ;;
        \?)
          echo "Unknown option $OPTARG"
          ;;
        \:)
          echo "No argument value for option $OPTARG"
          ;;
        *)
          echo "Unknown error while processing options."
          ;;
      esac
    done
#}

#load_opts
