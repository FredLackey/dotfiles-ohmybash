#!/bin/bash

# ~/.functions

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Clone a repository and install its dependencies.
#
# Usage example:
#
#   clone https://github.com/user/repo.git

clone() {
    git clone "$1" || return
    cd "$(basename "${1%.*}")" || return

    # Check if there are dependencies to be installed.
    if [ ! -f "package.json" ]; then
        return
    fi

    # Check if the project uses Yarn.
    if [ -f "yarn.lock" ] && command -v "yarn" > /dev/null; then
        printf "\n"
        yarn install
        return
    fi

    # If not, assume it uses npm.
    if command -v "npm" > /dev/null; then
        printf "\n"
        npm install
    fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Create data URI from a file.
#
# Usage example:
#
#   datauri image.png

datauri() {
    local mimeType=""

    if [ ! -f "$1" ]; then
        printf "%s is not a file.\n" "$1"
        return
    fi

    mimeType=$(file --brief --mime-type "$1")

    if [[ $mimeType == text/* ]]; then
        mimeType="$mimeType;charset=utf-8"
    fi

    printf "data:%s;base64,%s" \
        "$mimeType" \
        "$(openssl base64 -in "$1" | tr -d "\n")"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Delete files that match a certain pattern from the current directory.
#
# Usage example:
#
#   delete-files "*.log"  # Delete all .log files
#   delete-files          # Delete all .DS_Store files (default)

delete-files() {
    local q="${1:-*.DS_Store}"
    find . -type f -name "$q" -ls -delete
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Search history using grep and less.
#
# Usage example:
#
#   h "git commit"

h() {
    grep --color=always "$*" "$HISTFILE" \
        | less --no-init --raw-control-chars
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Search for text within the current directory using grep and less.
#
# Usage example:
#
#   s "my_variable"

s() {
    grep --color=always "$*" \
         --exclude-dir=".git" \
         --exclude-dir="node_modules" \
         --ignore-case \
         --recursive \
         . \
        | less --no-init --raw-control-chars
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Remove development artifact directories like `node_modules` and `bower_components`.
#
# Usage example:
#
#   clean-dev

clean-dev() {
    sudo find . -name "node_modules" -exec rm -rf '{}' +
    find . -name "bower_components" -exec rm -rf '{}' +
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set git user email and name to public defaults.
#
# Usage example:
#
#   set-git-public

set-git-public(){
    git config user.email "fred.lackey@gmail.com"
    git config user.name "Fred Lackey"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Organize files in the current directory into subdirectories based on date in filename.
#
# Usage example:
#
#   org-by-date

org-by-date(){
    ls -A1 | grep -E '[0-9]{4}-[0-9]{2}-[0-9]{2}' | while read -r line; do
        DNAME="$(echo $line | grep -Eo '[[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}' | sed 's#-#/#g')"
        mkdir -p "./$DNAME"
        mv "$line" "./$DNAME/"
    done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Pull changes and update git submodules.
#
# Usage example:
#
#   git-pup

git-pup(){
    git pull && git submodule init && git submodule update && git submodule status
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Clone a repository structure without the .git folder using rsync.
#
# Usage example:
#
#   git-clone /path/to/source/repo/

git-clone(){
    eval "rsync -av --progress $* ./ --exclude .git --exclude README.md --exclude LICENSE --exclude node_modules --exclude bower_components"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# A wrapper around `rm` to prevent accidental removal of root or top-level directories.
# Forbids removing '/', '/some_dir', '/*', or using '--no-preserve-root'.
#
# Usage example:
#
#   rm_safe file.txt directory/
#   rm_safe -rf old_files/

rm_safe() {
    # Iterate over the arguments
    for arg in "$@"; do
        # Check if the argument is the root directory "/"
        if [ "$arg" = "/" ]; then
            echo "Error: Attempt to remove the root directory is forbidden!"
            return 1
        fi

        # Check if the argument is any single directory in the root (e.g., "/bin", "/etc")
        if [[ "$arg" =~ ^/[^/]+$ ]]; then
            echo "Error: Attempt to remove a top-level directory is forbidden!"
            return 1
        fi

        # Check if the argument is the wildcard pattern "/*"
        if [ "$arg" = "/*" ]; then
            echo "Error: Attempt to remove all files and directories in the root is forbidden!"
            return 1
        fi
    done

    # Check if the arguments contain "--no-preserve-root"
    for arg in "$@"; do
        if [ "$arg" = "--no-preserve-root" ]; then
            echo "Error: Use of --no-preserve-root is forbidden!"
            return 1
        fi
    done

    # Run the actual rm command with the original arguments
    command rm "$@"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Add all changes, commit with a message, and push to the current branch.
#
# Usage example:
#
#   git-push "Fix bug #123"

git-push() {
    local usage="git-push \"commit message\""
    local message="$1"
    local current_branch
    local has_changes

    # Check if a commit message was provided
    if [ -z "$message" ]; then
        echo "Error: Commit message is required"
        echo "Usage: $usage"
        return 1
    fi

    # Check if we're in a git repository
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Error: Not in a git repository"
        return 1
    fi

    # Check for any changes (staged, unstaged, or untracked files)
    has_changes=$(git status --porcelain)
    if [ -z "$has_changes" ]; then
        echo "No changes detected in repository"
        return 0
    fi

    # Get current branch name
    current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    if [ -z "$current_branch" ]; then
        echo "Error: Could not determine current branch"
        return 1
    fi

    # Add all changes, commit with message, and push to current branch
    echo "Changes detected, proceeding with commit and push..."
    git add -A && \
    git commit -m "$message" && \
    git push origin "$current_branch"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Curl a URL, expecting JSON, and pretty-print the output using jq.
#
# Usage example:
#
#   ccurl https://api.example.com/data

ccurl() {
  if [ -z "$1" ]; then
    echo "Usage: ccurl <URL>"
    return 1
  fi
  curl -s -H "Accept: application/json" "$1" | jq
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Extract dependency names from a package.json file using jq.
#
# Usage examples:
#
#   get-dependencies ./package.json          # Get 'dependencies'
#   get-dependencies ./package.json dev      # Get 'devDependencies'
#   get-dependencies ../other/package.json peer # Get 'peerDependencies'

get-dependencies() {
    local package_json_path="$1"
    local dependency_type_prefix="${2:-dependencies}"
    local dependency_type=""

    # Check if jq is installed
    if ! command -v jq &> /dev/null; then
        echo "Error: jq command is not installed. Please install jq and try again."
        return 1
    fi

    # Check if a path was provided
    if [[ -z "$package_json_path" ]]; then
        echo "Usage: extract_dependencies /path/to/package.json [dependency_type_prefix]"
        echo "Example: extract_dependencies /path/to/package.json dev"
        return 1
    fi

    # Check if the package.json file exists
    if [[ ! -f "$package_json_path" ]]; then
        echo "Error: File not found: $package_json_path"
        return 1
    fi

    # Determine the full dependency type based on the prefix if provided
    if [[ -z "$dependency_type_prefix" ]]; then
        dependency_type="dependencies"
    else
        case "$dependency_type_prefix" in
            dev)
                dependency_type="devDependencies"
                ;;
            peer)
                dependency_type="peerDependencies"
                ;;
            opt)
                dependency_type="optionalDependencies"
                ;;
            bundle)
                dependency_type="bundledDependencies"
                ;;
            dependencies)
                dependency_type="dependencies"
                ;;
            *)
                echo "Error: Invalid dependency type prefix. Valid prefixes are: dev, peer, opt, bundle, dependencies."
                return 1
                ;;
        esac
    fi

    # Check if the dependency type node exists and is not null
    node_exists=$(jq -e --arg depType "$dependency_type" '.[$depType] != null' "$package_json_path")
    if [[ $? -ne 0 || "$node_exists" != "true" ]]; then
        return 0
    fi

    # Extract dependencies using jq
    dependencies=$(jq -r --arg depType "$dependency_type" '.[$depType] | keys[]?' "$package_json_path")
    if [[ -z "$dependencies" ]]; then
        return 0
    fi

    echo "$dependencies"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Install dependencies listed in a specified package.json file.
#
# Usage examples:
#
#   install-dependencies-from ../source/package.json        # Install 'dependencies'
#   install-dependencies-from ../source/package.json dev    # Install 'devDependencies' as dev dependencies

install-dependencies-from() {
    local package_json_path="$1"
    local dependency_type_prefix="${2:-dependencies}"
    local dependencies
    local npm_flag=""

    # Determine the npm flag based on the dependency type
    case "$dependency_type_prefix" in
        dev)
            npm_flag="--save-dev"
            ;;
        peer)
            npm_flag="--save-peer"
            ;;
        opt)
            npm_flag="--save-optional"
            ;;
        bundle)
            npm_flag="--save-bundled"
            ;;
        dependencies)
            npm_flag="--save"
            ;;
        *)
            echo "Error: Invalid dependency type prefix. Valid prefixes are: dev, peer, opt, bundle, dependencies."
            return 1
            ;;
    esac

    # Extract dependencies
    dependencies=$(get-dependencies "$package_json_path" "$dependency_type_prefix")

    if [[ -z "$dependencies" ]]; then
        echo "No dependencies to install."
        return 0
    fi

    # Install each dependency
    for dependency in $dependencies; do
        echo "Installing $dependency..."
        npm install "$dependency@latest" $npm_flag
    done
}
