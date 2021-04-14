local awful = require("awful")
local helpers = require("helpers")
local apps = {}

local browser = "brave"

apps = {
    discord = function()
        helpers.run_or_raise({class = "discord"}, false, "discocss", { switchtotag = true })
    end,
    browser = "brave",
    thunar = "thunar",
    zathura = "zathura",
    gimp = "gimp",
    torrent = "transmission-gtk",
    github = browser .. " github.com",
    youtube = browser .. " youtube.com",
    soundcloud = browser .. " soundcloud.com",
    spotify = browser .. " open.spotify.com",
    editor = "st -c editor -e nvim",
    terminal = "st",
    file_manager = "st -c files -e lf",
}

return apps
