local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local naughty = require("naughty")

local width = 300
local height = 330

--
-- header 
--

local notif_header = wibox.widget {
    markup = "Notifications",
    font = beautiful.nfont .. "16",
    valign = "center",
    align = "center",
    widget = wibox.widget.textbox
}

--
-- scroller
--

local scroller = function(widget)
    widget:buttons(gears.table.join(awful.button({}, 4, nil, function()
        if #widget.children < 4 then return end
        widget:insert(1, widget.children[#widget.children])
        widget:remove(#widget.children)
    end), awful.button({}, 5, nil, function()
        if #widget.children < 4 then return end
        widget:insert(#widget.children + 1, widget.children[1])
        widget:remove(1)
    end)))
end

-- 
-- notifbox
--

local notifbox = {}

notifbox.create = function(icon, title, message, width)
	local time = os.date("%H:%M")
	local box = {}

    local dismiss = wibox.widget {
        markup = "",
        font = beautiful.ifont .. "18",
        widget = wibox.widget.textbox
    }

    dismiss:connect_signal("button::press", function()
        remove_notifbox(box)
    end)
    dismiss:connect_signal("mouse::enter", function()
        dismiss.markup = helpers.colorize_text("", x.color9)
    end)
    dismiss:connect_signal("mouse::leave", function()
        dismiss.markup = helpers.colorize_text("", x.fg)
    end)

    box = wibox.widget {
        {
            {
                {
                    markup = icon,
                    font = beautiful.ifont .. "28",
                    widget = wibox.widget.textbox
                },
                left = dpi(20),
                widget = wibox.container.margin
            },
            {
                {
                    nil,
                    {
                        {
                            font = beautiful.nfont .. "12",
                            markup = title,
                            widget = wibox.widget.textbox
                        },
                        {
                            font = beautiful.nfont .. "10",
                            markup = message,
                            widget = wibox.widget.textbox
                        },
                        layout = wibox.layout.fixed.vertical
                    },
                    expand = "none",
                    layout = wibox.layout.align.vertical
                },
                left = dpi(20),
                bottom = dpi(0),
                widget = wibox.container.margin
            },
            {
                {
                    {
                        nil,
                        dismiss,
                        nil,
                        expand = "none",
                        layout = wibox.layout.align.horizontal
                    },
                    {
                        font = beautiful.nfont .. "8",
                        markup = time,
                        widget = wibox.widget.textbox
                    },
                    spacing = dpi(10),
                    layout = wibox.layout.fixed.vertical
                },
                margins = dpi(15),
                widget = wibox.container.margin
            },
            spacing = dpi(50),
            layout = wibox.layout.align.horizontal
        },
        shape = helpers.rrect(dpi(5)),
        bg = x.color8 .. "85",
        forced_width = width,
        widget = wibox.container.background
    }

    return box
end

--
-- build
--

--
-- empty notifbox
--

local empty_notifs = wibox.widget {
    {
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(5),
        {
            markup = "You have no notifs",
            font = beautiful.nfont .. "12",
            align = "center",
            valign = "center",
            widget = wibox.widget.textbox
        }
    },
    margins = dpi(20),
    widget = wibox.container.margin

}

local empty_notifbox = wibox.widget {
    layout = wibox.layout.fixed.vertical,
    expand = 'none',
    empty_notifs
}

-- create the notifbox's layout
local notifbox_layout = wibox.layout.fixed.vertical()

-- add a scroller to the notfication box
scroller(notifbox_layout)

notifbox_layout.spacing = dpi(20)
notifbox_layout.forced_widh = width

remove_notifbox_empty = true

-- reset the notification box
reset_notifbox_layout = function()
	notifbox_layout:reset(notifbox_layout)
	notifbox_layout:insert(1, empty_notifbox)
	remove_notifbox_empty = true
end

-- remove notifbox
remove_notifbox = function(box)
	notifbox_layout:remove_widgets(box)

	if #notifbox_layout.children == 0 then
		notifbox_layout:insert(1, empty_notifbox)
		remove_notifbox_empty = true
	end
end

notifbox_layout:insert(1, empty_notifbox)

naughty.connect_signal("added", function(n)

    if #notifbox_layout.children == 1 and remove_notifbox_empty then
        notifbox_layout:reset(notifbox_layout)
        remove_notifbox_empty = false
    end

    local appicon
    local default_icon = ""

    local app_config = {
        ['volume'] = { icon = "" },
        ['screenshot'] = { icon = "" },
        ['Telegram Desktop'] = { icon = "" },
        ['email'] = { icon = "" },
        ['discord'] = { icon = "ﭮ" },
        ['weather'] = { icon = "摒" },
        ['github'] = { icon = "" },
        ['music'] = { icon = "" },
    }

    if app_config[n.app_name] then
        appicon = app_config[n.app_name].icon
    else
        appicon = default_icon
    end

    notifbox_layout:insert(1, notifbox.create(appicon, n.title, n.message, width))
end)

local clear_button = wibox.widget {
    markup = "",
    font = beautiful.ifont .. "32",
    widget = wibox.widget.textbox
}

clear_button:connect_signal("mouse::enter", function()
    clear_button.markup = helpers.colorize_text("", x.color9)
end)

clear_button:connect_signal("mouse::leave", function()
    clear_button.markup = helpers.colorize_text("", x.fg)
end)

clear_button:connect_signal("button::press", reset_notifbox_layout)

local down_button = wibox.widget {
    markup = "",
    font = beautiful.ifont .. "32",
    widget = wibox.widget.textbox
}

local update_down_button

down_button:connect_signal("button::press", function()
    notifbox_layout.visible = not notifbox_layout.visible
    update_down_button()
end)

local notif_center = wibox.widget {
    {
        down_button,
        notif_header,
        clear_button,
        expand = "none",
        spacing = dpi(10),
        layout = wibox.layout.align.horizontal
    },
	notifbox_layout,
	forced_width = width,
	forced_height = height,
    spacing = dpi(10),
    layout = wibox.layout.fixed.vertical
}

update_down_button = function()
    if notifbox_layout.visible then
        down_button.markup = ""
        notif_center.forced_height = height
    else
        down_button.markup = ""
        notif_center.forced_height = dpi(50)
    end
end


return notif_center
