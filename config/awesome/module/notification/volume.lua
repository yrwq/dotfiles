local naughty = require("naughty")
local icons = require("icons")
icons.init("dear")
local notif
local timeout = 1.5
local first_time = true

local notifications = require("module.notification")

awesome.connect_signal("shit::volume", function (percentage, muted)
    if first_time then
        first_time = false
    else
        if (sidebar and sidebar.visible) or (client.focus and client.focus.class == "Pavucontrol") then
            -- Sidebar and Pavucontrol already show volume, so
            -- destroy notification if it exists
            if notif then
                notif:destroy()
            end
        else
            -- Send notification
            local message, icon
            if muted then
              message = "muted"
              icon = icons.volume
            else
                message = tostring(percentage)
              icon = icons.volume
            end

            notif = notifications.notify_dwim({ title = "Volume", message = message, icon = icon, timeout = timeout, app_name = "volume" }, notif)
        end
    end
end)

