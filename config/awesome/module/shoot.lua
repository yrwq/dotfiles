
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")
local pad = helpers.pad

-- appearance
local record_text_icon = ""
local picture_text_icon = ""
local stoprec_text_icon = "壘"
local selpic_text_icon = "麗"
local button_bg = x.color0
local button_size = dpi(120)
local shoot_screen_bg = x.bg .. 95

-- commands
-- record
local record_command = function()
    awful.spawn.with_shell("rec")
end

-- full screen picture
local picture_command = function()
    awful.spawn.with_shell("lien -s -f")
end

-- stop recording
local stoprec_command = function()
    awful.spawn.with_shell("rec'")
end

local selpic_command = function()
	awful.spawn.with_shell("lien -a -f")
end

local create_button = function(symbol, hover_color, text, command)
    local icon = wibox.widget {
        forced_height = button_size,
        forced_width = button_size,
        align = "center",
        valign = "center",
        font = "Monofur Nerd Font Mono 45",
        text = symbol,
        widget = wibox.widget.textbox()
    }

    local button = wibox.widget {
        {nil, icon, expand = "none", layout = wibox.layout.align.horizontal},
        forced_height = button_size,
        forced_width = button_size,
        border_width = dpi(3),
        border_color = button_bg,
        shape = helpers.rrect(10),
        bg = button_bg,
        widget = wibox.container.background
    }

    button:buttons(gears.table.join(
                        awful.button({}, 1, function() command() end)))

        button:connect_signal("mouse::enter", function()
            icon.markup = helpers.colorize_text(icon.text, hover_color)
            button.border_color = hover_color
        end)
        button:connect_signal("mouse::leave", function()
            icon.markup = helpers.colorize_text(icon.text, x.fg)
            button.border_color = button_bg
        end)

        helpers.add_hover_cursor(button, "hand1")

        return button
end

local picture = create_button(picture_text_icon, x.color1, "Picture", picture_command)
local record = create_button(record_text_icon,x.color1, "Record", record_command)
local stoprec = create_button(stoprec_text_icon,x.color1, "Stop recording", stoprec_command)
local selpic = create_button(selpic_text_icon,x.color1, "Select picture", selpic_command)

shoot_screen = wibox({visible = false, ontop = true})
awful.placement.maximize(shoot_screen)

shoot_screen.bg = shoot_screen_bg
shoot_screen.fg = x.foreground

local shoot_screen_grabber
function shoot_screen_hide()
    awful.keygrabber.stop(shoot_screen_grabber)
    shoot_screen.visible = false
end

function shoot_screen_show()
    shoot_screen_grabber = awful.keygrabber.run(
    function(_, key, event)

        key = key:lower()

        if event == "release" then return end

        if key == 'q' then
            shoot_screen_hide()
            record_command()
        elseif key == 'w' then
            shoot_screen_hide()
            picture_command()
        elseif key == 'e' then
            shoot_screen_hide()
            stoprec_command()
        elseif key == 'escape' or key == 'x' then
            shoot_screen_hide()
        end
    end)
    shoot_screen.visible = true
end

shoot_screen:buttons(gears.table.join(
awful.button({}, 1, function() shoot_screen_hide() end),
awful.button({}, 3, function() shoot_screen_hide() end)))

shoot_screen:setup{
    nil,
    {
        nil,
        {
            record,
            picture,
            stoprec,
			selpic,
            spacing = dpi(50),
            layout = wibox.layout.fixed.horizontal
        },
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    expand = "none",
    layout = wibox.layout.align.vertical
}
