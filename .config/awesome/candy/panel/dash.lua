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

-- helper function to create buttons
local function create_button(symbol, color, hover_color)
    local icon = wibox.widget {
        markup = helpers.colorize_text(symbol, color),
        align = "center",
        valign = "center",
        font = "Iosevka Custom 20",
        forced_width = dpi(30),
        forced_height = dpi(30),
        widget = wibox.widget.textbox
    }

    -- Press "animation"
    icon:connect_signal("button::press", function(_, _, __, button)
        if button == 3 then
            icon.markup = helpers.colorize_text(symbol, hover_color.."55")
        end
    end)
    icon:connect_signal("button::release", function ()
        icon.markup = helpers.colorize_text(symbol, hover_color)
    end)

    -- Hover "animation"
    icon:connect_signal("mouse::enter", function ()
        icon.markup = helpers.colorize_text(symbol, hover_color)
    end)
    icon:connect_signal("mouse::leave", function ()
        icon.markup = helpers.colorize_text(symbol, color)
    end)

    -- Change cursor on hover
    helpers.add_hover_cursor(icon, "hand1")

    return icon
end
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

local m_next = create_button("怜", x.fg, x.color1)
local m_prev = create_button("玲", x.fg, x.color1)
local m_tog = create_button("", x.fg, x.color1)

m_next:connect_signal("button::press", function()
	awful.spawn.with_shell("mpc next")
end)

m_prev:connect_signal("button::press", function()
	awful.spawn.with_shell("mpc prev")
end)

m_tog:connect_signal("button::press", function()
	awful.spawn.with_shell("mpc toggle")
end)

local control_line = wibox.widget {
	{
		m_prev,
		m_tog,
		m_next,
		layout = wibox.layout.align.horizontal
	},
	top = dpi(10),
	right = dpi(10),
	left = dpi(10),
	bottom = dpi(10),
	layout = wibox.container.margin
}

local control_box = create_boxed_widget(control_line, dpi(250), dpi(50), x.bg)

local cover_image = wibox.widget {
	resize = "false",
	clip_shape = helpers.rrect(border_radius),
	widget = wibox.widget.imagebox
}

local script = [[bash -c '
  art
  current=`mpc current`
  echo $current
']]


local cover_box = create_boxed_widget(cover_image, dpi(250), dpi(250), x.bg)
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
local mpd_box = create_boxed_widget(mpd, dpi(250), dpi(100), x.bg)
local mpd_area = {
    nil,
    {
        mpd_box,
        layout = wibox.container.margin
    },
    {
		control_box,
        layout = wibox.container.margin
    },
    nil,
    layout = wibox.layout.align.vertical
}

local fortune = require("widgets.fortune")
local fortune_box = create_boxed_widget(fortune, dpi(200), dpi(250), x.bg)
local fortune_area = {
	nil,
	{
		fortune_box,
		layout = wibox.container.margin
	},
	nil,
	layout = wibox.layout.align.vertical
}

local horoscope = require("widgets.horoscope")
local horoscope_box = create_boxed_widget(horoscope, dpi(200), dpi(250), x.bg)
local horoscope_area = {
	nil,
	{
		horoscope_box,
		layout = wibox.container.margin
	},
	nil,
	layout = wibox.layout.align.vertical
}

local panelWidget = wibox.widget {
	{
		cover_area,
		mpd_area,
    	layout = wibox.layout.align.vertical
	},
	{
		fortune_area,
		horoscope_area,
    	layout = wibox.layout.align.vertical
	},
    layout = wibox.layout.align.horizontal
}

local last_notification_id
local function send_notification(artist, title, icon)
    notification = naughty.notify({
        title = title,
        text = artist,
        icon = icon,
        timeout = 4,
        replaces_id = last_notification_id
    })
    last_notification_id = notification.id
end

local function update_image()
	awful.spawn.easy_async(script, function(stdout)
		local artist = stdout
		local title = " Currently playing"
		local cover_path = "/tmp/mpd_cover.jpg"

		cover_image:set_image(gears.surface.load_uncached(cover_path))
		-- send_notification(artist, title, cover_path)

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

local width = 800
local margin = 5

local settingsPop = popupLib.create(
	-- x
  	screen_width / 2 - width / 2 - margin / 2,
	-- y
	screen_height / 2 - 500 / 2 + margin / 2,
	-- height
  	widget_height,
	-- width
	width,
	-- widget
  	panelWidget)

return settingsPop
