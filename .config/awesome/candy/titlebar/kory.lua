local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local helpers = require("helpers")

-- helper function to create buttons
local function create_title_button(c, color, symbol)

    local tb_icon = wibox.widget {
        markup = "<span foreground=\"" .. color .. "\">" .. symbol .. "</span>",
        font = beautiful.ifont .. "18",
        widget = wibox.widget.textbox
    }

    local tb = wibox.widget {
        tb_icon,
        width = 15,
        height = 15,
        strategy = "min",
        layout = wibox.layout.constraint
    }

    tb.visible = true
    return tb
end


client.connect_signal("manage", function(c)

    if c.class == "firefox" then
        awful.titlebar.hide(c, "top")
    else
        awful.titlebar.show(c, "top")
    end

    if c.fullscreen then
        awful.titlebar.hide(c, "top")
    end

    if c.type == "dialog" then
        awful.titlebar.hide(c, "top")
    end


end)

-- enable titlebar
client.connect_signal("request::titlebars", function(c)
    local buttons = gears.table.join(

    awful.button({}, 1, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        if c.maximized == true then c.maximized = false end
        if c.floating == false then c.floating = true end
        awful.mouse.client.move(c)
    end),

    awful.button({}, 3, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        if c.maximized == true then c.maximized = false end
        if c.floating == false then c.floating = true end
        awful.mouse.client.resize(c)
    end))

    local borderbuttons = gears.table.join(
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            if c.floating == false then c.floating = true end
            awful.mouse.client.resize(c)
        end), awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            if c.floating == false then c.floating = true end
            awful.mouse.client.resize(c)
        end))

    -- buttons
    local close = create_title_button(c, beautiful.titlebar_close_color or x.color1, beautiful.titlebar_close_button or " ")
    close:connect_signal("button::press", function() c:kill() end)

    local floating = create_title_button(c, beautiful.titlebar_floating_color or x.color5, beautiful.titlebar_floating_button or " ")
    floating:connect_signal("button::press", function() c.floating = not c.floating end)

    local full = create_title_button(c, beautiful.titlebar_full_color or x.color3,beautiful.titlebar_full_button or " ")
    full:connect_signal("button::press", function(c) c.fullscreen = true end)

    awful.titlebar(c, {
        position = "top",
        size = beautiful.titlebar_size,
        bg = "#00000000"
    }):setup {
    {
        {
            {
                -- left
                {
                    {
                        {
                            close,
                            full,
                            floating,
                            layout = wibox.layout.fixed.horizontal
                        },
                        widget = wibox.container.margin
                    },
                    top = dpi(10),
                    left = dpi(10),
                    bottom = dpi(10),
                    widget = wibox.container.margin
                },
                -- center
                {
                    {
                        align  = 'center',
                        buttons = buttons,
                        widget = awful.titlebar.widget.titlewidget(c)
                    },
                    buttons = buttons,
                    layout  = wibox.layout.flex.horizontal
                },
                layout = wibox.layout.align.horizontal
            },
            bg = top_bg,
            widget = wibox.container.background
        },
        top = beautiful.border_width,
        left = beautiful.border_width,
        right = beautiful.border_width,
        widget = wibox.container.margin
    },
    bg = x.color0,
    widget = wibox.container.background
    }

end)
