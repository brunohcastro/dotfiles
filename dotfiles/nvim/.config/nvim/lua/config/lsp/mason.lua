import({ "mason", "mason-lspconfig", "lspconfig", "cmp_nvim_lsp" }, function(modules)
	local mason = modules.mason
	local masonLspConfig = modules["mason-lspconfig"]
	local cmpLsp = modules["cmp_nvim_lsp"]
	local lspconfig = modules.lspconfig

	mason.setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})

	masonLspConfig.setup({
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
			"taplo",
			"volar",
			"yamlls",
		},
		automatic_installation = { exclude = { "graphql" } },
	})

	local opts = {
		capabilities = cmpLsp.default_capabilities(),
		on_attach = require("config.lsp.on_attach").on_attach,
	}

	masonLspConfig.setup_handlers({
		function(server_name)
			local has_custom_opts, custom_opts = pcall(require, "config.lsp.settings." .. server_name)

			local server_opts = opts

			if has_custom_opts then
				server_opts = vim.tbl_deep_extend("force", custom_opts, opts)
			end

			modules.lspconfig[server_name].setup(server_opts)
		end,
		["rust_analyzer"] = function()
			import("rust-tools", function(rustTools)
				rustTools.setup({ server = opts })
			end)
		end,
	})

	require("lspconfig.configs").cfn_lsp = {
		default_config = {
			cmd = { os.getenv("HOME") .. "/.local/bin/cfn-lsp-extra" },
			filetypes = { "yaml.cloudformation", "json.cloudformation" },
			root_dir = function(fname)
				return require("lspconfig").util.find_git_ancestor(fname) or vim.fn.getcwd()
			end,
			settings = {
				documentFormatting = false,
			},
		},
	}

	require("lspconfig").cfn_lsp.setup({})

	lspconfig.graphql.setup({
		--[[ cmd = { "sh", "-c", "graphql-lsp server -m stream 2>&1" }, ]]
		capabilities = opts.capabilities,
		on_attach = opts.on_attach,
		filetypes = {
			"go",
			"graphql",
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
	})
end)
