--[[
  Debug Adapter Protocol (DAP) Configuration

  nvim-dap provides debugging support for Neovim, similar to VSCode's debugger.
  This configuration includes debuggers for:
  - Go (delve)
  - Rust (codelldb)

  SETUP INSTRUCTIONS:

  Go (delve):
  - Install: go install github.com/go-delve/delve/cmd/dlv@latest
  - Ensure $GOPATH/bin is in your PATH

  Rust (codelldb):
  - Mason will auto-install codelldb
  - Works out of the box

  Keybindings:
  - <leader>db: Toggle breakpoint
  - <leader>dB: Breakpoint with condition
  - <leader>dc: Continue/start debugging
  - <leader>dC: Run to cursor
  - <leader>di: Step into
  - <leader>do: Step over
  - <leader>dO: Step out
  - <leader>dr: Restart debugging
  - <leader>dt: Terminate debugging
  - <leader>du: Toggle UI
  - <leader>dh: Hover variables
  - <leader>dp: Preview value
  - <F5>: Continue
  - <F10>: Step over
  - <F11>: Step into
  - <F12>: Step out
--]]

return {
  -- ============================================================================
  -- NVIM-DAP: DEBUG ADAPTER PROTOCOL
  -- ============================================================================
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- Mason integration for automatic debugger installation
      "jay-babu/mason-nvim-dap.nvim",

      -- UI for DAP
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",

      -- Virtual text showing variable values
      "theHamsta/nvim-dap-virtual-text",

      -- Language-specific extensions
      "leoluz/nvim-dap-go",    -- Go debugging helpers
    },
    keys = {
      -- Breakpoints
      {
        "<leader>db",
        function() require("dap").toggle_breakpoint() end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Breakpoint Condition",
      },

      -- Execution control
      {
        "<leader>dc",
        function() require("dap").continue() end,
        desc = "Continue/Start",
      },
      {
        "<leader>dC",
        function() require("dap").run_to_cursor() end,
        desc = "Run to Cursor",
      },
      {
        "<leader>di",
        function() require("dap").step_into() end,
        desc = "Step Into",
      },
      {
        "<leader>do",
        function() require("dap").step_over() end,
        desc = "Step Over",
      },
      {
        "<leader>dO",
        function() require("dap").step_out() end,
        desc = "Step Out",
      },
      {
        "<leader>dr",
        function() require("dap").restart() end,
        desc = "Restart",
      },
      {
        "<leader>dt",
        function() require("dap").terminate() end,
        desc = "Terminate",
      },

      -- UI
      {
        "<leader>du",
        function() require("dapui").toggle() end,
        desc = "Toggle Debug UI",
      },
      {
        "<leader>dh",
        function() require("dap.ui.widgets").hover() end,
        desc = "Hover Variables",
      },
      {
        "<leader>dp",
        function() require("dap.ui.widgets").preview() end,
        desc = "Preview",
      },

      -- Function keys (VSCode-style)
      {
        "<F5>",
        function() require("dap").continue() end,
        desc = "Continue",
      },
      {
        "<F10>",
        function() require("dap").step_over() end,
        desc = "Step Over",
      },
      {
        "<F11>",
        function() require("dap").step_into() end,
        desc = "Step Into",
      },
      {
        "<F12>",
        function() require("dap").step_out() end,
        desc = "Step Out",
      },
    },
    config = function()
      local dap = require("dap")

      -- ======================================================================
      -- UI CONFIGURATION
      -- ======================================================================

      -- Define custom signs for breakpoints
      vim.fn.sign_define("DapBreakpoint", {
        text = "",
        texthl = "DiagnosticError",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapBreakpointCondition", {
        text = "",
        texthl = "DiagnosticWarn",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapBreakpointRejected", {
        text = "",
        texthl = "DiagnosticError",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapStopped", {
        text = "→",
        texthl = "DiagnosticInfo",
        linehl = "Visual",
        numhl = "DiagnosticInfo",
      })
      vim.fn.sign_define("DapLogPoint", {
        text = "",
        texthl = "DiagnosticInfo",
        linehl = "",
        numhl = "",
      })

      -- ======================================================================
      -- GO DEBUGGING CONFIGURATION (delve)
      -- ======================================================================

      -- nvim-dap-go provides better Go debugging setup
      require("dap-go").setup({
        -- Additional dap configurations can be added.
        -- dap_configurations accepts a list of tables where each entry
        -- represents a dap configuration. For more details do:
        -- :help dap-configuration
        dap_configurations = {
          {
            type = "go",
            name = "Debug (from vscode-go)",
            request = "launch",
            program = "${file}",
          },
          {
            type = "go",
            name = "Debug test (go.mod)",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}",
          },
        },
        -- delve configurations
        delve = {
          -- Path to delve binary (default: dlv)
          path = "dlv",
          -- Whether to initialize delve configurations
          initialize_timeout_sec = 20,
          -- Port to start delve debugger server on
          port = "${port}",
          args = {},
          build_flags = "",
        },
      })

      -- ======================================================================
      -- RUST DEBUGGING CONFIGURATION (codelldb)
      -- ======================================================================

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          -- Mason will install codelldb to this path
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.rust = {
        {
          name = "Launch file",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          name = "Attach to process",
          type = "codelldb",
          request = "attach",
          pid = require("dap.utils").pick_process,
          args = {},
        },
      }

      -- ======================================================================
      -- DAP UI INTEGRATION
      -- ======================================================================

      local dapui = require("dapui")

      -- Setup dap-ui with default configuration
      dapui.setup({
        icons = { expanded = "", collapsed = "", current_frame = "" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes",      size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks",      size = 0.25 },
              { id = "watches",     size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl",    size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
        },
      })

      -- Automatically open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- ======================================================================
      -- VIRTUAL TEXT
      -- ======================================================================

      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        filter_references_pattern = "<module",
        virt_text_pos = "eol",
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
      })
    end,
  },

  -- ============================================================================
  -- MASON DAP: AUTOMATIC DEBUGGER INSTALLATION
  -- ============================================================================
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      -- Automatically install these debuggers
      ensure_installed = {
        "codelldb", -- Rust, C, C++
        "delve",    -- Go
      },
      automatic_installation = true,
      handlers = {},
    },
  },

  -- ============================================================================
  -- DAP UI
  -- ============================================================================
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
  },

  -- ============================================================================
  -- DAP VIRTUAL TEXT
  -- ============================================================================
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
  },

  -- ============================================================================
  -- GO DAP HELPERS
  -- ============================================================================
  {
    "leoluz/nvim-dap-go",
    dependencies = "mfussenegger/nvim-dap",
    ft = "go",
  },
}
