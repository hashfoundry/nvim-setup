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
        -- Create temporary file and execute code
        local temp_file = vim.fn.tempname() .. ".js"
        vim.fn.writefile(vim.split(params.code, "\n"), temp_file)
        
        -- Execute code and get result
        local result = vim.fn.system(string.format("cd %s && node %s 2>&1", vim.fn.getcwd(), temp_file))
        local exit_code = vim.v.shell_error
        
        -- Delete temporary file
        vim.fn.delete(temp_file)
        
        -- Format result
        local formatted_result = string.format(
          "=== Node.js Execution Result ===\nExit Code: %d\nOutput:\n%s\n================================",
          exit_code,
          result
        )
        
        if exit_code ~= 0 then
          return formatted_result, "Execution failed with exit code " .. exit_code
        else
          return formatted_result
        end
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
        local cmd = string.format("cd %s && node %s %s 2>&1", vim.fn.getcwd(), params.file_path, args)
        
        -- Execute file
        local result = vim.fn.system(cmd)
        local exit_code = vim.v.shell_error
        
        -- Format result
        local formatted_result = string.format(
          "=== Node.js File Execution Result ===\nFile: %s\nCommand: %s\nExit Code: %d\nOutput:\n%s\n=====================================",
          params.file_path,
          cmd,
          exit_code,
          result
        )
        
        if exit_code ~= 0 then
          return formatted_result, "Execution failed with exit code " .. exit_code
        else
          return formatted_result
        end
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
        local cmd = string.format("cd %s && npm %s 2>&1", vim.fn.getcwd(), params.command)
        
        -- Execute npm command
        local result = vim.fn.system(cmd)
        local exit_code = vim.v.shell_error
        
        -- Format result
        local formatted_result = string.format(
          "=== NPM Command Execution Result ===\nCommand: npm %s\nExit Code: %d\nOutput:\n%s\n====================================",
          params.command,
          exit_code,
          result
        )
        
        if exit_code ~= 0 then
          return formatted_result, "NPM command failed with exit code " .. exit_code
        else
          return formatted_result
        end
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
