vim.pack.add({
	{ src = "https://github.com/ThePrimeagen/harpoon" },
	{ src = "https://github.com/smoka7/hop.nvim" },
	{ src = "https://github.com/kylechui/nvim-surround" },
	{ src = "https://github.com/numToStr/Comment.nvim" },
	{ src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },
	{ src = "https://github.com/jiaoshijie/undotree" },
	{ src = "https://github.com/styled-components/vim-styled-components" },
	{ src = "https://github.com/ThePrimeagen/vim-be-good" },
	{ src = "https://github.com/nvim-orgmode/orgmode" },
})

require("harpoon").setup({})
require("hop").setup()
require("nvim-surround").setup({})
require("undotree").setup()

-- Comment.nvim with treesitter-aware commentstring (JSX/embedded languages)
local comment_utils = require("Comment.utils")
local commentstring_utils = require("ts_context_commentstring.utils")
local commentstring_internal = require("ts_context_commentstring.internal")

require("Comment").setup({
	pre_hook = function(ctx)
		local U = comment_utils
		local location = nil
		if ctx.ctype == U.ctype.block then
			location = commentstring_utils.get_cursor_location()
		elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
			location = commentstring_utils.get_visual_start_location()
		end
		return commentstring_internal.calculate_commentstring({
			key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
			location = location,
		})
	end,
})

require("orgmode").setup({
	org_agenda_files = "~/Dropbox/org/**/*",
	org_default_notes_file = "~/Dropbox/org/inbox.org",
	org_todo_keywords = {
		"TODO(t)",
		"NEXT(n)",
		"IN-PROGRESS(p)",
		"WAITING(w)",
		"|",
		"DONE(d)",
		"CANCELED(c)",
	},
})

vim.lsp.enable("org")
