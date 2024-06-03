import({ "mason-null-ls", "null-ls" }, function(modules)
	local mason_null_ls = modules["mason-null-ls"]
	local null_ls = modules["null-ls"]

	mason_null_ls.setup({
		ensure_installed = {
			"stylua",
			"eslint_d",
			"hadolint",
			"dotenv_linter",
			"refactoring",
			"prettierd",
			"gofumpt",
			"goimports",
			"golangci_lint",
		},
		automatic_installation = true,
		methods = {
			diagnostics = true,
			formatting = true,
			code_actions = true,
			completion = true,
			hover = true,
		},
		handlers = {
			stylua = function()
				null_ls.register(null_ls.builtins.formatting.stylua)
			end,
			eslint_d = function()
				null_ls.register(require("none-ls.diagnostics.eslint_d").with({
					prefer_local = "node_modules/.bin",
					method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
					condition = function(utils)
						return utils.root_has_file({
							".eslintrc",
							".eslintrc.json",
							".eslintrc.yml",
							".eslintrc.yaml",
							".eslintrc.json5",
							".eslintrc.js",
							".eslintrc.cjs",
							".eslintrc.toml",
							"eslint.config.js",
							"eslint.config.cjs",
						})
					end,
				}))
			end,
			hadolint = function()
				null_ls.register(null_ls.builtins.diagnostics.hadolint)
			end,
			dotenv_linter = function()
				null_ls.register(null_ls.builtins.diagnostics.dotenv_linter)
			end,
			refactoring = function()
				null_ls.register(null_ls.builtins.refactoring)
			end,
			prettierd = function()
				null_ls.register(null_ls.builtins.formatting.prettierd.with({
					condition = function(utils)
						return utils.root_has_file({
							".prettierrc",
							".prettierrc.json",
							".prettierrc.yml",
							".prettierrc.yaml",
							".prettierrc.json5",
							".prettierrc.js",
							".prettierrc.cjs",
							".prettierrc.toml",
							"prettier.config.js",
							"prettier.config.cjs",
						})
					end,
				}))
			end,
			gofumpt = function()
				null_ls.register(null_ls.builtins.formatting.gofumpt)
			end,
			goimports = function()
				null_ls.register(null_ls.builtins.formatting.goimports.with({
					extra_args = { "-local", "github.com/reviz0r" },
				}))
			end,
			golangci_lint = function()
				null_ls.register(null_ls.builtins.diagnostics.golangci_lint)
			end,
		},
	})

	null_ls.setup({
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ bufnr = bufnr })
					end,
				})
			end
		end,
	})
end)
