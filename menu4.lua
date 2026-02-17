--// Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Sub Hub",
    LoadingTitle = "Loading",
    LoadingSubtitle = "By Zachary",
    ToggleUIKeybind = "K",
    KeySystem = false
})

--// Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

--// STATE
local SharkESPEnabled = false
local PlayerESPEnabled = false
local BoatESPEnabled = false
local AutoRunEnabled = false

local TriggerDistance = 120 -- slider controlled

--// ESP STORAGE
local ESPObjects = {}

--// TAB
local MainTab = Window:CreateTab("Main")
MainTab:CreateSection("ESP")

---------------------------------------------------
-- CLEAR ESP
---------------------------------------------------
local function ClearESP()
    for _, h in pairs(ESPObjects) do
        if h then h:Destroy() end
    end
    ESPObjects = {}
end

---------------------------------------------------
-- CREATE ESP
---------------------------------------------------
local function CreateESP(obj, color)
    if not obj then return end
    if ESPObjects[obj] then return end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = color
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = obj
    highlight.Parent = obj

    ESPObjects[obj] = highlight
end

---------------------------------------------------
-- REFRESH ESP
---------------------------------------------------
local function RefreshESP()
    ClearESP()

    -- Sharks
    if SharkESPEnabled then
        local sharksFolder = Workspace:FindFirstChild("Sharks")
        if sharksFolder then
            for _, shark in ipairs(sharksFolder:GetChildren()) do
                if shark:IsA("Model") then
                    CreateESP(shark, Color3.fromRGB(255,0,0))
                end
            end
        end
    end

    -- Players
    if PlayerESPEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                CreateESP(plr.Character, Color3.fromRGB(255,255,0))
            end
        end
    end

    -- Boats
    if BoatESPEnabled then
        local boatsFolder = Workspace:FindFirstChild("Boats")
        if boatsFolder then
            for _, boat in ipairs(boatsFolder:GetChildren()) do
                if boat:IsA("Model") or boat:IsA("BasePart") then
                    CreateESP(boat, Color3.fromRGB(0,170,255))
                end
            end
        end
    end
end

---------------------------------------------------
-- ESP TOGGLES
---------------------------------------------------
MainTab:CreateToggle({
    Name = "Shark ESP",
    CurrentValue = false,
    Callback = function(v)
        SharkESPEnabled = v
        RefreshESP()
    end
})

MainTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(v)
        PlayerESPEnabled = v
        RefreshESP()
    end
})

MainTab:CreateToggle({
    Name = "Boat ESP",
    CurrentValue = false,
    Callback = function(v)
        BoatESPEnabled = v
        RefreshESP()
    end
})

MainTab:CreateButton({
    Name = "Refresh ESP",
    Callback = function()
        RefreshESP()
    end
})

---------------------------------------------------
-- SAFETY SECTION
---------------------------------------------------
MainTab:CreateSection("Safety")

MainTab:CreateToggle({
    Name = "Auto Run From Shark",
    CurrentValue = false,
    Callback = function(v)
        AutoRunEnabled = v
    end
})

MainTab:CreateSlider({
    Name = "Run Trigger Distance",
    Range = {50, 300},
    Increment = 5,
    Suffix = "Studs",
    CurrentValue = 120,
    Callback = function(Value)
        TriggerDistance = Value
    end
})

---------------------------------------------------
-- FIND NEAREST SHARK
---------------------------------------------------
local function GetNearestShark()
    local sharksFolder = Workspace:FindFirstChild("Sharks")
    local character = LocalPlayer.Character
    if not sharksFolder or not character then return end

    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local closestPart
    local closestDistance = math.huge

    for _, shark in ipairs(sharksFolder:GetChildren()) do
        local part = shark.PrimaryPart or shark:FindFirstChildWhichIsA("BasePart")
        if part then
            local dist = (root.Position - part.Position).Magnitude
            if dist < closestDistance then
                closestDistance = dist
                closestPart = part
            end
        end
    end

    return closestPart, closestDistance
end

---------------------------------------------------
-- AUTO ESCAPE LOOP
---------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.1)

        if not AutoRunEnabled then continue end

        local sharkPart, distance = GetNearestShark()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")

        if sharkPart and root and distance < TriggerDistance then
            local direction = (root.Position - sharkPart.Position).Unit

            -- distance scaled escape
            local escapeDistance = math.clamp(200 - distance, 60, 200)

            local newPos = root.Position + (direction * escapeDistance)
            root.CFrame = CFrame.new(newPos)
        end
    end
end)

---------------------------------------------------
-- AUTO REFRESH ESP
---------------------------------------------------
task.spawn(function()
    while true do
        task.wait(5)
        RefreshESP()
    end
end)
