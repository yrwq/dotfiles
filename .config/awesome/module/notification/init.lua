local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")

local notifications = {}

-- require("module.notification.volume")

naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(80)
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.title = "System Notification"
naughty.config.defaults.margin = dpi(20)
naughty.config.defaults.border_width = beautiful.widget_border_width
naughty.config.defaults.border_color = beautiful.widget_border_color
naughty.config.defaults.position = "top_middle"
naughty.config.defaults.shape = helpers.rrect(10)

naughty.config.padding = dpi(10)
naughty.config.spacing = dpi(5)

naughty.config.defaults.timeout = 5
naughty.config.presets.low.timeout = 5
naughty.config.presets.critical.timeout = 5

-- >> Notify DWIM (Do What I Mean):
-- Create or update notification automagically. Requires storing the
-- notification in a variable.
-- Example usage:
--     local my_notif = notifications.notify_dwim({ title = "hello", message = "there" }, my_notif)
--     -- After a while, use this to update or recreate the notification if it is expired / dismissed
--     my_notif = notifications.notify_dwim({ title = "good", message = "bye" }, my_notif)
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
