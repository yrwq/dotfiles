-- Titlebars for ncmpcpp
-- Special thanks to elenapan and JavaCafe01
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local toolbar_position = "bottom"
local toolbar_size = dpi(100)
local toolbar_bg = x.bg
local toolbar_enabled_initially = true

local terminal_has_to_move_after_resizing = {["xst"] = true}

local music_client = "xst -c music -e music"
local update_interval = 15

local music_client_terminal = music_client:match("(%w+)(.+)")
local terminal_has_to_move =
    terminal_has_to_move_after_resizing[music_client_terminal]

local spot_toolbar_toggle = function(c)
    if c.toolbar_enabled then
        c.toolbar_enabled = false
        awful.titlebar.hide(c, toolbar_position)
        c.width = c.width + toolbar_size
        if terminal_has_to_move then c.x = c.x - toolbar_size end
    else
        c.toolbar_enabled = true
        awful.titlebar.show(c, toolbar_position)
        c.width = c.width - toolbar_size
        if terminal_has_to_move then c.x = c.x + toolbar_size end
    end
end

local art = wibox.widget {
    image = "/tmp/mpd_cover.jpg",
    clip_shape = helpers.rrect(dpi(6)),
    resize = true,
    widget = wibox.widget.imagebox
}

local create_button = function(symbol, color, command, playpause)

    local icon = wibox.widget {
        markup = helpers.colorize_text(symbol, color),
        font = "FiraCode Nerd Font Mono 20",
        align = "center",
        valigin = "center",
        widget = wibox.widget.textbox()
    }

    local button = wibox.widget {
        icon,
        forced_height = dpi(40),
        forced_width = dpi(40),
        widget = wibox.container.background
    }

    awful.widget.watch("playerctl status", update_interval,
                       function(widget, stdout)
        if playpause then
            if stdout:find("Playing") then
                widget.markup = helpers.colorize_text("", color)
            else
                widget.markup = helpers.colorize_text("", color)
            end
        end
    end, icon)

    button:buttons(gears.table.join(
                       awful.button({}, 1, function() command() end)))

    button:connect_signal("mouse::enter", function()
        icon.markup = helpers.colorize_text(icon.text, beautiful.xforeground)
    end)

    button:connect_signal("mouse::leave", function()
        icon.markup = helpers.colorize_text(icon.text, color)
    end)

    return button

end

local art_script = [[
bash -c '
echo /tmp/mpd_cover.jpg
']]

local song_title_cmd = "mpc current"
local song_title = "rice is cringe"

awful.widget.watch(song_title_cmd, update_interval, function(widget, stdout)
    if not (song_title == stdout) then
        awful.spawn.easy_async_with_shell(art_script, function(out)
            local album_path = out:gsub('%\n', '')
            widget:set_image(gears.surface.load_uncached(album_path))
        end)
        song_title = stdout
    end
end, art)

local play_command =
    function() awful.spawn.with_shell("mpc toggle") end
local prev_command = function() awful.spawn.with_shell("mpc prev") end
local next_command = function() awful.spawn.with_shell("mpc next") end

local spot_play_symbol = create_button("", x.color1, play_command,
                                       true)

local spot_prev_symbol = create_button("玲", x.color1, prev_command,
                                       false)
local spot_next_symbol = create_button("怜", x.color1, next_command,
                                       false)

local spot_create_decoration = function(c)
    awful.titlebar(c, {
        position = toolbar_position,
        size = toolbar_size,
        bg = x.background
    }):setup{
        {
            {
                {
                    layout = wibox.layout.fixed.horizontal
                },
                {
                    {
                        {
                            spot_prev_symbol,
                            spot_play_symbol,
                            spot_next_symbol,
                            spacing = dpi(60),
                            layout = wibox.layout.fixed.horizontal
                        },
                        margins = dpi(6),
                        widget = wibox.container.margin
                    },
                    bg = x.bg,
                    shape = helpers.rrect(beautiful.border_radius),
                    widget = wibox.container.background
                },
                expand = "outside",
                layout = wibox.layout.align.horizontal
            },
            bg = x.background,
            shape = helpers.rrect(beautiful.border_radius),
            widget = wibox.container.background
        },
        left = dpi(40),
        right = dpi(40),
        bottom = dpi(20),
        top = dpi(20),
        layout = wibox.container.margin
    }

    if not toolbar_enabled_initially then
        awful.titlebar.hide(c, toolbar_position)
    end

    c.custom_decoration = {bottom = true}
end

table.insert(awful.rules.rules, {
    rule_any = {class = {"music"}, instance = {"music"}},
    properties = {},
    callback = spot_create_decoration
})
