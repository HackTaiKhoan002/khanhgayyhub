-- Load UI Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({
    Name = "Aimbot Pro v1.0",
    HidePremium = false,
    IntroEnabled = false,
    SaveConfig = false
})

-- Configuration
local Settings = {
    AimbotEnabled = false,
    TargetType = "Mobs", -- Mobs or Players
    AimPart = "Head", -- Head, HumanoidRootPart, etc.
    Smoothness = 50, -- Aimbot smoothness (higher = smoother)
    FOV = 100, -- Field of View for targeting
    TeamCheck = true -- Ignore teammates
}

-- UI Setup
local MainTab = Window:MakeTab({
    Name = "Aimbot Settings",
    Icon = "rbxassetid://4483345998"
})

-- Toggle Aimbot
MainTab:AddToggle({
    Name = "Enable Aimbot",
    Default = false,
    Callback = function(State)
        Settings.AimbotEnabled = State
    end
})

-- Target Type Selector
MainTab:AddDropdown({
    Name = "Target Type",
    Default = Settings.TargetType,
    Options = {"Mobs", "Players"},
    Callback = function(Value)
        Settings.TargetType = Value
    end
})

-- Aim Part Selector
MainTab:AddDropdown({
    Name = "Aim Part",
    Default = Settings.AimPart,
    Options = {"Head", "HumanoidRootPart"},
    Callback = function(Value)
        Settings.AimPart = Value
    end
})

-- Smoothness Slider
MainTab:AddSlider({
    Name = "Smoothness",
    Min = 1,
    Max = 100,
    Default = Settings.Smoothness,
    Callback = function(Value)
        Settings.Smoothness = Value
    end
})

-- FOV Slider
MainTab:AddSlider({
    Name = "FOV",
    Min = 50,
    Max = 500,
    Default = Settings.FOV,
    Callback = function(Value)
        Settings.FOV = Value
    end
})

-- Team Check Toggle
MainTab:AddToggle({
    Name = "Ignore Teammates",
    Default = true,
    Callback = function(State)
        Settings.TeamCheck = State
    end
})

-- Aimbot Logic
local function GetClosestTarget()
    local closestTarget = nil
    local closestDistance = Settings.FOV
    local LocalPlayer = game.Players.LocalPlayer
    local LocalCharacter = LocalPlayer.Character
    local LocalRoot = LocalCharacter and LocalCharacter:FindFirstChild("HumanoidRootPart")

    if not LocalRoot then return nil end

    -- Target Mobs
    if Settings.TargetType == "Mobs" then
        for _, mob in pairs(workspace.Enemies:GetChildren()) do
            if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                local mobRoot = mob:FindFirstChild("HumanoidRootPart")
                if mobRoot then
                    local distance = (LocalRoot.Position - mobRoot.Position).Magnitude
                    if distance < closestDistance then
                        closestTarget = mobRoot
                        closestDistance = distance
                    end
                end
            end
        end
    end

    -- Target Players
    if Settings.TargetType == "Players" then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if Settings.TeamCheck and player.Team == LocalPlayer.Team then
                    continue
                end
                local playerRoot = player.Character.HumanoidRootPart
                local distance = (LocalRoot.Position - playerRoot.Position).Magnitude
                if distance < closestDistance then
                    closestTarget = playerRoot
                    closestDistance = distance
                end
            end
        end
    end

    return closestTarget
end

-- Aimbot Execution
game:GetService("RunService").RenderStepped:Connect(function()
    if Settings.AimbotEnabled then
        local target = GetClosestTarget()
        if target then
            local LocalPlayer = game.Players.LocalPlayer
            local LocalCharacter = LocalPlayer.Character
            local LocalRoot = LocalCharacter and LocalCharacter:FindFirstChild("HumanoidRootPart")
            local Camera = workspace.CurrentCamera

            if LocalRoot and Camera then
                local targetPosition = target.Position
                local cameraPosition = Camera.CFrame.Position
                local direction = (targetPosition - cameraPosition).Unit
                local smoothness = Settings.Smoothness / 100

                Camera.CFrame = CFrame.new(cameraPosition, cameraPosition + (direction * smoothness))
            end
        end
    end
end)

OrionLib:Init()
