local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local pad = helpers.pad

local nord_box = wibox.widget {
    markup = 'Disconnected',
    align = 'center',
    font = 'Anonymous Pro 12',
    widget = wibox.widget.textbox
}

local c_cmd = function()
    awful.spawn.with_shell("sudo systemctl start tor")
    awful.spawn.with_shell("notify-send 'Tor started!'")
    nord_box.markup = "Connected"
end
local d_cmd = function()
    awful.spawn.with_shell("sudo systemctl stop tor")
    awful.spawn.with_shell("notify-send 'Tor stopped!'")
    nord_box.markup = "Disconnected"
end

local create_button = function(cmd, mkup)

    local text = wibox.widget {
        markup = mkup,
        align = 'center',
        font = 'Anonymous Pro 8',
        forced_width = dpi(60),
        widget = wibox.widget.textbox
    }

    local button = wibox.widget {
        {text, margins = dpi(2), layout = wibox.container.margin},
        shape = helpers.rrect(dpi(6)),
        bg = x.bg,
        widget = wibox.container.background
    }

    button:buttons(gears.table.join(awful.button({}, 1, function() cmd() end)))

    button:connect_signal("mouse::enter", function()
        text.markup = helpers.colorize_text(text.text, x.color4)
    end)

    button:connect_signal("mouse::leave", function()
        text.markup = helpers.colorize_text(text.text, x.fg)
    end)

    return button

end

local connect_button = create_button(c_cmd, "Connect")
local d_connect_button = create_button(d_cmd, "Disconnect")


local box_image = wibox.widget {
  markup = "﨩 ",
  font = "Monofur Nerd Font 25",
  widget = wibox.widget.textbox
}

local image_cont = wibox.widget {
    box_image,
    shape = helpers.rrect(dpi(6)),
    widget = wibox.container.background
}

local align_vertical = {

    nil,
    nord_box,
    {
        connect_button,
        nil,
        d_connect_button,
        spacing = dpi(10),
        layout = wibox.layout.flex.horizontal
    },
    layout = wibox.layout.align.vertical
}
-- align_vertical:set_top(nil)
-- align_vertical:set_middle(nil)
-- align_vertical:set_bottom(text_area)
local area = wibox.layout.fixed.horizontal()
area:add(image_cont)
area:add(wibox.container.margin(align_vertical, dpi(10), dpi(20), 0, dpi(10)))
area.bg = x.color0

local main_wd = wibox.widget {
    area,
    left = dpi(30),
    right = dpi(5),
    forced_width = dpi(200),
    forced_height = dpi(100),
    shape = helpers.rrect(dpi(6)),
    bg = x.color0,
    widget = wibox.container.margin
}


return main_wd
