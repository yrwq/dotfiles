local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

local function format_progress_bar(bar)
    bar.forced_width = dpi(100)
    bar.shape = gears.shape.rounded_bar
    bar.bar_shape = gears.shape.rounded_bar
    bar.background_color = x.color8
    return bar
end

local volume_bar = require("widgets.volume_bar")
local volume = format_progress_bar(volume_bar)

local mysystray = wibox.widget.systray()
mysystray:set_base_size(beautiful.systray_icon_size)

local mysystray_container = {
    mysystray,
    left = dpi(8),
    right = dpi(8),
    screen = 1,
    widget = wibox.container.margin
}

local taglist_buttons = gears.table.join(
                            awful.button({}, 1, function(t) t:view_only() end),
                            awful.button({modkey}, 1, function(t)
        if client.focus then client.focus:move_to_tag(t) end
    end), awful.button({}, 3, awful.tag.viewtoggle),
                            awful.button({modkey}, 3, function(t)
        if client.focus then client.focus:toggle_tag(t) end
    end), awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
                            awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end))

local tasklist_buttons = gears.table.join(
                             awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end), awful.button({}, 3, function()
        awful.menu.client_list({theme = {width = 250}})
    end), awful.button({}, 4, function() awful.client.focus.byidx(1) end),
                             awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))

local mytextclock = awful.widget.textclock(s)

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
      style = {bg = x.transbg, shape = helpers.rrect(beautiful.bar_radius)},
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
              shape = helpers.rrect(beautiful.bar_radius),
              bg = x.transbg,
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
                    mytextclock,
                    top = dpi(4),
                    bottom = dpi(4),
                    right = dpi(7),
                    left = dpi(7),
                    widget = wibox.container.margin
            },
            top = 6,
            bottom = 6,
            right = 5,
            left = 5,
            widget = wibox.container.margin
        },

        {
            {
                {
                    {
                        volume,
                        top = dpi(2),
                        layout = wibox.container.margin
                    },
                    bg = x.bg,
                    shape = helpers.rrect(beautiful.border_radius - 3),
                    widget = wibox.container.background
                },
                top = 2,
                bottom = 2,
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
                    bg = x.bg,
                    shape = helpers.rrect(beautiful.border_radius - 3),
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
                        top = dpi(4),
                        bottom = dpi(4),
                        right = dpi(7),
                        left = dpi(7),
                        widget = wibox.container.margin
                    },
                    bg = x.bg,
                    shape = helpers.rrect(beautiful.border_radius - 3),
                    widget = wibox.container.background
                },
                top = 6,
                bottom = 6,
                right = 5,
                left = 5,
                widget = wibox.container.margin
            },
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
   s.mywibox.visible = not s.mywibox.visible
end

-- client.connect_signal("focus", no_wibar_visble)
-- client.connect_signal("unfocus", no_wibar_visble)
client.connect_signal("property::fullscreen", no_wibar)

-- Every bar theme should provide these fuctions
function wibars_toggle()
   local s = awful.screen.focused()
   s.mywibox.visible = not s.mywibox.visible
end
