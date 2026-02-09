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

    KeySystem = false,
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
-- PRISONER AIM-ASSIST (SILENT AIM)
-- =========================
local aimAssistEnabled = false
local aimAssistKey = Enum.KeyCode.E -- Toggle key

-- Add toggle in your MainTab
MainTab:CreateToggle({
    Name = "Aim-Assist (Prisoners)",
    CurrentValue = false,
    Callback = function(v)
        aimAssistEnabled = v
    end
})

-- Function to get closest prisoner
local function getClosestPrisoner()
    local closest
    local distance = math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Team and plr.Team.Name == "Inmates" and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if dist < distance then
                distance = dist
                closest = plr
            end
        end
    end
    return closest
end

-- Toggle keybind
UserInputService.InputBegan:Connect(function(input, g)
    if g then return end
    if input.KeyCode == aimAssistKey then
        aimAssistEnabled = not aimAssistEnabled
        print("Aim-Assist toggled:", aimAssistEnabled)
    end
end)

-- Smooth camera rotation toward target
RunService.RenderStepped:Connect(function(delta)
    if aimAssistEnabled then
        local target = getClosestPrisoner()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local cam = workspace.CurrentCamera
            local targetPos = target.Character.HumanoidRootPart.Position

            -- Smoothly rotate camera
            local currentCFrame = cam.CFrame
            local desiredCFrame = CFrame.lookAt(currentCFrame.Position, targetPos)
            cam.CFrame = currentCFrame:Lerp(desiredCFrame, 0.15) -- 0.15 = smoothness
        end
    end
end)

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

-- =========================
-- ARREST ALL CRIMINALS
-- =========================
local arresting = false
local mouse = player:GetMouse()

PrisonTab:CreateToggle({
    Name = "Arrest All Criminals",
    CurrentValue = false,
    Callback = function(v)
        arresting = v
        if not v then return end

        task.spawn(function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if not arresting then break end
                if plr ~= player
                and plr.Team
                and plr.Team.Name == "Criminals"
                and plr.Character
                and plr.Character:FindFirstChild("HumanoidRootPart") then

                    -- Make sure we are holding handcuffs
                    local cuffs = backpack:FindFirstChild("Handcuffs") or character:FindFirstChild("Handcuffs")
                    if not cuffs then
                        warn("Handcuffs not equipped. Stopping arrest loop.")
                        arresting = false
                        break
                    end

                    -- Equip handcuffs if needed
                    if cuffs.Parent ~= character then
                        humanoid:EquipTool(cuffs)
                        task.wait(0.4)
                    end

                    -- Slow teleport near target
                    local targetRoot = plr.Character.HumanoidRootPart
                    local steps = 15
                    for i = 1, steps do
                        if not arresting then return end
                        root.CFrame = root.CFrame:Lerp(
                            targetRoot.CFrame * CFrame.new(0, 0, 2),
                            i / steps
                        )
                        task.wait(0.05)
                    end

                    -- Wait for player click
                    local clicked = false
                    local conn
                    conn = mouse.Button1Down:Connect(function()
                        clicked = true
                        conn:Disconnect()
                    end)

                    while not clicked and arresting do
                        task.wait()
                    end

                    -- Small delay before next criminal
                    task.wait(0.6)
                end
            end

            arresting = false
        end)
    end
})


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
    if godMode then
        humanoid.MaxHealth = math.huge
        humanoid.Health = humanoid.MaxHealth
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
    if not antiTaser then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local bp = plr:FindFirstChild("Backpack")
            if bp then
                for _, tool in ipairs(bp:GetChildren()) do
                    if tool.Name:lower():find("taser") then
                        tool:Destroy()
                    end
                end
            end
        end
    end

    local gr = ReplicatedStorage:FindFirstChild("GunRemotes")
    if gr and gr:FindFirstChild("PlayerTased") then
        gr.PlayerTased:Destroy()
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
        h.FillColor = Color3.fromRGB(255,0,0)
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
            for _, h in pairs(espObjects) do h:Destroy() end
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
    for _, b in pairs(buttons) do b:Remove() end
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
