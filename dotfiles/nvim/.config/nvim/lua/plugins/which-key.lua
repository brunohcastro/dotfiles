vim.pack.add({
	{ src = "https://github.com/folke/which-key.nvim" },
})

local whichKey = require("which-key")

whichKey.setup({
	show_help = true,
})

-- Each entry below uses a full `<leader>…` lhs, so no `prefix` is needed
-- (it is deprecated in which-key v3 and would be ignored anyway).
local opts = {
	mode = "n",
	silent = true,
	noremap = true,
}

-- stylua: ignore
local mappings = {
  { "<leader>b",   group = "Buffers",                                                                       remap = false },
  { "<leader>bd",  "<cmd>lua Snacks.bufdelete()<cr>",                                                       desc = "Close Current",            remap = false },
  { "<leader>bl",  "<cmd>lua require('telescope.builtin').buffers()<CR>",                                   desc = "List",                     remap = false },
  { "<leader>d",   group = "Diff view",                                                                     remap = false },
  { "<leader>dd",  "<cmd>DiffviewClose<CR>",                                                                desc = "Close",                    remap = false },
  { "<leader>df",  "<cmd>DiffviewFocusFiles<CR>",                                                           desc = "Focus files",              remap = false },
  { "<leader>dh",  "<cmd>DiffviewFileHistory<CR>",                                                          desc = "File history",             remap = false },
  { "<leader>dl",  "<cmd>DiffviewLog<CR>",                                                                  desc = "Log",                      remap = false },
  { "<leader>do",  "<cmd>DiffviewOpen<CR>",                                                                 desc = "Open",                     remap = false },
  { "<leader>dr",  "<cmd>DiffviewRefresh<CR>",                                                              desc = "Refresh",                  remap = false },
  { "<leader>e",   "<cmd>Neotree toggle<CR>",                                                               desc = "Toggle Explorer",          remap = false },
  { "<leader>f",   group = "Find",                                                                          remap = false },
  { "<leader>fb",  "<cmd>OverdevioTelescopeBuffers<CR>",                                                    desc = "Buffers",                  remap = false },
  { "<leader>ff",  "<cmd>lua require('telescope.builtin').live_grep()<CR>",                                 desc = "Text",                     remap = false },
  { "<leader>fh",  "<cmd>lua require('telescope.builtin').help_tags()<CR>",                                 desc = "Help tags",                remap = false },
  { "<leader>fm",  "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",                                desc = "Marked files",             remap = false },
  { "<leader>fn",  "<cmd>lua require('telescope').extensions.notify.notify()<CR>",                          desc = "Notifications",            remap = false },
  { "<leader>fp",  "<cmd>lua require('telescope').extensions.project.project{ display_type = 'full' }<CR>", desc = "Project",                  remap = false },
  { "<leader>fs",  "<cmd>lua require('telescope.builtin').find_files()<CR>",                                desc = "Files",                    remap = false },
  { "<leader>fx",  "<cmd>lua require('telescope.builtin').resume()<CR>",                                    desc = "Resume",                   remap = false },
  { "<leader>g",   group = "Git",                                                                           remap = false },
  { "<leader>gS",  "<cmd>lua require('telescope.builtin').git_stash()<CR>",                                 desc = "Stash",                    remap = false },
  { "<leader>gb",  "<cmd>lua require('telescope.builtin').git_branches()<CR>",                              desc = "Branches",                 remap = false },
  { "<leader>gc",  "<cmd>lua require('telescope.builtin').git_commits()<CR>",                               desc = "Commits",                  remap = false },
  { "<leader>gf",  "<cmd>Git pull<CR>",                                                                     desc = "Pull",                     remap = false },
  { "<leader>gg",  "<cmd>Git<CR>",                                                                          desc = "Fugitive",                 remap = false },
  { "<leader>gp",  "<cmd>Git push<CR>",                                                                     desc = "Push",                     remap = false },
  { "<leader>gr",  "<cmd>Gread<CR>",                                                                        desc = "Checkout File",            remap = false },
  { "<leader>gs",  "<cmd>lua require('telescope.builtin').git_status()<CR>",                                desc = "Status",                   remap = false },
  { "<leader>h",   group = "Hop",                                                                           remap = false },
  { "<leader>hf",  "<cmd>HopChar1<cr>",                                                                     desc = "1 Chars",                  remap = false },
  { "<leader>hh",  "<cmd>HopChar2<cr>",                                                                     desc = "2 Chars",                  remap = false },
  { "<leader>hl",  "<cmd>HopLineStart<cr>",                                                                 desc = "Line start",               remap = false },
  { "<leader>hp",  "<cmd>HopPattern<cr>",                                                                   desc = "Pattern",                  remap = false },
  { "<leader>hv",  "<cmd>HopVertical<cr>",                                                                  desc = "Vertical",                 remap = false },
  { "<leader>hw",  "<cmd>HopWord<cr>",                                                                      desc = "Word",                     remap = false },
  { "<leader>l",   group = "LSP",                                                                           remap = false },
  { "<leader>lD",  "<cmd>lua vim.lsp.buf.declaration()<cr>",                                                desc = "Declaration",              remap = false },
  { "<leader>lK",  "<cmd>lua vim.lsp.buf.hover()<cr>",                                                      desc = "Hover",                    remap = false },
  { "<leader>lR",  "<cmd>lua vim.lsp.buf.references()<cr>",                                                 desc = "References",               remap = false },
  { "<leader>lT",  "<cmd>lua vim.lsp.buf.type_definition()<cr>",                                            desc = "Type definition",          remap = false },
  { "<leader>la",  "<cmd>lua require('actions-preview').code_actions()<CR>",                                desc = "Code actions",             remap = false },
  { "<leader>ld",  "<cmd>lua vim.lsp.buf.definition()<cr>",                                                 desc = "Definition",               remap = false },
  { "<leader>lf",  "<cmd>lua vim.lsp.buf.format({ async = true })<cr>",                                     desc = "Format",                   remap = false },
  { "<leader>li",  "<cmd>lua vim.lsp.buf.implementation()<cr>",                                             desc = "Implementation",           remap = false },
  { "<leader>lk",  "<cmd>lua vim.lsp.buf.signature_help()<cr>",                                             desc = "Signature help",           remap = false },
  { "<leader>ll",  "<cmd>lua vim.diagnostic.open_float()<cr>",                                              desc = "Open float",               remap = false },
  { "<leader>ln",  ":IncRename ",                                                                           desc = "Rename",                   remap = false },
  { "<leader>lr",  group = "Rust",                                                                          remap = false },
  { "<leader>lra", "<cmd>RustLsp runnables<cr>",                                                            desc = "Runnables",                remap = false },
  { "<leader>lrr", "<cmd>RustLsp run<cr>",                                                                  desc = "Run",                      remap = false },
  { "<leader>ls",  "<cmd>Outline<cr>",                                                                      desc = "Toggle symbols outline",   remap = false },
  { "<leader>lu",  group = "Trouble",                                                                       remap = false },
  { "<leader>lud", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",                                      desc = "Diagnostics",              remap = false },
  { "<leader>luf", "<cmd>Trouble lsp_definitions<cr>",                                                      desc = "Definitions",              remap = false },
  { "<leader>lul", "<cmd>Trouble loclist toggle<cr>",                                                       desc = "LocationList",             remap = false },
  { "<leader>luq", "<cmd>Trouble qflist toggle<cr>",                                                        desc = "QuickFix",                 remap = false },
  { "<leader>lur", "<cmd>Trouble lsp_references<cr>",                                                       desc = "References",               remap = false },
  { "<leader>luw", "<cmd>Trouble diagnostics toggle<cr>",                                                   desc = "Workspace Diagnostics",    remap = false },
  { "<leader>m",   "<cmd>lua require('harpoon.mark').add_file()<cr>",                                       desc = "Mark file",                remap = false },
  { "<leader>n",   "<cmd>nohl<cr>",                                                                         desc = "No highlight",             remap = false },
  { "<leader>p",   group = "Plugins",                                                                       remap = false },
  { "<leader>pu",  "<cmd>lua vim.pack.update()<CR>",                                                        desc = "Update",                   remap = false },
  { "<leader>q",   "<cmd>q<cr>",                                                                            desc = "Quit",                     remap = false },
  { "<leader>u",   group = "UndoTree",                                                                      remap = false },
  { "<leader>uc",  "<cmd>lua require('undotree').close()<cr>",                                              desc = "Close",                    remap = false },
  { "<leader>uo",  "<cmd>lua require('undotree').open()<cr>",                                               desc = "Open",                     remap = false },
  { "<leader>ut",  "<cmd>lua require('undotree').toggle()<cr>",                                             desc = "Toggle",                   remap = false },
  { "<leader>w",   "<cmd>w<cr>",                                                                            desc = "Save",                     remap = false },
}

whichKey.add(mappings, opts)
