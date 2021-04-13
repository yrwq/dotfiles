local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

-- helper function to easily create buttons
local create_button = function(symbol, font, radius, color, hover, cmd)

    local icon = wibox.widget {
        markup = helpers.colorize_text(symbol, x.fg),
        align = "center",
        valign = "center",
        font = font,
        widget = wibox.widget.textbox
    }

    local cont = wibox.widget {
        {
            icon,
            top = dpi(5),
            bottom = dpi(5),
            right = dpi(10),
            left = dpi(10),
            widget = wibox.container.margin
        },
        shape = helpers.rrect(radius),
        bg = color,
        widget = wibox.container.background
    }

    -- Change cursor on hover
    helpers.add_hover_cursor(cont, "hand1")

    -- Adds mousebinds if cmd is provided
    if cmd then
        cont:buttons(gears.table.join(
            awful.button({ }, 1, function ()
                cmd()
                start_hide()
            end),
            awful.button({ }, 3, function ()
                cmd()
                start_hide()
            end)
        ))
    end

    cont:connect_signal("mouse::enter", function()
        cont.bg = hover
    end)

    cont:connect_signal("mouse::leave", function()
        cont.bg = color
    end)

    return cont
end

return create_button
