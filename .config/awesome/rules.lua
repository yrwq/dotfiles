local gears = require("gears")
local awful = require("awful")
local ruled = require("ruled")
require("awful.autofocus")

-- Determines how floating clients should be placed
local floating_client_placement = function(c)
    -- If the layout is floating or there are no other visible
    -- clients, center client
    if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating or #mouse.screen.clients == 1 then
        return awful.placement.centered(c,{honor_padding = true, honor_workarea=true})
    end

    -- Else use this placement
    local p = awful.placement.no_overlap + awful.placement.no_offscreen
    return p(c, {honor_padding = true, honor_workarea=true, margins = beautiful.useless_gap * 2})
end

local centered_client_placement = function(c)
    return gears.timer.delayed_call(function ()
        awful.placement.centered(c, {honor_padding = true, honor_workarea=true})
    end)
end

ruled.client.connect_signal("request::rules", function()
    -- All clients will match this rule.
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
            maximized = false,
            maximized_horizontal = false,
            maximized_vertical = false,
            placement = floating_client_placement
        }
    }

    -- Floating and centered clients
    ruled.client.append_rule {
        id       = "floating",
        rule_any = {
            class    = {
        		"music",
            	"mail",
        		"Sxiv",
            	"feh",
            	"Tor Browser",
            	"Thunar",
            	"Pavucontrol",
            	"Lxappearance"
            },
            name    = {
                "Event Tester",  -- xev.
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
          width = 900,
          height = 700,
        },
        callback = function (c)
          awful.placement.centered(c)
        end
    }

    -- Add titlebars to normal clients and dialogs
    ruled.client.append_rule {
        id         = "titlebars",
        rule_any   = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true      }
    }

    -- File chooser dialog
    ruled.client.append_rule {
        rule_any = { role = { "GtkFileChooserDialog" } },
        properties = { floating = true, width = screen_width * 0.55, height = screen_height * 0.65 }
    }
    -- MPV
    ruled.client.append_rule {
        rule = { class = "mpv" },
        properties = {
          floating = true,
          width = 900,
          height = 700,
        },
        callback = function (c)
            c.ontop = true
        end
    }

    -- i use tag 1 for terminals, but i use terminals on any other tags too
    -- tag 2
    -- browser
    ruled.client.append_rule {
        rule_any = {
            class = {
                "firefox",
                "Nightly",
                "brave-browser-dev",
                "Brave-browser-dev",
                "brave-dev",
                "qutebrowser",
            },
        },
        except_any = {
            instance = { "Toolkit" },
            type = { "dialog" }
        },
        properties = { screen = 1, tag = awful.screen.focused().tags[2] },
    }

    -- tag 3
    -- editors
    ruled.client.append_rule {
        rule_any = {
            class = {
                "editor",
                "emacs",
            },
        },
        properties = { screen = 1, tag = awful.screen.focused().tags[3] },
    }

    -- tag 4
    -- chat
    ruled.client.append_rule {
        rule_any = {
            class = {
                "lightcord",
                "discord",
                "whatsapp-nativefier-dark",
            },
        },
        properties = { screen = 1, tag = awful.screen.focused().tags[4] },
    }

end)

client.connect_signal("manage", function (c)
    -- Set every new window as a slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end
end)
