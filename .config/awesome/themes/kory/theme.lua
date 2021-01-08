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

-- fonts
-- fallback
theme.font = "Iosevka Custom 9"
-- normal font
theme.nfont = "Iosevka Custom "
-- icon font
theme.ifont = "Iosevka Nerd Font Mono "

theme.tasklist_font = theme.nfont .. "9"
theme.taglist_font = theme.ifont .. "16"
theme.hotkeys_font = theme.nfont .. "9"

-- colors
theme.bg_normal = x.bg
theme.bg_dark = x.bg
theme.bg_focus = x.bg
theme.bg_urgent = x.color3
theme.bg_minimize = x.trans40
theme.bg_systray = x.color0
theme.fg_normal = x.fg
theme.fg_focus = x.color5
theme.fg_urgent = x.color3
theme.fg_minimize = x.color8

-- hotkeys
theme.hotkeys_bg = x.bg
theme.hotkeys_fg = x.fg
theme.hotkeys_border_width = dpi(5)
theme.hotkeys_modifiers_fg = x.color1
theme.hotkeys_group_margin = dpi(15)

-- taglist
local taglist_square_size = dpi(0)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
                                taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
                                  taglist_square_size, theme.fg_normal)
theme.taglist_fg_empty = x.color8
theme.taglist_fg_occupied = x.fg
theme.taglist_fg_urgent = x.color11
theme.taglist_fg_focus = x.color1
theme.taglist_bg_empty = x.trans
theme.taglist_bg_occupied = x.trans
theme.taglist_bg_urgent = x.trans
theme.taglist_bg_focus = x.trans

-- tasklist
theme.tasklist_fg_focus = x.fg
theme.tasklist_bg_focus = x.color0
theme.tasklist_fg_urgent = x.color3
theme.tasklist_fg_normal = x.color8

theme = theme_assets.recolor_layout(theme, x.fg)
theme.useless_gap = dpi(10)
theme.gap_single_client = true

--border
theme.border_width = dpi(0)
theme.border_normal = x.color8
theme.border_focus = x.color9
theme.border_radius = dpi(30)

theme.client_radius = dpi(30)
theme.popup_radius = dpi(10)

-- bling mstab
theme.mstab_bar_height = dpi(25)
theme.mstab_bar_padding = dpi(10)
theme.mstab_tabbar_orientation = "top"
theme.mstab_border_radius = dpi(10)

-- bling tabbar
theme.tabbar_style = "modern"
theme.tabbar_size = dpi(30)
theme.tabbar_bg_focus = x.bg
theme.tabbar_bg_normal = x.color0
theme.tabbed_spawn_in_tab = true
theme.tabbar_radius = dpi(3)

-- popup
theme.popup_bg = x.color0 .. "B3" -- 70% transparent

-- titlebar
theme.titlebar_size = dpi(30)
-- position
theme.titlebar_position = "top"
-- title
theme.titlebar_title_enabled = "true"
theme.titlebar_title_align = "center"
-- buttons
-- 
theme.titlebar_close_button = ""
theme.titlebar_floating_button = ""
theme.titlebar_full_button = ""
-- color of icons
theme.titlebar_close_color = x.color1
theme.titlebar_floating_color = x.color3
theme.titlebar_full_color = x.color5

-- exit screen
theme.exit_screen_bg = x.bg .. "BF" -- 70% opaque
theme.exit_screen_fg = x.fg

-- lock screen
theme.lock_screen_bg = x.bg .. "BF" -- 70% opaque
theme.lock_screen_fg = x.fg
theme.lock_screen_password = "awesome"

-- screensot screen
theme.shot_screen_bg = x.bg .. "BF" -- 70% opaque
theme.shot_screen_fg = x.fg
theme.scr_whole_icon = ""
theme.scr_sel_icon = "濾"
theme.rec_sel_icon = "礪"

-- notifications
theme.notification_title = "System notification"
theme.notification_position = "top_middle"
theme.notification_icon_radius = dpi(10)
theme.notification_icon_size = dpi(50)
theme.notification_bg = x.color0
theme.notification_max_width = dpi(350)
theme.notification_max_height = dpi(180)
theme.notification_margin = dpi(10)
theme.notification_border_radius = dpi(5)
theme.notification_border_width = dpi(5)
theme.notification_border_color = x.color0
theme.notification_spacing = dpi(5)
theme.notification_padding = dpi(5)

-- border of volume and brightness notification popup
theme.noti_pop_border_color = x.color8
theme.noti_pop_border_width = dpi(5)
theme.bri_pop_icon = ""
theme.vol_pop_icon = ""

-- notification center
-- icons
-- if no icons given display this icon
-- theme.notification_icon = ""
theme.noti_center_noti_radius = dpi(10)

-- bar
-- notification icon on the bar
--      
theme.bar_noti_icon = ""
-- brightness icon on the bar
--    
theme.bar_bri_icon = ""
-- radius of the widgets
theme.bar_radius = dpi(7)
-- height of the bar
theme.wibar_height = dpi(35)
-- spacing between systray icons
theme.systray_icon_spacing = dpi(8)
-- size of systray icons
theme.systray_icon_size = dpi(20)

return theme
