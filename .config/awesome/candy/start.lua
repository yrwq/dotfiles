local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local keygrabber = require("awful.keygrabber")

local awestore = require("awestore")

local width = 400
local height = 600

-- radius of widgets
local widget_radius = beautiful.popup_widget_radius or dpi(5)

-- font used for icons
local icon_font = beautiful.ifont .. "30"

-- helper to create buttons
local create_button = require("utils.button")

-- 
-- header area
--

local dash_button = create_button("舘", icon_font, widget_radius, x.color8, x.bg, function()
    dashboard_show()
end)

local lock_button = create_button("", icon_font, widget_radius, x.color8, x.bg, function()
    start_hide()
end)

local exit_button = create_button("", icon_font, widget_radius, x.color8, x.bg, function()
    awesome.quit()
end)

date_clock = wibox.widget.textclock("<big>%b %d %a</big>")
time_clock = wibox.widget.textclock("<big>%H:%M</big>")

local start_header = wibox.widget {
    date_clock,
    time_clock,
    spacing = dpi(20),
    layout = wibox.layout.fixed.horizontal
}

--
-- apps area
--

local app_discord = create_button("ﭮ",  icon_font, 5, x.color8, x.bg, apps.discord)
local app_browser = create_button("",  icon_font, 5, x.color8, x.bg, apps.browser)
local app_spotify = create_button("阮", icon_font, 5, x.color8, x.bg, apps.spotify)
local app_thunar = create_button("",   icon_font, 5, x.color8, x.bg, apps.thunar)
local app_zathura = create_button("",  icon_font, 5, x.color8, x.bg, apps.zathura)
local app_gimp = create_button("",     icon_font, 5, x.color8, x.bg, apps.gimp)
local app_torrent = create_button("",  icon_font, 5, x.color8, x.bg, apps.torrent)
local app_github = create_button("",   icon_font, 5, x.color8, x.bg, apps.github)
local app_youtube = create_button("輸", icon_font, 5, x.color8, x.bg, apps.youtube)

local apps = wibox.widget {
    app_browser,
    app_discord,
    app_spotify,
    app_thunar,
    app_zathura,
    app_gimp,
    app_torrent,
    app_github,
    app_youtube,
    spacing = dpi(5),
    layout = wibox.layout.fixed.vertical
}

--
-- main widget
--

local start = wibox.widget {
    {
        {
            {
                start_header,
                nil,
                {
                    dash_button,
                    lock_button,
                    exit_button,
                    spacing = dpi(20),
                    layout = wibox.layout.fixed.horizontal
                },
                layout = wibox.layout.align.horizontal
            },
            top = dpi(10),
            bottom = dpi(10),
            left = dpi(20),
            right = dpi(20),
            widget = wibox.container.margin
        },
        shape = helpers.rrect(dpi(5)),
        bg = x.color0,
        widget = wibox.container.background
    },
    {
        {
            {
                {
                    apps,
                    layout = wibox.layout.align.horizontal
                },
                margins = dpi(10),
                widget = wibox.container.margin
            },
            shape = helpers.rrect(widget_radius),
            bg = x.color0,
            widget = wibox.container.background
        },
        {
            require("widgets.volume_slider"),
            require("widgets.cpu_bar"),
            require("widgets.disk_bar"),
            spacing = dpi(20),
            layout = wibox.layout.fixed.vertical
        },
        require("widgets.theme_switcher"),
        layout = wibox.layout.align.horizontal
    },
    forced_width = width,
    forced_height = height,
    spacing = dpi(20),
    layout = wibox.layout.fixed.vertical
}

--
-- popup
--

local start_popup = awful.popup {
    widget = {
        {
            {
                start,
                margins = dpi(20),
                widget  = wibox.container.margin
            },
            -- make the main widget's background partly opaque
            bg = x.color0 .. "55",
            widget = wibox.container.background
        },
        -- antialiasing corner
        bg = beautiful.popup_bg_container or x.bg,
        shape = helpers.prrect(dpi(20), false, true, false, false),
        widget = wibox.container.background
    },
    -- transparent popup
    bg = beautiful.popup_bg or x.bg,
    ontop = true,
    y = screen_height - height - dpi(30),
    x = -width - 50,
    visible = false
}

-- reset cursor everytime
helpers.add_hover_cursor(start_popup, "left_ptr")

-- animate popping in with awestore
local pop_anim = awestore.tweened(-450, {
    duration = 300,
    easing = awestore.easing.cubic_in_out
})

pop_anim:subscribe(function(x) start_popup.x = x end)

start_hide = function()
    pop_anim:set(-451)
end

start_show = function()
    start_popup.visible = true
    pop_anim:set(0)
end

start_popup:connect_signal("mouse::leave", function()
    if start_popup.visible then
        start_hide()
    end
end)

-- hover to the bottom_left corner to pop it
local start_activator = wibox({
    y = 1, width = 1,
    visible = true, ontop = false,
    opacity = 0, below = true
})

start_activator.height = 1

start_activator:connect_signal("mouse::enter", function ()
    start_show()
end)

awful.placement.bottom_left(start_activator)

return start_popup
