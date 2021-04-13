local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local slider = wibox.widget {
    nil,
    {
        id               = "hdd_usage",
        max_value        = 100,
        value            = 29,
        forced_height    = dpi(4),
        color            = x.fg,
        background_color = x.fg .. "55",
        shape            = gears.shape.rounded_rect,
        widget           = wibox.widget.progressbar
    },
    nil,
    expand = "none",
    layout = wibox.layout.align.vertical
}

awful.widget.watch(
    [[bash -c "df -h /home|grep '^/' | awk '{print $5}'"]],
    10,
    function(_, stdout)
        local space_consumed = stdout:match("(%d+)")
        slider.hdd_usage:set_value(tonumber(space_consumed))
        collectgarbage("collect")
    end
)


local harddrive_meter = wibox.widget {
    {
        {
            {
                {
                    {
                        markup = "",
                        font = beautiful.ifont .. "22",
                        widget = wibox.widget.textbox
                    },
                    top = dpi(12),
                    bottom = dpi(12),
                    widget = wibox.container.margin
                },
                slider,
                spacing = dpi(24),
                layout = wibox.layout.fixed.horizontal

            },
            left = dpi(24),
            right = dpi(24),
            forced_height = dpi(42),
            widget = wibox.container.margin
        },
        shape = helpers.rrect(dpi(5)),
        bg = x.color0,
        widget = wibox.container.background
    },
    left = dpi(10),
    right = dpi(10),
    widget = wibox.container.margin
}

return harddrive_meter
