-- Rayfield UI
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Sub Hub",
    LoadingTitle = "Loading",
    LoadingSubtitle = "By Zachary",
    ToggleUIKeybind = "K",
    KeySystem = false
})

-- Services
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local function getCharacter()
    return player.Character or player.CharacterAdded:Wait()
end

local function getRoot()
    return getCharacter():WaitForChild("HumanoidRootPart")
end

-- =========================
-- TAB
-- =========================
local Tab = Window:CreateTab("Main")

-- =========================
-- INPUT HELPERS
-- =========================

local function pressKey(key)
    VirtualInputManager:SendKeyEvent(true, key, false, game)
    task.wait(0.1)
    VirtualInputManager:SendKeyEvent(false, key, false, game)
end

local function clickMouse()
    VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
    task.wait()
    VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
end

local function teleportTo(part)
    if part and part:IsA("BasePart") then
        getRoot().CFrame = part.CFrame + Vector3.new(0,3,0)
    end
end

local function hoverOver(part)
    local screenPos, visible = camera:WorldToViewportPoint(part.Position)
    if visible then
        VirtualInputManager:SendMouseMoveEvent(screenPos.X, screenPos.Y, game)
        task.wait(0.25) -- WAIT to ensure hover registers
    end
end

-- =========================
-- GAME HELPERS
-- =========================

local function getRandomTree()
    local foliage = workspace:FindFirstChild("Map")
        and workspace.Map:FindFirstChild("Foliage")

    if not foliage then return nil end

    local trees = {}

    for _, v in ipairs(foliage:GetChildren()) do
        if v.Name:lower():find("small tree") then
            table.insert(trees, v)
        end
    end

    if #trees == 0 then return nil end
    return trees[math.random(1,#trees)]
end

local function getWorkspaceLogs()
    local items = workspace:FindFirstChild("Items")
    if not items then return {} end

    local logs = {}
    for _, v in ipairs(items:GetChildren()) do
        if v.Name:lower():find("log") then
            table.insert(logs, v)
        end
    end

    return logs
end

local function getBagLogCount()
    local bag = player:FindFirstChild("ItemBag")
    if not bag then return 0 end

    local count = 0
    for _, item in ipairs(bag:GetChildren()) do
        if item.Name:lower():find("log") then
            count += 1
        end
    end

    return count
end

local function getFire()
    return workspace:FindFirstChild("Map")
        and workspace.Map:FindFirstChild("Campground")
        and workspace.Map.Campground:FindFirstChild("MainFire")
        and workspace.Map.Campground.MainFire:FindFirstChild("Center")
end

-- =========================
-- AUTO CHOP SYSTEM
-- =========================

local autoChop = false

Tab:CreateToggle({
    Name = "Auto Chop Trees",
    CurrentValue = false,
    Callback = function(v)
        autoChop = v
    end
})

task.spawn(function()
    while true do
        task.wait(0.2)

        if not autoChop then
            continue
        end

        local tree = getRandomTree()
        if not tree then
            task.wait(2)
            continue
        end

        -- TELEPORT TO TREE
        teleportTo(tree.PrimaryPart or tree:FindFirstChildWhichIsA("BasePart"))
        task.wait(0.5)

        -- EQUIP AXE (2)
        pressKey(Enum.KeyCode.Two)
        task.wait(0.3)

        -- CHOP UNTIL LOGS SPAWN
        local timeout = tick() + 10
        repeat
            clickMouse()
            task.wait(0.25)
        until #getWorkspaceLogs() > 0 or tick() > timeout

        -- PICKUP LOGS
        local startingCount = getBagLogCount()

        for _, log in ipairs(getWorkspaceLogs()) do
            if not autoChop then break end

            local part = log:IsA("BasePart") and log
                or log:FindFirstChildWhichIsA("BasePart")

            if part then
                teleportTo(part)
                task.wait(0.3)

                -- EQUIP SACK (1)
                pressKey(Enum.KeyCode.One)
                task.wait(0.2)

                -- HOVER BEFORE PRESSING F
                hoverOver(part)

                pressKey(Enum.KeyCode.F)
                task.wait(0.4)
            end
        end

        -- WAIT UNTIL BAG UPDATES
        local waitTimeout = tick() + 5
        repeat
            task.wait(0.2)
        until getBagLogCount() > startingCount or tick() > waitTimeout

        -- DEPOSIT AT FIRE
        if getBagLogCount() > 0 then
            local fire = getFire()
            if fire then
                teleportTo(fire)
                task.wait(0.5)
                pressKey(Enum.KeyCode.F)
            end
        end

        task.wait(1)
    end
end)

-- =========================
-- MANUAL FIRE TP
-- =========================

Tab:CreateButton({
    Name = "Teleport To Fire",
    Callback = function()
        teleportTo(getFire())
    end
})
