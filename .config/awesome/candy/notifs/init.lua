local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi
local menubar = require("menubar")
local helpers = require("helpers")
local ruled = require("ruled")

local notifications = {}

naughty.config.defaults.icon_size = dpi(100)
naughty.config.defaults.ontop = true
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = beautiful.notification_title or "System Notification"

naughty.config.defaults.border_color = x.bg
naughty.config.defaults.border_width = dpi(0)

naughty.config.defaults.position = beautiful.notification_position or "top_middle"
naughty.config.padding = dpi(0)
naughty.config.spacing = dpi(0)
naughty.config.defaults.margin = dpi(0)

naughty.config.presets.low.timeout = 5
naughty.config.presets.critical.timeout = 0

naughty.config.presets.normal = {
    timeout = 5,
    font = beautiful.nfont .. "12",
    fg = x.fg,
    bg = x.color0
}

naughty.config.presets.low = {
    timeout = 5,
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
        properties = { bg = x.color8, fg = x.fg, timeout = 5 }
    }

    -- Or green background for normal ones.
    ruled.notification.append_rule {
        rule       = { urgency = 'normal' },
        properties = { bg = x.color0, fg = x.fg, timeout = 5}
    }

    ruled.notification.append_rule {
        rule       = { urgency = 'low' },
        properties = { bg = x.bg, fg = x.fg, timeout = 5}
    }
end)

naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical

function notifications.notify_dwim(args, notif)
    local n = notif
    if n and not n._private.is_destroyed and not n.is_expired then
        notif.title = args.title or notif.title
        notif.message = args.message or notif.message
        -- notif.text = args.text or notif.text
        notif.icon = args.icon or notif.icon
        notif.timeout = args.timeout or notif.timeout
    else
        n = naughty.notification(args)
    end
    return n
end

function notifications.init(theme_name)

    require("candy.notifs.brightness")
    require("candy.notifs.desktop_brightness")
    require("candy.notifs.volume")

    -- Load theme
    require("candy.notifs." .. theme_name)
end


-- Handle notification icon
naughty.connect_signal("request::icon", function(n, context, hints)
    -- Handle other contexts here
    if context ~= "app_icon" then return end

    -- Use XDG icon
    local path = menubar.utils.lookup_icon(hints.app_icon) or
    menubar.utils.lookup_icon(hints.app_icon:lower())

    if path then
        n.icon = path
    end
end)

-- Use XDG icon
naughty.connect_signal("request::action_icon", function(a, context, hints)
    a.icon = menubar.utils.lookup_icon(hints.id)
end)

return notifications
