#!/usr/bin/env bash

cd "$(dirname "$0")" || exit

function ask() {
  # https://gist.github.com/davejamesmiller/1965569
  local prompt default reply
  if [ "${2:-}" = "Y" ]; then
    prompt="Y/n"
    default=Y
    elif [ "${2:-}" = "N" ]; then
    prompt="y/N"
    default=N
  else
    prompt="y/n"
    default=
  fi
  while true; do
    # Ask the question (not using "read -p" as it uses stderr not stdout)
    print_question "$1 [$prompt] "
    # Read the answer (use /dev/tty in case stdin is redirected from somewhere else)
    read -r reply </dev/tty
    # Default?
    if [ -z "$reply" ]; then
      reply=$default
    fi
    # Check if the reply is valid
    case "$reply" in
      Y*|y*) return 0 ;;
      N*|n*) return 1 ;;
    esac
  done
}

function cmd_exists() {
  command -v "$1" &> /dev/null
  return $?
}

function ask_for_sudo() {
  # Ask for the administrator password upfront.
  sudo -v
  # Update existing `sudo` time stamp
  # until this script has finished.
  #
  # https://gist.github.com/cowboy/3118588
  while true; do
    sleep 60;
    sudo -n true;
    kill -0 "$$" || exit
  done 2>/dev/null &
}

function print_error() {
  print_in_red "[✖] $1 $2"
}

function print_in_green() {
  printf "\\e[0;32m%b\\e[0m" "$1"
}

function print_in_purple() {
  printf "\\e[0;35m%b\\e[0m" "$1"
}

function print_in_red() {
  printf "\\e[0;31m%b\\e[0m" "$1"
}

function print_in_yellow() {
  printf "\\e[0;33m%b\\e[0m" "$1"
}

function print_in_white() {
  printf "\\e[O%b\\e[0m" "$1"
}

function print_question() {
  print_in_yellow "[?] $1"
}

function print_success() {
  print_in_green "[✔] $1"
}

function print_step() {
  print_in_white "[-] $1"
}

function print_and_exit() {
  print_in_white "\\nThanks for using stronghold!\\n\\n"
  print_in_white "If you have any suggestions for stronghold,\\n open an issue at: https://github.com/deild/dotfiles/issues/new \\n"
  exit 0
}

function usage() {
  print_in_white "Usage: stronghold.sh [OPTIONS]\\n"
  print_in_white "\\tSecurely configure your macOS.\\n"
  print_in_white "\\tDeveloped by Deild -> (Github: deild)\\n\\n"
  print_in_white "Options:\\n"
  print_in_white "\\t--force, -f  Set secure configuration without user interaction.\\n"
  print_in_white "\\t--help, -h  Show this message and exit.\\n"
  exit 1
}
## Start                                                                     ##
force=1
if [ $# -gt 1 ]; then
  usage
fi
if [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
  usage
else
  if [ "$1" == "--force" ] || [ "$1" == "-f" ]; then
    export force=0
  fi
fi

print_in_white "Stronghold is a configuration tool for MacOS.\\n"
print_in_white "You may be asked for a sudo password.\\n"

print_in_red "\\t0. Make the terminal window as large as possible.\\n"
print_in_red "\\t1. Ensure you have up-to-date system backups.\\n"
print_in_red "\\t2. Read the prompts carefully.\\n"

if [ $force -eq 1 ] && ! ask "I have read the above carefully and want to continue"; then
  print_and_exit
fi
# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

ask_for_sudo

## Brew                                                                      ##
if [ $force -eq 0 ] || ask "Would you like to install Brew" ; then
  if cmd_exists "brew"; then
    print_step "Updating Brew\\n"
    brew update
  else
    print_step  "Installing Brew\\n"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew analytics off
    brew update
  fi
  print_success "Brew installed\\n"
fi

## Bash 4                                                                    ##
if [ $force -eq 0 ] || ask "Would you like to install Bash 4" ; then
  [ -z "$(brew ls --versions bash)" ] && brew install bash
  [ -z "$(brew ls --versions bash-completion@2)" ] && brew install bash-completion@2
  # Install Bash 4.
  # Note: don’t forget to add `/usr/local/bin/bash` to `/etc/shells` before running `chsh`. Switch to using brew-installed bash as default shell
  if ! grep -F -q '/usr/local/bin/bash' /etc/shells; then
    echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
    chsh -s /usr/local/bin/bash;
  fi;
  print_success "Bash 4 installed\\n"
fi

if [ $force -ne 0 ] && ask "Would you like to set computer name (as done via System Preferences → Sharing)" ; then
  print_question "What computer name: "
  read -r hostname </dev/tty
  sudo scutil --set ComputerName "$hostname"
  sudo scutil --set HostName "$hostname"
  sudo scutil --set LocalHostName "$hostname"
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$hostname"
  unset hostname
  print_success "Computer name set\\n"
fi

## Brewfile                                                                  ##
if [ $force -eq 0 ] || ask "Would you like to install all apps from Brewfile" ; then
  # TODO
  print_success "All apps from Brewfile installed\\n"
fi

## Captive portal                                                            ##
if [ $force -eq 0 ] || ask "When macOS connects to new networks, it probes the network and launches a Captive Portal assistant utility if connectivity can't be determined. It's best to disable this feature and log in to captive portals using your regular Web browser.\\nWould you like to disable Captive Portal assistant" ; then
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false
  print_success "Captive Portal assistant disabled\\n"
fi

## Firewall                                                                  ##
if [ $force -eq 0 ] || ask "Enable the firewall with logging. This helps protect your Mac from being attacked over the internet. If there IS an infection, logs are useful for determining the source" ; then
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
  # After interacting with socketfilterfw, you may want to restart (or terminate) the process
  sudo pkill -HUP socketfilterfw
  print_success "Firewall and logging enabled\\n"
fi
if [ $force -eq 0 ] || ask "Turn on stealth mode. Your Mac will not respond to ICMP ping requests or connection attempts from closed TCP and UDP networks" ; then
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
  # After interacting with socketfilterfw, you may want to restart (or terminate) the process
  sudo pkill -HUP socketfilterfw
  print_success "Stealth mode enabled\\n"
fi
#
if [ $force -eq 0 ] || ask "Would you like to prevent built-in software as well as code-signed, downloaded software from being whitelisted automatically" ; then
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off
  sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off
  # After interacting with socketfilterfw, you may want to restart (or terminate) the process
  sudo pkill -HUP socketfilterfw
  print_success "Stealth mode enabled\\n"
fi

## FileVault 2                                                               ##
if [ $force -eq 0 ] || ask "Would you like to configure hibernation for FileVault" ; then
  # Prevent attacker with physical access from taking your encryption key in standby mode, you may wish to enforce hibernation and evict FileVault keys from memory instead of traditional sleep to memory
  sudo pmset -a destroyfvkeyonstandby 1
  sudo pmset -a hibernatemode 25
  # If you choose to evict FileVault keys in standby mode, you should also modify your standby and power nap settings. Otherwise, your machine may wake while in standby mode and then power off due to the absence of the FileVault key
  sudo pmset -a powernap 0
  sudo pmset -a standby 0
  sudo pmset -a standbydelay 0
  sudo pmset -a autopoweroff 0
  print_success "Hibernation configured\\n"
fi

# General UI/UX                                                               #
if [ $force -eq 0 ] || ask "Would you like to configure General UI/UX" ; then
  # Disable the sound effects on boot
  sudo nvram SystemAudioVolume=" "
  # Set sidebar icon size to medium
  defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2
  # Always show scrollbars
  defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
  # Possible values: `WhenScrolling`, `Automatic` and `Always`
  # Expand save panel by default
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
  # Expand print panel by default
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
  # Save to disk (not to iCloud) by default
  defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
  # Automatically quit printer app once the print jobs complete
  defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
  # Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
  # Display ASCII control characters using caret notation in standard text views
  # Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
  defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true
  # Disable Resume system-wide
  defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
  # Disable automatic termination of inactive apps
  defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true
  # Disable the crash reporter
  defaults write com.apple.CrashReporter DialogType -string "none"
  # Set Help Viewer windows to non-floating mode
  defaults write com.apple.helpviewer DevMode -bool true
  # Increase sound quality for Bluetooth headphones/headsets
  defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
  print_success "General UI/UX configured\\n"
fi

# Screen                                                                      #
if [ $force -eq 0 ] || ask "Would you like to configure Screen option" ; then
  # Require password immediately after sleep or screen saver begins
  defaults write com.apple.screensaver askForPassword -int 1
  defaults write com.apple.screensaver askForPasswordDelay -int 0
  # Save screenshots to the desktop
  defaults write com.apple.screencapture location -string "${HOME}/Desktop"
  # Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
  defaults write com.apple.screencapture type -string "png"
  print_success "Screen configured\\n"
fi

# Finder                                                                      #
if [ $force -eq 0 ] || ask "Would you like to configure Finder" ; then
  # Finder: disable window animations and Get Info animations
  defaults write com.apple.finder DisableAllAnimations -bool true
  # Hide icons for hard drives, servers, and removable media on the desktop
  defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
  defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
  defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
  defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
  # Finder: show hidden files by default
  defaults write com.apple.finder AppleShowAllFiles -bool true
  # Finder: show all filename extensions
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  # Finder: show status bar
  defaults write com.apple.finder ShowStatusBar -bool true
  # Finder: show path bar
  defaults write com.apple.finder ShowPathbar -bool true
  # Display full POSIX path as Finder window title
  #defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
  # Keep folders on top when sorting by name
  #defaults write com.apple.finder _FXSortFoldersFirst -bool true
  # Disable the warning when changing a file extension
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
  # Enable spring loading for directories
  defaults write NSGlobalDomain com.apple.springing.enabled -bool true
  # Remove the spring loading delay for directories (0.5 default)
  defaults write NSGlobalDomain com.apple.springing.delay -float 0
  # Avoid creating .DS_Store files on network or USB volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
  # Disable disk image verification
  #defaults write com.apple.frameworks.diskimages skip-verify -bool true
  #defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
  #defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
  # Disable the warning before emptying the Trash
  defaults write com.apple.finder WarnOnEmptyTrash -bool false
  # Show the ~/Library folder
  chflags nohidden ~/Library
  # Show the /Volumes folder
  sudo chflags nohidden /Volumes
  # Expand the following File Info panes:
  # “General”, “Open with”, and “Sharing & Permissions”
  defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true
  print_success "Finder configured\\n"
fi

# Spotlight                                                                   #
if [ $force -eq 0 ] || ask "Would you like to Disable Spotlight indexing for any volume" ; then
  # Disable Spotlight indexing for any volume that gets mounted and has not yet
  # been indexed before.
  # Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
  sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
  print_success "Spotlight indexing for any volume disabled\\n"
fi

# Time Machine                                                                #
if [ $force -eq 0 ] || ask "Would you like to configure Time Machine" ; then
  # Prevent Time Machine from prompting to use new hard drives as backup volume
  defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
  # Disable local Time Machine backups
  hash tmutil &> /dev/null && sudo tmutil disablelocal
  print_success "Time Machine configured\\n"
fi

## Messages                                                                  ##
if [ $force -eq 0 ] || ask "Would you like to configure Messages" ; then
  # Disable automatic emoji substitution (i.e. use plain text smileys)
  defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false
  # Disable smart quotes as it’s annoying for messages that contain code
  defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false
  # Disable continuous spell checking
  #defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false
  print_success "Messages configured\\n"
fi

# Photos                                                                      #
if [ $force -eq 0 ] || ask "Would you like to prevent Photos from opening automatically when devices are plugged in" ; then
  defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true
  print_success "Photos configured\\n"
fi

## Example                                                                   ##
# if [ $force -eq 0 ] || ask "Would you like to install example" ; then
#   print_success "Example installed\\n"
# fi

## End                                                                       ##
print_in_red "\\nNote that some of these changes require a logout/restart to take effect.\\n"

unset force
print_and_exit
