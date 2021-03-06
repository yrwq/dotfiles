local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local ruled = require("ruled")
local naughty = require("naughty")
local menubar = require("menubar")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

naughty.config.defaults.icon_size = dpi(100)
naughty.config.defaults.ontop = true
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 5
naughty.config.defaults.title = "System Notification"

naughty.config.defaults.border_color = x.color8
naughty.config.defaults.border_width = dpi(5)

naughty.config.defaults.position = "top_right"
naughty.config.padding = dpi(40)
naughty.config.spacing = dpi(40)
naughty.config.defaults.margin = dpi(40)

naughty.config.presets.normal = {
    timeout = 5,
    font = beautiful.nfont .. "12",
    fg = x.fg,
    bg = x.color0
}

naughty.config.presets.low = {
    timeout = 5,
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
        properties = { bg = x.color0, fg = x.fg, timeout = 5 }
    }

    -- Or green background for normal ones.
    ruled.notification.append_rule {
        rule       = { urgency = 'normal' },
        properties = { bg = x.bg, fg = x.fg, timeout = 5}
    }

    ruled.notification.append_rule {
        rule       = { urgency = 'low' },
        properties = { bg = x.bg, fg = x.fg, timeout = 5}
    }
end)


naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical

naughty.connect_signal("request::display", function(n)

    -- Actions Blueprint
    local actions_template = wibox.widget {
        notification = n,
        base_layout = wibox.widget {
            spacing        = dpi(0),
            layout         = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        id     = "text_role",
                        font   = beautiful.nfont .. "10",
                        widget = wibox.widget.textbox
                    },
                    widget = wibox.container.place
                },
                bg                 = x.color0,
                shape              = gears.shape.rounded_rect,
                forced_height      = dpi(30),
                widget             = wibox.container.background
            },
            margins = dpi(4),
            widget  = wibox.container.margin
        },
        style = { underline_normal = false, underline_selected = true },
        widget = naughty.list.actions
    }

    local appicon = n.icon or n.app_icon
    if not appicon then
        appicon = notification_icon
        image_visib = false
        text_visib = true
    else
        image_visib = true
        text_visib = false
    end

    -- Notifbox Blueprint
    naughty.layout.box {
        notification = n,
        type = "notification",
        screen = awful.screen.preferred(),
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
                                                    image = appicon,
                                                    visible = image_visib,
                                                    forced_width = dpi(100),
                                                    forced_height = dpi(50),
                                                    resize = true,
                                                    widget = wibox.widget.imagebox,
                                                },
                                                margins = beautiful.notification_margin,
                                                widget  = wibox.container.margin,
                                            },
                                            {
                                                {
                                                    markup = helpers.colorize_text(" ", x.fg),
                                                    font = beautiful.nfont .. "20",
                                                    visible = text_visib,
                                                    widget = wibox.widget.textbox,
                                                },
                                                margins = beautiful.notification_margin,
                                                widget  = wibox.container.margin,
                                            },
                                            {
                                                {
                                                    layout = wibox.layout.align.vertical,
                                                    expand = "none",
                                                    nil,
                                                    {
                                                        {
                                                            align = "center",
                                                            widget = naughty.widget.title
                                                        },
                                                        {
                                                            align = "center",
                                                            widget = naughty.widget.message,
                                                        },
                                                        layout = wibox.layout.fixed.vertical
                                                    },
                                                    nil
                                                },
                                                margins = beautiful.notification_margin,
                                                widget  = wibox.container.margin,
                                            },
                                            layout = wibox.layout.fixed.horizontal,
                                        },
                                        fill_space = true,
                                        spacing = beautiful.notification_margin,
                                        layout  = wibox.layout.fixed.vertical,
                                    },
                                    margins = dpi(10),
                                    widget  = wibox.container.margin,
                                },
                                bg = x.trans,
                                widget  = wibox.container.background,
                            },
                            -- Actions
                            actions_template,
                            spacing = dpi(0),
                            layout  = wibox.layout.fixed.vertical,
                        },
                        bg     = x.trans,
                        id     = "background_role",
                        widget = naughty.container.background,
                    },
                    strategy = "min",
                    widget   = wibox.container.constraint,
                },
                strategy = "max",
                widget   = wibox.container.constraint
            },
            bg = x.bg,
            widget = wibox.container.background
        }
    }

    if dont_disturb == true then
        naughty.destroy_all_notifications(nil, 1)
    end

end
)
