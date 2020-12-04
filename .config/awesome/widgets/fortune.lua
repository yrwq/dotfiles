local awful = require("awful")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local gears = require("gears")

local get_fortune = "fortune"

local fortune = wibox.widget {
		widget = wibox.widget.textbox,
		font = "Iosevka Term 10",
		markup = "",
		color = x.fg,
}

local main_widget = wibox.widget {
	{
		fortune,
		margins = dpi(20),
		widget = wibox.container.margin,
	},
	layout = wibox.layout.align.vertical,
}

local function update_fortune()
	awful.spawn.easy_async(get_fortune, function(stdout)
		local fort = stdout

		fortune:set_markup_silently(fort)
		collectgarbage()
	end)
end

update_fortune()

main_widget:connect_signal("button::press", function()
	update_fortune()
end)

return main_widget
