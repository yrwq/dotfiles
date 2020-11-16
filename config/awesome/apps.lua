local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")

local apps = {}

apps.pdf = function()
    awful.spawn.with_shell("~/.bin/pdf")
end

apps.news = function()
    awful.spawn.with_shell("xst -c news -e newsboat")
end

apps.browser = function ()
    awful.spawn.with_shell("firefox", { switchtotag = true })
end

apps.file_manager = function ()
    helpers.run_or_raise({class = 'thunar'}, false, "thunar")
end

apps.whatsapp = function ()
    helpers.run_or_raise({class = 'whatsapp-nativefier-dark'}, false, "whatsapp-nativefier-dark")
end

apps.discord = function ()
    helpers.run_or_raise({class = 'lightcord'}, false, "lightcord")
end

apps.mail = function ()
    helpers.run_or_raise({instance = 'email'}, false, mail, {switchtotag = true})
end

apps.gimp = function ()
    helpers.run_or_raise({class = 'Gimp'}, false, "gimp")
end

apps.volume = function ()
    helpers.run_or_raise({class = 'Pavucontrol'}, true, "pavucontrol")
end

apps.editor = function ()
    helpers.run_or_raise({instance = 'editor'}, false, "emacsclient -c", { switchtotag = true })
end

apps.music = function ()
    awful.spawn(music)
end

apps.todo = function()
    helpers.run_or_raise({instance = 'todo'}, false, "emacsclient -c ~/doc/todo.org", { switchtotag = true })
end

apps.lxappearance = function()
    helpers.run_or_raise({instance = 'lxappearance'}, false, "lxappearance", { switchtotag = true })
end

apps.nitrogen = function()
    helpers.run_or_raise({instance = 'nitrogen'}, false, "nitrogen", { switchtotag = true })
end

apps.torrent = function()
    helpers.run_or_raise({instance = 'transmission-gtk'}, false, "transmission-gtk", { switchtotag = true })
end

apps.lock = function()
    awful.spawn.with_shell("~/.bin/lock")
end

apps.logout = function()
    awesome.quit()
end

apps.shutdown = function()
    awful.spawn.with_shell("sudo shutdown now")
end

return apps
