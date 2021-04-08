local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local helpers = require("helpers")
local naughty = require("naughty")
local lgi = require("lgi")
local bling = require("bling")

local width = 300
local height = 600

--
-- header 
--

local prof_pic = {
    image = "/home/yrwq/etc/pic/prof.jpeg",
    resize = true,
    clip_shape = helpers.circle(dpi(150)),
    forced_height = dpi(150),
    forced_width = dpi(150),
    widget = wibox.widget.imagebox
}

local name_header = {
    markup = "<b>Inhof Dávid</b>",
    valign = "center",
    align = "center",
    font = beautiful.nfont .. "20",
    widget = wibox.widget.textbox
}

local user_name = {
    markup = helpers.colorize_text("@yrwq", x.color15),
    font = beautiful.nfont .. "16",
    valign = "center",
    align = "center",
    widget = wibox.widget.textbox
}

local sidebar_header = {
    nil,
    {
        {
            prof_pic,
            helpers.vertical_pad(dpi(10)),
            name_header,
            helpers.vertical_pad(dpi(5)),
            user_name,
            layout = wibox.layout.fixed.vertical
        },
        top = dpi(20),
        widget = wibox.container.margin
    },
    expand = "none",
    layout = wibox.layout.align.horizontal,
}

--
-- quote
--

local fortune_command = "fortune -n 50 -s computers"
local fortune_update_interval = 3600

local fortune = wibox.widget {
    font = beautiful.nfont .. "12",
    text = "Loading your cookie...",
    valign = "center",
    align = "center",
    widget = wibox.widget.textbox
}

local update_fortune = function()
    awful.spawn.easy_async_with_shell(fortune_command, function(out)
        -- Remove trailing whitespaces
        out = out:gsub('^%s*(.-)%s*$', '%1')
        fortune.markup = "<i>"..helpers.colorize_text(out, x.fg).."</i>"
    end)
end

gears.timer {
    autostart = true,
    timeout = fortune_update_interval,
    single_shot = false,
    call_now = true,
    callback = update_fortune
}

local fortune_widget = wibox.widget {
    {
        {
            nil,
            fortune,
            layout = wibox.layout.align.horizontal,
        },
        margins = dpi(15),
        widget = wibox.container.margin
    },
    forced_height = dpi(100),
    shape = helpers.rrect(dpi(5)),
    bg = x.color8,
    widget = wibox.container.background
}

fortune_widget:buttons(gears.table.join(
    -- Left click - New fortune
    awful.button({ }, 1, update_fortune)
))

helpers.add_hover_cursor(fortune_widget, "hand1")

--
-- music control
--

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
        shape = helpers.rrect(dpi(5)),
        bg = x.color8,
        widget = wibox.container.background,
    },
    layout = wibox.layout.fixed.vertical
}

--
-- search web
--

local search_text = wibox.widget {
    valign = "center",
    align = "center",
    font = beautiful.nfont .. "12",
    markup = helpers.colorize_text("Search the web", x.color7),
    widget = wibox.widget.textbox
}

local search_icon = wibox.widget {
    valign = "center",
    align = "center",
    font = beautiful.nfont .. "12",
    markup = helpers.colorize_text(" ", x.color7),
    widget = wibox.widget.textbox
}

local search = wibox.widget{
    {
        {
            search_icon,
            search_text,
            layout = wibox.layout.align.horizontal
        },
        left = dpi(10),
        widget = wibox.container.margin
    },
    forced_height = dpi(35),
    forced_width = dpi(200),
    bg = x.color8,
    shape = helpers.rrect(dpi(5)),
    widget = wibox.container.background()
}

--
-- build
--

local sidebar = wibox.widget {
    {
        sidebar_header,
        helpers.vertical_pad(dpi(30)),
        fortune_widget,
        layout = wibox.layout.fixed.vertical
    },
    {
        helpers.vertical_pad(dpi(10)),
        music,
        layout = wibox.layout.fixed.vertical
    },
    {
        helpers.vertical_pad(dpi(10)),
        search,
        layout = wibox.layout.fixed.vertical
    },
	forced_width = width,
	forced_height = height,
    spacing = dpi(10),
    layout = wibox.layout.fixed.vertical
}

--
-- popup
--

local sidebar_popup = awful.popup {
    widget = {
        sidebar,
        margins = dpi(20),
        widget  = wibox.container.margin
    },
    bg = x.color0,
    shape = helpers.prrect(dpi(10), false, true, true, false),
    ontop = true,
    placement = awful.placement.left,
    visible = false
}

function sidebar_activate_prompt()
    awful.prompt.run {
        prompt = 'Search: ',
        textbox = search_text,
        font = beautiful.nfont .. "10",
        done_callback = function()
            sidebar_popup.visible = false
        end,
        exe_callback = function(input)
            if not input or #input == 0 then return end
            awful.spawn.with_shell("noglob brave https://google.com/search?q=" .. input)
        end
    }
end

search:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        sidebar_activate_prompt()
    end)
))

local mouseInPopup = false
local timer = gears.timer {
    timeout = 0.75,
    single_shot = true,
    callback = function()
        if not mouseInPopup then
            sidebar_popup.visible = false
        end
    end
}

sidebar_popup:connect_signal("mouse::leave", function()
    if sidebar_popup.visible then
        mouseInPopup = false
        timer:again()
    end
end)

sidebar_popup:connect_signal("mouse::enter", function()
    mouseInPopup = true
end)

local sidebar_activator = wibox({
    y = 1, width = 1,
    visible = true, ontop = false,
    opacity = 0, below = true
})

sidebar_activator.height = height
sidebar_activator:connect_signal("mouse::enter", function ()
    sidebar_popup.visible = true

end)
awful.placement.left(sidebar_activator)

return sidebar_popup
