local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local helpers = require("helpers")

    awful.screen.connect_for_each_screen(function(s)

    local popup_taglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        style   = {
            shape = helpers.rrect(beautiful.corner_radius),
            font  = "Hack Bold 9"
        },
        layout   = {
            spacing = 5,
            spacing_widget = {
                -- shape  = gears.shape.rectangle,
                -- bg = "#00000000",
                -- widget = wibox.widget.separator,
            },
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
                       helpers.horizontal_pad(5),
                       {
                          {
                            {
                              id     = 'text_role',
                              align = "center",
                              valign = "center",
                              widget = wibox.widget.textbox,
                            },
                            top   = 8,
                            bottom = 8,
                            right = 8,
                            left = 8,
                            widget = wibox.container.margin
                          },
                          id = 'background_role',
                          widget  = wibox.container.background,
                        },
                       layout = wibox.layout.align.vertical,
        },
        -- widget_template = {
        --                helpers.horizontal_pad(5),
        --                {
        --                   {
        --                     id     = 'text_role',
        --                     widget = wibox.widget.textbox,
        --                   },
        --                   top   = 5,
        --                   bottom = 5,
        --                   left  = 3,
        --                   widget = wibox.container.margin
        --                 },
        --                 {
        --                   {
        --                     text = "",
        --                     widget = wibox.widget.textbox,
        --                   },
        --                   id = 'background_role',
        --                   forced_width = highlight_width,
        --                   widget  = wibox.container.background,
        --                },
        --                layout = wibox.layout.align.horizontal,
        -- },
        buttons = awful.util.taglist_buttons
        -- Create a taglist widget
    }


    local tag_popup = awful.popup {
        widget = wibox.widget {
            popup_taglist,
            margins = 4,
            widget  = wibox.container.margin,
        },
        border_color = x.color8,
        border_width = beautiful.border_width,
        placement = awful.placement.top + awful.placement.center,
        ontop        = true,
        visible      = false,
        shape        = helpers.rrect(beautiful.corner_radius),
    }

    local hide_tag_box = gears.timer {
       timeout = 2,
       autostart = true,
       callback = function()
          tag_popup.visible = false
       end
    }

    tag.connect_signal("property::selected", function(_)
        layout_popup.visible = not layout_popup.visible
        -- local s = awful.screen.focused()
    		-- if s.mywibar.visible then return end -- do nothing if there is a wibar
        -- if tag_popup.visible then
        --     hide_tag_box:again()
        -- else
        --     tag_popup.visible = true
        --     hide_tag_box:again()
        -- end
    end)

end)
