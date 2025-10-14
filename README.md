# Dotfiles - Oh My Bash Edition

A complete rebuild of my dotfiles repository using [Oh My Bash](https://ohmybash.nntoan.com/) as the foundation, with OS-specific configurations for macOS, Ubuntu, and Raspberry Pi OS.

## Quick Start

**macOS:**
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/fredlackey/dotfiles-ohmybash/main/src/setup.sh)"
```

**Ubuntu/Raspberry Pi OS:**
```bash
bash -c "$(wget -qO - https://raw.githubusercontent.com/fredlackey/dotfiles-ohmybash/main/src/setup.sh)"
```

The setup process will:
1. Detect operating system and environment type
2. Install Oh My Bash with custom theme and plugins
3. Run OS-specific package installations
4. Configure system preferences
5. Create symlinks for configuration files
6. Set up development environments (Node.js via nvm, etc.)

## Project Status

**ACTIVE REBUILD IN PROGRESS**

This repository is a ground-up rewrite of my dotfiles system. The previous implementation (_legacy folder) had accumulated significant technical debt through years of forking, customization drift, and custom implementations of features that now have better industry-standard solutions.

### Why a Complete Rebuild?

**The Problem:**
- Original repo was forked from another developer's opinionated configurations
- Years of modifications created a tangled web of custom scripts
- Custom implementations for prompts, autocomplete, Git integration, etc. were hard to maintain
- Attempting to refactor the existing codebase would result in an unmaintainable hybrid system

**The Solution:**
- Fresh start using **Oh My Bash** as the core framework
- Leverage community-maintained plugins and themes instead of custom implementations
- Use industry-standard installers (Homebrew, apt, etc.) instead of custom installation scripts
- Clean, modular structure organized by OS with clear separation of concerns

## What's Different

### Before (Legacy System)
- Custom Bash prompt configuration with manual color codes and Git parsing
- Hand-written autocomplete scripts for various tools
- Scattered aliases across multiple files
- Custom Git integration functions
- OS-specific configurations mixed with shared code
- Manual update mechanisms
- Difficult to test and maintain

### After (Oh My Bash System)
- **Oh My Bash themes** for prompt customization (70+ options)
- **Community-maintained plugins** for tool integration (24+ plugins)
- **Organized alias categories** following Oh My Bash conventions
- **Built-in Git integration** through themes and plugins
- **Clear OS separation** with shared Oh My Bash foundation
- **Automatic updates** via Oh My Bash's update system
- **Modular design** - enable/disable features easily

## Repository Structure

```
dotfiles-ohmybash/
├── README.md                 # This file
├── _legacy/                  # Original dotfiles (preserved for reference)
│   ├── src/
│   │   ├── git/
│   │   ├── shell/
│   │   ├── vim/
│   │   ├── os/
│   │   │   ├── installs/
│   │   │   └── preferences/
│   │   └── ...
│   └── README.md
├── _archive/                 # Experimental sandbox approach (not used)
├── ai-docs/                  # Documentation and notes
│   ├── ABOUT_OHMYBASH.md    # Oh My Bash capabilities and features
│   ├── ALIASES.md           # Legacy aliases documentation
│   ├── ALIASES_NEW.md       # New aliases approach
│   └── BASH_FILE_OVERLAP.md # File mapping documentation
└── (future structure)
    ├── install/              # OS-specific installation scripts
    │   ├── macos/
    │   ├── ubuntu-24-wks/
    │   ├── ubuntu-24-svr/
    │   └── raspberry-pi-os/
    ├── config/               # Configuration files
    │   ├── oh-my-bash/      # Oh My Bash customizations
    │   ├── git/
    │   └── vim/
    └── setup.sh             # Main setup script
```

## Philosophy

### 1. Industry Standards First
Use well-maintained, community-driven tools rather than reinventing the wheel:
- **Oh My Bash** for shell framework
- **Homebrew** (macOS) and **apt** (Ubuntu) for package management
- **nvm** for Node.js version management
- Standard installers for language runtimes and tools

### 2. OS-Specific When Necessary
Maintain separate configurations for different operating systems while maximizing code reuse:
- macOS-specific preferences and installations
- Ubuntu Server (headless) configurations
- Ubuntu Workstation (desktop) configurations
- Raspberry Pi OS optimizations

### 3. Modularity and Clarity
- Enable/disable features through simple configuration
- Clear separation between framework (Oh My Bash) and custom code
- Well-documented customizations in Oh My Bash's `custom/` directory
- No "magic" - explicit is better than implicit

### 4. Maintainability
- Reduce custom code surface area
- Leverage community maintenance for common functionality
- Keep custom code simple and well-documented
- Regular updates through Oh My Bash's built-in mechanism

## Oh My Bash Integration

### What Oh My Bash Provides

**Themes (70+)**
- Custom prompt designs with Git integration
- Branch, status, and change indicators
- Python virtualenv and Spack environment display
- Color schemes and visual customization

**Plugins (24+)**
- Tool-specific aliases and functions (Git, Docker, Node.js, Python, etc.)
- Tab completion for command-line tools
- Environment integration and workflow helpers
- Note: Plugins provide helpers for tools, they don't install the tools themselves

**Aliases**
- Organized by category (shell, package managers, development tools)
- Consistent naming conventions
- Easy to extend with custom aliases

**Auto-Update System**
- Keep framework up-to-date automatically
- Community improvements and bug fixes
- Configurable update behavior

### What We Customize

The Oh My Bash `custom/` directory contains our unique requirements:
- Organization-specific aliases
- Custom functions not available in standard plugins
- Environment-specific configurations
- Local overrides and extensions

## Target Operating Systems

### macOS (Primary Development Environment)
- Full desktop environment with GUI applications
- Homebrew package management
- Development tools and utilities
- macOS-specific system preferences

### Ubuntu 24.04 LTS Workstation
- Desktop environment with GUI
- Development tools
- Docker and containerization support
- apt package management

### Ubuntu 24.04 LTS Server
- Headless server configuration
- Minimal package installation
- Server utilities and tools
- Remote administration focus

### Raspberry Pi OS
- ARM-optimized configurations
- Lightweight tooling
- IoT and edge computing use cases

### Legacy Support (in _legacy folder)
- Ubuntu 20.04, 22.04, 23.04
- Previous configuration approaches
- Preserved for reference and migration

## Migration Strategy

### From Legacy System

The migration is happening in phases:

**Phase 1: Framework Setup (Current)**
- Install Oh My Bash as the foundation
- Configure base theme and essential plugins
- Document Oh My Bash capabilities and migration path

**Phase 2: Core Functionality**
- Migrate essential aliases from legacy system
- Port custom functions to Oh My Bash custom/ directory
- Set up OS detection and conditional loading

**Phase 3: OS-Specific Installations**
- Create installation scripts for each target OS
- Use standard package managers (no custom installers)
- Test on each supported platform

**Phase 4: Preferences and Configurations**
- Port system preferences (macOS defaults, Ubuntu settings)
- Configure Git, Vim, tmux, etc.
- Set up application preferences

**Phase 5: Testing and Refinement**
- Test on clean installations of each OS
- Document any manual steps required
- Create CI/CD workflows for validation

**Phase 6: Deprecation**
- Mark legacy system as archived
- Update documentation
- Provide migration guide for existing users

## What's Not Migrated

Some legacy features are intentionally NOT being migrated:

**Custom Implementations Replaced by Oh My Bash:**
- Custom prompt configurations (use Oh My Bash themes)
- Manual Git branch parsing (use Git plugin/themes)
- Hand-written autocomplete scripts (use Oh My Bash completions)
- Custom color definitions (use Oh My Bash color utilities)

**Obsolete or Unused Features:**
- Configurations for unsupported OS versions
- Rarely-used custom functions
- Experimental features from _archive
- Over-engineered solutions with simpler alternatives

## Documentation

- **ai-docs/ABOUT_OHMYBASH.md** - Complete Oh My Bash capabilities guide
- **ai-docs/ALIASES.md** - Legacy alias documentation
- **ai-docs/ALIASES_NEW.md** - New alias strategy
- **ai-docs/BASH_FILE_OVERLAP.md** - File mapping between old and new systems
- **_legacy/README.md** - Original dotfiles documentation

## Contributing

This is a personal dotfiles repository, but if you're interested in the approach:

1. Fork the repository
2. Adapt the OS-specific configurations to your needs
3. Customize Oh My Bash theme and plugins in your fork
4. Update installation scripts with your preferred applications

## License

MIT License - Feel free to use this as inspiration for your own dotfiles setup.

## Resources

- [Oh My Bash](https://ohmybash.nntoan.com/) - Shell configuration framework
- [Oh My Bash GitHub](https://github.com/ohmybash/oh-my-bash) - Source code and documentation
- [Homebrew](https://brew.sh/) - macOS package manager
- [Dotfiles community](https://dotfiles.github.io/) - Inspiration and examples

## Acknowledgments

- **Oh My Bash community** - For the excellent framework
- **Original dotfiles author** - For the initial foundation (preserved in _legacy)
- **Homebrew contributors** - For the best macOS package manager
- **Open source community** - For the tools that make development better

---

**Current Status:** Active development - framework selection complete, beginning implementation phase.

**Next Steps:** Create base Oh My Bash configuration and OS-specific installation scripts.
