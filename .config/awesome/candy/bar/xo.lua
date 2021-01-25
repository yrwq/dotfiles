local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")
local keys = require("keys")

local mysystray = wibox.widget.systray()
mysystray:set_base_size(15)

-- systray
local mysystray_container = {
   mysystray,
   left = dpi(10),
   right = dpi(10),
   top = dpi(8),
   screen = 1,
   bg = x.trans,
   widget = wibox.container.margin
}

local mytextclock = awful.widget.textclock()

awful.screen.connect_for_each_screen(function(s)
      
      -- create taglist
      s.mytaglist = awful.widget.taglist {
	 screen = s,
	 filter = awful.widget.taglist.filter.all,
	 style = {shape = gears.shape.rectangle},
	 layout = {spacing = 0, layout = wibox.layout.fixed.horizontal},
	 widget_template = {
	    {
	       {
		  {id = 'text_role', widget = wibox.widget.textbox},
		  layout = wibox.layout.fixed.horizontal
	       },
	       left = 11,
	       right = 11,
	       widget = wibox.container.margin
	    },
	    id = 'background_role',
	    widget = wibox.container.background
	 },
	 buttons = taglist_buttons
      }
      
      -- create wibox
      s.mywibox = awful.wibar({
	    position = "top",
	    screen = s,
	    ontop = true,
	    bg = x.trans,
	    height = dpi(35)
      })
      
      s.mylayoutbox = awful.widget.layoutbox
      
      s.mywibox:setup{
	 layout = wibox.layout.align.horizontal,
	 expand = "none",

	 -- left
	 {
            layout = wibox.layout.fixed.horizontal,
	 },

	 -- center
	 {
	    
            {
	       {
		  s.mytaglist,
		  shape = helpers.rrect(beautiful.bar_radius),
		  right = 8,
		  left = 8,
		  bg = x.transbg,
		  widget = wibox.container.background
	       },
	       top = 5,
	       right = 8,
	       left = 8,
	       widget = wibox.container.margin
            },
	    
            helpers.horizontal_pad(0),
            {
	       {
		  {
		     mysystray_container,
		     layout = wibox.container.margin
		  },
		  shape = helpers.rrect(beautiful.bar_radius),
		  bg = x.transbg,
		  widget = wibox.container.background
	       },
	       top = 5,
	       right = 5,
	       left = 5,
	       widget = wibox.container.margin
            },
	    
            {
	       {
		  {
		     s.mylayoutbox,
		     margins = dpi(6),
		     widget = wibox.container.margin
		  },
		  shape = helpers.rrect(beautiful.bar_radius),
		  bg = x.transbg,
		  widget = wibox.container.background
	       },
	       top = 5,
	       right = 10,
	       left = 10,
	       widget = wibox.container.margin
            },
	    
            {
	       {
		  mytextclock,
		  shape = helpers.rrect(beautiful.bar_radius),
		  right = 8,
		  left = 8,
		  bg = x.transbg,
		  widget = wibox.container.background
	       },
	       top = 5,
	       right = 8,
	       left = 8,
	       widget = wibox.container.margin
            },

            layout = wibox.layout.fixed.horizontal
	 },

	 -- right
	 {
            layout = wibox.layout.fixed.horizontal
	 }
      }
end)

local function no_wibar_visble(c)
   local s = awful.screen.focused()
   s.mywibox.visible = not s.mywibox.visible
end

local function no_wibar(c)
   local s = awful.screen.focused()
   s.mywibox.visible = false
end

client.connect_signal("focus", no_wibar_visble)
client.connect_signal("unfocus", no_wibar_visble)
client.connect_signal("property::fullscreen", no_wibar)

-- Every bar theme should provide these fuctions
function wibars_toggle()
   local s = awful.screen.focused()
   s.mywibox.visible = not s.mywibox.visible
end
