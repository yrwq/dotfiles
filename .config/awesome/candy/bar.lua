local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local helpers = require("helpers")
local keys = require("keys")
local dpi = beautiful.xresources.apply_dpi
local bling = require("bling")

local widget_fg = beautiful.bar_widget_fg

local volume = wibox.widget {
    markup = "",
    widget = wibox.widget.textbox
}

awesome.connect_signal("shit::volume", function(vol, muted)
    if muted then
        volume.markup = helpers.colorize_text("muted", widget_fg)
    else
        if vol then
            volume.markup = helpers.colorize_text("  " .. vol .. "%", widget_fg)
        else
            volume.markup = helpers.colorize_text("  ", widget_fg)
        end
    end
end)

local mysystray = wibox.widget.systray()

mysystray:set_base_size(beautiful.systray_icon_size)

local noti_toggle = wibox.widget {
    markup = helpers.colorize_text("", widget_fg),
    font = beautiful.ifont .. "20",
    widget = wibox.widget.textbox
}

dont_disturb = false

local notif_center = require("candy.notif-center")
noti_toggle:connect_signal("mouse::enter", function()
    notifcenter_show()
end)

noti_toggle:buttons(gears.table.join(
    awful.button({}, 1, function()
        dont_disturb = not dont_disturb
        update_disturb()
    end)
))

function update_disturb()
    if dont_disturb then
        noti_toggle.markup = helpers.colorize_text("", widget_fg)
    else
        noti_toggle.markup = helpers.colorize_text("", widget_fg)
    end
end

local sep = helpers.horizontal_pad(dpi(5))

local s = awful.screen.focused()

date_clock = wibox.widget.textclock(helpers.colorize_text("  %b %d %a", widget_fg))
time_clock = wibox.widget.textclock(helpers.colorize_text("  %H:%M", widget_fg))

screen.connect_signal("request::desktop_decoration", function(s)

    -- s.mytextclock = wibox.widget.textclock()

    s.mylayoutbox = awful.widget.layoutbox(s)

    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        style = {
            spacing = dpi(5),
            font = beautiful.nfont .. "12",
            shape = helpers.rrect(5)
        },
        widget_template = {
            {
                {
                    {
                        id     = "text_role",
                        widget = wibox.widget.textbox,
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = dpi(10),
                bottom = dpi(2),
                right = dpi(10),
                widget = wibox.container.margin
            },
            id     = "background_role",
            widget = wibox.container.background,
            create_callback = function(self, c3, index, objects)
                self:connect_signal("mouse::enter", function()
                    if #c3:clients() > 0 then
                        awesome.emit_signal("bling::tag_preview::update", c3)
                        awesome.emit_signal("bling::tag_preview::visibility", s, true)
                    end
                end)
                self:connect_signal("mouse::leave", function()
                    awesome.emit_signal("bling::tag_preview::visibility", s, false)
                end)
            end,
        },
        buttons = taglist_buttons
    }

    s.mytasklist = awful.widget.tasklist {
        buttons = keys.tasklist_buttons,
        screen   = s,
        filter   = awful.widget.tasklist.filter.focused,
        style    = {
            font = beautiful.nfont .. "10",
            bg = x.bg
        },
        layout   = { layout  = wibox.layout.flex.horizontal },
        widget_template = {
            {
                {
                    id     = "text_role",
                    align  = "center",
                    widget = wibox.widget.textbox,
                },
                forced_width = dpi(200),
                left = dpi(15),
                right = dpi(15),
                top  = dpi(4),
                bottom = dpi(4),
                widget = wibox.container.margin
            },
            widget = wibox.container.background,
        },
    }

    -- create a new bar
    s.bar = awful.wibar {
        position = "top",
        screen = s
    }

    -- Add widgets to the wibox
    s.bar:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {
            {
                {
                    s.mytaglist,
                    margins = dpi(5),
                    widget = wibox.container.margin
                },
                widget = wibox.container.constraint
            },
            layout = wibox.layout.fixed.horizontal,
        },

        {
            s.mytasklist,
            layout = wibox.layout.fixed.horizontal,
        },
        {
            {
                {
                    {
                        volume,
                        right = dpi(10),
                        left = dpi(10),
                        widget = wibox.container.margin
                    },
                    shape = helpers.rrect(dpi(5)),
                    bg = x.color1,
                    widget = wibox.container.background,
                },
                margins = dpi(3),
                widget = wibox.container.margin
            },
            {
                {
                    {
                        s.mylayoutbox,
                        right = dpi(10),
                        left = dpi(10),
                        top = dpi(5),
                        bottom = dpi(5),
                        widget = wibox.container.margin
                    },
                    shape = helpers.rrect(dpi(5)),
                    bg = x.color2,
                    widget = wibox.container.background,
                },
                margins = dpi(3),
                widget = wibox.container.margin
            },
            {
                {
                    {
                        date_clock,
                        right = dpi(10),
                        left = dpi(10),
                        top = dpi(5),
                        bottom = dpi(5),
                        widget = wibox.container.margin
                    },
                    shape = helpers.rrect(dpi(5)),
                    bg = x.color3,
                    widget = wibox.container.background,
                },
                margins = dpi(3),
                widget = wibox.container.margin
            },
            {
                {
                    {
                        time_clock,
                        right = dpi(10),
                        left = dpi(10),
                        top = dpi(5),
                        bottom = dpi(5),
                        widget = wibox.container.margin
                    },
                    shape = helpers.rrect(dpi(5)),
                    bg = x.color3,
                    widget = wibox.container.background,
                },
                margins = dpi(3),
                widget = wibox.container.margin
            },
            {
                {
                    {
                        mysystray,
                        right = dpi(10),
                        left = dpi(10),
                        top = dpi(4),
                        widget = wibox.container.margin
                    },
                    shape = helpers.rrect(dpi(5)),
                    bg = x.color5,
                    widget = wibox.container.background,
                },
                margins = dpi(3),
                widget = wibox.container.margin
            },
            {
                {
                    {
                        noti_toggle,
                        right = dpi(10),
                        left = dpi(10),
                        widget = wibox.container.margin
                    },
                    shape = helpers.rrect(dpi(5)),
                    bg = x.color12,
                    widget = wibox.container.background,
                },
                margins = dpi(3),
                widget = wibox.container.margin
            },
            layout = wibox.layout.fixed.horizontal,
        },
    }
end)

client.connect_signal("property::fullscreen", function(c)
    if c.fullscreen then
        s.bar.visible = false
    else
        -- s.fullbar.visible = true
        s.bar.visible = true
    end
end)

function toggle_bar()
    s.bar.visible = not s.bar.visible
end
