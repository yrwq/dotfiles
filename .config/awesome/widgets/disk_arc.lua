local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

local disk_arc = wibox.widget {
    start_angle = 3 * math.pi / 2,
    min_value = 0,
    max_value = 100,
    value = 50,
    border_width = 0,
    thickness = dpi(8),
    forced_width = dpi(90),
    forced_height = dpi(90),
    rounded_edge = true,
    bg = x.color8.."55",
    colors = { x.color13 },
    widget = wibox.container.arcchart
}

local disk_hover_text_value = wibox.widget {
    align = "center",
    valign = "center",
    font = beautiful.nfont .. "10",
    widget = wibox.widget.textbox()
}
local disk_hover_text = wibox.widget {
    disk_hover_text_value,
    {
        align = "center",
        valign = "center",
        font = beautiful.nfont .. "10",
        widget = wibox.widget.textbox("free")
    },
    spacing = dpi(2),
    visible = false,
    layout = wibox.layout.fixed.vertical
}

awesome.connect_signal("shit::disk", function(used, total)
    disk_arc.value = used * 100 / total
    disk_hover_text_value.markup = helpers.colorize_text(tostring(helpers.round(total - used, 1)).."G", x.color4)
end)

local disk_icon = wibox. widget {
    align = "center",
    valign = "center",
    font = beautiful.ifont .. "25",
    markup = helpers.colorize_text("", x.color4),
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

disk:connect_signal("mouse::enter", function ()
    disk_icon.visible = false
    disk_hover_text.visible = true
end)
disk:connect_signal("mouse::leave", function ()
    disk_icon.visible = true
    disk_hover_text.visible = false
end)

return disk
