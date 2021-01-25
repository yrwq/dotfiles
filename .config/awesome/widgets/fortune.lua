local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")
local fortune_command = "fortune -n 50 -s"
local fortune_update_interval = 360
-- local fortune_command = "fortune -n 140 -s computers"
local fortune = wibox.widget {
    text = "Loading your cookie...",
    align = "center",
    valign = "center",
    font = beautiful.nfont .. "10",
    widget = wibox.widget.textbox
}

local update_fortune = function()
    awful.spawn.easy_async_with_shell(fortune_command, function(out)
        -- Remove trailing whitespaces
        out = out:gsub('^%s*(.-)%s*$', '%1')
        fortune.markup = "<i>"..helpers.colorize_text(out, x.color3).."</i>"
    end)
end

gears.timer {
    autostart = true,
    timeout = fortune_update_interval,
    single_shot = false,
    call_now = true,
    callback = update_fortune
}

local fortune_widget = wibox.widget {
    {
        nil,
        fortune,
        layout = wibox.layout.align.horizontal,
    },
    margins = 4,
    color = "#00000000",
    widget = wibox.container.margin
}

fortune_widget:connect_signal("button::press", update_fortune)

return fortune_widget
