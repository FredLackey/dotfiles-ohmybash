#!/bin/bash

cd "$(dirname "${BASH_SOURCE[0]}")" \
    && . "utils.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

backup_bash() {

    find "$HOME" -type f -name ".bash*" | while read -r file; do
        # Construct the new file name with the "-original" suffix
        new_file="${file}-original"

        # Copy the original file to the new file
        cp "$file" "$new_file"

        # Print a message indicating the file has been copied
        echo "Copied $file to $new_file"
    done

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
    print_in_purple "\n • Backup Original Bash Files\n\n"
    backup_bash "$@"
}

main "$@"
