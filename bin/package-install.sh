#!/usr/bin/env bash
set -euo pipefail

# Note: `set -x` is intentionally not added as an option here to avoid double echo'ing commands in sourced scripts.

#######################################################################################################################
# Package installation
#######################################################################################################################
# Ensures that the Ubuntu machine has the desired packages installed.

# Where we expect this repo to be cloned to.
REPO_ROOT=/opt/ubuntu-bootstrap

########
# install <feature>:
#    - $1 - <feature> - single expected argument. A "feature" can install multiple packages.
#      - the name of the feature you want installed. The name corresponds to the directory under /install/<feature>.
#    - This function will try to run the script /module/<feature>/$VERSION_ID.sh", where:
#      - feature     -> the directory name e.g. "emacs"
#      - $VERSION_ID -> env var sourced from /etc/os-release e.g. 24.04
#    - For example: /module/emacs/24.04-install.sh
install() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: install <feature>"
        return 1
    fi

    local feature="$1"
    local file_name="v$VERSION_ID-install.sh"
    local script="$REPO_ROOT/module/$feature/$file_name"

    if [[ ! -f "$script" ]]; then
        echo "No script for $feature on Ubuntu file_name" >&2
        exit 1
    fi

    echo "==> running 'install' $feature for Ubuntu: $file_name"
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

# Source key env vars through our helper script.
banner "sourcing /etc/os-release"
source $REPO_ROOT/utils/os-release.sh

# Install each.
banner "Installing emacs"
install emacs
banner "emacs installation complete"

banner "Installing docker"
install docker
banner "docker installation complete"

banner "Installing tailscale"
install tailscale
banner "tailscale installation complete. to start it run 'sudo tailscale up' and follow the url to login"

banner "package-install.sh completed and ran successfully"