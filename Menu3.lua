-- Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Sub Hub",
    LoadingTitle = "Loading",
    LoadingSubtitle = "By Zachary",
    ToggleUIKeybind = "K"
})

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

-- =========================
-- MAIN TAB
-- =========================
local MainTab = Window:CreateTab("Main")
MainTab:CreateSection("Farming")

-- =========================
-- FARM STARS
-- =========================
local farmingStars = false

MainTab:CreateToggle({
    Name = "Farm Stars",
    CurrentValue = false,
    Callback = function(v)
        farmingStars = v

        if v then
            task.spawn(function()
                while farmingStars do
                    local main = Workspace:FindFirstChild("Main")
                    if main and main:FindFirstChild("PointGivers") then
                        for _, part in ipairs(main.PointGivers:GetChildren()) do
                            if not farmingStars then break end

                            if part:IsA("BasePart") then
                                root.CFrame = part.CFrame + Vector3.new(0,3,0)
                                task.wait(0.6)
                            end
                        end
                    end
                    task.wait(0.2)
                end
            end)
        end
    end
})

-- =========================
-- FARM ORBS
-- =========================
local farmingOrbs = false

MainTab:CreateToggle({
    Name = "Farm Orbs",
    CurrentValue = false,
    Callback = function(v)
        farmingOrbs = v

        if v then
            task.spawn(function()
                while farmingOrbs do
                    local main = Workspace:FindFirstChild("Main")
                    if main and main:FindFirstChild("Orb") and main.Orb:FindFirstChild("Orbs") then
                        for _, orb in ipairs(main.Orb.Orbs:GetChildren()) do
                            if not farmingOrbs then break end

                            if orb:IsA("BasePart") then
                                root.CFrame = orb.CFrame + Vector3.new(0,3,0)
                                task.wait(0.3)
                            elseif orb:IsA("Model") and orb.PrimaryPart then
                                root.CFrame = orb.PrimaryPart.CFrame + Vector3.new(0,3,0)
                                task.wait(0.3)
                            end
                        end
                    end
                    task.wait(0.2)
                end
            end)
        end
    end
})

-- =========================
-- REMOVE COOLDOWN FRAME
-- =========================
MainTab:CreateButton({
    Name = "Remove Cooldown Frame",
    Callback = function()

        local function removeCooldown()
            local playerGui = player:FindFirstChild("PlayerGui")
            if not playerGui then return end

            local hud = playerGui:FindFirstChild("HUD")
            if not hud then return end

            local frames = hud:FindFirstChild("Frames")
            if not frames then return end

            local custom = frames:FindFirstChild("CustomMessageFrame")
            if not custom then return end

            local cooldown = custom:FindFirstChild("CooldownFrame")
            if cooldown then
                cooldown:Destroy()
            end
        end

        -- remove immediately
        removeCooldown()

        -- remove again if recreated
        player.PlayerGui.DescendantAdded:Connect(function(obj)
            if obj.Name == "CooldownFrame" then
                obj:Destroy()
            end
        end)
    end
})
