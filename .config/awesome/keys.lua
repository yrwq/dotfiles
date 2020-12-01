local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local apps = require("apps")
local bling = require("bling")
local musicPop = require("candy.panel.music")
modkey = "Mod4"
shiftkey = "Shift"
altkey = "Mod1"
ctrlkey = "Control"

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

    awful.key({ altkey }, "q", function () musicPop.visible = not musicPop.visible end),

    awful.key({ altkey }, "a", function () bling.module.tabbed.pick() end),

    awful.key({ altkey }, "s", function () bling.module.tabbed.iter() end),

    awful.key({ altkey }, "d", function () bling.module.tabbed.pop() end),

    awful.key({ modkey, shiftkey }, "d", function () shift_focus_and_move_client(false) end),

    awful.key({ modkey, shiftkey}, "a", function () shift_focus_and_move_client(true) end),

    awful.key({ modkey}, "Tab", function () awful.client.focus.byidx( 1)             end),

    awful.key({ modkey, shiftkey }, "s",  function() awful.spawn.with_shell("rofi -show drun") end),

    awful.key({ }, "Print",  function() awful.spawn.with_shell("lien -s -f") end),

    awful.key({ modkey }, "Print",  function() awful.spawn.with_shell("lien -a -f") end),

    awful.key({ altkey }, "Print",  function() awful.spawn.with_shell("rec") end),

    -- apps
    awful.key({ modkey }, "e", apps.editor),
    awful.key({ modkey }, "m", apps.music),
    awful.key({ modkey }, "r", apps.file_manager),
    awful.key({ modkey }, "y", apps.youtube),
    awful.key({ modkey }, "á", apps.torrent),
    awful.key({ modkey, shiftkey }, "á", apps.torrent_toggle),

	awful.key({ modkey }, "b", function() wibars_toggle() end),
    -- show app launcher
    awful.key({ modkey }, "s", function() app_drawer_show() end),

    -- show shoot screen
    awful.key({ altkey }, "f", function() shoot_screen_show() end),

    -- show top right panel
    awful.key({ altkey }, "q",  function()
        settingsPop.visible = not settingsPop.visible end),

    -- toggle microphone
    awful.key({ modkey }, "v",  function()
        awful.spawn.with_shell("amixer -D pulse sset Capture toggle &> /dev/null") end),

    -- spawn emoji picker
    awful.key({ altkey }, "e",     function ()
        awful.spawn.with_shell("rofimoji") end),

    -- spawn nerd font picker
    awful.key({ altkey }, "y",     function ()
        awful.spawn.with_shell("nerdy") end),

    -- increase volume
    awful.key({ altkey }, "Up",     function ()
        awful.spawn.with_shell("pamixer --allow-boost -i 5") end),

    -- decrease volume
    awful.key({ altkey }, "Down",     function ()
        awful.spawn.with_shell("pamixer --allow-boost -d 5") end),

    awful.key({ altkey }, "space",  function()
        awful.spawn.with_shell("mpc toggle")
    end),

    awful.key({ altkey }, "m", function()
	awful.spawn.with_shell("amixer set Master toggle") end),
})

-- focus and layout
awful.keyboard.append_global_keybindings({
    -- switch tags
    awful.key({ modkey }, "a",   awful.tag.viewprev),
    awful.key({ modkey }, "d",  awful.tag.viewnext),

    -- focus clients with hjkl
    awful.key({ modkey }, "j", function()
	awful.client.focus.byidx( -1)             end),

    awful.key({ modkey }, "k", function()
    	awful.client.focus.byidx( 1)             end),

    awful.key({ modkey }, "h", function()
            awful.client.focus.bydirection("left")
    end),

    awful.key({ modkey }, "l", function()
            awful.client.focus.bydirection("right")
    end),

    awful.key({ modkey, ctrlkey }, "l",     function () awful.tag.incmwfact( 0.05)      end),

    awful.key({ modkey, ctrlkey }, "h",     function () awful.tag.incmwfact(-0.05)      end),
    -- swap clients
    awful.key({ modkey, shiftkey}, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, shiftkey}, "k", function () awful.client.swap.byidx( -1)    end),

    -- increase/decrease gaps
    awful.key({ modkey, shiftkey }, "minus", function () awful.tag.incgap(5, nil) end),
    awful.key({ modkey }, "minus", function () awful.tag.incgap(-5, nil) end),

    awful.key({ modkey }, "c", function (c)
       awful.placement.centered(c, {honor_workarea = true, honor_padding = true})
    end),
})

-- General Awesome keys
awful.keyboard.append_global_keybindings({

    -- reload awesome
    awful.key({ modkey, shiftkey }, "r", awesome.restart),
    -- quit awesome
    awful.key({ modkey, shiftkey   }, "e", awesome.quit),

    -- spawn terminal
    awful.key({ modkey}, "Return", function () awful.spawn(terminal) end),

})

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

client.connect_signal("request::default_keybindings", function()
    awful.keyboard.append_client_keybindings({
        awful.key({ modkey,           }, "f",
            function (c)
                c.fullscreen = not c.fullscreen
                c:raise()
            end,
            {description = "toggle fullscreen", group = "client"}),

        awful.key({ modkey }, "q",      function (c) c:kill()                         end,
          {description = "close", group = "client"}),

        awful.key({ modkey, shiftkey }, "space",  awful.client.floating.toggle                     ,
          {description = "toggle floating", group = "client"}),

        awful.key({ modkey, shiftkey }, "Return", function (c) c:swap(awful.client.getmaster()) end,
          {description = "move to master", group = "client"}),

        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
          {description = "toggle keep on top", group = "client"}),

    })
end)
