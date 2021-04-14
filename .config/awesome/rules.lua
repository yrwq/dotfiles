local awful = require("awful")
local ruled = require("ruled")
local beautiful = require("beautiful")
local keys = require("keys")
local gears = require("gears")
require("awful.autofocus")

-- set a wallpaper
screen.connect_signal("request::wallpaper", function(s)
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
end)

-- set newly spawned clients as slave
client.connect_signal("manage", function (c)
    if not awesome.startup then awful.client.setslave(c) end
end)

-- handle border colors
client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)

client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

-- hide titlebar's for some clients
client.connect_signal("manage",function(c)
    -- only hide titlebar's when there's no double titlebars enabled
    if config.double_titlebars == false then
        if c.class == "discord" or c.class == "scratch" or c.class == "music" then
            awful.titlebar.hide(c)
        end
    end
end)

--
-- rules
--

ruled.client.connect_signal("request::rules", function()

    --
    -- global
    --

    ruled.client.append_rule {
        id         = "global",
        rule       = { },
        properties = {
            focus     = awful.client.focus.filter,
            raise     = true,
            buttons = keys.clientbuttons,
            screen    = awful.screen.preferred,
            size_hints_honor = false,
            honor_workarea = true,
            honor_padding = true,
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal
        },
    }

    --
    -- enable titlebars for normal and dialog clients
    --

    ruled.client.append_rule {
        id         = "titlebars",
        rule_any   = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = true }
    }

    -- 
    -- scratchpad rules
    --

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
            awful.placement.centered(c, { honor_workarea = true, honor_padding = true })
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
            awful.placement.centered(c, { honor_workarea = true, honor_padding = true })
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
            width = 500 
        },
        callback = function (c)
            awful.placement.centered(c, { honor_workarea = true, honor_padding = true })
        end
    }

    --
    -- drawterm script requires this floating rule
    --

    ruled.client.append_rule {
        rule_any = { class = { "float" } },
        properties = { floating = true },
    }

end)
