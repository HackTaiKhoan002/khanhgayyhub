-- Blox Fruits Ultimate Auto-Farm Script (Optimized)
getgenv().Config = {
    TargetFruit = "Dragon",       -- Change to desired fruit
    MaxServerPlayers = 3,         -- Ideal player count
    RaidType = "Flame",           -- Flame/Ice/Dark/etc.
    FragmentGoal = 10000,         -- Stop when reached
    TeamLock = "Pirates",         -- Pirates/Marines
    AntiLag = true,               -- Destroy unnecessary parts
    Webhook = ""                  -- Discord webhook for notifications
}

-- Performance Modules
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TeleportService")
local LP = Players.LocalPlayer

-- Anti-Lag System
if Config.AntiLag then
    workspace.DescendantAdded:Connect(function(d)
        if d:IsA("Part") and d.Name == "Handle" then
            d:Destroy()
        end
    end)
end

-- Smart Server Hopper
local function GetBestServer()
    local servers = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
    servers = game:GetService("HttpService"):JSONDecode(servers)
    
    return task.spawn(function()
        table.sort(servers.data, function(a,b) 
            return a.playing < b.playing 
        end)
        
        for _,v in pairs(servers.data) do
            if v.playing <= Config.MaxServerPlayers and v.id ~= game.JobId then
                return v.id
            end
        end
    end)
end

-- Precision Fruit Collector
local function GrabFruit()
    local fruit = workspace:FindFirstChild(Config.TargetFruit)
    if not fruit then return false end
    
    LP.Character:PivotTo(fruit.Handle.CFrame)
    firetouchinterest(LP.Character.HumanoidRootPart, fruit.Handle, 0)
    task.wait()
    firetouchinterest(LP.Character.HumanoidRootPart, fruit.Handle, 1)
    return true
end

-- Lightning-Fast Raid System
local function ExecuteRaid()
    RS.Remotes.CommF_:InvokeServer("Raids", true, Config.RaidType)
    if not workspace.Map:FindFirstChild("RaidPortal") then return end
    
    local portal = workspace.Map.RaidPortal
    LP.Character:PivotTo(portal.CFrame)
    
    -- Optimized Mob Clearance
    for _,v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChild("Humanoid") then
            LP.Character:PivotTo(v.HumanoidRootPart.CFrame)
            RS.Remotes.CommF_:InvokeServer("Attack", "HeavyAttack")
            task.wait(0.15)
        end
    end
end

-- Main Execution Thread
local function Main()
    RS.Remotes.CommF_:InvokeServer("SetTeam", Config.TeamLock)
    
    while LP.Data.Fragments.Value < Config.FragmentGoal do
        local serverId = GetBestServer()
        TS:TeleportToPlaceInstance(game.PlaceId, serverId)
        repeat task.wait() until game:IsLoaded()
        
        if not GrabFruit() then
            task.wait(3)
            continue
        end
        
        ExecuteRaid()
        task.wait(5) -- Cooldown between cycles
    end
    
    if Config.Webhook ~= "" then
        -- Discord notification code here
    end
end

Main()
