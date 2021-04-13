local wibox = require("wibox")
local beautiful = require("beautiful")

local wtr_temp = wibox.widget {
    markup = "",
    align = "center",
    valign = "center",
    font = beautiful.nfont .. "15",
    widget = wibox.widget.textbox
}

local wtr_city = wibox.widget {
    markup = "Pécs",
    align = "center",
    valign = "center",
    font = beautiful.nfont .. "25",
    widget = wibox.widget.textbox
}

local weather = wibox.widget {
    wtr_city,
    wtr_temp,
    wtr_wind,
    layout = wibox.layout.fixed.vertical
}

awesome.connect_signal("shit::weather", function(temp, wind, emoji)
    wtr_temp.markup = "temp " .. temp .. ""
end)

return weather
