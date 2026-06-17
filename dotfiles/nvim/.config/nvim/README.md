## Installation

Plugins are managed by Neovim's native packager (`vim.pack`, requires Neovim
0.12+). On first launch, missing plugins are cloned automatically — just open
Neovim:

```bash
nvim
```

Treesitter parsers and LSP servers install on that first open. To verify, run
`nvim init.lua` and check for errors.

### Managing plugins

- Update everything: `<leader>pu` (or `:lua vim.pack.update()`)
- List installed: `:lua vim.print(vim.pack.get())`
- Remove a plugin: delete its `vim.pack.add` entry, then `:lua vim.pack.del({ "<name>" })`
