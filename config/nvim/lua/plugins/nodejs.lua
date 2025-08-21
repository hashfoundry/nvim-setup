-- Node.js Development Tools Configuration
return {
  -- ToggleTerm for terminal management
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
      
      local Terminal = require("toggleterm.terminal").Terminal
      
      -- Node.js REPL terminal
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
        cmd = "cmd",
        dir = "git_dir",
        direction = "horizontal",
        on_open = function(term)
          vim.cmd("startinsert!")
          vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
        end,
      })
      
      -- Key mappings
      vim.keymap.set("n", "<leader>tn", function() node_repl:toggle() end, { desc = "Toggle Node.js REPL" })
      vim.keymap.set("n", "<leader>tm", function() npm_terminal:toggle() end, { desc = "Toggle NPM Terminal" })
    end,
  },

  -- Package.json management
  {
    "vuki656/package-info.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    opts = {
      colors = {
        up_to_date = "#3C4048",
        outdated = "#d19a66",
      },
      icons = {
        enable = true,
        style = {
          up_to_date = "|  ",
          outdated = "|  ",
        },
      },
      autostart = true,
      hide_up_to_date = false,
      hide_unstable_versions = false,
      package_manager = "npm",
    },
    config = function(_, opts)
      require("package-info").setup(opts)
      
      -- Key mappings for package-info
      vim.keymap.set("n", "<leader>ns", require("package-info").show, { desc = "Show package versions" })
      vim.keymap.set("n", "<leader>nc", require("package-info").hide, { desc = "Hide package versions" })
      vim.keymap.set("n", "<leader>nt", require("package-info").toggle, { desc = "Toggle package versions" })
      vim.keymap.set("n", "<leader>nu", require("package-info").update, { desc = "Update package on line" })
      vim.keymap.set("n", "<leader>nd", require("package-info").delete, { desc = "Delete package on line" })
      vim.keymap.set("n", "<leader>ni", require("package-info").install, { desc = "Install a new package" })
      vim.keymap.set("n", "<leader>np", require("package-info").change_version, { desc = "Install a different package version" })
    end,
  },

  -- Enhanced TypeScript/JavaScript support
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = {
      on_attach = function(client, bufnr)
        -- Disable formatting capability if you have prettier
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
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
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
    config = function(_, opts)
      require("typescript-tools").setup(opts)
      
      -- Key mappings for TypeScript tools
      vim.keymap.set("n", "<leader>to", "<cmd>TSToolsOrganizeImports<cr>", { desc = "Organize Imports" })
      vim.keymap.set("n", "<leader>ts", "<cmd>TSToolsSortImports<cr>", { desc = "Sort Imports" })
      vim.keymap.set("n", "<leader>tr", "<cmd>TSToolsRemoveUnused<cr>", { desc = "Remove Unused" })
      vim.keymap.set("n", "<leader>tz", "<cmd>TSToolsGoToSourceDefinition<cr>", { desc = "Go to Source Definition" })
      vim.keymap.set("n", "<leader>ti", "<cmd>TSToolsAddMissingImports<cr>", { desc = "Add Missing Imports" })
      vim.keymap.set("n", "<leader>tf", "<cmd>TSToolsFixAll<cr>", { desc = "Fix All" })
    end,
  },

  -- LSP Configuration for TypeScript/JavaScript
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls", -- TypeScript/JavaScript LSP
          "jsonls", -- JSON LSP
          "eslint", -- ESLint LSP
        },
      })

      local lspconfig = require("lspconfig")
      
      -- TypeScript/JavaScript LSP
      lspconfig.ts_ls.setup({
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      })

      -- JSON LSP
      lspconfig.jsonls.setup({
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      })

      -- ESLint LSP
      lspconfig.eslint.setup({
        settings = {
          workingDirectories = { mode = "auto" },
        },
      })
    end,
  },

  -- JSON Schema Store
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- Prettier formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        markdown = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
      
      -- Key mapping for manual formatting
      vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        require("conform").format({ lsp_fallback = true })
      end, { desc = "Format buffer" })
    end,
  },

  -- Mason tool installer for formatters and linters
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "prettier", -- Formatter
        "eslint_d", -- ESLint daemon for faster linting
        "typescript-language-server", -- TypeScript LSP
        "json-lsp", -- JSON LSP
      },
    },
  },

  -- Enhanced Neo-tree configuration for Node.js projects
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      opts.filesystem = opts.filesystem or {}
      opts.filesystem.filtered_items = opts.filesystem.filtered_items or {}
      opts.filesystem.filtered_items.visible = true
      opts.filesystem.filtered_items.hide_dotfiles = false
      opts.filesystem.filtered_items.hide_gitignored = false
      opts.filesystem.filtered_items.hide_by_name = {
        ".DS_Store",
        "thumbs.db",
      }
      opts.filesystem.filtered_items.never_show = {
        ".git",
      }
      
      -- Add Git status integration
      opts.source_selector = opts.source_selector or {}
      opts.source_selector.winbar = true
      opts.source_selector.statusline = false
      opts.source_selector.sources = {
        { source = "filesystem", display_name = " 󰉓 Files " },
        { source = "buffers", display_name = " 󰈚 Buffers " },
        { source = "git_status", display_name = " 󰊢 Git " },
      }
      
      return opts
    end,
  },
}
