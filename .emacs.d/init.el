(setq inhibit-startup-message t)
(tool-bar-mode -1)
(fset 'yes-or-no-p 'y-or-n-p)
(setq make-backup-files nil)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; (load-theme 'xresources t)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
'("melpa" . "https://melpa.org/packages/"))

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
(package-refresh-contents)
(package-install 'use-package))

(use-package try
:ensure t)

(use-package evil)
(evil-mode 1)

(use-package counsel :ensure t )

(use-package which-key
:ensure t
:config
(which-key-mode))

(use-package org-bullets
:ensure t
:config
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(setq org-bullets-bullet-list '(" " " " " " " "))
(setq org-ellipsis "  ")
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-bullet-face ((t (:weight normal :height 1.5)))))
(setq org-bullets-face-name (quote org-bullet-face))

(use-package ivy
  :ensure t
  :diminish (ivy-mode)
  :bind (("C-x b" . ivy-switch-buffer))
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "%d/%d ")
  (setq ivy-display-style 'fancy))

(use-package swiper
:ensure try
:config
(progn
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-load-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key read-expression-map (kbd "C-r") 'counsel-expression-history)
))


(use-package jedi
:ensure t
:init)

(use-package elpy
  :ensure t
  :init
  (elpy-enable))

(use-package lua-mode
:ensure t)

(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-start-on-weekday nil)
(setq org-agenda-custom-commands
	'(("c" "Simple agenda view"
    ((agenda "")
    (alltodo "")))))
    (setq org-agenda-files (list "~/etc/doc/org/todo.org"
								 "~/etc/doc/org/notes.org"
								 ))

(org-babel-do-load-languages
	'org-babel-load-languages
    '((python . t)
    (emacs-lisp . t)
	(shell . t)
    (C . t)
    (js . t)
    (ditaa . t)
    (dot . t)
    (org . t)
    (latex . t )
))

(use-package hydra
    :ensure hydra
    :init
    (global-set-key
    (kbd "C-x t")
	    (defhydra toggle (:color red)
	      "toggle"
	      ("a" abbrev-mode "abbrev")
	      ("s" flyspell-mode "flyspell")
	      ("d" toggle-debug-on-error "debug")
	      ("c" fci-mode "fCi")
	      ("f" auto-fill-mode "fill")
	      ("t" toggle-truncate-lines "truncate")
	      ("w" whitespace-mode "whitespace")
	      ("q" nil "cancel")))
    (global-set-key
     (kbd "C-c t")
     (defhydra hydra-global-org (:color red)
       "Org"
       ("t" org-timer-start "Start Timer")
       ("s" org-timer-stop "Stop Timer")
       ("r" org-timer-set-timer "Set Timer") ; This one requires you be in an orgmode doc, as it sets the timer for the header
       ("p" org-timer "Print Timer") ; output timer value to buffer
       ("w" (org-clock-in '(4)) "Clock-In") ; used with (org-clock-persistence-insinuate) (setq org-clock-persist t)
       ("o" org-clock-out "Clock-Out") ; you might also want (setq org-log-note-clock-out t)
       ("j" org-clock-goto "Clock Goto") ; global visit the clocked task
       ("c" org-capture "Capture") ; Don't forget to define the captures you want http://orgmode.org/manual/Capture.html
	     ("l" (or )rg-capture-goto-last-stored "Last Capture"))
     ))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("6daa09c8c2c68de3ff1b83694115231faa7e650fdbb668bc76275f0f2ce2a437" default))
 '(custom-theme-directory "~/.emacs.d/themes/")
 '(org-confirm-babel-evaluate nil)
 '(org-default-notes-file (concat org-directory "/notes.org"))
 '(org-directory "~/etc/doc/org/")
 '(org-export-html-postamble nil)
 '(org-hide-leading-stars t)
 '(org-src-fontify-natively t)
 '(org-startup-folded 'overview)
 '(org-startup-indented t)
 '(package-selected-packages '(vterm rust-mode rustic which-key try use-package)))
