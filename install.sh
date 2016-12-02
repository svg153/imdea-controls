#!/bin/bash

VERSION=2.0.0


#
# -> VARS
#

# info: http://gillesfabio.com/blog/2011/03/01/rvm-for-pythonistas-virtualenv-for-rubyists/

NAME=$0;
MIN_RUBY_VERSION_STR="2.0.0"
MIN_RUBY_VERSION="${MIN_RUBY_VERSION_STR//.}" # 1.9.2 -> 192


declare -a programsToInstall=("git" "ruby" "ruby-dev")

#
# <- VARS
#


#
# -> FUNCTIONS
#

msg() {
    error_color="\e[31m"
    info_color="\033[0;36m"
    warn_color="\e[33m"
    reset_color="\e[0m"

    color=$reset_color
    case $1 in
        e|error) msg="ERROR"; color=$error_color ;;
        w|warn) msg="WARN"; color=$warn_color ;;
        i|info) msg="INFO"; color=$info_color ;;
        *) color=$reset_color ;;
    esac
    echo -e "${color}"$msg: "$2""${reset_color}"
}

check_and_install_programs() {
    msg i "Proceed to install programs..."
    for programToInstall in "$@" ; do
        programIsInstalled=$(which $programToInstall)
        if [ "$programIsInstalled" == *"not found"* ] ; then
            msg w "\t$programToInstall is not installed, so we proceed to install it..."
            sudo apt-get install $programToInstal
            msg i "\t$programToInstall is installed."
        else
            msg i "\t$programToInstall is already installed."
        fi
    done
    msg i "All gems dependecies installed."
}

#
# <- FUNCTIONS
#



main() {
    ruby_version_long=$(ruby --version)
    ruby_version_short="$(echo $ruby_version_long | awk '{print $2}')"
    ruby_version_num=${ruby_version_short:0:5}
    ruby_version_num_int=${ruby_version_num//.}


    # Check if ruby is installed and install
    check_and_install_programs ${programsToInstall[@]}


    # Check ruby version
    if [ "$ruby_version_num_int" -lt "$MIN_RUBY_VERSION" ] ; then
        msg e "Your ruby version is les than the minimun required... yours=$ruby_version_num < min=$MIN_RUBY_VERSION_STR."
        exit 1
    fi
    msg i "Your ruby version is correct... $ruby_version_num > $MIN_RUBY_VERSION_STR"


    # Create a virtual env with ruby 2.0.0 # install rvm
    #   commands from http://gillesfabio.com/blog/2011/03/01/rvm-for-pythonistas-virtualenv-for-rubyists/
    #   more info https://rvm.io/rvm/install
    bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head )
    echo '[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"' >> ~/.profile
    source ~/.rvm/scripts/rvm
    rvm use 2.0.0@imdea-controls --create

    # Install dependecies gems
    gem install bundler
    bundle install

    # End
    msg i "All installation finish."
    msg i "Proceed to launch blinds help. './blinds.rb -h'"
    # show help
    ./blinds.rb -h
}


main "$@"
