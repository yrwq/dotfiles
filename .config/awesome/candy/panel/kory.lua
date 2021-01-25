local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")

local popupLib = require("candy.popupLib")

local box_radius = dpi(10)
local box_gap = dpi(8)

local function create_boxed_widget(widget_to_be_boxed, width, height, bg_color)
    local box_container = wibox.container.background()
    box_container.bg = bg_color
    box_container.forced_height = height
    box_container.forced_width = width
    box_container.shape = helpers.rrect(box_radius)

    local boxed_widget = wibox.widget {
        {
            {
                nil,
                {
                    nil,
                    widget_to_be_boxed,
                    layout = wibox.layout.align.vertical,
                    expand = "none"
                },
                layout = wibox.layout.align.horizontal
            },
            widget = box_container
        },
        margins = box_gap,
        color = "#FF000000",
        widget = wibox.container.margin
    }
    return boxed_widget
end

-- Helper function that changes the appearance of progress bars and their icons
-- Create horizontal rounded bars
local function format_progress_bar(bar, markup)
    local text = wibox.widget {
        markup = markup,
        align = 'center',
        valign = 'center',
        font = beautiful.nfont .. '12',
        widget = wibox.widget.textbox
    }
    text.forced_height = dpi(36)
    text.forced_width = dpi(36)
    text.resize = true
    bar.forced_width = dpi(215)
    bar.shape = gears.shape.rounded_bar
    bar.bar_shape = gears.shape.rounded_bar

    -- bar.forced_height = dpi(30)
    -- bar.paddings = dpi(4)
    -- bar.border_width = dpi(2)
    -- bar.border_color = x.color8

    local w = wibox.widget {
        nil,
        {text, bar, spacing = dpi(10), layout = wibox.layout.fixed.horizontal},
        expand = "none",
        layout = wibox.layout.align.horizontal
    }
    return w
end

-- File system bookmarks
local function create_bookmark(name, path, color, hover_color)
    local bookmark = wibox.widget.textbox()
    bookmark.font = beautiful.nfont .. "20"
    -- bookmark.text = wibox.widget.textbox(name:sub(1,1):upper()..name:sub(2))
    bookmark.markup = helpers.colorize_text(name, color .. "80")
    bookmark.align = "center"
    bookmark.valign = "center"

    -- Buttons
    bookmark:buttons(gears.table.join(
        awful.button({ }, 1, function ()
            awful.spawn.with_shell(file_manager .. " " .. path)
        end),
        awful.button({ }, 3, function ()
            awful.spawn.with_shell(terminal .. " -e 'ranger' " .. path)
        end)
    ))

    -- Hover effect
    bookmark:connect_signal("mouse::enter", function ()
        bookmark.markup = helpers.colorize_text(name, color)
    end)
    bookmark:connect_signal("mouse::leave", function ()
        bookmark.markup = helpers.colorize_text(name, color .. "80")
    end)

    helpers.add_hover_cursor(bookmark, "hand1")

    return bookmark
end

-- Web bookmarks
local function create_web_bookmark(name, path, color, hover_color)
    local bookmark = wibox.widget.textbox()
    bookmark.font = beautiful.nfont .. "20"
    -- bookmark.text = wibox.widget.textbox(name:sub(1,1):upper()..name:sub(2))
    bookmark.markup = helpers.colorize_text(name, color .. "80")
    bookmark.align = "center"
    bookmark.valign = "center"

    -- Buttons
    bookmark:buttons(gears.table.join(
        awful.button({ }, 1, function ()
            awful.spawn.with_shell(web_browser .. " " .. path)
        end),
        awful.button({ }, 3, function ()
            awful.spawn.with_shell(web_browser2 .. " " .. path)
        end)
    ))

    -- Hover effect
    bookmark:connect_signal("mouse::enter", function ()
        bookmark.markup = helpers.colorize_text(name, color)
    end)
    bookmark:connect_signal("mouse::leave", function ()
        bookmark.markup = helpers.colorize_text(name, color .. "80")
    end)

    helpers.add_hover_cursor(bookmark, "hand1")

    return bookmark
end

local volume_bar = require("widgets.volume_bar")
local volume = format_progress_bar(volume_bar, helpers.colorize_text("", x.color1))

local cpu_bar = require("widgets.cpu_bar")
local cpu = format_progress_bar(cpu_bar, helpers.colorize_text("", x.color1))

local ram_bar = require("widgets.ram_bar")
local ram = format_progress_bar(ram_bar, helpers.colorize_text("ﱳ", x.color1))

volume:buttons(gears.table.join(
                   awful.button({}, 1, function() helpers.volume_control(0) end),
                   awful.button({}, 4, function() helpers.volume_control(5) end),
                   awful.button({}, 5, function() helpers.volume_control(-5) end)))

local sys = wibox.widget {
    volume,
    cpu,
    ram,
    layout = wibox.layout.flex.vertical
}

local sys_box = create_boxed_widget(sys, 400, 150, x.color0)

-- local weather = require("widget.weather")

local fortune_widget = require("widgets.fortune")
local fortune_box = create_boxed_widget(fortune_widget, 400, 80, x.color0)

local weather = require("widgets.weather")
local disk = require("widgets.disk_arc")

local disk_box = create_boxed_widget(disk, 200, 120, x.color0)
local weather_box = create_boxed_widget(weather, 200, 120, x.color0)

local bookmarks = wibox.widget {
    create_bookmark("", os.getenv("HOME"), x.color1),
    create_bookmark("", dir.download, x.color2),
    create_bookmark("", dir.config, x.color3),
    create_bookmark("", dir.picture, x.color4),
    create_bookmark("", dir.dev, x.color5),
    create_bookmark("", dir.doc, x.color6),
    spacing = dpi(10),
    layout = wibox.layout.flex.horizontal
}

local bookmarks_box = create_boxed_widget(bookmarks, 80, 80, x.color0)

local web_bookmarks = wibox.widget {
    create_web_bookmark("", "https://github.com", x.color1),
    create_web_bookmark("", "https://spotify.com", x.color2),
    create_web_bookmark("", "https://youtube.com", x.color3),
    create_web_bookmark("", "https://dmdamedia.hu", x.color4),
    create_web_bookmark("", "https://duckduckgo.com", x.color5),
    create_web_bookmark("", "https://doc.rust-lang.org/book", x.color6),
    spacing = dpi(10),
    layout = wibox.layout.flex.horizontal
}

local web_bookmarks_box = create_boxed_widget(web_bookmarks, 80, 80, x.color0)

local music = require("widgets.mpd")
local music_box = create_boxed_widget(music, 400, 330, x.color0)

local panelWidget = wibox.widget {
    {
        {
            weather_box,
            disk_box,
            layout = wibox.layout.flex.horizontal
        },
        fortune_box,
        sys_box,
        layout = wibox.layout.align.vertical,
    },
    music_box,
    {
        bookmarks_box,
        web_bookmarks_box,
        layout = wibox.layout.flex.vertical,
    },
    layout = wibox.layout.align.vertical
}

local width = 400
local margin = 10

local panelPop = popupLib.create(10, beautiful.wibar_height + margin,
                                nil,
                                width,
                                panelWidget,
                                dpi(25),
                                false, true, false, false)

return panelPop
