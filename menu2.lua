-- =========================
-- SUB HUB NEW RAYFIELD TEMPLATE
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
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local root = character:WaitForChild("HumanoidRootPart")

-- =========================
-- PLAYER SETTINGS TAB
-- =========================
local PlayerTab = Window:CreateTab("Player Settings")
PlayerTab:CreateSection("Adjust Your Character")

-- Walk Speed
PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 500},
    Increment = 1,
    CurrentValue = humanoid.WalkSpeed,
    Flag = "WalkSpeedSlider",
    Callback = function(value)
        humanoid.WalkSpeed = value
    end
})

-- Jump Power
PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 500},
    Increment = 1,
    CurrentValue = humanoid.JumpPower,
    Flag = "JumpPowerSlider",
    Callback = function(value)
        humanoid.JumpPower = value
    end
})

-- Hip Height
PlayerTab:CreateSlider({
    Name = "Hip Height",
    Range = {0, 20},
    Increment = 0.1,
    CurrentValue = humanoid.HipHeight,
    Flag = "HipHeightSlider",
    Callback = function(value)
        humanoid.HipHeight = value
    end
})

-- Player Scale
local scaleValue = 1
PlayerTab:CreateSlider({
    Name = "Player Scale",
    Range = {0.5, 5},
    Increment = 0.1,
    CurrentValue = scaleValue,
    Flag = "PlayerScaleSlider",
    Callback = function(value)
        scaleValue = value
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                part.Size = part.Size.Unit * scaleValue
            elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                part.Handle.Size = part.Handle.Size.Unit * scaleValue
            end
        end
    end
})

-- =========================
-- TELEPORT SAVE FEATURE
-- =========================
local savedCFrame = nil

PlayerTab:CreateButton({
    Name = "Save Current Position",
    Callback = function()
        savedCFrame = root.CFrame
        print("Position saved!")
    end
})

PlayerTab:CreateButton({
    Name = "Teleport to Saved Position",
    Callback = function()
        if savedCFrame then
            root.CFrame = savedCFrame
            print("Teleported to saved position!")
        else
            print("No saved position!")
        end
    end
})
