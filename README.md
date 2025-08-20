# NeoVim LazyVim Configuration with AI Assistant

A modern, VS Code-like NeoVim configuration based on LazyVim with integrated AI assistant for Node.js development.

## Features

### 🤖 AI Assistant Integration
- **Avante.nvim** with OpenRouter API support
- Custom tools for Node.js code execution
- Agentic mode for advanced AI interactions
- Real-time code execution in visible terminals

### 🚀 Modern Development Environment
- **LazyVim** base configuration for VS Code-like experience
- Enhanced terminal management with ToggleTerm
- Neo-tree file explorer with Git integration
- Package.json management with real-time updates
- Stable plugin configuration for reliable performance

### 📦 Node.js Development Tools
- TypeScript/JavaScript enhanced support
- NPM package management
- Node.js REPL integration
- Specialized terminals for different tasks
- LSP support with Mason

### 🎨 Beautiful Interface
- Modern UI with clean design
- Git status indicators
- Syntax highlighting with Treesitter
- Customizable themes and layouts
- Smooth panel transitions

## Project Structure

```
.config/nvim/
├── init.lua                    # Main configuration entry point
├── lua/
│   ├── config/
│   │   ├── autocmds.lua       # Auto commands
│   │   ├── keymaps.lua        # Key mappings
│   │   ├── lazy.lua           # Lazy.nvim plugin manager setup
│   │   └── options.lua        # NeoVim options
│   └── plugins/
│       ├── avante.lua         # AI assistant configuration
│       └── nodejs.lua         # Node.js development plugins
├── .gitignore                 # LazyVim gitignore
├── .neoconf.json             # Project-specific settings
└── stylua.toml               # Lua formatter configuration
```

## Installation

### Prerequisites

- NeoVim 0.9.0+
- Node.js 18+
- Git
- A terminal with true color support
- OpenRouter API key

### Quick Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/hashfoundry/nvim-setup.git
   cd nvim-setup
   ```

2. **Install on Ubuntu Server:**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **Manual installation:**
   ```bash
   # Backup existing config
   mv ~/.config/nvim ~/.config/nvim.backup

   # Copy configuration
   cp -r .config/nvim ~/.config/

   # Set OpenRouter API key
   export OPENROUTER_API_KEY="your-api-key-here"
   ```

4. **First launch:**
   ```bash
   nvim
   ```
   LazyVim will automatically install all plugins on first launch.

## Configuration

### OpenRouter API Setup

1. Get your API key from [OpenRouter](https://openrouter.ai/)
2. Set the environment variable:
   ```bash
   export OPENROUTER_API_KEY="your-api-key-here"
   ```
3. Add to your shell profile for persistence:
   ```bash
   echo 'export OPENROUTER_API_KEY="your-api-key-here"' >> ~/.bashrc
   ```

### Key Mappings

#### AI Assistant (Avante)
- `<leader>aa` - Ask AI assistant
- `<leader>ar` - Refresh AI response
- `<leader>ae` - Edit with AI
- `<leader>at` - Toggle AI sidebar

#### File Management
- `<leader>e` - Toggle Neo-tree file explorer
- `<leader>o` - Focus Neo-tree
- `<leader>ff` - Find files (Telescope)
- `<leader>fg` - Live grep (Telescope)

#### Terminal Management
- `<C-\>` - Toggle floating terminal
- `<leader>tn` - Toggle Node.js REPL
- `<leader>tp` - Toggle NPM terminal

#### Package Management
- `<leader>ns` - Show package info
- `<leader>nt` - Toggle package info
- `<leader>nu` - Update package
- `<leader>ni` - Install package


## Usage Examples

### AI-Assisted Development

1. **Ask AI for help:**
   - Select code and press `<leader>aa`
   - Type your question or request
   - AI will analyze and provide suggestions

2. **Execute Node.js code:**
   - AI can run code snippets directly in terminal
   - Results appear in visible terminal window
   - Supports npm commands and file execution

### Node.js Development

1. **Package management:**
   - Open package.json
   - Use `<leader>ns` to see package information
   - Use `<leader>nu` to update packages

2. **Terminal workflows:**
   - `<leader>tn` for Node.js REPL
   - `<leader>tp` for NPM commands
   - `<C-\>` for general terminal


## Customization

### Adding New Plugins

Create new files in `lua/plugins/` directory:

```lua
-- lua/plugins/my-plugin.lua
return {
  "author/plugin-name",
  opts = {
    -- plugin configuration
  },
  config = function(_, opts)
    require("plugin-name").setup(opts)
  end,
}
```

### Modifying AI Configuration

Edit `lua/plugins/avante.lua` to:
- Change AI model
- Add custom tools
- Modify UI settings
- Update key mappings

### Theme Customization

LazyVim comes with multiple themes. Change in `lua/config/options.lua`:

```lua
vim.cmd.colorscheme("tokyonight")
-- or
vim.cmd.colorscheme("catppuccin")
```

## Troubleshooting

### Common Issues

1. **AI Assistant not working:**
   - Check OpenRouter API key is set
   - Verify internet connection
   - Check `:checkhealth avante`

2. **Plugins not loading:**
   - Run `:Lazy sync` to update plugins
   - Check `:Lazy health` for issues
   - Restart NeoVim

3. **LSP not working:**
   - Run `:Mason` to install language servers
   - Check `:LspInfo` for status
   - Verify Node.js is installed

4. **Terminal issues:**
   - Check shell configuration
   - Verify terminal supports true colors
   - Try different terminal direction

### Performance Optimization

1. **Disable unused features:**
   ```lua
   -- In lua/config/options.lua
   vim.opt.backup = false
   vim.opt.swapfile = false
   ```

2. **Lazy load plugins:**
   ```lua
   -- In plugin configurations
   lazy = true,
   event = "VeryLazy",
   ```

## Development Workflow

### Typical Session

1. **Start NeoVim:**
   ```bash
   nvim
   ```

2. **Open project:**
   - `<leader>e` to open file explorer
   - Navigate and open files

3. **AI-assisted coding:**
   - Select code, press `<leader>aa`
   - Ask for improvements or explanations
   - Let AI execute code snippets

4. **Testing and debugging:**
   - Use `<leader>tn` for Node.js REPL
   - Use `<leader>tp` for NPM commands
   - Monitor with integrated terminal

### Git Integration

- Git status in file explorer
- Git signs in editor
- Use `:Git` commands or external terminal

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This configuration is open source and available under the MIT License.

## Support

- Create issues on GitHub for bugs
- Check LazyVim documentation for base features
- Consult Avante.nvim docs for AI features

---

**Note:** This configuration is optimized for Node.js development but can be easily extended for other languages by adding appropriate plugins and LSP configurations.
