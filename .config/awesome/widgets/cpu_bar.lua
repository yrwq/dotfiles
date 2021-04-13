local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local total_prev = 0
local idle_prev = 0

local slider = wibox.widget {
    nil,
    {
        id               = "cpu_usage",
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
    [[bash -c "
    cat /proc/stat | grep '^cpu '
    "]],
    10,
    function(_, stdout)
        local user, nice, system, idle, iowait, irq, softirq, steal, guest, guest_nice =
        stdout:match("(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s(%d+)%s")
        local total = user + nice + system + idle + iowait + irq + softirq + steal
        local diff_idle = idle - idle_prev
        local diff_total = total - total_prev
        local diff_usage = (1000 * (diff_total - diff_idle) / diff_total + 5) / 10
        slider.cpu_usage:set_value(diff_usage)
        total_prev = total
        idle_prev = idle
        collectgarbage("collect")
    end
)

local cpu_meter = wibox.widget {
    {
        {
            {
                {
                    {
                        markup = "",
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

return cpu_meter
