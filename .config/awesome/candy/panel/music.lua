local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local naughty = require("naughty")
local helpers = require("helpers")
local apps = require("apps")
local popupLib = require("candy.popupLib")
local box_radius = beautiful.border_radius
local box_gap = dpi(6)

-- helper function to create boxes
local function create_boxed_widget(widget_to_be_boxed, width, height, bg_color)
    local box_container = wibox.container.background()
    box_container.bg = bg_color
    box_container.forced_height = height
    box_container.forced_width = width
    box_container.shape = helpers.rrect(box_radius)

    local boxed_widget = wibox.widget {
        {
            {
                nil,
                {
                    nil,
                    widget_to_be_boxed,
                    layout = wibox.layout.align.vertical,
                    expand = "none"
                },
                layout = wibox.layout.align.horizontal
            },
            widget = box_container
        },
        margins = box_gap,
        color = "#FF000000",
        widget = wibox.container.margin
    }
    return boxed_widget
end

local cover_image = wibox.widget {
	resize = "true",
	clip_shape = helpers.rrect(border_radius),
	widget = wibox.widget.imagebox
}

local script = [[bash -c '
  art
']]


local cover_box = create_boxed_widget(cover_image, dpi(200), dpi(300), x.transbg)
local cover_area = {
	nil,
	{
		cover_box,
		layout = wibox.container.margin
	},
	nil,
	layout = wibox.layout.align.horizontal
}

local mpd = require("widgets.mpd")
local mpd_box = create_boxed_widget(mpd, dpi(200), dpi(100), "#2e2e2e")
local mpd_area = {
    nil,
    {
        mpd_box,
        layout = wibox.container.margin
    },
    nil,
    layout = wibox.layout.align.horizontal
}

local panelWidget = wibox.widget {
	cover_area,
	mpd_area,
	valign = center,
	align = center,
    layout = wibox.layout.align.vertical
}

local function update_image()
	awful.spawn.easy_async(script, function(stdout)
		local cover_path = "/tmp/mpd_cover.jpg"

		cover_image:set_image(gears.surface.load_uncached(cover_path))
		collectgarbage()
	end)
end

local mpd_change_event_listener = [[
sh -c '
mpc idleloop player
'
]]

awful.spawn.easy_async_with_shell(
	awful.spawn.with_line_callback(
		mpd_change_event_listener,
			{
				stdout = function(line)
					update_image()
				end
			}
		)
)

update_image()

local width = 400
local margin = 5

local settingsPop = popupLib.create(
	-- x
  	screen_width - width - margin,
	-- y
	beautiful.wibar_height + margin,
	-- height
  	widget_height,
	-- width
	width,
	-- widget
  	panelWidget)

return settingsPop
