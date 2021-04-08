local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful.xresources").apply_dpi
local helpers = require("helpers")
local naughty = require("naughty")
local lgi = require("lgi")
local naughty = require("naughty")
local watch = require("awful.widget.watch")

local spawn = require("awful.spawn")
local gfs = require("gears.filesystem")

local keygrabber = require("awful.keygrabber")

local box_radius = dpi(12)
local box_gap = dpi(6)

dashboard = wibox({
    visible = false,
    ontop = true,
    type = "dock"
})

awful.placement.maximize(dashboard)

dashboard.bg = "#00000055"
dashboard.fg = x.fg

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

-- Helper function that puts a widget inside a box with a specified background color
-- Invisible margins are added so that the boxes created with this function are evenly separated
-- The widget_to_be_boxed is vertically and horizontally centered inside the box
local function create_boxed_widget(widget_to_be_boxed, width, height, bg_color)
    local box_container = wibox.container.background()
    box_container.bg = bg_color
    box_container.forced_height = height
    box_container.forced_width = width
    box_container.shape = helpers.rrect(box_radius)
    -- box_container.shape = helpers.prrect(20, true, true, true, true)
    -- box_container.shape = helpers.prrect(30, true, true, false, true)

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

local user_picture_container = wibox.container.background()

user_picture_container.shape = helpers.prrect(dpi(40), true, true, false, true)
user_picture_container.forced_height = dpi(140)
user_picture_container.forced_width = dpi(140)

local user_picture = wibox.widget {
    {
        wibox.widget.imagebox("/home/yrwq/etc/pic/prof.jpeg"),
        widget = user_picture_container
    },
    shape = helpers.circle(dpi(140)),
    widget = wibox.container.background
}

local name = {
    align = "center",
    valign = "center",
    markup = helpers.colorize_text("Inhof Dávid", x.color7),
    font = beautiful.nfont .. "12",
    widget = wibox.widget.textbox
}

local username = {
    align = "center",
    valign = "center",
    markup = helpers.colorize_text("@yrwq", x.color15),
    font = beautiful.nfont .. "10",
    widget = wibox.widget.textbox
}

local user_widget = wibox.widget {
    user_picture,
    helpers.vertical_pad(dpi(24)),
    name,
    helpers.vertical_pad(dpi(4)),
    username,
    layout = wibox.layout.fixed.vertical
}

local user_box = create_boxed_widget(user_widget, dpi(300), dpi(340), x.color0)

--
-- fortune
--

local fortune_command = "fortune -n 50 -s computers"
local fortune_update_interval = 3600

local fortune = wibox.widget {
    font = beautiful.nfont .. "12",
    text = "Loading your cookie...",
    valign = "center",
    align = "center",
    widget = wibox.widget.textbox
}

local update_fortune = function()
    awful.spawn.easy_async_with_shell(fortune_command, function(out)
        -- Remove trailing whitespaces
        out = out:gsub('^%s*(.-)%s*$', '%1')
        fortune.markup = "<i>"..helpers.colorize_text(out, x.fg).."</i>"
    end)
end

gears.timer {
    autostart = true,
    timeout = fortune_update_interval,
    single_shot = false,
    call_now = true,
    callback = update_fortune
}

local fortune_widget = wibox.widget {
    {
        {
            nil,
            fortune,
            layout = wibox.layout.align.horizontal,
        },
        margins = dpi(15),
        widget = wibox.container.margin
    },
    widget = wibox.container.background
}

fortune_widget:buttons(gears.table.join(
    -- Left click - New fortune
    awful.button({ }, 1, update_fortune)
))

helpers.add_hover_cursor(fortune_widget, "hand1")

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

local music_header = wibox.widget {
    markup = "<b>Now playing</b>",
    font = beautiful.nfont .. "16",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox
}

local music_title = wibox.widget {
    markup = helpers.colorize_text("<b>Now playing</b>", x.color15),
    font = beautiful.nfont .. "14",
    align = "center",
    valign = "center",
    forced_height = dpi(40),
    widget = wibox.widget.textbox
}

local Playerctl = lgi.Playerctl
local player = Playerctl.Player{}
update_metadata = function()
    if player:get_title() then
        if string.match(player:get_title(), player:get_artist()) then
            music_title.markup = helpers.colorize_text(player:get_title(), x.color15)
        else
            music_title.markup = helpers.colorize_text(player:get_artist() .. " - " .. player:get_title(), x.color15)
        end
    else
        music_title.markup = helpers.colorize_text("Nothing playing", x.color15)
    end
end
player.on_metadata = update_metadata

update_metadata()

local music_prev = wibox.widget {
    markup = "玲",
    font = beautiful.ifont .. "16",
    widget = wibox.widget.textbox
}

local music_toggle = wibox.widget {
    markup = "契",
    font = beautiful.ifont .. "16",
    widget = wibox.widget.textbox
}

local music_next = wibox.widget {
    markup = "怜",
    font = beautiful.ifont .. "16",
    widget = wibox.widget.textbox
}

helpers.add_hover_cursor(music_prev, "hand1")
helpers.add_hover_cursor(music_next, "hand1")
helpers.add_hover_cursor(music_toggle, "hand1")

music_prev:connect_signal("button::press", function()
    awful.spawn.with_shell("playerctl previous")
end)

music_next:connect_signal("button::press", function()
    awful.spawn.with_shell("playerctl next")
end)

local status_cmd = "playerctl status -F"
local playing = "false"

update_status = function()
    awful.spawn.easy_async({
            "pkill", "--full", "--uid", os.getenv("USER"), "^playerctl status" }, function()
        awful.spawn.with_line_callback(status_cmd, {
            stdout = function(line)
                if line:find("Playing") then
                    playing = "true"
                    music_toggle.markup = ""
                else
                    playing = "false"
                    music_toggle.markup = "契"
                end
            end
        })
        collectgarbage("collect")
    end)
end

update_status()

music_toggle:connect_signal("button::press", function()
    awful.spawn.with_shell("playerctl play-pause")
    update_status()
end)


local music_control = {
    nil,
    {
        {
            music_prev,
            music_toggle,
            music_next,
            spacing = dpi(30),
            layout = wibox.layout.fixed.horizontal
        },
        widget = wibox.container.margin
    },
    expand = "none",
    layout = wibox.layout.align.horizontal,
}

local music = wibox.widget {
    {
        {
            {
                music_header,
                music_title,
                music_control,
                spacing = dpi(10),
                layout = wibox.layout.fixed.vertical
            },
            margins = dpi(15),
            widget = wibox.container.margin,
        },
        widget = wibox.container.background,
    },
    layout = wibox.layout.fixed.vertical
}

local music_box = create_boxed_widget(music, dpi(250), dpi(157), x.color0)

--
-- weather
--

local wtr_temp = wibox.widget {
    markup = "",
    font = beautiful.nfont .. "15",
    widget = wibox.widget.textbox
}

local wtr_emoji = wibox.widget {
    markup = "",
    font = beautiful.ifont .. "28",
    widget = wibox.widget.textbox
}

local wtr_wind = wibox.widget {
    markup = "",
    font = beautiful.nfont .. "15",
    widget = wibox.widget.textbox
}

local wtr_city = wibox.widget {
    markup = "Pécs",
    font = beautiful.nfont .. "20",
    widget = wibox.widget.textbox
}

local weather = wibox.widget {
    {
        wtr_city,
        helpers.horizontal_pad(dpi(20)),
        wtr_emoji,
        layout = wibox.layout.fixed.horizontal
    },
    helpers.vertical_pad(dpi(10)),
    {
        wtr_temp,
        wtr_wind,
        layout = wibox.layout.fixed.horizontal
    },
    layout = wibox.layout.fixed.vertical
}

awesome.connect_signal("shit::weather", function(temp, wind, emoji)
    wtr_temp.markup = temp .. "糖   "
    wtr_wind.markup = wind .. " km/h  "
    wtr_emoji.markup = emoji
end)

local wtr_box = create_boxed_widget(weather, dpi(250), dpi(200), x.color0)

-- 
-- email
--

local secrets = {
	email_address = config.widget.email.address,
	app_password = config.widget.email.app_password,
	imap_server = config.widget.email.imap_server,
	port = config.widget.email.port
}

local unread_email_count = 0
local startup_show = true

local email_icon_widget = wibox.widget {
	{
		id = 'icon',
        markup = "",
        font = beautiful.ifont .. "30",
		forced_height = dpi(45),
		forced_width = dpi(45),
		widget = wibox.widget.textbox,
	},
	layout = wibox.layout.fixed.horizontal
}

local email_from_text = wibox.widget {
    font = beautiful.nfont .. "12",
	markup = "From:",
	align = "left",
	valign = "center",
	widget = wibox.widget.textbox
}

local email_recent_from = wibox.widget {
    font = beautiful.nfont .. "12",
	markup = "loading@stdout.sh",
	align = "left",
	valign = "center",
	widget = wibox.widget.textbox
}

local email_subject_text = wibox.widget {
    font = beautiful.nfont .. "10",
	markup = "Subject:",
	align = "left",
	valign = "center",
	widget = wibox.widget.textbox
}

local email_recent_subject = wibox.widget {
    font = beautiful.nfont .. "10",
	markup = "Subject:",
	align = "left",
	valign = "center",
	widget = wibox.widget.textbox
}

local email_date_text = wibox.widget {
	font = beautiful.nfont .. "8",
	markup = "Local Date:",
	align = "left",
	valign = "center",
	widget = wibox.widget.textbox
}

local email_recent_date = wibox.widget {
	font = beautiful.nfont .. "8",
	markup = "Loading date...",
	align = "left",
	valign = "center",
	widget = wibox.widget.textbox
}

local email_report = wibox.widget{
	{
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(10),
			{
				layout = wibox.layout.align.vertical,
				expand = 'none',
				nil,
				email_icon_widget,
				nil
			},
			{
				layout = wibox.layout.align.vertical,
				expand = 'none',
				nil,
				{
					layout = wibox.layout.fixed.vertical,
					{
						email_from_text,
						email_recent_from,
						spacing = dpi(5),
						layout = wibox.layout.fixed.horizontal
					},
					{
						email_subject_text,
						email_recent_subject,
						spacing = dpi(5),
						layout = wibox.layout.fixed.horizontal
					},
					{
						email_date_text,
						email_recent_date,
						spacing = dpi(5),
						layout = wibox.layout.fixed.horizontal
					}
				},
				nil
			}
		},
		margins = dpi(10),
		widget = wibox.container.margin
	},
	-- forced_height = dpi(92),
	bg = x.color0,
    widget = wibox.container.background
}

local fetch_email_command = [[
python3 - <<END
import imaplib
import email
import datetime
import re
import sys
from email.policy import default
def process_mailbox(M):
	rv, data = M.search(None, "(UNSEEN)")
	if rv != 'OK':
		print ("No messages found!")
		return
	for num in reversed(data[0].split()):
		rv, data = M.fetch(num, '(BODY.PEEK[])')
		if rv != 'OK':
			print ("ERROR getting message", num)
			return
		msg = email.message_from_bytes(data[0][1], policy=default)
		print ('From:', msg['From'])
		print ('Subject: %s' % (msg['Subject']))
		date_tuple = email.utils.parsedate_tz(msg['Date'])
		if date_tuple:
			local_date = datetime.datetime.fromtimestamp(email.utils.mktime_tz(date_tuple))
			print ("Local Date:", local_date.strftime("%a, %H:%M:%S %b %d, %Y") + "\n")
			# with code below you can process text of email
			# if msg.is_multipart():
			#     for payload in msg.get_payload():
			#         if payload.get_content_maintype() == 'text':
			#             print  payload.get_payload()
			#         else:
			#             print msg.get_payload()
try:
	M=imaplib.IMAP4_SSL("]] .. secrets.imap_server .. [[", ]] .. secrets.port .. [[)
	M.login("]] .. secrets.email_address .. [[","]] .. secrets.app_password .. [[")
	status, counts = M.status("INBOX","(MESSAGES UNSEEN)")
	rv, data = M.select("INBOX")
	if rv == 'OK':
		unread = re.search(r'UNSEEN\s(\d+)', counts[0].decode('utf-8')).group(1)
		print ("Unread Count: " + unread)
		process_mailbox(M)
	M.close()
	M.logout()
except Exception as e:
	if e:
		print (e)
END
]]


local notify_all_unread_email = function(email_data)
	
	local unread_counter = email_data:match('Unread Count: (.-)From:'):sub(1, -2)

	local email_data = email_data:match('(From:.*)'):sub(1, -2)

	local title = nil

	if tonumber(unread_email_count) > 1 then
		title = 'You have ' .. unread_counter .. ' unread emails!'
	else
		title = 'You have ' .. unread_counter .. ' unread email!'
	end
	
	naughty.notification ({
		app_name = "email",
		title = title,
		message = email_data
	})
end

local notify_new_email = function(count, from, subject)
	if not startup_show and (tonumber(count) > tonumber(unread_email_count)) then
		unread_email_count = tonumber(count)

		local message = "From: " .. from ..
		"\nSubject: " .. subject
		
		naughty.notification ({
			app_name = "email",
			title = "You've got a new mail",
			message = message
		})
	else
		unread_email_count = tonumber(count)
	end
end

local set_widget_markup = function(from, subject, date, tooltip)

	email_recent_from:set_markup(from:gsub('%\n', ''))
	email_recent_subject:set_markup(subject:gsub('%\n', ''))
	email_recent_date:set_markup(date:gsub('%\n', ''))

	if tooltip then
		email_details_tooltip:set_markup(tooltip)
	end
end

local set_latest_email_data = function(email_data)

	local unread_count = email_data:match('Unread Count: (.-)From:'):sub(1, -2)
	local recent_from = email_data:match('From: (.-)Subject:'):sub(1, -2)
	local recent_subject = email_data:match('Subject: (.-)Local Date:'):sub(1, -2)
	local recent_date = email_data:match('Local Date: (.-)\n')

	recent_from = recent_from:match('<(.*)>') or recent_from:match('&lt;(.*)&gt;') or recent_from

	set_widget_markup(
		recent_from,
		recent_subject,
		recent_date
	)

	notify_new_email(unread_count, recent_from, recent_subject)
end

local fetch_email_data = function()
	awful.spawn.easy_async_with_shell(
		fetch_email_command,
		function(stdout)
			stdout = gears.string.xml_escape(stdout:sub(1, -2))

			if not stdout:match('Unread Count: (.-)From:') then
				return
			elseif not stdout or stdout == '' then
				return
			end

			set_latest_email_data(stdout)

			if startup_show then
				notify_all_unread_email(stdout)
				startup_show = false
			end
		end
	)
end

local check_secrets = function()
	if secrets.email_address == '' or secrets.app_password == '' or secrets.imap_server == '' or secrets.port == '' then
		return
	else
		fetch_email_data()
	end
end

check_secrets()

local update_widget_timer = gears.timer {
	timeout = 30,
	autostart = true,
	call_now = true,
	callback  = function()
		check_secrets() 
	end
}

email_report:connect_signal(
	'mouse::enter',
	function()
		check_secrets()
	end
)

local email_box = create_boxed_widget(email_report, dpi(300), dpi(150), x.color0)

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
            {
                email_box,
                layout = wibox.layout.fixed.vertical
            },
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
