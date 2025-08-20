#!/bin/bash

# NeoVim Configuration Installer
# Automated NeoVim installation with AI assistant for Ubuntu

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Output functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check operating system
check_os() {
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        print_error "This script is designed for Linux systems"
        exit 1
    fi
    
    if ! command -v apt &> /dev/null; then
        print_error "This script requires apt package manager (Ubuntu/Debian)"
        exit 1
    fi
}

# Check sudo privileges
check_sudo() {
    if ! sudo -n true 2>/dev/null; then
        print_info "Installation requires sudo privileges"
        sudo -v
    fi
}

# Update system
update_system() {
    print_info "Updating system..."
    sudo apt update && sudo apt upgrade -y
    print_success "System updated"
}

# Install basic dependencies
install_dependencies() {
    print_info "Installing basic dependencies..."
    sudo apt install -y curl wget git build-essential unzip software-properties-common
    print_success "Basic dependencies installed"
}

# Install Node.js
install_nodejs() {
    if command -v node &> /dev/null; then
        print_warning "Node.js is already installed ($(node --version))"
        return
    fi
    
    print_info "Installing Node.js LTS..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
    print_success "Node.js installed ($(node --version))"
}

# Install NeoVim
install_neovim() {
    if command -v nvim &> /dev/null; then
        print_warning "NeoVim is already installed ($(nvim --version | head -n1))"
        return
    fi
    
    print_info "Installing NeoVim..."
    
    # Download latest version
    wget -q https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -O /tmp/nvim-linux-x86_64.tar.gz
    
    # Extract to /opt
    sudo tar -xzf /tmp/nvim-linux-x86_64.tar.gz -C /opt/
    
    # Create symbolic link
    sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
    
    # Clean up temporary files
    rm -f /tmp/nvim-linux-x86_64.tar.gz
    
    print_success "NeoVim installed ($(nvim --version | head -n1))"
}

# Install Rust
install_rust() {
    if command -v rustc &> /dev/null; then
        print_warning "Rust is already installed ($(rustc --version))"
        return
    fi
    
    print_info "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
    print_success "Rust installed ($(rustc --version))"
}

# Install LSP servers
install_lsp_servers() {
    print_info "Installing LSP servers for Node.js..."
    npm install -g typescript-language-server @vtsls/language-server eslint_d prettier
    print_success "LSP servers installed"
}

# Copy configuration
install_config() {
    print_info "Installing NeoVim configuration..."
    
    # Create backup of existing configuration
    if [ -d ~/.config/nvim ]; then
        print_warning "Found existing NeoVim configuration"
        backup_dir=~/.config/nvim.backup.$(date +%Y%m%d_%H%M%S)
        mv ~/.config/nvim "$backup_dir"
        print_info "Backup created: $backup_dir"
    fi
    
    # Copy new configuration
    cp -r .config ~/.config
    print_success "NeoVim configuration installed"
}

# Check API key
check_api_key() {
    if [ -z "$OPENAI_API_KEY" ]; then
        print_warning "OpenRouter API key is not configured"
        echo
        print_info "To configure API key, run:"
        echo "echo 'export OPENAI_API_KEY=\"your_openrouter_api_key\"' >> ~/.bashrc"
        echo "source ~/.bashrc"
        echo
        print_info "Get API key at: https://openrouter.ai/"
    else
        print_success "OpenRouter API key is configured"
    fi
}

# Final check
final_check() {
    print_info "Checking installation..."
    
    # Check commands
    commands=("nvim" "node" "npm" "rustc")
    for cmd in "${commands[@]}"; do
        if command -v "$cmd" &> /dev/null; then
            print_success "$cmd installed"
        else
            print_error "$cmd not found"
        fi
    done
    
    # Check configuration
    if [ -f ~/.config/nvim/init.lua ]; then
        print_success "NeoVim configuration found"
    else
        print_error "NeoVim configuration not found"
    fi
}

# Main function
main() {
    echo "=================================================="
    echo "  NeoVim Configuration with AI Assistant"
    echo "  Installer for Ubuntu/Debian systems"
    echo "=================================================="
    echo
    
    check_os
    check_sudo
    
    print_info "Starting installation..."
    echo
    
    update_system
    install_dependencies
    install_nodejs
    install_neovim
    install_rust
    install_lsp_servers
    install_config
    
    echo
    print_success "Installation completed!"
    echo
    
    check_api_key
    final_check
    
    echo
    echo "=================================================="
    print_info "To launch NeoVim run: nvim"
    print_info "Plugins will install automatically on first launch"
    echo "=================================================="
}

# Run installation
main "$@"
