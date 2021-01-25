local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local ruled = require("ruled")
local naughty = require("naughty")
local menubar = require("menubar")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = beautiful.xresources.apply_dpi

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
                                                    markup = " ",
                                                    font = beautiful.nfont .. "40",
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
                                    -- Margin between the fake background
                                    -- Set to 0 to preserve the "titlebar" effect
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
                    width    = dpi(160),
                    widget   = wibox.container.constraint,
                },
                strategy = "max",
                width    = beautiful.notification_max_width or dpi(500),
                widget   = wibox.container.constraint
            },
            bg = x.bg,
            shape = gears.shape.rounded_rect,
            widget = wibox.container.background
        }
    }

    -- Destroy popups if dont_disturb mode is on
    -- Or if the right_panel is visible
    local focused = awful.screen.focused()
    if _G.dont_disturb or
        (focused.right_panel and focused.right_panel.visible) then
        naughty.destroy_all_notifications(nil, 1)
    end

end
)
