local awful = require("awful")
local menu = require("modules.menu")

-- root window mouse bindings
awful.mouse.append_global_mousebindings({
    awful.button({ }, 3, function () menu:toggle() end),
    awful.button({ mod }, 4, awful.tag.viewprev),
    awful.button({ mod }, 5, awful.tag.viewnext),
})
