local awful = require("awful")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local xrdb = xresources.get_current_theme()
local gears = require("gears")
local gfs = require("gears.filesystem")

local theme = dofile("/usr/share/awesome/themes/default/theme.lua")

theme.font = "Cozette 10"
theme.nfont = "Cozette "
theme.ifont = "Iosevka Nerd Font Mono "

theme.wallpaper = os.getenv("HOME") .. "/.wp/forest.jpg"

xres_file = os.getenv("HOME") .. "/.config/awesome/themes/dear/xresources"

local config_home = gfs.get_xdg_config_home()

local zathura_home = config_home .. "zathura/"

awful.spawn.with_shell("cp " .. zathura_home .. "dark " .. zathura_home .. "zathurarc")


awful.spawn.with_shell("xrdb " .. xres_file)
-- awful.spawn.with_shell("xrdb " .. "~/.Xresources")

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

theme.taglist_font = theme.nfont .. "24"

theme.taglist_bg = x.bg

theme.taglist_bg_focus = x.color0
theme.taglist_fg_focus = x.fg

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

-- theme.tabbar_style = "modern"

-- theme.tabbar_bg_focus = x.bg
-- theme.tabbar_bg_normal = x.color0
-- theme.tabbar_position = "top"

theme.tabbar_style = "default"
theme.tabbar_size = dpi(28)
theme.tabbar_ontop  = true
theme.tabbar_position = "top"
theme.tabbar_bg_normal = x.bg
theme.tabbar_fg_normal = x.fg
theme.tabbar_bg_focus  = x.color0
theme.tabbar_fg_focus  = x.fg


-- layout icons
theme.lain_icons         = os.getenv("HOME") ..  "/.config/awesome/lain/icons/layout/default/"
theme.layout_termfair    = theme.lain_icons .. "termfair.png"
theme.layout_centerfair  = theme.lain_icons .. "centerfair.png"  -- termfair.center
theme.layout_cascade     = theme.lain_icons .. "cascade.png"
theme.layout_cascadetile = theme.lain_icons .. "cascadetile.png" -- cascade.tile
theme.layout_centerwork  = theme.lain_icons .. "centerwork.png"
theme.layout_centerworkh = theme.lain_icons .. "centerworkh.png" -- centerwork.horizontal

return theme
