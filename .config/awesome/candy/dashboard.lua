local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require("helpers")
local lgi = require("lgi")
local naughty = require("naughty")
local watch = require("awful.widget.watch")

local spawn = require("awful.spawn")
local gfs = require("gears.filesystem")

local keygrabber = require("awful.keygrabber")

local box_radius = beautiful.dashboard_box_radius
local box_gap = beautiful.dashboard_box_gap

dashboard = wibox({
    visible = false,
    ontop = true,
    type = "dock"
})

awful.placement.maximize(dashboard)

dashboard.bg = beautiful.dashboard_bg

-- Add dashboard or mask to each screen
awful.screen.connect_for_each_screen(function(s)
    if s == screen.primary then
        s.dashboard = dashboard
    else
        s.dashboard = helpers.screen_mask(s, dashboard.bg)
    end
end)

local function set_visibility(v)
    for s in screen do
        s.dashboard.visible = v
    end
end

dashboard:buttons(gears.table.join(
    awful.button({ }, 3, function ()
        dashboard_hide()
    end)
))

-- helper function to create boxes
local function create_boxed_widget(widget_to_be_boxed, width, height, bg_color)
    local box_container = wibox.container.background()
    box_container.bg = bg_color
    box_container.forced_height = height
    box_container.forced_width = width
    box_container.shape = helpers.rrect(box_radius)

    local boxed_widget = wibox.widget {
        -- Add margins
        {
            -- Add background color
            {
                -- Center widget_to_be_boxed horizontally
                nil,
                {
                    -- Center widget_to_be_boxed vertically
                    nil,
                    -- The actual widget goes here
                    widget_to_be_boxed,
                    layout = wibox.layout.align.vertical,
                    expand = "none"
                },
                layout = wibox.layout.align.horizontal,
                expand = "none"
            },
            widget = box_container,
        },
        margins = box_gap,
        color = "#FF000000",
        widget = wibox.container.margin
    }

    return boxed_widget
end

--
-- user
--

local user_widget = require("widgets.user")
local user_box = create_boxed_widget(user_widget, dpi(300), dpi(340), x.color0)

--
-- fortune
--

local fortune_widget = require("widgets.fortune")
local fortune_box = create_boxed_widget(fortune_widget, dpi(300), dpi(200), x.color0)

--
-- bookmarks
--

local function create_bookmark(text, bg_color, hover_color, url, tl, tr, br, bl)

    local bookmark_container = wibox.widget {
        bg = bg_color,
        forced_height = dpi(80),
        forced_width = dpi(120),
        shape = helpers.prrect(20, tl, tr, br, bl),
        widget = wibox.container.background()
    } 

    local bookmark = wibox.widget {
        {
            {
                font = beautiful.ifont .. "55",
                align = "center",
                valign = "center",
                widget = wibox.widget.textbox(text)
            },
            widget = bookmark_container
        },
        shape = helpers.rrect(dpi(4)),
        widget = wibox.container.background()
    }

    bookmark:buttons(
        gears.table.join(
            awful.button({ }, 1, function ()
                awful.spawn("brave " .. url)
                dashboard_hide()
            end)
    ))

    bookmark:connect_signal("mouse::enter", function ()
        bookmark_container.bg = hover_color
    end)

    bookmark:connect_signal("mouse::leave", function ()
        bookmark_container.bg = bg_color
    end)

    return bookmark
end

-- shape = helpers.prrect(99, tl, tr, br, bl),
-- Create the containers
local bm_tl = create_bookmark("",  x.color0, x.color8, "https://github.com/", false, true, false, true)
local bm_tr = create_bookmark("輸", x.color0, x.color8, "https://youtube.com/", true, false, true, false)
local bm_bl = create_bookmark("阮", x.color0, x.color8, "https://open.spotify.com/", false, true, false, true)
local bm_br = create_bookmark("樂", x.color0, x.color8, "https://soundcloud.com/", true, false, true, false)

helpers.add_hover_cursor(bm_tl, "hand1")
helpers.add_hover_cursor(bm_tr, "hand1")
helpers.add_hover_cursor(bm_bl, "hand1")
helpers.add_hover_cursor(bm_br, "hand1")

local bms = wibox.widget {
    bm_tl,
    bm_tr,
    bm_bl,
    bm_br,
    forced_num_cols = 2,
    spacing = box_gap * 2,
    layout = wibox.layout.grid
}

local bm_box = create_boxed_widget(bms, dpi(250), dpi(170), "#00000000")

--
-- music
--

local music = require("widgets.playerctl")
local music_box = create_boxed_widget(music, dpi(250), dpi(157), x.color0)

--
-- weather
--

local weather = require("widgets.weather")
local wtr_box = create_boxed_widget(weather, dpi(250), dpi(200), x.color0)

--
-- todo list
--

local todo_list = wibox.layout.fixed.vertical()
todo_list.spacing = dpi(10)

local todo_path = os.getenv("HOME") .. "/.cache/todos"
local remove_todo

local add_todo = wibox.widget {
    valign = "center",
    align = "center",
    font = beautiful.nfont .. "12",
    markup = helpers.colorize_text("Add a task", x.color7),
    widget = wibox.widget.textbox
}

local get_todos = function()
    local store = {}

    local todo_file = io.open(todo_path, "r")
    if todo_file == nil then return end


    for line in todo_file:lines() do
        table.insert(store, line)
    end
    todo_file:close()

    todo_list:reset()

    for k, v in pairs(store) do

        local done_b = wibox.widget {
            markup = "",
            font = beautiful.ifont .. "22",
            widget = wibox.widget.textbox
        }

        local trash_b = wibox.widget {
            markup = "",
            font = beautiful.ifont .. "22",
            widget = wibox.widget.textbox
        }

        trash_b:connect_signal("button::press", function() remove_todo(v) end)

        local b = wibox.widget {
            {
                {
                    done_b,
                    {
                        align = "center",
                        valign = "center",
                        markup = v,
                        font = beautiful.nfont .. "12",
                        forced_width = dpi(150),
                        widget = wibox.widget.textbox,
                    },
                    trash_b,
                    expand = "none",
                    layout = wibox.layout.align.horizontal
                },
                top = dpi(10),
                bottom = dpi(10),
                left = dpi(20),
                right = dpi(20),
                widget = wibox.container.margin
            },
            forced_width = dpi(250),
            shape = helpers.rrect(dpi(5)),
            bg = x.color8,
            widget = wibox.container.background
        }
        todo_list:add(b)
    end
end

remove_todo = function(line)
    local line = string.gsub(line, "/", "\\/") -- if contain slash

    local command = "sh -c '[ -f " .. todo_path ..
        " ] && sed -i \"/" .. line .. "/d\" " .. todo_path .. "'"

    awful.spawn.easy_async_with_shell(command, function()
        get_todos()
    end)
end

get_todos()

local todo_header = wibox.widget {
    align = "center",
    valign = "center",
    markup = "My TODO List",
    font = beautiful.nfont .. "20",
    widget = wibox.widget.textbox
}

local todo_add = function(todo)
    awful.spawn.with_shell("echo " .. todo .. " >> " .. todo_path)
    get_todos()
end

function dashboard_activate_prompt()
    awful.prompt.run {
        prompt = "",
        textbox = add_todo,
        font = beautiful.nfont .. "10",
        done_callback = function()
            get_todos()
        end,
        exe_callback = function(input)
            if not input or #input == 0 then return end
            todo_add(input)
            get_todos()
        end
    }
end

local add_icon = wibox.widget {
    valign = "center",
    align = "center",
    font = beautiful.ifont .. "18",
    markup = helpers.colorize_text("", x.color7),
    widget = wibox.widget.textbox
}

local task = wibox.widget{
    {
        {
            add_icon,
            add_todo,
            layout = wibox.layout.align.horizontal
        },
        left = dpi(10),
        widget = wibox.container.margin
    },
    forced_height = dpi(35),
    forced_width = dpi(200),
    bg = x.color8,
    shape = helpers.rrect(dpi(5)),
    widget = wibox.container.background()
}

task:buttons(gears.table.join(
    awful.button({ }, 1, function ()
        dashboard_activate_prompt()
    end)
))

local todo_widget = wibox.widget {
    {
        {
            {
                nil,
                {
                    todo_header,
                    -- helpers.vertical_pad(dpi(20)),
                    todo_list,
                    task,
                    spacing = dpi(20),
                    expand = "none",
                    layout = wibox.layout.align.vertical
                },
                layout = wibox.layout.align.horizontal,
                expand = "none",
            },
            margins = dpi(20),
            widget = wibox.container.margin
        },
        shape = helpers.rrect(box_radius),
        forced_width = dpi(300),
        bg = x.color0,
        widget = wibox.container.background
    },
    margins = dpi(5),
    widget = wibox.container.margin
}

-- Item placement
dashboard:setup {
    -- Center boxes vertically
    nil,
    {
        -- Center boxes horizontally
        nil,
        {
            -- Column container
            {
                -- Column 1
                user_box,
                fortune_box,
                layout = wibox.layout.fixed.vertical
            },
            {
                -- Column 2
                bm_box,
                music_box,
                wtr_box,
                layout = wibox.layout.fixed.vertical
            },
            todo_widget,
            layout = wibox.layout.fixed.horizontal
        },
        nil,
        expand = "none",
        layout = wibox.layout.align.horizontal

    },
    nil,
    expand = "none",
    layout = wibox.layout.align.vertical
}

local dashboard_grabber
function dashboard_hide()
    awful.keygrabber.stop(dashboard_grabber)
    set_visibility(false)
end

local original_cursor = "left_ptr"

function dashboard_show()
    local w = mouse.current_wibox
    if w then
        w.cursor = original_cursor
    end
    dashboard_grabber = awful.keygrabber.run(function(_, key, event)
        if event == "release" then return end
        if key == 'Escape' or key == 'q' then
            dashboard_hide()
        end
    end)
    set_visibility(true)
end

return dashboard
