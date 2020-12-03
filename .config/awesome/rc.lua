pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")

awful.spawn.with_shell("picom")
awful.spawn.with_shell("mpd")

editor = "st -c editor -e nvim"
terminal = "st"
music = "st -c music -e ncmpcpp"
mail = "st -c mail -e neomutt"
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

local beautiful = require("beautiful")

local xrdb = beautiful.xresources.get_current_theme()

x = {
    --           xrdb variable
    bg = xrdb.background,
    fg = xrdb.foreground,
    trans = "#00000000",   -- fully transparent
    transbg = xrdb.background .. "CC", -- 80% transparent
    trans60 = xrdb.background .. "99", -- 60% transparent
    trans50 = xrdb.background .. "80", -- 50% transparent
    trans40 = xrdb.background .. "66", -- 40% transparent
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

local bling = require("bling")
bling.module.flash_focus.enable()

-- layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    bling.layout.mstab,
    bling.layout.centered,
    awful.layout.suit.floating,
}

awful.screen.connect_for_each_screen(function(s)
    local l = awful.layout.suit
    local b = bling.layout
    local layouts = {
      b.mstab,
      l.tile,
      b.mstab,
      l.tile,
      l.tile,
    }

    -- tags
    -- local tagnames = { "一", "二", "三", "四", "五" }
    local tagnames = { "", "爵", "", "", "" }
    awful.tag(tagnames, s, layouts)
end)

require("shit") -- daemons
require("keys") -- key binds
require("candy") -- bar, panels
require("module") -- titlebar, popups
require("rules") -- rules
require("collision")()
