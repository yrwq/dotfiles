local awful = require("awful")

-- layout related keybindings
awful.keyboard.append_global_keybindings({
    -- decrease master width
    awful.key {
        modifiers = { mod },
        key = "h",
        group = "layout",
        description = "decrease master width",
        on_press = function()
            awful.tag.incmwfact(-0.05)
        end,
    },
    -- increase master width
    awful.key {
        modifiers = { mod },
        key = "l",
        group = "layout",
        description = "increase master width",
        on_press = function()
            awful.tag.incmwfact(0.05)
        end,
    },
    -- incrase number of master clients
    awful.key {
        modifiers = { mod,shift },
        key = "h",
        group = "layout",
        description = "increase number of master clients",
        on_press = function()
            awful.tag.incnmaster(1, nil, true)
        end,
    },
    -- decrase number of master clients
    awful.key {
        modifiers = { mod,shift },
        key = "l",
        group = "layout",
        description = "decrease number of master clients",
        on_press = function()
            awful.tag.incnmaster(-1, nil, true)
        end,
    },
    -- increase number of columns
    awful.key {
        modifiers = { mod,ctrl },
        key = "h",
        group = "layout",
        description = "increase number of columns",
        on_press = function()
            awful.tag.incncol(1, nil, true)
        end,
    },
    -- decrease number of columns
    awful.key {
        modifiers = { mod,ctrl },
        key = "l",
        group = "layout",
        description = "decrease number of columns",
        on_press = function()
            awful.tag.incncol(-1, nil, true)
        end,
    },
})
