;; You will most likely need to adjust this font size for your system!
(defvar efs/default-font-size 120)
(defvar efs/default-variable-font-size 120)

;; Turn off backing up and auto saving
(setq make-backup-files nil)
(add-to-list 'backup-directory-alist
             (cons tramp-file-name-regexp nil))
(setq auto-save-default nil)

;; Initialize package sources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
(require 'use-package)
(setq use-package-always-ensure t)

;; define list of languages to install
(defvar langs
  '(better-defaults

    ;; Python
    elpy))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      langs)

;; start languages
(elpy-enable)

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar
(column-number-mode)
(global-display-line-numbers-mode) ;; Display line numbers

(set-face-attribute 'default nil :font "Iosevka Custom" :height efs/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Iosevka Custom" :height efs/default-font-size)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "Iosevka Custom" :height efs/default-variable-font-size :weight 'regular)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package general
  :config
  (general-create-definer rune/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (rune/leader-keys
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")))

(use-package evil
  :init
  :config
  (evil-mode 1)
  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package all-the-icons)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package ivy
  :diminish
  :bind (:map ivy-minibuffer-map
              ("TAB" . ivy-alt-done)
              ("C-l" . ivy-alt-done)
              ("C-j" . ivy-next-line)
              ("C-k" . ivy-previous-line)
              :map ivy-switch-buffer-map
              ("C-k" . ivy-previous-line)
              ("C-l" . ivy-done)
              :map ivy-reverse-i-search-map
              ("C-k" . ivy-previous-line)
              ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :config
  (counsel-mode 1))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 2)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(defhydra hydra-man-wins (:timeout 2)
  "manipulate windows"
  ("j" evil-window-increase-height)
  ("k" evil-window-decrease-height)
  ("l" evil-window-increase-width)
  ("h" evil-window-decrease-width)
  ("f" nil "finished" :exit t))


(rune/leader-keys
  "ts" '(hydra-text-scale/body :which-key "scale text")
  "tw" '(hydra-man-wins/body :which-key "maniupulate windows"))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("" "" "" "")))

(use-package base16-theme
  :ensure t
  :load-path "themes"
  :init
  (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
  :config
  (load-theme 'base16-main t))

;; Ranger
(use-package ranger
  :ensure t)
(setq ranger-show-hidden t)
(setq ranger-preview-file t)
(setq ranger-show-literal t)

(use-package evil-nerd-commenter)
(use-package evil-leader)

;; Vim key bindings
(require 'evil-leader)
(evil-leader/set-leader "SPC")
(global-evil-leader-mode)
(evil-leader/set-key
  "." 'find-file
  "," 'ranger
  "j" 'evil-window-down
  "k" 'evil-window-up
  "l" 'evil-window-right
  "h" 'evil-window-left
  "wc" 'evil-window-delete
  "ws" 'evil-window-split
  "wv" 'evil-window-vsplit
  "c" 'evilnc-comment-or-uncomment-lines)


(use-package rainbow-mode
  :ensure t
  :init (rainbow-mode))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(ranger which-key vterm visual-fill-column use-package rainbow-mode rainbow-delimiters org-bullets markdown-mode+ lua-mode ivy-rich hydra helpful haskell-mode general forge evil-nerd-commenter evil-leader evil-collection eterm-256color eshell-git-prompt elcord doom-modeline counsel command-log-mode base16-theme))
 '(safe-local-variable-values '((git-commit-major-mode . git-commit-elisp-text-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
