import({ "mason-null-ls", "null-ls" }, function(modules)
	local mason_null_ls = modules["mason-null-ls"]
	local null_ls = modules["null-ls"]

	mason_null_ls.setup({
		ensure_installed = {
			"dotenv_linter",
			"gofumpt",
			"goimports",
			"golangci_lint",
			"gomodifytags",
			"hadolint",
			"impl",
			"prettier",
			"refactoring",
			"stylua",
			"cfn_lint",
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
			hadolint = function()
				null_ls.register(null_ls.builtins.diagnostics.hadolint)
			end,
			dotenv_linter = function()
				null_ls.register(null_ls.builtins.diagnostics.dotenv_linter)
			end,
			prettier = function()
				null_ls.register(null_ls.builtins.formatting.prettier.with({
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
			cfn_lint = function()
				null_ls.register(null_ls.builtins.diagnostics.cfn_lint)
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
