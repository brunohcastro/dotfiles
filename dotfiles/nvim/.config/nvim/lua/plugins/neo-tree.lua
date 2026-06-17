vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
})

require("neo-tree").setup({
	close_if_last_window = true,
	hide_root_node = true,
	popup_border_style = "rounded",
	enable_git_status = true,
	enable_diagnostics = true,
	window = {
		mappings = {
			["l"] = "open",
			["o"] = "open",
		},
	},
	filesystem = {
		filtered_items = {
			always_show = {
				".gitignore",
				".gitlab-ci.yaml",
				".gitlab-ci.yml",
				".github",
				".eslintrc*",
				".prettierrc*",
			},
			never_show = { ".git", ".DS_Store" },
		},
		follow_current_file = { enabled = true },
		use_libuv_file_watcher = true,
	},
	source_selector = { winbar = true },
})

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle Explorer" })
