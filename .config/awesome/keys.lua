local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local apps = require("apps")
local bling = require("bling")
local helpers = require("helpers")
local titlebar = require("candy.titlebar")

local hotkeys_popup = require("awful.hotkeys_popup").widget

local keys = {}

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

keys.desktopbuttons = gears.table.join(
    awful.button({ }, 1, function ()
        -- Single tap
        naughty.destroy_all_notifications()
    end),

    -- Right click - Show app drawer
    -- awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 3, function ()
        if app_drawer_show then
            app_drawer_show()
        end
    end),

    -- Scrolling - Switch tags
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),

    -- Side buttons - Control volume
    awful.button({ }, 9, function () helpers.volume_control(5) end),
    awful.button({ }, 8, function () helpers.volume_control(-5) end)

)


awful.keyboard.append_global_keybindings({

    -- lock
    awful.key({ modkey, shiftkey }, "l", function () lock_screen_show() end,
    {description = "lock screen", group = "awesome"}),

    -- show keys
   awful.key({ modkey }, "p",      hotkeys_popup.show_help),

   -- unminimize
    awful.key({modkey, shiftkey }, "n", function() local c = awful.client.restore()
        if c then
            c:emit_signal("request::activate", "key.unminimize", {raise = true})
        end end,
    {description = "unminimize client", group = "client"}),

    -- add client to tabbed
    awful.key({ altkey }, "a", function () bling.module.tabbed.pick() end,
    {description = "add to tabbed", group = "client"}),

    -- add client to tabbed with rofi
    awful.key({ altkey, shiftkey }, "s", function () bling.module.tabbed.pick_with_dmenu() end,
    {description = "add to tabbed with rofi", group = "client"}),

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
    -- awful.key({ modkey, shiftkey }, "s",  function() awful.spawn.with_shell("rofi -show drun") end,
    -- {description = "rofi", group = "launch"}),

    -- take a screenshot and upload it to 0x0(select area)
    awful.key({ }, "Print",  function() shot_screen_show() end,
    {description = "shot screen", group = "launch"}),

    -- pick color
    awful.key({ modkey, altkey }, "v",  function() awful.spawn.with_shell("clr") end,
    {description = "pick color and show notification", group = "launch"}),

    -- apps
    awful.key({ modkey }, "s", function() app_drawer_show() end,
    {description = "app launcher", group = "launch"}),

    -- apps
    awful.key({ modkey,shiftkey }, "s", function() awful.spawn.with_shell("rofi -show drun -show-icons") end,
    {description = "app launcher", group = "launch"}),

    awful.key({ modkey }, "e", apps.org,
    {description = "editor", group = "launch"}),

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
    awful.key({ modkey }, "v",  function() awful.spawn.with_shell("tg microphone") end,
    {description = "toggle microphone", group = "launch"}),

    -- toggle volume on/off
    awful.key({ modkey }, "m", function() helpers.volume_control(0) end,
    {description = "toggle volume", group = "launch"}),

    -- spawn emoji picker
    awful.key({ altkey }, "e",     function () awful.spawn.with_shell("rofimoji") end,
    {description = "emoji picker", group = "launch"}),

    -- spawn nerd font picker
    awful.key({ altkey }, "y",     function () awful.spawn.with_shell("nerdy") end,
    {description = "nerd font picker", group = "launch"}),

    -- increase volume
    awful.key({ }, "XF86AudioRaiseVolume",     function () awful.spawn.with_shell("pamixer --allow-boost -i 5") end,
    {description = "increase volume", group = "launch"}),

    awful.key({ modkey }, "F10",     function () awful.spawn.with_shell("pamixer --allow-boost -i 5") end,
    {description = "increase volume", group = "launch"}),

    -- decrease volume
    awful.key({ }, "XF86AudioLowerVolume",     function () awful.spawn.with_shell("pamixer --allow-boost -d 5") end,
    {description = "decrease volume", group = "launch"}),

    awful.key({ modkey }, "F9",     function () awful.spawn.with_shell("pamixer --allow-boost -d 5") end,
    {description = "decrease volume", group = "launch"}),

    -- increase brightness
    awful.key({ }, "XF86MonBrightnessUp",  function() awful.spawn.with_shell("light -A 5") end,
    {description = "increase brightness", group = "launch"}),

    -- decrease brightness
    awful.key({ }, "XF86MonBrightnessDown",  function() awful.spawn.with_shell("light -U 5") end,
    {description = "decrease brightness", group = "launch"}),

    -- increase brightness
    awful.key({ modkey }, "F2",  function() awful.spawn.with_shell("bri down") end,
    {description = "increase brightness", group = "launch"}),

    -- decrease brightness
    awful.key({ modkey }, "F3",  function() awful.spawn.with_shell("bri up") end,
    {description = "decrease brightness", group = "launch"}),

    -- show exit screen
    awful.key({ }, "XF86PowerOff", function() exit_screen_show() end,
    {description = "power menu", group = "launch"}),

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

    -- resize master width
    awful.key({ modkey }, "l",     function () awful.tag.incmwfact( 0.05)      end,
    {description = "increase master width", group = "client"}),

    awful.key({ modkey }, "h",     function () awful.tag.incmwfact(-0.05)      end,
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
    awful.key({ modkey }, "c", function (c) awful.placement.centered(c, {honor_workarea = true, honor_padding = true}) end,
    {description = "center floating", group = "client"}),

    -- change theme
    awful.key({ modkey, shiftkey }, "c", function() awful.spawn.with_shell("cht -r") end,
    {description = "random theme", group = "launch"}),

    -- reload awesome
    awful.key({ modkey, shiftkey }, "r", awesome.restart,
    {description = "reload", group = "awesome"}),

    -- quit awesome
    awful.key({ modkey, shiftkey   }, "e", function() exit_screen_show() end,
    {description = "quit", group = "awesome"}),

    -- spawn terminal
    awful.key({ modkey}, "Return", function () awful.spawn(terminal) end,
    {description = "terminal", group = "launch"})

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
    awful.key({ modkey }, "t", function (c) titlebar.cycle(c) end,
    {description = "toggle titlebars", group = "ui"}),

    -- minimize
    awful.key({modkey}, "n", function(c) c.minimized = true end,
    {description = "minimize client", group = "client"})

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

-- client.connect_signal("request::default_mousebindings", function()
--     awful.mouse.append_client_mousebindings({
--         awful.button({ }, 1, function (c)
--             c:activate { context = "mouse_click" }
--         end),
--         awful.button({ modkey }, 1, function (c)
--             c:activate { context = "mouse_click", action = "mouse_move"  }
--         end),
--         awful.button({ modkey }, 3, function (c)
--             c:activate { context = "mouse_click", action = "mouse_resize"}
--         end),
--     })
-- end)

keys.clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 2, function (c) c:kill() end),
    awful.button({ modkey }, 3, function(c)
        client.focus = c
        awful.mouse.resize(c, nil, {jump_to_corner=true})
    end),

    -- Super + scroll = Change client opacity
    awful.button({ modkey }, 4, function(c)
        c.opacity = c.opacity + 0.1
    end),
    awful.button({ modkey }, 5, function(c)
        c.opacity = c.opacity - 0.1
    end)
)

-- Mouse buttons on the primary titlebar of the window
keys.titlebar_buttons = gears.table.join(
    -- Left button - move
    -- (Double tap - Toggle maximize) -- A little BUGGY
    awful.button({ }, 1, function()
        local c = mouse.object_under_pointer()
        c.floating = true
        client.focus = c
        awful.mouse.client.move(c)
    end),
    -- Middle button - close
    awful.button({ }, 2, function ()
        local c = mouse.object_under_pointer()
        c.floating = true
        c:kill()
    end),
    -- Right button - resize
    awful.button({ }, 3, function()
        local c = mouse.object_under_pointer()
        client.focus = c
        awful.mouse.client.resize(c)
    end),
    -- Side button up - toggle floating
    awful.button({ }, 9, function()
        local c = mouse.object_under_pointer()
        client.focus = c
        awful.placement.centered(c,{honor_padding = true, honor_workarea=true})
        c.floating = not c.floating
    end),
    -- Side button down - toggle ontop
    awful.button({ }, 8, function()
        local c = mouse.object_under_pointer()
        client.focus = c
        c.sticky = not c.sticky
    end)
)

-- root.keys(keys.globalkeys)
-- root.buttons(keys.desktopbuttons)

return keys
