local gtimer =require("gears.timer")
local aspawn = require("awful.spawn")

local rss = {}
local curl = "curl -A 'Mozilla/4.0' -fsm 5 --connect-timeout 3 "

local function rss_grab(object, fields, file)
    local object = object or "item"
    local fields = fields or {"title", "link"} -- link, title, or description

    local out = {}

    for _, v in pairs(fields) do
        out[v] = {}
    end

    local ob = nil
    local i,j,k = 1, 1, 0

    local f = io.open(file, "rb")
    if f == nil then return end

    local feed = f:read("*a")
    f:close()

    while true do
        i, j, ob = feed.find(feed, "<" .. object .. ">(.-)</" .. object .. ">", i)
        if not ob then break end

        for _, v in pairs(fields) do
            out[v][k] = ob:match("<" .. v .. ">(.*)</" .. v .. ">")
        end

        k = k+1
        i = j+1
    end

    return out
end

local function github()
    local url = "https://github.com/yrwq.private.atom?token=ALV4PB7U25VWBKZC4A2TGKN6POGV6"
    local file = "/tmp/github.feed"
    local command = curl .. '"' .. url .. '" -o ' .. file
    aspawn.easy_async_with_shell(command, function()
        rss['github'] = rss_grab("item", { "title", "link" }, file)
        awesome.emit_signal("shit::rss", rss)
    end)
end

gtimer {
    timeout = 900, autostart = true, call_now = true, -- 15 min
    callback = function()
        github()
    end
}
