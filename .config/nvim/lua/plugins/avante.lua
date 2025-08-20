-- ~/.config/nvim/lua/plugins/avante.lua
-- Updated AI assistant avante.nvim configuration with OpenRouter

require('avante').setup({
  -- Main settings
  provider = "openai", -- using openai-compatible API for OpenRouter
  mode = "agentic", -- Enable agentic mode for tool usage
  auto_suggestions_provider = "openai", -- Provider for auto-suggestions
  
  -- New provider configuration format
  providers = {
    openai = {
      endpoint = "https://openrouter.ai/api/v1",
      model = "anthropic/claude-sonnet-4",
      timeout = 30000,
      extra_request_body = {
        temperature = 0.75,
        max_tokens = 32768,
      },
      ["local"] = false,
    },
  },

  -- File selector settings
  selector = {
    provider = "telescope", -- "native" | "fzf_lua" | "mini_pick" | "snacks" | "telescope"
    provider_opts = {},
  },

  -- Input settings
  input = {
    provider = "snacks", -- "native" | "dressing" | "snacks"
    provider_opts = {
      title = "Avante Input",
      icon = " ",
      placeholder = "Enter your request...",
    },
  },

  -- Behavior settings
  behaviour = {
    auto_suggestions = false,
    auto_set_highlight_group = true,
    auto_set_keymaps = true,
    auto_apply_diff_after_generation = false,
    support_paste_from_clipboard = false,
    minimize_diff = true,
    enable_token_counting = true,
    auto_approve_tool_permissions = {"bash", "run_node_code", "run_node_file", "run_npm_command"}, -- Automatically approve code execution
  },

  -- Custom tools for Node.js code execution
  custom_tools = {
    {
      name = "run_node_code",
      description = "Execute Node.js code snippet and return results with proper formatting",
      param = {
        type = "table",
        fields = {
          {
            name = "code",
            description = "JavaScript/Node.js code to execute",
            type = "string",
          },
        },
      },
      returns = {
        {
          name = "result",
          description = "Execution result with stdout and stderr",
          type = "string",
        },
        {
          name = "error",
          description = "Error message if execution failed",
          type = "string",
          optional = true,
        },
      },
      func = function(params, on_log, on_complete)
        -- Create temporary file and execute code in visible terminal
        local temp_file = vim.fn.tempname() .. ".js"
        vim.fn.writefile(vim.split(params.code, "\n"), temp_file)
        
        -- Execute in visible terminal using global function
        vim.schedule(function()
          execute_file_in_terminal(temp_file, "node")
          -- Clean up temp file after a delay
          vim.defer_fn(function()
            vim.fn.delete(temp_file)
          end, 1000)
        end)
        
        -- Return immediate feedback
        local formatted_result = string.format(
          "=== Node.js Code Execution ===\nCode executed in terminal below.\nCheck the terminal output for results.\n==============================="
        )
        
        return formatted_result
      end,
    },
    {
      name = "run_node_file",
      description = "Execute a Node.js file and return results",
      param = {
        type = "table",
        fields = {
          {
            name = "file_path",
            description = "Path to the JavaScript/Node.js file to execute",
            type = "string",
          },
          {
            name = "args",
            description = "Optional command line arguments",
            type = "string",
            optional = true,
          },
        },
      },
      returns = {
        {
          name = "result",
          description = "Execution result with stdout and stderr",
          type = "string",
        },
        {
          name = "error",
          description = "Error message if execution failed",
          type = "string",
          optional = true,
        },
      },
      func = function(params, on_log, on_complete)
        local args = params.args or ""
        local file_with_args = params.file_path .. (args ~= "" and " " .. args or "")
        
        -- Execute file in visible terminal using global function
        vim.schedule(function()
          execute_file_in_terminal(file_with_args, "node")
        end)
        
        -- Return immediate feedback
        local formatted_result = string.format(
          "=== Node.js File Execution ===\nFile: %s\nArguments: %s\nExecuted in terminal below.\nCheck the terminal output for results.\n==================================",
          params.file_path,
          args
        )
        
        return formatted_result
      end,
    },
    {
      name = "run_npm_command",
      description = "Execute npm commands (install, test, run, etc.) and return results",
      param = {
        type = "table",
        fields = {
          {
            name = "command",
            description = "NPM command to execute (e.g., 'install', 'test', 'run dev')",
            type = "string",
          },
        },
      },
      returns = {
        {
          name = "result",
          description = "NPM command execution result",
          type = "string",
        },
        {
          name = "error",
          description = "Error message if execution failed",
          type = "string",
          optional = true,
        },
      },
      func = function(params, on_log, on_complete)
        -- Execute npm command in visible terminal using global function
        vim.schedule(function()
          execute_npm_in_terminal(params.command)
        end)
        
        -- Return immediate feedback
        local formatted_result = string.format(
          "=== NPM Command Execution ===\nCommand: npm %s\nExecuted in terminal below.\nCheck the terminal output for results.\n=================================",
          params.command
        )
        
        return formatted_result
      end,
    },
  },

  -- Window settings
  windows = {
    position = "right",
    wrap = true,
    width = 30,
    sidebar_header = {
      align = "center",
      rounded = true,
    },
  },

  -- Syntax highlighting
  highlights = {
    diff = {
      current = "DiffText",
      incoming = "DiffAdd",
    },
  },

  -- Key mappings
  mappings = {
    diff = {
      ours = "co",
      theirs = "ct",
      all_theirs = "ca",
      both = "cb",
      cursor = "cc",
      next = "]x",
      prev = "[x",
    },
    suggestion = {
      accept = "<M-l>",
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
    jump = {
      next = "]]",
      prev = "[[",
    },
    submit = {
      normal = "<CR>",
      insert = "<C-s>",
    },
    sidebar = {
      apply_all = "A",
      apply_cursor = "a",
      switch_windows = "<Tab>",
      reverse_switch_windows = "<S-Tab>",
    },
  },

  -- Hints settings - disable all hints
  hints = { enabled = false },

  -- UI settings for clean interface
  ui = {
    show_hints = false,
    show_token_count = false,
    show_submit_hint = false,
    show_placeholder = false,
  },

  -- Diff settings
  diff = {
    autojump = true,
    debug = false,
    list_opener = "copen",
  },
})

-- Additional keymaps for avante
vim.keymap.set("n", "<leader>aa", function() require("avante.api").ask() end, { desc = "avante: ask" })
vim.keymap.set("v", "<leader>aa", function() require("avante.api").ask() end, { desc = "avante: ask" })
vim.keymap.set("n", "<leader>ar", function() require("avante.api").refresh() end, { desc = "avante: refresh" })
vim.keymap.set("n", "<leader>ae", function() require("avante.api").edit() end, { desc = "avante: edit" })
vim.keymap.set("n", "<leader>at", function() require("avante").toggle() end, { desc = "avante: toggle" })

-- Commands for quick access
vim.api.nvim_create_user_command("AvanteAsk", function()
  require("avante.api").ask()
end, { desc = "Ask Avante AI" })

vim.api.nvim_create_user_command("AvanteToggle", function()
  require("avante").toggle()
end, { desc = "Toggle Avante sidebar" })

vim.api.nvim_create_user_command("AvanteRefresh", function()
  require("avante.api").refresh()
end, { desc = "Refresh Avante" })
