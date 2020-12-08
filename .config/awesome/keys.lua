local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local apps = require("apps")
local bling = require("bling")

local scratchpad = require("module.scratchpad")
local hotkeys_popup = require("awful.hotkeys_popup").widget

modkey = "Mod4"
shiftkey = "Shift"
altkey = "Mod1"
ctrlkey = "Control"

local dashPop = require("candy.panel.dash")

local function shift_focus_and_move_client(move_back)
  local t = client.focus and client.focus.first_tag or nil
  if t == nil then
    return
  end
  if move_back then
    if t.index == 1 then
      new_tagindex = #awful.screen.focused().tags
    else
      new_tagindex = t.index - 1
    end
    local tag = client.focus.screen.tags[new_tagindex]
    awful.client.movetotag(tag)
    awful.tag.viewprev()
    awesome.emit_signal("toggle::nav")
  else
    if t.index == #awful.screen.focused().tags then
      new_tagindex = 1
    else
      new_tagindex = t.index + 1
    end
    local tag = client.focus.screen.tags[new_tagindex]
    awful.client.movetotag(tag)
    awful.tag.viewnext()
  end
end

awful.keyboard.append_global_keybindings({

	-- launch scratchpad terminal
	awful.key({ modkey, ctrlkey }, "Return", function () scratchpad.toggle("st -c scratch", {class = "scratch"}) 	end,
    	{description = "scratchpad terminal", group = "launch"}),

	-- show keys
	awful.key({ modkey }, "p",      hotkeys_popup.show_help),

	-- unminimize
    awful.key({modkey, shiftkey }, "n", function() local c = awful.client.restore()
    	if c then
            c:emit_signal("request::activate", "key.unminimize", {raise = true})
        end end,
		{description = "unminimize client", group = "client"}),

	-- toggle dashboard
    awful.key({ altkey }, "q", function () dashPop.visible = not dashPop.visible end,
		{description = "dashboard", group = "ui"}),

	-- add client to tabbed
    awful.key({ altkey }, "a", function () bling.module.tabbed.pick() end,
		{description = "add to tabbed", group = "client"}),

	-- change tabbed clients
    awful.key({ altkey }, "s", function () bling.module.tabbed.iter() end,
		{description = "switch tabbed", group = "client"}),

	-- remove tabbed client
    awful.key({ altkey }, "d", function () bling.module.tabbed.pop() end,
		{description = "remove from tabbed", group = "client"}),

	-- move and focus to right tag
    awful.key({ modkey, shiftkey }, "d", function () shift_focus_and_move_client(false) end,
		{description = "move and focus to right", group = "tag"}),

	-- move and focus to left tag
    awful.key({ modkey, shiftkey}, "a", function () shift_focus_and_move_client(true) end,
		{description = "move and focus to left", group = "tag"}),

	-- focus next client
    awful.key({ modkey}, "Tab", function () awful.client.focus.byidx( 1)             end,
		{description = "focus next", group = "client"}),

	-- run application launcher (rofi)
    awful.key({ modkey, shiftkey }, "s",  function() awful.spawn.with_shell("rofi -show drun") end,
		{description = "rofi", group = "launch"}),

	-- take a screenshot and upload it to 0x0(select area)
    awful.key({ }, "Print",  function() awful.spawn.with_shell("lien -s -f") end,
		{description = "(screenshot) select area", group = "capture"}),

	-- take a screenshot and upload it to 0x0(whole screen)
    awful.key({ modkey }, "Print",  function() awful.spawn.with_shell("lien -a -f") end,
		{description = "(screenshot) whole screen", group = "capture"}),

	-- start recording the whole screen
    awful.key({ altkey }, "Print",  function() awful.spawn.with_shell("rec start") end,
		{description = "(recording) start", group = "capture"}),

	-- stop recording
    awful.key({ altkey, shiftkey }, "Print",  function() awful.spawn.with_shell("rec stop") end,
		{description = "(recording) stop", group = "capture"}),

	-- pick color
    awful.key({ modkey, altkey }, "v",  function() awful.spawn.with_shell("clr") end,
		{description = "pick color and show notification", group = "launch"}),

    -- apps
    awful.key({ modkey }, "s", function() app_drawer_show() end,
		{description = "app launcher", group = "launch"}),

    awful.key({ modkey }, "e", apps.editor,
		{description = "editor", group = "launch"}),

    awful.key({ altkey, shiftkey }, "e", apps.org,
		{description = "emacs", group = "launch"}),

    awful.key({ modkey }, "m", apps.music,
		{description = "music player", group = "launch"}),

    awful.key({ modkey }, "w", apps.qute,
		{description = "browser", group = "launch"}),

    awful.key({ modkey }, "r", apps.file_manager,
		{description = "file manager", group = "launch"}),

    awful.key({ modkey }, "y", apps.youtube,
		{description = "youtube", group = "launch"}),

    awful.key({ modkey }, "á", apps.torrent,
		{description = "torrent", group = "launch"}),

    awful.key({ modkey, shiftkey }, "á", apps.torrent_toggle,
		{description = "start/stop torrent", group = "launch"}),

	-- toggle bars
	awful.key({ modkey }, "b", function() wibars_toggle() end,
		{description = "toggle bar", group = "ui"}),

    -- toggle microphone on/off
    awful.key({ modkey }, "v",  function() awful.spawn.with_shell("amixer -D pulse sset Capture toggle &> /dev/null") end,
		{description = "toggle microphone", group = "launch"}),

    -- spawn emoji picker
    awful.key({ altkey }, "e",     function () awful.spawn.with_shell("rofimoji") end,
		{description = "emoji picker", group = "launch"}),

    -- spawn nerd font picker
    awful.key({ altkey }, "y",     function () awful.spawn.with_shell("nerdy") end,
		{description = "nerd font picker", group = "launch"}),

    -- increase volume
    awful.key({ altkey }, "Up",     function () awful.spawn.with_shell("pamixer --allow-boost -i 5") end,
		{description = "increase volume", group = "launch"}),

    -- decrease volume
    awful.key({ altkey }, "Down",     function () awful.spawn.with_shell("pamixer --allow-boost -d 5") end,
		{description = "decrease volume", group = "launch"}),

	-- toggle music on/off
    awful.key({ altkey }, "space",  function() awful.spawn.with_shell("mpc toggle") end,
		{description = "toggle music", group = "launch"}),

	-- toggle volume on/off
    awful.key({ altkey }, "m", function() awful.spawn.with_shell("amixer set Master toggle") end,
		{description = "toggle volume", group = "launch"}),

    -- switch tags
    awful.key({ modkey }, "a",   awful.tag.viewprev,
		{description = "switch to left ", group = "tag"}),

    awful.key({ modkey }, "d",  awful.tag.viewnext,
		{description = "switch to right", group = "tag"}),

    -- focus clients with hjkl
    awful.key({ modkey }, "j", function() awful.client.focus.byidx( -1) end,
		{description = "focus previous", group = "client"}),

    awful.key({ modkey }, "k", function() awful.client.focus.byidx( 1) end,
		{description = "focus next", group = "client"}),

    awful.key({ modkey }, "h", function() awful.client.focus.bydirection("left") end,
		{description = "focus left", group = "client"}),

    awful.key({ modkey }, "l", function() awful.client.focus.bydirection("right") end,
		{description = "focus focus right", group = "client"}),

	-- resize master width
    awful.key({ modkey, ctrlkey }, "l",     function () awful.tag.incmwfact( 0.05)      end,
		{description = "increase master width", group = "client"}),

    awful.key({ modkey, ctrlkey }, "h",     function () awful.tag.incmwfact(-0.05)      end,
		{description = "decrease master width", group = "client"}),

    -- swap clients
    awful.key({ modkey, shiftkey}, "j", function () awful.client.swap.byidx(  1)    end,
		{description = "swap with next", group = "client"}),

    awful.key({ modkey, shiftkey}, "k", function () awful.client.swap.byidx( -1)    end,
		{description = "swap with previous", group = "client"}),

    -- increase/decrease gaps
    awful.key({ modkey, shiftkey }, "minus", function () awful.tag.incgap(5, nil) end,
		{description = "increase gaps", group = "ui"}),

    awful.key({ modkey }, "minus", function () awful.tag.incgap(-5, nil) end,
		{description = "decrease gaps", group = "ui"}),

	-- center focused client
    awful.key({ modkey }, "c", function (c)
		awful.placement.centered(c, {honor_workarea = true, honor_padding = true})
	end,
		{description = "center floating", group = "client"}),

	-- change theme
    awful.key({ modkey, shiftkey }, "c", function()
		awful.spawn.with_shell("chth -f")
	end,
		{description = "choose theme", group = "launch"}),

    awful.key({ modkey, ctrlkey }, "c", function()
		awful.spawn.with_shell("chth -r")
	end,
		{description = "random theme", group = "launch"}),


    -- reload awesome
    awful.key({ modkey, shiftkey }, "r", awesome.restart,
		{description = "reload", group = "awesome"}),

    -- quit awesome
    awful.key({ modkey, shiftkey   }, "e", awesome.quit,
		{description = "quit", group = "awesome"}),

    -- spawn terminal
    awful.key({ modkey}, "Return", function () awful.spawn(terminal) end,
		{description = "terminal", group = "launch"}),

    awful.key({ altkey }, "Return", function () awful.spawn.with_shell("termite") end,
		{description = "alternative terminal", group = "launch"})
})

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({

	-- fullscreen client
    awful.key({ modkey }, "f", function (c)
		c.fullscreen = not c.fullscreen
        c:raise() end,
	{description = "fullscreen focused client", group = "client"}),

	-- kill client
    awful.key({ modkey }, "q", function (c) c:kill() end,
	{description = "kill focused", group = "client"}),

	-- toggle floating
    awful.key({ modkey, shiftkey }, "space",  awful.client.floating.toggle,
	{description = "toggle floating", group = "client"}),

	-- move client to master
    awful.key({ modkey, shiftkey }, "Return", function (c) c:swap(awful.client.getmaster()) end,
	{description = "move to master", group = "client"}),

	-- toggle client on top
    awful.key({ modkey, shiftkey }, "t",      function (c)
		c.ontop = not c.ontop
		c.sticky = not c.sticky end,
	{description = "toggle sticky and ontop", group = "client"}),

	-- toggle titlebar
    awful.key({ modkey }, "t", function (c) awful.titlebar.toggle(c) end,
	{description = "toggle titlebars", group = "ui"}),

	-- minimize
    awful.key({modkey}, "n", function(c) c.minimized = true end,
	{description = "minimize client", group = "client"}),

	awful.key({ ctrlkey }, "-", function(c)
        c.opacity = c.opacity + 0.05 end,
	{description = "increase opacity", group = "client"}),

	awful.key({ ctrlkey, shiftkey }, "-", function(c)
        c.opacity = c.opacity - 0.05 end,
	{description = "decrease opacity", group = "client"})

    })
end)

awful.keyboard.append_global_keybindings({
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numrow",
        description = "only view tag",
        group       = "tag",
        on_press    = function (index)
            local screen = awful.screen.focused()
            local tag = screen.tags[index]
            if tag then
                tag:view_only()
            end
        end,
    },
    awful.key {
        modifiers = { modkey, "Shift" },
        keygroup    = "numrow",
        description = "move focused client to tag",
        group       = "tag",
        on_press    = function (index)
            if client.focus then
                local tag = client.focus.screen.tags[index]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end,
    },
    awful.key {
        modifiers   = { modkey },
        keygroup    = "numpad",
        description = "select layout directly",
        group       = "layout",
        on_press    = function (index)
            local t = awful.screen.focused().selected_tag
            if t then
                t.layout = t.layouts[index] or t.layout
            end
        end,
    }
})

client.connect_signal("request::default_mousebindings", function()
    awful.mouse.append_client_mousebindings({
        awful.button({ }, 1, function (c)
            c:activate { context = "mouse_click" }
        end),
        awful.button({ modkey }, 1, function (c)
            c:activate { context = "mouse_click", action = "mouse_move"  }
        end),
        awful.button({ modkey }, 3, function (c)
            c:activate { context = "mouse_click", action = "mouse_resize"}
        end),
    })
end)
