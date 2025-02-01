-- Load Kavo UI Library
local success, KavoUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
end)

if not success then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Error",
        Text = "Failed to load Kavo UI!",
        Duration = 5
    })
    return
end

local Window = KavoUI.CreateLib("Aimbot Pro v2.0", "BloodTheme")

-- Configuration
local Settings = {
    Aimbot = false,
    TargetType = "Mobs",
    AimPart = "HumanoidRootPart",
    Smoothness = 1.5,
    FOV = 250,
    TeamCheck = true,
    DrawFOV = false
}

-- UI Setup
local MainTab = Window:NewTab("Main")
local AimbotSection = MainTab:NewSection("Aimbot Settings")

-- Aimbot Toggle
AimbotSection:NewToggle("Enable Aimbot", "Lock onto targets", function(State)
    Settings.Aimbot = State
end)

-- Target Type Selector
AimbotSection:NewDropdown("Target Type", "Choose what to target", {"Mobs", "Players"}, function(Value)
    Settings.TargetType = Value
end)

-- Aim Part Selector
AimbotSection:NewDropdown("Aim Part", "Select target body part", {"Head", "HumanoidRootPart"}, function(Value)
    Settings.AimPart = Value
end)

-- Sliders
AimbotSection:NewSlider("Smoothness", "Aim smoothness", 100, 1, function(Value)
    Settings.Smoothness = Value / 20
end)

AimbotSection:NewSlider("FOV", "Targeting radius", 500, 50, function(Value)
    Settings.FOV = Value
end)

-- Team Check
AimbotSection:NewToggle("Team Check", "Ignore teammates", function(State)
    Settings.TeamCheck = State
end)

-- FOV Circle Visualization
local FOVCircle
AimbotSection:NewToggle("Show FOV", "Display targeting area", function(State)
    Settings.DrawFOV = State
    if State then
        FOVCircle = Drawing.new("Circle")
        FOVCircle.Visible = true
        FOVCircle.Radius = Settings.FOV
        FOVCircle.Color = Color3.new(1, 1, 1)
        FOVCircle.Thickness = 2
        FOVCircle.Position = workspace.CurrentCamera.ViewportSize / 2
    else
        if FOVCircle then
            FOVCircle:Remove()
            FOVCircle = nil
        end
    end
end)

-- Aimbot Logic
local function GetClosestTarget()
    local closestTarget = nil
    local closestDistance = Settings.FOV
    local LocalPlayer = game.Players.LocalPlayer
    local LocalChar = LocalPlayer.Character
    local LocalRoot = LocalChar and LocalChar:FindFirstChild("HumanoidRootPart")
    
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
            if player ~= LocalPlayer and player.Character then
                local playerTeam = player.Team
                if Settings.TeamCheck and playerTeam == LocalPlayer.Team then continue end
                
                local playerRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if playerRoot then
                    local distance = (LocalRoot.Position - playerRoot.Position).Magnitude
                    if distance < closestDistance then
                        closestTarget = playerRoot
                        closestDistance = distance
                    end
                end
            end
        end
    end

    return closestTarget
end

-- Aimbot Execution
game:GetService("RunService").RenderStepped:Connect(function()
    if Settings.Aimbot then
        local target = GetClosestTarget()
        if target and target.Parent:FindFirstChild("Humanoid") then
            local Camera = workspace.CurrentCamera
            local LocalMouse = game.Players.LocalPlayer:GetMouse()
            
            -- Calculate smooth aiming
            local targetPosition = target.Position
            local cameraPosition = Camera.CFrame.Position
            local direction = (targetPosition - cameraPosition).Unit
            local smoothCFrame = CFrame.new(cameraPosition, cameraPosition + (direction * Settings.Smoothness))
            
            Camera.CFrame = Camera.CFrame:Lerp(smoothCFrame, 0.5)
        end
    end

    -- Update FOV Circle
    if FOVCircle then
        FOVCircle.Radius = Settings.FOV
        FOVCircle.Visible = Settings.DrawFOV
    end
end)
