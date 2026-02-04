-- Place-specific script loader
if game.PlaceId == 155615604 then
    -- Script for first place
    local url = "https://raw.githubusercontent.com/zacharyol/keyssdij/refs/heads/main/menu.lua"
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Failed to load script for PlaceId 155615604: "..tostring(err))
    end

elseif game.PlaceId == 135700444243485 then
    -- Script for second place
    local url = "https://raw.githubusercontent.com/yourusername/yourscript/main/script2.lua"
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Failed to load script for PlaceId 123456789: "..tostring(err))
    end

else
    print("No script configured for this PlaceId: "..game.PlaceId)
end
