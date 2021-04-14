local awful = require("awful")
local beautiful = require("beautiful")

local city = "Pecs"

local update_interval = 60*60 -- every hour

local weather_script = [[
    sh -c '
    wttr_str=`curl wttr.in/]] .. city .. [[?format=2`
    echo $wttr_str
    '
]]

-- Periodically get disk space info
awful.widget.watch(weather_script, update_interval, function(_, stdout)
    local list_weather_data = {}
    for element in stdout:gmatch("%S+") do table.insert(list_weather_data, element) end
    local temp  = tonumber(string.sub(list_weather_data[2], 8, #list_weather_data[2]-3))
    awesome.emit_signal("shit::weather", temp)
end)
