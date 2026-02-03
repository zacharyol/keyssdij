-- Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Sub Hub",
    LoadingTitle = "Loading",
    LoadingSubtitle = "By Zachary",
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
local humanoid = character:WaitForChild("Humanoid")

-- =========================
-- MAIN TAB (GUNS)
-- =========================
local MainTab = Window:CreateTab("Main")
MainTab:CreateSection("Guns")

local gunsFolder = ReplicatedStorage:WaitForChild("Tools"):WaitForChild("Guns")

local function cloneTool(tool)
    if not backpack:FindFirstChild(tool.Name) then
        tool:Clone().Parent = backpack
    end
end

MainTab:CreateButton({
    Name = "Get All Guns",
    Callback = function()
        for _, gun in ipairs(gunsFolder:GetChildren()) do
            if gun:IsA("Tool") then
                cloneTool(gun)
            end
        end
    end
})

for _, gun in ipairs(gunsFolder:GetChildren()) do
    if gun:IsA("Tool") then
        MainTab:CreateButton({
            Name = gun.Name,
            Callback = function()
                cloneTool(gun)
            end
        })
    end
end

-- =========================
-- ITEMS TAB (Tools + Melees)
-- =========================
local ItemsTab = Window:CreateTab("Items")
ItemsTab:CreateSection("All Items")

local toolsFolder = ReplicatedStorage:WaitForChild("Tools")
local meleeFolder = toolsFolder:FindFirstChild("Melees")

local function cloneItem(tool)
    if not backpack:FindFirstChild(tool.Name) then
        tool:Clone().Parent = backpack
    end
end

-- Add all Tools
for _, tool in ipairs(toolsFolder:GetChildren()) do
    if tool:IsA("Tool") then
        ItemsTab:CreateButton({
            Name = tool.Name,
            Callback = function()
                cloneItem(tool)
            end
        })
    end
end

-- Add all Melees
if meleeFolder then
    for _, melee in ipairs(meleeFolder:GetChildren()) do
        if melee:IsA("Tool") then
            ItemsTab:CreateButton({
                Name = melee.Name,
                Callback = function()
                    cloneItem(melee)
                end
            })
        end
    end
end

-- =========================
-- PRISON TAB
-- =========================
local PrisonTab = Window:CreateTab("Prison")
PrisonTab:CreateSection("Prison Controls")

-- Clear Prison Wall
PrisonTab:CreateButton({
    Name = "Clear Prison Wall",
    Callback = function()
        local wall = Workspace:FindFirstChild("Prison_OuterWall")
        if wall and wall:FindFirstChild("prison_wall") then
            for _, v in ipairs(wall.prison_wall:GetChildren()) do
                v:Destroy()
            end
        end
    end
})

-- Delete Doors
PrisonTab:CreateButton({
    Name = "Delete Doors",
    Callback = function()
        local d = Workspace:FindFirstChild("Doors")
        if d then
            for _, v in ipairs(d:GetChildren()) do
                v:Destroy()
            end
        end
    end
})

-- Delete Cell Doors
PrisonTab:CreateButton({
    Name = "Delete Cell Doors",
    Callback = function()
        local cd = Workspace:FindFirstChild("CellDoors")
        if cd then
            for _, v in ipairs(cd:GetChildren()) do
                v:Destroy()
            end
        end
    end
})

-- Grab Items (to YOUR position)
PrisonTab:CreateButton({
    Name = "Grab All Items",
    Callback = function()
        local items = Workspace:FindFirstChild("prison_ITEMS")
        if items and items:FindFirstChild("giver") then
            for _, obj in ipairs(items.giver:GetChildren()) do
                if obj:IsA("Tool") then
                    obj.Parent = backpack
                elseif obj:IsA("Model") then
                    if not obj.PrimaryPart then
                        for _, p in ipairs(obj:GetDescendants()) do
                            if p:IsA("BasePart") then
                                obj.PrimaryPart = p
                                break
                            end
                        end
                    end
                    if obj.PrimaryPart then
                        obj:SetPrimaryPartCFrame(root.CFrame * CFrame.new(0,3,0))
                    end
                elseif obj:IsA("BasePart") then
                    obj.CFrame = root.CFrame * CFrame.new(0,3,0)
                end
            end
        end
    end
})

-- =========================
-- GOD MODE
-- =========================
local godMode = false
PrisonTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Callback = function(v)
        godMode = v
    end
})

RunService.Heartbeat:Connect(function()
    if godMode and humanoid.Health < humanoid.MaxHealth then
        humanoid.Health = humanoid.MaxHealth
        humanoid.MaxHealth = math.huge
    end
end)

-- =========================
-- ANTI-TASER
-- =========================
local antiTaser = false
PrisonTab:CreateToggle({
    Name = "Anti-Taser",
    CurrentValue = false,
    Callback = function(v)
        antiTaser = v
    end
})

RunService.Heartbeat:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local pBackpack = plr:FindFirstChild("Backpack")
            if pBackpack then
                for _, tool in ipairs(pBackpack:GetChildren()) do
                    if antiTaser and tool.Name:lower():find("taser") then
                        tool:Destroy()
                    end
                end
            end
        end
    end

    -- Delete GunRemotes.PlayerTased if Anti-Taser enabled
    if antiTaser then
        local gunRemotes = ReplicatedStorage:FindFirstChild("GunRemotes")
        if gunRemotes and gunRemotes:FindFirstChild("PlayerTased") then
            gunRemotes.PlayerTased:Destroy()
        end
    end
end)

-- =========================
-- NOCLIP
-- =========================
local noclip = false
PrisonTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(v)
        noclip = v
    end
})

-- =========================
-- FLY
-- =========================
local flying = false
local speed = 60
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(1e5,1e5,1e5)
local move = Vector3.zero

PrisonTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(v)
        flying = v
        if v then
            bv.Parent = root
        else
            bv.Parent = nil
            move = Vector3.zero
        end
    end
})

RunService.Stepped:Connect(function()
    if noclip then
        for _, p in ipairs(character:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            end
        end
    end
    if flying then
        bv.Velocity = move * speed
    end
end)

UserInputService.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.W then move += root.CFrame.LookVector end
    if i.KeyCode == Enum.KeyCode.S then move -= root.CFrame.LookVector end
    if i.KeyCode == Enum.KeyCode.A then move -= root.CFrame.RightVector end
    if i.KeyCode == Enum.KeyCode.D then move += root.CFrame.RightVector end
    if i.KeyCode == Enum.KeyCode.Space then move += Vector3.yAxis end
    if i.KeyCode == Enum.KeyCode.LeftShift then move -= Vector3.yAxis end
end)

UserInputService.InputEnded:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.W then move -= root.CFrame.LookVector end
    if i.KeyCode == Enum.KeyCode.S then move += root.CFrame.LookVector end
    if i.KeyCode == Enum.KeyCode.A then move += root.CFrame.RightVector end
    if i.KeyCode == Enum.KeyCode.D then move -= root.CFrame.RightVector end
    if i.KeyCode == Enum.KeyCode.Space then move -= Vector3.yAxis end
    if i.KeyCode == Enum.KeyCode.LeftShift then move += Vector3.yAxis end
end)

-- =========================
-- ESP
-- =========================
local espEnabled = false
local espObjects = {}

local function createESP(plr)
    if plr == player then return end
    local function apply(char)
        if espObjects[plr] then espObjects[plr]:Destroy() end
        local h = Instance.new("Highlight")
        h.FillColor = Color3.fromRGB(255, 0, 0)
        h.OutlineColor = Color3.fromRGB(255,255,255)
        h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        h.Adornee = char
        h.Parent = char
        espObjects[plr] = h
    end
    if plr.Character then apply(plr.Character) end
    plr.CharacterAdded:Connect(apply)
end

PrisonTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Callback = function(v)
        espEnabled = v
        if not v then
            for _, h in pairs(espObjects) do
                h:Destroy()
            end
            espObjects = {}
        else
            for _, plr in ipairs(Players:GetPlayers()) do
                createESP(plr)
            end
        end
    end
})

Players.PlayerAdded:Connect(function(plr)
    if espEnabled then
        createESP(plr)
    end
end)

-- =========================
-- PLAYERS TAB
-- =========================
local PlayersTab = Window:CreateTab("Players")
PlayersTab:CreateSection("Teleport")

local buttons = {}

local function refreshPlayers()
    for _, b in pairs(buttons) do
        b:Remove()
    end
    buttons = {}

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = PlayersTab:CreateButton({
                Name = "TP to "..plr.Name,
                Callback = function()
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        root.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,5,0)
                    end
                end
            })
            table.insert(buttons, btn)
        end
    end
end

while true do
    refreshPlayers()
    task.wait(3)
end
