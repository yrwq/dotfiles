local red = "\27[31m"
local grn = "\27[32m"
local yel = "\27[33m"
local blu = "\27[34m"
local mag = "\27[35m"
local cyn = "\27[36m"
local wht = "\27[37m"

local bold = "\27[1m"
local italic = "\27[3m"
local res = "\27[0m"

yafetch.sep = " ~ "
yafetch.sep_color = bold

-- if set to false, yafetch.shell() will return
-- the full path of the current shell
yafetch.shell_base = true
local shell = yafetch.shell()
local shell_icon = " "

local username = yafetch.user()
local hostname = yafetch.hostname()

local kernel = yafetch.kernel()
local kernel_icon = " "

local pkgs = yafetch.pkgs()
local pkgs_icon = " "

local distro = yafetch.distro()
local distro_icon

local wm_icon = "类"
local wm = io.popen("wmctrl -m | grep Name | awk '{print $2}'"):read("*a")

if distro == "Arch Linux" or distro == "Artix Linux" then
    distro_icon = " "
elseif distro == "NixOS" then
    distro_icon = " "
elseif distro == "Ubuntu" then
    distro_icon = " "
elseif distro == "Alpine Linux" then
    distro_icon = " "
else
    distro_icon = " "
end

yafetch.header_sep = "@"
yafetch.header_sep_color = bold
yafetch.header_format = italic
yafetch.h1_color = italic
yafetch.h2_color = italic

function yafetch.init()
    print("")
    yafetch.header()
    yafetch.format(red, distro_icon, wht, distro)
    yafetch.format(grn, shell_icon, wht, shell)
    yafetch.format(yel, kernel_icon, wht, kernel)
    yafetch.format(blu, pkgs_icon, wht, pkgs)
    yafetch.format(mag, wm_icon, wht, wm)
end
