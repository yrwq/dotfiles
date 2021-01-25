local gears = require("gears")
local awful = require("awful")
local ruled = require("ruled")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require ("helpers")
local keys = require("keys")
require("awful.autofocus")

ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            buttons = keys.clientbuttons,
            raise     = true,
            screen    = awful.screen.preferred,
            size_hints_honor = false,
            honor_workarea = true,
            honor_padding = true,
            maximized = false,
            maximized_horizontal = false,
            maximized_vertical = false
        }
    }

    -- Floating and centered clients
    ruled.client.append_rule {
        id = "floating",
        rule_any = {
            class    = {
                "music",
                "news",
                "Sxiv",
                "feh",
                "Surf",
                "files",
                "Tor Browser",
                "Thunar",
                "Pavucontrol",
                "Lxappearance"
            },
            role    = {
                "AlarmWindow",    -- Thunderbird's calendar.
                "ConfigManager",  -- Thunderbird's about:config.
                "GtkFileChooserDialog", -- File chooser
                "pop-up",         -- e.g. Google Chrome's (detached) Developer Tools.
            },
            type = {
                "dialog",
            }
        },
        properties = {
            floating = true,
            width = screen_width * 0.6,
            height = screen_height * 0.6
        },
        callback = function (c)
            awful.placement.centered(c)
        end
    }

    ruled.client.append_rule {
        rule_any = { class = { "mail" } },
        properties = { floating = true, width = screen_width * 0.8, height = screen_height * 0.6 },
        callback = function(c)
            awful.placement.centered(c)
        end
    }

    ruled.client.append_rule {
        rule_any = { name = { "Weather" } },
        properties = { floating = true },
        callback = function(c)
            awful.placement.centered(c)
        end
    }
    -- Add titlebars to normal clients and dialogs
    -- ruled.client.append_rule {
    --     id         = "titlebars",
    --     rule_any   = { type = { "normal", "dialog" } },
    --     properties = { titlebars_enabled = true      }
    -- }

    -- File chooser dialog
    ruled.client.append_rule {
        rule_any = { role = { "GtkFileChooserDialog" } },
        properties = { floating = true, width = screen_width * 0.6, height = screen_height * 0.6 }
    }

    -- MPV
    ruled.client.append_rule {
        rule = { class = "mpv" },
        callback = function (c)
            awful.placement.centered(c)
            c.ontop = true
        end
    }

end)

client.connect_signal("manage", function (c)
    -- Set every new window as a slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end
end)

-- client.connect_signal("unfocus", function(c)
--     c.opacity = 0.8
-- end)
