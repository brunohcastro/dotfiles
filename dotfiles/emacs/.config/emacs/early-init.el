;;; early-init.el -*- lexical-binding: t; -*-

(setq package-enable-at-startup nil)
(setq frame-inhibit-implied-resize t)
(setq inhibit-compacting-font-caches t)
(setq warning-suppress-types '((native-compiler)))

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 128 1024 1024)
                  gc-cons-percentage 0.1)))

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))
(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

(defvar bhc--initial-mode-line-format (default-value 'mode-line-format))
(setq-default mode-line-format nil)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq-default mode-line-format bhc--initial-mode-line-format)))
