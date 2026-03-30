#######################################################################################################################
# Package configuration
#######################################################################################################################
# Ensures that the Ubuntu machine has configured the packages which were installed correctly.
# This script is NOT intended to be run directly - it is intended to be sourced by init.sh

########
# "main":
banner "Running package-configure.sh"

# Configure each relevant feature
banner "Configure docker"
run_module_script docker configure
banner "docker configuration complete"
