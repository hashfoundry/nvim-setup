-- ~/.config/nvim/lua/plugins/toggleterm.lua
-- Toggleterm.nvim configuration for terminal management

require("toggleterm").setup({
  -- Main settings
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<c-\>]], -- Ctrl+\ to open/close terminal
  hide_numbers = true, -- hide line numbers in terminal
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2, -- degree of shading for inactive terminals
  start_in_insert = true,
  insert_mappings = true, -- apply open_mapping in insert mode
  terminal_mappings = true, -- apply open_mapping in terminal mode
  persist_size = true,
  persist_mode = true, -- preserve terminal mode when switching
  direction = 'horizontal', -- 'vertical' | 'horizontal' | 'tab' | 'float'
  close_on_exit = true, -- close terminal when process exits
  shell = vim.o.shell, -- use system shell
  auto_scroll = true, -- automatically scroll to end of output
  
  -- Floating terminal settings
  float_opts = {
    border = 'curved', -- 'single' | 'double' | 'shadow' | 'curved' | ... other options supported by win open
    width = 120,
    height = 30,
    winblend = 3,
    highlights = {
      border = "Normal",
      background = "Normal",
    },
  },
  
  -- Horizontal terminal settings
  horizontal_opts = {
    size = 15,
  },
  
  -- Vertical terminal settings
  vertical_opts = {
    size = vim.o.columns * 0.4,
  },
})

-- Function to create specialized terminals
local Terminal = require('toggleterm.terminal').Terminal

-- Node.js REPL terminal
local node_repl = Terminal:new({
  cmd = "node",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "double",
    width = 100,
    height = 25,
  },
  -- function to run when opening terminal
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
  end,
  -- function to run when closing terminal
  on_close = function(term)
    vim.cmd("startinsert!")
  end,
})

-- NPM terminal for npm commands
local npm_terminal = Terminal:new({
  cmd = "bash",
  dir = "git_dir",
  direction = "horizontal",
  size = 15,
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
  end,
})

-- Terminal for executing JavaScript files
local js_runner = Terminal:new({
  dir = "git_dir",
  direction = "horizontal",
  size = 15,
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
  end,
})

-- Functions to open specialized terminals
function _NODE_REPL_TOGGLE()
  node_repl:toggle()
end

function _NPM_TERMINAL_TOGGLE()
  npm_terminal:toggle()
end

function _JS_RUNNER_TOGGLE()
  js_runner:toggle()
end

-- Function to execute current JavaScript file
function _RUN_CURRENT_JS_FILE()
  local current_file = vim.fn.expand('%:p')
  if vim.fn.expand('%:e') == 'js' then
    js_runner.cmd = "node " .. current_file
    js_runner:toggle()
  else
    print("Current file is not a JavaScript file")
  end
end

-- Function to execute selected JavaScript code
function _RUN_SELECTED_JS_CODE()
  -- Get selected text
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])
  
  if #lines > 0 then
    -- Create temporary file with selected code
    local temp_file = vim.fn.tempname() .. ".js"
    vim.fn.writefile(lines, temp_file)
    
    -- Execute temporary file
    js_runner.cmd = "node " .. temp_file .. " && rm " .. temp_file
    js_runner:toggle()
  end
end

-- Keymaps for toggleterm
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Toggle floating terminal" })
vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Toggle horizontal terminal" })
vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", { desc = "Toggle vertical terminal" })

-- Specialized terminals
vim.keymap.set("n", "<leader>tn", "<cmd>lua _NODE_REPL_TOGGLE()<CR>", { desc = "Toggle Node.js REPL" })
vim.keymap.set("n", "<leader>tm", "<cmd>lua _NPM_TERMINAL_TOGGLE()<CR>", { desc = "Toggle NPM terminal" })
vim.keymap.set("n", "<leader>tr", "<cmd>lua _RUN_CURRENT_JS_FILE()<CR>", { desc = "Run current JS file" })
vim.keymap.set("v", "<leader>tr", "<cmd>lua _RUN_SELECTED_JS_CODE()<CR>", { desc = "Run selected JS code" })

-- Keymaps for working in terminal
function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- Automatically apply keymaps when opening terminal
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

-- Commands for quick access
vim.api.nvim_create_user_command("NodeRepl", function()
  _NODE_REPL_TOGGLE()
end, { desc = "Open Node.js REPL" })

vim.api.nvim_create_user_command("NpmTerminal", function()
  _NPM_TERMINAL_TOGGLE()
end, { desc = "Open NPM terminal" })

vim.api.nvim_create_user_command("RunJS", function()
  _RUN_CURRENT_JS_FILE()
end, { desc = "Run current JavaScript file" })
