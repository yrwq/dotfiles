-- Theme
local themes = {
    "dear", -- 1 --
    "kory", -- 2 --
}
local theme = themes[2]

-- Bar
local bar_themes = {
    "dear", -- 1 -- full width transparent
    "kory", -- 2 -- full width
    "xo",   -- 3 -- workspaces, date at center, hides when a client is focused
}
local bar_theme = bar_themes[2]

-- Titlebar
local titlebar_themes = {
    "dear", -- 1 -- 3 block buttons at right
    "kory", -- 2 -- 3 symbol buttons at left
}
local titlebar_theme = titlebar_themes[2]

pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")

editor = "st -c editor -e nvim"
terminal = "st"
music = "st -c music -e ncmpcpp"
mail = "st -c mail -e neomutt"

screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

local beautiful = require("beautiful")

local xrdb = beautiful.xresources.get_current_theme()

x = {
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

local theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme .. "/"
beautiful.init(theme_dir .. "theme.lua")

-- bling needs to be loaded after initializing beautiful
local bling = require("bling")
bling.module.flash_focus.enable()
bling.module.window_swallowing.start()

-- layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    bling.layout.mstab,
    bling.layout.centered,
    awful.layout.suit.fair,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
}

awful.screen.connect_for_each_screen(function(s)
    local l = awful.layout.suit
    local b = bling.layout
    local layouts = {
      l.tile,
      l.tile,
      l.tile,
      l.tile,
      l.tile,
    }

    -- tags
    -- local tagnames = { "一", "二", "三", "四", "五" }
    -- local tagnames = { "", "爵", "", "", "" }
    -- local tagnames = { "I", "II", "III", "IV", "V" }
    -- local tagnames = { "1", "2", "3", "4", "5" }
    local tagnames = { "", "", "", "", "" }
    awful.tag(tagnames, s, layouts)
end)

require("shit") -- daemons
require("rules") -- rules

require("module.exitscreen")
-- initialize lockscreen
-- needed before loading keys
local lock_screen = require("module.lockscreen")
lock_screen.init()

-- initialize keys
require("keys") -- key binds

-- initialize applauncher
require("module.applauncher")

-- initialize layout popup
require("module.layout-popup")

-- initialize titlebar theme
require("candy.titlebar." .. titlebar_theme)

-- initialize bar theme
require("candy.bar." .. bar_theme)

-- initialize notifications
require("candy.notifs")

require("module.shotscreen")
