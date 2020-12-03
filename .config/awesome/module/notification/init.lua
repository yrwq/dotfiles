local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local menubar = require("menubar")
local helpers = require("helpers")

local notifications = {}
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(100)
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = "System Notification"
naughty.config.defaults.margin = dpi(30)
naughty.config.defaults.border_width = 0
naughty.config.defaults.border_color = x.color1
naughty.config.defaults.position = "top_right"
naughty.config.defaults.shape = helpers.rrect(beautiful.bar_radius)

naughty.config.padding = dpi(4)
naughty.config.spacing = dpi(4)
naughty.config.icon_dirs = {
    "/usr/share/icons/Faenza-Cupertino", "/usr/share/pixmaps/"
}
naughty.config.icon_formats = {"png", "svg"}

-- Timeouts
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

-- volume
local notif
local timeout = 1.5
local first_time = true

awesome.connect_signal("shit::volume", function (percentage, muted)
    if first_time then
        first_time = false
    else
        if (client.focus and client.focus.class == "Pavucontrol") then
            -- Sidebar and Pavucontrol already show volume, so
            -- destroy notification if it exists
            if notif then
                notif:destroy()
            end
        else
            -- Send notification
            local message, icon
            if muted then
                message = "婢 muted"
            else
                message = "奔 " .. tostring(percentage)
            end

            notif = notifications.notify_dwim({ title = message,font = "Iosevka 20", timeout = timeout, app_name = "volume" }, notif)
        end
    end
end)

return notifications
