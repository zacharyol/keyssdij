-- Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Weapon ESP Hub",
    LoadingTitle = "Loading Weapon ESP Hub",
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

-- Function to check if player has a Knife
local function hasKnife(plr)
    if not plr.Character then return false end

    -- Check character
    for _, tool in ipairs(plr.Character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("knife") then
            return true
        end
    end

    -- Check backpack
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

-- Function to check if player has a Gun
local function hasGun(plr)
    if not plr.Character then return false end

    -- Check character
    for _, tool in ipairs(plr.Character:GetChildren()) do
        if tool:IsA("Tool") and tool.Name:lower():find("gun") then
            return true
        end
    end

    -- Check backpack
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

-- Function to apply highlight
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

-- Function to remove highlight
local function removeHighlight(plr, tableRef)
    if tableRef[plr] then
        tableRef[plr]:Destroy()
        tableRef[plr] = nil
    end
end

-- Loop through players and update ESP
RunService.Heartbeat:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            -- Knife ESP
            if knifeESPEnabled then
                if hasKnife(plr) then
                    applyHighlight(plr, Color3.fromRGB(255,0,0), knifeHighlights)
                else
                    removeHighlight(plr, knifeHighlights)
                end
            else
                removeHighlight(plr, knifeHighlights)
            end

            -- Gun ESP
            if gunESPEnabled then
                if hasGun(plr) then
                    applyHighlight(plr, Color3.fromRGB(0,0,255), gunHighlights)
                else
                    removeHighlight(plr, gunHighlights)
                end
            else
                removeHighlight(plr, gunHighlights)
            end
        end
    end
end)

-- Refresh highlights when a new player joins
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if knifeESPEnabled and hasKnife(plr) then
            applyHighlight(plr, Color3.fromRGB(255,0,0), knifeHighlights)
        end
        if gunESPEnabled and hasGun(plr) then
            applyHighlight(plr, Color3.fromRGB(0,0,255), gunHighlights)
        end
    end)
end)
