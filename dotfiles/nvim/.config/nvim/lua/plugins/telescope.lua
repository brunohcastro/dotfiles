return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			},
			"nvim-telescope/telescope-project.nvim",
			-- harpoon must be loaded for the extension to register
			"ThePrimeagen/harpoon",
		},
		opts = function()
			local actions = require("telescope.actions")

			return {
				defaults = {
					file_ignore_patterns = { ".git/", "node_modules/*" },
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
						},
						n = {
							["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
							["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
						},
					},
				},
			}
		end,
		config = function()
			local telescope = require("telescope")

			telescope.load_extension("fzf")
			telescope.load_extension("project")
			telescope.load_extension("harpoon")
			telescope.load_extension("notify")

			-- Custom buffer picker with delete support
			require("overdevio.lib")
		end,
	},
}
