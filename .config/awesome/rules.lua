local awful = require("awful")
local ruled = require("ruled")
local beautiful = require("beautiful")
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
            titlebars_enabled = true,
            honor_workarea = true,
            honor_padding = true,
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
        }
    }
end)
