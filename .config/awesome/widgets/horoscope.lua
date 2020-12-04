local awful = require("awful")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local gears = require("gears")

local get_today = "horoscope --today" -- this is a python script,
local get_tomorrow = "horoscope --tomorrow" -- this is a python script,

local header = wibox.widget {
	widget = wibox.widget.textbox,
	font = "Iosevka Nerd Font Mono 12:style=Bold",
	markup = "",
	color = x.fg,
}

local horoscope = wibox.widget {
	widget = wibox.widget.textbox,
	font = "Iosevka Term 10",
	markup = "",
	color = x.fg,
}

local main_widget = wibox.widget {
	{
		layout = wibox.layout.align.horizontal,
    	expand = "outside",
    	nil,
		{
			header,
			margins = dpi(20),
			widget = wibox.container.margin,
		},
	},
	{
		horoscope,
		left = dpi(20),
		bottom = dpi(20),
		right = dpi(20),
		widget = wibox.container.margin,
	},
	layout = wibox.layout.fixed.vertical,
}

local function update_horoscope()
	awful.spawn.easy_async(get_today, function(stdout)
		local horoscp = stdout
		header:set_markup_silently("Today's horoscope")
		horoscope:set_markup_silently(horoscp)
		collectgarbage()
	end)
end

local function update_to_tomorrow()
	awful.spawn.easy_async(get_tomorrow, function(stdout)
		local horoscp = stdout
		header:set_markup_silently("Tomorrow's horoscope")
		horoscope:set_markup_silently(horoscp)
		collectgarbage()
	end)
end

update_horoscope()

main_widget:buttons(gears.table.join(
    awful.button({ }, 1, function ()
		update_to_tomorrow()
    end),
    awful.button({ }, 3, function()
		update_horoscope()
    end)
))

return main_widget
