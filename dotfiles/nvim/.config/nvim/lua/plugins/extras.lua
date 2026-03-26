-- Smaller UI/editing enhancements
return {
	-- Search match lens overlay
	{
		"kevinhwang91/nvim-hlslens",
		event = "BufReadPost",
		config = function()
			require("hlslens").setup()
			local kopts = { noremap = true, silent = true }
			vim.api.nvim_set_keymap(
				"n",
				"n",
				[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
				kopts
			)
			vim.api.nvim_set_keymap(
				"n",
				"N",
				[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
				kopts
			)
			vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
			vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
		end,
	},

	-- Scrollbar with diagnostic indicators
	{
		"petertriho/nvim-scrollbar",
		event = "BufReadPost",
		config = function()
			require("scrollbar").setup({
				handlers = { diagnostic = true, search = true },
			})
		end,
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		enable = false,
		event = "BufReadPost",
		config = function()
			require("ibl").setup()
		end,
	},

	-- Cursor word/line highlight
	{
		"yamatsum/nvim-cursorline",
		event = "BufReadPost",
		config = function()
			require("nvim-cursorline").setup({
				cursorline = { enable = true },
				cursorword = { enable = true },
			})
		end,
	},

	-- Inline color previews (#hex, rgb, tailwind)
	{
		"brenoprata10/nvim-highlight-colors",
		event = "BufReadPost",
		config = function()
			require("nvim-highlight-colors").setup({
				render = "background",
				enable_tailwind = true,
			})
		end,
	},

	-- Floating terminal
	{
		"akinsho/toggleterm.nvim",
		keys = { { [[<C-\>]], desc = "Toggle terminal" } },
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<c-\>]],
				terminal_mappings = true,
				insert_mappings = true,
				shade_terminals = false,
				start_in_insert = false,
			})

			function _G.set_terminal_keymaps()
				local opts = { buffer = 0 }
				vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
				vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
			end

			vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
		end,
	},

	-- Tmux pane navigation integration
	-- Must not be lazy: replaces <C-hjkl> navigation globally
	{
		"aserowy/tmux.nvim",
		lazy = false,
		config = function()
			require("tmux").setup()
		end,
	},
}
