# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a dotfiles management system built on **Oh My Bash** for managing shell configurations, system preferences, and package installations across multiple operating systems. The repository is undergoing a complete rebuild from a legacy system to a modern, maintainable architecture.

**Key Philosophy:**
- Leverage Oh My Bash framework instead of custom prompt/completion implementations
- Use industry-standard package managers (Homebrew, apt) instead of custom installers
- Organize by OS hierarchy: common → OS family → major version → edition
- Maximize code reuse through hierarchical inheritance

## Repository Status

**ACTIVE REBUILD IN PROGRESS** - This is a ground-up rewrite. The `_legacy/` folder contains the old system for reference. Do not modify legacy code.

## Architecture

### High-Level Structure

```
dotfiles-ohmybash/
├── src/
│   ├── setup.sh           # Main entry point (remote-executable)
│   ├── files/             # Config files to copy (dotfiles, app configs)
│   ├── installs/          # Package installation scripts
│   ├── preferences/       # OS preference configuration scripts
│   └── utils/             # Helper utilities and shared functions
├── docs/                  # Documentation
├── ai-docs/              # AI assistant notes and migration docs
├── _legacy/              # Original dotfiles (DO NOT MODIFY)
└── _archive/             # Experimental code (NOT USED)
```

### OS Hierarchy Pattern

All four `src/` subdirectories follow the same hierarchy from most general to most specific:

1. **common/** - Universal across all OSes
2. **{os}/** - OS family (macos, ubuntu, pios)
3. **{os}-{major-version}/** - Major version (ubuntu-24, macos-14)
4. **{os}-{major-version}-{edition}/** - Specific edition (ubuntu-24-svr, ubuntu-24-wks)

**Edition codes:**
- `svr` - Server (headless, no GUI)
- `wks` - Workstation (desktop with GUI)
- `wsl` - Windows Subsystem for Linux

**Resolution order:** Scripts execute from common → specific. Files at more specific levels override general ones.

### Target Operating Systems

**Currently Supported:**
- macOS (latest - Sonoma/Sequoia)
- Ubuntu 24.04 LTS (Server and Workstation)
- Raspberry Pi OS (Bookworm)

**Legacy (in `_legacy/` only):**
- Ubuntu 20.04, 22.04, 23.04

## Key Architectural Patterns

### main.sh Pattern

Every directory in `src/installs/` and `src/preferences/` MUST have a `main.sh` file as the entry point. These files must follow this pattern:

```bash
#!/bin/bash

main() {
    # ALL logic and variables go inside this function
    # NO variables outside the main() function
    local script_dir
    script_dir="$(dirname "${BASH_SOURCE[0]}")"

    # Source utilities
    source "${script_dir}/../utils/common/utils.sh"

    # Execute scripts in order
    # ...
}

main "$@"
```

### Remote Execution

`src/setup.sh` is designed for direct remote execution without cloning:

**macOS:**
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/fredlackey/dotfiles-ohmybash/main/src/setup.sh)"
```

**Ubuntu/Raspberry Pi OS:**
```bash
bash -c "$(wget -qO - https://raw.githubusercontent.com/fredlackey/dotfiles-ohmybash/main/src/setup.sh)"
```

## Oh My Bash Integration

This system is built on **Oh My Bash** (https://ohmybash.nntoan.com/), which provides:

- **70+ themes** - Customizable prompts with Git integration
- **24+ plugins** - Tool-specific aliases, completions, and helpers
- **Auto-update system** - Community-maintained framework updates
- **Custom directory** - `~/.oh-my-bash/custom/` for user customizations

**IMPORTANT:** Oh My Bash plugins provide aliases and helpers for tools but DO NOT install the tools themselves. Tools must be installed separately via the `src/installs/` scripts.

### What Oh My Bash Replaces

When working on this codebase, Oh My Bash replaces:
- Custom PS1/prompt configurations (use themes)
- Manual Git branch parsing (use Git plugin/themes)
- Hand-written autocomplete scripts (use completions)
- Custom color definitions (use Oh My Bash utilities)

See `ai-docs/ABOUT_OHMYBASH.md` for comprehensive Oh My Bash capabilities.

## Working with This Codebase

### Adding New OS Support

1. Create directories following the hierarchy pattern in all four `src/` subdirectories:
   - `src/files/{new-os}/`
   - `src/installs/{new-os}/`
   - `src/preferences/{new-os}/`
   - `src/utils/{new-os}/`

2. Create `main.sh` files in `installs/` and `preferences/` directories

3. Update `src/setup.sh` to detect and handle the new OS

### Adding New Packages

1. Determine the appropriate specificity level (common, OS family, version, edition)
2. Add installation logic to the appropriate `src/installs/{level}/main.sh`
3. Update `docs/INSTALLS.md` with the package listing
4. Use standard package managers - avoid custom installers

### Adding Configuration Files

1. Place files in `src/files/{level}/` at appropriate specificity
2. Preserve directory structure as it should appear in the target system
3. More specific files override general ones during setup

### Adding OS Preferences

1. Add preference scripts to `src/preferences/{level}/`
2. Use native OS tools (macOS `defaults`, Ubuntu `gsettings`)
3. Execute scripts in `main.sh` at appropriate hierarchy level

## Code Style

### Shell Scripts

- Use `#!/bin/bash` shebang (NOT `/bin/sh`)
- Follow the `main()` function pattern for all main.sh files
- Keep all variables inside the `main()` function
- Use `local` for function variables
- Use `"${variable}"` for variable expansion (quoted)
- Source utilities with absolute paths relative to script location

### EditorConfig

This repository uses EditorConfig:
- 2 spaces for indentation
- LF line endings
- UTF-8 encoding
- No trailing whitespace trimming (configured to `false`)
- No final newline insertion (configured to `false`)

### Naming Conventions

**Scripts:**
- `main.sh` - Entry point for a directory
- `setup.sh` - Orchestration script
- `{function}.sh` - Specific functional script

**Directories:**
- Use lowercase with hyphens
- Follow hierarchy pattern consistently

## Important Files

### Documentation

- `README.md` - Project overview and philosophy
- `docs/FILE_STRUCTURE.md` - Comprehensive directory organization guide
- `docs/INSTALLS.md` - Package installation reference
- `ai-docs/ABOUT_OHMYBASH.md` - Oh My Bash capabilities
- `ai-docs/BASH_FILE_OVERLAP.md` - Legacy to new system mapping
- `ai-docs/ALIASES.md` / `ALIASES_NEW.md` - Alias migration notes

### Core Scripts

- `src/setup.sh` - Main setup entry point (currently stub)
- `src/installs/{level}/main.sh` - Package installation orchestrators
- `src/preferences/{level}/main.sh` - Preference configuration orchestrators
- `src/utils/common/utils.sh` - Shared utility functions

## Development Workflow

### Testing Changes

1. Test at the most general level possible first (common)
2. Verify inheritance works correctly (specific levels override general)
3. Test on actual target OS - use VMs or containers for Ubuntu/Raspberry Pi OS
4. Ensure idempotency - scripts should be safe to run multiple times

### Making Changes

1. Identify correct hierarchy level for the change
2. Modify or create appropriate `main.sh` file
3. Update documentation if adding new features
4. Test on target OS
5. Commit with clear messages following Git history style

### What NOT to Do

- Do NOT modify files in `_legacy/` or `_archive/`
- Do NOT create custom implementations of features Oh My Bash provides
- Do NOT add package installations at too general a level (e.g., macOS-specific in common)
- Do NOT declare variables outside `main()` functions in main.sh files
- Do NOT use custom installers when package managers are available

## Common Tasks

### View git status and recent commits
```bash
git status
git log --oneline -10
```

### Run setup script locally (once implemented)
```bash
bash src/setup.sh
```

### Check Oh My Bash installation
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
```

### Find all main.sh files
```bash
find src/installs src/preferences -name "main.sh"
```

### Find shell scripts (excluding legacy)
```bash
find src -name "*.sh" -type f
```

## Package Installation Reference

Key packages installed across all systems:
- **NVM** with Node.js 22
- **Git** for version control
- **Vim** with minpac plugin manager
- **tmux** for terminal multiplexing
- **Docker** with Compose and Buildx plugins

See `docs/INSTALLS.md` for complete package listings per OS.

## Migration Notes

This repository is migrating from a legacy system with accumulated technical debt. The new approach:

**Old system issues:**
- Custom prompt implementations hard to maintain
- Scattered aliases across multiple files
- Mixed OS-specific code with shared code
- Custom installers instead of standard package managers
- Forked from another developer's opinionated setup

**New system benefits:**
- Oh My Bash handles prompt, completions, and Git integration
- Clear hierarchy from common to OS-specific
- Standard package managers (Homebrew, apt)
- Modular, maintainable structure
- Fresh start with modern best practices

When reviewing legacy code in `_legacy/`, consider whether Oh My Bash provides equivalent functionality before porting custom implementations.

## Additional Context

- Repository uses Git (main branch: `main`)
- Currently at commit: "eod" / "minor update"
- Recent work includes Ubuntu server bash_aliases fixes and setup-cicd.sh improvements
- No build/lint/test commands - this is a shell script collection, not a compiled project
- File names for markdown files are always snake case and uppercase with a lowercase extension.
- **IMPORTANT**: All new scripts and functions must be idempotent at all times.
- **IMPORTANT**: When copying functions from the _legacy codebase they must copied as-is without refactoring or making assumtions. They will be fine tuned later.
- **IMPORTANT**: Always read the markdown files in the repo for context while ignoring the root _archive and _legacy folders.
- **IMPORTANT**: The /src/installs/* and /src/preferences/* folders use main.sh entrypoint files. This file is meant to act as an orchestrator to call other scripts within that folder. While it is not neccessary to create these other files we should do so if the main.sh size becomes excessive.
- **IMPORTANT**: NEVER install or test anything on the local machine!!  This repo is tested on a remote computer.
- **CRITICAL**: NEVER interogate the local machine to make decisions or update the current machine.  The scripts in this repository are for a DIFFERENT COMPUTER!!!
- Each time an update is made to the src/ files they are tested on a virgin VM.  After the setup logic completes the terminal is restarted.