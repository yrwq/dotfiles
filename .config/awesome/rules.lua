local awful = require("awful")
local ruled = require("ruled")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")
require("awful.autofocus")

client.connect_signal("manage", function (c)
    if not awesome.startup then awful.client.setslave(c) end
end)

-- sloppy focus
client.connect_signal("mouse::enter", function(c)
    c:activate { context = "mouse_enter", raise = false }
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

client.connect_signal("focus",function(c)
    if c.class == "discord" or c.class == "scratch" or c.class == "music" then
        c.border_width = dpi(4)
        c.border_color = x.fg
        c.shape = helpers.rrect(dpi(5))
        awful.titlebar.hide(c)
    end
end)

ruled.client.connect_signal("request::rules", function()

    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            screen    = awful.screen.preferred,
            size_hints_honor = false,
            honor_workarea = true,
            honor_padding = true,
            titlebars_enabled = true,
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
        },
    }

    ruled.client.append_rule {
        rule_any = {
            instance = {
                "scratch"
            },
            class = {
                "scratch"
            },
        },
        properties = {
            floating = true,
            width = screen_width * 0.6,
            height = screen_height * 0.5
        },
        callback = function (c)
            awful.placement.centered(c)
        end
    }

    ruled.client.append_rule {
        rule_any = {
            instance = {
                "discord"
            },
            class = {
                "discord"
            },
        },
        properties = {
            floating = true,
            width = screen_width * 0.8,
            height = screen_height * 0.8
        },
        callback = function (c)
            awful.placement.centered(c)
        end
    }

    ruled.client.append_rule {
        rule_any = {
            instance = {
                "music"
            },
            class = {
                "music"
            },
        },
        properties = {
            floating = true,
            height = 352,
            width = 893
        },
        callback = function (c)
            awful.placement.centered(c)
        end
    }
end)
