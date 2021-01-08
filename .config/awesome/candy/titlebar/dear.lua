local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

local function create_title_button(c, color_focus, color_unfocus)
    local tb_color = wibox.widget {
        bg = color_focus,
        widget = wibox.container.background
    }

    local tb = wibox.widget {
        tb_color,
        width = 25,
        height = 20,
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

    client.connect_signal("manage", function(c)
        if c.bling_tabbed then
          tb.visible = false
          c.border_width = dpi(beautiful.border_width)
        end
    end)

    return tb
end

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
        create_title_button(c, x.color2, x.color0)
    floating:connect_signal("button::press",
                            function() c.floating = not c.floating end)

    local minimize =
        create_title_button(c, x.color3, x.color0)
    minimize:connect_signal("button::press",
                            function() c.fullscreen = true end)

    awful.titlebar(c, {position = "top", size = 20}):setup{
        { -- Left
            --            awful.titlebar.widget.iconwidget(c),
            layout = wibox.layout.fixed.horizontal
        },
        { -- Middle
            buttons = buttons,
            layout = wibox.layout.flex.horizontal
        },
        { -- Right
          minimize,
          nil,
          floating,
          close,
          layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)
