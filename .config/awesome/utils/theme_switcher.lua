local awful = require("awful")
local gears = require("gears")
local gfs = require("gears.filesystem")

local switcher = {}

switcher.switch = function(th, rest)

    -- change global variable in rc.lua to change theme
    local awm_conf = gfs.get_configuration_dir()
    local curr_theme = awm_conf .. "themes/" .. th
    awful.spawn.with_shell("sed -i 's/theme = \".*\"/theme = \"" ..
        th .. "\"/' -i " .. awm_conf .. "rc.lua")

    -- $HOME/.config
    local xdg_conf = gfs.get_xdg_config_home()

    -- neovim
    -- requires to set colorscheme to 'current'
    local nvim_colors = xdg_conf .. "nvim/colors/"
    awful.spawn.with_shell("cp " .. nvim_colors .. th .. ".vim " .. nvim_colors .. "current.vim")

    -- xresources
    awful.spawn.with_shell("xrdb " .. curr_theme .. "/xresources")

    -- reload st colorscheme
    awful.spawn.with_shell("pidof st | xargs kill -SIGUSR1")

    -- discord css
    awful.spawn.with_shell("cp " .. curr_theme .. "/discord.css " .. xdg_conf .. "discocss/custom.css")

    -- install gtk theme
    awful.spawn.with_shell("cd " .. curr_theme .. "/gtk && sudo make install")

    local rofi_themes = xdg_conf .. "rofi/themes/"

    -- switch rofi theme
    awful.spawn.with_shell("cp " .. rofi_themes .. th .. ".rasi "  .. rofi_themes .. "current.rasi")

    if rest then
        awesome.restart()
    end
end

return switcher
