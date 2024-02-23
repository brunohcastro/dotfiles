import({ "copilot", "copilot_cmp" }, function(modules)
	--	local copilot_cmp = modules["copilot_cmp"]
	modules.copilot.setup({
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
					listCount = 10, -- #completions for panel
					inlineSuggestCount = 5, -- #completions for getCompletions
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
					stops = {
						--[[ ["*"] = { ]]
						--[[ 	"\n\n\n", ]]
						--[[ }, ]]
					},
					temperature = "",
					top_p = 1,
				},
			},
		},
	})
	--	copilot_cmp.setup()
end)
