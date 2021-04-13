local counter = 1

local function gen_map(name)
    return setmetatable({}, {
        __newindex = function(_, k, v)
            -- Create a (private) global variables for the function
            if type(v) == "function" then
                local var = "_keymap_fct_"..counter
                counter = counter + 1
                _G[var] = v
                -- Replace the function by its global name
                if name ~= "map" then
                    v = "<cmd>:lua "..var.."()<cr>"
                else
                    v = ":lua "..var.."()<cr>"
                end
            end
            vim.api.nvim_command(name.." "..k.." "..v)
        end
    })
end

return {
    normal  = gen_map("map"),
    insert  = gen_map("imap"),
    visual  = gen_map("vmap"),
    command = gen_map("cmap"),
}
