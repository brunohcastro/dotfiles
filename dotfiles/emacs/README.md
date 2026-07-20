# Bare Emacs Config

This package is a personal, framework-free Emacs setup intended to replace the
current Doom install while keeping a similar editing shape to the Neovim config.

It uses:

- `package.el` and built-in `use-package` for packages
- Catppuccin Mocha, doom-modeline, dashboard, ligatures, Popper
- Evil, Which Key, Vertico, Consult, Corfu, Magit, Diff-HL, Dirvish, vterm
- yasnippet, EditorConfig, ws-butler, evil-goggles
- built-in `eglot` for LSP
- `apheleia` for formatting on save
- Org mode with agenda, capture, org-roam, org-modern, org-pomodoro, org-present

## Current state

This package is currently stowed into `~/.config/emacs`.

Doom was moved aside to timestamped backups:

- `~/.config/emacs.doom-20260622-101508`
- `~/.config/doom.doom-20260622-101508`

To restow this package manually:

```sh
cd ~/.dotfiles
stow --no-folding -t "$HOME" -d dotfiles/ emacs
emacs
```

On first launch, Emacs refreshes package archives and installs missing packages.
Language servers are expected on `PATH`; this config also prepends Neovim
Mason's `~/.local/share/nvim/mason/bin`, so the same LSP binaries can be reused
from the Neovim setup.

Vue support uses `vue-language-server` for `.vue` buffers and `vtsls` for
JavaScript/TypeScript buffers, with `@vue/typescript-plugin` configured for
cross-file Vue awareness.

## Parity notes

This config intentionally uses built-in `eglot`, which keeps the LSP layer
small. It covers the core Neovim language servers for TypeScript, Vue, HTML,
CSS, JSON, YAML, Lua, Go, Rust, Docker, Markdown, and TOML when the
corresponding executables are installed.

Tree-sitter grammar auto-install is disabled during normal editing to avoid
startup warning floods. Install or refresh the selected grammars with:

```elisp
M-x treesit-auto-install-all
```

The Neovim config still has a heavier frontend LSP setup: Tailwind, ESLint, CSS
Modules, and TypeScript/Vue can all attach as separate clients. Eglot does not
mirror that multi-server frontend behavior out of the box.

## Org

Org defaults to `~/Dropbox/org`, matching the Neovim orgmode configuration.
Capture uses `inbox.org`, `todo.org`, `work.org`, and `journal.org`. Org-roam
uses `~/Dropbox/org/roam`.
