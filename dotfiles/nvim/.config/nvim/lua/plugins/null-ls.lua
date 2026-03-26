return {
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
			"jayp0521/mason-null-ls.nvim",
		},
		config = function()
			require("overdevio.lsp.null-ls")
		end,
	},
}
