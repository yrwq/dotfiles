local awful = require("awful")
local helpers = require("helpers")
local spawn = awful.spawn

-- launchers
awful.keyboard.append_global_keybindings({

    -- increase brightness
    awful.key {
        modifiers = { mod },
        key = "F3",
        group = "launcher",
        description = "increase brightness",
        on_press = function()
            spawn.with_shell("bri i")
        end,
    },

    -- decrease brightness
    awful.key {
        modifiers = { mod },
        key = "F2",
        group = "launcher",
        description = "decrease brightness",
        on_press = function()
            spawn.with_shell("bri d")
        end,
    },

    -- launch terminal
    awful.key {
        modifiers = { mod },
        key = "Return",
        group = "launcher",
        description = "terminal",
        on_press = function()
            spawn(config.apps.terminal)
        end,
    },

    -- rofi
    awful.key {
        modifiers = { mod, shift },
        key = "s",
        group = "launcher",
        description = "rofi",
        on_press = function()
            spawn.with_shell("rofi -show drun")
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
            awesome.emit_signal("widget::volume")
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
            awesome.emit_signal("widget::volume")
        end,
    },

    -- nerd font picker
    awful.key {
        modifiers = { mod },
        key = "y",
        group = "launcher",
        description = "nerd font picker",
        on_press = function()
            spawn.with_shell("nerdy")
        end,
    },

    -- discord
    awful.key {
        modifiers = { mod, shift },
        key = "o",
        group = "launcher",
        description = "discord",
        on_press = config.apps.discord,
    },

    -- draw a floating terminal
    awful.key {
        modifiers = { mod, shift },
        key = "t",
        group = "launcher",
        description = "draw terminal",
        on_press = function()
            spawn.with_shell("drawterm")
        end,
    },

    -- read a man page
    awful.key {
        modifiers = { mod },
        key = ",",
        group = "launcher",
        description = "man page chooser",
        on_press = function()
            spawn.with_shell("manp")
        end,
    },

    -- rofi meme picker script
    awful.key {
        modifiers = { mod, shift },
        key = "p",
        group = "launcher",
        description = "meme picker",
        on_press = function()
            spawn.with_shell("chm")
        end,
    },

    -- font picker
    awful.key {
        modifiers = { mod, shift },
        key = "f",
        group = "launcher",
        description = "font picker",
        on_press = function()
            spawn.with_shell("fpick")
        end,
    },

    -- editor
    awful.key {
        modifiers = { mod },
        key = "e",
        group = "launcher",
        description = "editor",
        on_press = function()
            spawn(config.apps.editor)
        end,
    },

    -- file manager
    awful.key {
        modifiers = { mod },
        key = "r",
        group = "launcher",
        description = "file manager",
        on_press = function()
            spawn(config.apps.file_manager)
        end,
    }
})

