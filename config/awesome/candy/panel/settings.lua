local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local naughty = require("naughty")
local helpers = require("helpers")
local popupLib = require("candy.popupLib")
local box_radius = beautiful.border_radius
local box_gap = dpi(6)

-- helper function to create progress bar
local function format_progress_bar(bar, icon)
    icon.forced_height = dpi(27)
    icon.forced_width = dpi(36)
    icon.resize = true
    bar.forced_width = dpi(300)
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
        font = "RobotoMono Nerd Font Mono 18",
        align = "center",
        id = "text_role",
        valign = "center",
        markup = helpers.colorize_text(symbol, color),
        widget = wibox.widget.textbox()
    }

    local section = wibox.widget {
        widget,
        forced_width = dpi(20),
        bg = bg_color,
        shape = gears.shape.rounded_rect,
        widget = wibox.container.background
    }

    -- Hover animation
    section:connect_signal("mouse::enter", function ()
        section.bg = hover_color
    end)
    section:connect_signal("mouse::leave", function ()
        section.bg = bg_color
    end)
    helpers.add_hover_cursor(section, "hand1")
    return section
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

-- Widgets
-- basically, create a button for every widget,
-- make the icons boxed,
-- add them to the final area.

-- volume
local volicon = wibox.widget { -- create volume icon
  markup = "",
  font = "Monofur Nerd Font 20",
  widget = wibox.widget.textbox
}
local volbar = require("widgets.volume_bar")
local volume = format_progress_bar(volbar, volicon) -- create the prograss bar
local vol_box = create_boxed_widget(volume, 400, 50, x.bg) -- final volume bar

-- add buttons
volume:buttons(gears.table.join(
    -- left click - mute
    awful.button({ }, 1, function ()
        helpers.volume_control(0)
    end),
    -- right click - open pavucontrol
    awful.button({ }, 3, function()
        awful.spawn.with_shell("pavucontrol")
    end),
    -- scroll - inc/dec volume
    awful.button({ }, 4, function ()
        helpers.volume_control(5)
    end),
    awful.button({ }, 5, function ()
        helpers.volume_control(-5)
    end)
))

-- tor
local tor = require("widgets.tor") 
local tor_box = create_boxed_widget(tor, 100, 120, x.bg) -- final tor icon
-- wifi
local wifi = create_button("直", x.fg, x.trans) -- create wifi button
local wifi_box = create_boxed_widget(wifi, 50, 50, x.bg) -- final wifi icon
-- bluetooth 
local bt = create_button("", x.fg, x.trans) -- create bluetooth button
local bt_box = create_boxed_widget(bt, 50, 50, x.bg) -- final battery icon
-- rec
local rec = create_button("雷", x.fg, x.trans)
local rec_box = create_boxed_widget(rec, 50, 50, x.bg) -- final battery icon
rec_box:buttons(gears.table.join(
    -- left click - mute
    awful.button({ }, 1, function ()
        awful.spawn.with_shell("~/.bin/rec")
    end),
    -- right click - open pavucontrol
    awful.button({ }, 3, function()
        awful.spawn.with_shell("pkill ffmpeg && notify-send 'Recording Stopped!")
    end)
))
-- joplin
local todo = create_button("", x.fg, x.trans) -- create joplin button
local todo_box = create_boxed_widget(todo, 50, 50, x.bg) -- final joplin icon
todo_box:buttons(gears.table.join(
    -- left click - mute
    awful.button({ }, 1, function ()
        awful.spawn.with_shell("emacs ~/doc/todo.org")
    end),
    -- right click - open pavucontrol
    awful.button({ }, 3, function()
        awful.spawn.with_shell("emacs ~/doc/todo.org")
    end)
))

-- mpd
local mpd = require("widgets.mpd") 
local mpd_box = create_boxed_widget(mpd, 400, 125, x.bg) -- final mpd widget

-- final app box
local tor_area = {
    nil,
    {
        tor_box,
        left = dpi(5),
        right = dpi(5),
        top = dpi(10),
        bottom = dpi(10),
        layout = wibox.layout.align.vertical,
        widget = wibox.container.margin
    },
    nil,
    layout = wibox.layout.align.vertical
}

local sys_area = {
    nil,
    {
        {
            bt_box,
            wifi_box,
            layout = wibox.layout.align.horizontal
        },
        {
            todo_box,
            rec_box,
            layout = wibox.layout.align.horizontal
        },
        layout = wibox.layout.align.vertical,
    },
    nil,
    layout = wibox.layout.align.vertical
}

local settings_area = {
  nil,
          helpers.vertical_pad(100),
  {
      {
          vol_box,
          left = dpi(5),
          right = dpi(5),
          top = dpi(0),
          bottom = dpi(0),
          layout = wibox.layout.align.horizontal,
      },
      layout = wibox.layout.align.vertical,
  },
  nil,
  layout = wibox.layout.align.vertical
}

local mpd_area = {
    nil,
    {
        mpd_box,
        left = dpi(5),
        right = dpi(5),
        top = dpi(0),
        bottom = dpi(0),
        layout = wibox.container.margin
    },
    nil,
    layout = wibox.layout.align.vertical
}

local panelWidget = wibox.widget {
    {
        sys_area,
        tor_area,
        layout = wibox.layout.align.horizontal
    },
    settings_area,
    mpd_area,
    layout = wibox.layout.align.vertical
}

local width = 400
local margin = 4

local settingsPop = popupLib.create(
  dpi(870), dpi(35) + margin,
  awful.screen.focused().geometry.height - margin -
  margin - dpi(600) , width,
  panelWidget)

return settingsPop
