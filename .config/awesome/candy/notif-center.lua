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

local mouseInPopup = false
local timer = gears.timer {
    timeout = 0.75,
    single_shot = true,
    callback = function()
        if not mouseInPopup then
            pop_anim:set(screen_width + width)
        end
    end
}

notifcenter_show = function()
    notif_popup.visible = true
    pop_anim:set(screen_width - offset - width)
end

notif_popup:connect_signal("mouse::leave", function()
    if notif_popup.visible then
        mouseInPopup = false
        timer:again()
    end
end)

notif_popup:connect_signal("mouse::enter", function() mouseInPopup = true end)

return notif_popup
