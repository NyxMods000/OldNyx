--//Variables
local NyxModsUniversal = getgenv().NyxModsUniversal
local HttpService = game:GetService("HttpService")
local Window = NyxModsUniversal.Window
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Client = Players.LocalPlayer

local Script = {
    idle1 = {
        Api = nil,
        Name = nil,
    },
    walk = {
        Api = nil,
        Name = nil,
    },
    run = {
        Api = nil,
        Name = nil,
    },
    jump = {
        Api = nil,
        Name = nil,
    },
    fall = {
        Api = nil,
        Name = nil,
    },
    climb = {
        Api = nil,
        Name = nil,
    },
}

local SetAnimationsOnRespawn = true

local RobloxAnimationsApi = "https://pastebin.com/raw/14q07TEP"
local CommunityAnimationsApi = "https://pastebin.com/raw/KGK2inGd"

local function GetCharacterInstance(Player,Name)
    if not Player then
        return nil
    end
    
    local Character = Player.Character
    if not Character then
        return nil
    end
    
    local Instance = Character:FindFirstChild(Name)
    if not Instance then
        return nil
    end
    
    return Instance
end

local function GetRobloxAnimations()
    local Table = {}
    local Names = {}
    
    local Animations = HttpService:JSONDecode(game:HttpGet(RobloxAnimationsApi))
    
    if not Animations then
        return
    end
    
    for Name,Data in pairs(Animations) do
        if Name:lower():find("joao") then 
            continue 
        end
        
        table.insert(Names,Name)
        Table[Name] = Data
    end
    
    return Names,Table
end

local function GetCommunityAnimations()
    local Table = {}
    local Names = {}
    
    local Animations = HttpService:JSONDecode(game:HttpGet(CommunityAnimationsApi))
    
    if not Animations then
        return
    end
    
    for Name,Data in pairs(Animations) do
        if Name:lower():find("joao") then 
            continue 
        end
        
        table.insert(Names,Name)
        Table[Name] = Data
    end
    
    return Names,Table
end

local function SetAnimation(Table,Type,Name)
    local Animations = Table
    
    local Animation = Animations[Name]
    if not Animation then
        return
    end
    
    local AnimationType = Animation[Type]
    
    if not AnimationType then
        return
    end
    
    local Animate = GetCharacterInstance(Client,"Animate")
    if not Animate then
        return
    end
    
    local Humanoid = GetCharacterInstance(Client,"Humanoid")
    if not Humanoid then
        return
    end
    
    if Type == "idle1" or Type == "idle2" then
        local Folder = Animate:FindFirstChild("idle")
        if not Folder then
            return
        end
        Folder:ClearAllChildren()
        
        local FirstId = Animation["idle1"]
        local SecondId = Animation["idle2"]
        
        local Animation1 = Instance.new("Animation")
        Animation1.Name = "Animation1"
        Animation1.AnimationId = FirstId
        Animation1.Parent = Folder
        
        local Weight1 = Instance.new("NumberValue")
        Weight1.Value = 9
        Weight1.Name = "Weight"
        Weight1.Parent = Animation1
        
        local Animation2 = Instance.new("Animation")
        Animation2.Name = "Animation2"
        Animation2.AnimationId = SecondId
        Animation2.Parent = Folder
        
        local Weight2 = Instance.new("NumberValue")
        Weight2.Value = 1
        Weight2.Name = "Weight"
        Weight2.Parent = Animation2
        
        for i,Track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
            if Track and Track.Animation and Track.Animation.AnimationId ~= AnimationType then
                Track:Stop()
            end
        end
        
    else
        local Folder = Animate:FindFirstChild(Type)
        if not Folder then
            return
        end
        
        Folder:ClearAllChildren()
        
        local Animation = Instance.new("Animation")
        Animation.AnimationId = AnimationType
        Animation.Parent = Folder
        
        for i,Track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
            if Track and Track.Animation and Track.Animation.AnimationId ~= AnimationType then
                Track:Stop()
            end
        end
        
    end
    local RootPart = GetCharacterInstance(Client,"HumanoidRootPart")
    if not RootPart then
        return
    end
    
    Humanoid:MoveTo(RootPart.CFrame.Position + Vector3.new(0,0,-0.5))
end

local Tab = Window:CreateTab("Animation packs 2")
local RobloxSection = Tab:CreateSection("Roblox Animations")

local RNames,RTable = GetRobloxAnimations()

Tab:CreateDropdown({
    Name = "Idle",
    Options = RNames,
    Callback = function(Option)
        SetAnimation(RTable, "idle1", Option)

        Script.idle1 = {
            Api = RTable,
            Name = Option,
        }
    end
})

Tab:CreateDropdown({
    Name = "Walk",
    Options = RNames,
    Callback = function(Option)
        SetAnimation(RTable, "walk", Option)

        Script.walk = {
            Api = RTable,
            Name = Option,
        }
    end
})

Tab:CreateDropdown({
    Name = "Run",
    Options = RNames,
    Callback = function(Option)
        SetAnimation(RTable, "run", Option)

        Script.run = {
            Api = RTable,
            Name = Option,
        }
    end
})

Tab:CreateDropdown({
    Name = "Jump",
    Options = RNames,
    Callback = function(Option)
        SetAnimation(RTable, "jump", Option)

        Script.jump = {
            Api = RTable,
            Name = Option,
        }
    end
})

Tab:CreateDropdown({
    Name = "Fall",
    Options = RNames,
    Callback = function(Option)
        SetAnimation(RTable, "fall", Option)

        Script.fall = {
            Api = RTable,
            Name = Option,
        }
    end
})

Tab:CreateDropdown({
    Name = "Climb",
    Options = RNames,
    Callback = function(Option)
        SetAnimation(RTable, "climb", Option)

        Script.climb = {
            Api = RTable,
            Name = Option,
        }
    end
})


local CommunitySection = Tab:CreateSection("Community")

local CNames, CTable = GetCommunityAnimations()

Tab:CreateDropdown({
    Name = "Idle",
    Options = CNames,
    Callback = function(Option)
        SetAnimation(CTable, "idle1", Option)

        Script.idle1 = {
            Api = CTable,
            Name = Option,
        }
    end
})

Tab:CreateDropdown({
    Name = "Walk",
    Options = CNames,
    Callback = function(Option)
        SetAnimation(CTable, "walk", Option)

        Script.walk = {
            Api = CTable,
            Name = Option,
        }
    end
})

Tab:CreateDropdown({
    Name = "Run",
    Options = CNames,
    Callback = function(Option)
        SetAnimation(CTable, "run", Option)

        Script.run = {
            Api = CTable,
            Name = Option,
        }
    end
})

Tab:CreateDropdown({
    Name = "Jump",
    Options = CNames,
    Callback = function(Option)
        SetAnimation(CTable, "jump", Option)

        Script.jump = {
            Api = CTable,
            Name = Option,
        }
    end
})

Tab:CreateDropdown({
    Name = "Fall",
    Options = CNames,
    Callback = function(Option)
        SetAnimation(CTable, "fall", Option)

        Script.fall = {
            Api = CTable,
            Name = Option,
        }
    end
})

Tab:CreateDropdown({
    Name = "Climb",
    Options = CNames,
    Callback = function(Option)
        SetAnimation(CTable, "climb", Option)

        Script.climb = {
            Api = CTable,
            Name = Option,
        }
    end
})

local ConfigSection = Tab:CreateSection("Config")

Tab:CreateToggle({
    Name = "Set Animations On Respawn",
    CurrentValue = true,
    Callback = function(State)
        SetAnimationsOnRespawn = State
    end
})

Client.CharacterAdded:Connect(function(Character)
    if not SetAnimationsOnRespawn then
        return
    end
    
    local Humanoid = Character:FindFirstChild("Humanoid") or Character:WaitForChild("Humanoid")
    local Animate = Character:FindFirstChild("Animate") or Character:WaitForChild("Animate")
    
    task.wait(1)
    
    if not Humanoid or not Animate then
        return
    end
    
    for Type,Data in pairs(Script) do
        if Data.Name ~= nil and Data.Api ~= nil then
            SetAnimation(Data.Api,Type,Data.Name)
        end
    end
    
end)