# Function Hierarchy Analysis

This document analyzes the legacy bash_functions files to determine the appropriate hierarchy level for each function in the new architecture.

## Key Findings

### Ubuntu Versions
All Ubuntu bash_functions files are **IDENTICAL** (MD5: 448bc78d20ce8d5282b722c10c3176de):
- `ubuntu-20-svr/bash_functions`
- `ubuntu-22-svr/bash_functions`
- `ubuntu-23-svr/bash_functions`
- `ubuntu-24-svr/bash_functions`
- `ubuntu-24-wks/bash_functions`
- `ubuntu-original/bash_functions`

**Recommendation**: All 40 functions in these files should be placed at `src/files/ubuntu/bash_functions` level, NOT at version-specific levels.

### Main bash_functions vs Ubuntu
The main `bash_functions` (MD5: e3bc15e332cf812e525de6ed527e72c3) differs from Ubuntu versions.

Main includes `dp()` (Docker) which Ubuntu versions have, plus all other Ubuntu functions.

## Recommended Function Hierarchy

### `src/files/common/bash_functions` (OS-Agnostic)

Functions that work identically across all operating systems without OS-specific commands:

- `clone()` - Clone git repo and install npm/yarn dependencies
- `datauri()` - Convert file to base64-encoded data URI
- `delete-files()` - Delete files matching a pattern
- `evm()` - Execute Vim macro multiple times
- `h()` - Search bash history with grep
- `rename-files-with-date-in-name()` - Standardize date formats in filenames
- `s()` - Recursively search for text (excludes git/node_modules)
- `clean-dev()` - Delete node_modules and bower_components directories
- `killni()` - Kill Node Inspector processes
- `vpush()` - Commit using package.json version as message
- `set-git-public()` - Set git user config to Fred Lackey's public email/name
- `org-by-date()` - Move files into subdirectories by date
- `get-course()` - Download Pluralsight course with yt-dlp
- `get-channel()` - Download YouTube channel videos
- `get-tunes()` - Download audio/video from URL
- `get-video()` - Download video in MP4 format
- `docker-clean()` - Remove all Docker containers/images/volumes
- `git-clone()` - Copy repository structure without .git
- `git-pup()` - Pull changes and update submodules
- `refresh-files()` - Overwrite target files from source
- `ncu-update-all()` - Update package.json dependencies
- `npmi()` - Clean install npm dependencies with Node v18
- `get-dependencies()` - Extract dependency names from package.json
- `install-dependencies-from()` - Install dependencies from another package.json
- `rm_safe()` - Safety wrapper for rm (prevents root deletion)
- `git-push()` - Stage all, commit, and push to current branch
- `ccurl()` - Fetch JSON from URL and pretty-print with jq
- `fetch-github-repos()` - Clone all repos from GitHub organization
- `git-backup()` - Create timestamped zip archive of git repo
- `mkd()` - Create directory and cd into it

### `src/files/ubuntu/bash_functions` (Ubuntu/Debian Specific)

Functions that use Linux/Ubuntu/Debian-specific commands but work across all Ubuntu versions:

- `backup-source()` - Backup ~/Source with rsync (uses Linux paths)
- `backup-all()` - Backup user directories with rsync (uses Linux paths)
- `get-folder()` - Copy files with rsync/robocopy (uses stat -c)
- `ips()` - Scan network with nmap (requires nmap, sudo)
- `talk()` - Text-to-speech with festival (uses xsel, festival - Linux)
- `remove_smaller_files()` - Compare directories and remove smaller duplicates
- `nginx-init()` - Generate nginx config (uses /etc/nginx/ paths)
- `certbot-init()` - Install Let's Encrypt SSL certificates
- `certbot-crontab-init()` - Add certbot renewal to crontab
- `resize-image()` - Resize image with ImageMagick (uses convert command)
- `claude-danger()` - Launch Claude CLI without permission checks

### `src/files/pios/bash_functions` (Raspberry Pi OS Specific)

Functions that use Raspberry Pi-specific hardware commands:

- `pi_temp()` - Display CPU temperature (uses vcgencmd)
- `pi_throttle()` - Check throttling status (uses vcgencmd)
- `pi_version()` - Display Pi model info (uses /proc/device-tree/model)
- `pi_info()` - Comprehensive Pi system info (uses vcgencmd)
- `server_status()` - Display server status (uses ss, /proc/)
- `git_current_branch()` - Display current Git branch
- `git_log_oneline()` - Display last 10 commits
- `git_status_short()` - Display Git status in short format

Note: `mkd()` and `rm_safe()` in Pi OS should be sourced from common/ instead.

### `src/files/macos/bash_functions` (macOS Specific)

Currently no macOS-specific functions identified. If `dp()` Docker function needs macOS-specific handling, it would go here. Otherwise source from common/.

### Functions Needing OS-Specific Implementations

Some functions may need different implementations per OS:

- `backup-source()` / `backup-all()` - Path differences between macOS and Linux
- `get-folder()` - Uses `stat -c` on Linux, `stat -f` on macOS
- `talk()` - Uses festival/xsel on Linux, might use `say` on macOS

## Migration Strategy

The setup process creates symlinks to the **most specific** bash_functions file for the target system. Each OS-specific file sources its parent in the hierarchy.

### File Hierarchy (each sources the parent level)

```
common/bash_functions                    # Base - 30 universal functions
  ↑
debian/bash_functions                    # Sources common/ + Debian-specific
  ↑
ubuntu/bash_functions                    # Sources debian/ + Ubuntu-specific (11 functions)
  ↑
ubuntu-24/bash_functions                 # Sources ubuntu/ + Ubuntu 24-specific
  ↑
ubuntu-24-srv/bash_functions             # Sources ubuntu-24/ + server-specific
```

Similarly for Raspberry Pi OS:
```
common/bash_functions                    # Base - 30 universal functions
  ↑
debian/bash_functions                    # Sources common/ + Debian-specific
  ↑
pios/bash_functions                      # Sources debian/ + Pi-specific (9 functions)
  ↑
pios-5-srv/bash_functions                # Sources pios/ + version/edition-specific
```

And for macOS:
```
common/bash_functions                    # Base - 30 universal functions
  ↑
macos/bash_functions                     # Sources common/ + macOS-specific
  ↑
macos-15/bash_functions                  # Sources macos/ + version-specific
```

### Implementation Steps

1. **Populate `src/files/common/bash_functions`** with all OS-agnostic functions (30 functions)
2. **Create `src/files/debian/bash_functions`** that sources common/ and adds Debian-specific functions
3. **Create `src/files/ubuntu/bash_functions`** that sources debian/ and adds Ubuntu-specific functions (11 functions)
4. **Create version-specific files** (ubuntu-24/, ubuntu-24-srv/, etc.) that source their parent and add any version/edition-specific overrides
5. **Create `src/files/pios/bash_functions`** that sources debian/ and adds Pi-specific functions (9 functions)
6. **Create Pi version-specific files** (pios-5-srv/, etc.) that source pios/
7. **Create `src/files/macos/bash_functions`** that sources common/
8. **Create macOS version-specific files** (macos-15/, etc.) that source macos/

### Version-Specific Files

Even though current Ubuntu versions have identical functions, **version-specific files must still exist** as entry points for the symlink system. They may be simple files that just source the parent:

```bash
#!/bin/bash
# Source parent Ubuntu functions
source "${HOME}/.config/bash/ubuntu/bash_functions"

# Add ubuntu-24-srv specific functions here (if any)
```

This pattern allows for:
- Future version-specific overrides
- Clear hierarchy for inheritance
- Consistent symlink target naming
- Easy addition of edition-specific functions (srv vs wks vs wsl)

## Implementation Notes

- Functions should be copied as-is from legacy without refactoring (per CLAUDE.md guidelines)
- Each OS-specific file should source the parent level file first
- Use proper main() function pattern if needed for sourcing logic
- Functions with OS-specific commands should be placed at the appropriate OS level
- Functions that work identically everywhere should be in common/
