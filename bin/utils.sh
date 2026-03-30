
########
# run_module_script <feature> <action>:
#    - $1 - <feature> - the module directory name under /module/<feature>.
#    - $2 - <action>  - expected to be either "install" or "configure".
#    - Runs /module/<feature>/v$VERSION_ID-<action>.sh for the current Ubuntu version.
run_module_script() {
    if [ "$#" -ne 2 ]; then
        echo "Usage: run_module_script <feature> <install|configure>"
        return 1
    fi

    local feature="$1"
    local action="$2"

    case "$action" in
        install|configure)
            ;;
        *)
            echo "Invalid action: $action. Expected 'install' or 'configure'." >&2
            return 1
            ;;
    esac

    local file_name="v$VERSION_ID-$action.sh"
    local script="$REPO_ROOT/module/$feature/$file_name"

    if [[ ! -f "$script" ]]; then
        echo "No script for $feature on Ubuntu: $file_name" >&2
        exit 1
    fi

    echo "==> running '$action' $feature for Ubuntu: $file_name"
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
