local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

local offsetx = dpi(56)
local offsety = dpi(300)
local screen = awful.screen.focused()

local active_color_1 = {
    type = 'linear',
    from = {0, 0},
    to = {200, 50}, -- replace with w,h later
    stops = {{0, x.color5}, {0.50, x.color1}}
}

-- create the volume_adjust component
local volume_adjust = wibox({
    screen = awful.screen.focused(),
    x = screen.geometry.width - offsetx - 8,
    y = (screen.geometry.height / 2) - (offsety / 2),
    width = dpi(48),
    height = offsety,
    visible = false,
    ontop = true
})

local volume_bar = wibox.widget {
    widget = wibox.widget.progressbar,
    shape = helpers.rrect(beautiful.bar_radius),
    bar_shape = helpers.rrect(beautiful.bar_radius),
    color = active_color_1,
    background_color = x.color0,
    max_value = 100,
    value = 0
}

volume_adjust:setup{
    {
        {
            layout = wibox.layout.align.vertical,
            {
                wibox.container.margin(volume_bar, dpi(14), dpi(20), dpi(15),
                                       dpi(20)),
                forced_height = offsety * 0.75,
                direction = "east",
                layout = wibox.container.rotate
            },
            wibox.container.margin(wibox.widget {
				markup = "墳",
				font = "Iosevka Nerd Font 20",
                widget = wibox.widget.textbox
            }, dpi(12), dpi(12), dpi(10), dpi(10))
        },
        shape = helpers.rrect(beautiful.border_radius),
        widget = wibox.container.background
    },
    bg = x.transbg,
    widget = wibox.container.background
}

-- create a 3 second timer to hide the volume adjust
-- component whenever the timer is started
local hide_volume_adjust = gears.timer {
    timeout = 3,
    autostart = true,
    callback = function() volume_adjust.visible = false end
}

-- show volume-adjust when "volume_change" signal is emitted
awesome.connect_signal("shit::volume", function(volume, muted)
    if muted then
        volume_bar.value = 0
    else
        volume_bar.value = volume
    end
    -- make volume_adjust component visible
    if volume_adjust.visible then
        hide_volume_adjust:again()
    else
        volume_adjust.visible = true
        hide_volume_adjust:start()
    end
end)
