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
	})
	--	copilot_cmp.setup()
end)
