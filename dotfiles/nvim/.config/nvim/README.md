## Installation

```bash
# Run PackerSync to get all of the plugins
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
```

To make sure that everything is working fine, try running `nvim init.lua` and seeing if any errors occur, it should start installing treesitter languages and lsp servers on that initial open. If any errors are present, try running `:PackerSync` again.
