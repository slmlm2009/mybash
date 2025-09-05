# Enhanced Bash Configuration

## Overview

A comprehensive `.bashrc` configuration with modern terminal enhancements for Unix-like systems. This setup provides powerful aliases, custom functions, an enhanced prompt, and integrated tools to significantly improve your terminal productivity and experience.

## Table of Contents

- [Installation](#installation)
- [Uninstallation](#uninstallation)
- [Configuration Files](#configuration-files)
  - [.bashrc](#bashrc)
  - [starship.toml](#starshiptoml)
  - [config.jsonc](#configjsonc)
- [Key Features](#key-features)
- [Advanced Functions](#advanced-functions)
- [System-Specific Configurations](#system-specific-configurations)
- [Conclusion](#conclusion)

## Installation

To install the `.bashrc` configuration, execute the following commands in your terminal:

```sh
git clone --depth=1 https://github.com/dacrab/mybash.git
cd mybash
./setup.sh
```

The `setup.sh` script automates the installation process by:

- Installing essential packages (bash-completion, bat, tree, neovim, fastfetch, etc.)
- Installing modern terminal tools (starship prompt, fzf fuzzy finder, zoxide directory jumper)
- Installing MesloLGS Nerd Font for enhanced prompt display
- Linking configuration files (`.bashrc`, `starship.toml`, `config.jsonc`) to your home directory
- Backing up existing configurations before making changes

**Requirements:** Git, curl, and a supported package manager (apt, dnf, pacman, etc.)

## Uninstallation

To uninstall the `.bashrc` configuration, run:

```sh
cd mybash
./uninstall.sh
```

The `uninstall.sh` script reverses the installation by:

- Removing installed packages and dependencies
- Uninstalling MesloLGS Nerd Font
- Removing symbolic links and restoring original configurations
- Cleaning up external tools (starship, fzf, zoxide)
- Restoring backed up `.bashrc` if available

**Note:** Restart your shell after uninstallation to apply changes.

## Configuration Files

### `.bashrc`

Enhanced bash configuration with modern shell improvements:

- **Smart Aliases**: Safe defaults and productivity shortcuts (e.g., `cp='cp -i'`, `ll='ls -la'`)
- **Custom Functions**: Archive extraction, file operations, system utilities
- **History Management**: Improved history handling with deduplication
- **Tool Integration**: Seamless integration with fzf, zoxide, and other modern tools

### `starship.toml`

[Starship](https://starship.rs/) prompt configuration for a modern, informative shell prompt:

- **Clean Design**: Minimalist yet informative prompt layout
- **Git Integration**: Branch status, commit info, and repository state
- **Language Support**: Context-aware modules for Python, Node.js, Rust, Go, and more
- **Performance**: Fast rendering with intelligent truncation

### `config.jsonc`

[Fastfetch](https://github.com/fastfetch-cli/fastfetch) system information display:

- **System Overview**: CPU, GPU, memory, and storage information
- **Customizable Layout**: Clean, organized system information display
- **Logo Support**: Distro-specific ASCII art and branding
- **Performance Metrics**: Quick system health overview

## Key Features

### Modern Terminal Tools
- **Starship Prompt**: Fast, customizable prompt with git integration
- **FZF**: Fuzzy finder for files, command history, and more
- **Zoxide**: Smart directory jumping with frecency algorithm
- **Bat**: Syntax-highlighted `cat` replacement
- **Fastfetch**: System information display

### Enhanced Shell Experience
- **Smart Aliases**: Safer defaults and productivity shortcuts
- **Custom Functions**: Archive handling, file operations, system utilities
- **History Management**: Improved history with deduplication and search
- **Color Support**: Enhanced readability with syntax highlighting

### Safety and Productivity
- **Safe Operations**: Confirmation prompts for destructive commands
- **Trash Integration**: Use `trash` instead of `rm` for safer file deletion
- **Editor Integration**: NeoVim as default with fallbacks
- **Cross-Platform**: Works on major Linux distributions and package managers

### System Integration
- **Package Manager Detection**: Automatic detection of apt, dnf, pacman, etc.
- **Font Installation**: Automatic Nerd Font setup for prompt icons
- **Backup System**: Preserves existing configurations before changes

## Supported Systems

- **Arch Linux** (pacman, yay, paru)
- **Debian/Ubuntu** (apt, nala)
- **Fedora/RHEL** (dnf, yum)
- **Gentoo** (emerge)
- **Void Linux** (xbps-install)
- **openSUSE** (zypper)
- **NixOS** (nix-env)

## Contributing

Contributions are welcome! Please feel free to:
- Report bugs or issues
- Suggest new features or improvements
- Submit pull requests
- Share your customizations

## License

This project is open source. Feel free to use, modify, and distribute as needed.
