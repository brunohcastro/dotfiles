-- Native plugin management via vim.pack (Neovim 0.12+).
--
-- Each module under `lua/plugins/` calls `vim.pack.add(...)` for the plugins it
-- owns and then configures them. Modules are loaded in dependency order below.
-- `vim.pack.add` is idempotent, so shared dependencies (plenary, web-devicons,
-- cmp-nvim-lsp, ...) can be listed by every module that needs them.

-- Run build steps for plugins that need compilation/generation after they are
-- installed or updated.
vim.api.nvim_create_autocmd("PackChanged", {
	group = vim.api.nvim_create_augroup("pack_build", { clear = true }),
	callback = function(ev)
		local spec, kind, path = ev.data.spec, ev.data.kind, ev.data.path
		if kind == "delete" then
			return
		end
		if spec.name == "telescope-fzf-native.nvim" then
			-- Build synchronously so telescope can load the extension right after.
			vim.system({ "make" }, { cwd = path }):wait()
		elseif spec.name == "nvim-treesitter" then
			-- Parsers for `ensure_installed` are installed at setup; only refresh
			-- existing parsers on update, once the command actually exists.
			vim.schedule(function()
				if vim.fn.exists(":TSUpdate") == 2 then
					vim.cmd("TSUpdate")
				end
			end)
		end
	end,
})

local modules = {
	"plugins.ui", -- base libs (plenary, devicons), snacks, noice
	"plugins.colorscheme",
	"plugins.treesitter",
	"plugins.cmp",
	"plugins.minuet", -- local-LLM inline completion (llama.cpp FIM)
	"plugins.lsp",
	"plugins.null-ls", -- needs mason (set up by lsp)
	"plugins.ai",
	"plugins.telescope",
	"plugins.neo-tree",
	"plugins.git",
	"plugins.editor",
	"plugins.extras",
	"plugins.lualine",
	"plugins.alpha",
	"plugins.which-key",
}

for _, mod in ipairs(modules) do
	require(mod)
end
