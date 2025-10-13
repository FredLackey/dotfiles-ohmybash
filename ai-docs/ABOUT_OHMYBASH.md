# About Oh My Bash

## Overview

Oh My Bash is an open-source, community-driven framework for managing Bash configuration. It's inspired by Oh My Zsh but built specifically for the Bourne Again Shell (Bash). The framework simplifies shell customization through a modular plugin and theme system.

**Project Information:**
- GitHub: https://github.com/ohmybash/oh-my-bash
- Website: https://ohmybash.nntoan.com/
- License: MIT
- Community: 135+ contributors, 7k+ stars

## Core Capabilities

### 1. Themes (70+)

Oh My Bash includes over 70 pre-built themes that customize the command prompt appearance and behavior.

**Theme Features:**
- Custom prompt designs with color schemes
- Git integration showing branch, status, and changes
- Python virtual environment display (configurable via `OMB_PROMPT_SHOW_PYTHON_VENV`)
- Spack environment information (configurable via `OMB_PROMPT_SHOW_SPACK_ENV`)
- Random theme selection on shell startup
- Easy theme switching via `OSH_THEME` variable in `~/.bashrc`

**Popular Themes:**
- `font` (default)
- `agnoster` (requires Powerline fonts)
- `af-magic`
- `daveverwer`
- `eastwood`
- `kolo`
- `mh`
- `nebirhos`
- `minimal-gh`
- `powerline-light`

**Theme Configuration:**
```bash
# Set a specific theme
OSH_THEME="agnoster"

# Random theme on each session
OSH_THEME="random"

# Random from specific candidates
OMB_THEME_RANDOM_CANDIDATES=("font" "powerline-light" "minimal")

# Ignore specific themes from random selection
OMB_THEME_RANDOM_IGNORED=("powerbash10k" "wanelo")

# Check which random theme was selected
echo "$OMB_THEME_RANDOM_SELECTED"
```

### 2. Plugins (24+)

Plugins provide shortcuts, aliases, functions, and auto-completion for various tools and languages.

**Important: What Plugins Do and Don't Do**

Oh My Bash plugins **do not install** the underlying technologies. They assume the tools are already installed on your system. Plugins provide:
- **Convenience aliases** - Shorter commands for common operations
- **Helper functions** - Utility functions that wrap or extend tool functionality
- **Tab completion** - Enhanced autocomplete for tool-specific commands
- **Environment integration** - Hooks and configurations for smoother workflows
- **Prompt enhancements** - Display relevant status information (like virtualenv, Git branch)

You must install the actual tools separately (via package managers, installers, etc.). The plugins simply make working with those tools more efficient and user-friendly.

**Featured Plugins:**
- `git` - Git shortcuts and aliases (requires Git to be installed)
- `node.js` / `nvm` - Node.js development helpers and path management (requires Node.js/nvm)
- `python` / `virtualenv` - Python environment activation helpers and shortcuts (requires Python/virtualenv)
- `ruby` / `rails` - Ruby and Rails convenience functions and aliases (requires Ruby/Rails)
- `php` - PHP development shortcuts (requires PHP)
- `django` - Django framework helper functions (requires Django)
- `postgres` - PostgreSQL command shortcuts (requires PostgreSQL client)
- `docker` - Docker command enhancements and aliases (requires Docker)
- `osx` - macOS-specific system utilities (macOS only)
- `heroku` - Heroku CLI helper functions (requires Heroku CLI)
- `tmux-autoattach` - Auto-attach to tmux sessions on SSH login (requires tmux)
- `jump` - Directory jumping/bookmarking tool (provides the tool itself)

**Plugin Configuration:**
```bash
# Enable plugins in ~/.bashrc
plugins=(git bundler osx rake ruby)

# Conditional plugin loading (e.g., only on SSH)
[ "$SSH_TTY" ] && plugins+=(tmux-autoattach)
```

### 3. Aliases

Pre-configured command aliases for common operations organized by category.

**Alias Categories:**
- General shell operations
- Package managers (apt, yum, snap, brew, etc.)
- Development tools
- System administration

**Recent additions:**
- Snap package manager aliases

### 4. Completions

Tab completion scripts for various command-line tools and applications.

**Completion Features:**
- Enhanced Bash completion for popular tools
- Custom completion definitions
- Recent additions include `jump` command completion

### 5. Auto-Update System

Built-in mechanism to keep Oh My Bash up-to-date with community improvements.

**Update Configuration:**
```bash
# Automatic upgrades without prompting
DISABLE_UPDATE_PROMPT=true

# Disable automatic updates entirely
DISABLE_AUTO_UPDATE=true

# Manual update command
upgrade_oh_my_bash
```

### 6. Customization System

Robust customization framework allowing users to extend or override default behavior.

**Custom Directory Structure:**
- `custom/` - User-specific customizations
- `custom/plugins/` - Custom plugin development
- `custom/themes/` - Custom theme development
- `custom/aliases/` - Custom aliases
- `custom/completions/` - Custom completions

**Customization Methods:**

1. **Add new functionality:**
   - Create `.sh` files in `custom/` directory
   - Files are automatically loaded

2. **Override existing modules:**
   - Copy module to `custom/` with same directory structure
   - Modify as needed
   - Custom version loads instead of original

3. **Create custom plugins:**
   - Create `custom/plugins/PLUGINNAME/PLUGINNAME.plugin.sh`
   - Enable via `plugins` array in `~/.bashrc`

## Installation

### Basic Installation

**Via curl:**
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
```

**Via wget:**
```bash
bash -c "$(wget https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh -O -)"
```

### Advanced Installation Options

**Custom installation directory:**
```bash
export OSH="$HOME/.dotfiles/oh-my-bash"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
```

**Unattended installation (for automation):**
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --unattended
```

**System-wide installation:**
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)" --prefix=/usr/local
```

### Installation Behavior

- Replaces `~/.bashrc` (original backed up as `~/.bashrc.omb-TIMESTAMP`)
- Creates `~/.bash_profile` if it doesn't exist
- Default installation location: `~/.oh-my-bash`
- Requires `~/.bash_profile` to source `~/.bashrc`

## Configuration

### Primary Configuration File: `~/.bashrc`

All Oh My Bash configuration happens through `~/.bashrc`.

**Key Configuration Variables:**

```bash
# Theme selection
OSH_THEME="font"

# Plugin enablement
plugins=(git bundler python)

# Python virtualenv display
OMB_PROMPT_SHOW_PYTHON_VENV=true

# Spack environment display
OMB_PROMPT_SHOW_SPACK_ENV=true

# Disable sudo usage by Oh My Bash
OMB_USE_SUDO=false

# Update behavior
DISABLE_UPDATE_PROMPT=true
DISABLE_AUTO_UPDATE=true

# Installation directory
OSH="$HOME/.oh-my-bash"

# Custom directory (default: $OSH/custom)
OSH_CUSTOM="$HOME/.dotfiles/oh-my-bash-custom"
```

## Uninstallation

```bash
uninstall_oh_my_bash
```

This command:
- Removes Oh My Bash
- Restores previous Bash configuration

## What Oh My Bash Replaces in Custom Dotfiles

When migrating to Oh My Bash, the following custom implementations can typically be replaced:

### 1. Custom Prompt Configuration
- Replace custom `PS1` definitions with Oh My Bash themes
- Remove manual color code definitions
- Remove custom Git branch/status parsing functions

### 2. Autocomplete Scripts
- Replace custom completion scripts with Oh My Bash completions
- Remove manual `complete` command definitions

### 3. Alias Management
- Consolidate scattered aliases into Oh My Bash alias categories
- Use Oh My Bash's organized alias structure instead of flat alias lists

### 4. Tool-Specific Functions
- Replace custom Git helper functions (Oh My Bash Git plugin provides these)
- Remove custom virtualenv activation helpers (Python plugin handles this)
- Replace directory navigation helpers (use `jump` plugin)

### 5. Environment Detection
- Replace manual OS detection with Oh My Bash's built-in detection
- Remove custom conditional loading logic (use Oh My Bash's conditional plugin loading)

### 6. Prompt Git Integration
- Remove custom Git status parsing
- Remove custom Git branch detection
- Let themes handle Git information display

### 7. Color Definitions
- Replace manual color variable definitions
- Use Oh My Bash's standardized color utilities from `lib/`

### 8. Update Mechanisms
- Remove custom dotfile update scripts
- Use Oh My Bash's built-in auto-update system

## Directory Structure

```
~/.oh-my-bash/
├── aliases/          # Pre-built alias collections
├── completions/      # Tab completion scripts
├── custom/           # User customizations
│   ├── aliases/
│   ├── completions/
│   ├── plugins/
│   └── themes/
├── lib/              # Core framework libraries
├── plugins/          # Plugin collection
├── templates/        # Configuration templates
├── themes/           # Theme collection
├── tools/            # Installation and maintenance scripts
└── oh-my-bash.sh     # Main entry point
```

## Integration Considerations

### Vim/Neovim Integration
- Oh My Bash doesn't directly integrate with Vim
- Themes affect terminal appearance which Vim inherits
- No specific Vim plugin management

### Tmux Integration
- `tmux-autoattach` plugin provides auto-session management
- Themes work within tmux sessions
- No direct tmux configuration management

### Git Integration
- Strong Git integration through themes (branch display, status indicators)
- Git plugin provides shortcuts and aliases
- Customizable Git prompt information

## Migration Path from Custom Bash Configuration

1. **Audit current `.bashrc`** - Identify custom functions, aliases, prompts
2. **Map to Oh My Bash equivalents** - Find plugins/themes that replace custom code
3. **Preserve unique logic** - Move irreplaceable custom code to `custom/` directory
4. **Enable appropriate plugins** - Replace tool-specific customizations with plugins
5. **Select theme** - Replace custom prompt with Oh My Bash theme
6. **Test incrementally** - Enable features gradually to identify issues
7. **Document customizations** - Keep notes on what was replaced vs. preserved

## Advantages for Dotfiles Repository

- **Community maintenance** - Plugins and themes updated by community
- **Consistent structure** - Standard organization across machines
- **Easy updates** - Built-in update mechanism
- **Reduced maintenance** - Less custom code to maintain
- **Portability** - Same framework works across macOS and Linux
- **Modularity** - Enable/disable features via simple configuration
- **Extensibility** - Custom directory preserves unique requirements

## Limitations and Considerations

- **Bash-specific** - Won't work with Zsh, Fish, or other shells
- **macOS and Linux only** - Limited Windows/WSL support
- **Learning curve** - Need to learn Oh My Bash conventions
- **Performance** - Loading many plugins can slow shell startup
- **Customization conflicts** - Custom code might conflict with plugins
- **Theme requirements** - Some themes need special fonts (Powerline, Nerd Fonts)

## Best Practices

1. **Start minimal** - Enable only needed plugins initially
2. **Use custom/ directory** - Keep personal customizations separate
3. **Document changes** - Note which plugins replace custom code
4. **Test themes** - Try multiple themes to find best fit
5. **Conditional loading** - Use conditional plugin loading for environment-specific needs
6. **Version control custom/** - Track custom directory separately from Oh My Bash installation
7. **Regular updates** - Keep Oh My Bash updated for bug fixes and new features
8. **Review plugin READMEs** - Understand plugin capabilities before enabling
