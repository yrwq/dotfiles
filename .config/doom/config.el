(setq user-full-name "yrwq"
      user-mail-address "yrwq_again@proton.me")

(setq confirm-kill-emacs nil)
(setq default-frame-alist '((undecorated . t))) ; remove titlebar

(setq doom-font (font-spec :family "FantasqueSansM Nerd Font Mono" :size 16)
      doom-variable-pitch-font (font-spec :family "Iosevka Custom" :size 16))

(setq display-line-numbers-type t)
(setq org-directory "~/org/")
(setq org-agenda-files (list "~/org/notes.org" "~/org/todo.org"))
(setq doom-modeline-icon nil)
(setq doom-modeline-buffer-file-name-style 'buffer-name)
(setq doom-modeline-buffer-encoding nil)
(setq doom-modeline-env-version nil)
