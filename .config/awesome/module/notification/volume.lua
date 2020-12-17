local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")

local width = dpi(200)
local height = dpi(200)
local screen = awful.screen.focused()

local active_color_1 = {
    type = 'linear',
    from = {0, 0},
    to = {200, 50}, -- replace with w,h later
    stops = {{0, x.color5}, {0.50, x.color6}}
}

-- create the volume_adjust component
local volume_adjust = wibox({
      screen = awful.screen.focused(),
      x = screen.geometry.width / 2 - width / 2,
      y = screen.geometry.height / 2 - height / 2,
      width = width,
      height = height,
      visible = false,
      ontop = true,
      bg = x.bg .. "00"
})

local volume_bar = wibox.widget {
   widget = wibox.widget.progressbar,
   shape = gears.shape.rounded_bar,
   bar_shape = gears.shape.rounded_bar,
   color = active_color_1,
   background_color = x.color8,
   max_value = 100,
   value = 0
}

local icon = wibox.widget {
   markup = "",
   font = "Iosevka Custom 65",
   widget = wibox.widget.textbox
}

volume_adjust:setup{
   {
      layout = wibox.layout.align.vertical,
      {
	 icon,
	 top = dpi(30),
	 left = dpi(65),
	 bottom = dpi(0),
	 widget = wibox.container.margin
      },
      {
	 volume_bar,
	 top = dpi(20),
	 left = dpi(25),
	 right = dpi(25),
	 bottom = dpi(30),
	 widget = wibox.container.margin
      }

   },
   shape = helpers.rrect(dpi(10)),
   bg = x.color0,
   border_width = dpi(10),
   border_color = x.color8,
   widget = wibox.container.background
}

local hide_volume_adjust = gears.timer {
    timeout = 3,
    autostart = true,
    callback = function() volume_adjust.visible = false end
}

awesome.connect_signal("shit::volume", function(volume, muted)
			  if muted then
			     volume_bar.value = 0
			  else
			     volume_bar.value = volume
			  end
			  -- make volume_adjust component visible
			  if volume_adjust.visible then
			     hide_volume_adjust:again()
			  else
			     volume_adjust.visible = true
			     hide_volume_adjust:start()
			  end
end)
