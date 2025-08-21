-- AI Assistant Configuration (Avante.nvim)
return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false,
  build = "make",
  opts = {
    provider = "openai",
    auto_suggestions_provider = "openai",
    openai = {
      endpoint = "https://openrouter.ai/api/v1",
      model = "anthropic/claude-3.5-sonnet-20241022",
      timeout = 30000,
      temperature = 0,
      max_tokens = 4096,
    },
    behaviour = {
      auto_suggestions = false,
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
    },
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
    hints = { enabled = true },
    windows = {
      position = "right",
      wrap = true,
      width = 30,
      sidebar_header = {
        align = "center",
        rounded = true,
      },
    },
    highlights = {
      diff = {
        current = "DiffText",
        incoming = "DiffAdd",
      },
    },
    diff = {
      autojump = true,
      list_opener = "copen",
    },
    -- Custom tools for Node.js development
    tools = {
      {
        name = "run_node_code",
        description = "Execute Node.js code snippet",
        command = function(code)
          local temp_file = vim.fn.tempname() .. ".js"
          local file = io.open(temp_file, "w")
          if file then
            file:write(code)
            file:close()
            local result = vim.fn.system("node " .. temp_file)
            vim.fn.delete(temp_file)
            return result
          end
          return "Error: Could not create temporary file"
        end,
      },
      {
        name = "run_node_file",
        description = "Execute current Node.js file",
        command = function()
          local current_file = vim.fn.expand("%:p")
          if vim.fn.fnamemodify(current_file, ":e") == "js" or vim.fn.fnamemodify(current_file, ":e") == "ts" then
            return vim.fn.system("node " .. current_file)
          end
          return "Error: Current file is not a JavaScript/TypeScript file"
        end,
      },
      {
        name = "run_npm_command",
        description = "Execute npm command in current directory",
        command = function(cmd)
          return vim.fn.system("npm " .. cmd)
        end,
      },
    },
  },
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-tree/nvim-web-devicons",
    "zbirenbaum/copilot.lua",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
  keys = {
    { "<leader>aa", function() require("avante.api").ask() end, desc = "avante: ask", mode = { "n", "v" } },
    { "<leader>ar", function() require("avante.api").refresh() end, desc = "avante: refresh" },
    { "<leader>ae", function() require("avante.api").edit() end, desc = "avante: edit", mode = "v" },
    { "<leader>at", function() require("avante.api").toggle() end, desc = "avante: toggle" },
  },
}
