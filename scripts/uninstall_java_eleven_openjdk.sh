#!/bin/bash

# This script uninstalls Java 11 OpenJDK release for compatible Macs

cd /Library/Java/JavaVirtualMachines || exit

if [[ -e "$(/usr/bin/find . -maxdepth 1 -type d \( -iname 'jdk*11*.jdk' \))" ]]; then
  jdk_path="$(/usr/bin/find . -maxdepth 1 -type d \( -iname 'jdk*11*.jdk' \))"
fi

sudo rm -fr "${jdk_path}"

exit 0
