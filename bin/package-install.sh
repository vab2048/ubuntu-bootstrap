#!/usr/bin/env bash
set -euo pipefail

# Note: `set -x` is intentionally not added as an option here to avoid double echo'ing commands in sourced scripts.

#######################################################################################################################
# Package installation
#######################################################################################################################
# Ensures that the Ubuntu machine has the desired packages installed.

########
# Source /etc/os-release to get a number of env vars. For noble (24.04), version related env vars included:
# PRETTY_NAME="Ubuntu 24.04.4 LTS"       ;   NAME="Ubuntu"           ; VERSION_ID="24.04"            ;
# VERSION="24.04.4 LTS (Noble Numbat)"   ;   VERSION_CODENAME=noble  ; UBUNTU_CODENAME=noble         ;
. /etc/os-release
########

# Where we expect this repo to be cloned to.
ROOT=/opt/ubuntu-bootstrap

########
# install <feature>:
#    - $1 - <feature> - single expected argument. A "feature" can install multiple packages.
#      - the name of the feature you want installed. The name corresponds to the directory under /install/<feature>.
#    - This function will try to run the script /install/<feature>/$VERSION_ID.sh", where:
#      - feature     -> the directory name e.g. "emacs"
#      - $VERSION_ID -> env var sourced from /etc/os-release e.g. 24.04
#    - For example: /install/emacs/24.04.sh
install() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: install <feature>"
        return 1
    fi

    local feature="$1"
    local script="$ROOT/install/$feature/v$VERSION_ID.sh"

    if [[ ! -f "$script" ]]; then
        echo "No script for $feature on Ubuntu $VERSION_ID" >&2
        exit 1
    fi

    echo "==> running $feature for Ubuntu $VERSION_ID"
    sudo bash "$script"
}


########
# banner <text>:
#    - Print a simple banner with a border above and below.
#    - The border marches the length of the test
#    - e.g. `banner "Deploy Complete"`:
#            ####################
#            ## Deploy Complete #
#            #####################
banner() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: banner <text>"
        return 1
    fi

    local text="$1"
    local len=${#text}
    local border

    border=$(printf '%*s' "$((len + 4))" '' | tr ' ' '#')

    echo "$border"
    echo "# $text"
    echo "$border"
}


########
# "main":

# Update all package repositories before doing anything else
banner "apt-get update"
sudo apt-get update

# Install each.
banner "Installing emacs"
install emacs
banner "emacs installation complete"

banner "Installing docker"
install docker
banner "docker installation complete"

banner "package-install.sh completed and ran successfully"