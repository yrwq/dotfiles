-- This returns the "Wow, such empty." message.
local beautiful = require("beautiful")
local wibox = require('wibox')

local dpi = require('beautiful').xresources.apply_dpi

local empty_notifbox = wibox.widget {
    {
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(5),
        {
            expand = 'none',
            layout = wibox.layout.align.horizontal,
            nil,
            {
                markup = "",
                font = beautiful.ifont .. "40",
                widget = wibox.widget.textbox
            },
            nil
        },
        {
            markup = 'You have no notifs!',
            font = beautiful.nfont .. "10",
            align = 'center',
            valign = 'center',
            widget = wibox.widget.textbox
        }
    },
    margins = dpi(20),
    widget = wibox.container.margin

}

-- Make empty_notifbox center
local centered_empty_notifbox = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    expand = 'none',
    empty_notifbox
}

return centered_empty_notifbox
