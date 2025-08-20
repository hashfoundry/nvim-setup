-- Node.js development specific plugins (Stable Version)
return {
  -- Enhanced terminal management
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    opts = {
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)
      
      -- Terminal keymaps
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

      -- Apply terminal keymaps
      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

      -- Specialized terminals
      local Terminal = require('toggleterm.terminal').Terminal

      -- Node.js REPL
      local node_repl = Terminal:new({
        cmd = "node",
        dir = "git_dir",
        direction = "float",
        float_opts = {
          border = "double",
        },
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
        end,
        on_close = function(term)
          vim.cmd("startinsert!")
        end,
      })

      -- NPM terminal
      local npm_terminal = Terminal:new({
        cmd = "npm",
        dir = "git_dir",
        direction = "horizontal",
        on_open = function(term)
          vim.cmd("startinsert!")
        end,
      })

      -- Global functions for terminal access
      function _G.node_repl_toggle()
        node_repl:toggle()
      end

      function _G.npm_terminal_toggle()
        npm_terminal:toggle()
      end

      -- Keymaps for specialized terminals
      vim.keymap.set("n", "<leader>tn", "<cmd>lua node_repl_toggle()<CR>", { desc = "Toggle Node.js REPL" })
      vim.keymap.set("n", "<leader>tp", "<cmd>lua npm_terminal_toggle()<CR>", { desc = "Toggle NPM terminal" })
    end,
  },

  -- Package.json management
  {
    "vuki656/package-info.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    opts = {},
    config = function(_, opts)
      require("package-info").setup(opts)
      
      -- Keymaps for package-info
      vim.keymap.set("n", "<leader>ns", require("package-info").show, { desc = "Show package info" })
      vim.keymap.set("n", "<leader>nc", require("package-info").hide, { desc = "Hide package info" })
      vim.keymap.set("n", "<leader>nt", require("package-info").toggle, { desc = "Toggle package info" })
      vim.keymap.set("n", "<leader>nu", require("package-info").update, { desc = "Update package" })
      vim.keymap.set("n", "<leader>nd", require("package-info").delete, { desc = "Delete package" })
      vim.keymap.set("n", "<leader>ni", require("package-info").install, { desc = "Install package" })
      vim.keymap.set("n", "<leader>np", require("package-info").change_version, { desc = "Change package version" })
    end,
  },

  -- Enhanced JavaScript/TypeScript support
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      on_attach = function(client, bufnr)
        -- Disable formatting capability if you're using a different formatter
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        expose_as_code_action = {},
        tsserver_path = nil,
        tsserver_plugins = {},
        tsserver_max_memory = "auto",
        tsserver_format_options = {},
        tsserver_file_preferences = {},
        tsserver_locale = "en",
        complete_function_calls = false,
        include_completions_with_insert_text = true,
        code_lens = "off",
        disable_member_code_lens = true,
        jsx_close_tag = {
          enable = false,
          filetypes = { "javascriptreact", "typescriptreact" },
        },
      },
    },
  },

  -- Enhanced file explorer configuration (LazyVim already includes neo-tree)
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        width = 40,
        position = "left",
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {
            "node_modules",
            ".git",
            ".DS_Store",
          },
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
      },
      default_component_configs = {
        git_status = {
          symbols = {
            added     = "✚",
            modified  = "",
            deleted   = "✖",
            renamed   = "",
            untracked = "",
            ignored   = "",
            unstaged  = "",
            staged    = "",
            conflict  = "",
          }
        },
      },
    },
  },

  -- Enable TypeScript/JavaScript language support
  {
    "LazyVim/LazyVim",
    opts = {
      extras = {
        "lazyvim.plugins.extras.lang.typescript",
        "lazyvim.plugins.extras.lang.json",
        "lazyvim.plugins.extras.formatting.prettier",
        "lazyvim.plugins.extras.linting.eslint",
      },
    },
  },
}
