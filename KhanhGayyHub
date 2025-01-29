-- Load UI Library
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()
local Window = OrionLib:MakeWindow({
    Name = "Auto Raid Pro v2.1",
    HidePremium = false,
    IntroEnabled = false,
    SaveConfig = false
})

-- Configuration
local Settings = {
    AutoRaid = false,
    SelectedRaid = "Flame",
    AutoBuyChip = false,
    RaidTypes = {"Flame", "Ice", "Dark", "Phoenix", "Dough", "Order"},
    ChipNPCs = {
        Basic = "Mysterious Scientist",
        Advanced = "Sick Scientist",
        Order = "Arlthmetic NPC"
    }
}

-- UI Setup
local MainTab = Window:MakeTab({
    Name = "Core Features",
    Icon = "rbxassetid://4483345998"
})

-- Raid Selector
MainTab:AddDropdown({
    Name = "Select Raid Type",
    Default = Settings.SelectedRaid,
    Options = Settings.RaidTypes,
    Callback = function(Value)
        Settings.SelectedRaid = Value
    end
})

-- Toggle Auto-Raid
MainTab:AddToggle({
    Name = "Auto Start Raid",
    Default = false,
    Callback = function(State)
        Settings.AutoRaid = State
        if State then
            StartAutoRaid()
        end
    end
})

-- Manual Chip Purchase Button
MainTab:AddButton({
    Name = "Buy Raid Chip",
    Callback = function()
        BuyRaidChip(Settings.SelectedRaid)
    end
})

-- Advanced Settings Tab
local AdvTab = Window:MakeTab({
    Name = "Configuration",
    Icon = "rbxassetid://4483345998"
})

AdvTab:AddToggle({
    Name = "Auto-Buy Chip (Experimental)",
    Default = false,
    Callback = function(State)
        Settings.AutoBuyChip = State
    end
})

-- Core Functions
function BuyRaidChip(RaidType)
    local NPC = Settings.ChipNPCs.Basic
    local Cost = 100000
    
    if RaidType == "Phoenix" or RaidType == "Dough" then
        NPC = Settings.ChipNPCs.Advanced
        Cost = 1000000
    elseif RaidType == "Order" then
        NPC = Settings.ChipNPCs.Order
        Cost = 1000
    end
    
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Raids", true, RaidType)
    -- Teleport to NPC logic (omitted for brevity) :cite[2]:cite[3]
end

function StartAutoRaid()
    spawn(function()
        while Settings.AutoRaid do
            -- Raid Start Logic
            local Portal = workspace.Map:FindFirstChild("RaidPortal") or workspace.Map:FindFirstChild("Secret Laboratory")
            if Portal then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Portal.CFrame
                task.wait(2)
                fireclickdetector(Portal:FindFirstChild("ClickDetector"))
            end
            
            -- Combat Automation
            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy:FindFirstChild("Humanoid") then
                    -- Optimized attack pattern :cite[3]:cite[7]
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Attack", "HeavyAttack")
                    task.wait(0.15)
                end
            end
            task.wait(5)
        end
    end)
end

OrionLib:Init()
