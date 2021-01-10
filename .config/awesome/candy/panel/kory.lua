local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")
local icons = require("icons")

local popupLib = require("candy.popupLib")

local box_radius = beautiful.client_radius
local box_gap = dpi(8)

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

-- Helper function that changes the appearance of progress bars and their icons
-- Create horizontal rounded bars
local function format_progress_bar(bar, markup)
    local text = wibox.widget {
        markup = markup,
        align = 'center',
        valign = 'center',
        font = beautiful.nfont .. '12',
        widget = wibox.widget.textbox
    }
    text.forced_height = dpi(36)
    text.forced_width = dpi(36)
    text.resize = true
    bar.forced_width = dpi(215)
    bar.shape = gears.shape.rounded_bar
    bar.bar_shape = gears.shape.rounded_bar

    -- bar.forced_height = dpi(30)
    -- bar.paddings = dpi(4)
    -- bar.border_width = dpi(2)
    -- bar.border_color = x.color8

    local w = wibox.widget {
        nil,
        {text, bar, spacing = dpi(10), layout = wibox.layout.fixed.horizontal},
        expand = "none",
        layout = wibox.layout.align.horizontal
    }
    return w
end

