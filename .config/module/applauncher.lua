local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")
local icons = require("icons")
local apps = require("apps")
local keybinds = {}

local function create_button(symbol, color, hover_color, cmd, key)
    local icon = wibox.widget {
        markup = helpers.colorize_text(symbol, color),
        align = "center",
        valign = "center",
        font = "Iosevka Nerd Font 50",
        forced_width = dpi(180),
        forced_height = dpi(200),
        widget = wibox.widget.textbox
    }

    -- Press "animation"
    icon:connect_signal("button::press", function(_, _, __, button)
        if button == 3 then
            icon.markup = helpers.colorize_text(symbol, hover_color.."55")
        end
    end)
    icon:connect_signal("button::release", function ()
        icon.markup = helpers.colorize_text(symbol, hover_color)
    end)

    -- Hover "animation"
    icon:connect_signal("mouse::enter", function ()
        icon.markup = helpers.colorize_text(symbol, hover_color)
    end)
    icon:connect_signal("mouse::leave", function ()
        icon.markup = helpers.colorize_text(symbol, color)
    end)

    -- Change cursor on hover
    helpers.add_hover_cursor(icon, "hand1")

    -- Adds mousebinds if cmd is provided
    if cmd then
        icon:buttons(gears.table.join(
            awful.button({ }, 1, function ()
                cmd()
            end),
            awful.button({ }, 3, function ()
                cmd()
            end)
        ))
    end

    -- Add keybind to dict, if given
    if key then
        keybinds[key] = cmd
    end

    return icon
end

-- Create app buttons
local browser = create_button("爵", x.color8, x.fg, apps.browser, "q")
local discord = create_button("ﭮ", x.color8, x.fg, apps.discord, "w")
local calcurse = create_button("", x.color8, x.fg, apps.calcurse, "e")
local mail = create_button("", x.color8, x.fg, apps.mail, "r")
local file_manager = create_button("", x.color8, x.fg, apps.file_manager, "a")
local editor = create_button("", x.color8, x.fg, apps.editor, "s")
local music = create_button("", x.color8, x.fg, apps.music, "d")
local todo = create_button("", x.color8, x.fg, apps.todo, "f")
local lxappearance = create_button("嗀", x.color8, x.fg, apps.lxappearance, "y")
local volume = create_button("奔", x.color8, x.fg, apps.volume, "x")
local nitrogen = create_button("", x.color8, x.fg, apps.nitrogen, "c")
local torrent = create_button("", x.color8, x.fg, apps.torrent, "v")
local abook = create_button("", x.color8, x.fg, apps.abook, "u")

-- Create the widget
app_drawer = wibox({visible = false, ontop = true, type = "dock"})
awful.placement.maximize(app_drawer)

app_drawer.bg = "#0f0f0fA0"
app_drawer.fg = "#FEFEFE"

-- Add app drawer or mask to each screen
for s in screen do
    if s == screen.primary then
        s.app_drawer = app_drawer
    else
        s.app_drawer = helpers.screen_mask(s, x.bg)
    end
end

local function set_visibility(v)
    for s in screen do
        s.app_drawer.visible = v
    end
end

local app_drawer_grabber
function app_drawer_hide()
    awful.keygrabber.stop(app_drawer_grabber)
    set_visibility(false)
end

function app_drawer_show()
    -- naughty.notify({text = "starting the keygrabber"})
    app_drawer_grabber = awful.keygrabber.run(function(_, key, event)
        local invalid_key = false

        -- Debug
        -- naughty.notify({ title = event, text = key })
        -- if event == "press" and key == "Alt_L" or key == "Alt_R" then
        --     naughty.notify({ title = "you pressed alt" })
        -- end
        -- if event == "release" and key == "Alt_L" or key == "Alt_R" then
        --     naughty.notify({ title = "you released alt" })
        -- end

        if event == "release" then return end

        if keybinds[key] then
            keybinds[key]()
        else
            invalid_key = true
        end

        if not invalid_key or key == 'Escape' then
            app_drawer_hide()
        end
    end)

    set_visibility(true)
end

app_drawer:buttons(gears.table.join(
    -- Left click - Hide app_drawer
    awful.button({ }, 1, function ()
        app_drawer_hide()
    end),
    -- Right click - Hide app_drawer
    awful.button({ }, 2, function ()
        app_drawer_hide()
    end),
    -- Middle click - Hide app_drawer
    awful.button({ }, 2, function ()
        app_drawer_hide()
    end)
))

local function create_stripe(widgets, bg)
    local buttons = wibox.widget {
        -- spacing = dpi(20),
        layout = wibox.layout.fixed.horizontal
    }

    for _, widget in ipairs(widgets) do
        buttons:add(widget)
    end

    local stripe = wibox.widget {
        {
            nil,
            {
                nil,
                buttons,
                expand = "none",
                layout = wibox.layout.align.horizontal
            },
            expand = "none",
            layout = wibox.layout.align.vertical
        },
        bg = bg,
        widget = wibox.container.background
    }

    return stripe
end

app_drawer:setup {
    -- Background
    {
        -- Stripes
        create_stripe({ browser, discord, calcurse, mail}, "#00000000"),
        create_stripe({ file_manager, editor, music, todo }, "#00000000"),
        create_stripe({ lxappearance, volume, nitrogen, torrent}, "#00000000"),
        create_stripe({ abook}, "#00000000"),
        layout = wibox.layout.flex.vertical
    },
    bg = x.bg .. "A0",
    widget = wibox.container.background
}
