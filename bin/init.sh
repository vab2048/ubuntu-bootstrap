#!/usr/bin/env bash
set -euo pipefail

# Note: `set -x` is intentionally not added as an option here to avoid double echo'ing commands in sourced scripts.

#######################################################################################################################
# Initialize our Ubuntu machine.
# - Our "main" script.
# - Has 2 phases:
#   1. Install all packages
#   2. Configure relevant packages.
#######################################################################################################################

##############
# Step 1 - Define global variables
#
# Where we expect this repo to be cloned to.
REPO_ROOT=/opt/ubuntu-bootstrap
REPO_BIN_DIR="$REPO_ROOT/bin"
PACKAGE_INSTALL_SCRIPT="$REPO_BIN_DIR/package-install.sh"
PACKAGE_CONFIGURE_SCRIPT="$REPO_BIN_DIR/package-configure.sh"
OS_RELEASE_SCRIPT="$REPO_BIN_DIR/os-release.sh"
UTILS_SCRIPT="$REPO_BIN_DIR/utils.sh"

# "shellcheck" directives are to pacify the shellcheck linter.

# shellcheck source=/opt/ubuntu-bootstrap/bin/os-release.sh
source $OS_RELEASE_SCRIPT
# shellcheck source=/opt/ubuntu-bootstrap/bin/utils.sh
source $UTILS_SCRIPT

##############
# Step 2 - Install relevant packages

# shellcheck source=/opt/ubuntu-bootstrap/bin/package-install.sh
source $PACKAGE_INSTALL_SCRIPT

##############
# Step 3 - Configure the machine

# shellcheck source=/opt/ubuntu-bootstrap/bin/package-configure.sh
source $PACKAGE_CONFIGURE_SCRIPT
