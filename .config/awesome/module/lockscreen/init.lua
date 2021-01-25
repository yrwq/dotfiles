local awful = require("awful")
local beautiful = require("beautiful")

local lock_screen = {}

lock_screen.init = function()
    lock_screen.authenticate = function(password)
        return password == beautiful.lock_screen_password
    end

    require("module.lockscreen.lockscreen")
end

return lock_screen
