-- nvim-treesitter `main` branch: the rewrite required by Neovim 0.12+/nightly.
-- The frozen `master` branch only supports Neovim 0.10/0.11 and breaks injection
-- parsing on this build. `main` needs the `tree-sitter` CLI (>= 0.26.1) on PATH
-- to compile parsers — install it from your package manager, not npm.
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
	{ src = "https://github.com/windwp/nvim-ts-autotag" },
})

local ensure_installed = {
	"lua",
	"markdown",
	"markdown_inline",
	"html",
	"css",
	"scss",
	"javascript",
	"typescript",
	"tsx",
	"vue",
	"svelte",
	"astro",
	"prisma",
	"json",
	"yaml",
	"toml",
	"c",
	"python",
	"pug",
	"php",
	"java",
	"dockerfile",
	"graphql",
	"go",
	"gomod",
	"gosum",
	"gotmpl",
	"sql",
	"tmux",
	"rust",
	"regex",
	"bash",
	"vim",
	"vimdoc",
	"templ",
	"styled",
	"typespec",
	"http",
	"xml",
	"gitcommit",
	"gitignore",
	"comment",
}

if vim.fn.executable("tree-sitter") == 1 then
	require("nvim-treesitter").install(ensure_installed)
end

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		if pcall(vim.treesitter.start) then
			vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

require("nvim-treesitter-textobjects").setup({
	select = {
		lookahead = true,
		selection_modes = {
			["@parameter.outer"] = "v",
			["@function.outer"] = "V",
			["@class.outer"] = "<c-v>",
		},
		include_surrounding_whitespace = true,
	},
	move = {
		set_jumps = true,
	},
})

local select = require("nvim-treesitter-textobjects.select")
local swap = require("nvim-treesitter-textobjects.swap")
local move = require("nvim-treesitter-textobjects.move")

local function map_select(key, query, desc)
	vim.keymap.set({ "x", "o" }, key, function()
		select.select_textobject(query, "textobjects")
	end, { desc = desc })
end

map_select("af", "@function.outer", "Select outer function")
map_select("if", "@function.inner", "Select inner function")
map_select("ac", "@class.outer", "Select outer class")
map_select("ic", "@class.inner", "Select inner part of a class region")

vim.keymap.set("n", "<leader>a", function()
	swap.swap_next("@parameter.inner")
end, { desc = "Swap next parameter" })
vim.keymap.set("n", "<leader>A", function()
	swap.swap_previous("@parameter.inner")
end, { desc = "Swap previous parameter" })

local moves = {
	{ "]m", move.goto_next_start, "@function.outer" },
	{ "]]", move.goto_next_start, "@class.outer" },
	{ "]M", move.goto_next_end, "@function.outer" },
	{ "][", move.goto_next_end, "@class.outer" },
	{ "[m", move.goto_previous_start, "@function.outer" },
	{ "[[", move.goto_previous_start, "@class.outer" },
	{ "[M", move.goto_previous_end, "@function.outer" },
	{ "[]", move.goto_previous_end, "@class.outer" },
}
for _, m in ipairs(moves) do
	vim.keymap.set({ "n", "x", "o" }, m[1], function()
		m[2](m[3], "textobjects")
	end)
end

require("nvim-ts-autotag").setup()
