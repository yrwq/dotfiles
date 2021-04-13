local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")

local user_picture_container = wibox.container.background()

user_picture_container.shape = helpers.prrect(dpi(40), true, true, false, true)
user_picture_container.forced_height = dpi(140)
user_picture_container.forced_width = dpi(140)

local user_picture = wibox.widget {
    {
        wibox.widget.imagebox(beautiful.profile_picture),
        widget = user_picture_container
    },
    shape = helpers.circle(dpi(140)),
    widget = wibox.container.background
}

local name = {
    align = "center",
    valign = "center",
    markup = helpers.colorize_text("Inhof Dávid", x.color7),
    font = beautiful.nfont .. "14",
    widget = wibox.widget.textbox
}

local username = {
    align = "center",
    valign = "center",
    markup = helpers.colorize_text("@yrwq", x.color15),
    font = beautiful.nfont .. "12",
    widget = wibox.widget.textbox
}

local user_widget = wibox.widget {
    user_picture,
    helpers.vertical_pad(dpi(24)),
    name,
    helpers.vertical_pad(dpi(4)),
    username,
    layout = wibox.layout.fixed.vertical
}

return user_widget
