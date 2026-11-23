--//Variables
local NyxModsUniversal = getgenv().NyxModsUniversal
local Window = NyxModsUniversal.Window
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Client = Players.LocalPlayer

--//Tables
local Config = {
  WalkSpeed = {
    Enabled = false,
    Value = 16,
    Default = 16,
    Force = false
  },
  JumpPower = {
    Enabled = false,
    Value = 50,
    Default = 50,
    Force = false
  },
  Slide = {
    Enabled = false,
    Value = 1,
    Method = "CFrame" --// CFrame or velocity
  },
  Noclip = {
    Enabled = false,
    Default = {}
  },
  TeleportTool = {
    Enabled = false,
    Tool = nil
  },
  ControlClickTp = {
    Enabled = false,
    Pressed = false
  },
  InfiniteJump = {
    Enabled = false
  },
  AirWalk = {
    Enabled = false,
    Margin = 0.5,
    Platform = nil
  },
  HipHeight = {
    Enabled = false,
    Value = 0,
    Default = nil
  },
  WayPointTeleport = {
    Saved = nil
  },
  Spin = {
    Enabled = false,
    Value = 0
  },
  Fly = {
    Enabled = false,
    Speed = 10,
    SpeedMultiplier = 1,
  },
  VehicleFly = {
                  Enabled = false,
                  Speed = 10,
                  SpeedMultiplier = 1,
    OldGravity = nil,
  },
  AntifallDamage = false,
  FreeCam = {
    Enabled = false,

    Speed = false,
    SpeedMultiplier = 1,

    Part = nil,

    OldMaxZoom = nil,
    OldMinZoom = nil,
  },
   FakeLag = {
     Enabled = false,
   }
}

--//Functions
local function GetHumanoid()
  local Character = Client and Client.Character
  if Character then
    local Humanoid = Character:FindFirstChild("Humanoid")
    if Humanoid then
      return Humanoid
    end
    return nil
  end
  return nil
end

local function GetHumanoidRootPart()
  local Character = Client and Client.Character
  if Character then
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart then
      return HumanoidRootPart
    end
    return nil
  end
  return nil
end

local function GetMoveDirection()
  local Humanoid = GetHumanoid()
  if Humanoid then
    return Humanoid and Humanoid.MoveDirection
  end
end

local function UpdateHumanoidProperty(Property,Data)
  local Humanoid = GetHumanoid()
  if Humanoid then
    if not Data.Default then
      Data.Default = Humanoid[Property]
    end
    Humanoid[Property] = Data.Enabled and Data.Value or Data.Default
  end
  return nil
end

local function EnableAllHumanoidStates(Humanoid)
  Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,true)
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,true)
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,true)
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,true)
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,true)
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,true)
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
end

local function DisableAllHumanoidStates(Humanoid)
  Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,false)
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping,false)
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall,false)
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Landed,false)
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming,false)
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding,false)
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics,false)
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false)
end

local function Teleport(Position)
  local HumanoidRootPart = GetHumanoidRootPart()
  if HumanoidRootPart then
    if typeof(Position) == "CFrame" then
      HumanoidRootPart.CFrame = Position
    elseif typeof(Position) == "Vector3" then
      HumanoidRootPart.CFrame = CFrame.new(Position)
    end
  end
end

local function ApplyVelocity(Velocity)
  local HumanoidRootPart = GetHumanoidRootPart()
  if HumanoidRootPart then
    HumanoidRootPart.AssemblyLinearVelocity = Velocity
  end
end

local function UpdateNoclip(Data)
  local Character = Client.Character
  if Character then
    local Default = Config.Noclip.Default
    for _,v in ipairs(Character:GetDescendants()) do
      if v:IsA("BasePart") then
        if not Default[v.Name] then
          Default[v.Name] = v.CanCollide
        end
        if Data and Data.Enabled then
          v.CanCollide = false
        elseif Data and not Data.Enabled then
          if Default and Default[v.Name] ~= nil then
            v.CanCollide = Default[v.Name]
          else
            v.CanCollide = true
          end
        end
      end
    end
  end
end

local function CreateTeleportTool()
  local Tool = Instance.new("Tool")
  Tool.Name = "Teleport Tool"
  Tool.RequiresHandle = false

  Tool.Activated:Connect(function()
    if Config.TeleportTool.Enabled then
      local Mouse = Client:GetMouse()
      if Mouse and Mouse.Hit then
        Teleport(Mouse.Hit)
      end
    end
  end)

  return Tool
end

local function GetTeleportTool()
  if Config.TeleportTool.Tool then
    Config.TeleportTool.Tool:Destroy()
  end

  local Tool = CreateTeleportTool()
  if Tool then
    Config.TeleportTool.Tool = Tool
    Tool.Parent = Client and Client.Backpack or Client and Client:WaitForChild("Backpack")
  end
end

local function CreatePlatform()
  if Config.AirWalk.Platform then
    return Config.AirWalk.Platform
  end

  local Platform = Instance.new("Part")
  Platform.Size = Vector3.new(20,1,20)
  Platform.Transparency = 1
  Platform.Anchored = true
  Platform.CanCollide = true
  Platform.Parent = Workspace

  Config.AirWalk.Platform = Platform

  return Platform
end

local function UpdatePlatform()
  local Platform = CreatePlatform()
  local HumanoidRootPart = GetHumanoidRootPart()
  local Humanoid = GetHumanoid()
  local Margin = Config.AirWalk.Margin
  if Platform  and HumanoidRootPart and Humanoid then
    local Relative = Platform.CFrame:PointToObjectSpace(HumanoidRootPart.Position)
    local Half = Platform.Size / 2

    local NearEdgeX = math.abs(Relative.X) >= Half.X - Margin or math.abs(Relative.Y) >= 5
    local NearEdgeZ = math.abs(Relative.Z) >= Half.Z - Margin or math.abs(Relative.Y) >= 5

    if NearEdgeX or NearEdgeZ then
      Platform.Position = HumanoidRootPart.Position + Vector3.new(0,-3.5,0)
    end

  end
end

local function WayPointTeleport(Type)
  local HumanoidRootPart = GetHumanoidRootPart()
  if HumanoidRootPart then
    if Type == "Save" then
      Config.WayPointTeleport.Saved = HumanoidRootPart.CFrame
    elseif Type == "Teleport" then
      if Config.WayPointTeleport.Saved then
        Teleport(Config.WayPointTeleport.Saved)
      end
    elseif Type == "Delete" then
      Config.WayPointTeleport.Saved = nil
    end
  end
end

local function Fly()
  task.spawn(function()
    while true do
      local HumanoidRootPart = GetHumanoidRootPart()
      local Humanoid = GetHumanoid()

      local Camera = Workspace.CurrentCamera

      if HumanoidRootPart and Humanoid and Camera then

        if not Config.Fly.Enabled then
          Config.AntifallDamage = false
          Humanoid.PlatformStand = false
          if HumanoidRootPart:FindFirstChild("BodyVelocity") then
            HumanoidRootPart:FindFirstChild("BodyVelocity"):Destroy()
          end
        return
      end

        local MoveDirection = Camera.CFrame:VectorToObjectSpace(Humanoid.MoveDirection)

        if not HumanoidRootPart:FindFirstChild("BodyVelocity") then
          local BodyVelocity = Instance.new("BodyVelocity")
          BodyVelocity.Velocity = Vector3.zero
          BodyVelocity.MaxForce = Vector3.new(9e7,9e7,9e7)
          BodyVelocity.maxForce = Vector3.new(9e7,9e7,9e7)
          BodyVelocity.Parent = HumanoidRootPart
        end

        local BodyVelocity = HumanoidRootPart:FindFirstChild("BodyVelocity")

        if MoveDirection.Magnitude == 0 then
          Humanoid.PlatformStand = true
          HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position,HumanoidRootPart.Position + Camera.CFrame.LookVector)
        else
          local LookVector = Camera.CFrame.LookVector
          local RightVector = Camera.CFrame.RightVector

          local Direction = LookVector * -MoveDirection.Z + RightVector * MoveDirection.X

          if Direction.Magnitude > 0 then
            Direction = Direction.Unit
          end

          Config.AntifallDamage = true
          Humanoid.PlatformStand = true

          HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + Direction * Config.Fly.Speed * Config.Fly.SpeedMultiplier
          HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position,HumanoidRootPart.Position + Camera.CFrame.LookVector)
        end
      end
      task.wait(0.01)
    end
  end)
end

local function VehicleFly()
  task.spawn(function() 
    local FirstTime = true
    while true do
    local Character = Client.Character
    local Camera = Workspace.CurrentCamera
    if Character then
      local Humanoid = Character:FindFirstChild("Humanoid")
      local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
      if Humanoid and HumanoidRootPart then
        local Seat = Humanoid.SeatPart
        if not Config.VehicleFly.Enabled then
          if HumanoidRootPart then
            HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position,Vector3.new(9e7,HumanoidRootPart.Position.Y,9e7))
            HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
            HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0,0,0)
            Workspace.Gravity = Config.VehicleFly.OldGravity or 192.2
            task.wait(0.1)
            Config.VehicleFly.OldGravity = nil
          end 
          break
        end

        if not Config.VehicleFly.OldGravity then
              Config.VehicleFly.OldGravity = Workspace.Gravity
        end


        if Seat and Humanoid.Sit then
          local MoveDirection = Camera.CFrame:VectorToObjectSpace(Humanoid.MoveDirection)
          local LookVector = Camera.CFrame.LookVector
          local RightVector = Camera.CFrame.RightVector

          local Direction = LookVector * -MoveDirection.Z + RightVector * MoveDirection.X

          if Direction.Magnitude > 0 then
            Direction = Direction.Unit
          end

          if FirstTime then
            HumanoidRootPart.Velocity = Vector3.new(0,100,0)
            task.wait(0.5)
            FirstTime = false
          end

          if MoveDirection.Magnitude > 0 then

            HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position,Vector3.new(9e7,HumanoidRootPart.Position.Y,9e7))
            HumanoidRootPart.AssemblyLinearVelocity = Direction * Config.VehicleFly.Speed * Config.VehicleFly.SpeedMultiplier
            Workspace.Gravity = 0
          else

            HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position,Vector3.new(9e7,HumanoidRootPart.Position.Y,9e7))
            HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
            HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0,0,0)
            Workspace.Gravity = 0
          end

        end
      end
    end
    task.wait(0.01)
    end
  end)
end

local function FreeCam()
  task.spawn(function()
    while true do
      local Character = Client.Character
      local Camera = Workspace.CurrentCamera
      if Character then
        local Humanoid = Character:FindFirstChild("Humanoid")
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        if Humanoid and HumanoidRootPart then

          if not Config.FreeCam.Enabled then
            Camera.CameraSubject = Humanoid
            HumanoidRootPart.Anchored = false
            Config.FreeCam.Part:Destroy()
            Config.FreeCam.Part = nil

            Client.CameraMaxZoomDistance = Config.OldMaxZoom
            Client.CameraMinZoomDistance = 10
            task.wait(0.01)
            Client.CameraMinZoomDistance = Config.OldMinZoom

            Config.OldMinZoom = nil
            Config.OldMaxZoom = nil
            break
          end

          if not Config.FreeCam.Part then
            local Part = Instance.new("Part")
            Part.Size = Vector3.new(1,1,1)
            Part.Transparency = 1
            Part.Anchored = true
            Part.CFrame = HumanoidRootPart.CFrame * CFrame.new(-5,0,0)
            Part.Parent = Workspace
            Config.FreeCam.Part = Part
          end

          local Part = Config.FreeCam.Part
          if Part then
            Camera.CameraSubject = Part
            if not Config.OldMaxZoom then
              Config.OldMaxZoom = Client.CameraMaxZoomDistance
            end
            if not Config.OldMinZoom then
              Config.OldMinZoom = Client.CameraMinZoomDistance
            end

            if not HumanoidRootPart.Anchored then
               HumanoidRootPart.Anchored = true
            end

           Client.CameraMinZoomDistance = 0.5
           Client.CameraMaxZoomDistance = 0.5

            local MoveDirection = Camera.CFrame:VectorToObjectSpace(Humanoid.MoveDirection)

            if MoveDirection.Magnitude > 0 then
              local LookVector = Camera.CFrame.LookVector
              local RightVector = Camera.CFrame.RightVector

              local Direction = LookVector * -MoveDirection.Z + RightVector * MoveDirection.X

              if Direction.Magnitude > 0 then
                Direction = Direction.Unit
              end

              Part.CFrame = Part.CFrame + Direction * Config.FreeCam.Speed * Config.FreeCam.SpeedMultiplier
              Part.CFrame = CFrame.lookAt(Part.Position, Part.Position + Camera.CFrame.LookVector)
            end

          end
        end
      end
      task.wait(0.01)
    end
  end)
end

local function FakeLag()
 task.spawn(function()
   local Current = true
   while true do
     local Character = Client.Character
     if Character then
       local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
       if HumanoidRootPart then
       if not Config.FakeLag.Enabled then
         HumanoidRootPart.Anchored = false
         break
       end

       HumanoidRootPart.Anchored = Current

       if Current then
         local Number = tostring(math.random(1,9)) 
         local Decimal = tonumber("0.".. Number)
         task.wait(Decimal)
       else
         local Number = tostring(math.random(1,3)) 
         local Decimal = tonumber("0.".. Number)
         task.wait(Decimal) 
     end

       Current = not Current
       end
      end
   end
 end) 
end

--//Library
local Tab = Window:CreateTab("Movement")

local Section = Tab:CreateSection("Character")

Tab:CreateToggle({
    Name = "Enable WalkSpeed",
    CurrentValue = false,
    Callback = function(State)
      Config.WalkSpeed.Enabled = State
      UpdateHumanoidProperty("WalkSpeed",Config.WalkSpeed)

      if State then
          Notify("WalkSpeed","Enabled",2)
        else
           Notify("WalkSpeed","Disabled",2)
        end
    end
})

Tab:CreateSlider({
    Name = "WalkSpeed Value",
    Range = {0, 1000}, --- Mínimo y máximo
    Increment = 0.1, --- De cuánto en cuánto cambia
    Suffix = "studs/s", --- Texto después del valor
    CurrentValue = 16, --- Valor inicial
    Callback = function(Value)
      Config.WalkSpeed.Value = Value
      UpdateHumanoidProperty("WalkSpeed",Config.WalkSpeed)
    end
})

Tab:CreateToggle({
    Name = "Force WalkSpeed",
    CurrentValue = false,
    Callback = function(State)
      Config.WalkSpeed.Force = State

      if State then
          Notify("Force WalkSpeed","Enabled",2)
        else
           Notify("Force WalkSpeed","Disabled",2)
        end
    end
})

Tab:CreateToggle({
    Name = "Enable JumpPower",
    CurrentValue = false,
    Callback = function(State)
      Config.JumpPower.Enabled = State
      UpdateHumanoidProperty("JumpPower",Config.JumpPower)

      if State then
          Notify("JumpPower","Enabled",2)
        else
           Notify("JumpPower","Disabled",2)
        end
    end
})

Tab:CreateSlider({
    Name = "JumpPower Value",
    Range = {0, 1000}, --- Mínimo y máximo
    Increment = 0.1, --- De cuánto en cuánto cambia
    Suffix = "studs/s", --- Texto después del valor
    CurrentValue = 50, --- Valor inicial
    Callback = function(Value)
      Config.JumpPower.Value = Value
      UpdateHumanoidProperty("JumpPower",Config.JumpPower)
    end
})

Tab:CreateToggle({
    Name = "Force JumpPower",
    CurrentValue = false,
    Callback = function(State)
      Config.JumpPower.Force = State

      if State then
          Notify("Force JumpPower","Enabled",2)
        else
           Notify("Force JumpPower","Disabled",2)
        end
    end
})

Tab:CreateToggle({
    Name = "Enable Fly",
    CurrentValue = false,
    Callback = function(State)
      Config.Fly.Enabled = State
      if State then
        Fly()
      end

      if State then
          Notify("Fly","Enabled",2)
        else
           Notify("Fly","Disabled",2)
        end
    end
})

Tab:CreateSlider({
    Name = "Fly Speed",
    Range = {1, 100}, --- Mínimo y máximo
    Increment = 1, --- De cuánto en cuánto cambia
    Suffix = "studs/s", --- Texto después del valor
    CurrentValue = 1, --- Valor inicial
    Callback = function(Value)
      Config.Fly.Speed = Value
    end
})

Tab:CreateSlider({
    Name = "Fly Speed Multiplier",
    Range = {1, 20}, --- Mínimo y máximo
    Increment = 0.5, --- De cuánto en cuánto cambia
    Suffix = "", --- Texto después del valor
    CurrentValue = 1, --- Valor inicial
    Callback = function(Value)
      Config.Fly.SpeedMultiplier = Value
    end
})

Tab:CreateToggle({
    Name = "Enable Slide",
    CurrentValue = false,
    Callback = function(State)
      Config.Slide.Enabled = State

      if State then
          Notify("Slide","Enabled",2)
        else
           Notify("Slide","Disabled",2)
        end
    end
})

Tab:CreateSlider({
    Name = "Slide Value",
    Range = {0, 100}, --- Mínimo y máximo
    Increment = 1, --- De cuánto en cuánto cambia
    Suffix = "studs/s", --- Texto después del valor
    CurrentValue = 1, --- Valor inicial
    Callback = function(Value)
      Config.Slide.Value = Value
    end
})

Tab:CreateDropdown({
    Name = "Slide Method",
    Options = {
      "CFrame",
      "Velocity"
    },
    Callback = function(Option)
        Config.Slide.Method = Option
        Notify("Slide Method","Method: "..Option.." Selected")
    end
})

Tab:CreateToggle({
    Name = "Enable HipHeight",
    CurrentValue = false,
    Callback = function(State)
      Config.HipHeight.Enabled = State
      UpdateHumanoidProperty("HipHeight",Config.HipHeight)

      if State then
          Notify("HipHeight","Enabled",2)
        else
           Notify("HipHeight","Disabled",2)
        end
    end
})

Tab:CreateSlider({
    Name = "HipHeight Value",
    Range = {0, 100}, --- Mínimo y máximo
    Increment = 1, --- De cuánto en cuánto cambia
    Suffix = "studs/s", --- Texto después del valor
    CurrentValue = 1, --- Valor inicial
    Callback = function(Value)
      Config.HipHeight.Value = Value
      UpdateHumanoidProperty("HipHeight",Config.HipHeight)
    end
})

local VehiclesSection = Tab:CreateSection("Vehicles")

Tab:CreateToggle({
    Name = "Enable Vehicle Fly",
    CurrentValue = false,
    Callback = function(State)
      Config.VehicleFly.Enabled = State
      if State then
        VehicleFly()
      end

      if State then
          Notify("Vehicle Fly","Enabled",2)
        else
           Notify("Vehicle Fly","Disabled",2)
        end
    end
})

Tab:CreateSlider({
    Name = "Vehicle Fly Speed",
    Range = {1, 100}, --- Mínimo y máximo
    Increment = 1, --- De cuánto en cuánto cambia
    Suffix = "studs/s", --- Texto después del valor
    CurrentValue = 1, --- Valor inicial
    Callback = function(Value)
      Config.VehicleFly.Speed = Value
    end
})

Tab:CreateSlider({
    Name = "Vehicle Fly Speed Multiplier",
    Range = {1, 20}, --- Mínimo y máximo
    Increment = 0.5, --- De cuánto en cuánto cambia
    Suffix = "", --- Texto después del valor
    CurrentValue = 1, --- Valor inicial
    Callback = function(Value)
      Config.VehicleFly.SpeedMultiplier = Value
    end
})

local CameraSection = Tab:CreateSection("Camera")

Tab:CreateToggle({
    Name = "Enable FreeCam",
    CurrentValue = false,
    Callback = function(State)
      Config.FreeCam.Enabled = State
      if State then
        FreeCam()
      end

      if State then
          Notify("FreeCam","Enabled",2)
        else
           Notify("FreeCam","Disabled",2)
        end
    end
})

Tab:CreateSlider({
    Name = "FreeCam Speed",
    Range = {1, 100}, --- Mínimo y máximo
    Increment = 1, --- De cuánto en cuánto cambia
    Suffix = "studs/s", --- Texto después del valor
    CurrentValue = 1, --- Valor inicial
    Callback = function(Value)
      Config.FreeCam.Speed = Value
    end
})

Tab:CreateSlider({
    Name = "FreeCam Speed Multiplier",
    Range = {1, 20}, --- Mínimo y máximo
    Increment = 0.5, --- De cuánto en cuánto cambia
    Suffix = "", --- Texto después del valor
    CurrentValue = 1, --- Valor inicial
    Callback = function(Value)
      Config.FreeCam.SpeedMultiplier = Value
    end
})

local Section2 = Tab:CreateSection("Teleport")

Tab:CreateToggle({
    Name = "Teleport Tool",
    CurrentValue = false,
    Callback = function(State)
      Config.TeleportTool.Enabled = State
      if State then
        GetTeleportTool()
      else
        local Tool = Config.TeleportTool.Tool or Client and Client:FindFirstChild("Backpack") and Client.Backpack:FindFirstChild("TeleportTool")
        if Tool then
          Tool:Destroy()
          Config.TeleportTool.Tool = nil
        end
      end

      if State then
          Notify("Teleport Tool","Enabled",2)
        else
           Notify("Teleport Tool","Disabled",2)
        end
    end
})

Tab:CreateToggle({
    Name = "ControlClick Teleport",
    CurrentValue = false,
    Callback = function(State)
      Config.ControlClickTp.Enabled = State

      if State then
          Notify("ControlClickTp","Enabled",2)
        else
           Notify("ControlClickTp","Disabled",2)
        end
    end
})

Tab:CreateButton({
  Name = "Save WayPoint",
  Callback = function()
    WayPointTeleport("Save")
    Notify("Save WayPoint","WayPoint Saved",2)
  end
})

Tab:CreateButton({
  Name = "Teleport To WayPoint",
  Callback = function()
    WayPointTeleport("Teleport")
    Notify("Teleport to WayPoint","Teleported",2)
  end
})

Tab:CreateButton({
  Name = "Delete WayPoint",
  Callback = function()
    WayPointTeleport("Delete")

    Notify("Delete WayPoint","WayPoint Deleted",2)
  end
})

local Section3 = Tab:CreateSection("Physics")

Tab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(State)
      Config.Noclip.Enabled = State
      UpdateNoclip(Config.Noclip)

      if State then
          Notify("Noclip","Enabled",2)
        else
           Notify("Noclip","Disabled",2)
        end
    end
})

Tab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(State)
      Config.InfiniteJump.Enabled = State

      if State then
          Notify("Infinite Jump","Enabled",2)
        else
           Notify("Infinite Jump","Disabled",2)
        end
    end
})

Tab:CreateToggle({
    Name = "AirWalk",
    CurrentValue = false,
    Callback = function(State)
      Config.AirWalk.Enabled = State
      if not State then
        if Config.AirWalk.Platform then
          Config.AirWalk.Platform:Destroy()
          Config.AirWalk.Platform = nil
        end
      end
      if State then
          Notify("AirWalk","Enabled",2)
        else
           Notify("AirWalk","Disabled",2)
        end
    end
})

local Section4 = Tab:CreateSection("Misc Movement")

Tab:CreateToggle({
    Name = "Spin",
    CurrentValue = false,
    Callback = function(State)
      Config.Spin.Enabled = State

      if State then
          Notify("Spin","Enabled",2)
        else
           Notify("Spin","Disabled",2)
        end
    end
})

Tab:CreateSlider({
    Name = "Spin Value",
    Range = {0, 180}, --- Mínimo y máximo
    Increment = 1, --- De cuánto en cuánto cambia
    Suffix = "Spin/s", --- Texto después del valor
    CurrentValue = 1, --- Valor inicial
    Callback = function(Value)
      Config.Spin.Value = Value
    end
})

Tab:CreateToggle({
    Name = "FakeLag",
    CurrentValue = false,
    Callback = function(State)
      Config.FakeLag.Enabled = State
      if State then
        FakeLag()
      end
    end
})

--//Events
Client.CharacterAdded:Connect(function(Character)
    if not Character:FindFirstChild("Humanoid") then
      Character:WaitForChild("Humanoid")
    end
    UpdateHumanoidProperty("WalkSpeed",Config.WalkSpeed)
    UpdateHumanoidProperty("JumpPower",Config.JumpPower)
    UpdateNoclip(Config.Noclip)
    if Config.HipHeight.Enabled then
    UpdateHumanoidProperty("HipHeight",Config.HipHeight)
    end
end)

UserInputService.InputBegan:Connect(function(Input,GameProcessed)
  if Input.KeyCode == Enum.KeyCode.RightControl or Input.KeyCode == Enum.KeyCode.LeftControl then
    Config.ControlClickTp.Pressed = true
  end
  if Input.UserInputType == Enum.UserInputType.MouseButton1 then
    if Config.ControlClickTp.Enabled and Config.ControlClickTp.Pressed then
      local Mouse = Client:GetMouse()
      if Mouse and Mouse.Hit then
        Teleport(Mouse.Hit)
      end
    end
  end
end)

UserInputService.InputEnded:Connect(function(Input,GameProcessed)
  if Input.KeyCode == Enum.KeyCode.RightControl or Input.KeyCode == Enum.KeyCode.LeftControl then
    Config.ControlClickTp.Pressed = false
  end
end)

UserInputService.JumpRequest:Connect(function()
  if Config.InfiniteJump.Enabled then
    local Character = Client.Character
    if Character then
      local Humanoid = Character:FindFirstChild("Humanoid")
      if Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
      end
    end
  end
end)

--//Loops
RunService.Heartbeat:Connect(function()
  if Config.AntifallDamage then
    local HumanoidRootPart = GetHumanoidRootPart()
    if HumanoidRootPart then
      local OldVelocity = HumanoidRootPart.AssemblyLinearVelocity
      HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
      RunService.RenderStepped:Wait()
      HumanoidRootPart.AssemblyLinearVelocity = OldVelocity
    end
  end


  if Config.WalkSpeed.Enabled then
    if Config.WalkSpeed.Force then
      local Humanoid = GetHumanoid()
      if Humanoid then
        if Humanoid.WalkSpeed ~= Config.WalkSpeed.Value then
          UpdateHumanoidProperty("WalkSpeed",Config.WalkSpeed)
        end
      end
    end
  end
  if Config.JumpPower.Enabled then
    if Config.JumpPower.Force then
      local Humanoid = GetHumanoid()
      if Humanoid then
        if Humanoid.JumpPower ~= Config.JumpPower.Value then
          UpdateHumanoidProperty("JumpPower",Config.JumpPower)
        end
      end
    end
  end
  if Config.Slide.Enabled then
    local HumanoidRootPart = GetHumanoidRootPart()
    if HumanoidRootPart then
      local Method = Config.Slide.Method
      local Value = Config.Slide.Value
      local MoveDirection = GetMoveDirection()
      if MoveDirection and MoveDirection.Magnitude > 0 then
        if Method == "CFrame" then
          Teleport((HumanoidRootPart.Position + MoveDirection.Unit * Value))
        elseif Method == "Velocity" then
          ApplyVelocity(Vector3.new(MoveDirection.X * Value * 4,HumanoidRootPart.AssemblyLinearVelocity.Y,MoveDirection.Z * Value * 4))
        end
      end
    end
  end
  if Config.Noclip.Enabled then
    UpdateNoclip(Config.Noclip)
  end
  if Config.AirWalk.Enabled then
    UpdatePlatform()
  end
  if Config.HipHeight.Enabled then
    UpdateHumanoidProperty("HipHeight",Config.HipHeight)
  end
  if Config.Spin.Enabled then
    local HumanoidRootPart = GetHumanoidRootPart()
    if HumanoidRootPart then
      Teleport(HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(Config.Spin.Value),0))
    end
  end
end)