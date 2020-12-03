local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local helpers = require("helpers")
local pad = helpers.pad

local title_color = x.fg
local artist_color = x.fg
local paused_color = x.color8
local artist_fg
local artist_bg
local seek_state = false
local icon_font_nerd = "Iosevka Nerd Font 16"

local bar = wibox.widget {
    value = 64,
    max_value = 100,
    forced_height = dpi(8),
    forced_width = dpi(180),
    color = {
        type = 'linear',
        from = {0, 0},
        to = {200, 50}, -- replace with w,h later
        stops = {{0, x.color5}, {0.50, x.color1}}
    },
    background_color = "#4e4e4e",
    shape = helpers.rrect(dpi(6)),
    bar_shape = helpers.rrect(dpi(6)),
    widget = wibox.widget.progressbar
}

local bar_timer = gears.timer {
    timeout = 3,
    call_now = true,
    autostart = true,
    callback = function()
        awful.spawn.easy_async_with_shell("mpc -f '%time%'", function(stdout)
            bar.value = tonumber(stdout:match('[(]+(%d+)'))
        end)
    end
}

local mpd_title = wibox.widget {
	font = "Iosevka Term 10",
	align = "center",
	valign = "center",
	markup = "Title",
	widget = wibox.widget.textbox
}
local mpd_artist = wibox.widget {
	font = "Iosevka Term 14",
	align = "center",
	valign = "center",
	markup = "Artist",
	widget = wibox.widget.textbox
}

local main_wd = wibox.widget {
	{
		mpd_artist,
		mpd_title,
		{
			bar,
			top = dpi(10),
			right = dpi(50),
			left = dpi(50),
			widget = wibox.container.margin
		},
		layout = wibox.layout.fixed.vertical
	},
    shape = helpers.rrect(dpi(6)),
    bg = "#2e2e2e",
    widget = wibox.container.margin
}

main_wd:buttons(gears.table.join(
	awful.button({ }, 1, function()
		awful.spawn.with_shell("mpc toggle")
	end),
	awful.button({ }, 3, function()
		awful.spawn.with_shell("mpc next")
	end),
	awful.button({ }, 4, function()
		awful.spawn.with_shell("mpc seek +5%")
	end),
	awful.button({ }, 5, function()
		awful.spawn.with_shell("mpc seek -5%")
	end)
))

local script = [[bash -c '
  file=`mpc current -f %file%`
  info=`mpc -f "%artist%@@%title%@"`
  echo $info"##"$cover"##"
']]

-- update widget on song change
local function update_widget()
    awful.spawn.easy_async(script, function(stdout)

        bar_timer:emit_signal("timeout")

        local artist = stdout:match('(.*)@@')
        local title = stdout:match('@@(.*)@')
        local status = stdout:match('%[(.*)%]')
        status = string.gsub(status, '^%s*(.-)%s*$', '%1')

        local artist_span = "> " .. artist .. ""
        local title_span = "" .. title .. ""

        if status == "paused" then
            bar_timer:stop()
            artist_fg = paused_color
            title_fg = paused_color
        else
            bar_timer:start()
            artist_fg = artist_color
            title_fg = title_color
        end

        -- Escape &'s
        title = string.gsub(title, "&", "&amp;")
        artist = string.gsub(artist, "&", "&amp;")

        mpd_title.markup = "<span foreground='" .. title_fg .. "'>" .. title ..
                               "</span>"
        mpd_artist.markup =
            "<span foreground='" .. artist_fg .. "'>" .. artist .. "</span>"

        collectgarbage()
    end)
end

update_widget()

local mpd_script = [[
  bash -c '
    mpc idleloop player
  ']]

awful.spawn.with_line_callback(mpd_script, {
    stdout = function(line)
        if (seek_state) then
            seek_state = false
        else
            update_widget()
        end
    end
})

return main_wd
