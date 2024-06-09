local options = {
	backup = false,
	cmdheight = 1,
	laststatus = 3,
	completeopt = { "menuone", "noselect" },
	conceallevel = 0,
	fileencoding = "utf-8",
	hlsearch = true,
	ignorecase = true,
	mouse = "a",
	pumheight = 10,
	showmode = false,
	--[[ showtabline = 4, ]]
	smartcase = true,
	smartindent = true,
	splitbelow = true,
	splitright = true,
	swapfile = false,
	termguicolors = true,
	undofile = true,
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

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set t_Co=256]])
vim.cmd("hi EndOfBuffer ctermbg=NONE ctermfg=200 cterm=NONE")
vim.cmd("hi Normal ctermbg=NONE ctermfg=200 cterm=NONE")

vim.opt.shortmess:append("c")

local function set_filetype_and_syntax(extension, filetype, syntax)
	vim.cmd(string.format("autocmd BufRead,BufNewFile *%s setlocal filetype=%s", extension, filetype))
	if syntax then
		vim.cmd(string.format("autocmd FileType %s setlocal syntax=%s", filetype, syntax))
	end
end

set_filetype_and_syntax(".vtl", "vm", "vm")
set_filetype_and_syntax(".hbs", "html", "html")
