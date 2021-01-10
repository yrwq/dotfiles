local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local ruled = require("ruled")

require("candy.notifs.brightness")
require("candy.notifs.desktop_brightness")
require("candy.notifs.volume")

naughty.config.defaults.icon_size = beautiful.notification_icon_size or dpi(100)
naughty.config.defaults.ontop = true
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 3
naughty.config.defaults.title = beautiful.notification_title or "System Notification"
naughty.config.defaults.margin = beautiful.notification_margin or dpi(20)
naughty.config.defaults.border_width = dpi(0)
naughty.config.defaults.border_color = beautiful.notification_border_color or x.bg
naughty.config.defaults.position = beautiful.notification_position or "top_middle"
naughty.config.padding = beautiful.notification_padding or dpi(10)
naughty.config.spacing = beautiful.notification_spacing or dpi(5)

naughty.config.icon_dirs = { "/usr/share/icons/Papirus-Dark/24x24/apps/", "/usr/share/pixmaps/"
}
naughty.config.icon_formats = {"png", "svg"}

-- Timeouts
naughty.config.presets.low.timeout = 3
naughty.config.presets.critical.timeout = 0

naughty.config.presets.normal = {
    font = beautiful.nfont .. "12",
    fg = x.fg,
    bg = x.color0
}

naughty.config.presets.low = {
    font = beautiful.nfont .. "12",
    fg = x.fg,
    bg = x.bg
}

naughty.config.presets.critical = {
    font = beautiful.nfont .. "12",
    fg = x.fg,
    bg = x.color8,
    timeout = 0
}

ruled.notification.connect_signal('request::rules', function()
    -- Add a red background for urgent notifications.
    ruled.notification.append_rule {
        rule       = { urgency = 'critical' },
        properties = { bg = x.color8, fg = x.fg, timeout = 3 }
    }

    -- Or green background for normal ones.
    ruled.notification.append_rule {
        rule       = { urgency = 'normal' },
        properties = { bg = x.color0, fg = x.fg, timeout = 3}
    }

    ruled.notification.append_rule {
        rule       = { urgency = 'low' },
        properties = { bg = x.bg, fg = x.fg, timeout = 3}
    }
end)

naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical

beautiful.notification_bg = "#00000000"

local default_icon = ""

local app_config = {
    ['discord'] = { icon = "", title = true },
    ['mail'] = { icon = "", title = false },
    ['theme'] = { icon = "嗀", title = true },
    ['music'] = { icon = "", title = false },
    ['colorpicker'] = { icon = "", title = false },
    ['git'] = { icon = "", title = false },
    ['scr'] = { icon = "", title = false },
    ['bar'] = { icon = "鸞", title = false },
    ['rec'] = { icon = "", title = false },
    ['torrent'] = { icon = "", title = false },
    ['comp'] = { icon = "", title = false },
    ['redshift'] = { icon = "嗀", title = false },
}

local urgency_color = {
    ['low'] = x.color2,
    ['normal'] = x.color4,
    ['critical'] = x.color11,
}

naughty.connect_signal("request::display", function(n)

    -- Custom icon widget
    -- It can be used instead of naughty.widget.icon if you prefer your icon to be
    -- a textbox instead of an image. However, you have to determine its
    -- text/markup value from the notification before creating the
    -- naughty.layout.box.
    local custom_notification_icon = wibox.widget {
        font = beautiful.ifont .. "30",
        align = "center",
        valign = "center",
        widget = wibox.widget.textbox
    }

    local icon, title_visible
    local color = urgency_color[n.urgency]
    -- Set icon according to app_name
    if app_config[n.app_name] then
        icon = app_config[n.app_name].icon
        title_visible = app_config[n.app_name].title
    else
        icon = default_icon
        title_visible = true
    end

    local actions = wibox.widget {
        notification = n,
        base_layout = wibox.widget {
            spacing = dpi(3),
            layout = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id = 'text_role',
                        font = beautiful.notification_font,
                        widget = wibox.widget.textbox
                    },
                    left = dpi(6),
                    right = dpi(6),
                    widget = wibox.container.margin
                },
                widget = wibox.container.place
            },
            bg = x.color8.."32",
            forced_height = dpi(25),
            forced_width = dpi(70),
            widget = wibox.container.background
        },
        style = {
            underline_normal = false,
            underline_selected = true
        },
        widget = naughty.list.actions
    }

    naughty.layout.box {
        notification = n,
        type = "notification",
        -- For antialiasing: The real shape is set in widget_template
        shape = gears.shape.rectangle,
        border_width = beautiful.notification_border_width,
        border_color = beautiful.notification_border_color,
        position = beautiful.notification_position,
        widget_template = {
            {
                {
                    {
                        {
                            markup = helpers.colorize_text(icon, color),
                            align = "center",
                            valign = "center",
                            widget = custom_notification_icon,
                        },
                        forced_width = dpi(50),
                        bg = x.color0,
                        widget  = wibox.container.background,
                    },
                    {
                        {
                            {
                                align = "center",
                                visible = title_visible,
                                font = beautiful.notification_font,
                                markup = "<b>"..n.title.."</b>",
                                widget = wibox.widget.textbox,
                                -- widget = naughty.widget.title,
                            },
                            {
                                align = "center",
                                -- wrap = "char",
                                widget = naughty.widget.message,
                            },
                            {
                                helpers.vertical_pad(dpi(10)),
                                {
                                    actions,
                                    shape = helpers.rrect(dpi(4)),
                                    widget = wibox.container.background,
                                },
                                visible = n.actions and #n.actions > 0,
                                layout  = wibox.layout.fixed.vertical
                            },
                            layout  = wibox.layout.align.vertical,
                        },
                        margins = beautiful.notification_margin,
                        widget  = wibox.container.margin,
                    },
                    layout  = wibox.layout.fixed.horizontal,
                },
                strategy = "max",
                width    = beautiful.notification_max_width or dpi(350),
                height   = beautiful.notification_max_height or dpi(180),
                widget   = wibox.container.constraint,
            },
            -- Anti-aliasing container
            shape = helpers.rrect(beautiful.notification_border_radius),
            bg = x.color0,
            widget = wibox.container.background
        }
    }
end)

naughty.disconnect_signal("request::display", naughty.default_notification_handler)
