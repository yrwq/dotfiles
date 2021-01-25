local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")
local naughty = require("naughty")
local apps = {}

-- I define often used applications here so i can easily launch them later

-- take a screenshot of the whole screen
apps.screenshot_whole = function()
    awful.spawn.with_shell("scr -a -d 1")
end

-- take a screenshot of the whole screen and copy to clipboard
apps.screenshot_copy = function()
    awful.spawn.with_shell("scr -ac -d 1")
end

-- take a screenshot of the selected area and copy the screenshot to the clipboard
apps.screenshot_select = function()
    awful.spawn.with_shell("scr -sc")
end

-- take a screenshot of the whole screen and uload to 0x0
apps.screenshot_upload = function()
    awful.spawn.with_shell("scr -au")
end

-- start recording the whole screen
apps.record_whole = function()
    awful.spawn.with_shell("tg rec")
end

-- org(emacs)
apps.org = function()
    awful.spawn.with_shell("emacsclient -c")
    -- awful.spawn.with_shell("emacs")
end

-- todo
apps.todo = function()
   awful.spawn.with_shell("emacsclient -c ~/doc/agenda.org")
   -- awful.spawn.with_shell("st -c nvim ~/doc/notes.md")
end

-- news
apps.news = function()
   -- awful.spawn.with_shell("kitty --class news -e newsboat")
   awful.spawn.with_shell("st -c news -e newsboat")
end

-- browser
apps.browser = function ()
   awful.spawn.with_shell("firefox yrwq.github.io/termstart")
   -- awful.spawn.with_shell("qutebrowser yrwq.github.io/termstart")
end

apps.brave_browser = function ()
   -- awful.spawn.with_shell("brave yrwq.github.io/termstart")
   awful.spawn.with_shell("brave")
end

-- file manager
apps.file_manager = function ()
   awful.spawn.with_shell("thunar")
   -- awful.spawn.with_shell("st -c files -e ranger")
   -- awful.spawn.with_shell("st -c lf -e lf")
   -- awful.spawn.with_shell("kitty --class files -e ranger")
end

-- chat
apps.discord = function ()
    -- awful.spawn.with_shell("discocss")
   helpers.run_or_raise({class = 'discord'}, false, "discocss", {switchtotag = true})
end

-- email
apps.mail = function ()
    -- i run a bash script which syncs my emails then opens neomutt
    helpers.run_or_raise({instance = 'mail'}, false, "st -c mail -e neomutt", {switchtotag = true})
    -- helpers.run_or_raise({instance = 'mail'}, false, "st -c mail -e neomutt", {switchtotag = true})
end

apps.syncmail = function()
    awful.spawn.with_shell("mail")
end

-- volume mixer
apps.volume = function ()
    awful.spawn.with_shell("st -c volume -e pulsemixer")
    -- awful.spawn.with_shell("st -c volume -e alsamixer")
end

-- editor
apps.editor = function ()
   awful.spawn(editor)
   -- awful.spawn.with_shell("st -c editor -e nvim")
   -- awful.spawn.with_shell("st -c editor -e emacsclient -t")
end

-- music playere
apps.music = function ()
   awful.spawn(music)
   -- awful.spawn.with_shell("st -c music -e ncmpcpp")
   -- awful.spawn.with_shell("st -c music -e cmus")
   -- awful.spawn.with_shell("audacious")
end

-- change theme
apps.lxappearance = function()
   helpers.run_or_raise({instance = 'lxappearance'}, false, "lxappearance", { switchtotag = true })
end

-- change wallpaper
apps.nitrogen = function()
   helpers.run_or_raise({instance = 'nitrogen'}, false, "nitrogen", { switchtotag = true })
end

-- open torrent
apps.torrent = function()
    -- i run a script which checks if transmission daemon is running,
    -- if not running then it'll start the daemon and open a terminal torrent client
    awful.spawn.with_shell("torwrap")
    -- awful.spawn.with_shell("st -c torrent -e tide")
    -- awful.spawn.with_shell("st -c torrent -e torque")
    -- awful.spawn.with_shell("transmission-gtk")
end

-- toggle torrent
apps.torrent_toggle = function()
    awful.spawn.with_shell("tg torrent")
end

-- Rofi youtube
apps.youtube = function()
    awful.spawn.with_shell("ytw")
end

-- Toggle compositor
apps.compositor = function ()
    awful.spawn.with_shell("tg compositor")
end

-- Toggle night mode
apps.night_mode = function ()
    -- awful.spawn.with_shell("pgrep redshift > /dev/null && (pkill redshift && echo 'OFF') || (echo 'ON' && redshift -l 0:0 -t 3700:3700 -r &>/dev/null &)")
    awful.spawn.with_shell("tg redshift")
end

return apps
