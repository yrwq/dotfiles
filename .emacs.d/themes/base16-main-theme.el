;; base16-main-theme.el -- A base16 colorscheme

;;; Commentary:
;; Base16: (https://github.com/chriskempson/base16)

;;; Authors:
;; Scheme: Dawid Kurek (dawikur@gmail.com), morhetz (https://github.com/morhetz/gruvbox)
;; Template: Kaleb Elwert <belak@coded.io>

;;; Code:

(require 'base16-theme)

(defvar base16-main-colors
  '(:base00 "#262626"
    :base01 "#3a3a3a"
    :base02 "#4e4e4e"
    :base03 "#8a8a8a"
    :base04 "#949494"
    :base05 "#dab997"
    :base06 "#d5c4a1"
    :base07 "#ebdbb2"
    :base08 "#d75f5f"
    :base09 "#ff8700"
    :base0A "#ffaf00"
    :base0B "#afaf00"
    :base0C "#85ad85"
    :base0D "#83adad"
    :base0E "#d485ad"
    :base0F "#d65d0e")
  "All colors for Base16 main are defined here.")

;; Define the theme
(deftheme base16-main)

;; Add all the faces to the theme
(base16-theme-define 'base16-main base16-main-colors)

;; Mark the theme as provided
(provide-theme 'base16-main)

(provide 'base16-main-theme)

;;; base16-main-theme.el ends here
