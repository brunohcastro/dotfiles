return {
	{
		"ThePrimeagen/harpoon",
		keys = {
			{
				"<leader>m",
				function()
					require("harpoon.mark").add_file()
				end,
				desc = "Mark file",
			},
			{
				"<leader>fm",
				function()
					require("harpoon.ui").toggle_quick_menu()
				end,
				desc = "Marked files",
			},
		},
		opts = {},
	},

	{
		"hadronized/hop.nvim",
		keys = {
			{ "<leader>hf", "<cmd>HopChar1<cr>", desc = "1 Char" },
			{ "<leader>hh", "<cmd>HopChar2<cr>", desc = "2 Chars" },
			{ "<leader>hl", "<cmd>HopLineStart<cr>", desc = "Line start" },
			{ "<leader>hp", "<cmd>HopPattern<cr>", desc = "Pattern" },
			{ "<leader>hv", "<cmd>HopVertical<cr>", desc = "Vertical" },
			{ "<leader>hw", "<cmd>HopWord<cr>", desc = "Word" },
		},
		opts = {},
	},

	{
		"kylechui/nvim-surround",
		event = "BufReadPost",
		opts = {},
	},

	{
		"numToStr/Comment.nvim",
		event = "BufReadPost",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		config = function()
			local comment_utils = require("Comment.utils")
			local commentstring_utils = require("ts_context_commentstring.utils")
			local commentstring_internal = require("ts_context_commentstring.internal")

			require("Comment").setup({
				pre_hook = function(ctx)
					local U = comment_utils
					local location = nil
					if ctx.ctype == U.ctype.block then
						location = commentstring_utils.get_cursor_location()
					elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
						location = commentstring_utils.get_visual_start_location()
					end
					return commentstring_internal.calculate_commentstring({
						key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
						location = location,
					})
				end,
			})
		end,
	},

	{
		"jiaoshijie/undotree",
		keys = {
			{
				"<leader>ut",
				function()
					require("undotree").toggle()
				end,
				desc = "Toggle",
			},
			{
				"<leader>uo",
				function()
					require("undotree").open()
				end,
				desc = "Open",
			},
			{
				"<leader>uc",
				function()
					require("undotree").close()
				end,
				desc = "Close",
			},
		},
		opts = {},
	},

	{
		"styled-components/vim-styled-components",
		branch = "main",
		ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	},

	{ "ThePrimeagen/vim-be-good", cmd = "VimBeGood" },

	{
		"nvim-orgmode/orgmode",
		event = "VeryLazy",
		config = function()
			require("orgmode").setup({
				org_agenda_files = "~/Dropbox/org/**/*",
				org_default_notes_file = "~/Dropbox/org/inbox.org",
				org_todo_keywords = {
					"TODO(t)",
					"NEXT(n)",
					"IN-PROGRESS(p)",
					"WAITING(w)",
					"|",
					"DONE(d)",
					"CANCELED(c)",
				},
			})

			vim.lsp.enable("org")
		end,
	},
}
