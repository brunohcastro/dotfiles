--[[ import("catppuccin", function(catppuccin) ]]
--[[ 	catppuccin.setup({ ]]
--[[ 		flavour = "mocha", ]]
--[[ 		integrations = { ]]
--[[ 			cmp = true, ]]
--[[ 			fidget = true, ]]
--[[ 			harpoon = true, ]]
--[[ 			hop = true, ]]
--[[ 			lsp_trouble = true, ]]
--[[ 			which_key = true, ]]
--[[ 		}, ]]
--[[ 	}) ]]
--[[]]
--[[   vim.cmd.colorscheme("catpuccin-mocha") ]]
--[[ end) ]]

import("tokyonight", function(tokyonight)
	tokyonight.setup({
		style = "night",
		terminal_colors = true,
		styles = {
			sidebars = "dark",
			floats = "dark",
			comments = { italic = true },
			keywords = { italic = true, bold = true },
			functions = { bold = true },
		},
		dim_inactive = true,
		lualine_bold = true,
	})

	vim.cmd.colorscheme("tokyonight")
end)

--[[ import("night-owl", function(night_owl) ]]
--[[ 	night_owl.setup() ]]
--[[]]
--[[ 	vim.cmd.colorscheme("night-owl") ]]
--[[ end) ]]
