;; base16-main-theme.el -- A base16 colorscheme

;;; Commentary:
;; Base16: (https://github.com/chriskempson/base16)

;;; Authors:
;; Scheme: arcticicestudio
;; Template: Kaleb Elwert <belak@coded.io>

;;; Code:

(require 'base16-theme)

(defvar base16-main-colors
  '(:base00 "#2E3440"
    :base01 "#3B4252"
    :base02 "#434C5E"
    :base03 "#4C566A"
    :base04 "#D8DEE9"
    :base05 "#E5E9F0"
    :base06 "#ECEFF4"
    :base07 "#8FBCBB"
    :base08 "#88C0D0"
    :base09 "#81A1C1"
    :base0A "#5E81AC"
    :base0B "#BF616A"
    :base0C "#D08770"
    :base0D "#EBCB8B"
    :base0E "#A3BE8C"
    :base0F "#B48EAD")
  "All colors for Base16 main are defined here.")

;; Define the theme
(deftheme base16-main)

;; Add all the faces to the theme
(base16-theme-define 'base16-main base16-main-colors)

;; Mark the theme as provided
(provide-theme 'base16-main)

(provide 'base16-main-theme)

;;; base16-main-theme.el ends here
