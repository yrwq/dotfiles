local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local button = require("widgets.button")
local notifbox = {}

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


notifbox.create = function(icon, title, message, width)
    local time = os.date("%H:%M")
    local box = {}

    local dismiss = create_button("", x.fg, x.color1)

    dismiss:connect_signal("button::press", function()
        _G.remove_notifbox(box)
    end)

    dismiss.forced_height = dpi(24)
    dismiss.forced_width = dpi(24)

    local img_icon = wibox.widget {
        image = icon,
        forced_width = dpi(40),
        forced_height = dpi(40),
        resize = true,
        clip_shape = function(cr)
            gears.shape.rounded_rect(cr, dpi(35), dpi(35), dpi(6))
        end,
        widget = wibox.widget.imagebox
    }

    local center1 = wibox.container.margin(img_icon, 20, 0, 14, 0)

    box = wibox.widget {
        {
            center1,
            {
                {
                    nil,
                    {
                        {
                            font = beautiful.nfont .. "8",
                            markup = title,
                            widget = wibox.widget.textbox
                        },
                        {
                            font = beautiful.ifont .. "8",
                            markup = message,
                            widget = wibox.widget.textbox
                        },
                        layout = wibox.layout.fixed.vertical
                    },
                    expand = "none",
                    layout = wibox.layout.align.vertical
                },
                left = dpi(20),
                bottom = dpi(0),
                widget = wibox.container.margin
            },
            {
                {
                    {
                        font = beautiful.ifont .. "8",
                        markup = time,
                        widget = wibox.widget.textbox
                    },
                    {
                        dismiss,
                        expand = "none",
                        layout = wibox.layout.align.horizontal
                    },
                    spacing = dpi(5),
                    layout = wibox.layout.fixed.vertical
                },
                margins = dpi(10),
                widget = wibox.container.margin
            },
            spacing = dpi(20),
            layout = wibox.layout.align.horizontal
        },
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, beautiful.noti_center_noti_radius)
        end,
        bg = x.color8 .. "80",
        forced_width = width,
        widget = wibox.container.background,
    }

    return box
end

return notifbox
