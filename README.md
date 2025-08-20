# Neovim configuration in Lua

Complete NeoVim configuration in Lua, focused on productivity and simplicity for Node.js development.

## Features

- 🔧 **LSP Support** - TypeScript, JavaScript, JSON, HTML, CSS
- 📝 **Autocompletion** - nvim-cmp with LSP integration
- 🌳 **Syntax Highlighting** - Treesitter
- 📁 **File Manager** - nvim-tree
- 🔍 **File Search** - Telescope
- 🔀 **Git Integration** - Gitsigns
- 📊 **Status Line** - Lualine
- 🖥️ **Terminal Management** - ToggleTerm
- 🎨 **Theme** - Tokyo Night

## Requirements

- Ubuntu 24.04 LTS (or compatible system)
- Git
- Node.js LTS
- Rust (for compiling avante.nvim)
- OpenRouter API key

## Project Structure

```
├── .gitignore                   # Git ignore patterns
├── install.sh                  # Automated installation script
├── README.md                   # Project documentation
└── .config/
    └── nvim/
        ├── init.lua            # Main configuration
        └── lua/
            ├── config/
            │   └── lazy.lua    # Plugin manager configuration
            └── plugins/
                ├── avante.lua      # AI assistant configuration
                ├── lsp.lua         # LSP configuration
                ├── cmp.lua         # Autocompletion setup
                ├── treesitter.lua  # Syntax highlighting
                ├── nvim-tree.lua   # File manager
                ├── telescope.lua   # File search
                ├── gitsigns.lua    # Git integration
                ├── lualine.lua     # Status line
                └── toggleterm.lua  # Terminal management
```

## Getting Started

### 1. Clone Repository

```bash
git clone https://github.com/hashfoundry/nvim-setup.git ~/neovim-config
cd ~/neovim-config
```

### 2. Set Up API Key

```bash
echo 'export OPENAI_API_KEY="your_openrouter_api_key"' >> ~/.bashrc
source ~/.bashrc
```
**Replace `your_openrouter_api_key` with your actual OpenRouter API key!**

## Quick Installation

### 1. Run Installation Script

```bash
chmod +x install.sh
./install.sh
```

### 2. First Launch

```bash
nvim
```
Plugins will install automatically on first launch.

## Manual Installation

### Step 1: Update System

```bash
sudo apt update && sudo apt upgrade -y
```

### Step 2: Install Dependencies

```bash
sudo apt install -y curl wget git build-essential unzip software-properties-common
```

### Step 3: Install Node.js

```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### Step 4: Install NeoVim

```bash
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo tar -xzf nvim-linux-x86_64.tar.gz -C /opt/
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
```

### Step 5: Install Rust (required for avante.nvim)

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.cargo/env
```

### Step 6: Install LSP Servers

```bash
npm install -g typescript-language-server @vtsls/language-server eslint_d prettier
```

### Step 7: Copy Configuration

```bash
cp -r .config ~/.config
```

### Step 8: First Launch

```bash
nvim
```
Plugins will install automatically on first launch.

## Key Bindings

### AI Assistant (Avante)
- `<Space>aa` - Ask AI
- `<Space>at` - Toggle AI sidebar
- `<Space>ar` - Refresh AI
- `<Space>ae` - Edit with AI
- `:AvanteAsk` - AI ask command

### LSP
- `gd` - Go to definition
- `K` - Show documentation
- `<Space>vca` - Code actions
- `<Space>vrn` - Rename
- `<Space>f` - Format code
- `[d` / `]d` - Navigate diagnostics

### File Manager
- `<Space>e` - Toggle file manager

### Search (Telescope)
- `<Space>ff` - Find files
- `<Space>fg` - Live grep
- `<Space>fb` - Find buffers
- `<Space>fh` - Help tags

### Terminal (ToggleTerm)
- `<C-\>` - Toggle terminal
- `<Space>tn` - New terminal
- `<Space>tf` - Float terminal

### General
- `<Space>` - Leader key
- `<C-d>` / `<C-u>` - Scroll with centering
- `J` / `K` (visual mode) - Move lines

## Usage

### AI Assistant Features
- **Code Analysis**: Ask questions about your code
- **Code Generation**: Generate code snippets and functions
- **Debugging Help**: Get assistance with debugging
- **Code Review**: Get suggestions for code improvements
- **Documentation**: Generate documentation for your code

### Development Workflow
1. Open NeoVim in your project directory
2. Use `<Space>e` to browse files
3. Use `<Space>ff` to quickly find files
4. Use `<Space>aa` to ask AI for help
5. Use LSP features for code navigation and completion

## Troubleshooting

### Common Issues

1. **Plugins not installing**: Run `:Lazy sync` in NeoVim
2. **LSP not working**: Check if language servers are installed with `:Mason`
3. **AI not responding**: Verify your OpenRouter API key is set correctly
4. **Rust compilation errors**: Ensure Rust is properly installed and updated

### Getting Help

- Use `:checkhealth` in NeoVim to diagnose issues
- Check plugin documentation with `:help <plugin-name>`
- Review logs in `~/.local/share/nvim/`

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This configuration is provided as-is for educational and development purposes.
