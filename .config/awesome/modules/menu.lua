local awful = require("awful")

awesome_menu = {
    { "edit config", config.apps.editor .. " " .. awesome.conffile },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
}

main_menu = awful.menu({
    items = {
        { "awesome", awesome_menu },
        { "editor", config.apps.editor },
        { "terminal", config.apps.terminal },
        { "telegram", "telegram-desktop" },
        { "browser",  "brave" },
        { "discord", "discocss" }
    }
})

return main_menu
