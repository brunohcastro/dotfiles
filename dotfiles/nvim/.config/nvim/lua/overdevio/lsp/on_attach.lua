local M = {}

M.on_attach = function(client, bufnr)
	local map = function(keys, cmd, desc)
		vim.keymap.set("n", keys, cmd, { buffer = bufnr, desc = desc })
	end

	-- Disable formatting for servers that conflict with null-ls
	if client.name == "lua_ls" or client.name == "ts_ls" then
		client.server_capabilities.documentFormattingProvider = false
	end

	map("gd", "<cmd>Trouble lsp_definitions<CR>", "Go to definition")
	map("gD", vim.lsp.buf.declaration, "Go to declaration")
	map("gt", "<cmd>Trouble lsp_type_definitions<CR>", "Go to type definition")
	map("gi", "<cmd>Trouble lsp_implementations<CR>", "Go to implementation")
	map("gr", "<cmd>Trouble lsp_references<CR>", "Go to references")
	map("K", vim.lsp.buf.hover, "Hover documentation")
	map("<C-k>", vim.lsp.buf.signature_help, "Signature help")
	map("<leader>rn", ":IncRename ", "Rename")
	map("<leader>ca", function()
		require("actions-preview").code_actions()
	end, "Code action")
	map("gf", function()
		vim.lsp.buf.format({ async = true })
	end, "Format buffer")
	map("gl", vim.diagnostic.open_float, "Open diagnostic float")
	map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
	map("]d", vim.diagnostic.goto_next, "Next diagnostic")

	local ok, navic = pcall(require, "nvim-navic")
	if ok and client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
	end
end

return M
