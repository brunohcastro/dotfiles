-- Core UI: dependencies, notifications, command palette, input UI
return {
	{ "nvim-lua/plenary.nvim", lazy = true },
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{ "MunifTanjim/nui.nvim", lazy = true },

	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			dashboard = { enabled = false },
			explorer = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			picker = { enabled = true },
			notifier = { enabled = true },
			health = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
		},
	},

	{
		"folke/noice.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				progress = { enabled = true },
				hover = { enabled = true, silent = true, view = "hover" },
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
				lsp_doc_border = true,
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "exit",
					},
					opts = { skip = true },
				},
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true },
				},
				{
					view = "split",
					filter = { event = "msg_show", min_height = 20 },
				},
			},
		},
	},
}
