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
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- ========================
-- Prison Tab
-- ========================
local PrisonTab = Window:CreateTab("Prison", 4483362458)
local PrisonSection = PrisonTab:CreateSection("Prison Tools & Movement")

-- Clear Prison Wall Button
PrisonSection:CreateButton({
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
            end
        end
    end
})

-- Noclip Toggle
local noclipEnabled = false
PrisonSection:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(value)
        noclipEnabled = value
    end
})

-- Fly Toggle
local flying = false
local flySpeed = 50
local flyVelocity = Instance.new("BodyVelocity")
flyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
flyVelocity.Velocity = Vector3.new(0,0,0)

local moveVector = Vector3.new(0,0,0)

PrisonSection:CreateToggle({
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

-- Doors Toggle
local doorsEnabled = false
PrisonSection:CreateToggle({
    Name = "Toggle Doors",
    CurrentValue = false,
    Flag = "DoorsToggle",
    Callback = function(value)
        doorsEnabled = value
    end
})

-- ========================
-- Noclip / Fly / Doors Logic
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

    -- Doors Toggle
    local doorsFolder = Workspace:FindFirstChild("Doors")
    if doorsFolder then
        for _, door in ipairs(doorsFolder:GetChildren()) do
            if door:IsA("BasePart") then
                if doorsEnabled then
                    door.CanCollide = false
                    door.Transparency = 0.5
                else
                    door.CanCollide = true
                    door.Transparency = 0
                end
            end
        end
    end
end)

-- Fly input
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

RunService.RenderStepped:Connect(function(delta)
    if flying then
        if moveVector.Magnitude > 0 then
            flyVelocity.Velocity = moveVector.Unit * flySpeed
        else
            flyVelocity.Velocity = Vector3.new(0,0,0)
        end
    end
end)
