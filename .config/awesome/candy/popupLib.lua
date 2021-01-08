local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = require('beautiful').xresources.apply_dpi
local helpers = require('helpers')

local popupLib = {}

popupLib.create = function(x, y, height, width, widget)
    local widgetContainer = wibox.widget {
        {widget, margins = dpi(10), widget = wibox.container.margin},
        forced_height = height,
        forced_width = width,
        layout = wibox.layout.fixed.vertical
    }

    local popupWidget = awful.popup {
    widget = {
        {
            {
                {
                    widgetContainer,
                    widget = wibox.container.margin
                },
                bg = beautiful.popup_bg,
                clip = true,
                widget = wibox.widget.background
            },
            layout = wibox.layout.fixed.vertical,
        },
        widget = wibox.container.margin
    },
    shape = helpers.rrect(beautiful.popup_radius),
    visible = false,
    ontop = true,
    x = x,
    y = y,
    }

    local mouseInPopup = false
    local timer = gears.timer {
        timeout = 1.25,
        single_shot = true,
        callback = function()
            if not mouseInPopup then popupWidget.visible = false end
        end
    }

    popupWidget:connect_signal("mouse::leave", function()
        if popupWidget.visible then
            mouseInPopup = false
            timer:again()
        end
    end)

    popupWidget:connect_signal("mouse::enter",
                               function() mouseInPopup = true end)

    return popupWidget
end

return popupLib
