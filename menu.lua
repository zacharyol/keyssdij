-- ========================
-- Prison Tab
-- ========================
local PrisonTab = Window:CreateTab("Prison", 4483362458)
local PrisonSection = PrisonTab:CreateSection("Wall & Movement") -- create a section first

-- Clear Prison Wall button
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
            else
                warn("prison_wall not found in Prison_OuterWall")
            end
        else
            warn("Prison_OuterWall not found in workspace")
        end
    end,
})

-- Noclip toggle
local noclipEnabled = false
PrisonSection:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(value)
        noclipEnabled = value
    end
})

RunService.Stepped:Connect(function()
    if noclipEnabled then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Fly toggle
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

-- Doors toggle
local doorsEnabled = false
PrisonSection:CreateToggle({
    Name = "Toggle Doors",
    CurrentValue = false,
    Flag = "DoorsToggle",
    Callback = function(value)
        doorsEnabled = value
    end
})

-- Fly movement logic
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

RunService.RenderStepped:Connect(function()
    -- Fly
    if flying then
        if moveVector.Magnitude > 0 then
            flyVelocity.Velocity = moveVector.Unit * flySpeed
        else
            flyVelocity.Velocity = Vector3.new(0,0,0)
        end
    end

    -- Doors toggle
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
