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

-- Tables to store highlights
local sharkHighlights = {}
local playerHighlights = {}
local boatHighlights = {}

-- =========================
-- MAIN TAB
-- =========================
local MainTab = Window:CreateTab("Main")
MainTab:CreateSection("ESP Features")

-- SHARK ESP
local sharkESPEnabled = false
MainTab:CreateToggle({
    Name = "Shark ESP",
    CurrentValue = false,
    Callback = function(v)
        sharkESPEnabled = v
        if not v then
            for _, h in pairs(sharkHighlights) do h:Destroy() end
            sharkHighlights = {}
        else
            local sharks = Workspace:FindFirstChild("Sharks")
            if sharks then
                for _, shark in ipairs(sharks:GetChildren()) do
                    if shark:IsA("Model") then
                        if not shark.PrimaryPart then
                            for _, p in ipairs(shark:GetDescendants()) do
                                if p:IsA("BasePart") then
                                    shark.PrimaryPart = p
                                    break
                                end
                            end
                        end
                        if shark.PrimaryPart and not sharkHighlights[shark] then
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

-- PLAYER ESP
local playerESPEnabled = false
MainTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(v)
        playerESPEnabled = v
        if not v then
            for _, h in pairs(playerHighlights) do h:Destroy() end
            playerHighlights = {}
        else
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
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

-- BOAT ESP
local boatESPEnabled = false
MainTab:CreateToggle({
    Name = "Boat ESP",
    CurrentValue = false,
    Callback = function(v)
        boatESPEnabled = v
        if not v then
            for _, h in pairs(boatHighlights) do h:Destroy() end
            boatHighlights = {}
        else
            local boatsFolder = Workspace:FindFirstChild("Boats")
            if boatsFolder then
                for _, boat in ipairs(boatsFolder:GetChildren()) do
                    if boat:IsA("Model") then
                        if not boat.PrimaryPart then
                            for _, p in ipairs(boat:GetDescendants()) do
                                if p:IsA("BasePart") then
                                    boat.PrimaryPart = p
                                    break
                                end
                            end
                        end
                        if boat.PrimaryPart and not boatHighlights[boat] then
                            local h = Instance.new("Highlight")
                            h.FillColor = Color3.fromRGB(0, 255, 255)
                            h.OutlineColor = Color3.fromRGB(255, 255, 255)
                            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            h.Adornee = boat
                            h.Parent = boat
                            boatHighlights[boat] = h
                        end
                    end
                end
            end
        end
    end
})

-- AUTO REFRESH BOAT ESP every 5 seconds
spawn(function()
    while true do
        if boatESPEnabled then
            local boatsFolder = Workspace:FindFirstChild("Boats")
            if boatsFolder then
                for _, boat in ipairs(boatsFolder:GetChildren()) do
                    if boat:IsA("Model") and not boatHighlights[boat] then
                        if not boat.PrimaryPart then
                            for _, p in ipairs(boat:GetDescendants()) do
                                if p:IsA("BasePart") then
                                    boat.PrimaryPart = p
                                    break
                                end
                            end
                        end
                        if boat.PrimaryPart then
                            local h = Instance.new("Highlight")
                            h.FillColor = Color3.fromRGB(0, 255, 255)
                            h.OutlineColor = Color3.fromRGB(255, 255, 255)
                            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            h.Adornee = boat
                            h.Parent = boat
                            boatHighlights[boat] = h
                        end
                    end
                end
            end
        end
        task.wait(5)
    end
end)

-- =========================
-- REFRESH ALL ESPs BUTTON
-- =========================
MainTab:CreateButton({
    Name = "Refresh All ESPs",
    Callback = function()
        -- Destroy all highlights
        for _, h in pairs(sharkHighlights) do h:Destroy() end
        for _, h in pairs(playerHighlights) do h:Destroy() end
        for _, h in pairs(boatHighlights) do h:Destroy() end

        sharkHighlights = {}
        playerHighlights = {}
        boatHighlights = {}

        -- Reapply ESPs if toggled
        if sharkESPEnabled then
            local sharks = Workspace:FindFirstChild("Sharks")
            if sharks then
                for _, shark in ipairs(sharks:GetChildren()) do
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

        if playerESPEnabled then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
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

        if boatESPEnabled then
            local boatsFolder = Workspace:FindFirstChild("Boats")
            if boatsFolder then
                for _, boat in ipairs(boatsFolder:GetChildren()) do
                    if boat:IsA("Model") then
                        if not boat.PrimaryPart then
                            for _, p in ipairs(boat:GetDescendants()) do
                                if p:IsA("BasePart") then
                                    boat.PrimaryPart = p
                                    break
                                end
                            end
                        end
                        if boat.PrimaryPart then
                            local h = Instance.new("Highlight")
                            h.FillColor = Color3.fromRGB(0, 255, 255)
                            h.OutlineColor = Color3.fromRGB(255, 255, 255)
                            h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            h.Adornee = boat
                            h.Parent = boat
                            boatHighlights[boat] = h
                        end
                    end
                end
            end
        end
    end
})
