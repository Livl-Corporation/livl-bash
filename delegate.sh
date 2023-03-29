#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <username>"
  exit 1
fi

if [ $(id -u) -ne 0 ]; then
  echo "This script must be run as superuser"
  exit 1
fi

groupadd -f livl-bash
usermod -a -G livl-bash $1

chgrp livl-bash *.sh
chmod g+x *.sh
