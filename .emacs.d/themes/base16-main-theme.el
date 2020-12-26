;; base16-main-theme.el -- A base16 colorscheme

;;; Commentary:
;; Base16: (https://github.com/chriskempson/base16)

;;; Authors:
;; Scheme: Nate Peterson
;; Template: Kaleb Elwert <belak@coded.io>

;;; Code:

(require 'base16-theme)

(defvar base16-main-colors
  '(:base00 "#212121"
    :base01 "#303030"
    :base02 "#353535"
    :base03 "#4A4A4A"
    :base04 "#B2CCD6"
    :base05 "#EEFFFF"
    :base06 "#EEFFFF"
    :base07 "#FFFFFF"
    :base08 "#F07178"
    :base09 "#F78C6C"
    :base0A "#FFCB6B"
    :base0B "#C3E88D"
    :base0C "#89DDFF"
    :base0D "#82AAFF"
    :base0E "#C792EA"
    :base0F "#FF5370")
  "All colors for Base16 main are defined here.")

;; Define the theme
(deftheme base16-main)

;; Add all the faces to the theme
(base16-theme-define 'base16-main base16-main-colors)

;; Mark the theme as provided
(provide-theme 'base16-main)

(provide 'base16-main-theme)

;;; base16-main-theme.el ends here
