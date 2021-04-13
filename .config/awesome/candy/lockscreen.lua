local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local helpers = require("helpers")
local gfs = require("gears.filesystem")

local config_dir = gfs.get_configuration_dir()
package.cpath = package.cpath .. ";" .. config_dir .. "utils/lib/?.so;"

local pam = require("liblua_pam")

local auth = function(password)
    return pam.auth_current_user(password)
end

local pass_textbox = wibox.widget.textbox()

local secret_textbox = wibox.widget {
    font = beautiful.nfont .. 12,
    widget = wibox.widget.textbox
}

pass_textbox:connect_signal("widget::redraw_needed", function()
    local secret = " "
    if #pass_textbox.text > 1 then
        for i = 1, #pass_textbox.text - 1, 1 do secret = secret .. "" end
        secret_textbox.markup = secret .. " "
    else
        secret_textbox.markup = helpers.colorize_text("Password", x.fg)
    end
end)

-- Create the lock screen wibox
lock_screen_box = wibox({
    visible = false,
    ontop = true,
    type = "splash",
    screen = screen.primary
})

awful.placement.maximize(lock_screen_box)

local gradient = {
    type = "linear",
    from = {960, 0},
    to = {960, 1080},
    stops = {{0.4, x.color9}, {1, x.color3}}
}

lock_screen_box.bg = gradient

-- Add lockscreen gradient to each screen
awful.screen.connect_for_each_screen(function(s)
    if s == screen.primary then
        s.mylockscreen = lock_screen_box
    else
        s.mylockscreen = helpers.screen_mask(s, gradient or x.bg)
    end
end)

local function set_visibility(v)
    for s in screen do s.mylockscreen.visible = v end
end

--- Get input from user
local function grab_password()
    awful.prompt.run {
        hooks = {
            {{}, 'Escape', function(_) grab_password() end}, -- Fix for Control+Delete crashing the keygrabber
            {{'Control'}, 'Delete', function() grab_password() end}
        },
        keypressed_callback = function(mod, key, cmd)
        end,
        exe_callback = function(input)
            if auth(input) then
                set_visibility(false)
            else
                secret_textbox.markup = helpers.colorize_text("Password", x.fg)
                grab_password()
            end
        end,
        textbox = pass_textbox
    }
end

function lockscreen_show()
    set_visibility(true)
    grab_password()
end

local create_button = require("utils.button")

local shutdown_b = create_button("shutdown", beautiful.nfont .. "16", dpi(10), x.color0, x.color8, function()
    awful.spawn.with_shell("sudo shutdown") end)

local reboot_b = create_button("reboot", beautiful.nfont .. "16", dpi(10), x.color0, x.color8, function()
    awful.spawn.with_shell("sudo reboot") end)

local clock = wibox.widget {
    font = beautiful.nfont .. "22",
    align = "center",
    valign = "center",
    format = "%l:%M",
    widget = wibox.widget.textclock
}

clock:connect_signal("widget::redraw_needed",function() clock.markup = clock.text end)

lock_screen_box:setup{
    -- vertical centering
    nil,
    {
        -- horizontal centering
        nil,
        {
            -- horizontally centered vertical box
            {
                -- antialiasing the main widget
                {
                    {
                        {
                            require("widgets.user"),
                            secret_textbox,
                            spacing = dpi(30),
                            layout = wibox.layout.fixed.vertical
                        },
                        margins = dpi(50),
                        widget = wibox.container.margin
                    },
                    shape = helpers.rrect(dpi(10)),
                    bg = x.bg,
                    widget = wibox.container.background
                },
                bg = "#00000000",
                widget = wibox.container.background
            },
            {
                nil,
                {
                    {
                        {
                            {
                                clock,
                                {
                                    shutdown_b,
                                    reboot_b,
                                    spacing = dpi(10),
                                    layout = wibox.layout.fixed.horizontal
                                },
                                spacing = dpi(20),
                                layout = wibox.layout.fixed.vertical,
                            },
                            margins = dpi(20),
                            widget = wibox.container.margin,
                        },
                        shape = helpers.rrect(dpi(10)),
                        bg = x.bg,
                        widget = wibox.container.background
                    },
                    bg = "#00000000",
                    widget = wibox.container.background
                },
                expand = "none",
                layout = wibox.layout.align.horizontal
            },
            spacing = dpi(20),
            layout = wibox.layout.fixed.vertical
        },
        expand = "none",
        layout = wibox.layout.align.horizontal
    },
    expand = "none",
    layout = wibox.layout.align.vertical
}
return true
