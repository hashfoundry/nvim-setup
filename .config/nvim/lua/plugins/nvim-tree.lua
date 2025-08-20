-- ~/.config/nvim/lua/plugins/nvim-tree.lua
-- File manager configuration

require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

-- Function to close Avante if open
local function close_avante_if_open()
  -- Check if avante is open and close it
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) then
      local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
      if ft == 'Avante' or ft == 'AvanteInput' then
        -- Close avante
        if require("avante").toggle then
          require("avante").toggle()
          return true
        end
      end
    end
  end
  return false
end

-- Custom toggle function that handles avante interaction
local function nvimtree_toggle_with_avante()
  -- Close avante if it's open
  close_avante_if_open()
  
  -- Small delay to ensure avante is closed before opening nvim-tree
  vim.defer_fn(function()
    vim.cmd('NvimTreeToggle')
    -- Update terminal sizes after nvim-tree toggle
    if _G.update_terminal_sizes then
      vim.defer_fn(_G.update_terminal_sizes, 100)
    end
  end, 50)
end

-- Keymaps for nvim-tree
vim.keymap.set('n', '<leader>e', nvimtree_toggle_with_avante, { desc = 'Toggle file explorer' })
