themes = {
    "dear",
    "kory",
    "ss"
}
theme = themes[1]

pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local lain = require("lain")
local wibox = require("wibox")

screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

local theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme .. "/"
beautiful.init(theme_dir .. "theme.lua")

awful.spawn.with_shell("mpd")

local bling = require("bling")
local machi = require("machi")

beautiful.layout_machi = machi.get_icon()

terminal = "st"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

myawesomemenu = {
    { "edit config", editor_cmd .. " " .. awesome.conffile }, { "restart", awesome.restart }, { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({
    items = {
        { "awesome", myawesomemenu },
        { "terminal", terminal },
        { "telegram", "telegram-desktop" },
        { "browser",  "brave" },
        { "discord", "discocss" }
    }
})

screen.connect_signal("request::wallpaper", function(s)
    -- local wallpaper = os.getenv("HOME") .. "/.wp/forest.jpg"
    -- gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    gears.wallpaper.centered(beautiful.wallpaper, s, x.bg, 1)
end)


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

naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)
