local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local titlebar = require("candy.titlebar")
local helpers = require("helpers")
local keys = require("keys")

local button_size = dpi(12)
local button_margin = dpi(8)
local button_color_unfocused = x.color8

local close_button_shape = beautiful.titlebar_close_button or ""
local min_button_shape = beautiful.titlebar_min_button or ""
local max_button_shape = beautiful.titlebar_max_button or ""
local button_font = beautiful.ifont .. "20" or "Iosevka Nerd Font Mono 20"

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

client.connect_signal("request::titlebars", function(c)

    local icon, title_visible

    if app_config[c.class] then
        icon = app_config[c.class].icon
        title_visible = app_config[c.class].title
    else
        icon = default_icon
        title_visible = true
    end

    awful.titlebar(c, {font = beautiful.nfont .. "20", position = "top", size = dpi(40)}) : setup {
        {
            {
                markup = icon,
                font = beautiful.ifont .. "22",
                widget = wibox.widget.textbox
            },
            left = dpi(20),
            right = dpi(8),
            bottom= dpi(8),
            top= dpi(8),
            spacing = dpi(8),
            widget = wibox.container.margin()
        },
        {
            {
                buttons = keys.titlebar_buttons,
                font = beautiful.nfont .. "10",
                align = beautiful.titlebar_title_align or "center",
                widget = beautiful.titlebar_title_enabled and awful.titlebar.widget.titlewidget(c) or wibox.widget.textbox("")
            },
            forced_width = 50,
            widget = wibox.container.margin
        },
        {
            titlebar.text_button(c, min_button_shape, button_font, x.color3 .. "CC", button_color_unfocused, x.color3, button_size, button_margin, "minimize"),
            titlebar.text_button(c, max_button_shape, button_font, x.color2 .. "CC", button_color_unfocused, x.color2, button_size, button_margin, "maximize"),
            titlebar.text_button(c, close_button_shape, button_font, x.color1 .. "CC", button_color_unfocused, x.color1, button_size, button_margin, "close"),

            -- Create some extra padding at the edge
            helpers.horizontal_pad(button_margin),

            layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal
    }
end)
