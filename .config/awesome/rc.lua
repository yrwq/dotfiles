pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local lain = require("lain")
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

screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

theme = "kory"

local theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme .. "/"
beautiful.init(theme_dir .. "theme.lua")

naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)

local bling = require("bling")
local machi = require("machi")

beautiful.layout_machi = machi.get_icon()

terminal = "st"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

myawesomemenu = {
    { "edit config", editor_cmd .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({
    items = {
        { "awesome", myawesomemenu },
        { "terminal", terminal },
        { "browser",  "brave" },
        { "discord", "discocss" }
    }
})

local wallpaper = os.getenv("HOME") .. "/.wp/forest.jpg"
gears.wallpaper.maximized(wallpaper, s, true)

awful.layout.layouts = {
    awful.layout.suit.tile,
    bling.layout.equalarea,
    bling.layout.centered,
    machi.default_layout,
    lain.layout.centerwork.horizontal,
    awful.layout.suit.fair,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.corner.nw,
}

awful.screen.connect_for_each_screen(function(s)
    local l = awful.layout.suit
    local layouts = {
        l.tile,
        l.tile,
        l.tile,
        l.tile,
        l.tile,
    }

    -- tags
    -- local tagnames = { "一", "二", "三", "四", "五" }
    -- local tagnames = { "", "爵", "", "", "" }
    -- local tagnames = { "I", "II", "III", "IV", "V" }
    -- local tagnames = { "1", "2", "3", "4", "5" }
    local tagnames = { "", "", "", "", "" }
    awful.tag(tagnames, s, layouts)
end)

require("shit")
require("rules")
require("keys")

require("candy.layout-pop")
require("candy.task-pop")
require("candy.bar")
require("candy.titlebar")
require("candy.notifications")

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

