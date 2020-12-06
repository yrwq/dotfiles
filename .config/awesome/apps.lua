local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")

local apps = {}

apps.org = function()
	helpers.run_or_raise({class = 'emacs'}, false, "emacsclient -c ~/etc/doc/org/todo.org")
end

apps.qute = function()
	awful.spawn.with_shell("surf duckduckgo.com")
end

apps.news = function()
    awful.spawn.with_shell("st -c news -e newsboat")
end

apps.browser = function ()
    awful.spawn.with_shell("brave-dev", { switchtotag = true })
end

apps.abook = function ()
    awful.spawn.with_shell("st -e abook -C ~/.config/abook/abookrc --datafile ~/.config/abook/addressbook", { switchtotag = true })
end

apps.calcurse = function ()
    awful.spawn.with_shell("st -e calcurse", { switchtotag = true })
end

apps.file_manager = function ()
    helpers.run_or_raise({class = 'st -c files -e lf'}, false, "st -c files -e lf")
end

apps.discord = function ()
    helpers.run_or_raise({class = 'discord'}, false, "discocss")
end

apps.mail = function ()
    helpers.run_or_raise({instance = 'email'}, false, "st -c email -e neomutt", {switchtotag = true})
end

apps.gimp = function ()
    helpers.run_or_raise({class = 'Gimp'}, false, "gimp")
end

apps.volume = function ()
    awful.spawn.with_shell("st -c volume -e pulsemixer")
end

apps.editor = function ()
    awful.spawn(editor)
end

apps.music = function ()
    awful.spawn(music)
end

apps.lxappearance = function()
    helpers.run_or_raise({instance = 'lxappearance'}, false, "lxappearance", { switchtotag = true })
end

apps.nitrogen = function()
    helpers.run_or_raise({instance = 'nitrogen'}, false, "nitrogen", { switchtotag = true })
end

apps.torrent = function()
    awful.spawn.with_shell("torwrap")
end

apps.torrent_toggle = function()
    awful.spawn.with_shell("td-toggle")
end

apps.youtube = function()
    awful.spawn.with_shell("ytw")
end

apps.lock = function()
    awful.spawn.with_shell("lock")
end

apps.logout = function()
    awesome.quit()
end

apps.shutdown = function()
    awful.spawn.with_shell("sudo shutdown now")
end

return apps
