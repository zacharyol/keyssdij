-- Place-specific script loader with fallback

local function loadScript(url, label)
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)

    if not success then
        warn("Failed to load script (" .. label .. "): " .. tostring(err))
    end
end

if game.PlaceId == 155615604 then
    -- Script for first place
    loadScript(
        "https://raw.githubusercontent.com/zacharyol/keyssdij/refs/heads/main/menu.lua",
        "PlaceId 155615604"
    )

elseif game.PlaceId == 135700444243485 then
    -- Script for second place
    loadScript(
        "https://raw.githubusercontent.com/zacharyol/keyssdij/refs/heads/main/menu2.lua",
        "PlaceId 135700444243485"
    )

elseif game.PlaceId == 107959286470160 then
    -- Script for 3 place
    loadScript(
        "https://raw.githubusercontent.com/zacharyol/keyssdij/refs/heads/main/Menu3.lua",
        "PlaceId 107959286470160"
    )

 elseif game.PlaceId == 734159876 then
    -- Script for 4 place
    loadScript(
        "https://raw.githubusercontent.com/zacharyol/keyssdij/refs/heads/main/menu4.lua",
        "PlaceId 734159876"
    )
    
else
    -- Fallback if no PlaceId matches
    warn("No specific script for PlaceId " .. game.PlaceId .. ", loading menu2 fallback")

    loadScript(
        "https://raw.githubusercontent.com/zacharyol/keyssdij/refs/heads/main/menu2.lua",
        "Fallback (menu2)"
    )
end
