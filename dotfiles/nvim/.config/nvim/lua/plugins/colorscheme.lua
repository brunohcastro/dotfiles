return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("tokyonight").setup({
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
		end,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		config = function()
			require("catppuccin").setup({ flavour = "mocha" })

			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{ "oxfist/night-owl.nvim", lazy = true },
}
