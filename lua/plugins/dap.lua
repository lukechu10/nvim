return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local wk = require("which-key")
			wk.register({
				["<leader>"] = {
					d = {
						name = "debug",
						s = {
							name = "step",
							c = { "<cmd>lua require('dap').continue()<CR>", "Continue" },
							v = { "<cmd>lua require('dap').step_over()<CR>", "Step Over" },
							i = { "<cmd>lua require('dap').step_into()<CR>", "Step Into" },
							o = { "<cmd>lua require('dap').step_out()<CR>", "Step Out" },
						},
						b = {
							name = "breakpoints",
							t = { "<cmd>lua require('dap').toggle_breakpoint()<CR>", "Toggle Breakpoint" },
							c = { "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
								"Set Conditional Breakpoint" },
							m = {
								"<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
								"Set Log Point" },
						}
					}
				},
				["<F5>"] = { "<cmd>lua require('dap').continue()<CR>", "Continue" },
				["S-<F5>"] = { "<cmd>lua require('dap').stop()<CR>", "Continue" },
				["<F9>"] = { "<cmd>lua require('dap').toggle_breakpoint()<CR>", "Toggle Breakpoint" },
				["<F11>"] = { "<cmd>lua require('dap').step_into()<CR>", "Step Into" },
				["S-<F11>"] = { "<cmd>lua require('dap').step_out()<CR>", "Step Out" },
				["<F10>"] = { "<cmd>lua require('dap').step_over()<CR>", "Step Over" },
			})

			local dap = require("dap")

			local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
			local codelldb_path = mason_path .. "bin/codelldb"
			local this_os = vim.loop.os_uname().sysname

			-- The path in windows is different
			if this_os:find "Windows" then
				codelldb_path = mason_path .. "packages\\codelldb\\extension\\adapter\\codelldb.exe"
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

			require("dap.ext.vscode").load_launchjs(nil, { lldb = { "c", "cpp", "rust" } })
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("nvim-dap-virtual-text").setup()
		end
	},
	{
		"rcarriga/nvim-dap-ui",
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
