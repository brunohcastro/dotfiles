vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/b0o/SchemaStore.nvim" },

	-- Breadcrumbs / context
	{ src = "https://github.com/SmiteshP/nvim-navic" },
	{ src = "https://github.com/utilyre/barbecue.nvim" },

	-- LSP UI & extras
	{ src = "https://github.com/smjonas/inc-rename.nvim" },
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/aznhe21/actions-preview.nvim" },
	{ src = "https://github.com/hedyhli/outline.nvim" },
	{ src = "https://github.com/dmmulroy/ts-error-translator.nvim" },

	-- Language-specific (rustaceanvim wires up rust_analyzer itself)
	{ src = "https://github.com/mrcjkb/rustaceanvim", version = vim.version.range("5") },

	-- Mason
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
})

-- Diagnostic signs, virtual text and float config.
require("overdevio.lsp.config")

-- Wire on_attach for all servers via the LspAttach autocmd.
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("overdevio_lsp_attach", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if client then
			require("overdevio.lsp.on_attach").on_attach(client, event.buf)
		end
	end,
})

require("inc_rename").setup()
require("trouble").setup()
require("barbecue").setup({ theme = "auto" })
require("outline").setup({})
require("ts-error-translator").setup()

-- Apply per-server settings (lua/overdevio/lsp/settings/<name>.lua). These merge
-- on top of nvim-lspconfig defaults and the global capabilities set in cmp.lua.
local function configure(name, settings)
	if type(settings) == "table" then
		vim.lsp.config(name, settings)
	end
end

for _, name in ipairs({ "lua_ls", "jsonls", "yamlls", "tailwindcss", "graphql", "cssmodules_ls" }) do
	local ok, settings = pcall(require, "overdevio.lsp.settings." .. name)
	if ok then
		configure(name, settings)
	end
end

-- eslint exposes language-server settings rather than a full config table.
do
	local ok, settings = pcall(require, "overdevio.lsp.settings.eslint")
	if ok and type(settings) == "table" then
		configure("eslint", { settings = settings })
	end
end

require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

require("mason-lspconfig").setup({
	ensure_installed = {
		"angularls",
		"cssls",
		"cssmodules_ls",
		"dockerls",
		"eslint",
		"gopls",
		"html",
		"jsonls",
		"lua_ls",
		"marksman",
		"rust_analyzer",
		"tailwindcss",
		"ts_ls",
		"taplo",
		"yamlls",
	},
	-- rust_analyzer is owned by rustaceanvim; graphql is enabled manually only.
	automatic_enable = { exclude = { "rust_analyzer", "graphql" } },
})
