local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

client.connect_signal("request::titlebars", function(c)

    awful.titlebar(c, {font = beautiful.nfont .. "20", position = "top", size = dpi(30)}) : setup {

        -- left
        {

            layout  = wibox.layout.fixed.horizontal
        },

        -- middle
        {
            {
                align  = "center",
                valign  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            layout  = wibox.layout.flex.horizontal
        },

        -- right
        {
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)
