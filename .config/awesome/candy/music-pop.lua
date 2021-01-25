local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = require("beautiful").xresources.apply_dpi
local popupLib = require("candy.popupLib")

local popupWidget = require("widgets.mpd")

local width = 400

local popup = popupLib.create(screen_width / 2 - width / 2, beautiful.wibar_height + 5, 360, width, popupWidget)

return popup
