local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local helpers = require("helpers")

local function create_title_button(c, color_focus, color_unfocus)
    local tb_color = wibox.widget {
        forced_width = dpi(5),
        forced_height = dpi(5),
        bg = color_focus,
        shape = gears.shape.circle,
        widget = wibox.container.background
    }

    local tb = wibox.widget {
        tb_color,
        width = 15,
        height = 15,
        strategy = "min",
        layout = wibox.layout.constraint
    }

    local function update()
        if client.focus == c then
            tb_color.bg = color_focus
        else
            tb_color.bg = color_unfocus
        end
    end
    update()
    c:connect_signal("focus", update)
    c:connect_signal("unfocus", update)

    tb:connect_signal("mouse::enter",
                      function() tb_color.bg = color_focus .. "70" end)

    tb:connect_signal("mouse::leave", function() tb_color.bg = color_focus end)

    tb.visible = true
    return tb
end
-- }}

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar

    local buttons = gears.table.join(awful.button({}, 1, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        if c.maximized == true then c.maximized = false end
        awful.mouse.client.move(c)
    end), awful.button({}, 3, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.resize(c)
    end))
    local borderbuttons = gears.table.join(
                              awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end), awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end))

    local close = create_title_button(c, x.color1, x.color0)
    close:connect_signal("button::press", function() c:kill() end)

    local floating =
        create_title_button(c, x.color5, x.color0)
    floating:connect_signal("button::press",
                            function() c.floating = not c.floating end)

    local min = create_title_button(c, x.color3, x.color0)
    min:connect_signal("button::press", function() c.fullscreen = true end)

    local top_bg = x.bg

    if c.class == "firefox" or c.class == "Thunar" then
        top_bg = x.color0
    else
        top_bg = x.bg
    end

    awful.titlebar(c, {
        position = "top",
        size = beautiful.titlebar_size,
        bg = "#00000000"
    }):setup{
        {
            {
                {
                    {
                        {
                            {
                                min,
                                floating,
                                close,
                                layout = wibox.layout.fixed.horizontal
                            },
                            widget = wibox.container.margin
                        },
                        top = dpi(10),
                        left = dpi(10),
                        bottom = dpi(10),
                        widget = wibox.container.margin

                    },
                    nil,
                    nil,
                    layout = wibox.layout.align.horizontal
                },
                bg = top_bg,
                -- shape = helpers.prrect(beautiful.client_radius, true, true,
                                       -- false, false),
                widget = wibox.container.background
            },

            top = beautiful.border_width,
            left = beautiful.border_width,
            right = beautiful.border_width,
            widget = wibox.container.margin
        },
        bg = x.color0,
        -- shape = helpers.prrect(beautiful.client_radius, true, true, false, false),
        widget = wibox.container.background

    }

    awful.titlebar(c, {
        position = "bottom",
        -- size = beautiful.client_radius,
        size = beautiful.border_width,
        bg = "#00000000"
    }):setup{
        {
            {
                bg = x.bg,
                shape = helpers.prrect(beautiful.client_radius, false, false,
                                       true, true),
                widget = wibox.container.background
            },
            bottom = beautiful.border_width,
            left = beautiful.border_width,
            right = beautiful.border_width,
            widget = wibox.container.margin
        },

        bg = x.color0,
        shape = helpers.prrect(beautiful.client_radius, false, false, true, true),
        widget = wibox.container.background

    }

    awful.titlebar(c, {
        position = "left",
        size = beautiful.border_width,
        bg = x.color0
    })

    awful.titlebar(c, {
        position = "right",
        size = beautiful.border_width,
        bg = x.color0
    })

end)
