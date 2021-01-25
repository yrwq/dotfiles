local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local dpi = require("beautiful").xresources.apply_dpi
local popupLib = require("candy.popupLib")

local calendar_themes = {
    kory = {
        bg = x.bg,
        fg = x.fg,
        focus_date_bg = x.color8,
        focus_date_fg = x.color7,
        weekend_day_bg = x.color0 .. "F7",
        weekday_fg = x.fg,
        header_fg = x.color1,
        border = '#4C566A'
    }
}

local theme = 'kory'
local placement = 'top'

local styles = {}

styles.month = {
    padding = 4,
    bg_color = calendar_themes[theme].bg,
    border_width = 0
}

styles.normal = {
    markup = function(t) return t end,
    shape = helpers.rrect(dpi(6))
}

styles.focus = {
    padding = 1,
    fg_color = calendar_themes[theme].focus_date_fg,
    bg_color = calendar_themes[theme].focus_date_bg,
    markup = function(t) return '<b>' .. t .. '</b>' end,
    shape = helpers.rrect(dpi(6))
}

styles.header = {
    fg_color = calendar_themes[theme].header_fg,
    bg_color = calendar_themes[theme].bg,
    markup = function(t) return '<b>' .. t .. '</b>' end
}

styles.weekday = {
    fg_color = calendar_themes[theme].weekday_fg,
    bg_color = calendar_themes[theme].bg,
    markup = function(t) return '<b>' .. t .. '</b>' end
}

local function decorate_cell(widget, flag, date)
    if flag == 'monthheader' and not styles.monthheader then flag = 'header' end

    if flag == 'focus' then
        local today = os.date('*t')
        if today.month ~= date.month then flag = 'normal' end
    end

    local props = styles[flag] or {}
    if props.markup and widget.get_text and widget.set_markup then
        widget:set_markup(props.markup(widget:get_text()))
    end

    local d = {
        year = date.year,
        month = (date.month or 1),
        day = (date.day or 1)
    }
    local weekday = tonumber(os.date('%w', os.time(d)))
    local default_bg = calendar_themes[theme].bg
    local ret = wibox.widget {
        {
            {widget, halign = 'center', widget = wibox.container.place},
            margins = (props.padding or 2) + (props.border_width or 0),
            widget = wibox.container.margin
        },
        shape = props.shape,
        shape_border_color = props.border_color or '#000000',
        shape_border_width = props.border_width or 0,
        fg = props.fg_color or calendar_themes[theme].fg,
        bg = props.bg_color or default_bg,
        widget = wibox.container.background
    }

    return ret
end

local popupWidget = wibox.widget {
    date = os.date('*t'),
    font = beautiful.nfont .. "10",
    fn_embed = decorate_cell,
    spacing = 10,
    long_weekdays = false,
    start_sunday = true,
    widget = wibox.widget.calendar.month
}

local width = 250

local popup = popupLib.create(screen_width / 2 + screen_width / 4, beautiful.wibar_height + 5,
	nil, width, popupWidget)

return popup
