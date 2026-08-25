#!/usr/bin/env bash
set -euo pipefail

# Ubuntu 26.04 is compatible with the Ubuntu 24.04 configuration script.
# Delegate through run_module_script rather than using a symlink to avoid Windows Git
# checkout issues with symlinks.
source "$REPO_ROOT/bin/utils.sh"
run_module_script ufw configure 24.04
