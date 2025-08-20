-- ~/.config/nvim/lua/plugins/treesitter.lua
-- Treesitter configuration for syntax highlighting

require('nvim-treesitter.configs').setup({
  ensure_installed = {
    "javascript",
    "typescript",
    "tsx",
    "json",
    "html",
    "css",
    "lua",
    "vim",
    "markdown",
    "markdown_inline",
  },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true
  },
})
