#!/usr/bin/env bash
set -euo pipefail

# Ubuntu 26.04 is compatible with the Ubuntu 24.04 installer.
# Delegate through run_module_script rather than using a symlink to avoid Windows Git
# checkout issues with symlinks.
source "$REPO_ROOT/bin/utils.sh"
echo "Ubuntu 26.04: delegating to the compatible Ubuntu 24.04 tailscale installer"
run_module_script tailscale install 24.04
