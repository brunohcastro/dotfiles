vim.loader.enable()

-- Set leader before plugins load so mappings are correct
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")

-- Plugins are managed by the native packager (vim.pack, Neovim 0.12+)
require("config.plugins")
