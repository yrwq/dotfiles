local awful = require("awful")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local gears = require("gears")
local watch = require("awful.widget.watch")

local get_todo_cmd = "awtodo -g"
local remove_todos = "awtodo -r"
local add_todo = [[bash -c '
	todo=$(rofi -dmenu)
	echo $todo >> ~/.config/todos
']]


local todo_list = wibox.widget {
		widget = wibox.widget.textbox,
		font = "Iosevka Term 10",
		markup = "",
		color = x.fg,
}

local widget_todo  = wibox.widget {
	{
		todo_list,
		margins = dpi(20),
		widget = wibox.container.margin,
	},
	layout = wibox.layout.fixed.vertical,
}

local function update_todos()
	awful.spawn.easy_async(get_todo_cmd, function(stdout)
		local todos = stdout

		todo_list:set_markup_silently(todos)
		collectgarbage()
	end)
end

widget_todo:buttons(gears.table.join(
	awful.button({ }, 1, function()
		awful.spawn.easy_async_with_shell(add_todo, function(widget, stdout, stderr, _, _)
			widget.markup = string.match(stdout)
    	end, todo_list)
		update_todos()
	end),
	awful.button({ }, 2, function()
		update_todos()
	end),
	awful.button({ }, 3, function()
		awful.spawn.with_shell(remove_todos)
		update_todos()
	end),
	awful.button({ }, 4, function()
		update_todos()
	end),
	awful.button({ }, 5, function()
		update_todos()
	end)
))

awful.spawn.easy_async_with_shell(
	awful.spawn.with_line_callback(
		get_todo_cmd,
			{
				stdout = function(line)
					update_todos()
				end
			}
		)
)

update_todos()

-- Refreshes Widget every minute
function widget_todo.init()
	watch(get_todo_cmd, 1,
		function(widget, stdout, stderr, _, _)
			widget.markup = string.match(stdout, ".+")

		end,
		todo_list)
end

return widget_todo
