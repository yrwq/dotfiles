local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local helpers = require("helpers")
local pad = helpers.pad

local todos = wibox.widget {
	font = "Iosevka Term 10",
	align = "center",
	valign = "center",
	markup = "todo",
	widget = wibox.widget.textbox
}

local main_wd = wibox.widget {
	{
		todos,
		layout = wibox.layout.fixed.vertical
	},
    shape = helpers.rrect(dpi(6)),
    bg = "#2e2e2e",
    widget = wibox.container.margin
}

local script = [[bash -c '
cat ~/.config/todos
']]

local function update_widget()
    awful.spawn.easy_async(script, function(stdout)

        local to = stdout

        -- Escape &'s
        to = string.gsub(to, "&", "&amp;")

        todos.markup = "<span foreground='" .. "#efefef" .. "'>" .. to .. "</span>"

        collectgarbage()
    end)
end

update_widget()

local mpd_script = [[
  bash -c '
  	cat ~/.config/todos
  ']]

awful.spawn.with_line_callback(mpd_script, {
    stdout = function(line)
            update_widget()
    end
})

return main_wd
