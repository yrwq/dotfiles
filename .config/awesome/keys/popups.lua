local awful = require("awful")
local notif_center = require("candy.notif-center")
local hotkeys_popup = require("awful.hotkeys_popup")
local sidebar = require("candy.sidebar")
require("awful.hotkeys_popup.keys")

-- require("keys")

-- mod = "Mod4"
-- ctrl = "Control"
-- shift = "Shift"
-- alt = "Mod1"

-- popups
awful.keyboard.append_global_keybindings({
    -- show key bindings in a popup
    awful.key {
        modifiers = { mod },
        key = "p",
        group = "awesome",
        description = "show keybindings",
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
            sidebar.visible = not sidebar.visible
        end,
    }
})
