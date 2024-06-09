import("which-key", function(whichKey)
	local setup = {
		window = {
			border = "rounded",
			position = "bottom",
			margin = { 1, 0, 1, 0 },
			padding = { 2, 2, 2, 2 },
			winblend = 0,
		},
		ignore_missing = true,
		hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
		show_help = true,
	}

	local opts = {
		mode = "n",
		prefix = "<leader>",
		silent = true,
		noremap = true,
	}

	local mappings = {
		["w"] = { "<cmd>w<cr>", "Save" },
		["q"] = { "<cmd>q<cr>", "Quit" },
		["e"] = { "<cmd>Neotree toggle<cr>", "Toggle Explorer" },
		["n"] = { "<cmd>nohl<cr>", "No highlight" },
		["b"] = {
			name = "Buffers",
			["l"] = { "<cmd>lua require('telescope.builtin').buffers()<CR>", "List" },
			["d"] = { "<cmd>Bdelete<cr>", "Close Current" },
		},
		["p"] = {
			name = "Packer",
			["s"] = { "<cmd>PackerSync<CR>", "Sync" },
			["i"] = { "<cmd>PackerInstall<CR>", "Install" },
			["u"] = { "<cmd>PackerUpdate<CR>", "Update" },
			["c"] = { "<cmd>PackerCompile<CR>", "Compile" },
		},
		["f"] = {
			name = "Find",
			["f"] = { "<cmd>lua require('telescope.builtin').live_grep()<CR>", "Text" },
			["s"] = { "<cmd>lua require('telescope.builtin').find_files()<CR>", "Files" },
			["h"] = { "<cmd>lua require('telescope.builtin').help_tags()<CR>", "Help tags" },
			["b"] = { "<cmd>lua require('telescope.builtin').buffers()<CR>", "Buffers" },
			["p"] = {
				"<cmd>lua require('telescope').extensions.project.project{ display_type = 'full' }<CR>",
				"Project",
			},
			["m"] = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Marked files" },
			["n"] = { "<cmd>lua require('telescope').extensions.notify.notify()<CR>", "Notifications" },
		},
		["g"] = {
			name = "Git",
			["s"] = { "<cmd>lua require('telescope.builtin').git_status()<CR>", "Status" },
			["c"] = { "<cmd>lua require('telescope.builtin').git_commits()<CR>", "Commits" },
			["b"] = { "<cmd>lua require('telescope.builtin').git_branches()<CR>", "Branches" },
			["g"] = { "<cmd>Git<CR>", "Fugitive" },
			["r"] = { "<cmd>Gread<CR>", "Checkout File" },
		},
		["d"] = {
			name = "Diff view",
			["o"] = { "<cmd>DiffviewOpen<CR>", "Open" },
			["d"] = { "<cmd>DiffviewClose<CR>", "Close" },
			["l"] = { "<cmd>DiffviewLog<CR>", "Log" },
			["r"] = { "<cmd>DiffviewRefresh<CR>", "Refresh" },
			["f"] = { "<cmd>DiffviewFocusFiles<CR>", "Focus files" },
			["h"] = { "<cmd>DiffviewFileHistory<CR>", "File history" },
		},
		["l"] = {
			name = "LSP",
			["D"] = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Declaration" },
			["d"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Definition" },
			["T"] = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Type definition" },
			["i"] = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Implementation" },
			["R"] = { "<cmd>lua vim.lsp.buf.references()<cr>", "References" },
			["K"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
			["k"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature help" },
			["s"] = { "<cmd>Outline<cr>", "Toggle symbols outline" },
			["n"] = { ":IncRename ", "Rename" },
			["a"] = { "<cmd>lua require('actions-preview').code_actions()<CR>", "Code actions" },
			["f"] = { "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", "Format" },
			["l"] = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Open float" },
			["t"] = {
				name = "TypeScript",
				["a"] = { "<cmd>TSToolsAddMissingImports<CR>", "Add missing imports" },
				["o"] = { "<cmd>TSToolsOrganizeImports<CR>", "Organize imports" },
				["s"] = { "<cmd>TSToolsSortImports<CR>", "Sort imports" },
				["u"] = { "<cmd>TSToolsRemoveUnusedImports<CR>", "Remove dangling imports" },
				["c"] = { "<cmd>TSToolsRemoveUnused<CR>", "Remove unused" },
				["f"] = { "<cmd>TSToolsFixAll<CR>", "Fix all" },
				["g"] = { "<cmd>TSToolsGoToSourceDefinition<CR>", "Go to source definition" },
				["r"] = { "<cmd>OverdevioTSRenameFile<CR>", "Rename file" },
				["R"] = { "<cmd>OverdevioTSRenameFile force_save<CR>", "Rename file and save all" },
				["l"] = { "<cmd>TSToolsFileReferences<CR>", "Show file references" },
			},
			["r"] = {
				name = "Rust",
				["r"] = { "<cmd>RustRun<cr>", "Run" },
				["a"] = { "<cmd>RustRunnables<cr>", "Runnables" },
			},
			["u"] = {
				name = "Trouble",
				r = { "<cmd>TroubleToggle lsp_references<cr>", "References" },
				f = { "<cmd>TroubleToggle lsp_definitions<cr>", "Definitions" },
				d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Diagnostics" },
				q = { "<cmd>TroubleToggle quickfix<cr>", "QuickFix" },
				l = { "<cmd>TroubleToggle loclist<cr>", "LocationList" },
				w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
			},
		},
		["u"] = {
			name = "UndoTree",
			["t"] = { "<cmd>lua require('undotree').toggle()<cr>", "Toggle" },
			["o"] = { "<cmd>lua require('undotree').open()<cr>", "Open" },
			["c"] = { "<cmd>lua require('undotree').close()<cr>", "Close" },
		},
		["h"] = {
			name = "Hop",
			["h"] = { "<cmd>HopChar2<cr>", "2 Chars" },
			["f"] = { "<cmd>HopChar1<cr>", "1 Chars" },
			["p"] = { "<cmd>HopPattern<cr>", "Pattern" },
			["l"] = { "<cmd>HopLineStart<cr>", "Line start" },
			["v"] = { "<cmd>HopVertical<cr>", "Vertical" },
			["w"] = { "<cmd>HopWord<cr>", "Word" },
		},
		--[[ ["t"] = { "<cmd>ToggleTermToggleAll<cr>", "Toggle terminals" }, ]]
		["m"] = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Mark file" },
	}

	whichKey.setup(setup)
	whichKey.register(mappings, opts)
end)
