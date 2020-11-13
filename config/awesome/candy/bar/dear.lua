-- require
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")
local keys = require("keys")

-- helper function to create buttons
local create_button = function (symbol, color, bg_color, hover_color)
    local widget = wibox.widget {
        font = "RobotoMono Nerd Font Mono 14",
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

-- systray
local mysystray = wibox.widget.systray()
mysystray:set_base_size(20)

local mysystray_container = {
    mysystray,
    left = dpi(8),
    right = dpi(8),
    top = dpi(5),
    screen = 1,
    widget = wibox.container.margin
}

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

-- create apple button
local apple = create_button("󰀵", x.fg, x.trans, x.color8)

apple:buttons(gears.table.join(
                  awful.button({  }, 1, function()
                          app_drawer_show()
                  end),
                  awful.button({  }, 1, function()
                          exit_screen_show()
                  end)
))

-- create settings button
local settingsPop = require('candy.panel.settings')
local settings = create_button("漣", x.fg, x.trans, x.color8)

settings:connect_signal("mouse::enter", function()
    st = settings:get_all_children()[1]
    st.markup = helpers.colorize_text("漣", x.color15)
end)

settings:connect_signal("mouse::leave", function()
    st = settings:get_all_children()[1]
    st.markup = helpers.colorize_text("漣", x.fg)
end)

settings:buttons(gears.table.join(
    awful.button({ }, 1, function ()
            settingsPop.visible = not settingsPop.visible
    end),
    awful.button({ }, 3, function()
            settingsPop.visible = not settingsPop.visible
    end)
))

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

local mytextclock = awful.widget.textclock()
awful.screen.connect_for_each_screen(function(s)

        -- create tasklist
        s.mytasklist = awful.widget.tasklist {
            screen   = s,
            filter   = awful.widget.tasklist.filter.currenttags,
            style    = {
                font = beautiful.font,
                bg = x.color0,
            },
            layout   = {
                -- spacing = dpi(10),
                layout  = wibox.layout.flex.horizontal
            },
            widget_template = {
            {
                {
                    id     = 'text_role',
                    align  = "center",
                    widget = wibox.widget.textbox,
                },
                forced_width = dpi(220),
                left = dpi(15),
                right = dpi(15),
                -- Add margins to top and bottom in order to force the
                -- text to be on a single line, if needed. Might need
                -- to adjust them according to font size.
                top  = dpi(4),
                bottom = dpi(4),
                widget = wibox.container.margin
            },
            -- shape = helpers.rrect(dpi(8)),
            -- border_width = dpi(2),
            id = "bg_role",
            -- id = "background_role",
            -- shape = gears.shape.rounded_bar,
            widget = wibox.container.background,
            },
        }

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
                height = dpi(30)
        })

        -- add widgets to wibox
        s.mywibox:setup{
        layout = wibox.layout.align.horizontal,
        expand = "none",

        -- left
        {
            apple,
            layout = wibox.layout.fixed.horizontal,
            {
                s.mytasklist,
                margins = dpi(5),
                widget = wibox.container.margin
            },
        },

        -- center
        {
            layout = wibox.layout.fixed.horizontal,
            {
                {
                    s.mytaglist,
                    shape = helpers.rrect(beautiful.border_radius),
                    bg = x.color0,
                    widget = wibox.container.background
                },
                margins = dpi(5),
                widget = wibox.container.margin
            },
        },

        -- right
        {
            microphone,
            volume,
            settings,
            mysystray_container,
            mytextclock,
            helpers.horizontal_pad(10),
            widget = wibox.container.margin,
            layout = wibox.layout.fixed.horizontal
        }
    }
end)
