local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local ruled = require("ruled")
local naughty = require("naughty")
local menubar = require("menubar")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

naughty.config.defaults.icon_size = dpi(80)
naughty.config.defaults.ontop = true
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = "Notification"
naughty.config.defaults.position = "bottom_right"
naughty.config.defaults.border_width = dpi(0)

naughty.config.presets.normal = {
    timeout = 5,
    font = beautiful.nfont .. "12",
    fg = x.fg,
    border_color = x.color3,
    bg = x.bg
}

naughty.config.presets.low = {
    timeout = 3,
    font = beautiful.nfont .. "12",
    fg = x.fg,
    border_color = x.color2,
    bg = x.bg
}

naughty.config.presets.critical = {
    font = beautiful.nfont .. "12",
    fg = x.fg,
    bg = x.bg,
    border_color = x.color1,
    timeout = 0
}


ruled.notification.connect_signal('request::rules', function()
    ruled.notification.append_rule {
        rule       = { urgency = 'critical' },
        properties = {
            bg = x.bg,
            fg = x.fg,
            border_color = x.color1,
            timeout = 0
        }
    }

    -- Or green background for normal ones.
    ruled.notification.append_rule {
        rule       = { urgency = 'normal' },
        properties = {
            bg = x.bg,
            fg = x.fg,
            border_color = x.color3,
            timeout = 5
        }
    }

    ruled.notification.append_rule {
        rule       = { urgency = 'low' },
        properties = {
            bg = x.bg,
            fg = x.fg,
            border_color = x.color2,
            timeout = 3
        }
    }
end)


naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical


-- For antialiasing
-- The real background color is set in the widget_template
beautiful.notification_bg = "#00000000"

local default_icon = ""

local app_config = {
    ['volume'] = { icon = "" },
    ['screenshot'] = { icon = "" },
    ['Telegram Desktop'] = { icon = "" },
    ['email'] = { icon = "" },
    ['discord'] = { icon = "ﭮ" },
    ['weather'] = { icon = "摒" },
}

local urgency_color = {
    ['low'] = x.color2,
    ['normal'] = x.fg,
    ['critical'] = x.color1,
}

local bg_color = {
    ['low'] = x.bg,
    ['normal'] = x.bg,
    ['critical'] = x.bg,
}

naughty.connect_signal("request::display", function(n)

    local custom_notification_icon = wibox.widget {
        font = beautiful.ifont .. "22",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local icon

    local color = urgency_color[n.urgency]
    local bg_c = bg_color[n.urgency]

    if app_config[n.app_name] then
        icon = app_config[n.app_name].icon
    else
        icon = default_icon
    end

    title = n.title or ""

    -- naughty.actions template
    local actions_template = wibox.widget {
        notification = n,
        base_layout = wibox.widget {
            spacing = 5,
            layout = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id = 'text_role',
                        beautiful.nfont .. "8",
                        widget = wibox.widget.textbox
                    },
                    widget = wibox.container.place
                },
                bg = x.color0,
                shape = helpers.rrect(dpi(5)),
                forced_height = dpi(30),
                widget = wibox.container.background,
            },
            margins = dpi(3),
            widget = wibox.container.margin,
        },
        style = { underline_normal = false, underline_selected = true },
        widget = naughty.list.actions
    }

    -- Custom notification layout
    naughty.layout.box {
        notification = n,
        type = "notification",
        screen = awful.screen.focused(),
        shape = gears.shape.rectangle,
        widget_template = {
            {
                {
                    {
                        {
                            {
                                {
                                    {
                                        {
                                            {
                                                {
                                                    {
                                                        {
                                                            markup = helpers.colorize_text(icon, color),
                                                            resize_strategy = 'center',
                                                            font = beautiful.ifont .. "28",
                                                            align = 'center',
                                                            valign = 'center',
                                                            widget = wibox.widget.textbox
                                                        },
                                                        right = dpi(10),
                                                        left = dpi(10),
                                                        widget = wibox.container.margin,
                                                    },
                                                    bg = x.color0,
                                                    widget = wibox.container.background
                                                },
                                                {
                                                    {
                                                        layout = wibox.layout.align.vertical,
                                                        expand = 'none',
                                                        nil,
                                                        {
                                                            {
                                                                align = "center",
                                                                valign = "center",
                                                                font = beautiful.nfont .. "12",
                                                                markup = "<b>" .. title .. "</b>",
                                                                widget = wibox.widget.textbox
                                                            },
                                                            {
                                                                align = "center",
                                                                valign = 'center',
                                                                font = beautiful.nfont .. "10",
                                                                widget = naughty.widget.message,
                                                            },
                                                            layout = wibox.layout.fixed.vertical
                                                        },
                                                        nil
                                                    },
                                                    margins = dpi(15),
                                                    widget = wibox.container.margin,
                                                },
                                                fill_space = true,
                                                layout = wibox.layout.fixed.horizontal,
                                            },
                                            fill_space = true,
                                            spacing = dpi(5),
                                            layout = wibox.layout.fixed.vertical,
                                        },
                                        -- Margin between the fake background
                                        -- Set to 0 to preserve the 'titlebar' effect
                                        margins = 0,
                                        widget = wibox.container.margin,
                                    },
                                    bg = bgc,
                                    widget = wibox.container.background,
                                },
                                -- Notification action list
                                -- naughty.list.actions,
                                actions_template,
                                spacing = dpi(0),
                                layout = wibox.layout.fixed.vertical,
                            },
                            bg = bgc,
                            id = "background_role",
                            widget = naughty.container.background,
                        },
                        strategy = "min",
                        width = dpi(160),
                        widget = wibox.container.constraint,
                    },
                    strategy = "max",
                    width = dpi(300),
                    height = dpi(100),
                    widget = wibox.container.constraint,
                },
                -- Anti-aliasing container
                -- Real BG
                bg = "#00000000",
                -- This will be the anti-aliased shape of the notification
                shape = helpers.rrect(dpi(10)),
                border_width = dpi(2),
                border_color = color,
                widget = wibox.container.background
            },
            -- Margin of the fake BG to have a space between notification and the screen edge
            right = dpi(10),
            bottom = dpi(20),
            widget = wibox.container.margin
        }
    }

end)
