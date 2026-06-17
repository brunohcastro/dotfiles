local signs = {
	[vim.diagnostic.severity.ERROR] = "",
	[vim.diagnostic.severity.WARN] = "",
	[vim.diagnostic.severity.HINT] = "",
	[vim.diagnostic.severity.INFO] = "",
}

local config = {
	virtual_text = true,
	signs = {
		text = signs,
	},
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
}

vim.diagnostic.config(config)

local function with_border(handler)
	return function(err, result, ctx, cfg)
		cfg = vim.tbl_deep_extend("force", cfg or {}, { border = "rounded" })
		return handler(err, result, ctx, cfg)
	end
end

vim.lsp.handlers["textDocument/hover"] = with_border(vim.lsp.handlers.hover)
vim.lsp.handlers["textDocument/signatureHelp"] = with_border(vim.lsp.handlers.signature_help)

vim.g.navic_silence = true
