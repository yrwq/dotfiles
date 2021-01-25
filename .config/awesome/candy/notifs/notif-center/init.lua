local wibox = require('wibox')
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local notif_header = wibox.widget {
    markup = 'Notification Center',
    font = beautiful.nfont .. "12",
    align = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
}

local build = require("candy.notifs.notif-center.build-notifbox")

return wibox.widget {
    {
        notif_header,
        nil,
        require("candy.notifs.notif-center.clear-all"),
        expand = "none",
        spacing = dpi(10),
        layout = wibox.layout.align.horizontal
    },

    {
        build,
        layout = wibox.layout.fixed.vertical
    },

    spacing = dpi(10),
    layout = wibox.layout.fixed.vertical
}
