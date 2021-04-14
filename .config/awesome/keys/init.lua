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
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
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

-- Mouse buttons on a tag of the taglist widget
keys.taglist_buttons = gears.table.join(
    
    -- view a tag with left click
    awful.button({ }, 1, function(t)
        t:view_only()
    end),

    -- move focused client to focused tag on the taglist
    awful.button({ mod }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),

    -- toggle viewing another tag too with right_click
    awful.button({ }, 3, awful.tag.viewtoggle),

    -- make focused client available in the right_clicked tag
    awful.button({ mod }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),

    -- scrolling up/down to view next/prev tag
    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
)


-- Mouse buttons on the client (whole window, not just titlebar)
keys.clientbuttons = gears.table.join(

    -- left click to focus a client
    awful.button({ }, 1, function (c) client.focus = c end),

    -- make a client floating and move it with mod+left_click
    awful.button({ mod }, 1, function(c)
        client.focus = c
        c.floating = true
        awful.mouse.client.move(c)
    end),
    
    -- make a client floating and resize it mod+right_click
    awful.button({ mod }, 3, function(c)
        client.focus = c
        c.floating = true
        awful.mouse.client.resize(c)
    end)
)

return keys
