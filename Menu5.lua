-- Rayfield UI
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
    KeySystem = false
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- Highlight tables
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
            for _, h in pairs(knifeHighlights) do h:Destroy() end
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
            for _, h in pairs(gunHighlights) do h:Destroy() end
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
            for _, h in pairs(innocentHighlights) do h:Destroy() end
            innocentHighlights = {}
        end
    end
})

-- Refresh button
MainTab:CreateButton({
    Name = "Refresh All ESPs",
    Callback = function()
        updateAllESPs()
    end
})

-- Tool check functions
local function hasTool(plr, keyword)
    if plr.Character then
        for _, tool in ipairs(plr.Character:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find(keyword) then return true end
        end
    end
    local bp = plr:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find(keyword) then return true end
        end
    end
    return false
end

local function hasKnife(plr) return hasTool(plr, "knife") end
local function hasGun(plr) return hasTool(plr, "gun") end

-- Highlight utility
local function applyHighlight(plr, color, tableRef)
    if not plr.Character or tableRef[plr] then return end
    local h = Instance.new("Highlight")
    h.FillColor = color
    h.OutlineColor = Color3.fromRGB(255,255,255)
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee = plr.Character
    h.Parent = workspace
    tableRef[plr] = h
end

local function removeHighlight(plr, tableRef)
    if tableRef[plr] then
        tableRef[plr]:Destroy()
        tableRef[plr] = nil
    end
end

-- Update all ESPs
function updateAllESPs()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local isKnife = hasKnife(plr)
            local isGun = hasGun(plr)

            -- Knife
            if knifeESPEnabled and isKnife then applyHighlight(plr, Color3.fromRGB(255,0,0), knifeHighlights)
            else removeHighlight(plr, knifeHighlights) end

            -- Gun
            if gunESPEnabled and isGun then applyHighlight(plr, Color3.fromRGB(0,0,255), gunHighlights)
            else removeHighlight(plr, gunHighlights) end

            -- Innocent
            if innocentESPEnabled and not isKnife and not isGun then
                applyHighlight(plr, Color3.fromRGB(0,255,0), innocentHighlights)
            else removeHighlight(plr, innocentHighlights) end
        end
    end
end

-- Loop updates
spawn(function()
    while true do
        updateAllESPs()
        task.wait(0.2) -- smoother update
    end
end)

-- Update on new player / respawn
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.5)
        updateAllESPs()
    end)
end)

-- =========================
-- TELEPORT BUTTONS
-- =========================
MainTab:CreateButton({
    Name = "TP to Knife Holder",
    Callback = function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and hasKnife(plr) then
                -- Wait for their character to exist
                local char = plr.Character or plr.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart", 5) -- Wait max 5s
                if hrp then
                    root.CFrame = hrp.CFrame * CFrame.new(0,5,0)
                    break
                end
            end
        end
    end
})

MainTab:CreateButton({
    Name = "TP to Gun Holder",
    Callback = function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and hasGun(plr) then
                local char = plr.Character or plr.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart", 5)
                if hrp then
                    root.CFrame = hrp.CFrame * CFrame.new(0,5,0)
                    break
                end
            end
        end
    end
})
