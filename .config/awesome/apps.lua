local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")
local naughty = require("naughty")
local apps = {}

-- I define often used applications here so i can easily start them later

apps.org = function()
   awful.spawn.with_shell("emacsclient -c")
end

apps.notif_toggle = function()
   naughty.toggle()
end

apps.todo = function()
   awful.spawn.with_shell("emacsclient -c ~/doc/agenda.org")
end

apps.news = function()
   awful.spawn.with_shell("st -c news -e newsboat")
end

apps.browser = function ()
   awful.spawn.with_shell("brave-dev yrwq.github.io/termstart")
end

apps.file_manager = function ()
   awful.spawn.with_shell("st -c files -e lf")
end

apps.discord = function ()
   helpers.run_or_raise({class = 'Discord'}, false, "discocss", {switchtotag = true})
end

apps.mail = function ()
   helpers.run_or_raise({instance = 'email'}, false, "st -c email -e neomutt", {switchtotag = true})
end

apps.volume = function ()
   awful.spawn.with_shell("st -c volume -e pulsemixer")
end

apps.syncmail = function ()
   awful.spawn.with_shell("syncmail")
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
