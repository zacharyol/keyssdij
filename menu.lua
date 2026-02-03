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
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

-- Tool folders
local toolsFolder = ReplicatedStorage:WaitForChild("Tools")
local gunsFolder = toolsFolder:WaitForChild("Guns") -- make sure capitalization matches

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
local PrisonSection = PrisonTab:CreateSection("Wall Tools")

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

-- ========================
-- Players Tab
-- ========================
local PlayersTab = Window:CreateTab("Players", 4483362458)
local PlayersSection = PlayersTab:CreateSection("Teleport to Player")

-- Table to keep track of buttons
local playerButtons = {}

-- Function to refresh buttons
local function updatePlayerButtons()
    -- Remove old buttons
    for _, btn in pairs(playerButtons) do
        btn:Remove()
    end
    playerButtons = {}

    -- Create new buttons for each player
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
