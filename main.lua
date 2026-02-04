-- Check the place ID
if game.PlaceId == 155615604 then
    -- Load the script from a URL
    local url = "https://raw.githubusercontent.com/zacharyol/keyssdij/refs/heads/main/menu.lua"
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    
    if not success then
        warn("Failed to load script: "..tostring(err))
    end
end
