local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")
local apps = require("apps")
local keybinds = {}

local function create_button(symbol, color, hover_color, cmd, key)
    local icon = wibox.widget {
        markup = helpers.colorize_text(symbol, color),
        align = "center",
        valign = "center",
        font = beautiful.ifont .. "50",
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
local browser = create_button("爵", x.color1, x.fg, apps.browser, "q")
local discord = create_button("", x.color2, x.fg, apps.discord, "w")
local mail = create_button("", x.color3, x.fg, apps.mail, "e")
local news = create_button("", x.color4, x.fg, apps.news, "r")
local lxappearance = create_button("嗀", x.color1, x.fg, apps.lxappearance, "a")
local volume = create_button("奔", x.color2, x.fg, apps.volume, "s")
local nitrogen = create_button("", x.color3, x.fg, apps.nitrogen, "d")
local yt = create_button("", x.color4, x.fg, apps.youtube, "f")
local todo = create_button("", x.color1, x.fg, apps.todo, "t")
local syncmail = create_button("﯍", x.color2, x.fg, apps.syncmail, "z")
local compositor = create_button("異", x.color1, x.fg, apps.compositor, "u")
local night_mode = create_button("望", x.color1, x.fg, apps.night_mode, "i")

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
        create_stripe({ browser, discord, mail, news}, x.color8 .. "99"),
        create_stripe({ lxappearance, volume, nitrogen, yt}, x.color0 .. "99"),
        create_stripe({ todo, syncmail, compositor, night_mode}, x.bg .. "99"),
        layout = wibox.layout.flex.vertical
}