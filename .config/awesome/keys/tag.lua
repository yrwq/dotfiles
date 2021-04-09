local awful = require("awful")

-- tag related keybindings
awful.keyboard.append_global_keybindings({
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
    -- view a tag
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
    -- move focused client to tag
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
})
