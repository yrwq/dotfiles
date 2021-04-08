local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local helpers = require("helpers")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi

-- buttons for the titlebar
local buttons = gears.table.join(
    awful.button({ }, 1, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ }, 3, function()
        c:emit_signal("request::activate", "titlebar", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

client.connect_signal("request::titlebars", function(c)

    awful.titlebar(c, {
        font = beautiful.nfont .. "9",
        position = "top",
        size = dpi(30),
    }) : setup {

        -- left
        {

            layout  = wibox.layout.fixed.horizontal
        },

        -- middle
        {
            {
                align  = "center",
                valign  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            layout  = wibox.layout.flex.horizontal
        },

        -- right
        {
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }

	-- awful.titlebar(c, {size = 3, position = 'bottom'}) : setup {
	-- 	buttons = buttons,
	-- 	layout = wibox.layout.align.horizontal
	-- }
	-- awful.titlebar(c, {size = 3, position = 'left'}) : setup {
	-- 	buttons = buttons,
	-- 	layout = wibox.layout.align.horizontal
	-- }
	-- awful.titlebar(c, {size = 3, position = 'right'}) : setup {
	-- 	buttons = buttons,
	-- 	layout = wibox.layout.align.horizontal
	-- }
end)
