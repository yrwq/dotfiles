local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local helpers = require("helpers")
local lain = require("lain")
local keys = require("keys")
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

local volume = wibox.widget {
    markup = " ",
    widget = wibox.widget.textbox
}

awesome.connect_signal("shit::volume", function(vol, muted)
    if muted then
        volume.markup = helpers.colorize_text("muted", x.fg)
    else
        if vol then
            volume.markup = helpers.colorize_text("vol " .. vol .. "%", x.fg)
        else
            volume.markup = helpers.colorize_text(" %", x.fg)
        end
    end
end)

local weather = wibox.widget {
    markup = "望",
    widget = wibox.widget.textbox
}

awesome.connect_signal("shit::weather", function(temp, wind, emoji)
    weather.markup = helpers.colorize_text("摒 " .. temp .. "", x.fg)
end)

local music = wibox.widget {
    forced_width = dpi(200),
    align = "center",
    widget = wibox.widget.textbox,
}

music:buttons(gears.table.join(
    awful.button({}, 1, function()
        helpers.music("toggle")
    end)
))

awesome.connect_signal("shit::mpd", function(artist, title, paused)
    if not paused then
        music.markup = helpers.colorize_text(artist .. " - " .. title, x.fg)
    else
        music.markup = helpers.colorize_text("", x.fg)
    end
end)

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
        dont_disturb = not dont_disturb
        update_disturb()
    end)
))
function update_disturb()
    if dont_disturb then
        noti_toggle.markup = ""
    else
        noti_toggle.markup = ""
    end
end


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
        buttons = keys.tasklist_buttons,
        screen   = s,
        filter   = awful.widget.tasklist.filter.currenttags,
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
                forced_width = dpi(180),
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
    s.fullbar = awful.wibar {
        visible = false,
        position = "top",
        screen = s
    }

    s.floatbar = awful.wibar {
        position = "top",
        screen = s
    }

    -- Add widgets to the wibox
    s.floatbar:setup {
        layout = wibox.layout.align.horizontal,
        expand = "none",
        {
            bl(s.mytaglist, x.color0),
            bl(s.mytasklist, x.bg),
            bl(s.mypromptbox, x.color0),
            layout = wibox.layout.fixed.horizontal,
        },
        {
            bl(mr(s.mytextclock), x.color0),
            sep,
            layout = wibox.layout.fixed.horizontal,
        },
        {
            bl(mr(music), x.color0),
            sep,
            bl(mr(weather), x.color0),
            sep,
            bl(mr(volume), x.color0),
            sep,
            bl(mr(noti_toggle), x.color0),
            sep,
            bl(mrl(s.mylayoutbox), x.color0),
            sep,
            bl(mr(systray), x.color8),
            sep,
            layout = wibox.layout.fixed.horizontal,
        },
    }

    -- Add widgets to the wibox
    s.fullbar:setup {
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
            bl(mr(s.mytextclock), x.bg),
        },
        {
            layout = wibox.layout.fixed.horizontal,
            bl(mr(music), x.color1 .. "60"),
            sep,
            bl(mr(weather), x.color2 .. "60"),
            sep,
            bl(mr(disk.widget), x.color3 .. "60"),
            sep,
            bl(mr(volume), x.color1 .. "60"),
            sep,
            bl(mrl(s.mylayoutbox), x.color4 .. "60"),
            sep,
            bl(mr(noti_toggle), x.color5 .. "60"),
            sep,
            bl(mr(systray), x.color6 .. "99"),
            sep,
        },
    }

end)

client.connect_signal("property::fullscreen", function(c)
    if c.fullscreen then
        s.fullbar.visible = false
        s.floatbar.visible = false
    else
        -- s.fullbar.visible = true
        s.floatbar.visible = true
    end
end)

function toggle_bar()
    -- s.floatbar.visible = false
    -- s.fullbar.visible = not s.fullbar.visible
    s.floatbar.visible = not s.floatbar.visible
end

function switch_bar_mode()
    s.fullbar.visible = not s.fullbar.visible
    s.floatbar.visible = not s.floatbar.visible
end
