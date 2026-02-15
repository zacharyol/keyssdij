-- Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "sub hub",
    LoadingTitle = "Loading",
    LoadingSubtitle = "By Zachary",
    ToggleUIKeybind = "K",
    Discord = { Enabled = true, Invite = "https://discord.gg/8mYgKKKsSY", RememberJoins = true },
    KeySystem = false
})

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- Utility: get a part from a model (PrimaryPart or first BasePart)
local function getTeleportPart(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then
        return obj
    elseif obj:IsA("Model") then
        if obj.PrimaryPart then
            return obj.PrimaryPart
        else
            for _, p in ipairs(obj:GetDescendants()) do
                if p:IsA("BasePart") then
                    return p
                end
            end
        end
    end
    return nil
end

-- =========================
-- MAIN TAB
-- =========================
local MainTab = Window:CreateTab("Stone Teleports")
MainTab:CreateSection("Teleport Stones")

-- Auto TP toggles
local autoSpace = false
local autoTime = false
local autoReality = false

-- =========================
-- SPACE STONE
-- =========================
MainTab:CreateButton({
    Name = "TP to Space Stone",
    Callback = function()
        local current = Workspace:FindFirstChild("SpaceStoneTower") and Workspace.SpaceStoneTower:FindFirstChild("Space Stone")
        local part = getTeleportPart(current)
        if part then
            root.CFrame = part.CFrame + Vector3.new(0,5,0)
        end
    end
})

MainTab:CreateToggle({
    Name = "Auto TP to Space Stone",
    CurrentValue = false,
    Callback = function(v)
        autoSpace = v
    end
})

-- =========================
-- TIME STONE
-- =========================
MainTab:CreateButton({
    Name = "TP to Time Stone",
    Callback = function()
        local current = Workspace:FindFirstChild("Tower of the TimeStone") 
                        and Workspace["Tower of the TimeStone"]:FindFirstChild("Pedestal") 
                        and Workspace["Tower of the TimeStone"].Pedestal:FindFirstChild("TimeStone")
        local part = getTeleportPart(current)
        if part then
            root.CFrame = part.CFrame + Vector3.new(0,5,0)
        end
    end
})

MainTab:CreateToggle({
    Name = "Auto TP to Time Stone",
    CurrentValue = false,
    Callback = function(v)
        autoTime = v
    end
})

-- =========================
-- REALITY STONE
-- =========================
MainTab:CreateButton({
    Name = "TP to Reality Stone",
    Callback = function()
        local current = Workspace:FindFirstChild("RealityStonePit") 
                        and Workspace.RealityStonePit:FindFirstChild("Pedestal") 
                        and Workspace.RealityStonePit.Pedestal:FindFirstChild("Reality Stone")
        local part = getTeleportPart(current)
        if part then
            root.CFrame = part.CFrame + Vector3.new(0,5,0)
        end
    end
})

MainTab:CreateToggle({
    Name = "Auto TP to Reality Stone",
    CurrentValue = false,
    Callback = function(v)
        autoReality = v
    end
})

-- =========================
-- POWER STONE
-- =========================
MainTab:CreateButton({
    Name = "TP to Power Stone",
    Callback = function()
        local current = Workspace:FindFirstChild("PowerStoneTemple") and Workspace.PowerStoneTemple:FindFirstChild("PowerStoneThing")
        local part = getTeleportPart(current)
        if part then
            root.CFrame = part.CFrame + Vector3.new(0,5,0)
        end
    end
})

-- =========================
-- AUTO TELEPORT LOOP
-- =========================
RunService.Heartbeat:Connect(function()
    -- Auto Space
    if autoSpace then
        local current = Workspace:FindFirstChild("SpaceStoneTower") and Workspace.SpaceStoneTower:FindFirstChild("Space Stone")
        local part = getTeleportPart(current)
        if part then
            root.CFrame = part.CFrame + Vector3.new(0,5,0)
        end
    end

    -- Auto Time
    if autoTime then
        local current = Workspace:FindFirstChild("Tower of the TimeStone") 
                        and Workspace["Tower of the TimeStone"]:FindFirstChild("Pedestal") 
                        and Workspace["Tower of the TimeStone"].Pedestal:FindFirstChild("TimeStone")
        local part = getTeleportPart(current)
        if part then
            root.CFrame = part.CFrame + Vector3.new(0,5,0)
        end
    end

    -- Auto Reality
    if autoReality then
        local current = Workspace:FindFirstChild("RealityStonePit") 
                        and Workspace.RealityStonePit:FindFirstChild("Pedestal") 
                        and Workspace.RealityStonePit.Pedestal:FindFirstChild("Reality Stone")
        local part = getTeleportPart(current)
        if part then
            root.CFrame = part.CFrame + Vector3.new(0,5,0)
        end
    end
end)
