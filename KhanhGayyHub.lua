-- Load Kavo UI Library
local KavoUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = KavoUI.CreateLib("Aimbot Controller", "Serpent")

-- Create toggle circle
local Circle = Instance.new("ImageLabel")
Circle.Name = "UICircle"
Circle.Image = "rbxassetid://3570695787" -- Smooth circle image
Circle.ImageColor3 = Color3.new(0, 0.8, 1)
Circle.BackgroundTransparency = 1
Circle.Size = UDim2.new(0, 40, 0, 40)
Circle.Position = UDim2.new(1, -50, 1, -50) -- Bottom-right corner
Circle.ZIndex = 999
Circle.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Toggle visibility function
local function ToggleUI()
    Window:ToggleUI()
    Circle.Visible = not Circle.Visible
end

-- Click detection
local UIS = game:GetService("UserInputService")
Circle.MouseButton1Click:Connect(ToggleUI)

-- Hover effects
Circle.MouseEnter:Connect(function()
    game:GetService("TweenService"):Create(
        Circle,
        TweenInfo.new(0.2),
        {ImageTransparency = 0.2}
    ):Play()
end)

Circle.MouseLeave:Connect(function()
    game:GetService("TweenService"):Create(
        Circle,
        TweenInfo.new(0.2),
        {ImageTransparency = 0}
    ):Play()
end)

-- UI Configuration (same as previous script)
local Settings = {
    Aimbot = false,
    TargetType = "Mobs",
    AimPart = "HumanoidRootPart"
}

local MainTab = Window:NewTab("Controls")
MainTab:NewSection("Aimbot Configuration")

MainTab:NewToggle("Enable Aimbot", "Toggles targeting system", function(State)
    Settings.Aimbot = State
end)

MainTab:NewDropdown("Target Type", "Select what to aim at", {"Mobs", "Players"}, function(Value)
    Settings.TargetType = Value
end)

MainTab:NewDropdown("Aim Part", "Select target body part", {"Head", "HumanoidRootPart"}, function(Value)
    Settings.AimPart = Value
end)

-- Keep the circle visible when UI is closed
Window:OnClose(function()
    Circle.Visible = true
end)

-- Initial visibility setup
Circle.Visible = true
Window:HideUI() -- Start with UI hidden

-- Rest of your aimbot logic here...
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
