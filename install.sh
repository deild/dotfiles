#!/usr/bin/env bash

cd "$(dirname "$0")" || exit

git pull --rebase origin master

cmd_exists() {
  command -v "$1" &>/dev/null
  return $?
}

doIt() {
  rsync --exclude ".gitignore" \
    --exclude ".DS_Store" \
    -avh --no-perms homedir/ ~
  # shellcheck source=/dev/null
  . ~/.bashrc
  printf "\\e[0;32m%s\\e[0m\\n" "[✔] dotfiles copied"
}

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
  doIt
else
  printf "\\e[0;33m%s\\e[0m" "[?] Copy dotfiles, This may overwrite existing files in your home directory. Are you sure? (y/n) "
  read -r -n 1
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt
  fi
fi
unset doIt
