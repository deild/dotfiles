#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Install/Update Homebrew
if command -v "brew" &> /dev/null; then
  # Make sure we’re using the latest Homebrew.
  printf "\\e[0;32m%s\\e[0m\\n" "[✔] Updating Brew"
  brew update
  brew doctor
else
  printf "\\e[0;32m%s\\e[0m\\n" "[✔] Installing Brew"
  ruby -e \
  "$(curl -Ls 'https://github.com/Homebrew/install/raw/master/install')" \
  < /dev/null > /dev/null 2>&1
  brew analytics off
  brew update
  brew doctor
  brew tap "homebrew/bundle"
fi
printf "\\e[0;32m%s\\e[0m\\n" "[✔] Install/Update Homebrew"

# Upgrade any already-installed formulae.
outdated="$(brew outdated)"
[ -z "$outdated" ] &&brew upgrade

# Install from local Brewfile
printf "\\e[0;33m%s\\e[0m" "[?] Would you like to install all apps from Brewfile? (y/n) "
read -r -n 1
echo ""

if [[ "$REPLY" =~ ^[Yy]$ ]]; then
  brew bundle --global
  printf "\\e[0;32m%s\\e[0m\\n" "[✔] Brew and all apps installed"
else
  printf "\\e[0;32m%s\\e[0m\\n" "[✔] Only Brew installed"
fi

# Install Bash 4.
# Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before running `chsh`. Switch to using brew-installed bash as default shell
if ! grep -F -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;

# Remove outdated versions from the cellar.
brew cleanup
brew cask cleanup
