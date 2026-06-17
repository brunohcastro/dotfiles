-- Loaded after cmp so copilot-cmp can register the "copilot" source.
vim.pack.add({
	{ src = "https://github.com/zbirenbaum/copilot.lua" },
	{ src = "https://github.com/zbirenbaum/copilot-cmp" },
})

require("copilot").setup({
	suggestion = {
		enable = true,
		auto_trigger = true,
		debounce = 75,
		keymap = {
			accept = "<M-l>",
			accept_word = false,
			accept_line = false,
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
	},
	server_opts_overrides = {
		trace = "verbose",
		settings = {
			advanced = {
				listCount = 10,
				inlineSuggestCount = 5,
				indentationMode = {
					python = false,
					javascript = false,
					javascriptreact = false,
					jsx = false,
					typescript = false,
					typescriptreact = false,
					go = false,
					ruby = false,
					["*"] = true,
				},
				length = 1000,
				stops = {},
				temperature = "",
				top_p = 1,
			},
		},
	},
})

require("copilot_cmp").setup()
