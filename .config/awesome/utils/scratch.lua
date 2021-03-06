local client = client
local awful = require("awful")
local util = require("awful.util")

local scratch = {}
local default_rule = {class = "scratch"}

local function turn_on(c)
    c.minimized = false
    c.skip_taskbar = true
    c.sticky = true
    c.hidden = false
    c.ontop = true
    c.above = true
    c:raise()
    client.focus = c
    awful.placement.centered(c)
end

-- Turn off this scratch window client (remove current tag from window's tags)
local function turn_off(c)
    c.minimized = true
    c.skip_taskbar = true
    c.hidden = true
    c.sticky = false
    c.ontop = false
    c.above = false
end

function scratch.raise(cmd, rule)
    local rule = rule or default_rule
    local function matcher(c) return awful.rules.match(c, rule) end

    local clients = client.get()
    local findex  = util.table.hasitem(clients, client.focus) or 1
    local start = util.cycle(#clients, findex + 1)

    for c in awful.client.iterate(matcher, start) do
       turn_on(c)
       return
    end

    awful.spawn(cmd)
end

function scratch.toggle(cmd, rule)
    local rule = rule or default_rule
    if client.focus and awful.rules.match(client.focus, rule) then
        turn_off(client.focus)
    else
        scratch.raise(cmd, rule)
    end
end

return scratch
