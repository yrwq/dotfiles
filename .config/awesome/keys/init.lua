local awful = require("awful")
local helpers = require("helpers")
local gears = require("gears")

-- define modifiers
mod = "Mod4"
ctrl = "Control"
shift = "Shift"
alt = "Mod1"

require("keys.popups")
require("keys.scratchpads")
require("keys.launchers")
require("keys.client")
require("keys.root")
require("keys.tag")
require("keys.awesome")
require("keys.layout")

local keys = {}

keys.tasklist_buttons = gears.table.join(
    awful.button({ "Any" }, 1,
        function (c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
            end
    end),
    -- Middle mouse button closes the window (on release)
    awful.button({ "Any" }, 2, nil, function (c) c:kill() end),
    awful.button({ "Any" }, 3, function (c) c.minimized = true end),
    awful.button({ "Any" }, 4, function ()
        awful.client.focus.byidx(-1)
    end),
    awful.button({ "Any" }, 5, function ()
        awful.client.focus.byidx(1)
    end),

    -- Side button up - toggle floating
    awful.button({ "Any" }, 9, function(c)
        c.floating = not c.floating
    end),
    -- Side button down - toggle ontop
    awful.button({ "Any" }, 8, function(c)
        c.ontop = not c.ontop
        c.sticky = not c.sticky
    end)
)

return keys
