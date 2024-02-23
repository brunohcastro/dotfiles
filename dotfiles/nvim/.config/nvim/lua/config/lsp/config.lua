local signs = {
	{ name = "DiagnosticSignError", text = "" },
	{ name = "DiagnosticSignWarn", text = "" },
	{ name = "DiagnosticSignHint", text = "" },
	{ name = "DiagnosticSignInfo", text = "" },
}

for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

local config = {
	virtual_text = true,
	signs = {
		active = signs,
	},
	update_in_insert = true,
	underline = true,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minmal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
}

vim.diagnostic.config(config)

vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, conf)
	if not (result and result.contents) then
		return
	end

	local content = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
	content = vim.lsp.util.trim_empty_lines(content)

	if vim.tbl_isempty(content) then
		return
	end

	return vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})(_, result, ctx, conf)
end

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
	border = "rounded",
})

import("notify", function(notify)
	vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
		local client = vim.lsp.get_client_by_id(ctx.client_id)
		local lvl = ({
			"ERROR",
			"WARN",
			"INFO",
			"DEBUG",
		})[result.type]
		notify({ result.message }, lvl, {
			title = "LSP | " .. client.name,
			timeout = 10000,
			keep = function()
				return lvl == "ERROR" or lvl == "WARN"
			end,
		})
	end
end)

vim.g.navic_silence = true
