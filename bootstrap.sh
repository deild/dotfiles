#!/usr/bin/env bash

cd "$(dirname "$0")" || exit

git pull --rebase origin master

cmd_exists() {
  command -v "$1" &> /dev/null
  return $?
}

doIt() {
  rsync --exclude ".gitignore" \
  --exclude ".DS_Store" \
  -avh --no-perms homedir/ ~;
  # shellcheck source=/dev/null
  . ~/.bashrc
  printf "\\e[0;32m%s\\e[0m\\n" "[✔] dotfiles copied"
}

doBrew() {
  if cmd_exists "brew"; then
    printf "\\e[0;35m%s\\e[0m" "[-] Updating Brew"
    brew update
  else
    printf "\\e[0;35m%s\\e[0m" "[-] Installing Brew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew analytics off
    brew update
  fi
  [ -z "$(brew ls --versions bash)" ] && brew install bash
  [ -z "$(brew ls --versions bash-completion@2)" ] && brew install bash-completion@2
  # Install Bash 4.
  # Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before running `chsh`. Switch to using brew-installed bash as default shell
  if ! grep -F -q '/usr/local/bin/bash' /etc/shells; then
    echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
    chsh -s /usr/local/bin/bash;
  fi;
  printf "\\e[0;32m%s\\e[0m\\n" "[✔] Brew installed"
}

if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
  doBrew;
  doIt;
else
  printf "\\e[0;33m%s\\e[0m" "[?] Install or update Brew with bash4. Are you sure? (y/n) "
  read -r -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doBrew;
  fi;
  printf "\\e[0;33m%s\\e[0m" "[?] Copy dotfiles, This may overwrite existing files in your home directory. Are you sure? (y/n) "
  read -r -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt;
  fi;
fi;
unset doIt;
unset doBrew;

