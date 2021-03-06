local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local helpers = require("helpers")

local task_pop = awful.popup {
    widget = awful.widget.tasklist {
        screen   = screen[1],
        filter   = awful.widget.tasklist.filter.currenttags,
        layout   = {
            layout = wibox.layout.flex.vertical
        },
        widget_template = {
            {
                {
                    id     = "text_role",
                    align  = "center",
                    widget = wibox.widget.textbox,
                },
                forced_width = dpi(180),
                left = dpi(15),
                right = dpi(15),
                top  = dpi(4),
                bottom = dpi(4),
                widget = wibox.container.margin
            },
            forced_width = dpi(400),
            forced_height = dpi(40),
            id = "background_role",
            widget = wibox.container.background,
        },
    },
    bg = x.bg,
    border_color = x.fg,
    border_width = dpi(4),
    ontop = true,
    visible = false,
    placement = awful.placement.centered,
    shape = helpers.rrect(dpi(4)),
}

awful.keygrabber {
    start_callback = function() task_pop.visible = true end,
    stop_callback = function() task_pop.visible = false end,
    export_keybindings = true,
    stop_event = "release",
    stop_key = {"Escape", "Super_L", "Super_R", "Mod4"},
    keybindings = {
        {
            { mod }, "Tab", function()
                awful.client.focus.byidx(1)
            end
        },
    }
}
