pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local naughty = require("naughty")
local ruled = require("ruled")

-- init
awful.spawn.with_shell("xrdb ~/.Xresources")
awful.spawn.with_shell("picom")
awful.spawn.with_shell("nitrogen --restore")

-- vars
terminal = "xst"
applauncher = "rofi -show drun -show-icons"

local beautiful = require("beautiful")
local xrdb = beautiful.xresources.get_current_theme()

x = {
    --           xrdb variable
    bg = xrdb.background,
    fg = xrdb.foreground,
    color0     = xrdb.color0,
    color1     = xrdb.color1,
    color2     = xrdb.color2,
    color3     = xrdb.color3,
    color4     = xrdb.color4,
    color5     = xrdb.color5,
    color6     = xrdb.color6,
    color7     = xrdb.color7,
    color8     = xrdb.color8,
    color9     = xrdb.color9,
    color10    = xrdb.color10,
    color11    = xrdb.color11,
    color12    = xrdb.color12,
    color13    = xrdb.color13,
    color14    = xrdb.color14,
    color15    = xrdb.color15,
}

beautiful.init(require("theme"))

local icons = require("icons")
icons.init("sheet")

local bling = require("bling")
bling.module.flash_focus.enable()

awful.layout.layouts = {
    bling.layout.mstab,
    awful.layout.suit.tile,
    bling.layout.centered,
    awful.layout.suit.floating,
}

awful.screen.connect_for_each_screen(function(s)
    local b = bling.layout
    local layouts = {
      b.mstab,
      b.mstab,
      b.mstab,
      b.mstab,
      b.mstab,
    }

    local tagnames = { "一", "二", "三", "四", "五" }
    awful.tag(tagnames, s, layouts)
end)


require("shit")
require("keys")
require("rules")
require("module.layout-popup")
require("noti")
require("module.titlebar")
require("candy.bar.dear")
