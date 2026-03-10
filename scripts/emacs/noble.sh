#!/usr/bin/env bash
set -euxo pipefail

#######################################################################################################################
# Install emacs-nox on the Ubuntu machine.
#######################################################################################################################
# Unfortunately, since Ubuntu 24.04 (Noble) "mailutils" is now a recommended package rather than a
# suggested package for emacs-nox.
#
# This brings in a whole kitchen sink of recommended packages (postfix mail server, mysql-common, etc), which are
# irrelevant to our default use-case of emacs as a basic text editor on the server.
#
#
# Useful links
# - History of what caused mailutils to become a recommended package
#   - https://emacs.stackexchange.com/q/81985#

# So there are options in how we want to install emacs:
# 1. Install it with the recommended packages and provide a configuration for postfix.
#   - If you just go `sudo apt-get install -y emacs-nox` it will hang on the postfix (mail server) installation
#     which will ask for input in how to configure it.
#   - Instead we can "pre-seed" the config as "No configuration" so it just installs postfix and does
#     not prompt us for further config details:
#    ```bash
#       sudo debconf-set-selections <<< "postfix postfix/main_mailer_type select No configuration"
#       sudo apt install emacs-nox
#    ```
# 2. Install it with all recommended packages EXCEPT mailutils
#  - This is what we do.
#  - We install it and explicitly state `mailutils-` on the end of the command.
#  - The minus indicates to apt to NOT install this dependency (mailutils).

# Option 2: Install with all recommended packages EXCEPT mailutils
sudo apt-get install -y emacs-nox mailutils-



