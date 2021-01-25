local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local button = require("widgets.button")
local helpers = require("helpers")
local dpi = require('beautiful').xresources.apply_dpi

local config_dir = gears.filesystem.get_configuration_dir()

-- helper function to create buttons
local create_button = function (symbol, color, hover_color)
    local widget = wibox.widget {
        font = beautiful.ifont .. "18",
        align = "center",
        id = "text_role",
        valign = "center",
        markup = helpers.colorize_text(symbol, color),
        widget = wibox.widget.textbox()
    }

    -- Press animation
    widget:connect_signal("mouse::enter", function ()
        widget.markup = helpers.colorize_text(symbol, hover_color)
    end)
    widget:connect_signal("mouse::leave", function ()
        widget.markup = helpers.colorize_text(symbol, color)
    end)

    return widget
end

local delete_button = create_button("", x.fg, x.color1)

delete_button:connect_signal("button::press", function()
    _G.reset_notifbox_layout()
end)

local delete_button_wrapped = wibox.widget {
    nil,
    {
        delete_button,
        widget = wibox.container.background,
        forced_height = dpi(24),
        forced_width = dpi(24)
    },
    nil,
    expand = 'none',
    layout = wibox.layout.align.vertical
}

return delete_button_wrapped
