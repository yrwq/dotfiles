local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local ruled = require("ruled")

require("candy.notifs.brightness")
require("candy.notifs.volume")

naughty.config.defaults.icon_size = beautiful.notification_icon_size or dpi(100)
naughty.config.defaults.ontop = true
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 3
naughty.config.defaults.title = beautiful.notification_title or "System Notification"
naughty.config.defaults.margin = beautiful.notification_margin or dpi(20)
naughty.config.defaults.border_width = beautiful.notification_border_width or dpi(0)
naughty.config.defaults.border_color = beautiful.notification_border_color or x.bg
naughty.config.defaults.position = beautiful.notification_position or "top_middle"
naughty.config.padding = beautiful.notification_padding or dpi(10)
naughty.config.spacing = beautiful.notification_spacing or dpi(5)

naughty.config.icon_dirs = { "/usr/share/icons/Papirus-Dark/24x24/apps/", "/usr/share/pixmaps/"
}
naughty.config.icon_formats = {"png", "svg"}

-- Timeouts
naughty.config.presets.low.timeout = 3
naughty.config.presets.critical.timeout = 0

naughty.config.presets.normal = {
    font = beautiful.nfont .. "12",
    fg = x.fg,
    bg = x.color0
}

naughty.config.presets.low = {
    font = beautiful.nfont .. "12",
    fg = x.fg,
    bg = x.bg
}

naughty.config.presets.critical = {
    font = beautiful.nfont .. "12",
    fg = x.fg,
    bg = x.color8,
    timeout = 0
}

ruled.notification.connect_signal('request::rules', function()
    -- Add a red background for urgent notifications.
    ruled.notification.append_rule {
        rule       = { urgency = 'critical' },
        properties = { bg = x.color8, fg = x.fg, timeout = 3 }
    }

    -- Or green background for normal ones.
    ruled.notification.append_rule {
        rule       = { urgency = 'normal' },
        properties = { bg = x.color0, fg = x.fg, timeout = 3}
    }

    ruled.notification.append_rule {
        rule       = { urgency = 'low' },
        properties = { bg = x.bg, fg = x.fg, timeout = 3}
    }
end)

naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical
