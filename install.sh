#!/bin/bash

VERSION=2.5.0


#
# -> VARS TO CHANGE
#

ALIAS="blinds"

#
# -> VARS TO CHANGE
#



#
# -> VARS
#

# info: http://gillesfabio.com/blog/2011/03/01/rvm-for-pythonistas-virtualenv-for-rubyists/

NAME=$0;
MIN_RUBY_VERSION_STR="2.0.0"
MIN_RUBY_VERSION="${MIN_RUBY_VERSION_STR//.}" # 2.0.0 -> 200


declare -a programsToInstall=("git" "ruby" "ruby-dev")
declare -a shellsToCheck=("bash" "zsh")

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


add_rvm_to_rcs() {
    for shell_i in "$@" ; do
        # include $shell_I rc if it exists
        RC="."$shell_i"rc"
        PWDRC="$HOME/$RC"
        RVMLINE='[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*'
        if [ -f $PWDRC ]; then
            if ! grep -Fxq "$RVMLINE" $PWDRC ; then
                echo $RVMLINE >> $PWDRC
            fi
        fi
    done
}

make_ruby_vm() {
    # Create a virtual env with ruby 2.0.0
    # install rvm for manage the ruby version
    #   commands from http://gillesfabio.com/blog/2011/03/01/rvm-for-pythonistas-virtualenv-for-rubyists/
    #   more info https://rvm.io/rvm/install
    bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head )
    add_rvm_to_rcs ${shellsToCheck[@]}
    source ~/.rvm/scripts/rvm
    pw=$PWD
    cd ..
    rvm use 2.0.0@imdea-controls --create
    cd $pw
}


#
# <- FUNCTIONS
#



main() {
    # Check if ruby is installed and install
    check_and_install_programs ${programsToInstall[@]}


    ruby_version_long=$(ruby --version)
    ruby_version_short="$(echo $ruby_version_long | awk '{print $2}')"
    ruby_version_num=${ruby_version_short:0:5}
    ruby_version_num_int=${ruby_version_num//.} # Example: 2.1.5 -> 215

    # Check ruby version
    if [ "$ruby_version_num_int" -ne "$MIN_RUBY_VERSION" ] ; then
        msg w "Your ruby version is not the version required... yours=$ruby_version_num != min=$MIN_RUBY_VERSION_STR."
        msg i "We have to make a virtual env and install rvm for manage the ruby version."
        make_ruby_vm
    else
        msg i "Your ruby version is correct... $ruby_version_num == $MIN_RUBY_VERSION_STR"
    fi

    # Install dependecies gems
    gem install bundler
    bundle install

    # to .aliases
    blinds_path=$(pwd)"/blinds.rb"
    msg_alias="alias "$ALIAS"=\""$blinds_path" \$@\""
    echo $msg_alias >> ~/.aliases

    # End
    msg i "All installation finish."
    msg i "Proceed to launch blinds help. './blinds.rb -h'"
    # show help
    ./blinds.rb -h
}


main "$@"
