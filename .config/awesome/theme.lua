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

-- default font
theme.font = "Iosevka Custom 9"

-- colors
theme.bg_normal = x.trans40
theme.bg_dark = x.transbg
theme.bg_focus = x.transbg
theme.bg_urgent = x.color3
theme.bg_minimize = x.trans40
theme.bg_systray = x.trans
theme.fg_normal = x.fg
theme.fg_focus = x.color1
theme.fg_urgent = x.color3
theme.fg_minimize = x.fg

-- hotkeys
theme.hotkeys_bg = x.bg
theme.hotkeys_fg = x.fg
theme.hotkeys_border_width = dpi(5)
theme.hotkeys_modifiers_fg = x.color1
theme.hotkeys_font = "Iosevka Custom 12"
theme.hotkeys_group_margin = dpi(15)

-- taglist
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
                                taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
                                  taglist_square_size, theme.fg_normal)
theme.taglist_fg_empty = x.color0
theme.taglist_fg_occupied = x.color9
theme.taglist_fg_urgent = x.color11
theme.taglist_fg_focus = x.color13
theme.taglist_bg_empty = x.trans
theme.taglist_bg_occupied = x.trans
theme.taglist_bg_urgent = x.trans
theme.taglist_bg_focus = x.color8 .. "90"
theme.taglist_font = "Iosevka Custom 16"

-- tasklist
theme.tasklist_font = theme.font
theme.tasklist_fg_focus = x.fg
theme.tasklist_fg_normal = x.color8

-- other
theme = theme_assets.recolor_layout(theme, x.fg)
theme.wibar_height = dpi(35)
theme.systray_icon_spacing = dpi(8)
theme.useless_gap = dpi(10)
theme.gap_single_client = true
theme.border_width = dpi(0)
theme.border_normal = x.color0
theme.border_focus = x.color8
theme.bar_radius = dpi(7)
theme.border_radius = dpi(30)
theme.client_radius = dpi(30)
theme.titlebar_size = dpi(25)


-- bling mstab
theme.mstab_bar_height = dpi(25)
theme.mstab_bar_padding = dpi(10)
theme.mstab_tabbar_orientation = "top"
theme.mstab_border_radius = dpi(10)

-- bling tabbar
theme.tabbar_style = "modern"
theme.tabbar_size = dpi(30)
theme.tabbar_bg_focus = x.transbg
theme.tabbar_bg_normal = x.trans40
theme.tabbed_spawn_in_tab = true
theme.tabbar_radius = dpi(3)
theme.tabbar_font = "Iosevka Custom 9"

-- popup
theme.popup_bg = x.color0 .. "B3" -- 70% transparent

-- notifications
theme.notification_font = "Iosevka Custom 9"
theme.notification_bg = x.color0
theme.notification_max_width = dpi(400)

return theme
