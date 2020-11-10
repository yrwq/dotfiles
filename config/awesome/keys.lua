local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

modkey = "Mod4"
shiftkey = "Shift"
altkey = "Mod1"

-- custom
awful.keyboard.append_global_keybindings({

    awful.key({ altkey }, "e",     function ()
        awful.spawn.with_shell("rofimoji")
    end,
      {description = "show emoji picker", group = "launcher"}),

    awful.key({ altkey }, "y",     function ()
        awful.spawn.with_shell("~/.bin/nerdy")
    end,
      {description = "show nerd font picker", group = "launcher"}),
    
    awful.key({ altkey }, "Up",     function ()
        awful.spawn.with_shell("amixer sset Master 5%+")
    end,
      {description = "increase volume", group = "launcher"}),

    awful.key({ altkey }, "Down",     function ()
        awful.spawn.with_shell("amixer sset Master 5%-")
    end,
      {description = "decrease volume", group = "launcher"}),

})

awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "a",   awful.tag.viewprev,
      {description = "view previous", group = "tag"}),

    awful.key({ modkey,           }, "d",  awful.tag.viewnext,
      {description = "view next", group = "tag"}),

})

-- Focus related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
      {description = "focus the next screen", group = "screen"}),

    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
      {description = "focus the previous screen", group = "screen"}),

})

-- Layout related keybindings
awful.keyboard.append_global_keybindings({
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
      {description = "swap with next client by index", group = "client"}),

    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
      {description = "swap with previous client by index", group = "client"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
      {description = "increase master width factor", group = "layout"}),

    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
      {description = "decrease master width factor", group = "layout"}),

})

-- General Awesome keys
awful.keyboard.append_global_keybindings({

    awful.key({ modkey, shiftkey }, "r", awesome.restart,
      {description = "reload awesome", group = "awesome"}),

    awful.key({ modkey, shiftkey   }, "e", awesome.quit,
      {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
      {description = "open a terminal", group = "launcher"}),

    awful.key({ modkey }, "r",     function () awful.screen.focused().mypromptbox:run() end,
      {description = "run prompt", group = "launcher"}),
    
    awful.key({ modkey }, "s",     function () awful.spawn(applauncher) end,
      {description = "spawn application launcher", group = "launcher"}),
    
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

        awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
          {description = "close", group = "client"}),

        awful.key({ modkey, shiftkey }, "space",  awful.client.floating.toggle                     ,
          {description = "toggle floating", group = "client"}),

        awful.key({ modkey, shiftkey }, "Return", function (c) c:swap(awful.client.getmaster()) end,
          {description = "move to master", group = "client"}),

        awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
          {description = "toggle keep on top", group = "client"}),

    })
end)
