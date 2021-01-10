local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi

local helpers = require("helpers")

local weather_fg = x.color1

local weather_heading = wibox.widget({
    align = "center",
    valign = "center",
    font = beautiful.nfont .. "15",
    markup = helpers.colorize_text("?", x.color4),
    widget = wibox.widget.textbox()
})

awesome.connect_signal("shit::weather", function(temp, wind, emoji)
    weather_heading.markup = helpers.colorize_text(
                                 emoji .. "  " .. tostring(temp) ..
                                     "°C in " .. beautiful.weather_city, x.color4)
end)

return weather_heading
