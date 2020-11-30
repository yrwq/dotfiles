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

-- helper function to create progress bar
local function format_progress_bar(bar, icon)
    icon.forced_height = dpi(27)
    icon.forced_width = dpi(36)
    icon.resize = true
    bar.forced_width = dpi(150)
    bar.shape = gears.shape.rounded_bar
    bar.bar_shape = gears.shape.rounded_bar

    local w = wibox.widget {
        nil,
        {icon, bar, layout = wibox.layout.fixed.horizontal},
        expand = "none",
        layout = wibox.layout.align.horizontal
    }
    return w
end

-- helper function to create buttons
local create_button = function (symbol, color, bg_color, hover_color)
    local widget = wibox.widget {
        font = "Ioseva Nerd Font 14",
        align = "center",
        id = "text_role",
        valign = "center",
        markup = helpers.colorize_text(symbol, color),
        widget = wibox.widget.textbox()
    }

    local section = wibox.widget {
        widget,
        forced_width = dpi(40),
        bg = bg_color,
        shape = gears.shape.rounded_rect,
        widget = wibox.container.background
    }

    -- Hover animation
    section:connect_signal("button::press", function ()
        section.bg = hover_color
    end)
    section:connect_signal("button::release", function ()
        section.bg = bg_color
    end)

    return section
end

local volicon = wibox.widget.imagebox(nil)
local volume_bar = require("widgets.volume_bar")
local volbar = format_progress_bar(volume_bar, volicon)

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

-- create microphone button
local microphone_symbol = ""
local microphone_muted_color = x.color8
local microphone_unmuted_color = x.fg
local microphone = create_button(microphone_symbol, microphone_unmuted_color, x.trans, x.color8)

microphone:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        awful.spawn.with_shell("amixer -D pulse sset Capture toggle &> /dev/null")
    end)
))

awesome.connect_signal("shit::microphone", function(muted)
    local t = microphone:get_all_children()[1]
    if muted then
        t.markup = helpers.colorize_text(microphone_symbol, microphone_muted_color)
    else
        t.markup = helpers.colorize_text(microphone_symbol, microphone_unmuted_color)
    end
end)
-- create volume button
local volume_symbol = ""
local volume_muted_color = x.color8
local volume_unmuted_color = x.fg
local volume = create_button(volume_symbol, volume_unmuted_color, x.trans, x.color8)

volume:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        helpers.volume_control(0)
    end),
    awful.button({ }, 3, function()
        awful.spawn.with_shell("pavucontrol")
    end),
    awful.button({ }, 4, function ()
        helpers.volume_control(5)
    end),
    awful.button({ }, 5, function ()
        helpers.volume_control(-5)
    end)
))

awesome.connect_signal("shit::volume", function(_, muted)
    local t = volume:get_all_children()[1]
    if muted then
        t.markup = helpers.colorize_text(volume_symbol, volume_muted_color)
    else
        t.markup = helpers.colorize_text(volume_symbol, volume_unmuted_color)
    end
end)
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
        {
            layout = wibox.layout.fixed.horizontal,
            {
                {
                    s.mytaglist,
                    shape = helpers.rrect(beautiful.border_radius),
                    bg = x.transbg,
                    widget = wibox.container.background
                },
                top = 5,
                right = 5,
                left = 5,
                widget = wibox.container.margin
            },
        },

        {
            layout = wibox.layout.fixed.horizontal,
            {
                {
		    mytextclock,
                    shape = helpers.rrect(beautiful.border_radius),
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
        },

        {


            {
                {
                    {
			volume,
			microphone,
                        layout = wibox.layout.fixed.horizontal
                    },
                    shape = helpers.rrect(beautiful.border_radius),
                    bg = x.transbg,
                    widget = wibox.container.background
                },
                top = 5,
                right = 5,
                left = 5,
                widget = wibox.container.margin
            },

            helpers.horizontal_pad(0),
            {
                {
                    {
                        mysystray_container,
                        layout = wibox.container.margin
                    },
                    shape = helpers.rrect(beautiful.border_radius),
                    bg = x.transbg,
                    widget = wibox.container.background
                },
                top = 5,
                right = 5,
                left = 5,
                widget = wibox.container.margin
            },

            helpers.horizontal_pad(0),
            {
                {
                    {
		        volume_bar,
			right = 10,
			left = 10,
                        layout = wibox.container.margin
                    },
                    shape = helpers.rrect(beautiful.border_radius),
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
                    shape = helpers.rrect(beautiful.border_radius),
                    bg = x.color0,
                    widget = wibox.container.background
                },
                top = 5,
                right = 10,
                left = 10,
                widget = wibox.container.margin
            },

            layout = wibox.layout.fixed.horizontal
        }
    }
end)
