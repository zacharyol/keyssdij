-- Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "sub Hub",
    LoadingTitle = "Loading",
    LoadingSubtitle = "By Zachary",
    ToggleUIKeybind = "K",
    Discord = {
       Enabled = true,
       Invite = "https://discord.gg/8mYgKKKsSY",
       RememberJoins = true
    },
    KeySystem = false
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Tables to store highlights
local knifeHighlights = {}
local gunHighlights = {}
local innocentHighlights = {}

-- =========================
-- MAIN TAB
-- =========================
local MainTab = Window:CreateTab("Main")
MainTab:CreateSection("Weapon ESP")

-- Knife ESP Toggle
local knifeESPEnabled = false
MainTab:CreateToggle({
    Name = "Knife ESP",
    CurrentValue = false,
    Callback = function(v)
        knifeESPEnabled = v
        if not v then
            for _, h in pairs(knifeHighlights) do
                h:Destroy()
            end
            knifeHighlights = {}
        end
    end
})

-- Gun ESP Toggle
local gunESPEnabled = false
MainTab:CreateToggle({
    Name = "Gun ESP",
    CurrentValue = false,
    Callback = function(v)
        gunESPEnabled = v
        if not v then
            for _, h in pairs(gunHighlights) do
                h:Destroy()
            end
            gunHighlights = {}
        end
    end
})

-- Innocent ESP Toggle
local innocentESPEnabled = false
MainTab:CreateToggle({
    Name = "Innocent ESP",
    CurrentValue = false,
    Callback = function(v)
        innocentESPEnabled = v
        if not v then
            for _, h in pairs(innocentHighlights) do
                h:Destroy()
            end
            innocentHighlights = {}
        end
    end
})

-- Refresh Button
MainTab:CreateButton({
    Name = "Refresh All ESPs",
    Callback = function()
        updateAllESPs()
    end
})

-- Functions to check tools
local function hasKnife(plr)
    if not plr.Character then return false end
    for _, tool in ipairs(plr.Character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("knife") then
            return true
        end
    end
    local backpack = plr:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("knife") then
                return true
            end
        end
    end
    return false
end

local function hasGun(plr)
    if not plr.Character then return false end
    for _, tool in ipairs(plr.Character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("gun") then
            return true
        end
    end
    local backpack = plr:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("gun") then
                return true
            end
        end
    end
    return false
end

-- Highlight utility
local function applyHighlight(plr, color, tableRef)
    if tableRef[plr] then return end
    if not plr.Character then return end
    local h = Instance.new("Highlight")
    h.FillColor = color
    h.OutlineColor = Color3.fromRGB(255, 255, 255)
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee = plr.Character
    h.Parent = plr.Character
    tableRef[plr] = h
end

local function removeHighlight(plr, tableRef)
    if tableRef[plr] then
        tableRef[plr]:Destroy()
        tableRef[plr] = nil
    end
end

-- Update ESPs
function updateAllESPs()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local hasK = hasKnife(plr)
            local hasG = hasGun(plr)

            -- Knife ESP
            if knifeESPEnabled and hasK then
                applyHighlight(plr, Color3.fromRGB(255,0,0), knifeHighlights)
            else
                removeHighlight(plr, knifeHighlights)
            end

            -- Gun ESP
            if gunESPEnabled and hasG then
                applyHighlight(plr, Color3.fromRGB(0,0,255), gunHighlights)
            else
                removeHighlight(plr, gunHighlights)
            end

            -- Innocent ESP
            if innocentESPEnabled and not hasK and not hasG then
                applyHighlight(plr, Color3.fromRGB(0,255,0), innocentHighlights)
            else
                removeHighlight(plr, innocentHighlights)
            end
        end
    end
end

-- Loop updates every heartbeat
RunService.Heartbeat:Connect(function()
    updateAllESPs()
end)

-- Update when new players join
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        updateAllESPs()
    end)
end)
