;;; init.el -*- lexical-binding: t; -*-

;;; Package management

(require 'package)

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t
      use-package-expand-minimally t)

;;; Identity and paths

(setq user-full-name "Bruno Castro"
      user-mail-address "brunohcastro@gmail.com")

(defconst bhc/cache-dir (expand-file-name "cache/" user-emacs-directory))
(defconst bhc/state-dir (expand-file-name "state/" user-emacs-directory))
(defconst bhc/org-directory (expand-file-name "~/Dropbox/org/"))

(dolist (dir (list bhc/cache-dir bhc/state-dir))
  (make-directory dir t))

(defun bhc/prepend-path (dir)
  (let ((expanded (expand-file-name dir)))
    (when (file-directory-p expanded)
      (add-to-list 'exec-path expanded)
      (setenv "PATH" (concat expanded path-separator (getenv "PATH"))))))

(dolist (dir '("~/.local/bin"
               "~/bin"
               "~/.local/share/nvim/mason/bin"
               "~/Development/go/bin"
               "~/Development/flutter/bin"
               "~/.opencode/bin"))
  (bhc/prepend-path dir))

(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x pgtk))
  :config
  (exec-path-from-shell-initialize))

;;; Defaults

(setq inhibit-startup-screen t
      initial-scratch-message nil
      ring-bell-function 'ignore
      confirm-kill-emacs 'y-or-n-p
      use-short-answers t
      make-backup-files t
      auto-save-default t
      create-lockfiles nil
      require-final-newline t
      sentence-end-double-space nil
      scroll-conservatively 101
      scroll-margin 8
      mouse-wheel-scroll-amount '(1 ((shift) . 1))
      mouse-wheel-progressive-speed nil
      read-process-output-max (* 1024 1024))

(setq backup-directory-alist `(("." . ,(expand-file-name "backups/" bhc/cache-dir)))
      auto-save-file-name-transforms `((".*" ,(expand-file-name "auto-save/" bhc/cache-dir) t))
      custom-file (expand-file-name "custom.el" bhc/state-dir)
      recentf-save-file (expand-file-name "recentf" bhc/state-dir)
      savehist-file (expand-file-name "savehist" bhc/state-dir)
      save-place-file (expand-file-name "places" bhc/state-dir))

(setq-default indent-tabs-mode nil
              tab-width 2
              fill-column 100)

(delete-selection-mode 1)
(electric-pair-mode 1)
(global-auto-revert-mode 1)
(savehist-mode 1)
(save-place-mode 1)
(recentf-mode 1)
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(winner-mode 1)

(setq display-line-numbers-type 'relative)
(dolist (hook '(term-mode-hook
                vterm-mode-hook
                eshell-mode-hook
                shell-mode-hook
                org-mode-hook
                markdown-mode-hook))
  (add-hook hook (lambda () (display-line-numbers-mode -1))))

;;; UI

(defun bhc/apply-font ()
  (when (display-graphic-p)
    (set-face-attribute 'default nil :family "FiraCode Nerd Font" :height 140)
    (set-face-attribute 'fixed-pitch nil :family "FiraCode Nerd Font" :height 140)
    (set-face-attribute 'variable-pitch nil :family "Sans" :height 145)))

(add-to-list 'default-frame-alist '(font . "FiraCode Nerd Font-14"))
(add-hook 'after-init-hook #'bhc/apply-font)

(use-package catppuccin-theme
  :defer t
  :init
  (setq catppuccin-flavor 'mocha
        catppuccin-highlight-matches t
        catppuccin-italic-comments t)
  (load-theme 'catppuccin t))

(use-package doom-modeline
  :custom
  (doom-modeline-height 26)
  :hook (after-init . doom-modeline-mode))

(use-package solaire-mode
  :hook (after-init . solaire-global-mode))

(use-package spacious-padding
  :if (display-graphic-p)
  :custom
  (spacious-padding-widths
   '(:internal-border-width 8
     :header-line-width 4
     :mode-line-width 4
     :tab-width 4
     :right-divider-width 8
     :scroll-bar-width 8))
  :hook (after-init . spacious-padding-mode))

(use-package dashboard
  :custom
  (dashboard-center-content t)
  (dashboard-icon-type 'nerd-icons)
  (dashboard-set-file-icons t)
  (dashboard-set-heading-icons t)
  (dashboard-startup-banner 'official)
  (dashboard-items '((recents . 8)
                     (projects . 5)
                     (agenda . 5)))
  :config
  (dashboard-setup-startup-hook))

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :custom
  (hl-todo-keyword-faces
   '(("TODO" . "#ff9e64")
     ("NEXT" . "#7aa2f7")
     ("FIXME" . "#f7768e")
     ("HACK" . "#bb9af7")
     ("REVIEW" . "#7dcfff")
     ("NOTE" . "#9ece6a"))))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package colorful-mode
  :hook ((css-mode css-ts-mode scss-mode web-mode html-mode html-ts-mode
          tsx-ts-mode js-jsx-mode emacs-lisp-mode) . colorful-mode)
  :custom
  (colorful-use-prefix nil)
  (colorful-only-strings nil))

(use-package ligature
  :if (display-graphic-p)
  :config
  (ligature-set-ligatures 't '("www"))
  (ligature-set-ligatures
   'prog-mode
   '("**" "***" "**/" "*>" "*/" "\\\\" "\\\\\\"
     "::" ":::" ":=" "!!" "!=" "!==" "--" "---" "-->" "->" "->>"
     "#{" "#[" "##" "###" "####" "#(" "#?" "#_" ".-" ".=" ".."
     "..<" "..." "?=" "??" ";;" "/*" "/**" "/=" "/==" "/>" "//"
     "///" "&&" "||" "||=" "|=" "|>" "++" "+++" "+>" "=:=" "=="
     "===" "==>" "=>" "=>>" "<=" "=<<" "=/=" ">-" ">=" ">=>" ">>"
     ">>-" ">>=" ">>>" "<*" "<*>" "<|" "<|>" "<$" "<$>" "<!--"
     "<-" "<--" "<->" "<+" "<+>" "<=" "<==" "<=>" "<=<" "<>" "<<"
     "<<-" "<<=" "<<<" "<~" "<~~" "</" "</>" "~-" "~=" "~>" "~~"
     "~~>"))
  (global-ligature-mode 1))

;;; Completion and search

(use-package vertico
  :init
  (vertico-mode 1))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :after vertico
  :init
  (marginalia-mode 1))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)))

(use-package embark
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings)))

(use-package embark-consult
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-cycle t)
  (corfu-preview-current nil)
  :init
  (global-corfu-mode 1))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

(use-package helpful
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h x" . helpful-command)))

;;; Evil and editing

(use-package evil
  :init
  (setq evil-want-C-u-scroll t
        evil-want-keybinding nil
        evil-undo-system 'undo-redo)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package general
  :after evil
  :config
  (general-create-definer bhc/leader
    :states '(normal visual motion)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "C-SPC"))

(use-package which-key
  :init
  (which-key-mode 1)
  :custom
  (which-key-idle-delay 0.35)
  (which-key-idle-secondary-delay 0.05)
  (which-key-side-window-location 'bottom)
  (which-key-side-window-max-height 0.33)
  (which-key-sort-order 'which-key-key-order-alpha))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode 1))

(use-package evil-goggles
  :after evil
  :custom
  (evil-goggles-duration 0.12)
  :config
  (evil-goggles-mode 1))

(use-package undo-fu-session
  :config
  (setq undo-fu-session-directory (expand-file-name "undo/" bhc/state-dir))
  (global-undo-fu-session-mode 1))

(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :config
  (require 'smartparens-config))

(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :after yasnippet)

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)))

(use-package ws-butler
  :hook ((prog-mode text-mode conf-mode) . ws-butler-mode))

(use-package avy
  :custom
  (avy-timeout-seconds 0.3)
  (avy-all-windows t))

(use-package vundo
  :custom
  (vundo-glyph-alist vundo-unicode-symbols)
  (vundo-compact-display t))

(use-package harpoon)

;;; Project, files, git, terminal

(use-package projectile
  :init
  (projectile-mode 1)
  :custom
  (projectile-completion-system 'default)
  (projectile-project-search-path '("~/Development" "~/.dotfiles")))

(use-package editorconfig
  :config
  (editorconfig-mode 1))

(use-package magit
  :commands (magit-status magit-dispatch))

(use-package diff-hl
  :hook ((prog-mode text-mode conf-mode) . diff-hl-mode)
  :config
  (diff-hl-flydiff-mode 1))

(use-package dirvish
  :init
  (dirvish-override-dired-mode)
  :custom
  (dirvish-mode-line-format '(:left (sort symlink) :right (omit yank index)))
  (dirvish-attributes '(nerd-icons file-time file-size collapse subtree-state vc-state)))

(use-package nerd-icons)

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package vterm
  :commands vterm
  :custom
  (vterm-max-scrollback 10000))

(use-package popper
  :bind (("C-`" . popper-toggle)
         ("M-`" . popper-cycle)
         ("C-M-`" . popper-toggle-type))
  :custom
  (popper-reference-buffers
   '("\\*Messages\\*"
     "\\*Warnings\\*"
     "\\*Help\\*"
     "\\*Backtrace\\*"
     "\\*Compile-Log\\*"
     "\\*Embark Collect.*\\*"
     "\\*Completions\\*"
     "\\*Async Shell Command\\*"
     help-mode
     compilation-mode
     vterm-mode))
  :init
  (popper-mode 1)
  (popper-echo-mode 1))

;;; Languages, LSP, formatting

(use-package treesit-auto
  :custom
  (treesit-auto-install nil)
  (treesit-auto-langs '(bash c cpp css dockerfile go gomod html javascript json lua python
                        rust toml tsx typescript yaml))
  :config
  (global-treesit-auto-mode 1))

(use-package web-mode
  :mode "\\.vue\\'"
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (web-mode-enable-auto-quoting nil))

(use-package emmet-mode
  :hook ((sgml-mode html-mode mhtml-mode html-ts-mode web-mode
          css-mode css-ts-mode scss-mode less-css-mode
          js-jsx-mode tsx-ts-mode) . emmet-mode)
  :custom
  (emmet-move-cursor-between-quotes t)
  (emmet-self-closing-tag-style " /"))

(use-package typescript-mode
  :mode (("\\.ts\\'" . typescript-mode)
         ("\\.tsx\\'" . typescript-mode)))

(use-package markdown-mode :mode "\\.md\\'")
(use-package yaml-mode :mode "\\.ya?ml\\'")
(use-package dockerfile-mode :mode "Dockerfile\\'")
(use-package terraform-mode :mode "\\.tf\\'")
(use-package go-mode :mode "\\.go\\'")
(use-package rust-mode :mode "\\.rs\\'")
(use-package elixir-ts-mode :mode "\\.exs?\\'")
(use-package lua-mode :mode "\\.lua\\'")
(use-package graphql-mode :mode "\\.graphql\\'")
(add-to-list 'auto-mode-alist '("\\.prisma\\'" . conf-mode))
(use-package ledger-mode
  :mode ("\\.journal\\'" "\\.ledger\\'")
  :custom
  (ledger-clear-whole-transactions 1)
  (ledger-reports
   '(("bal" "%(binary) -f %(ledger-file) bal")
     ("reg" "%(binary) -f %(ledger-file) reg")
     ("payee" "%(binary) -f %(ledger-file) reg @%(payee)"))))

(use-package restclient :mode ("\\.http\\'" "\\.rest\\'"))

(use-package eglot
  :ensure nil
  :commands (eglot eglot-ensure)
  :custom
  (eglot-autoshutdown t)
  (eglot-events-buffer-size 0))

(defconst bhc/vue-language-server-root
  (expand-file-name "~/.local/share/nvim/mason/packages/vue-language-server/node_modules"))

(defconst bhc/vue-typescript-sdk
  (expand-file-name "typescript/lib" bhc/vue-language-server-root))

(with-eval-after-load 'eglot
  (add-to-list
   'eglot-server-programs
   `(((js-mode :language-id "javascript")
      (js-ts-mode :language-id "javascript")
      (typescript-mode :language-id "typescript")
      (typescript-ts-mode :language-id "typescript")
      (tsx-ts-mode :language-id "typescriptreact"))
     . ("vtsls" "--stdio")))

  (add-to-list
   'eglot-server-programs
   `((web-mode :language-id "vue")
     . ("vue-language-server" "--stdio"
        :initializationOptions
        (:typescript (:tsdk ,bhc/vue-typescript-sdk
                      :disableAutoImportCache :json-false)
         :vue (:hybridMode :json-false)))))

  (add-to-list
   'eglot-server-programs
   '(((toml-ts-mode :language-id "toml")
      (conf-toml-mode :language-id "toml"))
     . ("taplo" "lsp" "stdio")))

  (add-to-list
   'eglot-server-programs
   '((graphql-mode :language-id "graphql")
     . ("graphql-lsp" "server" "-m" "stream")))

  ;; eglot binds one server per buffer, so tailwindcss-language-server can only
  ;; be primary in plain HTML/CSS buffers. In .vue (web-mode) and .tsx the Vue
  ;; server / vtsls already own the slot, so Tailwind class completion is not
  ;; available there (an eglot limitation vs nvim's multi-client model).
  (add-to-list
   'eglot-server-programs
   '((html-mode :language-id "html")
     (mhtml-mode :language-id "html")
     (html-ts-mode :language-id "html")
     (css-mode :language-id "css")
     (css-ts-mode :language-id "css")
     (scss-mode :language-id "scss")
     (less-css-mode :language-id "less")
     . ("tailwindcss-language-server" "--stdio")))

  (setq-default
   eglot-workspace-configuration
   `(:vtsls
     (:tsserver
      (:globalPlugins
       [(:name "@vue/typescript-plugin"
         :location ,(expand-file-name "@vue/language-server" bhc/vue-language-server-root)
         :languages ["vue"]
         :configNamespace "typescript")]))
     :typescript
     (:preferences
      (:importModuleSpecifierPreference "non-relative"
       :includeCompletionsForModuleExports t
       :includeCompletionsWithInsertText t)))))

(defun bhc/eglot-server-program ()
  (when (fboundp 'eglot--lookup-mode)
    (ignore-errors
      (eglot--lookup-mode major-mode))))

(defun bhc/eglot-contact-available-p (server-program)
  (let ((contact (cdr server-program)))
    (cond
     ((null server-program) nil)
     ((functionp contact) t)
     ((and (listp contact) (stringp (car contact))) (executable-find (car contact)))
     ((stringp contact) (executable-find contact))
     (t t))))

(defun bhc/eglot-ensure ()
  (unless (file-remote-p default-directory)
    (require 'eglot)
    (let ((server-program (bhc/eglot-server-program)))
      (when (bhc/eglot-contact-available-p server-program)
        (eglot-ensure)))))

(defun bhc/vue-buffer-p ()
  (and buffer-file-name
       (string-equal (file-name-extension buffer-file-name) "vue")))

(dolist (hook '(bash-ts-mode-hook
                css-mode-hook
                css-ts-mode-hook
                dockerfile-mode-hook
                elixir-ts-mode-hook
                go-mode-hook
                go-ts-mode-hook
                graphql-mode-hook
                html-mode-hook
                html-ts-mode-hook
                js-mode-hook
                js-ts-mode-hook
                json-mode-hook
                json-ts-mode-hook
                lua-mode-hook
                python-mode-hook
                python-ts-mode-hook
                rust-mode-hook
                rust-ts-mode-hook
                sh-mode-hook
                terraform-mode-hook
                toml-ts-mode-hook
                conf-toml-mode-hook
                typescript-mode-hook
                tsx-ts-mode-hook
                typescript-ts-mode-hook
                yaml-mode-hook
                yaml-ts-mode-hook))
  (add-hook hook #'bhc/eglot-ensure))

(add-hook 'web-mode-hook
          (lambda ()
            (when (bhc/vue-buffer-p)
              (bhc/eglot-ensure))))

(use-package consult-eglot
  :after (consult eglot))

(use-package apheleia
  :config
  (setf (alist-get 'goimports apheleia-formatters)
        '("goimports" "-local" "github.com/reviz0r"))
  (dolist (entry '((js-mode . prettier)
                   (js-ts-mode . prettier)
                   (typescript-ts-mode . prettier)
                   (tsx-ts-mode . prettier)
                   (web-mode . prettier)
                   (go-mode . (goimports gofumpt))
                   (go-ts-mode . (goimports gofumpt))
                   (json-mode . prettier)
                   (json-ts-mode . prettier)
                   (css-mode . prettier)
                   (css-ts-mode . prettier)
                   (markdown-mode . prettier)
                   (sh-mode . shfmt)
                   (yaml-mode . prettier)
                   (yaml-ts-mode . prettier)))
    (setf (alist-get (car entry) apheleia-mode-alist) (cdr entry)))
  (apheleia-global-mode 1))

;;; AI

;; Inline completion from local llama.cpp via llama-swap (replaces Copilot).
;; Asking for "qwen-coder-7b" makes llama-swap load the 7B coder on the GPU.
(use-package minuet
  :hook (prog-mode . minuet-auto-suggestion-mode)
  :bind (("M-i" . minuet-show-suggestion)
         :map minuet-active-mode-map
         ("M-l" . minuet-accept-suggestion)
         ("M-L" . minuet-accept-suggestion-line)
         ("M-]" . minuet-next-suggestion)
         ("M-[" . minuet-previous-suggestion)
         ("C-]" . minuet-dismiss-suggestion))
  :config
  (defun bhc/minuet-qwen-fim-prompt (ctx)
    (format "<|fim_prefix|>%s<|fim_suffix|>%s<|fim_middle|>"
            (plist-get ctx :before-cursor)
            (plist-get ctx :after-cursor)))
  (setq minuet-provider 'openai-fim-compatible
        minuet-n-completions 1
        minuet-context-window 512)
  (plist-put minuet-openai-fim-compatible-options :end-point "http://localhost:8081/v1/completions")
  (plist-put minuet-openai-fim-compatible-options :name "llama.cpp")
  (plist-put minuet-openai-fim-compatible-options :api-key "TERM")
  (plist-put minuet-openai-fim-compatible-options :model "qwen-coder-7b")
  (minuet-set-nested-plist minuet-openai-fim-compatible-options
                           #'bhc/minuet-qwen-fim-prompt :template :prompt)
  (minuet-set-nested-plist minuet-openai-fim-compatible-options nil :template :suffix)
  (minuet-set-optional-options minuet-openai-fim-compatible-options :max_tokens 256)
  (minuet-set-optional-options minuet-openai-fim-compatible-options :top_p 0.9))

;; Drives the `claude` CLI in a vterm buffer (≈ claudecode.nvim).
;; Backend must be set in :init — claude-code defcustoms it to 'eat (which pulls
;; in the uninstalled eat package); setting it after load is too late.
(use-package claude-code
  :vc (:url "https://github.com/stevemolitor/claude-code.el" :rev :newest)
  :init
  (setq claude-code-terminal-backend 'vterm)
  :config
  (claude-code-mode 1))

;; Local-LLM chat via gptel → llama-swap (loads the 30B on first request).
(use-package gptel
  :config
  (setq gptel-model 'qwen-coder-30b
        gptel-backend (gptel-make-openai "llama-swap"
                        :host "localhost:8081"
                        :protocol "http"
                        :endpoint "/v1/chat/completions"
                        :stream t
                        :key "ollama"
                        :models '(qwen-coder-30b qwen-coder-7b))))

;;; Org

(defun bhc/org-file (name)
  (expand-file-name name bhc/org-directory))

(defun bhc/org-agenda-files ()
  (when (file-directory-p bhc/org-directory)
    (directory-files-recursively bhc/org-directory "\\.org\\'")))

(use-package org
  :ensure nil
  :mode ("\\.org\\'" . org-mode)
  :custom
  (org-directory bhc/org-directory)
  (org-default-notes-file (bhc/org-file "inbox.org"))
  (org-id-locations-file (bhc/org-file ".orgids"))
  (org-agenda-files (bhc/org-agenda-files))
  (org-startup-indented nil)
  (org-hide-leading-stars nil)
  (org-startup-folded 'content)
  (org-ellipsis "...")
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-return-follows-link t)
  (org-cycle-separator-lines 1)
  (org-tags-column 0)
  (org-todo-keywords
   '((sequence "TODO(t)" "NEXT(n)" "IN-PROGRESS(p)" "WAITING(w@/!)" "|"
               "DONE(d!)" "CANCELED(c@)")))
  (org-refile-targets '((org-agenda-files :maxlevel . 3)))
  (org-outline-path-complete-in-steps nil)
  (org-refile-use-outline-path 'file)
  (org-capture-templates
   `(("i" "Inbox" entry (file ,(bhc/org-file "inbox.org"))
      "* TODO %?\n%U\n")
     ("t" "Task" entry (file ,(bhc/org-file "todo.org"))
      "* TODO %?\n%U\n")
     ("w" "Work" entry (file ,(bhc/org-file "work.org"))
      "* TODO %?\n%U\n")
     ("j" "Journal" entry (file+olp+datetree ,(bhc/org-file "journal.org"))
      "* %U %?\n")
     ("b" "Blog post" entry (file ,(bhc/org-file "blog.org"))
      ,(concat "* TODO %^{Title}  :@uncategorized:\n"
               ":PROPERTIES:\n"
               ":EXPORT_FILE_NAME: %^{Slug}\n"
               ":EXPORT_DATE: %<%Y-%m-%d>\n"
               ":END:\n%?\n")
      :prepend t)))
  (org-agenda-custom-commands
   '(("d" "Dashboard"
      ((agenda "" ((org-agenda-span 7)))
       (todo "NEXT")
       (todo "IN-PROGRESS")
       (todo "WAITING")))
     ("n" "Next actions" todo "NEXT")
     ("w" "Waiting" todo "WAITING")))
  :config
  (add-to-list 'org-modules 'org-habit)
  (require 'org-habit)
  (setq org-habit-show-habits-only-for-today nil)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (python . t)
     (js . t)
     (sql . t))))

(use-package org-modern
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda)))

(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :custom
  (org-appear-autoemphasis t)
  (org-appear-autolinks t)
  (org-appear-autosubmarkers t))

(use-package org-roam
  :custom
  (org-roam-directory (bhc/org-file "roam"))
  (org-roam-completion-everywhere t)
  :config
  (org-roam-db-autosync-mode 1))

(use-package org-pomodoro
  :after org)

(use-package org-present
  :after org)

(use-package org-download
  :after org
  :custom
  (org-download-method 'directory)
  (org-download-image-dir (bhc/org-file "attachments"))
  (org-download-heading-lvl nil))

(use-package toc-org
  :hook (org-mode . toc-org-mode))

;;; Blog (ox-hugo)

(defconst bhc/hugo-base-dir "~/Development/projects/overdevelop/blog"
  "Hugo site that `blog.org' exports into (matches its #+HUGO_BASE_DIR).")

(use-package ox-hugo
  :after ox
  :custom
  (org-hugo-base-dir bhc/hugo-base-dir)
  (org-hugo-front-matter-format "yaml")
  (org-hugo-auto-set-lastmod t))

(defun bhc/visit-blog ()
  "Open the org source for the blog."
  (interactive)
  (find-file (bhc/org-file "blog.org")))

(defun bhc/blog-export-all ()
  "Export every post subtree in blog.org to Hugo markdown."
  (interactive)
  (with-current-buffer (find-file-noselect (bhc/org-file "blog.org"))
    (org-hugo-export-wim-to-md :all-subtrees)))

(defun bhc/hugo-server ()
  "Run the Hugo dev server (with drafts) for live preview."
  (interactive)
  (let ((default-directory (expand-file-name bhc/hugo-base-dir)))
    (compile "hugo server --buildDrafts --navigateToChanged")))

;;; Keybindings

(with-eval-after-load 'general
  (bhc/leader
    "SPC" '(execute-extended-command :which-key "M-x")
    "TAB" '(consult-buffer :which-key "buffer")

    "a" '(:ignore t :which-key "ai")
    "aa" '(claude-code :which-key "claude")
    "am" '(claude-code-transient :which-key "claude menu")
    "ag" '(gptel :which-key "gptel chat")
    "as" '(gptel-send :which-key "gptel send")
    "aG" '(gptel-menu :which-key "gptel menu")

    "j" '(:ignore t :which-key "jump")
    "jj" '(avy-goto-char-timer :which-key "char")
    "jl" '(avy-goto-line :which-key "line")
    "jw" '(avy-goto-word-1 :which-key "word")

    "m" '(:ignore t :which-key "marks")
    "ma" '(harpoon-add-file :which-key "add file")
    "mm" '(harpoon-toggle-quick-menu :which-key "menu")
    "1" '(harpoon-go-to-1 :which-key "harpoon 1")
    "2" '(harpoon-go-to-2 :which-key "harpoon 2")
    "3" '(harpoon-go-to-3 :which-key "harpoon 3")
    "4" '(harpoon-go-to-4 :which-key "harpoon 4")

    "u" '(vundo :which-key "undo tree")

    "b" '(:ignore t :which-key "buffers")
    "bb" '(consult-buffer :which-key "switch")
    "bd" '(kill-current-buffer :which-key "kill")
    "br" '(revert-buffer :which-key "revert")

    "f" '(:ignore t :which-key "files")
    "ff" '(find-file :which-key "find")
    "fr" '(consult-recent-file :which-key "recent")
    "fs" '(save-buffer :which-key "save")

    "g" '(:ignore t :which-key "git")
    "gg" '(magit-status :which-key "status")
    "gb" '(magit-blame-addition :which-key "blame")

    "l" '(:ignore t :which-key "lsp")
    "la" '(eglot-code-actions :which-key "actions")
    "lf" '(eglot-format :which-key "format")
    "lr" '(eglot-rename :which-key "rename")
    "ls" '(consult-eglot-symbols :which-key "symbols")

    "o" '(:ignore t :which-key "org")
    "oa" '(org-agenda :which-key "agenda")
    "oc" '(org-capture :which-key "capture")
    "or" '(org-roam-node-find :which-key "roam find")
    "oi" '(org-roam-node-insert :which-key "roam insert")
    "op" '(org-pomodoro :which-key "pomodoro")
    "oh" '(:ignore t :which-key "hugo/blog")
    "ohb" '(bhc/visit-blog :which-key "open blog.org")
    "ohe" '(org-hugo-export-wim-to-md :which-key "export here")
    "oha" '(bhc/blog-export-all :which-key "export all")
    "ohs" '(bhc/hugo-server :which-key "hugo server")

    "p" '(:ignore t :which-key "projects")
    "pp" '(projectile-switch-project :which-key "switch")
    "pf" '(projectile-find-file :which-key "file")
    "ps" '(consult-ripgrep :which-key "search")

    "s" '(:ignore t :which-key "search")
    "ss" '(consult-line :which-key "line")
    "sg" '(consult-ripgrep :which-key "ripgrep")

    "t" '(:ignore t :which-key "toggles")
    "tt" '(vterm :which-key "terminal")
    "tn" '(display-line-numbers-mode :which-key "line numbers")

    "w" '(:ignore t :which-key "windows")
    "wh" '(evil-window-left :which-key "left")
    "wj" '(evil-window-down :which-key "down")
    "wk" '(evil-window-up :which-key "up")
    "wl" '(evil-window-right :which-key "right")
    "ws" '(split-window-below :which-key "split")
    "wv" '(split-window-right :which-key "vsplit")
    "wd" '(delete-window :which-key "delete")))

(when (file-exists-p custom-file)
  (load custom-file t))
