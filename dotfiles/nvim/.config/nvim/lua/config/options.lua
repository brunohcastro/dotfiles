local options = {
	backup = false,
	cmdheight = 1,
	laststatus = 3,
	completeopt = { "menu", "menuone", "noselect" },
	conceallevel = 0,
	fileencoding = "utf-8",
	hlsearch = true,
	ignorecase = true,
	mouse = "a",
	pumheight = 10,
	showmode = false,
	showtabline = 0,
	smartcase = true,
	smartindent = true,
	splitbelow = true,
	splitright = true,
	swapfile = false,
	termguicolors = true,
	undofile = true,
	undodir = vim.fn.expand("$HOME/.local/share/nvim/undo"),
	updatetime = 300,
	writebackup = false,
	expandtab = true,
	shiftwidth = 2,
	tabstop = 2,
	cursorline = true,
	number = true,
	relativenumber = true,
	numberwidth = 4,
	signcolumn = "yes",
	wrap = false,
	scrolloff = 8,
	sidescrolloff = 8,
	guicursor = "",
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.iskeyword:append("-")
vim.cmd("hi EndOfBuffer ctermbg=NONE ctermfg=200 cterm=NONE")
vim.cmd("hi Normal ctermbg=NONE ctermfg=200 cterm=NONE")
vim.cmd("set t_ZH=[3m")
vim.cmd("set t_ZR=[23m")

vim.opt.shortmess:append("c")

vim.filetype.add({
	extension = {
		hbs = "html",
		vtl = "vm",
	},
	pattern = {
		[".*%.cf%.json"] = "json.cloudformation",
		[".*%.cf%.yaml"] = "yaml.cloudformation",
		[".*%.cf%.yml"] = "yaml.cloudformation",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "vm",
	callback = function()
		vim.bo.syntax = "vm"
	end,
})
