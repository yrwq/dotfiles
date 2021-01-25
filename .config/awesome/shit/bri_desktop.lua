-- Provides:
-- shit::desk_brightness
--      percentage (integer)
local awful = require("awful")

local update_interval = 1
local brightness_script = [[
   bash -c "
   xrandr --verbose | grep -i brightness | cut -f2 -d ' ' | head -n1
"]]


local old_percentage
awful.widget.watch(brightness_script, update_interval, function(_, stdout)
  percentage = tonumber(stdout)
  if percentage ~= old_percentage then
    awesome.emit_signal("shit::desk_brightness", percentage)
    old_percentage = percentage
  end
end)
