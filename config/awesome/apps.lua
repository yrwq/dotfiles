local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")

local apps = {}

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
    helpers.run_or_raise({class = 'discord'}, false, "discord")
end

apps.mail = function ()
    helpers.run_or_raise({instance = 'email'}, false, mail, {switchtotag = true})
end

apps.gimp = function ()
    helpers.run_or_raise({class = 'Gimp'}, false, "gimp")
end

apps.youtube = function ()
    awful.spawn.with_shell("mpvtube")
end

apps.volume = function ()
    helpers.run_or_raise({class = 'Pavucontrol'}, true, "pavucontrol")
end

apps.editor = function ()
    helpers.run_or_raise({instance = 'editor'}, false, "emacs", { switchtotag = true })
end

apps.music = function ()
    awful.spawn(music)
end

apps.todo = function()
    helpers.run_or_raise({instance = 'todo'}, false, "emacs ~/doc/todo.org", { switchtotag = true })
end

return apps
