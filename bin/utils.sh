
########
# run_module_script <feature> <action> [script-version]:
#    - $1 - <feature> - the module directory name under /module/<feature>.
#    - $2 - <action>  - expected to be either "install" or "configure".
#    - $3 - <script-version> - optional implementation version.
#      Defaults to VERSION_ID when omitted.
run_module_script() {
    if [[ "$#" -lt 2 || "$#" -gt 3 ]]; then
        echo "Usage: run_module_script <feature> <install|configure> [script-version]"
        return 1
    fi

    local feature="$1"
    local action="$2"
    local script_version="${3:-$VERSION_ID}"

    case "$action" in
        install|configure)
            ;;
        *)
            echo "Invalid action: $action. Expected 'install' or 'configure'." >&2
            return 1
            ;;
    esac

    local file_name="v$script_version-$action.sh"
    local script="$REPO_ROOT/module/$feature/$file_name"

    if [[ ! -f "$script" ]]; then
        echo "No script for $feature on Ubuntu: $file_name" >&2
        exit 1
    fi

    echo "==> running '$action' $feature for Ubuntu: $file_name"
    # If invoked without elevation, elevate the module script here (avoid nested sudo).
    if (( EUID == 0 )); then
        bash "$script"
    else
        sudo bash "$script"
    fi
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
