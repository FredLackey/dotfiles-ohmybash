# Bash Functions Migration Plan

This document maps legacy bash functions to their target locations in the new `src/files/` hierarchy.

## Target File Structure

```
src/files/
├── common/bash_functions          # Universal functions (all OSes)
├── macos/bash_functions           # macOS-specific functions
├── ubuntu/bash_functions          # Ubuntu-specific functions (server + workstation)
├── pios/bash_functions            # Raspberry Pi OS-specific functions
└── debian/bash_functions          # Debian-specific functions (if needed)
```

## Functions by Target Location

### `src/files/common/bash_functions` - Universal Functions

These functions work across all operating systems (macOS, Ubuntu, Raspberry Pi OS):

- `clone()` - Clone a git repository and automatically install npm/yarn dependencies
- `datauri()` - Convert a file to a base64-encoded data URI for embedding
- `delete-files()` - Delete files matching a pattern (defaults to .DS_Store files)
- `evm()` - Execute a Vim macro 'q' multiple times on specified files
- `h()` - Search bash history with grep and display results in less
- `rename-files-with-date-in-name()` - Standardize filenames containing dates to YYYY-MM-DD HH.MM.SS format
- `resize-image()` - Resize an image using ImageMagick with high-quality filtering
- `s()` - Recursively search for text in current directory excluding git/node_modules
- `clean-dev()` - Recursively delete all node_modules and bower_components directories
- `killni()` - Kill all running Node Inspector debug processes
- `vpush()` - Commit and push changes using package.json version as commit message
- `set-git-public()` - Set git user config to Fred Lackey's public email/name
- `backup-source()` - Backup ~/Source directory to specified location with rsync
- `backup-all()` - Backup multiple user directories (Desktop, Documents, etc.) with rsync
- `org-by-date()` - Move files into subdirectories based on YYYY-MM-DD dates in filenames
- `get-course()` - Download a Pluralsight course with yt-dlp (requires credentials)
- `get-channel()` - Download all videos from a YouTube channel with yt-dlp
- `get-tunes()` - Download audio/video from URL with options for audio-only or video-only
- `get-video()` - Download video from URL in MP4 format using yt-dlp
- `get-folder()` - Copy files between directories, skipping files with matching sizes
- `docker-clean()` - Remove all Docker containers, images, and volumes (with confirmation)
- `git-clone()` - Copy repository structure excluding .git, README, LICENSE, and dependencies
- `git-pup()` - Pull changes and initialize/update git submodules
- `ips()` - Scan local network for active IP addresses using nmap
- `refresh-files()` - Overwrite files in target directory from source (protects critical files)
- `ncu-update-all()` - Update all package.json and bower.json dependencies to latest versions
- `remove_smaller_files()` - Compare two directories and delete smaller duplicate files
- `npmi()` - Clean install npm dependencies using Node.js v18
- `get-dependencies()` - Extract dependency names from package.json (dependencies/devDependencies/etc.)
- `install-dependencies-from()` - Install dependencies from another project's package.json
- `rm_safe()` - Safety wrapper for rm preventing deletion of root/system directories
- `git-push()` - Stage all changes, commit with message, and push to current branch
- `ccurl()` - Fetch JSON from URL and pretty-print with jq
- `fetch-github-repos()` - Clone all repositories from a GitHub organization
- `git-backup()` - Create timestamped zip archive of git repository (mirror clone)
- `dp()` - Display Docker containers in a formatted table (ID, name, ports)
- `mkd()` - Create a new directory and change into it (mkdir + cd)
- `git_current_branch()` - Display the current Git branch name
- `git_log_oneline()` - Display last 10 Git commits in oneline format
- `git_status_short()` - Display Git status in short format with branch info
- `claude-danger()` - Launch Claude CLI with permission checks disabled

**Total: 41 functions**

### `src/files/ubuntu/bash_functions` - Ubuntu-Specific Functions

These functions use Ubuntu/Debian-specific tools or paths:

- `nginx-init()` - Generate nginx reverse proxy config from template with domain/host
- `certbot-init()` - Request and install Let's Encrypt SSL certificates for nginx domains
- `certbot-crontab-init()` - Add automatic certificate renewal to crontab (daily at noon)
- `talk()` - Convert selected text to speech using festival text-to-speech (requires X server)
- `server_status()` - Display server status information (uptime, load, memory, disk, network)

**Total: 5 functions**

**Note:** These functions could also be used on Raspberry Pi OS (which is Debian-based), so consider whether they should be in a `debian/bash_functions` file instead, or duplicated in `pios/bash_functions`.

### `src/files/pios/bash_functions` - Raspberry Pi OS-Specific Functions

These functions use Raspberry Pi-specific tools (vcgencmd, device-tree):

- `pi_temp()` - Display Raspberry Pi CPU temperature using vcgencmd
- `pi_throttle()` - Check Raspberry Pi throttling status using vcgencmd
- `pi_version()` - Display Raspberry Pi model information
- `pi_info()` - Display comprehensive Raspberry Pi system information (model, temp, throttle, uptime, memory, disk)

**Total: 4 functions**

**Note:** Raspberry Pi OS also had `server_status()` which is listed under Ubuntu-specific. Consider adding it here as well.

### `src/files/macos/bash_functions` - macOS-Specific Functions

Currently, no functions are exclusively macOS-specific from the legacy codebase. All functions use universal Unix tools.

**Total: 0 functions**

**Note:** If macOS-specific functions are needed in the future (e.g., using `defaults` command, Homebrew-specific operations, etc.), they would go here.

## Migration Notes

1. **Duplicate Functions Across Legacy Files**: The analysis shows that Ubuntu 20/22/23/24 server and workstation editions all have identical bash_functions files. This indicates these should all be consolidated into the common file.

2. **Raspberry Pi OS Functions**: Some functions like `mkd()`, `git_current_branch()`, `git_log_oneline()`, and `git_status_short()` appear in the Raspberry Pi OS file but are actually universal and should go in common.

3. **Linux Server Functions**: `nginx-init()`, `certbot-init()`, and `certbot-crontab-init()` are server-specific and may be better suited for `ubuntu-24-srv/bash_functions` rather than the general `ubuntu/bash_functions` if they're only used on servers.

4. **Tool Dependencies**: Many "universal" functions depend on tools that may not be installed by default:
   - `ips()` requires `nmap`
   - `resize-image()` requires ImageMagick
   - `get-*()` functions require `yt-dlp`
   - `talk()` requires `xsel` and `festival`
   - `ccurl()` and `fetch-github-repos()` require `jq`
   - `ncu-update-all()` requires `ncu` (npm-check-updates)

   These should be documented in the installation scripts.

5. **rm_safe() Already Exists**: The `src/files/common/bash_functions` file already has a stub for `rm_safe()` that should be replaced with the full implementation from the legacy files.

## Recommended File Hierarchy

Based on this analysis, create the following bash_functions files:

```
src/files/
├── common/bash_functions          # 41 universal functions
├── ubuntu/bash_functions          # 3 Ubuntu/Linux-specific functions (nginx, certbot)
├── ubuntu-24-srv/bash_functions   # 1 server-specific function (server_status)
├── pios/bash_functions            # 4 + 1 Raspberry Pi-specific (pi_* + server_status)
└── macos/bash_functions           # (create if needed for future macOS-specific functions)
```

## Implementation Order

1. **Phase 1**: Update `src/files/common/bash_functions` with all 41 universal functions
2. **Phase 2**: Create `src/files/ubuntu/bash_functions` with nginx/certbot functions
3. **Phase 3**: Create `src/files/pios/bash_functions` with Raspberry Pi-specific functions
4. **Phase 4**: Create `src/files/ubuntu-24-srv/bash_functions` with server_status() or add to pios
5. **Phase 5**: Update documentation to reflect which functions are available on which systems
