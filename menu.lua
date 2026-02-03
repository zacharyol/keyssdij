-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Sub Hub",
    LoadingTitle = "Loading",
    LoadingSubtitle = "By Zachary",
    ShowText = "Sub Hub",
    Theme = "Default",
    ToggleUIKeybind = "K",
})

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- Tool folders
local toolsFolder = ReplicatedStorage:WaitForChild("Tools")
local gunsFolder = toolsFolder:WaitForChild("Guns")

-- ========================
-- Main Tab (Guns)
-- ========================
local MainTab = Window:CreateTab("Main", 4483362458)
local MainSection = MainTab:CreateSection("Gun Menu")

-- Get All Guns Button
MainTab:CreateButton({
    Name = "Get All Guns",
    Callback = function()
        for _, v in ipairs(gunsFolder:GetChildren()) do
            if v:IsA("Tool") and not backpack:FindFirstChild(v.Name) then
                v:Clone().Parent = backpack
            end
        end
    end,
})

-- Individual gun buttons
for _, gun in ipairs(gunsFolder:GetChildren()) do
    if gun:IsA("Tool") then
        MainTab:CreateButton({
            Name = gun.Name,
            Callback = function()
                if not backpack:FindFirstChild(gun.Name) then
                    gun:Clone().Parent = backpack
                end
            end,
        })
    end
end

-- ========================
-- Prison Tab
-- ========================
local PrisonTab = Window:CreateTab("Prison", 4483362458)
local PrisonSection = PrisonTab:CreateSection("Wall & Movement")

-- Clear Prison Wall Button
PrisonTab:CreateButton({
    Name = "Clear Prison Wall",
    Callback = function()
        local wall = Workspace:FindFirstChild("Prison_OuterWall")
        if wall then
            local prison_wall = wall:FindFirstChild("prison_wall")
            if prison_wall then
                for _, child in ipairs(prison_wall:GetChildren()) do
                    child:Destroy()
                end
                print("Prison wall cleared!")
            else
                warn("prison_wall not found")
            end
        else
            warn("Prison_OuterWall not found")
        end
    end,
})

-- Noclip Toggle
local noclipEnabled = false
PrisonTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(value)
        noclipEnabled = value
    end,
})

-- Fly Toggle
local flying = false
local flySpeed = 50
local flyVelocity = Instance.new("BodyVelocity")
flyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
flyVelocity.Velocity = Vector3.new(0,0,0)
local moveVector = Vector3.new(0,0,0)

PrisonTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(value)
        flying = value
        if flying then
            flyVelocity.Parent = root
        else
            flyVelocity.Parent = nil
            moveVector = Vector3.new(0,0,0)
        end
    end
})

-- Delete All Doors Button
PrisonTab:CreateButton({
    Name = "Delete All Doors",
    Callback = function()
        local doorsFolder = Workspace:FindFirstChild("Doors")
        if doorsFolder then
            for _, door in ipairs(doorsFolder:GetChildren()) do
                if door:IsA("BasePart") or door:IsA("Model") then
                    door:Destroy()
                end
            end
            print("All doors deleted!")
        else
            warn("Doors folder not found in workspace")
        end
    end
})

-- Grab All Items Button (prison_ITEMS.giver) at your position
PrisonTab:CreateButton({
    Name = "Grab All Items",
    Callback = function()
        local itemsFolder = Workspace:FindFirstChild("prison_ITEMS")
        if itemsFolder then
            local giver = itemsFolder:FindFirstChild("giver")
            if giver then
                for _, item in ipairs(giver:GetChildren()) do
                    if item:IsA("Tool") then
                        item.Parent = backpack
                    elseif item:IsA("BasePart") then
                        local offset = Vector3.new(0,3,0)
                        item.CFrame = root.CFrame + offset
                    elseif item:IsA("Model") then
                        if not item.PrimaryPart then
                            for _, p in ipairs(item:GetDescendants()) do
                                if p:IsA("BasePart") then
                                    item.PrimaryPart = p
                                    break
                                end
                            end
                        end
                        if item.PrimaryPart then
                            item:SetPrimaryPartCFrame(root.CFrame + Vector3.new(0,3,0))
                        end
                    end
                end
                print("All items grabbed at your position!")
            else
                warn("giver folder not found in prison_ITEMS")
            end
        else
            warn("prison_ITEMS folder not found in workspace")
        end
    end
})

-- ========================
-- Fly / Noclip Logic
-- ========================
RunService.Stepped:Connect(function()
    -- Noclip
    if noclipEnabled then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    -- Fly
    if flying then
        if moveVector.Magnitude > 0 then
            flyVelocity.Velocity = moveVector.Unit * flySpeed
        else
            flyVelocity.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- Fly movement input
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then moveVector = moveVector + root.CFrame.LookVector end
    if input.KeyCode == Enum.KeyCode.S then moveVector = moveVector - root.CFrame.LookVector end
    if input.KeyCode == Enum.KeyCode.A then moveVector = moveVector - root.CFrame.RightVector end
    if input.KeyCode == Enum.KeyCode.D then moveVector = moveVector + root.CFrame.RightVector end
    if input.KeyCode == Enum.KeyCode.Space then moveVector = moveVector + Vector3.new(0,1,0) end
    if input.KeyCode == Enum.KeyCode.LeftShift then moveVector = moveVector - Vector3.new(0,1,0) end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then moveVector = moveVector - root.CFrame.LookVector end
    if input.KeyCode == Enum.KeyCode.S then moveVector = moveVector + root.CFrame.LookVector end
    if input.KeyCode == Enum.KeyCode.A then moveVector = moveVector + root.CFrame.RightVector end
    if input.KeyCode == Enum.KeyCode.D then moveVector = moveVector - root.CFrame.RightVector end
    if input.KeyCode == Enum.KeyCode.Space then moveVector = moveVector - Vector3.new(0,1,0) end
    if input.KeyCode == Enum.KeyCode.LeftShift then moveVector = moveVector + Vector3.new(0,1,0) end
end)

-- ========================
-- Players Tab
-- ========================
local PlayersTab = Window:CreateTab("Players", 4483362458)
local PlayersSection = PlayersTab:CreateSection("Teleport to Player")

local playerButtons = {}

local function updatePlayerButtons()
    for _, btn in pairs(playerButtons) do
        btn:Remove()
    end
    playerButtons = {}

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = PlayersTab:CreateButton({
                Name = "TP to " .. plr.Name,
                Callback = function()
                    local char = plr.Character
                    local myChar = player.Character
                    if char and char:FindFirstChild("HumanoidRootPart") and myChar and myChar:FindFirstChild("HumanoidRootPart") then
                        myChar.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
                    end
                end
            })
            table.insert(playerButtons, btn)
        end
    end
end

-- Auto-update player buttons every 3 seconds
while true do
    updatePlayerButtons()
    task.wait(3)
end
