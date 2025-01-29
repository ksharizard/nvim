  -- REPL
return {
  -- {
  -- -- REPL
  --   "Vigemus/iron.nvim",
  --   ft = "python",
  --   keys = {
  --     { "<leader>rr", vim.cmd.IronRepl,             desc = "Toggle REPL" },
  --     { "<leader>rr", vim.cmd.IronRestart,          desc = "Restart REPL" },
  --
  --     { "+",         mode = { "n", "x" },          desc = "?? Send-to-REPL Operator" },
  --     { "++",        desc = "?? Send Line to REPL" },
  --   },
  --   main = "iron.core",
  --   opts = {
  --     scratch_repl = true,
  --     keymaps = {
  --       send_line = "++",
  --       visual_send = "+",
  --       send_motion = "+",
  --     },
  --     config = {
  --       repl_open_cmd = "horizontal bot 10 split",
  --
  --       repl_definition = {
  --         python = {
  --           command = function()
  --             local ipythonAvailable = vim.fn.executable("ipython") == 1
  --             local binary = ipythonAvailable and "ipython" or "python3"
  --             return { binary }
  --           end,
  --           format = require("iron.fts.common").bracketed_paste_python
  --         },
  --       },
  --     },
  --   },
  -- },

	-- DEBUGGING

	-- DAP Client for nvim
	-- * start the debugger with `<leader>dc`
	-- * add breakpoints with `<leader>db`
	-- * terminate the debugger `<leader>dt`
	{
		"mfussenegger/nvim-dap",
		keys = {
			{
				"<leader>dc",
				function() require("dap").continue() end,
				desc = "Start/Continue Debugger",
			},
			{
				"<leader>db",
				function() require("dap").toggle_breakpoint() end,
				desc = "Add Breakpoint",
			},
			{
				"<leader>dt",
				function() require("dap").terminate() end,
				desc = "Terminate Debugger",
			},
		},
	},

	-- UI for the debugger
	-- * the debugger UI is also automatically opened when starting/stopping the debugger
	-- * toggle debugger UI manually with `<leader>du`
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		keys = {
			{
				"<leader>du",
				function() require("dapui").toggle() end,
				desc = "Toggle Debugger UI",
			},
		},

		-- automatically open/close the DAP UI when starting/stopping the debugger
		config = function()
			local listener = require("dap").listeners
			listener.after.event_initialized["dapui_config"] = function() require("dapui").open() end
		end,
	},

	-- Configuration for the python debugger
	-- * configures debugpy for us
	-- * uses the debugpy installation from mason
	{
		"mfussenegger/nvim-dap-python",
		dependencies = "mfussenegger/nvim-dap",
    ft = "python",
		config = function()
			-- fix: E5108: Error executing lua .../Local/nvim-data/lazy/nvim-dap-ui/lua/dapui/controls.lua:14: attempt to index local 'element' (a nil value)
			-- see: https://github.com/rcarriga/nvim-dap-ui/issues/279#issuecomment-1596258077
			require("dapui").setup()
			-- uses the debugypy installation by mason
			local debugpyPythonPath = require("mason-registry").get_package("debugpy"):get_install_path()
				.. "/venv/bin/python3"
			require("dap-python").setup(debugpyPythonPath, {}) ---@diagnostic disable-line: missing-fields
		end,
	},

  -- Docstring creation
  {
    "danymat/neogen",
    opts = true,
    keys = {
      {
        "<leader>a",
        function() require("neogen").generate() end,
        desc = "Add Docstring",
      },
    },
  },

  -- f-strings
  {
    "chrisgrieser/nvim-puppeteer",
    dependencies = "nvim-treesitter/nvim-treesitter",
    ft = "python",
  },

  -- better indentation behavior
  { "Vimjas/vim-python-pep8-indent" },

  -- select virtual environments
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
      "mfussenegger/nvim-dap-python",
    },
    branch = "regexp",
    ft = "python",
    opts = {
      dap_enabled = true,
    },
    keys = {
      { "<leader>v", "<cmd>VenvSelect<cr>", desc = "Select venv" },
    },
  },
}
