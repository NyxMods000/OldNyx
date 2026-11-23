local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Client = Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SelectedRace = "Highway Race"

local RacesCheckPointsWait = {}

if require then
local RaceStorage = ReplicatedStorage.Storage.RaceStorage
local RaceConfig = require(ReplicatedStorage.Module.Configs.RaceConfig)

local function GenerateRacesCheckPointsWait()
    table.clear(RacesCheckPointsWait)

    for _, Race in ipairs(RaceStorage:GetChildren()) do
        local Checkpoints = Race:FindFirstChild("Checkpoints")
        local Config = RaceConfig[Race.Name]

        if Checkpoints and Config then
            local CheckPointCount = 0

            for _, CheckPoint in ipairs(Checkpoints:GetChildren()) do
                if CheckPoint:IsA("BasePart") then
                    CheckPointCount += 1
                end
            end

            if CheckPointCount > 0 then
                local TotalCheckPoints = CheckPointCount * Config.laps
                local WaitTime = Config.minimumTime / TotalCheckPoints

                RacesCheckPointsWait[Race.Name] = WaitTime
            end
        end
    end

    return RacesCheckPointsWait
end

GenerateRacesCheckPointsWait()

end

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/pruebasjoao/test/refs/heads/main/JmodsLibV1.0'))()

function Notify(Title,Content,Time)
  Library:Notify({
    Title = Title,
    Content = Content,
    Duration = Time
})
end

local Window = Library:CreateWindow({
  Name = "NyxMods | Vehicle Legends",
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

local ModPresets = {
    ["Full Boost"] = {
        ["Properties"] = {
            ["MaxSteerRadius"] = 30,
            ["SteerSpeed"] = 3,
            ["SteerSpeedReturn"] = 6,

            ["RelaxTorque"] = 1200,
            ["BrakeTorque"] = 15000,
            ["HandbrakeTorque"] = 40000,

            ["MaxRPM"] = 10000,
            ["IdleRPM"] = 850,

            ["NoThrottleSoundMultiplier"] = 1,
            ["ThrottleSoundMultiplier"] = 1.75,

            ["MinVolume"] = 5,
            ["MaxVolume"] = 6,
            ["IdleVolumeMultiplier"] = 0.6,

            ["UpShiftTime"] = 0.05,
            ["DownShiftTime"] = 0.05,

            ["DownShiftVolumeMultiplier"] = 1.65,
            ["UpShiftVolumeMultiplier"] = 0.95,

            ["MidShiftTorque"] = 3000,

            ["FrontFriction"] = 1.15,
            ["RearFriction"] = 1.5,

            ["BurnoutFriction"] = 0.3,
            ["BurnoutTorque"] = 30000,

            ["WorldSteerForce"] = 16000,

            ["LaunchControlEnabled"] = true,
            ["LaunchControlRPMHoldMulti"] = 0.9,
        },

        ["Gears"] = {
    { -40, 10000 },
    { 0, 10000 },
    { 45, 6000 },
    { 77, 6000 },
    { 102, 6000 },
    { 124, 6000 },
    { 180, 6000 },
    { 307, 6000 },
    { 500, 6000 },
    { 700, 6000 },
    { 1000, 6000 },
}
    }
}

local SelectedMod = nil

local Config = {
    AutoDrive = {
        Enabled = false,

        Distance = 200,
        Speed = 200,
    },
    AutoRace = {
        Enabled = false,
        Interval = 0.5,
    }
}

local function GetClientCar()
  local Vehicles = Workspace:FindFirstChild("Vehicles")
  if Vehicles then
    local Car = Vehicles:FindFirstChild(Client.Name.."'s Car")
    if Car then
      return Car
    end
  end
end

local function ModifyModule(Car,ValuesTable,GearsTable)
    if not Car then return end
  local Tune = Car:FindFirstChild("Tune")
  if Tune then
    local Module = require(Tune)
    for Propertie,Value in pairs(ValuesTable) do
      pcall(function()
        Module[Propertie] = Value
      end)
    end
    if GearsTable then
      Module["Gears"] = GearsTable
    end
  end
end

local function GetModPresetsNames()
    local Table = {}
    for Name,_ in pairs(ModPresets) do
        table.insert(Table,Name)
    end
    return Table
end

local function GetPropertiesList()
    local Table = {}
    for Propertie,Value in pairs(ModPresets["Full Boost"]["Properties"]) do
        table.insert(Table,Propertie)
    end
    return Table
end

local function AutoDrive()
    local StartPos = nil
    local FinishPos = nil
    local OldSeat = nil
    local OldSpeed = nil
    local OldDistance = nil

    task.spawn(function()
        while true do
            if not Config.AutoDrive.Enabled then
                break
            end

            local Character = Client.Character
            if Character then
                local Humanoid = Character:FindFirstChild("Humanoid")
                if Humanoid then
                    local Seat = Humanoid.SeatPart
                    if Seat then
                        if Seat:IsA("Seat") or Seat:IsA("VehicleSeat") then

                            if not OldSeat then
                                OldSeat = Seat
                            end
                            if not OldDistance then
                                OldDistance = Config.AutoDrive.Distance
                            end

                            if not StartPos or OldSeat ~= Seat then
                                StartPos = Seat.Position
                            end
                            if not FinishPos or OldSeat ~= Seat or OldDistance ~= Config.AutoDrive.Distance then
                                FinishPos = StartPos + Seat.CFrame.LookVector * Config.AutoDrive.Distance
                            end
                            if OldSeat ~= Seat then
                                OldSeat = Seat
                            end
                            if OldDistance ~= Config.AutoDrive.Distance then
                                OldDistance = Config.AutoDrive.Distance
                            end

                            local StartDirection = (FinishPos - StartPos).Unit
                            local FinishDirection = (StartPos - FinishPos).Unit

                            local MaxDistance = 20

                            if not OldSpeed then
                                OldSpeed = Config.AutoDrive.Speed
                            end

                            for i = 1,99999,1 do
                                if not Config.AutoDrive.Enabled then
                                    break
                                end
                                if Config.AutoDrive.Speed ~= OldSpeed then
                                    break
                                end
                                Seat.AssemblyLinearVelocity = StartDirection * Config.AutoDrive.Speed

                                local Direction = (FinishPos - StartPos).Unit
                                local Distance = (Seat.Position - StartPos):Dot(Direction)
                                if Distance >= Config.AutoDrive.Distance then
                                    break
                                end
                                task.wait(0.01)
                            end

                            for i = 1,99999,1 do
                                if not Config.AutoDrive.Enabled then
                                    break
                                end
                                if Config.AutoDrive.Speed ~= OldSpeed then
                                    break
                                end
                                Seat.AssemblyLinearVelocity = FinishDirection * Config.AutoDrive.Speed

                                local Direction = (StartPos - FinishPos).Unit
                                local Distance = (Seat.Position - FinishPos):Dot(Direction)
                                if Distance >= Config.AutoDrive.Distance then
                                    break
                                end
                                task.wait(0.01)
                            end

                            if Config.AutoDrive.Speed ~= OldSpeed then
                                    OldSpeed = Config.AutoDrive.Speed
                            end

                        end
                    end
                end
            end

            task.wait(0.0001)
        end
    end)
end

local function GetCurrentRace()
    local CurrentRace = nil
    local Races = Workspace:FindFirstChild("Races")
    if Races then
        local Race = Races:FindFirstChild(SelectedRace)
        if Race then
            return Race
        end
    end

    return CurrentRace
end

local function RaceStarted()
    local CurrentRace = GetCurrentRace()
    if CurrentRace then
        return CurrentRace:GetAttribute("Racing")
    end
    return false
end

local function GetCheckPoints()
    local Table = {}
    local RaceProps = Workspace:FindFirstChild("RaceProps")
    if RaceProps then
        local CheckPoints = RaceProps:FindFirstChild("Checkpoints")
        if CheckPoints and #CheckPoints:GetChildren() == 0 then
            CheckPoints:Destroy()
        end
        if not CheckPoints then
            CheckPoints = RaceProps:FindFirstChild("Checkpoints")
        end
        if CheckPoints then
            for i = 1,100,1 do
                local CheckPoint = CheckPoints:FindFirstChild(tostring(i))
                if CheckPoint then
                    table.insert(Table,CheckPoint)
                else
                    break
                end
            end
        end
    end
    return Table
end

local function GetAvailableCheckPoints()
    local Table = {}
    local CheckPoints = GetCheckPoints()
    if #CheckPoints > 0 then
        for i,CheckPoint in ipairs(CheckPoints) do
            local Display = CheckPoint:FindFirstChild("Display")
            if Display then
                local InternalCheckPoint = Display:FindFirstChild("Checkpoint")
                if InternalCheckPoint then
                    local Barrier = InternalCheckPoint:FindFirstChild("Barrier")
                    if Barrier then
                        if Barrier.Transparency == 0 then
                            table.insert(Table,CheckPoint)
                        end
                    end
                end
            end
        end
    end
    return Table
end

local function TeleportCar(Vehicle,To)
    local Relatives = {}
    local Seat = Vehicle:FindFirstChild("VehicleSeat")

    for i,Part in ipairs(Vehicle:GetDescendants()) do
        if Part:IsA("BasePart") and Seat then
            local Relative = Seat.CFrame:ToObjectSpace(Part.CFrame)
            if Relative then
                Relatives[Part] = Relative
            end
        end
    end

    local InitialCFrame = Seat.CFrame

    Seat.AssemblyLinearVelocity = Vector3.new(0,0,0)
    Seat.AssemblyAngularVelocity = Vector3.new(0,0,0)
    Seat.Velocity = Vector3.new(0,0,0)

    if RaceStarted() then
        Seat.CFrame = To

        for i,Part in ipairs(Vehicle:GetDescendants()) do
            if Part:IsA("BasePart") then
                local Relative = Relatives[Part]
                if Relative then
                    Part.Velocity = Vector3.zero
                    Part.CFrame = Seat.CFrame * Relative
                    Part.Velocity = Vector3.zero
                end
            end
        end
      end

        task.wait(0.1)

    for i,Part in ipairs(Vehicle:GetDescendants()) do
        if Part:IsA("BasePart") then
                Part.Velocity = Vector3.zero
        end
    end

end

local function AutoRace()
    if not require then
        Notify("Auto Race","Your executor doesn't support this function",3)
        return
    end
    
    print("Iniciando Auto Race")
    local OldGravity = nil
    task.spawn(function()
        while true do
            if Config.AutoRace.Enabled then
                if RaceStarted() then
                local CheckPoints = GetCheckPoints()
                local Car = GetClientCar()

                local Character = Client.Character
                if Character then
                    local Humanoid = Character:FindFirstChild("Humanoid")
                    if Humanoid then
                        if not Humanoid.SeatPart then
                            if OldGravity then
                                Workspace.Gravity = OldGravity
                            end
                        end
                    end
                end

                if #CheckPoints > 0 then
                    if not OldGravity then
                        OldGravity = Workspace.Gravity
                    end
                    for i,CheckPoint in ipairs(CheckPoints) do
                        if not RaceStarted() then
                            break
                        end
                        if not Config.AutoRace.Enabled then
                            break
                        end
                        local CurrentRace = GetCurrentRace()
                        if CurrentRace then
                            task.wait(RacesCheckPointsWait[CurrentRace.Name])
                        else
                            task.wait(1)
                        end

                        if #GetCheckPoints() <= 0 then
                            break
                        end
                        Workspace.Gravity = 0
                        if Car and CheckPoint then
                            if #GetCheckPoints() <= 0 then
                                break
                            end
                            local CheckPointCFrame = CheckPoint.CFrame * CFrame.new(CheckPoint.Size.X / 2.5,-CheckPoint.Size.Y / 2,0)
                            TeleportCar(Car,CheckPointCFrame)
                        else
                            if OldGravity then
                      Workspace.Gravity = OldGravity
                  end
                        end




                    end
                    else
                        if OldGravity then
                      Workspace.Gravity = OldGravity
                  end
                end
                else
                    if OldGravity then
                      Workspace.Gravity = OldGravity
                  end
                end
              else
                  if OldGravity then
                      Workspace.Gravity = OldGravity
                  end
                  break
        end
            task.wait(0.1)
        end
    end)
end

local ModTab = Window:CreateTab("Mod")
local PresetsSection = ModTab:CreateSection("Presets")

ModTab:CreateDropdown({
    Name = "Presets List",
    Options = GetModPresetsNames(),
    Callback = function(Option)
        SelectedMod = Option
    end
})

ModTab:CreateButton({
  Name = "Set Preset",
  Callback = function()
      if not require then
          Notify("Set Preset","Your executor doesn't support this function",3)
          return
      end
      
      if SelectedMod then
          local SelectedModTable = ModPresets[SelectedMod]
          if SelectedModTable then
              local Properties = SelectedModTable["Properties"]
              local Gears = SelectedModTable["Gears"]
              local Car = GetClientCar()
              if Properties and Gears and Car then
                  ModifyModule(Car,Properties,Gears)
                  Notify("NyxMods | Vehicle Legends","Car Modified Successfully",3)
              end
          end
      end
  end
})

local ManualModSection = ModTab:CreateSection("Manual Mod")

for i, Propertie in ipairs(GetPropertiesList()) do
    if not require then
        Notify("Set Preset","Your executor doesn't support manual mod",3)
        break
    end
    
    local PropertieValue = 0
    local Car = GetClientCar()

    if Car then
        local Tune = Car:FindFirstChild("Tune")

        if Tune then
            local Module = require(Tune)
            PropertieValue = Module[Propertie] or 0
        end
    end

    -- Booleanos
    if typeof(PropertieValue) == "boolean" then

        ModTab:CreateToggle({
            Name = Propertie,
            CurrentValue = PropertieValue,

            Callback = function(State)
                local Car = GetClientCar()

                if Car then
                    local Tune = Car:FindFirstChild("Tune")

                    if Tune then
                        local Module = require(Tune)

                        pcall(function()
                            Module[Propertie] = State
                        end)
                    end
                end
            end
        })

    -- Números
    elseif typeof(PropertieValue) == "number" then

        local Limits = {
            MaxSteerRadius = {
                Range = {1, 100},
                Increment = 1,
            },

            SteerSpeed = {
                Range = {1, 100},
                Increment = 1,
            },

            SteerSpeedReturn = {
                Range = {1, 100},
                Increment = 1,
            },

            RelaxTorque = {
                Range = {0, 10000},
                Increment = 100,
            },

            BrakeTorque = {
                Range = {0, 100000},
                Increment = 100,
            },

            HandbrakeTorque = {
                Range = {0, 100000},
                Increment = 100,
            },

            MaxRPM = {
                Range = {500, 20000},
                Increment = 100,
            },

            IdleRPM = {
                Range = {0, 5000},
                Increment = 50,
            },

            NoThrottleSoundMultiplier = {
                Range = {0, 10},
                Increment = 0.1,
            },

            ThrottleSoundMultiplier = {
                Range = {0, 10},
                Increment = 0.1,
            },

            MinVolume = {
                Range = {0, 20},
                Increment = 0.1,
            },

            MaxVolume = {
                Range = {0, 20},
                Increment = 0.1,
            },

            IdleVolumeMultiplier = {
                Range = {0, 10},
                Increment = 0.1,
            },

            UpShiftTime = {
                Range = {0, 2},
                Increment = 0.01,
            },

            DownShiftTime = {
                Range = {0, 2},
                Increment = 0.01,
            },

            DownShiftVolumeMultiplier = {
                Range = {0, 10},
                Increment = 0.1,
            },

            UpShiftVolumeMultiplier = {
                Range = {0, 10},
                Increment = 0.1,
            },

            MidShiftTorque = {
                Range = {0, 50000},
                Increment = 100,
            },

            FrontFriction = {
                Range = {0, 10},
                Increment = 0.05,
            },

            RearFriction = {
                Range = {0, 10},
                Increment = 0.05,
            },

            BurnoutFriction = {
                Range = {0, 10},
                Increment = 0.05,
            },

            BurnoutTorque = {
                Range = {0, 100000},
                Increment = 100,
            },

            WorldSteerForce = {
                Range = {0, 100000},
                Increment = 100,
            },

            LaunchControlRPMHoldMulti = {
                Range = {0, 2},
                Increment = 0.01,
            },
        }

        local Config = Limits[Propertie] or {
            Range = {0, 100000},
            Increment = 1,
        }

        ModTab:CreateSlider({
            Name = Propertie,
            Range = Config.Range,
            Increment = Config.Increment,
            Suffix = "",
            CurrentValue = PropertieValue,

            Callback = function(Value)
                local Car = GetClientCar()

                if Car then
                    local Tune = Car:FindFirstChild("Tune")

                    if Tune then
                        local Module = require(Tune)

                        pcall(function()
                            Module[Propertie] = Value
                        end)
                    end
                end
            end
        })
    end
end

local AutofarmTab = Window:CreateTab("Autofarm")
local AutoDriveSection = AutofarmTab:CreateSection("Auto Drive")

AutofarmTab:CreateToggle({
    Name = "Toggle Auto Drive",
    CurrentValue = false,
    Callback = function(State)
      Config.AutoDrive.Enabled = State
      if State then
          AutoDrive()
          Notify("Auto drive","Auto drive enabled")
      end
    end
})

AutofarmTab:CreateSlider({
    Name = "Auto Drive Distance",
    Range = {1, 1000}, --- Mínimo y máximo
    Increment = 1, --- De cuánto en cuánto cambia
    Suffix = "studs", --- Texto después del valor
    CurrentValue = 200, --- Valor inicial
    Callback = function(Value)
      Config.AutoDrive.Distance = Value
    end
})

AutofarmTab:CreateSlider({
    Name = "Auto Drive Speed",
    Range = {1, 1000}, --- Mínimo y máximo
    Increment = 1, --- De cuánto en cuánto cambia
    Suffix = "studs", --- Texto después del valor
    CurrentValue = 200, --- Valor inicial
    Callback = function(Value)
      Config.AutoDrive.Speed = Value
    end
})

local AutoRaceSection = AutofarmTab:CreateSection("Auto Race")

local Races = Workspace:FindFirstChild("Races")
local RacesNames = {}
if Races then
    for i,Race in ipairs(Races:GetChildren()) do
        table.insert(RacesNames,Race.Name)
    end
end

local PlayersList = AutofarmTab:CreateDropdown({
    Name = "Select Player",
    Options = RacesNames,
    Callback = function(Option)
        SelectedRace = Option
    end
})

AutofarmTab:CreateToggle({
    Name = "Toggle Auto Race",
    CurrentValue = false,
    Callback = function(State)
      Config.AutoRace.Enabled = State
      if State then
          AutoRace()
      end
    end
})