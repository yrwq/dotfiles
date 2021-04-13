local awful = require("awful")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gears = require("gears")
local gfs = require("gears.filesystem")

local theme = dofile("/usr/share/awesome/themes/default/theme.lua")

theme.font = "Dina 11"
theme.nfont = "Dina "
theme.ifont = "TerminessTTF Nerd Font Mono "

theme.wallpaper = os.getenv("HOME") .. "/.wp/pointoverhead.jpg"

-- Colors from xresources
x = {
    bg = xrdb.background,
    fg = xrdb.foreground,
    rans = "#00000000",   -- fully transparent
    color0     = xrdb.color0,
    color1     = xrdb.color1,
    color2     = xrdb.color2,
    color3     = xrdb.color3,
    color4     = xrdb.color4,
    color5     = xrdb.color5,
    color6     = xrdb.color6,
    color7     = xrdb.color7,
    color8     = xrdb.color8,
    color9     = xrdb.color9,
    color10    = xrdb.color10,
    color11    = xrdb.color11,
    color12    = xrdb.color12,
    color13    = xrdb.color13,
    color14    = xrdb.color14,
    color15    = xrdb.color15,
}


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

theme.border_width = dpi(2)
theme.border_normal = x.bg
theme.border_focus = x.color9
theme.border_radius = dpi(15)

-- taglist

local taglist_square_size = dpi(0)

theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

theme.taglist_bg = x.bg

theme.taglist_bg_focus = x.color9
theme.taglist_fg_focus = x.bg

theme.taglist_bg_urgent = x.color1
theme.taglist_fg_urgent = x.bg

theme.taglist_bg_occupied = x.color8
theme.taglist_fg_occupied = x.fg

theme.taglist_bg_empty = x.color0
theme.taglist_fg_empty = x.color15

theme.taglist_bg_volatile = transparent
theme.taglist_fg_volatile = x.color9

theme.taglist_disable_icon = true

--tasklist

theme.tasklist_font = theme.font
theme.tasklist_plain_task_name = true

theme.tasklist_bg_focus = x.color0
theme.tasklist_fg_focus = x.fg

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
theme.titlebar_fg_normal = x.fg .. "55"
theme.titlebar_bg_focus = x.bg
theme.titlebar_fg_focus = x.fg

-- Prompt

theme.prompt_bg = transparent
theme.prompt_fg = x.fg
theme.prompt_fg_cursor = x.color15
theme.prompt_bg_cursor = x.color15

-- Menu

theme.menu_font = theme.font

theme.menu_bg_focus = x.color0
theme.menu_fg_focus = x.fg

theme.menu_bg_normal = x.bg
theme.menu_fg_normal = x.fg

theme.menu_height = dpi(20)
theme.menu_width = dpi(130)

theme.menu_border_color = theme.border_focus
theme.menu_border_width = dpi(2)

-- Hotkeys Pop Up

theme.hotkeys_font = theme.font
theme.hotkeys_border_color = theme.border_focus
theme.hotkeys_border_width = dpi(2)
theme.hotkeys_modifiers_fg = x.fg
theme.hotkeys_group_margin = dpi(10)
theme.hotkeys_bg = x.bg


-- Wibar

theme.wibar_height = dpi(30)
theme.wibar_bg = x.bg

-- Systray

theme.systray_icon_spacing = dpi(10)
theme.bg_systray = x.color5
theme.systray_icon_size = dpi(16)

-- Tabs

theme.tabbar_style = "default"
theme.tabbar_size = dpi(28)
theme.tabbar_ontop  = true
theme.tabbar_position = "top"
theme.tabbar_bg_normal = x.color0
theme.tabbar_fg_normal = x.fg
theme.tabbar_bg_focus  = x.bg
theme.tabbar_fg_focus  = x.fg

-- tag preview

theme.tag_preview_client_border_radius = 5
theme.tag_preview_client_opacity = 0.9
theme.tag_preview_client_bg = x.color0
theme.tag_preview_client_border_color = x.color9
theme.tag_preview_client_border_width = 2

theme.tag_preview_widget_border_radius = 5
theme.tag_preview_widget_bg = x.color0
theme.tag_preview_widget_border_color = x.color9
theme.tag_preview_widget_border_width = 2
theme.tag_preview_widget_margin = 10

-- misc notification

theme.notification_margin = dpi(5)

-- widget settings
theme.bar_widget_fg = x.bg

theme.profile_picture = os.getenv("HOME") .. "/etc/pic/prof.jpeg"

-- Layout icon
theme = theme_assets.recolor_layout(theme, theme.bar_widget_fg)

-- popup settings
theme.popup_bg = "#00000000"
theme.popup_bg_container = x.bg
theme.popup_mouse_timeout = 0.5
theme.popup_widget_radius = dpi(5)

-- dashboard settings
theme.dashboard_box_radius = dpi(12)
theme.dashboard_box_gap = dpi(5)
theme.dashboard_bg = x.bg .. "55"

return theme
