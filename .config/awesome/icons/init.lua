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
icons.image = {}
icons.text = {}

icons.text.by_class = {
    -- Terminals
    ['kitty'] = { symbol = "", color = x.color5 },
    ['Alacritty'] = { symbol = "", color = x.color5 },
    ['Termite'] = { symbol = "", color = x.color5 },
    ['URxvt'] = { symbol = "", color = x.color5 },
    ['st'] = { symbol = "", color = x.color5 },
    ['St'] = { symbol = "", color = x.color5 },
    ['st-256color'] = { symbol = "", color = x.color5 },

    -- Image viewers
    ['feh'] = { symbol = "", color = x.color1 },
    ['Sxiv'] = { symbol = "", color = x.color1 },

    -- General
    ['TelegramDesktop'] = { symbol = "", color = x.color4 },
    ['Firefox'] = { symbol = "", color = x.color3 },
    ['firefox'] = { symbol = "", color = x.color3 },
    ['Nightly'] = { symbol = "", color = x.color4 },
    ['Chromium'] = { symbol = "", color = x.color4 },
    ['Brave-browser'] = { symbol = "", color = x.color4 },
    ['Chromium-browser'] = { symbol = "", color = x.color4 },
    ['Steam'] = { symbol = "", color = x.color2 },
    ['editor'] = { symbol = "", color = x.color5 },
    ['Emacs'] = { symbol = "", color = x.color2 },
    ['thunar'] = { symbol = "", color = x.color2 },
    ['Thunar'] = { symbol = "", color = x.color2 },
    ['mail'] = { symbol = "", color = x.color6 },
    ['tide'] = { symbol = "", color = x.color6 },
    ['lf'] = { symbol = "", color = x.color6 },
    ['music'] = { symbol = "", color = x.color6 },
    ['mpv'] = { symbol = "", color = x.color6 },
    ['Pavucontrol'] = { symbol = "", color = x.color4 },
    ['Zathura'] = { symbol = "", color = x.color2 },
    ['weechat'] = { symbol = "", color = x.color5 },
    ['discord'] = { symbol = "ﭮ", color = x.color5 },
    ['news'] = { symbol = "", color = x.color5 },
    ['newsboat'] = { symbol = "", color = x.color5 },

    -- File managers
    ['Thunar'] = { symbol = "", color = x.color3 },
    ['Nemo'] = { symbol = "", color = x.color3 },
    ['files'] = { symbol = "", color = x.color3 },

    ['Gimp'] = { symbol = "", color = x.color4 },
    ['Inkscape'] = { symbol = "", color = x.color2 },
    ['Gpick'] = { symbol = "", color = x.color6 },

    -- Default
    ['_'] = { symbol = "", color = x.color7.."99" }
}

local image_icon_names = {
    "terminal",
}

local p

-- Assumes all the icon files end in .png
-- TODO maybe automatically detect icons in icon theme directory
local function set_image_icon(icon_name)
    local i = p..icon_name..".png"
    icons.image[icon_name] = i
end

-- Set all the icon variables
function icons.init(theme_name)
    -- Set the path to image icons
    p = gears.filesystem.get_configuration_dir().."icons/"..theme_name.."/"

    for i = 1, #image_icon_names do
        set_image_icon(image_icon_names[i])
    end

    -- Set symbols and accent colors for text icons
end

return icons
