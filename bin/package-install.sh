#######################################################################################################################
# Package installation
#######################################################################################################################
# Ensures that the Ubuntu machine has the desired packages installed.
# This script is NOT intended to be run directly - it is intended to be sourced by init.sh

########
# "main":
banner "Running package-install.sh"

# Update all package repositories before doing anything else
banner "apt-get update"
sudo apt-get update

# Install each.
banner "Installing emacs"
run_module_script emacs install
banner "emacs installation complete"

banner "Installing docker"
run_module_script docker install
banner "docker installation complete"

banner "Installing tailscale"
run_module_script tailscale install
banner "tailscale installation complete. to start it run 'sudo tailscale up' and follow the url to login"

banner "Installing ufw"
run_module_script ufw install
banner "ufw installation complete"

banner "package-install.sh completed and ran successfully"
