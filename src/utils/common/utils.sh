#!/bin/bash

# File to be sourced by other scripts
# OS detection, command utilities, process management, version comparison, Git utilities, file system, and argument parsing

cmd_exists() {
    command -v "$1" &> /dev/null
}

kill_all_subprocesses() {

    local i=""

    for i in $(jobs -p); do
        kill "$i"
        wait "$i" &> /dev/null
    done

}

get_os() {

    local os=""
    local kernelName=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    kernelName="$(uname -s)"

    if [ "$kernelName" == "Darwin" ]; then
        os="macos"
    elif [ "$kernelName" == "Linux" ] && \
         [ -e "/etc/os-release" ]; then
        os="$(. /etc/os-release; printf "%s" "$ID")"
    else
        os="$kernelName"
    fi

    printf "%s" "$os"

}

get_os_name() {

    local os=""

    local version=""
    local id=""
    local int=""
    local name=""
    local envflag=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    os="$(get_os)"

    if [ "$os" == "macos" ]; then
        version="macos"
    elif [ -e "/etc/os-release" ]; then
        id="$(. /etc/os-release; printf "%s" "$ID")"

        # Check if it's Raspberry Pi OS (raspbian)
        if [ "$id" == "raspbian" ]; then
            version="raspberry-pi-os"
        else
            if [ -z "/mnt/c" ]; then
              envflag="-wsl"
            elif [ -z "$XDG_CURRENT_DESKTOP" ]; then
              envflag="-svr"
            else
              envflag="-wks"
            fi
            version_id="$(. /etc/os-release; printf "%s" "$VERSION_ID")"
            parts=(`echo $version_id | tr '.' ' '`)
            int=${parts[0]}
            version="$id""-""$int""$envflag"
        fi

    fi

    printf "%s" "$version"

}
get_os_version() {

    local os=""
    local version=""

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    os="$(get_os)"

    if [ "$os" == "macos" ]; then
        version="$(sw_vers -productVersion)"
    elif [ -e "/etc/os-release" ]; then
        version="$(. /etc/os-release; printf "%s" "$VERSION_ID")"
    fi

    printf "%s" "$version"

}

is_git_repository() {
    git rev-parse &> /dev/null
}

is_supported_version() {

    # shellcheck disable=SC2206
    declare -a v1=(${1//./ })
    # shellcheck disable=SC2206
    declare -a v2=(${2//./ })
    local i=""

    # Fill empty positions in v1 with zeros.
    for (( i=${#v1[@]}; i<${#v2[@]}; i++ )); do
        v1[i]=0
    done


    for (( i=0; i<${#v1[@]}; i++ )); do

        # Fill empty positions in v2 with zeros.
        if [[ -z ${v2[i]} ]]; then
            v2[i]=0
        fi

        if (( 10#${v1[i]} < 10#${v2[i]} )); then
            return 1
        elif (( 10#${v1[i]} > 10#${v2[i]} )); then
            return 0
        fi

    done

}

mkd() {
    if [ -n "$1" ]; then
        if [ -e "$1" ]; then
            if [ ! -d "$1" ]; then
                print_error "$1 - a file with the same name already exists!"
            else
                print_success "$1"
            fi
        else
            execute "mkdir -p $1" "$1"
        fi
    fi
}

set_trap() {

    trap -p "$1" | grep "$2" &> /dev/null \
        || trap '$2' "$1"

}

skip_questions() {

     while :; do
        case $1 in
            -y|--yes) return 0;;
                   *) break;;
        esac
        shift 1
    done

    return 1

}

# ------------------------------------------------------------------------------
# | Phase 0: Bootstrap and Setup Functions                                    |
# ------------------------------------------------------------------------------

# Download a file from a URL using curl or wget
download() {

    local url="$1"
    local output="$2"

    if command -v "curl" &> /dev/null; then

        curl \
            --location \
            --silent \
            --show-error \
            --output "$output" \
            "$url" \
                &> /dev/null

        return $?

    elif command -v "wget" &> /dev/null; then

        wget \
            --quiet \
            --output-document="$output" \
            "$url" \
                &> /dev/null

        return $?
    fi

    return 1

}

# Extract a gzipped tarball to a directory
extract() {

    local archive="$1"
    local outputDir="$2"

    if command -v "tar" &> /dev/null; then

        tar \
            --extract \
            --gzip \
            --file "$archive" \
            --strip-components 1 \
            --directory "$outputDir"

        return $?
    fi

    return 1

}

# Verify the operating system is supported and meets minimum version requirements
verify_os() {

    declare -r MINIMUM_MACOS_VERSION="10.10"
    declare -r MINIMUM_UBUNTU_VERSION="20.04"
    declare -r MINIMUM_RASPBERRY_PI_VERSION="10"

    local os_name="$(get_os)"
    local os_version="$(get_os_version)"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if the OS is `macOS` and
    # it's above the required version.

    if [ "$os_name" == "macos" ]; then

        if is_supported_version "$os_version" "$MINIMUM_MACOS_VERSION"; then
            return 0
        else
            printf "Sorry, this script is intended only for macOS %s+" "$MINIMUM_MACOS_VERSION"
        fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if the OS is `Ubuntu` and
    # it's above the required version.

    elif [ "$os_name" == "ubuntu" ]; then

        if is_supported_version "$os_version" "$MINIMUM_UBUNTU_VERSION"; then
            return 0
        else
            printf "Sorry, this script is intended only for Ubuntu %s+" "$MINIMUM_UBUNTU_VERSION"
        fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if the OS is `Raspberry Pi OS` (raspbian)
    # and it's above the required version.

    elif [ "$os_name" == "raspbian" ]; then

        if is_supported_version "$os_version" "$MINIMUM_RASPBERRY_PI_VERSION"; then
            return 0
        else
            printf "Sorry, this script is intended only for Raspberry Pi OS %s+" "$MINIMUM_RASPBERRY_PI_VERSION"
        fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    else
        printf "Sorry, this script is intended only for macOS, Ubuntu, and Raspberry Pi OS!"
    fi

    return 1

}

# Backup existing Bash configuration files before creating symlinks
backup_bash_files() {
    find "$HOME" -maxdepth 1 -name ".bash*" -type f | while IFS= read -r file; do
        # Skip files that are already backups (end with -original)
        if [[ "$file" == *-original* ]]; then
            continue
        fi

        # Only create backup if it doesn't already exist
        if [ -e "${file}-original" ]; then
            print_success "Backup of ${file} already exists (preserved)"
        else
            execute "cp $file ${file}-original" "Backup $file"
        fi
    done
}

# Create ~/.bash.local file for user-specific Bash configurations
create_bash_local() {

    declare -r FILE_PATH="$HOME/.bash.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

   if [ ! -e "$FILE_PATH" ]; then

        printf "%s\n" \
"#!/bin/bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Local Bash configurations (not tracked in version control)
# Add your custom aliases, functions, and environment variables here

# Example:
# export MY_CUSTOM_VAR=\"value\"
# alias myalias=\"command\"
" \
        >> "$FILE_PATH"
   fi

    print_result $? "$FILE_PATH"

}

# Create ~/.gitconfig.local file for user-specific Git settings
create_gitconfig_local() {

    declare -r FILE_PATH="$HOME/.gitconfig.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -e "$FILE_PATH" ] || [ -z "$FILE_PATH" ]; then

        printf "%s\n" \
"[commit]

    # Sign commits using GPG.
    # https://help.github.com/articles/signing-commits-using-gpg/

    # gpgsign = true


[user]

    name =
    email =
    # signingkey =" \
        >> "$FILE_PATH"
    fi

    print_result $? "$FILE_PATH"

}

# Create ~/.vimrc.local file for user-specific Vim customizations
create_vimrc_local() {

    declare -r FILE_PATH="$HOME/.vimrc.local"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ ! -e "$FILE_PATH" ]; then
        printf "" >> "$FILE_PATH"
    fi

    print_result $? "$FILE_PATH"

}

# Initialize Git repository in dotfiles directory and set remote origin
initialize_git_repository() {

    declare -r GIT_ORIGIN="$1"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [ -z "$GIT_ORIGIN" ]; then
        print_error "Please provide a URL for the Git origin"
        exit 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! is_git_repository; then

        # Run the following Git commands in the root of
        # the dotfiles directory, not in the `os/` directory.

        cd ../../ \
            || print_error "Failed to 'cd ../../'"

        execute \
            "git init && git remote add origin $GIT_ORIGIN" \
            "Initialize the Git repository"

    fi

}

# ------------------------------------------------------------------------------
# | Phase 1: File System Setup Functions                                      |
# ------------------------------------------------------------------------------

# Create symbolic links from dotfiles repository to home directory
# Uses hierarchical resolution: Only creates symlinks to MOST SPECIFIC version
# OS-specific files source their parent/generic versions internally
create_symlinks() {

    local os_name="$(get_os_name)"
    local script_dir="$(pwd)"
    local files_base_dir="${script_dir}/files"
    local skipQuestions=false

    # Files that Oh My Bash manages - we skip these
    # Note: We manage both bash_profile and bashrc ourselves to control NVM and OMB loading
    declare -a OMB_MANAGED_FILES=(
        "bash_prompt"
        "bash_autocompletion"
        "bash_colors"
    )

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    skip_questions "$@" \
        && skipQuestions=true

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Build hierarchy path array based on OS (ordered from general to specific)
    local -a hierarchy=("common")

    if [ "$os_name" == "macos" ]; then
        hierarchy+=("macos")
    elif [ "$os_name" == "raspberry-pi-os" ]; then
        hierarchy+=("pios")
    else
        # Ubuntu variants: ubuntu-24-svr, ubuntu-24-wks, etc.
        # Extract components: ubuntu, ubuntu-24, ubuntu-24-svr
        local os_base="${os_name%%-*}"  # ubuntu
        local os_version="${os_name%-*}"  # ubuntu-24

        hierarchy+=("$os_base")

        if [ "$os_version" != "$os_base" ]; then
            hierarchy+=("$os_version")
        fi

        if [ "$os_version" != "$os_name" ]; then
            hierarchy+=("$os_name")
        fi
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Build a map of files: target_path => most_specific_source_path
    # Later levels (more specific) override earlier levels
    declare -A file_map

    for level in "${hierarchy[@]}"; do
        local level_dir="${files_base_dir}/${level}"

        # Skip if directory doesn't exist
        if [ ! -d "$level_dir" ]; then
            continue
        fi

        # Find all files in this level (recursively)
        while IFS= read -r -d '' sourceFile; do

            # Get relative path from level directory
            local relPath="${sourceFile#$level_dir/}"

            # Build target path in home directory
            local targetFile="$HOME/.${relPath}"

            # Check if this file is managed by Oh My Bash
            local isOmbManaged=false
            local fileName="$(basename "$sourceFile")"
            for ombFile in "${OMB_MANAGED_FILES[@]}"; do
                if [ "$fileName" == "$ombFile" ] || [ ".$fileName" == "$ombFile" ]; then
                    isOmbManaged=true
                    break
                fi
            done

            if $isOmbManaged; then
                continue
            fi

            # Add/update the map with most specific version
            file_map["$targetFile"]="$sourceFile"

        done < <(find "$level_dir" -type f -print0)

    done

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Now create symlinks ONLY for the most specific version of each file
    for targetFile in "${!file_map[@]}"; do
        local sourceFile="${file_map[$targetFile]}"

        # Create target directory if needed
        local targetDir="$(dirname "$targetFile")"
        if [ ! -d "$targetDir" ]; then
            mkdir -p "$targetDir"
        fi

        # Create or update symlink
        if [ ! -e "$targetFile" ] || $skipQuestions; then

            execute \
                "ln -fs $sourceFile $targetFile" \
                "$targetFile → $sourceFile"

        elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
            print_success "$targetFile → $sourceFile"
        else

            if ! $skipQuestions; then

                ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
                if answer_is_yes; then

                    rm -rf "$targetFile"

                    execute \
                        "ln -fs $sourceFile $targetFile" \
                        "$targetFile → $sourceFile"

                else
                    print_error "$targetFile → $sourceFile"
                fi

            fi

        fi

    done

}
