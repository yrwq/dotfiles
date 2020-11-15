-- stolen from JavaCafe01
local gears = require("gears")

local function file_exists(path)
    -- Try to open it
    local f = io.open(path)
    if f then
        f:close()
        return true
    end
    return false
end

local icons = {}

-- Available icons
local icon_names = {
    "discord",
    "volume",
    "volume-muted",
}

-- Path to icons
local p

-- Assumes all the icon files end in .png
-- TODO maybe automatically detect icons in icon theme directory
local function set_icon(icon_name)
    local i = p..icon_name..".png"
    icons[icon_name] = i
end

-- Set all the icon variables
function icons.init(theme_name)
    -- Set the path to icons
    p = gears.filesystem.get_configuration_dir().."icons/"..theme_name.."/"

    for i = 1, #icon_names do
        set_icon(icon_names[i])
    end
end

return icons
