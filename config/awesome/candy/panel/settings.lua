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
local function create_button(symbol, color, hover_color, cmd)
    local icon = wibox.widget {
        markup = helpers.colorize_text(symbol, color),
        align = "center",
        valign = "center",
        font = "Material Icons 20",
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

    -- Adds mousebinds if cmd is provided
    if cmd then
        icon:buttons(gears.table.join(
            awful.button({ }, 1, function ()
                cmd()
            end),
            awful.button({ }, 3, function ()
                cmd()
            end)
        ))
    end

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
local vol_box = create_boxed_widget(volume, 400, 50, x.color0) -- final volume bar

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
local tor_box = create_boxed_widget(tor, 100, 120, x.color0) -- final tor icon

-- power buttons
local logout = create_button("", x.fg, x.color1, apps.logout)
local shutdown = create_button("", x.fg, x.color1, apps.shutdown)
local lock = create_button("", x.fg, x.color1, apps.lock)
local logout_box = create_boxed_widget(logout, 50, 50, x.color0)
local shutdown_box = create_boxed_widget(shutdown, 50, 50, x.color0)
local lock_box = create_boxed_widget(lock, 50, 50, x.color0)

-- disk
--BEGIN
local disk_arc = wibox.widget {
    start_angle = 3 * math.pi / 2,
    min_value = 0,
    max_value = 100,
    value = 50,
    border_width = 0,
    rounded_edge = true,
    bg = x.color8.."55",
    colors = { x.color1 },
    widget = wibox.container.arcchart
}
local disk_hover_text_value = wibox.widget {
    align = "center",
    valign = "center",
    font = "Anonymous Pro 13",
    widget = wibox.widget.textbox()
}
local disk_hover_text = wibox.widget {
    disk_hover_text_value,
    {
        align = "center",
        valign = "center",
        font = "Anonymous Pro 10",
        widget = wibox.widget.textbox("free")
    },
    visible = false,
    layout = wibox.layout.fixed.vertical
}
awesome.connect_signal("shit::disk", function(used, total)
    disk_arc.value = used * 100 / total
    disk_hover_text_value.markup = helpers.colorize_text(tostring(helpers.round(total - used, 1)).."G", x.color9)
end)
local disk_icon = wibox. widget {
    align = "center",
    valign = "center",
    font = "icomoon 23",
    markup = helpers.colorize_text("", x.color9),
    widget = wibox.widget.textbox()
}
local disk = wibox.widget {
    {
        nil,
        disk_hover_text,
        expand = "none",
        layout = wibox.layout.align.vertical
    },
    disk_icon,
    disk_arc,
    top_only = false,
    layout = wibox.layout.stack
}
local disk_box = create_boxed_widget(disk, 100, 120, x.trans)
disk_box:connect_signal("mouse::enter", function ()
    disk_icon.visible = false
    disk_hover_text.visible = true
end)
disk_box:connect_signal("mouse::leave", function ()
    disk_icon.visible = true
    disk_hover_text.visible = false
end)
--END


-- mpd
local mpd = require("widgets.mpd") 
local mpd_box = create_boxed_widget(mpd, 400, 125, x.color0) -- final mpd widget

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

local disk_area = {
    nil,
    {
        disk_box,
        layout = wibox.layout.align.vertical,
    },
    nil,
    layout = wibox.layout.align.vertical
}

local power_area = {
  {
      {
          lock_box,
          layout = wibox.layout.align.horizontal,
      },
      {
          logout_box,
          layout = wibox.layout.align.horizontal,
      },
      {
          shutdown_box,
          layout = wibox.layout.align.horizontal,
      },
      layout = wibox.layout.align.horizontal,
  },
  layout = wibox.layout.align.vertical
}

local settings_area = {
  nil,
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
        disk_area,
        tor_area,
        layout = wibox.layout.align.horizontal
    },
    power_area,
    {
        settings_area,
        mpd_area,
        layout = wibox.layout.align.vertical
    },
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
