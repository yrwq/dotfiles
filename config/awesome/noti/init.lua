local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")

require("noti.volume")
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(50)
naughty.config.defaults.screen = awful.screen.focused()
naughty.config.defaults.timeout = 3
naughty.config.defaults.title = "System Notification"
naughty.config.defaults.margin = dpi(20)
naughty.config.defaults.border_width = 2
naughty.config.defaults.border_color = x.color8
naughty.config.defaults.position = "top_right"
naughty.config.defaults.shape = helpers.rrect(beautiful.client_radius)

naughty.config.padding = dpi(20)
naughty.config.spacing = dpi(10)
naughty.config.icon_dirs = {
    "/home/yrwq/.icons/grey/apps/16/", "/usr/share/pixmaps/"
}
naughty.config.icon_formats = {"png", "svg"}

-- Timeouts
naughty.config.presets.low.timeout = 3
naughty.config.presets.critical.timeout = 0

naughty.config.presets.normal = {
    font = beautiful.font,
    fg = x.fg,
    bg = x.color0,
    position = "top_right"
}

naughty.config.presets.low = {
    font = beautiful.font,
    fg = x.fg,
    bg = x.color0,
    position = "top_right"
}

naughty.config.presets.critical = {
    font = beautiful.font,
    fg = x.fg,
    bg = x.color0,
    position = "top_right",
}

naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical
