local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local wibox = require("wibox")
local naughty = require("naughty")

local helpers = {}

-- Create rounded rectangle shape
helpers.rrect = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

-- Adds a maximized mask to a screen
function helpers.screen_mask(s, bg)
    local mask = wibox({
        visible = false,
        ontop = true,
        type = "splash",
        screen = s
    })
    awful.placement.maximize(mask)
    mask.bg = bg
    return mask
end

-- Create partially rounded rect
helpers.prrect = function(radius, tl, tr, br, bl)
    return function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
    end
end

-- create a circle
helpers.circle = function(radius)
    return function(cr)
        gears.shape.circle(cr, radius, radius)
    end
end

-- colorize markup text
helpers.colorize_text = function(text, color)
    return "<span foreground='" .. color .. "'>" .. text .. "</span>"
end

-- add vertical padding to a box
function helpers.vertical_pad(height)
    return wibox.widget{
        forced_height = height,
        layout = wibox.layout.fixed.vertical
    }
end

-- add horizontal padding to a box
function helpers.horizontal_pad(width)
    return wibox.widget{
        forced_width = width,
        layout = wibox.layout.fixed.horizontal
    }
end

-- Add a hover cursor to a widget by changing the cursor on
-- mouse::enter and mouse::leave
-- You can find the names of the available cursors by opening any
-- cursor theme and looking in the "cursors folder"
-- For example: "hand1" is the cursor that appears when hovering over
-- links
function helpers.add_hover_cursor(w, hover_cursor)
    local original_cursor = "left_ptr"

    w:connect_signal("mouse::enter", function ()
        local w = _G.mouse.current_wibox
        if w then
            w.cursor = hover_cursor
        end
    end)

    w:connect_signal("mouse::leave", function ()
        local w = _G.mouse.current_wibox
        if w then
            w.cursor = original_cursor
        end
    end)
end

-- control volume
function helpers.volume_control(step)
    local cmd
    if step == 0 then
        cmd = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
    else
        sign = step > 0 and "+" or ""
        cmd = "pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ "..sign..tostring(step).."%"
    end
    awful.spawn.with_shell(cmd)
end

-- run an application, or bring it to current tag if it's already open
function helpers.run_or_raise(match, move, spawn_cmd, spawn_args)

    local matcher = function (c)
        return awful.rules.match(c, match)
    end

    -- Find and raise
    local found = false
    for c in awful.client.iterate(matcher) do
        found = true
        c.minimized = false
        if move then
            c:move_to_tag(mouse.screen.selected_tag)
            client.focus = c
        else
            c:jump_to()
        end
        break
    end

    -- Spawn if not found
    if not found then
        awful.spawn(spawn_cmd, spawn_args)
    end
end

-- makes a client floating, then resizes the client
-- to the given width and height
function helpers.float_and_resize(c, width, height)
    c.maximized = false
    c.width = width
    c.height = height
    awful.placement.centered(c,{honor_workarea=true, honor_padding = true})
    awful.client.property.set(c, 'floating_geometry', c:geometry())
    c.floating = true
    c:raise()
end

-- resize a client by direction
function helpers.resize_dwim(c, direction)
    if c and c.floating then
        if direction == "up" then
            c:relative_move(  0,  0, 0, -dpi(20))
        elseif direction == "down" then
            c:relative_move(  0,  0, 0,  dpi(20))
        elseif direction == "left" then
            c:relative_move(  0,  0, -dpi(20), 0)
        elseif direction == "right" then
            c:relative_move(  0,  0,  dpi(20), 0)
        end
    elseif awful.layout.get(mouse.screen) ~= awful.layout.suit.floating then
        if direction == "up" then
            awful.client.incwfact(-0.05)
        elseif direction == "down" then
            awful.client.incwfact(0.05)
        elseif direction == "left" then
            awful.tag.incmwfact(-0.05)
        elseif direction == "right" then
            awful.tag.incmwfact(0.05)
        end
    end
end

return helpers
