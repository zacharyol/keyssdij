-- =========================
-- RAYFIELD UI TEMPLATE
-- =========================
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Sub Hub",
    LoadingTitle = "Loading",
    LoadingSubtitle = "By Zachary",
    ToggleUIKeybind = "K",

    Discord = {
       Enabled = true,
       Invite = "https://discord.gg/8mYgKKKsSY",
       RememberJoins = true
    },

    KeySystem = true,
    KeySettings = {
        Title = "Sub Hub Key System",
        Subtitle = "Enter your key",
        Note = "Key is required to use this hub",
        FileName = "SubHubKey",
        SaveKey = true,
        GrabKeyFromSite = true,
        Key = "https://raw.githubusercontent.com/zacharyol/keyssdij/refs/heads/main/keys.txt"
    }
})

-- =========================
-- SERVICES
-- =========================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- =========================
-- MAIN TAB
-- =========================
local MainTab = Window:CreateTab("Main")
MainTab:CreateSection("Actions")

-- Example button
MainTab:CreateButton({
    Name = "Example Action",
    Callback = function()
        print("Button pressed!")
    end
})

-- =========================
-- PLACE-SPECIFIC SCRIPT LOADER
-- =========================
local function loadPlaceScript(url)
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Failed to load script: "..tostring(err))
    end
end

if game.PlaceId == 155615604 then
    loadPlaceScript("https://raw.githubusercontent.com/yourusername/yourscript/main/script1.lua")
elseif game.PlaceId == 123456789 then
    loadPlaceScript("https://raw.githubusercontent.com/yourusername/yourscript/main/script2.lua")
else
    print("No script configured for this PlaceId: "..game.PlaceId)
end

-- =========================
-- TOGGLE EXAMPLE
-- =========================
local exampleToggle = false
MainTab:CreateToggle({
    Name = "Example Toggle",
    CurrentValue = false,
    Callback = function(v)
        exampleToggle = v
        print("Toggle is now: "..tostring(v))
    end
})

-- =========================
-- SLIDER EXAMPLE
-- =========================
local exampleValue = 0
MainTab:CreateSlider({
    Name = "Example Slider",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 50,
    Flag = "ExampleSlider",
    Callback = function(v)
        exampleValue = v
        print("Slider value: "..v)
    end
})

-- =========================
-- KEYBINDS EXAMPLE
-- =========================
MainTab:CreateKeybind({
    Name = "Example Keybind",
    CurrentKeybind = "F",
    HoldToInteract = false,
    Callback = function()
        print("Keybind pressed!")
    end
})
