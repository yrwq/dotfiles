local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local helpers = require("helpers")

s.window_switcher = awful.widget.tasklist {
        screen   = screen[1],
        filter   = awful.widget.tasklist.filter.currenttags,
        style    = {
            shape = gears.shape.rounded_rect,
        },
        layout   = {
            layout = wibox.layout.fixed.vertical
        },
        widget_template = {
            {
                {
                    -- id     = 'clienticon',
                    -- widget = awful.widget.clienticon,
                    id     = 'text_role',
					align = "center",
					forced_width = dpi(50),
                    widget = awful.widget.textbox,
                },
				left = dpi(6),
				right = dpi(6),
				bottom = dpi(6),
				top = dpi(6),
                margins = 4,
                widget  = wibox.container.margin,
            },
            id              = 'background_role',
            forced_width    = 48,
            forced_height   = 48,
            widget          = wibox.container.background,
            -- create_callback = function(self, c, index, objects) --luacheck: no unused
            --     self:get_children_by_id('clienticon')[1].client = c
            -- end,
            create_callback = function(self, c, index, objects) --luacheck: no unused
                self:get_children_by_id('text_role')[1].client = c
            end,
        },
    },
    border_color = '#777777',
    border_width = 2,
    ontop        = true,
	visible 	 = false,
    placement    = awful.placement.centered,
    shape        = gears.shape.rounded_rect
}

function gears.table.iterate_value(t, value, step_size, filter, start_at)
    local k = gears.table.hasitem(t, value, true, start_at)
    if not k then return end

    step_size = step_size or 1
    local new_key = gears.math.cycle(#t, k + step_size)

    if filter and not filter(t[new_key]) then
        for i = 1, #t do
            local k2 = gears.math.cycle(#t, new_key + i)
            if filter(t[k2]) then return t[k2], k2 end
        end
        return
    end

    return t[new_key], new_key
end

awful.keygrabber {
    start_callback = function() tasks_popup.visible = true end,
    stop_callback = function() tasks_popup.visible = false end,
    export_keybindings = true,
    stop_event = "release",
    stop_key = {"Escape", "Super_L", "Super_R", "Mod4"},
    keybindings = {
        {
            {modkey}, "Tab", function()
				awful.client.focus.byidx( 1)
            end
        }
    }
}
