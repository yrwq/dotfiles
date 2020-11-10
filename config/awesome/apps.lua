local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local helpers = require("helpers")
local icons = require("icons")
local notifications = require("notifications")


local apps = {}

apps.browser = function ()
    awful.spawn(user.browser, { switchtotag = true })
end

apps.file_manager = function ()
    awful.spawn(user.file_manager, { floating = true })
end

apps.discord = function ()
    helpers.run_or_raise({class = 'lightcord'}, false, "lightcord")
end

apps.volume = function ()
    helpers.run_or_raise({class = 'Pavucontrol'}, true, "pavucontrol")
end

apps.editor = function ()
    helpers.run_or_raise({instance = 'editor'}, false, user.editor, { switchtotag = true })
end

return apps
