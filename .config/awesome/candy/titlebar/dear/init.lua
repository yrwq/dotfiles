local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local titlebar = require("candy.titlebar")
local helpers = require("helpers")
local keys = require("keys")

local gen_button_size = dpi(12)
local gen_button_margin = dpi(8)
local gen_button_color_unfocused = x.color8
local gen_button_shape = gears.shape.circle


client.connect_signal("request::titlebars", function(c)
    awful.titlebar(c, {font = beautiful.nfont .. "20", position = "top", size = dpi(40)}) : setup {
        nil,
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
            titlebar.button(c, gen_button_shape, x.color3, gen_button_color_unfocused, x.color2 .. "90", gen_button_size, gen_button_margin, "minimize"),
            titlebar.button(c, gen_button_shape, x.color2, gen_button_color_unfocused, x.color2 .. "90", gen_button_size, gen_button_margin, "maximize"),
            titlebar.button(c, gen_button_shape, x.color1, gen_button_color_unfocused, x.color1 .. "90", gen_button_size, gen_button_margin, "close"),

            -- Create some extra padding at the edge
            helpers.horizontal_pad(gen_button_margin / 2),

            layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal
    }
end)
