#!/bin/bash

# Workstation Builder v0.3
# Tim Hordern (@mence)
# This is a basic shell script to build an OSX development environment from scratch.
# Linting is done with shellcheck: https://github.com/koalaman/shellcheck

install # Let's do some installing!

function install(){
  update_osx_system           # Check for System Updates
  install_homebrew            # Install Homebrew
  install_homebrew_apps       # Install Homebrew Apps
  install_homebrew_cask       # Install Homebrew Cask
  install_browsers            # Install Browsers
  install_development_tools   # Install Development Tools
  install_collaboration_tools # Install Collaboration Apps
  install_productivity_tools  # Install Productivity Apps
  install_utilities           # Install Utilities
  install_quicklook_upgrades  # Install QuickLook Upgrades
  install_multimedia_apps     # Install Multimedia Apps
  install_other_apps          # Install Random Apps
  install_fonts               # Install Programming Fonts
  #install_color_schemes      # Install Color Schemes
  install_terminal_utilities  # Install Terminal Utilities
  install_dotfiles            # Install and Configure Personal Dotfiles
  install_python_apps         # Install Applications via Python
}

function update_osx_system(){
  echo -e "\033[33m--- Running System Updates ---\033[0m"
  sudo softwareupdate --install -all
}

function install_homebrew(){
  echo -e "\033[33m--- Installing Homebrew ---\033[0m"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew doctor
}

function install_homebrew_apps(){
  homebrew_apps=(
    git
    curl
    iftop
    htop-osx
    tree
    the_silver_searcher
    unrar
    whatmask
    node
    )

  echo -e "\033[33m--- Installing Homebrew Applications ---\033[0m"
  homebrew_install $homebrew_apps
  sudo brew install mtr --no-gtk  # mtr needs command-line flags
}

function install_homebrew_cask(){
  echo -e "\033[33m--- Setting up Homebrew Cask ---\033[0m"
  brew tap caskroom/cask
  brew install brew-cask
  brew doctor
}

function install_browsers(){
  browser_casks=(
    google-chrome
    firefox
    chromium
    )

  echo -e "\033[33m--- Installing Browsers ---\033[0m"
  cask_install $browser_casks
  # TODO: Determine how to install Chrome extensions from command line
}

function install_development_tools(){
  development_casks=(
    sublime-text
    virtualbox
    sequel-pro
    charles
    dbeaver-community
    rowanj-gitx
    github
    cyberduck
    processing
    arduino
    iterm2
    atom
    dash
    heroku-toolbelt
    sauce
    icdiff
    entr
    pstree
    watch
    )
  # TODO: Allow for optional choices (eg. IntelliJ which eats the world)

  echo -e "\033[33m--- Installing Development Tools ---\033[0m"
  cask_install $development_casks

  # Sublime Text 3
  brew cask install caskroom/homebrew-versions/sublime-text3

  # Google Canary
  brew cask install caskroom/homebrew-versions/google-chrome-canary

  # RubyMine and IntelliJ depend on Java 6
  brew cask install caskroom/homebrew-versions/java6
  brew cask install rubymine
  brew cask install intellij-idea

  # MacVim
  brew cask install macvim
  brew linkapps macvim
}

function install_collaboration_tools(){
  collaboration_casks=(
    slack
    hipchat
    propane
    adium
    )

  echo -e "\033[33m--- Installing Collaboration Tools ---\033[0m"
  cask_install $collaboration_casks
}

function install_productivity_tools(){
  productivity_casks=(
    evernote
    skitch
    dropbox
    calibre
    sequential
    fantastical
    hazel
    keyboard-maestro
    marked
    mailbox
    )
  # TODO: Determine how to deal with App Store apps?

  echo -e "\033[33m--- Installing Productivity Apps ---\033[0m"
  cask_install $productivity_casks
}

function install_utilities(){
  utility_casks=(
    flux
    bettertouchtool
    alfred
    cheatsheet
    carbon-copy-cloner
    appcleaner
    onepassword
    smcfancontrol
    bartender
    caffeine
    coconutbattery
    crashplan
    smoothmouse
    phoneclean
    )
    # Growl
    # HardwareGrowler

  echo -e "\033[33m--- Installing Utilities ---\033[0m"
  cask_install $utility_casks
}

function install_quicklook_upgrades(){
  quicklook_upgrade_casks=(
    qlcolorcode
    qlstephen
    qlmarkdown
    quicklook-json
    qlprettypatch
    quicklook-csv
    betterzipql
    webp-quicklook
    suspicious-package
    cert-quicklook
    )

  echo -e "\033[33m--- Installing QuickLook Upgrades ---\033[0m"
  cask_install $quicklook_upgrade_casks
  defaults write com.apple.finder QLEnableTextSelection -bool true && killall Finder # Allow copying text from QL
}

function install_multimedia_apps(){
  multimedia_casks=(
    vlc
    spotifree
    rdio
    lastfm
    chromecast
    )

  echo -e "\033[33m--- Installing Multimedia Apps ---\033[0m"
  cask_install $multimedia_casks
}

function install_other_apps(){
  random_casks=(
    dogecoin
    reeddit
    )

  echo -e "\033[33m--- Installing Random Apps ---\033[0m"
  cask_install $random_casks
}

function install_dotfiles(){
  echo -e "\033[33m--- Installing Personal Dotfiles ---\033[0m"
  git clone https://github.com/mence/dotfiles.git ~/.dotfiles
  cp ~/.dotfiles/.bash_profile.template ~/.bash_profile
  ln -s ~/.dotfiles/.gitaliasconfig ~/.gitaliasconfig
  ln -s ~/.dotfiles/.gitconfig ~/.gitconfig
  ln -s ~/.dotfiles/.githubconfig ~/.githubconfig
  ln -s ~/.dotfiles/.iftoprc ~/.iftoprc
}

function install_terminal_utilities(){
  echo -e "\033[33m--- Installing Terminal Utilities ---\033[0m"
  install_rainbow
  brew tap tldr-pages/tldr    # install tl;dr manpages
  brew install tldr
}

function install_rainbow(){
# Install Rainbow
# https://github.com/nicoulaj/rainbow
# v2.5: https://github.com/nicoulaj/rainbow/archive/2.5.0.zip
  mkdir tmp
  curl -L https://github.com/nicoulaj/rainbow/archive/2.5.0.zip -o tmp/rainbow.zip
  cd tmp/rainbow
  unzip rainbow.zip
  cd rainbow-2.5.0
  echo "You will be prompted for your Administrator password."
  sudo python setup.py install
  cd ../../..
  rm -rf tmp
}

function install_fonts(){
  font_casks=(
    font-inconsolata  # Inconsolata
    font-fontawesome  # Font Awesome
    font-roboto       # Roboto
    font-roboto-slab  # Roboto Slab
  )

  echo -e "\033[33m--- Installing Programming Fonts ---\033[0m"
  brew tap caskroom/Fonts   # Add the font cask to Homebrew
  cask_install $font_casks
}

function install_color_schemes(){
  echo -e "\033[33m--- Installing Color Schemes ---\033[0m"
  # Install Solarized Color Scheme
  # https://github.com/altercation/solarized
}

function install_python_apps(){
  echo -e "\033[33m--- Installing Python Applications ---\033[0m"
  pip install lolcat # Because lolcat
}

function homebrew_install(){
  for kegs in $kegs; do
    echo "Installing Homebrew: $keg"
    "brew install $keg"
  done
}

function cask_install(){
  for casks in $casks; do
    echo "Installing Cask: $cask"
    "brew cask install $cask"
  done
}
