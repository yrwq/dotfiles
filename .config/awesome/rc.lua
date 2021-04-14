pcall(require, "luarocks.loader")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local switcher = require("utils.theme_switcher")

dpi = require("beautiful.xresources").apply_dpi

config = require("config")

-- autostart
awful.spawn.with_shell("picom")
awful.spawn.with_shell("pidof dunst && pkill dunst") -- fix dunst

-- define screen's width and height globally
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

themes = {
    "dear",
    "space",
    "cool",
    "kory"
}

-- give a literal string because of the theme switcher
theme = "kory"

switcher.switch(theme, false)

-- initialize theme
local theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/" .. theme
beautiful.init(theme_dir .. "/theme.lua")

--
-- bling
--

local bling = require("bling")

bling.signal.playerctl.enable()

bling.widget.tag_preview.enable {
    show_client_content = true,
    x = 20,
    y = 50,
    scale = 0.4,
    honor_padding = true,
    honor_workarea = true
}

-- define layouts
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.left,
    awful.layout.suit.magnifier,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.corner.nw,
    awful.layout.suit.corner.ne,
    awful.layout.suit.corner.se,
}

-- initialize layouts and tags
awful.screen.connect_for_each_screen(function(s)
    local l = awful.layout.suit
    local layouts = {
        l.tile,
        l.tile,
        l.tile,
        l.tile,
        l.tile,
    }
    -- local tagnames = { "1", "2", "3", "4", "5" }
    local tagnames = { "main", "web", "code", "chat", "music" }
    awful.tag(tagnames, s, layouts)
end)

-- initialize any external things

-- background 'daemons'
require("shit")

-- client rules
require("rules")

-- key bindings
require("keys")

-- popup widget when switching layout
require("candy.layout-pop")

-- alt-tab application switcher
require("candy.task-pop")

-- status bar
require("candy.bar")

-- title bar
require("candy.titlebar")

-- notifications
require("candy.notifications")

-- dashboard
require("candy.dashboard")

-- start screen
require("candy.start")

-- lock screen
require("candy.lockscreen")

-- garbage collection to use less ram
collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)

-- catch errors and display them as a notification
naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification {
        urgency = "critical",
        title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
        message = message
    }
end)
