local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local keys = require("keys")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local padding = dpi(30)

local decor = function(c)
    awful.titlebar(c, {
        position = "bottom",
        bg = x.bg
    })

    awful.titlebar(c, {
        position = "top",
        bg = x.bg
    })

    awful.titlebar(c, {
        position = "right",
        size = padding,
        bg = x.bg
    })

    awful.titlebar(c, {
        position = "left",
        size = padding,
        bg = x.bg
    })
end

table.insert(awful.rules.rules, {
    rule_any = {class = {"emacs"}, instance = {"emacs"}},
    properties = {},
    callback = decor
})
