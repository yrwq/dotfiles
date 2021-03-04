local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local bling = require("bling")
local helpers = require("helpers")
local machi = require("machi")
local lain = require("lain")
require("awful.hotkeys_popup.keys")

mod = "Mod4"
ctrl = "Control"
shift = "Shift"
alt = "Mod1"

awful.mouse.append_global_mousebindings({
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})

awful.keyboard.append_global_keybindings({

    awful.key {
        modifiers = { mod },
        key = "t",
        group = "client",
        description = "toggle titlebar",
        on_press = function(c)
            if client.focus then
                local c = client.focus
                titlebar.cycle(c)
            end
        end,
    },

    awful.key {
        modifiers = { mod },
        key = "ö",
        group = "tag",
        description = "add",
        on_press = function()
            awful.tag.add("", { screen = awful.screen.focused(), layout = awful.layout.suit.tile }):view_only()
        end,
    },

    awful.key {
        modifiers = { mod, shift },
        key = "ö",
        group = "tag",
        description = "add",
        on_press = function()
            lain.util.delete_tag()
        end,
    },

    awful.key {
        modifiers = { mod },
        key = ",",
        group = "layout",
        description = "increase gaps",
        on_press = function()
            lain.util.useless_gaps_resize(1)
        end,
    },

    awful.key {
        modifiers = { mod, shift },
        key = ",",
        group = "layout",
        description = "increase gaps",
        on_press = function()
            lain.util.useless_gaps_resize(-1)
        end,
    },

    awful.key {
        modifiers = { mod, alt },
        key = "f",
        group = "client",
        description = "start editing machi",
        on_press = function()
            machi.default_editor.start_interactive()
        end,
    },

    awful.key {
        modifiers = { mod, alt },
        key = "a",
        group = "client",
        description = "add to tabbed",
        on_press = function()
            bling.module.tabbed.pick()
        end,
    },

    awful.key {
        modifiers = { mod, alt },
        key = "s",
        group = "client",
        description = "switch tabbed",
        on_press = function()
            bling.module.tabbed.iter()
        end,
    },

    awful.key {
        modifiers = { mod, alt },
        key = "d",
        group = "client",
        description = "remove from tabbed",
        on_press = function()
            bling.module.tabbed.pop()
        end,
    },

    awful.key {
        modifiers = { mod },
        key = "p",
        group = "awesome",
        description = "show keybindings",
        on_press = hotkeys_popup.show_help
    },

    awful.key {
        modifiers = { mod, shift },
        key = "r",
        group = "awesome",
        description = "reload awesome",
        on_press = awesome.restart
    },

    awful.key {
        modifiers = { mod, shift },
        key = "q",
        group = "awesome",
        description = "quit awesome",
        on_press = awesome.quit
    },

    awful.key {
        modifiers = { mod },
        key = "Return",
        group = "launcher",
        description = "terminal",
        on_press = function()
            awful.spawn(terminal)
        end,
    },

    awful.key {
        modifiers = { mod },
        key = "r",
        group = "launcher",
        description = "run prompt",
        on_press = function()
            awful.screen.focused().mypromptbox:run()
        end,
    },

    awful.key {
        modifiers = { mod },
        key = "a",
        group = "tag",
        description = "view previous",
        on_press = awful.tag.viewprev
    },

    awful.key {
        modifiers = { mod },
        key = "d",
        group = "tag",
        description = "view next",
        on_press = awful.tag.viewnext
    },

    awful.key {
        modifiers = { mod },
        key = "j",
        group = "client",
        description = "focus next",
        on_press = function()
            awful.client.focus.byidx(1)
        end,
    },

    awful.key {
        modifiers = { mod },
        key = "k",
        group = "client",
        description = "focus prev",
        on_press = function()
            awful.client.focus.byidx(-1)
        end,
    },

    awful.key {
        modifiers = { mod },
        key = "Tab",
        group = "client",
        description = "focus prev by history",
        on_press = function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
    },

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

    awful.key {
        modifiers = { mod,shift },
        key = "j",
        group = "client",
        description = "swap with next",
        on_press = function()
            awful.client.swap.byidx(1)
        end,
    },

    awful.key {
        modifiers = { mod,shift },
        key = "k",
        group = "client",
        description = "swap with prev",
        on_press = function()
            awful.client.swap.byidx(-1)
        end,
    },

    awful.key {
        modifiers = { mod,shift },
        key = "u",
        group = "client",
        description = "jump to urgent",
        on_press = awful.client.urgent.jumpto
    },

    awful.key {
        modifiers = { mod },
        key = "h",
        group = "layout",
        description = "decrease master width",
        on_press = function()
            awful.tag.incmwfact(-0.05)
        end,
    },

    awful.key {
        modifiers = { mod },
        key = "l",
        group = "layout",
        description = "increase master width",
        on_press = function()
            awful.tag.incmwfact(0.05)
        end,
    },

    awful.key {
        modifiers = { mod,shift },
        key = "h",
        group = "layout",
        description = "increase number of master clients",
        on_press = function()
            awful.tag.incnmaster(1, nil, true)
        end,
    },

    awful.key {
        modifiers = { mod,shift },
        key = "l",
        group = "layout",
        description = "decrease number of master clients",
        on_press = function()
            awful.tag.incnmaster(-1, nil, true)
        end,
    },

    awful.key {
        modifiers = { mod,ctrl },
        key = "h",
        group = "layout",
        description = "increase number of columns",
        on_press = function()
            awful.tag.incncol(1, nil, true)
        end,
    },

    awful.key {
        modifiers = { mod,ctrl },
        key = "l",
        group = "layout",
        description = "decrease number of columns",
        on_press = function()
            awful.tag.incncol(-1, nil, true)
        end,
    },

    awful.key {
        modifiers = { mod },
        key = "space",
        group = "layout",
        description = "select next layout",
        on_press = function()
            awful.layout.inc(1)
        end,
    },

    awful.key {
        modifiers   = { mod },
        keygroup    = "numrow",
        description = "view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },

    awful.key {
        modifiers = { mod, shift },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },

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

    awful.key {
        modifiers = { mod, shift },
        key = "space",
        group = "client",
        description = "toggle floating",
        on_press = awful.client.floating.toggle
    },

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

    awful.key {
        modifiers = { mod },
        key = "y",
        group = "launcher",
        description = "nerd font picker",
        on_press = function()
            awful.spawn.with_shell("nerdy")
        end,
    },

    awful.key {
        modifiers = { mod },
        key = "F10",
        group = "launcher",
        description = "volume up",
        on_press = function()
            helpers.volume_control(5)
        end,
    },

    awful.key {
        modifiers = { mod },
        key = "F9",
        group = "launcher",
        description = "volume down",
        on_press = function()
            helpers.volume_control(-5)
        end,
    },

})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ mod }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ mod }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)
