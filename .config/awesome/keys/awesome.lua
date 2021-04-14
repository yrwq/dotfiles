local awful = require("awful")
local naughty = require("naughty")

-- wm related keybindings
awful.keyboard.append_global_keybindings({

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

})
