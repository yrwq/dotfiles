local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

local notif_center = require("candy.notif-center")
local sidebar = require("candy.sidebar")
local start_menu = require("candy.start")

require("awful.hotkeys_popup.keys")

-- popups
awful.keyboard.append_global_keybindings({
    -- start menu
    awful.key {
        modifiers = { mod },
        key = "s",
        group = "popup",
        description = "start menu",
        on_press = function()
            if start_menu.x < -1 then
	            start_show()
            else
                start_hide()
            end
        end,
    },
    -- show key bindings in a popup
    awful.key {
        modifiers = { mod },
        key = "p",
        group = "popup",
        description = "keybindings",
        on_press = hotkeys_popup.show_help
    },
    -- toggle bar
    awful.key {
        modifiers = { mod },
        key = "b",
        on_press = function()
            toggle_bar()
        end,
    },
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
            if sidebar.x < -1 then
	            sidebar_show()
            else
                sidebar_hide()
            end
        end,
    }
})
