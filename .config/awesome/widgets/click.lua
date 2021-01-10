local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local gears = require("gears")

local button = {}

button.create = function(image, size, radius, margin, bg, bg_hover, bg_press, command)
    local button_image = wibox.widget {
        image = image,
        forced_height = size,
        forced_width = size,
        widget = wibox.widget.imagebox
    }

    local button = wibox.widget {
        {
            button_image,
            margins = dpi(margin),
            widget = wibox.container.margin,
        },
        bg = bg,
        shape = function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, dpi(radius))
        end,
        widget = wibox.container.background
    }

    button:connect_signal("button::press", function()
        button.bg = bg_press
        command()
    end)

    button:connect_signal("button::leave", function() button.bg = bg end)

    local old_cursor, old_wibox
    button:connect_signal("mouse::enter", function()
        button.bg = bg_hover

        -- change cursor
        local wb = mouse.current_wibox
        old_cursor, old_wibox = wb.cursor, wb
        wb.cursor = "hand2"
    end)
    button:connect_signal("mouse::leave", function()
        button.bg = bg

        -- reset cursor
        if old_wibox then
            old_wibox.cursor = old_cursor
            old_wibox = nil
        end
    end)

    button.update_image = function(image)
        button_image.image = image
    end

    return button
end


button.create_text = function(color, color_hover, text, font, onclick)
    local textWidget = wibox.widget {
        font = font,
        align = "center",
        valign = "center",
        markup = "<span foreground='"..color.."'>"..text.."</span>",
        widget = wibox.widget.textbox
    }

    textWidget:connect_signal("mouse::enter", function()
        textWidget.markup = "<span foreground='"..color_hover.."'>"..text.."</span>"
    end)

    textWidget:connect_signal("mouse::leave", function()
        textWidget.markup = "<span foreground='"..color.."'>"..text.."</span>"
    end)

    if onclick ~= nil then
        textWidget:connect_signal("button::press", onclick)
    end

    return textWidget
end

return button
