# Legacy Bash Functions Files

This document lists the locations of bash_functions files in the `_legacy/` folder for reference during migration.

**See [FUNCTIONS_MIGRATION.md](FUNCTIONS_MIGRATION.md) for the deduplicated migration plan showing which functions should be copied to which files in `src/files/`.**

## Summary

- **41 universal functions** → `src/files/common/bash_functions`
- **5 Ubuntu/Linux functions** → `src/files/ubuntu/bash_functions`
- **4 Raspberry Pi functions** → `src/files/pios/bash_functions`
- **0 macOS functions** (none currently, all legacy functions are universal)

## Legacy bash_functions File Paths

### `_legacy/src/shell/bash_functions`

- `dp()` - Display Docker containers in a formatted table (ID, name, ports)
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
- `talk()` - Convert selected text to speech using festival text-to-speech
- `remove_smaller_files()` - Compare two directories and delete smaller duplicate files
- `npmi()` - Clean install npm dependencies using Node.js v18
- `get-dependencies()` - Extract dependency names from package.json (dependencies/devDependencies/etc.)
- `install-dependencies-from()` - Install dependencies from another project's package.json
- `rm_safe()` - Safety wrapper for rm preventing deletion of root/system directories
- `git-push()` - Stage all changes, commit with message, and push to current branch
- `ccurl()` - Fetch JSON from URL and pretty-print with jq
- `fetch-github-repos()` - Clone all repositories from a GitHub organization
- `git-backup()` - Create timestamped zip archive of git repository (mirror clone)
- `nginx-init()` - Generate nginx reverse proxy config from template with domain/host
- `certbot-init()` - Request and install Let's Encrypt SSL certificates for nginx domains
- `certbot-crontab-init()` - Add automatic certificate renewal to crontab (daily at noon)
- `claude-danger()` - Launch Claude CLI with permission checks disabled

### `_legacy/src/shell/raspberry-pi-os/bash_functions`

- `mkd()` - Create a new directory and change into it (mkdir + cd)
- `rm_safe()` - Safety wrapper for rm preventing deletion of root/system directories
- `pi_temp()` - Display Raspberry Pi CPU temperature using vcgencmd
- `pi_throttle()` - Check Raspberry Pi throttling status using vcgencmd
- `pi_version()` - Display Raspberry Pi model information
- `pi_info()` - Display comprehensive Raspberry Pi system information (model, temp, throttle, uptime, memory, disk)
- `server_status()` - Display server status information (uptime, load, memory, disk, network)
- `git_current_branch()` - Display the current Git branch name
- `git_log_oneline()` - Display last 10 Git commits in oneline format
- `git_status_short()` - Display Git status in short format with branch info

### `_legacy/src/shell/ubuntu-20-svr/bash_functions`

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
- `talk()` - Convert selected text to speech using festival text-to-speech
- `remove_smaller_files()` - Compare two directories and delete smaller duplicate files
- `npmi()` - Clean install npm dependencies using Node.js v18
- `get-dependencies()` - Extract dependency names from package.json (dependencies/devDependencies/etc.)
- `install-dependencies-from()` - Install dependencies from another project's package.json
- `rm_safe()` - Safety wrapper for rm preventing deletion of root/system directories
- `git-push()` - Stage all changes, commit with message, and push to current branch
- `ccurl()` - Fetch JSON from URL and pretty-print with jq
- `fetch-github-repos()` - Clone all repositories from a GitHub organization
- `git-backup()` - Create timestamped zip archive of git repository (mirror clone)
- `nginx-init()` - Generate nginx reverse proxy config from template with domain/host
- `certbot-init()` - Request and install Let's Encrypt SSL certificates for nginx domains
- `certbot-crontab-init()` - Add automatic certificate renewal to crontab (daily at noon)
- `claude-danger()` - Launch Claude CLI with permission checks disabled

### `_legacy/src/shell/ubuntu-22-svr/bash_functions`

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
- `talk()` - Convert selected text to speech using festival text-to-speech
- `remove_smaller_files()` - Compare two directories and delete smaller duplicate files
- `npmi()` - Clean install npm dependencies using Node.js v18
- `get-dependencies()` - Extract dependency names from package.json (dependencies/devDependencies/etc.)
- `install-dependencies-from()` - Install dependencies from another project's package.json
- `rm_safe()` - Safety wrapper for rm preventing deletion of root/system directories
- `git-push()` - Stage all changes, commit with message, and push to current branch
- `ccurl()` - Fetch JSON from URL and pretty-print with jq
- `fetch-github-repos()` - Clone all repositories from a GitHub organization
- `git-backup()` - Create timestamped zip archive of git repository (mirror clone)
- `nginx-init()` - Generate nginx reverse proxy config from template with domain/host
- `certbot-init()` - Request and install Let's Encrypt SSL certificates for nginx domains
- `certbot-crontab-init()` - Add automatic certificate renewal to crontab (daily at noon)
- `claude-danger()` - Launch Claude CLI with permission checks disabled

### `_legacy/src/shell/ubuntu-23-svr/bash_functions`

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
- `talk()` - Convert selected text to speech using festival text-to-speech
- `remove_smaller_files()` - Compare two directories and delete smaller duplicate files
- `npmi()` - Clean install npm dependencies using Node.js v18
- `get-dependencies()` - Extract dependency names from package.json (dependencies/devDependencies/etc.)
- `install-dependencies-from()` - Install dependencies from another project's package.json
- `rm_safe()` - Safety wrapper for rm preventing deletion of root/system directories
- `git-push()` - Stage all changes, commit with message, and push to current branch
- `ccurl()` - Fetch JSON from URL and pretty-print with jq
- `fetch-github-repos()` - Clone all repositories from a GitHub organization
- `git-backup()` - Create timestamped zip archive of git repository (mirror clone)
- `nginx-init()` - Generate nginx reverse proxy config from template with domain/host
- `certbot-init()` - Request and install Let's Encrypt SSL certificates for nginx domains
- `certbot-crontab-init()` - Add automatic certificate renewal to crontab (daily at noon)
- `claude-danger()` - Launch Claude CLI with permission checks disabled

### `_legacy/src/shell/ubuntu-24-svr/bash_functions`

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
- `talk()` - Convert selected text to speech using festival text-to-speech
- `remove_smaller_files()` - Compare two directories and delete smaller duplicate files
- `npmi()` - Clean install npm dependencies using Node.js v18
- `get-dependencies()` - Extract dependency names from package.json (dependencies/devDependencies/etc.)
- `install-dependencies-from()` - Install dependencies from another project's package.json
- `rm_safe()` - Safety wrapper for rm preventing deletion of root/system directories
- `git-push()` - Stage all changes, commit with message, and push to current branch
- `ccurl()` - Fetch JSON from URL and pretty-print with jq
- `fetch-github-repos()` - Clone all repositories from a GitHub organization
- `git-backup()` - Create timestamped zip archive of git repository (mirror clone)
- `nginx-init()` - Generate nginx reverse proxy config from template with domain/host
- `certbot-init()` - Request and install Let's Encrypt SSL certificates for nginx domains
- `certbot-crontab-init()` - Add automatic certificate renewal to crontab (daily at noon)
- `claude-danger()` - Launch Claude CLI with permission checks disabled

### `_legacy/src/shell/ubuntu-24-wks/bash_functions`

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
- `talk()` - Convert selected text to speech using festival text-to-speech
- `remove_smaller_files()` - Compare two directories and delete smaller duplicate files
- `npmi()` - Clean install npm dependencies using Node.js v18
- `get-dependencies()` - Extract dependency names from package.json (dependencies/devDependencies/etc.)
- `install-dependencies-from()` - Install dependencies from another project's package.json
- `rm_safe()` - Safety wrapper for rm preventing deletion of root/system directories
- `git-push()` - Stage all changes, commit with message, and push to current branch
- `ccurl()` - Fetch JSON from URL and pretty-print with jq
- `fetch-github-repos()` - Clone all repositories from a GitHub organization
- `git-backup()` - Create timestamped zip archive of git repository (mirror clone)
- `nginx-init()` - Generate nginx reverse proxy config from template with domain/host
- `certbot-init()` - Request and install Let's Encrypt SSL certificates for nginx domains
- `certbot-crontab-init()` - Add automatic certificate renewal to crontab (daily at noon)
- `claude-danger()` - Launch Claude CLI with permission checks disabled

### `_legacy/src/shell/ubuntu-original/bash_functions`

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
- `talk()` - Convert selected text to speech using festival text-to-speech
- `remove_smaller_files()` - Compare two directories and delete smaller duplicate files
- `npmi()` - Clean install npm dependencies using Node.js v18
- `get-dependencies()` - Extract dependency names from package.json (dependencies/devDependencies/etc.)
- `install-dependencies-from()` - Install dependencies from another project's package.json
- `rm_safe()` - Safety wrapper for rm preventing deletion of root/system directories
- `git-push()` - Stage all changes, commit with message, and push to current branch
- `ccurl()` - Fetch JSON from URL and pretty-print with jq
- `fetch-github-repos()` - Clone all repositories from a GitHub organization
- `git-backup()` - Create timestamped zip archive of git repository (mirror clone)
- `nginx-init()` - Generate nginx reverse proxy config from template with domain/host
- `certbot-init()` - Request and install Let's Encrypt SSL certificates for nginx domains
- `certbot-crontab-init()` - Add automatic certificate renewal to crontab (daily at noon)
- `claude-danger()` - Launch Claude CLI with permission checks disabled
