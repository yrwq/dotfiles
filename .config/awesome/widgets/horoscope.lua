local awful = require("awful")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local gears = require("gears")

local get_horoscope = "horoscope"

local horoscope = wibox.widget {
		widget = wibox.widget.textbox,
		font = "Iosevka Term 10",
		markup = "",
		color = x.fg,
}

local main_widget = wibox.widget {
	{
		horoscope,
		margins = dpi(20),
		widget = wibox.container.margin,
	},
	layout = wibox.layout.fixed.vertical,
}

local function update_horoscope()
	awful.spawn.easy_async(get_horoscope, function(stdout)
		local horoscp = stdout

		horoscope:set_markup_silently(horoscp)
		collectgarbage()
	end)
end

update_horoscope()


return main_widget
