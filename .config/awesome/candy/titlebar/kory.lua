local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local titlebar = require("candy.titlebar")

local gen_button_size = dpi(12)
local gen_button_margin = dpi(8)
local gen_button_color_unfocused = x.color8
local gen_button_shape = gears.shape.circle

titlebar.enable_rounding()

client.connect_signal("request::titlebars", function(c)

    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
    end))

    awful.titlebar(c, {font = beautiful.nfont .. "20", position = "top", size = dpi(30)}) : setup {

        -- left
        {

            titlebar.button(c, gen_button_shape, x.color1, gen_button_color_unfocused,
                x.color1 .. "90", gen_button_size, gen_button_margin, "close"),

            titlebar.button(c, gen_button_shape, x.color2, gen_button_color_unfocused,
                x.color2 .. "90", gen_button_size, gen_button_margin, "maximize"),

            titlebar.button(c, gen_button_shape, x.color3, gen_button_color_unfocused,
                x.color3 .. "90", gen_button_size, gen_button_margin, "sticky"),

            titlebar.button(c, gen_button_shape, x.color4, gen_button_color_unfocused,
                x.color4 .. "90", gen_button_size, gen_button_margin, "ontop"),

            titlebar.button(c, gen_button_shape, x.color5, gen_button_color_unfocused,
                x.color5 .. "90", gen_button_size, gen_button_margin, "floating"),

            layout  = wibox.layout.fixed.horizontal
        },

        -- middle
        {
            {
                align  = "center",
                valign  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },

        -- right
        {
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- client.connect_signal("focus", function(c)
--     if c.class == "Brave" then
--         awful.titlebar.hide(c, "top")
--     else
--         awful.titlebar.show(c, "top")
--     end
-- end)
