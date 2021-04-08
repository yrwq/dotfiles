local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

local width = dpi(200)
local height = dpi(200)
local screen = awful.screen.focused()

local volume_icon = wibox.widget {
    markup = helpers.colorize_text("", x.color9),
    align = "center",
    valign = "center",
    font = beautiful.ifont .. "70",
    widget = wibox.widget.textbox
}

local volume_adjust = wibox({
    screen = screen.primary,
    type = "notification",
    x = screen_width / 2 - width / 2,
    y = screen_height / 2 - height / 2,
    width = width,
    height = height,
    visible = false,
    ontop = true,
    bg = x.color0
})

local volume_bar = wibox.widget {
    widget = wibox.widget.progressbar,
    shape = gears.shape.rounded_bar,
    bar_shape = gears.shape.rounded_bar,
    color = x.color9,
    background_color = x.color8,
    max_value = 100,
    value = 0
}

volume_adjust:setup{
    {
        layout = wibox.layout.align.vertical,
        {
            volume_icon,
            top = dpi(15),
            left = dpi(50),
            right = dpi(50),
            bottom = dpi(20),
            widget = wibox.container.margin
        },
        {
            volume_bar,
            left = dpi(25),
            right = dpi(25),
            bottom = dpi(40),
            widget = wibox.container.margin
        }

    },
    shape = helpers.rrect(dpi(5)),
    bg = x.color0,
    border_width = dpi(2),
    border_color = x.color9,
    widget = wibox.container.background
}

local hide_volume_adjust = gears.timer {
    timeout = 2,
    autostart = true,
    callback = function() volume_adjust.visible = false end
}

awesome.connect_signal("shit::volume", function(vol, muted)
    volume_bar.value = vol
    if muted or vol == 0 then
        volume_icon.markup = helpers.colorize_text("ﳌ", x.color15)
    else
        volume_icon.markup = helpers.colorize_text("", x.color9)
    end

    if volume_adjust.visible then
        hide_volume_adjust:again()
    else
        volume_adjust.visible = true
        hide_volume_adjust:start()
    end
end)
