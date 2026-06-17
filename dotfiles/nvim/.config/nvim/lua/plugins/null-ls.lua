-- Formatters & linters via none-ls. Loaded after lsp.lua so mason is available.
vim.pack.add({
	{ src = "https://github.com/nvimtools/none-ls.nvim" },
	{ src = "https://github.com/nvimtools/none-ls-extras.nvim" },
	{ src = "https://github.com/jay-babu/mason-null-ls.nvim" },
})

require("overdevio.lsp.null-ls")
