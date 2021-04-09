local awful = require("awful")
local scratch = require("utils.scratch")

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
    }
})
