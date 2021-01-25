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

    return tb
end


client.connect_signal("manage", function(c)

    if c.class == "firefox" then
        awful.titlebar.hide(c)
    else
        if not c.fullscreen then
            awful.titlebar.show(c, "top")
            awful.titlebar.show(c, "bottom")
            awful.titlebar.show(c, "left")
            awful.titlebar.show(c, "right")
        end
    end

    if c.fullscreen then
        awful.titlebar.hide(c)
    end

    if c.type == "dialog" then
        awful.titlebar.hide(c)
    end

end)

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

    local min = create_title_button(c, x.color5, x.color0)
    min:connect_signal("button::press", function() c.minimized = not c.minimized end)

    awful.titlebar(c, {position = "right", size = dpi(10)}):setup{
        {close, layout = wibox.layout.flex.vertical},
        layout = wibox.layout.align.vertical
    }
    awful.titlebar(c, {position = "left", size = dpi(10)}):setup{
        {min, layout = wibox.layout.flex.vertical},
        layout = wibox.layout.align.vertical

    }
    awful.titlebar(c, {position = "bottom", size = dpi(10)}):setup{
        buttons = borderbuttons,
        layout = wibox.layout.fixed.horizontal
    }
    awful.titlebar(c, {position = "top", size = dpi(10)}):setup{
        buttons = borderbuttons,
        layout = wibox.layout.fixed.horizontal
    }
    awful.titlebar(c, {position = "top", size = dpi(10)}):setup{
        { -- Left
            --            awful.titlebar.widget.iconwidget(c),
            min,
            layout = wibox.layout.fixed.horizontal
        },
        { -- Middle
            buttons = buttons,
            layout = wibox.layout.flex.horizontal
        },
        { -- Right
            close,
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)
