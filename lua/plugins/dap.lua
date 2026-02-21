return {
	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		dependencies = { "nvim-neotest/nvim-nio" },
		config = function()
			local wk = require("which-key")
			wk.add(
				{
					{ "<F10>",       "<cmd>lua require('dap').step_over()<CR>",                                                   desc = "Step Over" },
					{ "<F11>",       "<cmd>lua require('dap').step_into()<CR>",                                                   desc = "Step Into" },
					{ "<F17>",       "<cmd>lua require('dap').close()<CR>",                                                       desc = "Continue" },
					{ "<F23>",       "<cmd>lua require('dap').step_out()<CR>",                                                    desc = "Step Out" },
					{ "<F5>",        "<cmd>lua require('dap').continue()<CR>",                                                    desc = "Continue" },
					{ "<F9>",        "<cmd>lua require('dap').toggle_breakpoint()<CR>",                                           desc = "Toggle Breakpoint" },
					{ "<leader>d",   group = "debug" },
					{ "<leader>db",  group = "breakpoints" },
					{ "<leader>dbc", "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",        desc = "Set Conditional Breakpoint" },
					{ "<leader>dbm", "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", desc = "Set Log Point" },
					{ "<leader>dbt", "<cmd>lua require('dap').toggle_breakpoint()<CR>",                                           desc = "Toggle Breakpoint" },
					{ "<leader>ds",  group = "step" },
					{ "<leader>dsc", "<cmd>lua require('dap').continue()<CR>",                                                    desc = "Continue" },
					{ "<leader>dsi", "<cmd>lua require('dap').step_into()<CR>",                                                   desc = "Step Into" },
					{ "<leader>dso", "<cmd>lua require('dap').step_out()<CR>",                                                    desc = "Step Out" },
					{ "<leader>dsv", "<cmd>lua require('dap').step_over()<CR>",                                                   desc = "Step Over" },
				}
			)

			local dap = require("dap")

			-- First check if the dap is installed via Mason.
			local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
			local this_os = vim.loop.os_uname().sysname
			if this_os:find "Windows" then
				codelldb_path = mason_path .. "packages\\codelldb\\extension\\adapter\\codelldb.exe"
			else
				codelldb_path = mason_path .. "bin/codelldb"
			end

			if not vim.fn.filereadable(codelldb_path) then
				-- TODO: Try to find codelldb from vscode extension.
				print("codelldb not found at " .. codelldb_path)
			end

			dap.adapters.codelldb = {
				type = "server",
				port = "${port}",
				executable = {
					command = codelldb_path,
					args = { "--port", "${port}" },
				}
			}
			dap.adapters.lldb = dap.adapters.codelldb

			dap.configurations.cpp = {
				{
					name = "Launch file",
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					stopOnEntry = false,
				},
			}
			dap.configurations.c = dap.configurations.cpp
			dap.configurations.rust = dap.configurations.cpp
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		event = "VeryLazy",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("nvim-dap-virtual-text").setup()
		end
	},
	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("dapui").setup()
			local dap, dapui = require("dap"), require("dapui")
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end
	}
}
