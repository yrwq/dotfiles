local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

local bg_normal = beautiful.tabbar_bg_normal or beautiful.bg_normal or "#ffffff"
local fg_normal = beautiful.tabbar_fg_normal or beautiful.fg_normal or "#000000"
local bg_focus  = beautiful.tabbar_bg_focus  or beautiful.bg_focus  or "#000000"
local fg_focus  = beautiful.tabbar_fg_focus  or beautiful.fg_focus  or "#ffffff"
local font      = beautiful.tabbar_font      or beautiful.font      or "Hack 15"
local size      = 40
local position  = beautiful.tabbar_position or "bottom"

local app_config = {
    ['St'] = { icon = ""},
    ['Brave-browser'] = { icon = ""},
    ['Sxiv'] = { icon = ""},
    ['Firefox'] = { icon = ""},
    ['firefox'] = { icon = ""},
    ['torrent'] = { icon = ""},
    ['mail'] = { icon = ""},
    ['tide'] = { icon = ""},
    ['lf'] = { icon = ""},
    ['Chromium-browser'] = { icon = ""},
    ['music'] = { icon = ""},
    ['mpv'] = { icon = ""},
    ['Pavucontrol'] = { icon = ""},
    ['Zathura'] = { icon = ""},
    ['weechat'] = { icon = ""},
    ['discord'] = { icon = "ﭮ"},
    ['news'] = { icon = ""},
    ['newsboat'] = { icon = ""},
    ['Thunar'] = { icon = "", color = x.color3 },
    ['Nemo'] = { icon = ""},
    ['files'] = { icon = ""},
    ['emacs'] = { icon = ""},
    ['Emacs'] = { icon = ""},
}

local default_icon = ""

local function create(c, focused_bool, buttons)

    local icon, title_visible

    if app_config[c.class] then
        icon = app_config[c.class].icon
        title_visible = app_config[c.class].title
    else
        icon = default_icon
        title_visible = true
    end

    local bg_temp = bg_normal
    local fg_temp = x.color15

    if focused_bool then
        bg_temp = bg_focus
        fg_temp = x.color5
    end

    local wid_temp = wibox.widget({
        {
            {
                {
                    markup = icon,
                    font = beautiful.ifont .. "20",
                    widget = wibox.widget.textbox,
                },
                left = dpi(8),
                right = dpi(8),
                bottom= dpi(8),
                top= dpi(8),
                spacing = dpi(8),
                widget = wibox.container.margin()
            },
            widget = wibox.container.place()
        },
        buttons = buttons,
        fg = fg_temp,
        bg = bg_temp,
        widget = wibox.container.background()
    })
    return wid_temp
end

local layout = wibox.layout.fixed.horizontal
if position == "left" or position == "right" then
    layout = wibox.layout.fixed.vertical
end

return {
    layout = layout,
    create = create,
    position = position,
    size = size,
    bg_normal = bg_normal,
    bg_focus  = bg_normal
}
