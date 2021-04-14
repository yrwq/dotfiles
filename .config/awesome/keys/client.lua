local awful = require("awful")
local helpers = require("helpers")
local bling = require("bling")

-- client's mouse bindings
client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        
        -- focus a client on click
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),

        -- move a client on mod + click
        awful.button({ mod }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),

        -- resize a client on mod + right click
        awful.button({ mod }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)

-- client manipulation
awful.keyboard.append_global_keybindings({

    -- toggle fullscreen
    awful.key {
        modifiers = { mod },
        key = "f",
        group = "client",
        description = "toggle fullscreen",
        on_press = function(c)
            if client.focus then
                local c = client.focus
                c.fullscreen = not c.fullscreen
                c:raise()
            end
        end,
    },

    -- close client
    awful.key {
        modifiers = { mod },
        key = "q",
        group = "client",
        description = "close",
        on_press = function(c)
            if client.focus then
                local c = client.focus
                c:kill()
            end
        end,
    },

    -- toggle floating
    awful.key {
        modifiers = { mod, shift },
        key = "space",
        group = "client",
        description = "toggle floating",
        on_press = function()
            local c = client.focus
            if c.floating then
                c.floating = False
            else
                helpers.float_and_resize(c, screen_width * 0.8, screen_height * 0.8)
                awful.placement.centered(c, { honor_workarea = true, honor_padding = true })
            end
        end,
        -- end,
    },

    -- swap focused client with master
    awful.key {
        modifiers = { mod, shift },
        key = "Return",
        group = "client",
        description = "swap with master",
        on_press = function(c)
            if client.focus then
                local c = client.focus
                c:swap(awful.client.getmaster())
            end
        end,
    },

    -- minimize client
    awful.key {
        modifiers = { mod },
        key = "n",
        group = "client",
        description = "minimize",
        on_press = function(c)
            if client.focus then
                local c = client.focus
                c.minimized = true
            end
        end,
    },

    -- focus next client
    awful.key {
        modifiers = { mod },
        key = "j",
        group = "client",
        description = "focus next",
        on_press = function()
            awful.client.focus.byidx(1)
        end,
    },

    -- focus previous client
    awful.key {
        modifiers = { mod },
        key = "k",
        group = "client",
        description = "focus prev",
        on_press = function()
            awful.client.focus.byidx(-1)
        end,
    },

    -- restore minimized clients
    awful.key {
        modifiers = { mod, shift },
        key = "n",
        group = "client",
        description = "restore minimized",
        on_press = function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:activate { raise = true, context = "key.unminimize" }
            end
        end,
    },

    -- swap client with next
    awful.key {
        modifiers = { mod,shift },
        key = "j",
        group = "client",
        description = "swap with next",
        on_press = function()
            awful.client.swap.byidx(1)
        end,
    },

    -- swap client with previous
    awful.key {
        modifiers = { mod,shift },
        key = "k",
        group = "client",
        description = "swap with prev",
        on_press = function()
            awful.client.swap.byidx(-1)
        end,
    },

    -- jump to urgent client
    awful.key {
        modifiers = { mod,shift },
        key = "u",
        group = "client",
        description = "jump to urgent",
        on_press = awful.client.urgent.jumpto
    },

    -- center a client
    awful.key {
        modifiers = { mod },
        key = "c",
        group = "client",
        description = "move to center",
        on_press = function(c)
            if client.focus then
                local c = client.focus
                awful.placement.centered(c, { honor_workarea = true, honor_padding = true })
            end
        end,
    },

    -- add a client to bling tabbed
    awful.key {
        modifiers = { mod, alt },
        key = "a",
        group = "client",
        description = "add to tabbed",
        on_press = function()
            bling.module.tabbed.pick()
        end,
    },

    -- switch tabbed clients
    awful.key {
        modifiers = { mod, alt },
        key = "s",
        group = "client",
        description = "switch tabbed",
        on_press = function()
            bling.module.tabbed.iter()
        end,
    },

    -- remove a client from bling tabbed
    awful.key {
        modifiers = { mod, alt },
        key = "d",
        group = "client",
        description = "remove from tabbed",
        on_press = function()
            bling.module.tabbed.pop()
        end,
    },

    -- focus mode
    awful.key {
        modifiers = { mod, shift },
        key = "c",
        group = "client",
        description = "move and resize to center",
        on_press = function(c)
            if client.focus then
                local c = client.focus
                helpers.float_and_resize(c, screen_width * 0.9, screen_height * 0.9)
            end
        end,
    },

    -- toggle titlebar
    awful.key {
        modifiers = { mod },
        key = "t",
        group = "client",
        description = "toggle titlebar",
        on_press = function(c)
            if client.focus then
                local c = client.focus
                awful.titlebar.toggle(c)
            end
        end,
    },

    -- resize left
    awful.key {
        modifiers = { ctrl, alt },
        key = "h",
        group = "client",
        description = "resize left",
        on_press = function(c)
            if client.focus then
                local c = client.focus
                helpers.resize_dwim(c, "left")
            end
        end,
    },

    -- resize down
    awful.key {
        modifiers = { ctrl, alt },
        key = "j",
        group = "client",
        description = "resize down",
        on_press = function(c)
            if client.focus then
                local c = client.focus
                helpers.resize_dwim(c, "down")
            end
        end,
    },

    -- resize up
    awful.key {
        modifiers = { ctrl, alt },
        key = "k",
        group = "client",
        description = "resize up",
        on_press = function(c)
            if client.focus then
                local c = client.focus
                helpers.resize_dwim(c, "up")
            end
        end,
    },

    -- resize right
    awful.key {
        modifiers = { ctrl, alt },
        key = "l",
        group = "client",
        description = "resize right",
        on_press = function(c)
            if client.focus then
                local c = client.focus
                helpers.resize_dwim(c, "right")
            end
        end,
    }
})
