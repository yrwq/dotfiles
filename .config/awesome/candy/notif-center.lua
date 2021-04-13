local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local awestore = require("awestore")

local width = 300
local height = 330
local offset = 60
local wbh = beautiful.wibar_height

local notif_center = require("widgets.notif_center")

--
-- popup
--

local notif_popup = awful.popup {
    widget = {
        notif_center,
        margins = dpi(20),
        widget  = wibox.container.margin
    },
    bg = x.color0,
    shape = helpers.rrect(dpi(5)),
    ontop = true,
    x = screen_width + width,
    y = wbh + (wbh / 2),
    visible = false
}

local pop_anim = awestore.tweened(screen_width + width, {
    duration = 300,
    easing = awestore.easing.cubic_in_out
})

pop_anim:subscribe(function(x) notif_popup.x = x end)

notifcenter_show = function()
    notif_popup.visible = true
    pop_anim:set(screen_width - offset - width)
end

notifcenter_hide = function()
    pop_anim:set(screen_width + offset + width + 1)
end

notif_popup:connect_signal("mouse::leave", function()
    if notif_popup.visible then
        notifcenter_hide()
    end
end)

return notif_popup
