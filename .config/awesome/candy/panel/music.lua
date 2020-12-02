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

local mpd = require("widgets.mpd")

local mpd_box = create_boxed_widget(mpd, 250, 250, "#2e2e2e")

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
    mpd_area,
	valign = center,
	align = center,
    layout = wibox.layout.align.vertical
}

local width = 400
local margin = 4

local settingsPop = popupLib.create(
  dpi(870), dpi(35) + margin,
  awful.screen.focused().geometry.height - margin -
  margin - dpi(800) , width,
  panelWidget)

return settingsPop
