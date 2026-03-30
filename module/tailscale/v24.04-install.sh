#######################################################################################################################
# Install tailscale
# We just source the full install script.
#######################################################################################################################
script_path="$(realpath "$0")"
script_dir="$(dirname "$script_path")"

source "$script_dir/.assets/install.sh"