local awful = require("awful")
local helpers = require("helpers")

-- launchers
awful.keyboard.append_global_keybindings({
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
    -- volume up 
    awful.key {
        modifiers = { mod },
        key = "F10",
        group = "launcher",
        description = "volume up",
        on_press = function()
            helpers.volume_control(5)
        end,
    },
    -- volume down
    awful.key {
        modifiers = { mod },
        key = "F9",
        group = "launcher",
        description = "volume down",
        on_press = function()
            helpers.volume_control(-5)
        end,
    },
    -- nerd font picker
    awful.key {
        modifiers = { mod },
        key = "y",
        group = "launcher",
        description = "nerd font picker",
        on_press = function()
            awful.spawn.with_shell("nerdy")
        end,
    },
    -- discord
    awful.key {
        modifiers = { mod, shift },
        key = "o",
        group = "launcher",
        description = "discord",
        on_press = function()
            helpers.run_or_raise({class = "discord"},
                false, "discocss", { switchtotag = true })
        end,
    },
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
    -- read a man page
    awful.key {
        modifiers = { mod },
        key = ",",
        group = "launcher",
        description = "man page chooser",
        on_press = function()
            awful.spawn.with_shell("manp")
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

