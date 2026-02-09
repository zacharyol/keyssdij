-- Place-specific script loader with fallback

local HttpService = game:GetService("HttpService")

-- Table mapping PlaceIds to script URLs
local placeScripts = {
    [155615604] = "https://raw.githubusercontent.com/zacharyol/keyssdij/refs/heads/main/menu.lua",
    [135700444243485] = "https://raw.githubusercontent.com/zacharyol/keyssdij/refs/heads/main/menu2.lua",
    [107959286470160] = "https://raw.githubusercontent.com/zacharyol/keyssdij/refs/heads/main/Menu3.lua",
    [734159876] = "https://raw.githubusercontent.com/zacharyol/keyssdij/refs/heads/main/menu4.lua",
    [142823291] = "https://raw.githubusercontent.com/zacharyol/keyssdij/refs/heads/main/Menu5.lua"
}

-- Fallback script URL
local fallbackScript = "https://raw.githubusercontent.com/zacharyol/keyssdij/refs/heads/main/menu2.lua"

local function loadScript(url, label)
    local success, err = pcall(function()
        local response = game:HttpGet(url)
        local func = loadstring(response)
        if func then
            func()
        else
            error("Failed to compile script from " .. label)
        end
    end)

    if success then
        print("Successfully loaded script: " .. label)
    else
        warn("Failed to load script (" .. label .. "): " .. tostring(err))
    end
end

-- Load the script for the current PlaceId, or fallback
local url = placeScripts[game.PlaceId] or fallbackScript
local label = placeScripts[game.PlaceId] and tostring(game.PlaceId) or "Fallback"

loadScript(url, label)
