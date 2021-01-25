local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local popupLib = require("candy.popupLib")

local popupWidget = wibox.widget {
    {
        require("candy.notifs.notif-center"),
        margins = dpi(8),
        widget = wibox.container.margin
    },
    expand = "none",
    layout = wibox.layout.fixed.horizontal
}

local width = 400
local margin = 10

local popup = popupLib.create(screen_width - width,
                              beautiful.wibar_height + 10,
                              screen_height / 2,
                              width - 10,
                              popupWidget,
                              dpi(25), false, false, false, true)
return popup
