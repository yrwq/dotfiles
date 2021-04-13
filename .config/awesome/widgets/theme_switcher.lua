local wibox = require("wibox")
local beautiful = require("beautiful")

-- list all available themes,
-- create a clickable textbox for each
local get_themes = function(w)
    w:reset()
    for k,v in ipairs(themes) do

        local b = require("utils.button")(v, beautiful.nfont .. "23", 5, x.color0, x.color8, function()
		    require("utils.theme_switcher").switch(v, true) end)

        w:add(b)
    end
end

local theme_switch = wibox.widget {
    spacing = dpi(20),
    layout = wibox.layout.fixed.vertical
}

get_themes(theme_switch)

return theme_switch
