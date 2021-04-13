local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local helpers = require("helpers")
local naughty = require("naughty")
local lgi = require("lgi")
local awestore = require("awestore")
local bling = require("bling")

local width = 300
local height = 550

--
-- header 
--

local user_widget = require("widgets.user")

local sidebar_header = {
    nil,
    {
        {
            user_widget,
            layout = wibox.layout.fixed.vertical
        },
        top = dpi(20),
        widget = wibox.container.margin
    },
    expand = "none",
    layout = wibox.layout.align.horizontal,
}

--
-- quote
--

local fortune = require("widgets.fortune")

--
-- music control
--

local music = require("widgets.playerctl")

--
-- search web
--

local search_text = wibox.widget {
    valign = "center",
    align = "center",
    font = beautiful.nfont .. "12",
    markup = helpers.colorize_text("Search the web", x.color7),
    widget = wibox.widget.textbox
}

local search_icon = wibox.widget {
    valign = "center",
    align = "center",
    font = beautiful.nfont .. "12",
    markup = helpers.colorize_text(" ", x.color7),
    widget = wibox.widget.textbox
}

local search = wibox.widget{
    {
        {
            search_icon,
            search_text,
            layout = wibox.layout.align.horizontal
        },
        left = dpi(10),
        widget = wibox.container.margin
    },
    forced_height = dpi(35),
    forced_width = dpi(200),
    bg = x.color0,
    shape = helpers.rrect(dpi(5)),
    widget = wibox.container.background()
}

--
-- build
--

local sidebar = wibox.widget {
    {
        sidebar_header,
        {
            {
                fortune,
                margins = dpi(10),
                widget = wibox.container.margin
            },
            forced_height = dpi(70),
            bg = x.color0,
            widget = wibox.container.background,
        },
        spacing = dpi(20),
        layout = wibox.layout.fixed.vertical
    },
    {
        {
            music,
            margins = dpi(10),
            widget = wibox.container.margin
        },
        bg = x.color0,
        widget = wibox.container.background
    },
    {
        search,
        layout = wibox.layout.fixed.vertical
    },
	forced_width = width,
	forced_height = height,
    spacing = dpi(20),
    layout = wibox.layout.fixed.vertical
}

--
-- popup
--

local sidebar_popup = awful.popup {
    widget = {
        {
            {
                sidebar,
                margins = dpi(20),
                widget  = wibox.container.margin
            },
            shape = helpers.prrect(dpi(10), false, true, true, false),
            bg = x.color0 .. "55",
            widget = wibox.container.background
        },
        bg = x.bg,
        widget = wibox.container.background
    },
    ontop = true,
    y = (screen_height / 2) / 3, -- centered vertically
    x = -width - 50,
    visible = false
}

local pop_anim = awestore.tweened(-450, {
    duration = 300,
    easing = awestore.easing.cubic_in_out
})

pop_anim:subscribe(function(x) sidebar_popup.x = x end)

function sidebar_activate_prompt()
    awful.prompt.run {
        prompt = "",
        textbox = search_text,
        font = beautiful.nfont .. "10",
        done_callback = function()
            sidebar_popup.visible = false
        end,
        exe_callback = function(input)
            if not input or #input == 0 then return end
            helpers.run_or_raise({
                    class = "brave"
                },
                true,
                "brave https://google.com/search?q=" .. input,
                {
                    switchtotag = true
                })
        end
    }
end

search:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        sidebar_activate_prompt()
    end)
))

local mouseInPopup = false
local timer = gears.timer {
    timeout = beautiful.popup_mouse_timeout,
    single_shot = true,
    callback = function()
        if not mouseInPopup then
            pop_anim:set(-451)
        end
    end
}

sidebar_popup:connect_signal("mouse::leave", function()
    if sidebar_popup.visible then
        mouseInPopup = false
        timer:again()
    end
end)

sidebar_popup:connect_signal("mouse::enter", function()
    mouseInPopup = true
end)

local sidebar_activator = wibox({
    y = 1, width = 1,
    visible = true, ontop = false,
    opacity = 0, below = true
})

sidebar_activator.height = height

sidebar_activator:connect_signal("mouse::enter", function ()
    sidebar_popup.visible = true
    pop_anim:set(-2)

end)
awful.placement.left(sidebar_activator)

return sidebar_popup
