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
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- =========================
-- MAIN TAB
-- =========================
local MainTab = Window:CreateTab("Main")
MainTab:CreateSection("ESP Controls")

-- =========================
-- SHARK ESP
-- =========================
local sharkESPEnabled = false
local sharkHighlights = {}

MainTab:CreateToggle({
    Name = "Shark ESP",
    CurrentValue = false,
    Callback = function(v)
        sharkESPEnabled = v
        if not v then
            for _, h in pairs(sharkHighlights) do
                h:Destroy()
            end
            sharkHighlights = {}
        else
            -- Apply highlights to existing sharks
            local sharksFolder = Workspace:FindFirstChild("Sharks")
            if sharksFolder then
                for _, shark in ipairs(sharksFolder:GetChildren()) do
                    if shark:IsA("Model") then
                        if not shark.PrimaryPart then
                            for _, p in ipairs(shark:GetDescendants()) do
                                if p:IsA("BasePart") then
                                    shark.PrimaryPart = p
                                    break
                                end
                            end
                        end
                        if shark.PrimaryPart then
                            local h = Instance.new("Highlight")
                            h.FillColor = Color3.fromRGB(0, 0, 255)
                            h.OutlineColor = Color3.fromRGB(255, 255, 255)
                            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            h.Adornee = shark
                            h.Parent = shark
                            sharkHighlights[shark] = h
                        end
                    end
                end
            end
        end
    end
})

-- Update shark ESP for new sharks
Workspace.ChildAdded:Connect(function(child)
    if sharkESPEnabled and child.Parent == Workspace and child.Name == "Sharks" then
        for _, shark in ipairs(child:GetChildren()) do
            if shark:IsA("Model") and not sharkHighlights[shark] then
                if not shark.PrimaryPart then
                    for _, p in ipairs(shark:GetDescendants()) do
                        if p:IsA("BasePart") then
                            shark.PrimaryPart = p
                            break
                        end
                    end
                end
                if shark.PrimaryPart then
                    local h = Instance.new("Highlight")
                    h.FillColor = Color3.fromRGB(0, 0, 255)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Adornee = shark
                    h.Parent = shark
                    sharkHighlights[shark] = h
                end
            end
        end
    end
end)

-- =========================
-- PLAYER ESP
-- =========================
local playerESPEnabled = false
local playerHighlights = {}

MainTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(v)
        playerESPEnabled = v
        if not v then
            for _, h in pairs(playerHighlights) do
                h:Destroy()
            end
            playerHighlights = {}
        else
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    if playerHighlights[plr] then playerHighlights[plr]:Destroy() end
                    local h = Instance.new("Highlight")
                    h.FillColor = Color3.fromRGB(255, 0, 0)
                    h.OutlineColor = Color3.fromRGB(255, 255, 255)
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Adornee = plr.Character
                    h.Parent = plr.Character
                    playerHighlights[plr] = h
                end
            end
        end
    end
})

-- Update player ESP when new players join
Players.PlayerAdded:Connect(function(plr)
    if playerESPEnabled and plr ~= player then
        plr.CharacterAdded:Connect(function(char)
            if playerESPEnabled then
                local h = Instance.new("Highlight")
                h.FillColor = Color3.fromRGB(255, 0, 0)
                h.OutlineColor = Color3.fromRGB(255, 255, 255)
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                h.Adornee = char
                h.Parent = char
                playerHighlights[plr] = h
            end
        end)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if playerHighlights[plr] then
        playerHighlights[plr]:Destroy()
        playerHighlights[plr] = nil
    end
end)

print("ESP hub loaded successfully!")
