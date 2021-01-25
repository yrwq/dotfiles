local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local helpers = require("helpers")
local apps = require("apps")
local pad = helpers.pad

-- Appearance
local icon_font = beautiful.ifont .. "45"

local scr_whole_icon = beautiful.scr_whole_icon or ""
local scr_sel_icon = beautiful.scr_sel_icon or "濾"
local scr_copy_icon = ""
local rec_whole_icon = beautiful.rec_whole_icon or ""

local button_bg = x.color0
local button_size = dpi(120)

-- Commands
local scr_whole_command = apps.screenshot_whole
local scr_sel_command = apps.screenshot_select
local scr_copy_command = apps.screenshot_copy
local rec_whole_command = apps.record_whole

-- Helper function that generates the clickable buttons
local create_button = function(symbol, hover_color, text, command)
    local icon = wibox.widget {
        forced_height = button_size,
        forced_width = button_size,
        align = "center",
        valign = "center",
        font = icon_font,
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

    -- Bind left click to run the command
    button:buttons(gears.table.join(
                       awful.button({}, 1, function() command() end)))

    -- Change color on hover
    button:connect_signal("mouse::enter", function()
        icon.markup = helpers.colorize_text(icon.text, hover_color)
        button.border_color = hover_color
    end)
    button:connect_signal("mouse::leave", function()
        icon.markup = helpers.colorize_text(icon.text, x.fg)
        button.border_color = button_bg
    end)

    -- Use helper function to change the cursor on hover
    helpers.add_hover_cursor(button, "hand1")

    return button
end

-- Create the buttons
local scr_whole = create_button(scr_whole_icon, x.color1, "Screenshot Whole Screen", scr_whole_command)
local scr_sel = create_button(scr_sel_icon, x.color1, "Screenshot Selected Area", scr_sel_command)
local scr_copy = create_button(scr_copy_icon, x.color1, "Screenshot and copy image to clip", scr_copy_command)
local rec_whole = create_button(rec_whole_icon, x.color3, "Record Whole Screen", rec_whole_command)

shot_screen = wibox({visible = false, ontop = true, type = "splash"})
awful.placement.maximize(shot_screen)

shot_screen.bg = beautiful.shot_screen_bg or "#111111"
shot_screen.fg = beautiful.shot_screen_fg or "#FEFEFE"

local shot_screen_grabber
function shot_screen_hide()
    awful.keygrabber.stop(shot_screen_grabber)
    shot_screen.visible = false
end
function shot_screen_show()
    shot_screen_grabber = awful.keygrabber.run(
                              function(_, key, event)
            -- Ignore case
            key = key:lower()

            if event == "release" then return end

            if key == 'q' then
                shot_screen_hide()
                scr_whole_command()
            elseif key == 'w' then
                shot_screen_hide()
                scr_copy_command()
            elseif key == 'e' then
                shot_screen_hide()
                scr_sel_command()
            elseif key == 'r' then
                shot_screen_hide()
                rec_whole_command()
            elseif key == 'escape' or key == 'x' then
                shot_screen_hide()
            end
        end)
    shot_screen.visible = true
end

shot_screen:buttons(gears.table.join(
    awful.button({}, 1, function() shot_screen_hide() end),
    awful.button({}, 2, function() shot_screen_hide() end),
    awful.button({}, 3, function() shot_screen_hide() end)
))

-- Item placement
shot_screen:setup{
    nil,
    {
        nil,
        {
            scr_whole,
            scr_copy,
            scr_sel,
            rec_whole,
            spacing = dpi(50),
            layout = wibox.layout.fixed.horizontal
        },
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    expand = "none",
    layout = wibox.layout.align.vertical
}
