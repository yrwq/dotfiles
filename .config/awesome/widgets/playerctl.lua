local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local lgi = require("lgi")

local music_header = wibox.widget {
    markup = "<b>Now playing</b>",
    font = beautiful.nfont .. "16",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

local music_title = wibox.widget {
    markup = helpers.colorize_text("<b>Now playing</b>", x.color15),
    font = beautiful.nfont .. "14",
    align = "center",
    valign = "center",
    forced_height = dpi(40),
    widget = wibox.widget.textbox
}

local Playerctl = lgi.Playerctl
local player = Playerctl.Player{}

update_metadata = function()
    if player:get_title() then
        if string.match(player:get_title(), player:get_artist()) then
            music_title.markup = helpers.colorize_text(player:get_title(), x.color15)
        else
            music_title.markup = helpers.colorize_text(player:get_artist() .. " - " .. player:get_title(), x.color15)
        end
    else
        music_title.markup = helpers.colorize_text("Nothing playing", x.color15)
    end
end
player.on_metadata = update_metadata

update_metadata()

local music_prev = wibox.widget {
    markup = "玲",
    font = beautiful.ifont .. "16",
    widget = wibox.widget.textbox
}

local music_toggle = wibox.widget {
    markup = "契",
    font = beautiful.ifont .. "16",
    widget = wibox.widget.textbox
}

local music_next = wibox.widget {
    markup = "怜",
    font = beautiful.ifont .. "16",
    widget = wibox.widget.textbox
}

helpers.add_hover_cursor(music_prev, "hand1")
helpers.add_hover_cursor(music_next, "hand1")
helpers.add_hover_cursor(music_toggle, "hand1")

music_prev:connect_signal("button::press", function()
    awful.spawn.with_shell("playerctl previous")
end)

music_next:connect_signal("button::press", function()
    awful.spawn.with_shell("playerctl next")
end)

local status_cmd = "playerctl status -F"
local playing = "false"

update_status = function()
    awful.spawn.easy_async({
            "pkill", "--full", "--uid", os.getenv("USER"), "^playerctl status" }, function()
        awful.spawn.with_line_callback(status_cmd, {
            stdout = function(line)
                if line:find("Playing") then
                    playing = "true"
                    music_toggle.markup = ""
                else
                    playing = "false"
                    music_toggle.markup = "契"
                end
            end
        })
        collectgarbage("collect")
    end)
end

update_status()

music_toggle:connect_signal("button::press", function()
    awful.spawn.with_shell("playerctl play-pause")
    update_status()
end)


local music_control = {
    nil,
    {
        {
            music_prev,
            music_toggle,
            music_next,
            spacing = dpi(30),
            layout = wibox.layout.fixed.horizontal
        },
        widget = wibox.container.margin
    },
    expand = "none",
    layout = wibox.layout.align.horizontal,
}

local music = wibox.widget {
    {
        {
            {
                music_header,
                music_title,
                music_control,
                spacing = dpi(10),
                layout = wibox.layout.fixed.vertical
            },
            margins = dpi(15),
            widget = wibox.container.margin,
        },
        widget = wibox.container.background,
    },
    layout = wibox.layout.fixed.vertical
}

return music
