-- Smaller UI/editing enhancements
vim.pack.add({
	{ src = "https://github.com/kevinhwang91/nvim-hlslens" },
	{ src = "https://github.com/petertriho/nvim-scrollbar" },
	{ src = "https://github.com/yamatsum/nvim-cursorline" },
	{ src = "https://github.com/brenoprata10/nvim-highlight-colors" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
	{ src = "https://github.com/aserowy/tmux.nvim" },
})

-- Search lens (shows match count near the cursor)
require("hlslens").setup()
do
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
end

-- Scrollbar with diagnostic indicators
require("scrollbar").setup({
	handlers = { diagnostic = true, search = true },
})

-- Cursor word/line highlight
require("nvim-cursorline").setup({
	cursorline = { enable = true },
	cursorword = { enable = true },
})

-- Inline color previews (#hex, rgb, tailwind)
require("nvim-highlight-colors").setup({
	render = "background",
	enable_tailwind = true,
})

-- Floating terminal
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

-- Tmux pane navigation integration (replaces <C-hjkl> navigation globally).
-- copy_sync is disabled: a bare setup() turns it on (init.lua's own defaults
-- override the module default), and its register sync throws "Using a Blob as a
-- String" on CmdlineEnter whenever a tmux buffer holds binary/NUL data.
require("tmux").setup({
	copy_sync = { enable = false },
})
