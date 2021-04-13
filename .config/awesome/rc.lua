pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local helpers = require("helpers")
local switcher = require("utils.theme_switcher")

dpi = require("beautiful.xresources").apply_dpi

awful.spawn.with_shell("picom")

apps = {
    discord = function()
        helpers.run_or_raise({class = "discord"}, false, "discocss", { switchtotag = true })
    end,
    browser = function()
        awful.spawn.with_shell("brave")
    end,
    spotify = function()
        awful.spawn.with_shell("brave open.spotify.com")
    end,
    thunar = function()
        awful.spawn.with_shell("thunar")
    end,
    zathura = function()
        awful.spawn.with_shell("zathura")
    end,
    gimp = function()
        awful.spawn.with_shell("gimp")
    end,
    torrent = function()
        awful.spawn.with_shell("transmission-gtk")
    end,
    github = function()
        awful.spawn.with_shell("brave github.com")
    end,
    youtube = function()
        awful.spawn.with_shell("brave youtube.com")
    end,
    soundcloud = function()
        awful.spawn.with_shell("brave soundcloud.com")
    end
}

-- define screen's width and height globally
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

-- user variables
config = {
    double_borders = false,
}

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

-- define often applications
terminal = "st"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- right-click menu
myawesomemenu = {
    { "edit config", editor_cmd .. " " .. awesome.conffile }, { "restart", awesome.restart }, { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({
    items = {
        { "awesome", myawesomemenu },
        { "editor", editor_cmd },
        { "terminal", terminal },
        { "telegram", "telegram-desktop" },
        { "browser",  "brave" },
        { "discord", "discocss" }
    }
})

-- set wallpaper from theme
screen.connect_signal("request::wallpaper", function(s)
    -- local wallpaper = os.getenv("HOME") .. "/.wp/forest.jpg"
    gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    -- gears.wallpaper.centered(beautiful.wallpaper, s, x.bg, 1)
end)

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

    -- local tagnames = { "一", "二", "三", "四", "五" }
    -- local tagnames = { "", "爵", "", "", "" }
    -- local tagnames = { "I", "II", "III", "IV", "V" }
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
