local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")

-- require("module.notification.volume")

naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(32)
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 3
naughty.config.defaults.title = "System Notification"
naughty.config.defaults.margin = dpi(20)
naughty.config.defaults.border_width = beautiful.widget_border_width
naughty.config.defaults.border_color = beautiful.widget_border_color
naughty.config.defaults.position = "top_right"
naughty.config.defaults.shape = helpers.rrect(10)

naughty.config.padding = dpi(10)
naughty.config.spacing = dpi(5)
naughty.config.icon_dirs = {
    "/usr/share/icons/Archdroid-Grey/apps/scalable/", "/usr/share/pixmaps/"
}
naughty.config.icon_formats = {"png", "svg"}
