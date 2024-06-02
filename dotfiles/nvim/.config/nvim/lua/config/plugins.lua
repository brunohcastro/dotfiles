local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

local packer = require("packer")

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return packer.startup(function(use)
	-- Essentials
	use("wbthomason/packer.nvim")
	use("nvim-lua/plenary.nvim")
	use("miversen33/import.nvim")
	use("nvim-tree/nvim-web-devicons")
	use("MunifTanjim/nui.nvim")
	use({
		"folke/noice.nvim",
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
					progress = {
						enabled = false,
					},
					hover = {
						enabled = true,
						silent = true,
						view = "hover",
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = false,
					lsp_doc_border = false,
				},
			})
		end,
	})

	-- Navigation
	use("nvim-neo-tree/neo-tree.nvim")
	use("folke/which-key.nvim")

	-- Buffers & navigation
	use("lewis6991/gitsigns.nvim")
	use("nvim-lualine/lualine.nvim")
	use({ "akinsho/bufferline.nvim", tag = "*" })
	use("famiu/bufdelete.nvim")
	use("lukas-reineke/indent-blankline.nvim")
	use("kevinhwang91/nvim-hlslens")
	use("petertriho/nvim-scrollbar")
	use("yamatsum/nvim-cursorline")
	use("brenoprata10/nvim-highlight-colors")
	use("ThePrimeagen/harpoon")
	use("akinsho/git-conflict.nvim")
	use({
		"jiaoshijie/undotree",
		config = function()
			require("undotree").setup()
		end,
	})

	-- Git
	use("tpope/vim-fugitive")
	use("sindrets/diffview.nvim")

	-- Colorscheme
	use({ "catppuccin/nvim", as = "catppuccin" })
	use("folke/tokyonight.nvim")

	-- Treesitter
	use("nvim-treesitter/nvim-treesitter")
	use("windwp/nvim-ts-autotag")
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use("nvim-treesitter/nvim-treesitter-context")
	use("windwp/nvim-autopairs")

	-- Telescope
	use("nvim-telescope/telescope.nvim")
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	})
	use("nvim-telescope/telescope-project.nvim")

	-- CMP
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("saadparwaiz1/cmp_luasnip")
	use("hrsh7th/cmp-nvim-lsp")
	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets")
	use("onsails/lspkind.nvim")
	use("zbirenbaum/copilot.lua")
	use("zbirenbaum/copilot-cmp")

	-- LSP
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("neovim/nvim-lspconfig")
	use("b0o/SchemaStore.nvim")
	use({
		"hedyhli/outline.nvim",
		config = function()
			require("outline").setup({})
		end,
	})
	use({
		"pmizio/typescript-tools.nvim",
		requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("typescript-tools").setup({})
		end,
	})
	use("j-hui/fidget.nvim")
	use("ray-x/lsp_signature.nvim")
	use("smjonas/inc-rename.nvim")
	use({
		"weilbith/nvim-code-action-menu",
		cmd = "CodeActionMenu",
	})
	use("kosayoda/nvim-lightbulb")
	use("nvimtools/none-ls.nvim")
	use("nvimtools/none-ls-extras.nvim")
	use("jayp0521/mason-null-ls.nvim")
	use("gpanders/editorconfig.nvim")
	use("folke/trouble.nvim")
	use("smiteshp/nvim-navic")
	use("utilyre/barbecue.nvim")
	use("simrat39/rust-tools.nvim")

	-- Editing
	use("numToStr/Comment.nvim")
	use("JoosepAlviste/nvim-ts-context-commentstring")
	use("hadronized/hop.nvim")
	use("kylechui/nvim-surround")

	-- UI
	use("goolord/alpha-nvim")
	use("stevearc/dressing.nvim")
	use("rcarriga/nvim-notify")

	-- Misc
	use("akinsho/toggleterm.nvim")
	use("ThePrimeagen/vim-be-good")
	use("aserowy/tmux.nvim")
	use({
		"styled-components/vim-styled-components",
		branch = "main",
	})

	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
