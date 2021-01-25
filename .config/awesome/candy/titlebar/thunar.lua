local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")

client.connect_signal("manage", function(c)
    if c.class == "Thunar" then
        awful.titlebar.show(c, "left")
    end
end)

button.create_text = function(color, text, font, onclick)
    local icon = wibox.widget {
        font = font,
        align = "center",
        valign = "center",
        markup = "<span foreground='"..color.."'>"..text.."</span>",
        widget = wibox.widget.textbox
    }

    if onclick ~= nil then
        icon:connect_signal("button::press", onclick)
    end

    icon:connect_signal("mouse::enter", function ()
        icon.markup = "<span foreground='"..x.fg .. "CC" .."'>"..text.."</span>"
    end)

    icon:connect_signal("mouse::leave", function ()
        icon.markup = "<span foreground='"..color.."'>"..text.."</span>"
    end)

    return icon
end

local create_shortcut = function(c, icon, location)
    local shortcut = button.create_text(x.fg, icon, beautiful.ifont .. "35", function()
        awful.spawn.with_shell("xdotool key ctrl+l; xdotool type --delay 0 "..location.."; xdotool key Return;")
    end)

    shortcut.forced_width = dpi(40)
    shortcut.forced_height = dpi(40)

    return shortcut
end

local keyf = function(c, icon, key)
    local shortcut = button.create_text(x.color15, icon, beautiful.ifont .. "35", function()
        awful.spawn.with_shell("xdotool key ctrl+" .. key)
    end)

    shortcut.forced_width = dpi(40)
    shortcut.forced_height = dpi(40)

    return shortcut
end

local create_thunar_titlebar = function(c)
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

        awful.titlebar(c, {
            position = "left",
            size = dpi(50),
            bg = x.bg
        }):setup{
            {
                {
                    {
                        create_shortcut(c, "", dir.home),
                        create_shortcut(c, "", dir.config),
                        create_shortcut(c, "", dir.download),
                        create_shortcut(c, "", dir.video),
                        create_shortcut(c, "", dir.picture),
                        create_shortcut(c, "", dir.dev),
                        create_shortcut(c, "", dir.doc),

                        helpers.horizontal_pad(dpi(40)),

                        keyf(c, "﬒", "h"), -- toggle hidden
                        layout = wibox.layout.flex.vertical
                    },
                    top = dpi(10),
                    bottom = dpi(10),
                    left = dpi(10),
                    right = dpi(10),
                    widget = wibox.container.margin
                },
                layout = wibox.layout.flex.vertical,
            },

            bg = x.color0,
            shape = helpers.prrect(dpi(0), false, true, true, false),
            widget = wibox.container.background

        }

    end)
end

-- only add this titlebar to thunar
table.insert(awful.rules.rules, {
    rule_any = {
        class = {
            "Thunar",
        },
    },
    properties = {},
    callback = create_thunar_titlebar
})
