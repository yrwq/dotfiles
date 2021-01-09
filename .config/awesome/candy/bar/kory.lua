local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

-- helper function to create progress bar
local function format_progress_bar(bar, icon)
    icon.resize = true
    bar.forced_width = dpi(100)
    bar.shape = gears.shape.rounded_bar
    bar.bar_shape = gears.shape.rounded_bar
    bar.visible = false

    local w = wibox.widget {
        nil,
        {
            icon,
            bar,
            layout = wibox.layout.fixed.horizontal
        },
        expand = "none",
        layout = wibox.layout.align.horizontal
    }
    return w
end

-- helper function to create buttons
local create_button = function (symbol, color, bg_color, hover_color)
    local widget = wibox.widget {
        font = beautiful.ifont .. "16",
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

    -- Press animation
    section:connect_signal("button::press", function ()
        section.bg = hover_color
    end)
    section:connect_signal("button::release", function ()
        section.bg = bg_color
    end)

    return section
end

-- clock
local mytextclock = awful.widget.textclock(s)
local calPop = require("candy.calendar")
-- show a calendar when hovering on the clock
mytextclock:connect_signal("mouse::enter", function()
    calPop.visible = true end)
mytextclock:connect_signal("mouse::leave", function()
    calPop.visible = false end)

-- brightness
local brightness_bar = require("widgets.bri_bar")
local bri_icon = wibox.widget {
    markup = beautiful.bar_bri_icon or "",
    font = beautiful.ifont .. "16",
    widget = wibox.widget.textbox
}
local brightness = format_progress_bar(brightness_bar, bri_icon)
brightness:connect_signal("mouse::enter", function()
    bri_icon.visible = false
    brightness_bar.visible = true
end)
brightness:connect_signal("mouse::leave", function()
    bri_icon.visible = true
    brightness_bar.visible = false
end)

-- volume
-- icon
local volume_symbol = ""
local volume_muted_symbol = "ﳌ"
local volume_muted_color = x.color8
local volume_unmuted_color = x.fg
local vol_icon = create_button(volume_symbol, volume_unmuted_color, x.trans, x.color8)
-- bar
local volume_bar = require("widgets.volume_bar")
local volume = format_progress_bar(volume_bar, vol_icon)
-- show bar on hover
volume:connect_signal("mouse::enter", function()
    vol_icon.visible = false
    volume_bar.visible = true
end)
volume:connect_signal("mouse::leave", function()
    vol_icon.visible = true
    volume_bar.visible = false
end)
-- volume controls with mouse
volume:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        helpers.volume_control(0)
    end),
    awful.button({ }, 3, function()
        awful.spawn.with_shell(apps.volume)
    end),
    awful.button({ }, 4, function ()
        helpers.volume_control(5)
    end),
    awful.button({ }, 5, function ()
        helpers.volume_control(-5)
    end)
))
awesome.connect_signal("shit::volume", function(_, muted)
    local t = vol_icon:get_all_children()[1]
    if muted then
        t.markup = helpers.colorize_text(volume_muted_symbol, volume_muted_color)
    else
        t.markup = helpers.colorize_text(volume_symbol, volume_unmuted_color)
    end
end)

-- microphone
local microphone_symbol = ""
local microphone_muted_symbol = ""
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
        t.markup = helpers.colorize_text(microphone_muted_symbol, microphone_muted_color)
    else
        t.markup = helpers.colorize_text(microphone_symbol, microphone_unmuted_color)
    end
end)

-- systray
local mysystray = wibox.widget.systray()
mysystray:set_base_size(beautiful.systray_icon_size)

local mysystray_container = {
    mysystray,
    left = dpi(8),
    right = dpi(8),
    screen = 1,
    widget = wibox.container.margin
}

-- notification center
local notifPop = require("candy.notif-pop")
local notif_icon = wibox.widget {
    markup = beautiful.bar_noti_icon,
    font = beautiful.ifont .. "16",
    widget = wibox.widget.textbox
}
notif_icon:connect_signal("mouse::enter", function()
    notifPop.visible = true
end)

local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),

    awful.button({modkey}, 1, function(t) if
        client.focus then client.focus:move_to_tag(t) end
    end),

    awful.button({}, 3, awful.tag.viewtoggle),

    awful.button({modkey}, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
    end),

    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),

    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end))

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end),

    awful.button({}, 3, function() awful.menu.client_list({theme = {width = 250}}) end),
    awful.button({}, 4, function() awful.client.focus.byidx(1) end),
    awful.button({}, 5, function() awful.client.focus.byidx(-1) end))


awful.screen.connect_for_each_screen(function(s)
    -- Create layoutbox widget
    s.mylayoutbox = awful.widget.layoutbox(s)

    if s.index == 1 then
        mysystray_container.visible = true
    else
        mysystray_container.visible = false
    end

    s.mywibox = awful.wibar({position = "top", screen = s, ontop = true, visible = true})

    -- Create a taglist widget
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
                top = 1,
                widget = wibox.container.margin
            },
            id = 'background_role',
            widget = wibox.container.background
        },
        buttons = taglist_buttons
    }


    s.mytasklist = awful.widget.tasklist {
      screen = s,
      filter = awful.widget.tasklist.filter.currenttags,
      buttons = tasklist_buttons,
      style = {bg = x.transbg, shape = helpers.rrect(beautiful.bar_widget_radius)},
      layout = {spacing = 10, layout = wibox.layout.flex.horizontal},
      widget_template = {
        {
          {
            {id = 'text_role',align = "center", widget = wibox.widget.textbox},
            layout = wibox.layout.flex.horizontal
          },
          forced_width = dpi(150),
          left = dpi(12),
          right = dpi(12),
          widget = wibox.container.margin
        },
        id = 'background_role',
        widget = wibox.container.background
      }
    }

    -- Add widgets to the wibox
    s.mywibox:setup{
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {
          layout = wibox.layout.fixed.horizontal,
          {
            {
              s.mytaglist,
              shape = helpers.rrect(beautiful.bar_widget_radius),
              bg = x.color0,
              widget = wibox.container.background
            },
            top = 4,
            bottom = 4,
            right = 5,
            left = 5,
            widget = wibox.container.margin
          },

          {
            {
              s.mytasklist,
              top = 4,
              bottom = 4,
              right = 5,
              left = 5,
              widget = wibox.container.margin
            },
            layout = wibox.layout.flex.horizontal
          },
        },

        {
            {
                {
                    mytextclock,
                    bg = x.color0,
                    shape = helpers.rrect(beautiful.bar_widget_radius),
                    widget = wibox.widget.background
                },
                top = dpi(4),
                bottom = dpi(4),
                right = dpi(7),
                left = dpi(7),
                widget = wibox.container.margin
            },
            right = 5,
            left = 5,
            widget = wibox.container.margin
        },

        {
            {
                {
                    {
                        {
                            microphone,
                            volume,
                            layout = wibox.layout.fixed.horizontal
                        },
                        top = dpi(2),
                        right = dpi(6),
                        layout = wibox.container.margin
                    },
                    bg = x.color0,
                    shape = helpers.rrect(beautiful.bar_widget_radius),
                    widget = wibox.container.background
                },
                top = 4,
                bottom = 4,
                right = 5,
                left = 5,
                widget = wibox.container.margin
            },
            {
                {
                    {
                        mysystray_container,
                        top = dpi(4),
                        layout = wibox.container.margin
                    },
                    bg = x.color0,
                    shape = helpers.rrect(beautiful.bar_widget_radius),
                    widget = wibox.container.background
                },
                top = 4,
                bottom = 4,
                right = 5,
                left = 5,
                widget = wibox.container.margin
            },
            {
                {
                    {
                        s.mylayoutbox,
                        top = dpi(6),
                        bottom = dpi(6),
                        right = dpi(7),
                        left = dpi(7),
                        widget = wibox.container.margin
                    },
                    bg = x.color0,
                    shape = helpers.rrect(beautiful.bar_widget_radius),
                    widget = wibox.container.background
                },
                top = 4,
                bottom = 4,
                right = 5,
                left = 5,
                widget = wibox.container.margin
            },
            {
                {
                    {
                        notif_icon,
                        top = dpi(6),
                        bottom = dpi(6),
                        right = dpi(7),
                        left = dpi(7),
                        widget = wibox.container.margin
                    },
                    bg = x.color0,
                    shape = helpers.rrect(beautiful.bar_widget_radius),
                    widget = wibox.container.background
                },
                top = 4,
                bottom = 4,
                right = 5,
                left = 5,
                widget = wibox.container.margin
            },
            layout = wibox.layout.fixed.horizontal
        }
    }
end)

-- local function no_wibar_visble(c)
--    local s = awful.screen.focused()
--    s.mywibox.visible = not s.mywibox.visible
-- end

-- local function no_wibar(c)
--    local s = awful.screen.focused()
--    s.mywibox.visible = not s.mywibox.visible
-- end

-- client.connect_signal("focus", no_wibar_visble)
-- client.connect_signal("unfocus", no_wibar_visble)
-- client.connect_signal("property::fullscreen", no_wibar)
--
client.connect_signal("property::fullscreen", function(c)
   local s = awful.screen.focused()
    if c.fullscreen then
        s.mywibox.visible = false
    else
        if not c.fullscreen then
            s.mywibox.visible = true
        end
    end
end)

-- Every bar theme should provide these fuctions
function wibars_toggle()
   local s = awful.screen.focused()
   s.mywibox.visible = not s.mywibox.visible
end
