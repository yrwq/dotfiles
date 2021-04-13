local helpers = require("helpers")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")

local icon = wibox.widget {
    layout = wibox.layout.align.vertical,
    expand = 'none',
    nil,
    {
        markup = "",
        font = beautiful.ifont .. "22",
        widget = wibox.widget.textbox
    },
    nil
}

local action_level = wibox.widget {
    icon,
    widget = wibox.container.background
}

local slider = wibox.widget {
    nil,
    {
        id                  = "volume_slider",
        bar_shape           = gears.shape.rounded_rect,
        bar_height          = dpi(4),
        bar_color           = x.fg .. "55",
        bar_active_color    = x.fg,
        handle_color        = x.color9,
        handle_shape        = gears.shape.circle,
        handle_width        = dpi(0),
        handle_border_color = x.color1,
        handle_border_width = dpi(0),
        maximum             = 100,
        widget              = wibox.widget.slider,
    },
    nil,
    forced_height = dpi(24),
    expand = "none",
    layout = wibox.layout.align.vertical
}

local volume_slider = slider.volume_slider

volume_slider:connect_signal("property::value", function()
    local volume_level = volume_slider:get_value()
    awful.spawn("amixer -D pulse sset Master " ..  volume_level .. "%", false)
end)

local update_slider = function()
    awful.spawn.easy_async_with_shell([[bash -c "amixer -D pulse sget Master"]],
        function(stdout)
            local volume = string.match(stdout, "(%d?%d?%d)%%")
            volume_slider:set_value(tonumber(volume))
        end)
end

-- Update on startup
update_slider()

-- The emit will come from the global keybind
awesome.connect_signal("widget::volume", function()
    update_slider()
end)

volume_slider:buttons(gears.table.join(
    awful.button({}, 4, nil, function()
        if volume_slider:get_value() > 100 then
            volume_slider:set_value(100)
            return
        end
        volume_slider:set_value(volume_slider:get_value() + 5)
    end),
    awful.button({},5, nil, function()
        if volume_slider:get_value() < 0 then
            volume_slider:set_value(0)
            return
        end
        volume_slider:set_value(volume_slider:get_value() - 5)
    end)
))

local action_jump = function()
    local sli_value = volume_slider:get_value()
    local new_value = 0

    if sli_value >= 0 and sli_value < 50 then
        new_value = 50
    elseif sli_value >= 50 and sli_value < 100 then
        new_value = 100
    else
        new_value = 0
    end
    volume_slider:set_value(new_value)
end

action_level:buttons(
    awful.util.table.join(
    awful.button({}, 1, nil, function()
        action_jump()
    end)
))

local volume_setting = wibox.widget {
    {
        {
            {
                {
                    action_level,
                    top = dpi(12),
                    bottom = dpi(12),
                    widget = wibox.container.margin
                },
                slider,
                spacing = dpi(24),
                layout = wibox.layout.fixed.horizontal
            },
            left = dpi(24),
            right = dpi(24),
            forced_height = dpi(42),
            widget = wibox.container.margin
        },
        shape = helpers.rrect(dpi(5)),
        bg = x.color0,
        widget = wibox.container.background
    },
    right = dpi(10),
    left = dpi(10),
    widget = wibox.container.margin
}

return volume_setting
