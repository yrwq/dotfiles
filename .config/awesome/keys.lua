local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local bling = require("bling")
local helpers = require("helpers")
local naughty = require("naughty")
local gears = require("gears")
local scratch = require("utils.scratch")
require("awful.hotkeys_popup.keys")
local notif_center = require("candy.notif-center")
local sidebar = require("candy.sidebar")
local dashboard = require("candy.dashboard")

local keys = {}

-- define modifiers
mod = "Mod4"
ctrl = "Control"
shift = "Shift"
alt = "Mod1"

-- root window mouse bindings
awful.mouse.append_global_mousebindings({
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),
})

-- popups
awful.keyboard.append_global_keybindings({
    -- notification center
    awful.key {
        modifiers = { mod },
        key = "u",
        group = "popup",
        description = "notif_center",
        on_press = function()
            notif_center.visible = not notif_center.visible
        end,
    },
    -- dashboard
    awful.key {
        modifiers = { alt },
        key = "q",
        group = "popup",
        description = "dashboard",
        on_press = function()
            dashboard_show()
        end,
    },
    -- sidebar
    awful.key {
        modifiers = { mod },
        key = "é",
        group = "popup",
        description = "sidebar",
        on_press = function()
            sidebar.visible = not sidebar.visible
        end,
    }
})

-- scratchpads
awful.keyboard.append_global_keybindings({

    -- terminal
    awful.key {
        modifiers = { mod },
        key = "o",
        group = "scratchpad",
        description = "terminal",
        on_press = function()
            scratch.toggle("st -c scratch", { class = "scratch" })
        end,
    },

    -- music player
    awful.key {
        modifiers = { mod },
        key = "m",
        group = "scratchpad",
        description = "music player",
        on_press = function()
            scratch.toggle("st -c music -e ncmpcpp", { class = "music" })
        end,
    },

    -- discord
    awful.key {
        modifiers = { mod, shift },
        key = "o",
        group = "scratchpad",
        description = "discord",
        on_press = function()
            -- hack to automatically focus the message box
            scratch.toggle("discord", { class = "discord" })
            if client.focus then
                if client.focus.class == "discord" then
                    awful.spawn.with_shell("sleep 0.3; xdotool mousemove 600 850 click 1")
                end
            end
        end,
    },
})

-- launchers
awful.keyboard.append_global_keybindings({
    -- draw a floating terminal
    awful.key {
        modifiers = { mod, shift },
        key = "t",
        group = "launcher",
        description = "draw terminal",
        on_press = function()
            awful.spawn.with_shell("drawterm")
        end,
    },
    -- rofi meme picker script
    awful.key {
        modifiers = { mod, shift },
        key = "p",
        group = "launcher",
        description = "meme picker",
        on_press = function()
            awful.spawn.with_shell("chm")
        end,
    },
    -- font picker
    awful.key {
        modifiers = { mod, shift },
        key = "f",
        group = "launcher",
        description = "font picker",
        on_press = function()
            awful.spawn.with_shell("fpick")
        end,
    },
    awful.key {
        modifiers = { mod },
        key = "e",
        group = "launcher",
        description = "editor",
        on_press = function()
            awful.spawn(editor_cmd)
        end,
    },
    awful.key {
        modifiers = { mod },
        key = "r",
        group = "launcher",
        description = "file manager",
        on_press = function()
            awful.spawn.with_shell("st -c files -e lf")
        end,
    }
})

-- client manipulation
awful.keyboard.append_global_keybindings({
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

awful.keyboard.append_global_keybindings({

    -- toggle the bar
    awful.key {
        modifiers = { mod },
        key = "b",
        on_press = function()
            toggle_bar()
        end,
    },

    -- close notifications
    awful.key {
        modifiers = { ctrl },
        key = "space",
        group = "awesome",
        description = "close all notifications",
        on_press = function()
            naughty.destroy_all_notifications()
        end,
    },

    -- app launcher
    awful.key {
        modifiers = { mod },
        key = "s",
        group = "launcher",
        description = "application launcher",
        on_press = function(s)
            awful.spawn.with_shell("rofi -show drun")
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

    -- add a tag
    awful.key {
        modifiers = { mod },
        key = "ö",
        group = "tag",
        description = "add",
        on_press = function()
            awful.tag.add("", { screen = awful.screen.focused(), layout = awful.layout.suit.tile }):view_only()
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

    -- show key bindings in a popup
    awful.key {
        modifiers = { mod },
        key = "p",
        group = "awesome",
        description = "show keybindings",
        on_press = hotkeys_popup.show_help
    },

    -- restart awesomewm
    awful.key {
        modifiers = { mod, shift },
        key = "r",
        group = "awesome",
        description = "reload awesome",
        on_press = awesome.restart
    },

    -- quit awesomewm
    awful.key {
        modifiers = { mod, shift },
        key = "q",
        group = "awesome",
        description = "quit awesome",
        on_press = awesome.quit
    },

    -- launch terminal
    awful.key {
        modifiers = { mod },
        key = "Return",
        group = "launcher",
        description = "terminal",
        on_press = function()
            awful.spawn(terminal)
        end,
    },

    -- prev tag
    awful.key {
        modifiers = { mod },
        key = "a",
        group = "tag",
        description = "view previous",
        on_press = awful.tag.viewprev
    },

    -- next tag
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

    -- awful.key {
    --     modifiers = { mod },
    --     key = "space",
    --     group = "layout",
    --     description = "select next layout",
    --     on_press = function()
    --         awful.layout.inc(1)
    --     end,
    -- },

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

local timestamp = os.date("%b-%a_%d_%H:%M:%S")
local filename = os.getenv("HOME") .. "/etc/pic/shot/" .. timestamp .. ".png"

local screenshot_open = naughty.action { name = "Open" }
local screenshot_copy = naughty.action { name = "Copy" }
local screenshot_edit = naughty.action { name = "Edit" }
local screenshot_delete = naughty.action { name = "Delete" }

screenshot_open:connect_signal('invoked', function()
    awful.spawn.with_shell("sxiv " .. filename .. " >/dev/null")
end)

screenshot_copy:connect_signal('invoked', function()
    awful.spawn.with_shell("xclip -selection clipboard -t image/png " .. filename .. " &>/dev/null")
end)

screenshot_edit:connect_signal('invoked', function()
    awful.spawn.with_shell("gimp " .. filename .. " >/dev/null")
end)

screenshot_delete:connect_signal('invoked', function()
    awful.spawn.with_shell("rm " .. filename)
end)

awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers = { },
        key = "Print",
        on_press = function()
            cmd = "maim " .. filename
            awful.spawn.easy_async_with_shell(cmd, function()
                naughty.notification({
                    title = "Screenshot",
                    message = "Screenshot taken",
                    icon = filename,
                    actions = { screenshot_open, screenshot_copy, screenshot_edit, screenshot_delete },
                    app_name = "screenshot",
                })
            end)
        end,
    },

    awful.key {
        modifiers = { mod },
        key = "Print",
        on_press = function()
            cmd = "maim -s " .. filename
            awful.spawn.easy_async_with_shell(cmd, function()
                naughty.notification({
                    title = "Screenshot",
                    message = "Screenshot taken",
                    icon = filename,
                    actions = { screenshot_open, screenshot_copy, screenshot_edit, screenshot_delete },
                    app_name = "screenshot",
                })
            end)
        end,
    }
})

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

return keys
