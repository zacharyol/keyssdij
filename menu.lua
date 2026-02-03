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
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- Tool folders
local toolsFolder = ReplicatedStorage:WaitForChild("Tools")
local gunsFolder = toolsFolder:WaitForChild("Guns") -- ensure capitalization matches

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

-- Individual Gun Buttons
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
local PrisonSection = PrisonTab:CreateSection("Wall Tools & Movement")

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
                warn("prison_wall not found in Prison_OuterWall")
            end
        else
            warn("Prison_OuterWall not found in workspace")
        end
    end,
})

-- Noclip toggle
local noclipEnabled = false
PrisonTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(value)
        noclipEnabled = value
    end
})

RunService.Stepped:Connect(function()
    if noclipEnabled then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- Fly toggle
local flying = false
local flySpeed = 50
local flyVelocity = Instance.new("BodyVelocity")
flyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
flyVelocity.Velocity = Vector3.new(0,0,0)

local flyDirection = Vector3.new(0,0,0)

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
        end
    end
})

-- Fly movement input
local moveVector = Vector3.new(0,0,0)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then
        moveVector = moveVector + root.CFrame.LookVector
    elseif input.KeyCode == Enum.KeyCode.S then
        moveVector = moveVector - root.CFrame.LookVector
    elseif input.KeyCode == Enum.KeyCode.A then
        moveVector = moveVector - root.CFrame.RightVector
    elseif input.KeyCode == Enum.KeyCode.D then
        moveVector = moveVector + root.CFrame.RightVector
    elseif input.KeyCode == Enum.KeyCode.Space then
        moveVector = moveVector + Vector3.new(0,1,0)
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        moveVector = moveVector - Vector3.new(0,1,0)
    end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then
        moveVector = moveVector - root.CFrame.LookVector
    elseif input.KeyCode == Enum.KeyCode.S then
        moveVector = moveVector + root.CFrame.LookVector
    elseif input.KeyCode == Enum.KeyCode.A then
        moveVector = moveVector + root.CFrame.RightVector
    elseif input.KeyCode == Enum.KeyCode.D then
        moveVector = moveVector - root.CFrame.RightVector
    elseif input.KeyCode == Enum.KeyCode.Space then
        moveVector = moveVector - Vector3.new(0,1,0)
    elseif input.KeyCode == Enum.KeyCode.LeftShift then
        moveVector = moveVector + Vector3.new(0,1,0)
    end
end)

RunService.RenderStepped:Connect(function(delta)
    if flying then
        flyVelocity.Velocity = moveVector.Unit * flySpeed
    end
end)

-- ========================
-- Players Tab
-- ========================
local PlayersTab = Window:CreateTab("Players", 4483362458)
local PlayersSection = PlayersTab:CreateSection("Teleport to Player")

local playerButtons = {}

-- Function to refresh buttons
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
                end,
            })
            table.insert(playerButtons, btn)
        end
    end
end

-- Update player buttons every 3 seconds
while true do
    updatePlayerButtons()
    task.wait(3)
end
