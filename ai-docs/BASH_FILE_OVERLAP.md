# Bash File Overlap Analysis

## Purpose

This document identifies files and configurations in the current dotfiles repository that can be removed or significantly simplified after migrating to Oh My Bash. Each entry explains what functionality is being replaced and which Oh My Bash features provide equivalent or superior functionality.

---

## Files That Can Be Completely Removed

### 1. Prompt Configuration Files

**Files to Remove:**
- `src/shell/bash_prompt`
- `src/shell/*/bash_prompt` (all OS-specific versions)

**Current Functionality:**
- Custom PS1/PS2/PS4 prompt definitions
- Git repository detection and status parsing (`get_git_repository_details`)
- Color support detection
- Terminal title setting
- Git branch display
- Working directory display with colors

**Oh My Bash Replacement:**
- **Feature**: Themes (70+ available)
- **Configuration**: Set `OSH_THEME` in `~/.bashrc`
- **Equivalent**: Any Oh My Bash theme provides prompt customization
- **Recommended Themes**:
  - `font` (default, similar to current setup)
  - `agnoster` (enhanced Git support)
  - `powerline-light` (modern appearance)

**Migration Notes:**
- Oh My Bash themes handle Git status natively (no custom parsing needed)
- Themes automatically adapt to terminal capabilities
- Color schemes are built into themes

---

### 2. Bash Autocompletion Files

**Files to Remove:**
- `src/shell/bash_autocompletion`
- `src/shell/*/bash_autocompletion` (all OS-specific versions)

**Current Functionality:**
- Sources OS-specific autocompletion scripts
- Loads custom completion definitions

**Oh My Bash Replacement:**
- **Feature**: Completions system (`completions/` directory)
- **Configuration**: No explicit configuration needed (loaded automatically)
- **Available Completions**: awscli, docker, git, npm, pip, ssh, and many more

**Migration Notes:**
- Oh My Bash handles completion loading automatically
- Custom completions can be placed in `$OSH_CUSTOM/completions/`

---

### 3. Color Definition Files

**Files to Remove:**
- `src/shell/macos/bash_colors`
- `src/shell/*/bash_colors` (all Ubuntu/Raspberry Pi versions)

**Current Functionality:**
- Sets `LSCOLORS` (macOS) and `LS_COLORS` (Linux)
- Defines color codes for `ls` output
- Creates color aliases for `ls`, `grep`, etc.

**Oh My Bash Replacement:**
- **Feature**: Built-in color utilities in `lib/` directory
- **Configuration**: Automatic OS detection and color setup
- **Themes**: Handle terminal colors automatically

**Migration Notes:**
- Oh My Bash detects OS and applies appropriate color schemes
- Themes include color definitions
- No manual `LSCOLORS` or `LS_COLORS` configuration needed

---

## Files That Can Be Partially Removed/Simplified

### 4. Bash Aliases File

**File:** `src/shell/bash_aliases`

**Remove These Aliases (Oh My Bash provides equivalents):**

```bash
# Navigation aliases (lines 3-6)
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias cd..="cd .."
```
- **Replacement**: Oh My Bash aliases provide these by default
- **Plugin**: General navigation aliases

```bash
# Git alias (line 31)
alias g="git"
```
- **Replacement**: Oh My Bash `git` plugin
- **Plugin**: `git` (provides comprehensive Git aliases)

```bash
# NPM alias (line 36)
alias n="npm"
```
- **Replacement**: Oh My Bash `node` plugin
- **Plugin**: `node` or `npm`

```bash
# Yarn alias (line 41)
alias y="yarn"
```
- **Replacement**: Oh My Bash likely has yarn support
- **Check**: `yarn` plugin availability

**All Standard Aliases Can Be Removed:**
- `alias :q="exit"` (line 26) - **NOT USED**
- `alias c="clear"` (line 27) - **NOT USED**
- `alias ch="history -c && > ~/.bash_history"` (line 28) - **NOT USED**
- `alias d="cd ~/Desktop"` (line 29) - **NOT USED**
- `alias e="vim --"` (line 30) - **NOT USED**
- `alias ip="dig +short myip.opendns.com @resolver1.opendns.com"` (line 32) - **NOT USED**
- `alias ll="ls -l"` (line 33) - **NOT USED** (Oh My Bash provides this)
- `alias m="man"` (line 34) - **NOT USED**
- `alias map="xargs -n1"` (line 35) - **NOT USED**
- `alias p="cd ~/projects"` (line 37) - **NOT USED**
- `alias path='printf "%b\n" "${PATH//:/\\n}"'` (line 38) - **NOT USED**
- `alias q="exit"` (line 39) - **NOT USED**
- `alias t="tmux"` (line 40) - **NOT USED**
- Custom file counting aliases (lines 53-56) - **NOT USED**
- `alias rm='rm_safe'` (line 56) - **NOT USED**

**Note:** These aliases were inherited from the original forked repository and are not actively used. They can all be safely removed during Oh My Bash migration.

**OS-Specific Alias Files:**
- `src/shell/*/bash_aliases` - Review each for custom vs. standard aliases

**Migration Strategy:**
1. Move custom aliases to `$OSH_CUSTOM/aliases/custom.aliases.sh`
2. Remove aliases that overlap with Oh My Bash plugins
3. Enable relevant Oh My Bash plugins for standard tool aliases

---

### 5. Bash Functions File

**File:** `src/shell/bash_functions`

**Functions to Keep (Custom/Specialized):**
- `dp()` - Docker ps formatting (lines 11-18)
- `clone()` - Git clone with dependency install (lines 28-59)
- `datauri()` - Create data URI from file (lines 69-89)
- `delete-files()` - Delete files by pattern (lines 100-103)
- `evm()` - Execute Vim macro (lines 114-134)
- `h()` - History search with grep (lines 144-152)
- `rename-files-with-date-in-name()` - Date-based file renaming (lines 165-200)
- `resize-image()` - ImageMagick wrapper (lines 218-251)
- `s()` - Project search with grep (lines 261-271)
- `clean-dev()` - Remove node_modules/bower_components (lines 281-284)
- `killni()` - Kill Node Inspector (lines 294-297)
- `vpush()` - Version-based git push (lines 307-321)
- `set-git-public()` - Set git user config (lines 331-334)
- `backup-source()` - Rsync backup of ~/Source (lines 344-350)
- `backup-all()` - Rsync backup of user directories (lines 360-375)
- `org-by-date()` - Organize files by date (lines 385-391)
- `get-course()`, `get-channel()`, `get-tunes()`, `get-video()` - yt-dlp wrappers (lines 401-507)
- `get-folder()` - Rsync/robocopy wrapper (lines 518-549)
- `docker-clean()` - Remove all Docker resources (lines 559-598)
- `git-clone()` - Rsync-based repo copy (lines 608-610)
- `git-pup()` - Git pull with submodules (lines 620-622)
- `ips()` - Network IP scanning with nmap (lines 636-682)
- `refresh-files()` - Overwrite files from source (lines 692-749)
- `ncu-update-all()` - Update npm/bower deps (lines 759-781)
- `talk()` - Text-to-speech with festival (lines 792-794)
- `remove_smaller_files()` - Compare and remove smaller files (lines 804-840)
- `npmi()` - Reinstall npm packages (lines 850-877)
- `get-dependencies()` - Extract package.json deps (lines 889-953)
- `install-dependencies-from()` - Install deps from another package.json (lines 964-1006)
- `rm_safe()` - Safe rm wrapper (lines 1018-1050)
- `git-push()` - Add, commit, and push (lines 1060-1098)
- `ccurl()` - Curl with JSON pretty-print (lines 1108-1114)
- `fetch-github-repos()` - Clone org repositories (lines 1124-1157)
- `git-backup()` - Create git repository backups (lines 1159-1237)
- `nginx-init()` - Initialize nginx configs (lines 1248-1445)
- `certbot-init()` - Install SSL certs (lines 1456-1616)
- `certbot-crontab-init()` - Setup certbot renewal cron (lines 1626-1708)
- `claude-danger()` - Launch Claude CLI (lines 1714-1724)

**Considerations:**
- All functions are **custom/specialized** and should be kept
- Consider organizing into categories in `$OSH_CUSTOM/` directory:
  - `$OSH_CUSTOM/functions/docker.sh`
  - `$OSH_CUSTOM/functions/git.sh`
  - `$OSH_CUSTOM/functions/backups.sh`
  - `$OSH_CUSTOM/functions/media.sh`
  - `$OSH_CUSTOM/functions/nginx.sh`
  - etc.

**Migration Strategy:**
1. Copy `bash_functions` to `$OSH_CUSTOM/functions/custom.sh`
2. Optionally split into logical groupings for better organization
3. Oh My Bash will automatically load files from `$OSH_CUSTOM/`

---

### 6. Bash Options File

**File:** `src/shell/bash_options`

**Current Functionality:**
- Enables vi editing mode
- Sets various `shopt` options (autocd, cdspell, etc.)

**Oh My Bash Consideration:**
- Oh My Bash **does not** manage shell options by default
- These are **personal preferences** and should be kept

**Migration Strategy:**
1. Move to `$OSH_CUSTOM/bash_options.sh`
2. Will be automatically sourced by Oh My Bash
3. Alternatively, add directly to `~/.bashrc` after Oh My Bash initialization

**Decision:** **KEEP** - These are user preferences, not redundant functionality

---

## Files to Review and Decide

### 7. Bash Exports

**File:** `src/shell/bash_exports`

**Action:** **READ AND ANALYZE** (not included in current file reads)

**Likely Overlap:**
- `PATH` modifications - May conflict with Oh My Bash plugin path management
- Language-specific environment variables (NODE_ENV, PYTHON_PATH, etc.)
- Editor preferences (EDITOR, VISUAL)

**Recommendation:**
1. Read the file to identify exports
2. Keep custom paths and environment variables
3. Remove any that conflict with Oh My Bash plugin expectations
4. Move to `$OSH_CUSTOM/exports.sh`

---

### 8. Bash Init Files

**Files:**
- `src/shell/bash_init`
- `src/shell/*/bash_init` (OS-specific versions)

**Action:** **READ AND ANALYZE** (not included in current file reads)

**Likely Contains:**
- NVM initialization
- Other tool initialization (rbenv, pyenv, etc.)
- Path setup

**Recommendation:**
1. Review for tool initialization that Oh My Bash plugins handle
2. Keep custom initialization
3. Move to `$OSH_CUSTOM/init.sh`

---

### 9. Other Shell Configuration Files

**Files:**
- `src/shell/bashrc` - Main bashrc file
- `src/shell/bash_profile` - Profile file
- `src/shell/bash_logout` - Logout script
- `src/shell/inputrc` - Readline configuration
- `src/shell/curlrc` - Curl configuration

**bashrc / bash_profile:**
- **Action**: Will be **replaced** by Oh My Bash installation
- **Backup**: Oh My Bash automatically backs up as `~/.bashrc.omb-TIMESTAMP`
- **Custom additions**: Move to `~/.bash.local` or `$OSH_CUSTOM/`

**bash_logout:**
- **Action**: **KEEP** - Not managed by Oh My Bash
- **Location**: Keep as `~/.bash_logout`

**inputrc:**
- **Action**: **KEEP** - Readline configuration is independent
- **Location**: Keep as `~/.inputrc`

**curlrc:**
- **Action**: **KEEP** - Curl configuration is independent
- **Location**: Keep as `~/.curlrc`

---

## OS-Specific Directory Structure

### Current Structure

```
src/shell/
├── (base files)
├── macos/
├── ubuntu-original/
├── ubuntu-20-svr/
├── ubuntu-22-svr/
├── ubuntu-23-svr/
├── ubuntu-24-svr/
├── ubuntu-24-wks/
└── raspberry-pi-os/
```

### Oh My Bash Approach

**Oh My Bash uses:**
1. **Built-in OS detection** - Automatic in framework
2. **Conditional plugin loading** - Based on OS
3. **Single configuration file** - `~/.bashrc` with conditionals

### Migration Strategy

**Instead of separate directories:**

```bash
# In ~/.bashrc (after Oh My Bash initialization)

# macOS-specific
if [[ "$OSTYPE" == "darwin"* ]]; then
    [ -f "$OSH_CUSTOM/macos.sh" ] && source "$OSH_CUSTOM/macos.sh"
    plugins+=(osx brew)
fi

# Ubuntu-specific
if [[ "$OSTYPE" == "linux-gnu"* ]] && [ -f /etc/lsb-release ]; then
    [ -f "$OSH_CUSTOM/ubuntu.sh" ] && source "$OSH_CUSTOM/ubuntu.sh"
    plugins+=(ubuntu)
fi

# Raspberry Pi-specific
if [ -f /proc/device-tree/model ] && grep -q "Raspberry Pi" /proc/device-tree/model 2>/dev/null; then
    [ -f "$OSH_CUSTOM/raspberry-pi.sh" ] && source "$OSH_CUSTOM/raspberry-pi.sh"
fi
```

**Consolidate OS-specific configs:**
1. Extract unique configurations from each OS directory
2. Place in `$OSH_CUSTOM/os-name.sh` files
3. Use conditional loading in `~/.bashrc`
4. Remove redundant OS directories

---

## Summary of Actions

### Remove Completely
- ✅ `src/shell/bash_prompt` and all OS variants
- ✅ `src/shell/bash_autocompletion` and all OS variants
- ✅ `src/shell/*/bash_colors` (all OS-specific color files)

### Simplify and Move to Custom
- ⚠️ `src/shell/bash_aliases` - Remove overlapping aliases, keep custom ones
- ✅ `src/shell/bash_functions` - Move to `$OSH_CUSTOM/functions/`
- ✅ `src/shell/bash_options` - Move to `$OSH_CUSTOM/`

### Review Before Decision
- ❓ `src/shell/bash_exports` - Review for Oh My Bash conflicts
- ❓ `src/shell/bash_init` and OS variants - Check for tool init overlap

### Keep As-Is
- ✅ `src/shell/bash_logout` - Keep as `~/.bash_logout`
- ✅ `src/shell/inputrc` - Keep as `~/.inputrc`
- ✅ `src/shell/curlrc` - Keep as `~/.curlrc`

### Replace with Oh My Bash
- ✅ `src/shell/bashrc` - Replaced by Oh My Bash template
- ✅ `src/shell/bash_profile` - Replaced by Oh My Bash template

---

## Migration Checklist

1. **Pre-Migration**
   - [ ] Backup current configuration
   - [ ] Document custom aliases and functions
   - [ ] Identify OS-specific requirements

2. **Install Oh My Bash**
   - [ ] Run Oh My Bash installation script
   - [ ] Verify `~/.bashrc` and `~/.bash_profile` created

3. **Configure Oh My Bash**
   - [ ] Select and set `OSH_THEME`
   - [ ] Enable required plugins (git, docker, node, etc.)
   - [ ] Configure `OMB_PROMPT_SHOW_PYTHON_VENV` if needed

4. **Migrate Custom Code**
   - [ ] Copy `bash_functions` to `$OSH_CUSTOM/functions/custom.sh`
   - [ ] Copy custom aliases to `$OSH_CUSTOM/aliases/custom.aliases.sh`
   - [ ] Copy `bash_options` to `$OSH_CUSTOM/bash_options.sh`
   - [ ] Review and migrate `bash_exports` to `$OSH_CUSTOM/exports.sh`
   - [ ] Review and migrate `bash_init` to `$OSH_CUSTOM/init.sh`

5. **Consolidate OS-Specific Configs**
   - [ ] Extract unique macOS configs to `$OSH_CUSTOM/macos.sh`
   - [ ] Extract unique Ubuntu configs to `$OSH_CUSTOM/ubuntu.sh`
   - [ ] Extract unique Raspberry Pi configs to `$OSH_CUSTOM/raspberry-pi.sh`
   - [ ] Add conditional loading to `~/.bashrc`

6. **Test Configuration**
   - [ ] Open new shell and verify prompt appears correctly
   - [ ] Test custom functions work
   - [ ] Test custom aliases work
   - [ ] Test OS detection and conditional loading
   - [ ] Verify tab completion works for common commands

7. **Clean Up Old Files**
   - [ ] Remove `src/shell/bash_prompt` and OS variants
   - [ ] Remove `src/shell/bash_autocompletion` and OS variants
   - [ ] Remove `src/shell/*/bash_colors` files
   - [ ] Remove redundant OS-specific directories
   - [ ] Archive or delete old `bashrc` and `bash_profile`

8. **Document Changes**
   - [ ] Update repository README
   - [ ] Document custom Oh My Bash configuration
   - [ ] Note which plugins are required
   - [ ] Document OS-specific customizations

---

## Estimated Reduction

### Current State
- **Files**: ~100+ bash-related configuration files
- **Directories**: 8 OS-specific shell directories
- **Lines of Code**: Thousands of lines of custom prompt, completion, and color code

### After Oh My Bash Migration
- **Files**: ~10 custom configuration files in `$OSH_CUSTOM/`
- **Directories**: 1 custom directory (`$OSH_CUSTOM/`)
- **Lines of Code**: Hundreds (only truly custom code)
- **Maintenance**: Significantly reduced (community maintains framework)

### What Gets Replaced
- **Prompt logic**: Replaced by Oh My Bash themes
- **Autocomplete**: Replaced by Oh My Bash completions
- **Color schemes**: Replaced by Oh My Bash themes/lib
- **Git integration**: Replaced by Oh My Bash git plugin and themes
- **OS detection**: Replaced by Oh My Bash built-in detection

### What Stays Custom
- **Personal aliases**: Your workflow shortcuts
- **Custom functions**: Your specialized utility functions
- **Shell options**: Your personal preferences (vi mode, etc.)
- **Tool initialization**: Environment-specific setup
- **Exports**: Custom PATH and environment variables

---

## Notes

- **Test thoroughly** after migration in a non-production environment first
- **Keep backups** of all original configuration files
- Oh My Bash automatically backs up `~/.bashrc` during installation
- Custom configurations in `$OSH_CUSTOM/` **survive Oh My Bash updates**
- You can always revert by restoring the backup created during installation
