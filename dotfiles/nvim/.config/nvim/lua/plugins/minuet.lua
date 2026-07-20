vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/milanglacier/minuet-ai.nvim" },
})

require("minuet").setup({
	provider = "openai_fim_compatible",
	n_completions = 1,
	context_window = 4096,
	provider_options = {
		openai_fim_compatible = {
			api_key = "TERM",
			name = "llama.cpp",
			end_point = "http://localhost:8081/v1/completions",
			model = "ornith-9b",
			optional = {
				max_tokens = 4096,
				top_p = 0.9,
			},
			template = {
				prompt = function(prefix, suffix)
					return "<|fim_prefix|>" .. prefix .. "<|fim_suffix|>" .. suffix .. "<|fim_middle|>"
				end,
				suffix = false,
			},
		},
	},
	virtualtext = {
		auto_trigger_ft = { "*" },
		keymap = {
			accept = "<M-l>",
			accept_line = "<M-L>",
			prev = "<M-[>",
			next = "<M-]>",
			dismiss = "<C-]>",
		},
	},
})
