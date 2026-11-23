-- +1 Speed Monkey Scape

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Client = Players.LocalPlayer

local Config = {
  AutoTeleport = false,
  AutoSpeed = false,
  AutoRebirth = false,
  AutoShards = false,
  AutoUpgrades = false,

  WalkSpeed = false,
  WalkSpeedValue = 16,
  WalkSpeedOriginal = nil,

  JumpPower = false,
  JumpPowerValue = 52,
  JumpPowerOriginal = nil,
}





local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/pruebasjoao/test/refs/heads/main/JmodsLibV1.0'))()

local Window = Library:CreateWindow({
  Name = "NyxMods | +1SMS",
  Icon = 86507528059862,
  LoadingTitle = "Cargando... espera...",
  LoadingSubtitle = "ya casi está",
  Theme = "neon_indigo",
  OpenButtomImage = 86507528059862,
  Intro = true,
  IntroIcon = 86507528059862,
  AnimationIntro = 3,
  DragImage = 86507528059862
})


local WorldStageCFrames = {
    ["World1"] = {
        ["0"] = {
            CFrame.new(-1571, 28, -255),
        },
        ["1"] = {
            CFrame.new(-9459, 392, -256),
        },
    },

    ["World2"] = {
        ["8"] = {
            CFrame.new(-3606, 156, -9379)
        },
    },

    ["World3"] = {
        ["8"] = {
            CFrame.new(-8079, 284, 2740),
        },
    },

    ["World4"] = {
        ["8"] = {
            CFrame.new(-7761, 22, 5740),
        },
    },

    ["World5"] = {
        ["8"] = {
            CFrame.new(-7598, 287, 8360),
        },
    },
}

local function GetHumanoidPropertie(Player,Propertie)
    local Character = Player.Character
    if Character then
        local Humanoid = Character:FindFirstChild("Humanoid")
        if Humanoid then
            return Humanoid[Propertie]
        end
    end
end

local function SetHumanoidPropertie(Player,Propertie,Value)
    local Character = Player.Character
    if Character then
        local Humanoid = Character:FindFirstChild("Humanoid")
        if Humanoid then
            Humanoid[Propertie] = Value
        end
    end
end

local function GetPlayerInstancePropertie(Player,InstanceName,Propertie)
    local Character = Player.Character
    if Character then
        local Instance = Character:FindFirstChild(InstanceName)
        if Instance then
            return Instance[Propertie]
        end
    end
end

local function SetPlayerInstancePropertie(Player,InstanceName,Propertie,Value)
    local Character = Player.Character
    if Character then
        local Instance = Character:FindFirstChild(InstanceName)
        if Instance then
            Instance[Propertie] = Value
        end
    end
end

local function GetAllStages(WorldName)
    local StagesList = {}
    local Map = Workspace:FindFirstChild("Map")
    if Map then
        local World = Map:FindFirstChild(WorldName)
        if World then
            local Stages = World:FindFirstChild("Stages")
            if Stages then
                for _, Stage in ipairs(Stages:GetChildren()) do
                    local Number = tonumber(string.match(Stage.Name, "%d+"))

                    if Number then
                        StagesList[Number] = Stage
                    end
                end
            end
        end
    end

    return StagesList
end


local function GetWinPart(Stage)
    if not Stage then
        return nil
    end

    local NormalWin = Stage:FindFirstChild("NormalWin")

    if NormalWin then
        local Button = NormalWin:FindFirstChild("Button")

        if Button then
            return Button
        end
    end

    return nil
end


local function Teleport(Position)
    if not Position then
        return
    end

    local Character = Client.Character

    if Character then
        local HumanoidRootPart =
            Character:FindFirstChild("HumanoidRootPart")

        if HumanoidRootPart then
            HumanoidRootPart.CFrame = CFrame.new(Position)
        end
    end
end

local function GetMaxRebirth(WorldTable)
    local Table = nil
    local MaxNumber = 0
    for i,v in pairs(WorldTable) do
        if tonumber(i) > MaxNumber then
            MaxNumber = tonumber(i)
            Table = v
        end
    end
    return Table
end


local function AutoTeleport(WorldName)
    task.spawn(function()
        while true do
            if not Config.AutoTeleport then
                break
            end
            local Character = Client.Character
            if Character then
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                if HumanoidRootPart then
                    local WorldTable = WorldStageCFrames[WorldName]
                    if WorldTable then
                        local LeaderStats = Client:FindFirstChild("leaderstats")
                        if LeaderStats then
                            local Rebirths = nil
                            for i,Instance in ipairs(LeaderStats:GetChildren()) do
                                if Instance.Name:find("Rebirths") then
                                    Rebirths = Instance
                                    break
                                end
                            end
                            if Rebirths then
                                local RebirthStage = WorldTable[tostring(Rebirths.Value)] or GetMaxRebirth(WorldTable)
                                if RebirthStage then
                                    for i,v in ipairs(RebirthStage) do
                                        HumanoidRootPart.CFrame = v
                                        task.wait(0.5)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.01)
        end
    end)
end

local function AutoSpeed()
    task.spawn(function()
        while true do
            if not Config.AutoSpeed then
                break
            end
            local Character = Client.Character
            if Character then
                local Humanoid = Character:FindFirstChild("Humanoid")
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                if Humanoid and HumanoidRootPart then
                    local OldCFrame = HumanoidRootPart.CFrame

                    Humanoid:Move(Vector3.new(0,0,1),false)
                    task.wait(0.00000001)
                    HumanoidRootPart.CFrame = OldCFrame
                end
            end
            task.wait(0.000000001)
        end
    end)
end

local function FireRebirth()
    local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if Remotes then
        local Rebirth = Remotes:FindFirstChild("Rebirth")
        if Rebirth then
            Rebirth:FireServer()
        end
    end
end

local function AutoRebirth()
    task.spawn(function()
        while true do
            if not Config.AutoRebirth then
                break
            end

    local PlayerGui = Client:FindFirstChild("PlayerGui")
    local LeaderStats = Client:FindFirstChild("leaderstats")
    if PlayerGui and LeaderStats then

        local Main = PlayerGui:FindFirstChild("Main")
        if Main then

            local UIs = Main:FindFirstChild("UIs")
            if UIs then

                local Rebirth = UIs:FindFirstChild("Rebirth")
                if Rebirth then

                    local Level = Rebirth:FindFirstChild("Level")
                    if Level then

                        local Level = Level:FindFirstChild("Level")
                        local CurrentLevel = nil
                        for i,Instance in ipairs(LeaderStats:GetChildren()) do
                            if Instance.Name:find("Level") then
                                CurrentLevel = tonumber(Instance.Value)
                                break
                            end
                        end

                        if Level then

                            local RequiredLevel = tonumber(string.match(Level.Text,"%d+"))
                            if CurrentLevel and CurrentLevel >= RequiredLevel then
                                FireRebirth()
                            end
                        end
                    end
                end
            end
        end
    end
    task.wait(0.000001)
    end
    end)
end

local function AutoShards()
    task.spawn(function()
        while true do
            if not Config.AutoShards then
                break
            end
            local Shards = Workspace:FindFirstChild("SunkenShards")
            if Shards then
                for i,Shard in ipairs(Shards:GetChildren()) do
                    if Shard:IsA("Model") then
                        local BasePart = Shard:FindFirstChildWhichIsA("BasePart")
                        if BasePart then
                            local Position = BasePart.Position
                            Teleport(Position)
                        end
                    elseif Shard:IsA("BasePart") then
                        local Position = Shard.Position
                        Teleport(Position)
                    end
                end
            end
            task.wait(0.00001)
        end
    end)
end

local function ParseNumber(str)
    local number, suffix = str:match("([%d%.]+)(%a*)")
    number = tonumber(number)

    if suffix == "K" then
        return number * 1e3
    elseif suffix == "M" then
        return number * 1e6
    elseif suffix == "B" then
        return number * 1e9
    elseif suffix == "T" then
        return number * 1e12
    elseif suffix == "Qa" then
        return number * 1e15
    elseif suffix == "Qui" then
        return number * 1e18
    elseif suffix == "Sx" then
        return number * 1e21
    elseif suffix == "Sp" then
        return number * 1e24
    elseif suffix == "Oc" then
        return number * 1e27
    end

    return number
end

local function BuyUpgrade(Number)

    local args = {
    [1] = Number
    }
    local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if Remotes then
        local SelectUpgrade = Remotes:FindFirstChild("SelectUpgrade")
        if SelectUpgrade then
            SelectUpgrade:FireServer(unpack(args))
        end
    end
end

local function GetBestUpgrade()
    local Data = Client:FindFirstChild("Data")
    if Data then
        local World = Data:FindFirstChild("World")
        if World then
            local WorldName = "World"..World.Value
            local Map = Workspace:FindFirstChild("Map")
            if Map then
                local World = Map:FindFirstChild(WorldName)
                if World then
                    local Upgrades = World:FindFirstChild("Upgrades")
                    if Upgrades then
                        local LeaderStats = Client:FindFirstChild("leaderstats")
                        if LeaderStats then
                            local Wins = nil
                            for i,Instance in ipairs(LeaderStats:GetChildren()) do
                                if Instance.Name:find("Wins") then
                                    Wins = tonumber(Instance.Value)
                                    break
                                end
                            end
                            local BestUpgrade = nil --???
                            local MaxWins = 0 --??
                            for i,Button in ipairs(Upgrades:GetChildren()) do
                                if Button.Name:find("Button") then
                                    local PlusStep = Button:FindFirstChild("PlusStep")
                                    if PlusStep then
                                        local BillboardGui = PlusStep:FindFirstChild("BillboardGui")
                                        if BillboardGui then
                                            local RequiredWins = BillboardGui:FindFirstChild("Required")
                                            if RequiredWins then
                                                local RequiredWinsNumber = ParseNumber(RequiredWins.Text)

                                                if RequiredWinsNumber <= Wins and RequiredWinsNumber > MaxWins then
                                                    MaxWins = RequiredWinsNumber
                                                    BestUpgrade = Button:GetAttribute("Upgrade")


                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            return BestUpgrade
                        end
                    end
                end
            end
        end
    end
    return 1
end

local function AutoUpgrades()
    task.spawn(function()
        while true do
            if not Config.AutoUpgrades then
                break
            end
            pcall(function()
                local BestUpgrade = GetBestUpgrade()
                BuyUpgrade(BestUpgrade)
            end)
            task.wait(0.001)
        end
    end)
end


local Tab = Window:CreateTab("Main")
local AutoTeleportToggleSection = Tab:CreateSection("Auto Wins")

Tab:CreateToggle({
    Name = "Toggle Auto Wins",
    CurrentValue = false,
    Callback = function(State)
        Config.AutoTeleport = State
        if State then
            local Data = Client:FindFirstChild("Data")
            if Data then
                local World = Data:FindFirstChild("World")
                if World then
                    AutoTeleport("World"..tostring(World.Value))
                end
            end
        end
    end
})

local AutoSpeedToggleSection = Tab:CreateSection("Toggle Auto Speed")

Tab:CreateToggle({
    Name = "Toggle Auto Speed",
    CurrentValue = false,
    Callback = function(State)
        Config.AutoSpeed = State
        if State then
          AutoSpeed()
        end
    end
})

local AutoRebirthToggleSection = Tab:CreateSection("Toggle Auto Rebirth")

Tab:CreateToggle({
    Name = "Toggle Auto Rebirth",
    CurrentValue = false,
    Callback = function(State)
        Config.AutoRebirth = State
        if State then
          AutoRebirth()
        end
    end
})

local AutoShardsToggleSection = Tab:CreateSection("Toggle Auto Shards")

Tab:CreateToggle({
    Name = "Toggle Auto Shards",
    CurrentValue = false,
    Callback = function(State)
        Config.AutoShards = State
        if State then
          AutoShards()
        end
    end
})

local AutoUpgradesToggleSection = Tab:CreateSection("Toggle Auto Upgrade")

Tab:CreateToggle({
    Name = "Toggle Auto Upgrades",
    CurrentValue = false,
    Callback = function(State)
        Config.AutoUpgrades = State
        if State then
          AutoUpgrades()
        end
    end
})

local Tab2 = Window:CreateTab("Others")
local Movement = Tab2:CreateSection("Movement")

Tab2:CreateToggle({
    Name = "Toggle WalkSpeed",
    CurrentValue = false,
    Callback = function(State)
        Config.WalkSpeed = State

        if not Config.WalkSpeedOriginal then
            local WalkSpeed = GetHumanoidPropertie(Client,"WalkSpeed")
            if WalkSpeed then
                Config.WalkSpeedOriginal = WalkSpeed
            end
        end
        if not State then
            SetHumanoidPropertie(Client,"WalkSpeed",Config.WalkSpeedOriginal)
        end

    end
})

Tab2:CreateSlider({
    Name = "WalkSpeed",
    Range = {1, 20}, --- Mínimo y máximo
    Increment = 1, --- De cuánto en cuánto cambia
    Suffix = "studs/s", --- Texto después del valor
    CurrentValue = 1, --- Valor inicial
    Callback = function(Value)
        Config.WalkSpeedValue = Value
    end
})

Tab2:CreateToggle({
    Name = "Toggle JumpPower",
    CurrentValue = false,
    Callback = function(State)
        Config.JumpPower = State

        if not Config.JumpPowerOriginal then
            local JumpPower = GetHumanoidPropertie(Client,"JumpPower")
            if JumpPower then
                Config.JumpPowerOriginal = JumpPower
            end
        end
        if not State then
            SetHumanoidPropertie(Client,"JumpPower",Config.JumpPowerOriginal)
            SetHumanoidPropertie(Client,"UseJumpPower",false)
        end

    end
})

Tab2:CreateSlider({
    Name = "JumpPower",
    Range = {0, 1000}, --- Mínimo y máximo
    Increment = 1, --- De cuánto en cuánto cambia
    Suffix = "studs/s", --- Texto después del valor
    CurrentValue = 52, --- Valor inicial
    Callback = function(Value)
        Config.JumpPowerValue = Value
    end
})

RunService.Heartbeat:Connect(function()
    if Config.WalkSpeed then
        local MoveDirection = GetHumanoidPropertie(Client,"MoveDirection")
        local Position = GetPlayerInstancePropertie(Client,"HumanoidRootPart","Position")
        local Rotation = GetPlayerInstancePropertie(Client,"HumanoidRootPart","CFrame").Rotation

        if MoveDirection.Magnitude > 0 then
        local Direction = (Position + MoveDirection.Unit * Config.WalkSpeedValue)

        SetPlayerInstancePropertie(Client,"HumanoidRootPart","CFrame",CFrame.new(Direction) * Rotation)
        end
    end
    if Config.JumpPower then
        SetHumanoidPropertie(Client,"JumpPower",Config.JumpPowerValue)
        SetHumanoidPropertie(Client,"UseJumpPower",true)
    end
end)