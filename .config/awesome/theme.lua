local awful = require("awful")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local helpers = require("helpers")

local theme = dofile(themes_path .. "default/theme.lua")

theme.font = "Iosevka Term 9"

theme.bg_normal = x.transbg
theme.bg_dark = x.bg
theme.bg_focus = x.transbg
theme.bg_urgent = x.color3
theme.bg_minimize = x.bg
theme.bg_systray = x.trans

theme.fg_normal = x.fg
theme.fg_focus = x.color1
theme.fg_urgent = x.color3
theme.fg_minimize = x.fg

theme.useless_gap = dpi(10)

theme.gap_single_client = true

theme.border_width = dpi(0)
theme.border_normal = x.color0
theme.border_focus = x.color8
theme.border_radius = dpi(30)
theme.client_radius = dpi(30)
theme.titlebar_size = dpi(30)

local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
                                taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
                                  taglist_square_size, theme.fg_normal)

theme.taglist_fg_empty = x.color8
theme.taglist_fg_occupied = x.color4
theme.taglist_fg_urgent = x.color9
theme.taglist_fg_focus = x.color1
theme.taglist_bg_empty = x.trans
theme.taglist_bg_occupied = x.trans
theme.taglist_bg_urgent = x.trans
theme.taglist_bg_focus = x.trans

theme.tasklist_font = theme.font
theme.tasklist_fg_focus = x.fg
theme.tasklist_fg_normal = x.color8

theme.systray_icon_spacing = dpi(8)
theme.notification_max_width = dpi(350)
theme.notification_font = "Iosevka Term 9"

theme.icon_theme = "/home/yrwq/.icons/grey/apps/16"

theme = theme_assets.recolor_layout(theme, x.fg)

theme.mstab_bar_height = dpi(30)
theme.mstab_bar_padding = dpi(10)
theme.mstab_tabbar_orientation = "top"
theme.mstab_border_radius = dpi(10)

theme.tabbar_style = "modern"
theme.tabbar_bg_focus = x.bg
theme.tabbar_bg_normal = x.bg
theme.tabbed_spawn_in_tab = true
theme.tabbar_radius = dpi(6)
theme.tabbar_font = "Iosevka Term 11"

return theme
