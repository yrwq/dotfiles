local awful = require("awful")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gears = require("gears")
local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = dofile("/usr/share/awesome/themes/default/theme.lua")
-- Fonts
theme.font = "Iosevka Custom 10"
theme.nfont = "Iosevka Custom "
theme.ifont = "Iosevka Nerd Font Mono "

theme.bg_dark = x.bg
theme.bg_normal = x.color0
theme.bg_focus = x.color8
theme.bg_urgent = x.color3
theme.bg_minimize = x.bg

theme.fg_normal = x.fg
theme.fg_focus = x.fg
theme.fg_urgent = x.bg
theme.fg_minimize = x.color15

-- gap

theme.useless_gap = dpi(10)

-- border

theme.border_width = dpi(0)
theme.border_normal = x.color0
theme.border_focus = x.color8
theme.border_radius = dpi(15)

-- taglist

local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

theme.taglist_font = theme.nfont .. "24"

theme.taglist_bg = x.bg

theme.taglist_bg_focus = x.color0
theme.taglist_fg_focus = x.color3

theme.taglist_bg_urgent = x.color3
theme.taglist_fg_urgent = x.bg

theme.taglist_bg_occupied = x.bg
theme.taglist_fg_occupied = x.fg

theme.taglist_bg_empty = x.bg
theme.taglist_fg_empty = x.color8

theme.taglist_bg_volatile = transparent
theme.taglist_fg_volatile = x.color9

theme.taglist_disable_icon = true

--tasklist

theme.tasklist_font = theme.font
theme.tasklist_plain_task_name = true

theme.tasklist_bg_focus = x.color0
theme.tasklist_fg_focus = x.color3

theme.tasklist_bg_minimize = x.bg
theme.tasklist_fg_minimize = x.color8

theme.tasklist_bg_normal = x.bg
theme.tasklist_fg_normal = x.fg

theme.tasklist_disable_task_name = false
theme.tasklist_disable_icon = true

theme.tasklist_bg_urgent = x.color0
theme.tasklist_fg_urgent = x.color1

theme.tasklist_align = "center"

-- Titlebars

theme.titlebar_height = dpi(30)

theme.titlebar_bg_normal = x.bg
theme.titlebar_fg_normal = x.color8

theme.titlebar_bg_focus = x.color0
theme.titlebar_fg_focus = x.fg

-- Prompt

theme.prompt_bg = transparent
theme.prompt_fg = x.fg

-- Menu

theme.menu_font = theme.font

theme.menu_bg_focus = x.color0
theme.menu_fg_focus = x.fg

theme.menu_bg_normal = x.bg
theme.menu_fg_normal = x.fg

theme.menu_height = dpi(20)
theme.menu_width = dpi(130)

theme.menu_border_color = theme.border_focus
theme.menu_border_width = dpi(4)

-- Hotkeys Pop Up

theme.hotkeys_font = theme.font
theme.hotkeys_border_color = theme.border_focus
theme.hotkeys_border_width = dpi(4)
theme.hotkeys_modifiers_fg = x.fg
theme.hotkeys_group_margin = dpi(10)

-- Layout icon

theme = theme_assets.recolor_layout(theme, x.fg)

-- Wibar

theme.wibar_height = dpi(30)
theme.wibar_bg = x.bg

-- Systray

theme.systray_icon_spacing = dpi(10)
theme.bg_systray = x.color8
theme.systray_icon_size = dpi(15)

-- Tabs

theme.mstab_bar_height = dpi(60)
theme.mstab_bar_padding = dpi(0)
theme.mstab_border_radius = dpi(10)

theme.tabbar_style = "modern"

theme.tabbar_bg_focus = x.bg
theme.tabbar_bg_normal = x.color0
theme.tabbar_position = "top"

theme.mstab_bar_ontop = false

-- layout icons
theme.lain_icons         = os.getenv("HOME") ..  "/.config/awesome/lain/icons/layout/default/"
theme.layout_termfair    = theme.lain_icons .. "termfair.png"
theme.layout_centerfair  = theme.lain_icons .. "centerfair.png"  -- termfair.center
theme.layout_cascade     = theme.lain_icons .. "cascade.png"
theme.layout_cascadetile = theme.lain_icons .. "cascadetile.png" -- cascade.tile
theme.layout_centerwork  = theme.lain_icons .. "centerwork.png"
theme.layout_centerworkh = theme.lain_icons .. "centerworkh.png" -- centerwork.horizontal

return theme
