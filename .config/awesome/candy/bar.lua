local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local helpers = require("helpers")
local lain = require("lain")
local dpi = beautiful.xresources.apply_dpi

-- create a container widget with background
local bl = function(widget, clr)
    return wibox.widget {
        widget,
        bg = clr,
        widget = wibox.container.background
    }
end

-- create a container widget with margin
local mr = function(widget)
    return wibox.widget {
        widget,
        top = dpi(6),
        bottom = dpi(6),
        right = dpi(6),
        left = dpi(6),
        widget = wibox.container.margin
    }
end

-- create a container widget with margin for bigger items
local mrl = function(widget)
    return wibox.widget {
        widget,
        top = dpi(8),
        bottom = dpi(8),
        right = dpi(8),
        left = dpi(8),
        widget = wibox.container.margin
    }
end

-- create a text box widget
local tb = function(markup)
    return wibox.widget {
        font = beautiful.nfont .. "12",
        markup = markup,
        widget = wibox.widget.textbox
    }
end

local cpu = lain.widget.cpu {
    settings = function()
        widget:set_markup(" " .. cpu_now.usage .. "%")
    end
}

local mem = lain.widget.mem {
    settings = function()
        widget:set_markup(" " .. mem_now.perc .. "%")
    end
}

local disk = lain.widget.fs {
    settings = function()
        widget:set_text(" " ..  fs_now["/home"].percentage .. "%")
    end
}

local volume = lain.widget.pulse {
    settings = function()
        widget:set_text(" " ..  volume_now.left .. "%")
    end
}

local mysystray = wibox.widget.systray()

mysystray:set_base_size(beautiful.systray_icon_size)

local mysystray_container = {
    mysystray,
    left = dpi(4),
    right = dpi(4),
    widget = wibox.container.margin
}

local systray = wibox.widget {
    {
        mysystray_container,
        top = dpi(3),
        layout = wibox.container.margin
    },
    widget = wibox.container.background
}

local noti_toggle = wibox.widget {
    markup = "",
    font = beautiful.ifont .. "20",
    widget = wibox.widget.textbox
}

dont_disturb = false

noti_toggle:buttons(gears.table.join(
    awful.button({}, 1, function()
        dont_disturb = true
        noti_toggle.markup = ""
    end),
    awful.button({}, 3, function()
        dont_disturb = false
        noti_toggle.markup = ""
    end)
))

local sep = helpers.horizontal_pad(dpi(5))

local s = awful.screen.focused()

screen.connect_signal("request::desktop_decoration", function(s)

    s.mytextclock = wibox.widget.textclock()

    s.mylayoutbox = awful.widget.layoutbox(s)

    s.mypromptbox = awful.widget.prompt {
        prompt = " "
    }

    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        style = {
            font = beautiful.ifont .. "24"
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
                top = 5,
                bottom = 5,
                left  = 10,
                right = 10,
                widget = wibox.container.margin
            },
            id     = "background_role",
            widget = wibox.container.background,
        },
    }

    s.mytasklist = awful.widget.tasklist {
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
        style    = {
            font = beautiful.nfont .. "10",
            bg = x.color0j
        },
        layout   = { layout  = wibox.layout.flex.horizontal },
        widget_template = {
            {
                {
                    id     = "text_role",
                    align  = "center",
                    widget = wibox.widget.textbox,
                },
                forced_width = dpi(220),
                left = dpi(15),
                right = dpi(15),
                top  = dpi(4),
                bottom = dpi(4),
                widget = wibox.container.margin
            },
            id = "background_role",
            widget = wibox.container.background,
        },
    }

    -- Create the wibox
    s.mywibox = awful.wibar({
        position = "top",
        screen = s
    })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {
            layout = wibox.layout.fixed.horizontal,
            bl(s.mytaglist, x.color0),
            bl(s.mypromptbox, x.color0),
            bl(s.mytasklist, x.bg),
        },
        {
            layout = wibox.layout.fixed.horizontal,
            bl(mr(s.mytextclock), x.color0),
        },
        {
            layout = wibox.layout.fixed.horizontal,
            bl(mr(disk.widget), x.color1 .. "60"),
            sep,
            bl(mr(mem.widget), x.color2 .. "60"),
            sep,
            bl(mr(cpu.widget), x.color3 .. "60"),
            sep,
            bl(mr(volume.widget), x.color4 .. "60"),
            sep,
            bl(mrl(s.mylayoutbox), x.color5 .. "60"),
            sep,
            bl(mr(noti_toggle), x.color1 .. "60"),
            sep,
            bl(mr(systray), x.color6 .. "99"),
            sep,
        },
    }

end)

client.connect_signal("manage", function(c)
    if c.fullscreen then
        s.mywibox.visible = false
    else
        s.mywibox.visible = true
    end
end)

client.connect_signal("focus", function(c)
    if c.fullscreen then
        s.mywibox.visible = false
    else
        s.mywibox.visible = true
    end
end)

client.connect_signal("property::fullscreen", function(c)
    if c.fullscreen then
        s.mywibox.visible = false
    else
        s.mywibox.visible = true
    end
end)
