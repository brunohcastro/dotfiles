return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			-- Core LSP tooling
			"hrsh7th/cmp-nvim-lsp",
			"b0o/SchemaStore.nvim",

			-- Breadcrumbs / context
			"smiteshp/nvim-navic",
			{ "utilyre/barbecue.nvim", dependencies = { "smiteshp/nvim-navic" } },

			-- LSP status & extras
			"j-hui/fidget.nvim",
			"smjonas/inc-rename.nvim",
			"folke/trouble.nvim",
			"aznhe21/actions-preview.nvim",
			{ "hedyhli/outline.nvim" },

			-- Language-specific
			{ "dmmulroy/ts-error-translator.nvim" },
			{
				"antosha417/nvim-lsp-file-operations",
				dependencies = { "nvim-lua/plenary.nvim" },
			},

			-- Misc
			"gpanders/editorconfig.nvim",
		},
		config = function()
			-- Diagnostic signs, virtual text, float config
			require("overdevio.lsp.config")

			-- Wire on_attach for all servers via LspAttach autocmd
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("overdevio_lsp_attach", { clear = true }),
				callback = function(event)
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client then
						require("overdevio.lsp.on_attach").on_attach(client, event.buf)
					end
				end,
			})

			-- Incremental rename
			require("inc_rename").setup()

			--[[ require("nvim-lightbulb").setup({ priority = 90, autocmd = { enabled = true, updatetime = 50 } }) ]]

			-- Trouble (diagnostics window)
			require("trouble").setup()

			-- Breadcrumbs
			require("barbecue").setup({ theme = "tokyonight" })

			-- Symbols outline
			require("outline").setup({})

			-- TypeScript error translator
			require("ts-error-translator").setup()

			--[[ -- LSP-aware file rename (neo-tree integration) ]]
			--[[ require("lsp-file-operations").setup() ]]
		end,
	},

	{
		"mrcjkb/rustaceanvim",
		version = "^5",
		ft = { "rust" },
	},
	{
		"mason-org/mason.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
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
			automatic_installation = { exclude = { "graphql" } },
		},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)
		end,
	},
}
