#!/bin/bash

set -euo pipefail

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly CONFIG_DIR="${HOME}/.config"
readonly FONT_DIR="${HOME}/.local/share/fonts"

# Color definitions
readonly COLOR_RESET='\033[0m'
readonly COLOR_RED='\033[31m'
readonly COLOR_GREEN='\033[32m'
readonly COLOR_YELLOW='\033[33m'
readonly COLOR_BLUE='\033[34m'

# Package lists
readonly PACKAGES=(
    'bash-completion'
    'bat'
    'tree'
    'multitail'
    'fastfetch'
    'neovim'
    'trash-cli'
)

# Global variables
PACKAGE_MANAGER=""
PRIVILEGE_CMD=""

log() {
    local level="$1"
    local message="$2"
    local color=""
    
    case "$level" in
        "INFO")  color="$COLOR_BLUE" ;;
        "WARN")  color="$COLOR_YELLOW" ;;
        "ERROR") color="$COLOR_RED" ;;
        "SUCCESS") color="$COLOR_GREEN" ;;
        *) color="$COLOR_RESET" ;;
    esac
    
    printf "${color}[%s]${COLOR_RESET} %s\n" "$level" "$message" >&2
}

check_command() {
    command -v "$1" >/dev/null 2>&1
}

detect_package_manager() {
    local managers=("nala" "apt" "dnf" "yum" "pacman" "zypper" "emerge" "xbps-install" "nix-env")
    
    for manager in "${managers[@]}"; do
        if check_command "$manager"; then
            PACKAGE_MANAGER="$manager"
            log "INFO" "Detected package manager: $manager"
            return 0
        fi
    done

    log "ERROR" "No supported package manager found"
        exit 1
}

detect_privilege_escalation() {
    if check_command "sudo"; then
        PRIVILEGE_CMD="sudo"
    elif check_command "doas" && [[ -f "/etc/doas.conf" ]]; then
        PRIVILEGE_CMD="doas"
    else
        PRIVILEGE_CMD="su -c"
    fi

    log "INFO" "Using privilege escalation: $PRIVILEGE_CMD"
}

remove_packages() {
    log "WARN" "Removing installed packages..."
    
    local packages_str="${PACKAGES[*]}"
    
    case "$PACKAGE_MANAGER" in
        "pacman")
            if check_command "yay"; then
                yay -Rns --noconfirm $packages_str || true
            elif check_command "paru"; then
                paru -Rns --noconfirm $packages_str || true
        else
                $PRIVILEGE_CMD pacman -Rns --noconfirm $packages_str || true
        fi
            ;;
        "nala"|"apt")
            $PRIVILEGE_CMD $PACKAGE_MANAGER purge -y $packages_str || true
            ;;
        "emerge")
            local emerge_packages=(
                "app-shells/bash-completion"
                "sys-apps/bat"
                "app-text/tree"
                "app-text/multitail"
                "app-misc/fastfetch"
                "app-editors/neovim"
                "app-misc/trash-cli"
            )
            $PRIVILEGE_CMD emerge --deselect "${emerge_packages[@]}" || true
            ;;
        "xbps-install")
            $PRIVILEGE_CMD xbps-remove -Ry $packages_str || true
            ;;
        "nix-env")
            $PRIVILEGE_CMD nix-env -e $packages_str || true
            ;;
        "dnf"|"yum")
            $PRIVILEGE_CMD $PACKAGE_MANAGER remove -y $packages_str || true
            ;;
        *)
            $PRIVILEGE_CMD $PACKAGE_MANAGER remove -y $packages_str || true
            ;;
    esac
    
    log "SUCCESS" "Package removal completed"
}

remove_fonts() {
    local font_name="MesloLGS Nerd Font Mono"
    local font_path="$FONT_DIR/$font_name"
    
    if [[ -d "$font_path" ]]; then
        log "WARN" "Removing font: $font_name"
        rm -rf "$font_path"
        
        if check_command "fc-cache"; then
            fc-cache -fv >/dev/null 2>&1
    fi
        
        log "SUCCESS" "Font removed successfully"
    else
        log "INFO" "Font directory not found: $font_name"
    fi
}

remove_external_tools() {
    # Remove Starship
    if check_command "starship"; then
        log "WARN" "Removing Starship prompt..."
        local starship_path
        starship_path="$(command -v starship)"
        $PRIVILEGE_CMD rm -f "$starship_path"
        log "SUCCESS" "Starship removed"
    fi

    # Remove fzf
    if [[ -d "$HOME/.fzf" ]]; then
        log "WARN" "Removing fzf..."
        if [[ -x "$HOME/.fzf/uninstall" ]]; then
            "$HOME/.fzf/uninstall" --all >/dev/null 2>&1 || true
    fi
        rm -rf "$HOME/.fzf"
        log "SUCCESS" "fzf removed"
    fi
    
    # Remove Zoxide
    if check_command "zoxide"; then
        log "WARN" "Removing Zoxide..."
        local zoxide_path
        zoxide_path="$(command -v zoxide)"
        $PRIVILEGE_CMD rm -f "$zoxide_path"
        log "SUCCESS" "Zoxide removed"
        fi
}

restore_configurations() {
    local user_home
    user_home="$(getent passwd "${SUDO_USER:-$USER}" | cut -d: -f6)"
    
    log "WARN" "Restoring configuration files..."
    
    # Restore .bashrc
    if [[ -L "$user_home/.bashrc" ]]; then
        rm "$user_home/.bashrc"
        if [[ -f "$user_home/.bashrc.bak" ]]; then
            mv "$user_home/.bashrc.bak" "$user_home/.bashrc"
            log "SUCCESS" "Original .bashrc restored"
    fi
    fi
    
    # Remove configuration files
    local config_files=(
        "$user_home/.config/starship.toml"
        "$user_home/.config/fastfetch/config.jsonc"
    )
    
    for config_file in "${config_files[@]}"; do
        if [[ -f "$config_file" ]]; then
            rm -f "$config_file"
        fi
    done
    
    log "SUCCESS" "Configuration restoration completed"
}

cleanup_project_directory() {
    log "INFO" "Project directory cleanup completed"
    log "INFO" "You can manually remove the mybash directory if desired"
}

main() {
    log "INFO" "Starting Linux Toolbox uninstallation..."
    detect_package_manager
    detect_privilege_escalation
    
    remove_packages
    remove_fonts
    remove_external_tools
    restore_configurations
    cleanup_project_directory
    
    log "SUCCESS" "Uninstallation completed successfully!"
    log "INFO" "Please restart your shell or source your shell configuration to apply changes"
}

main "$@"
