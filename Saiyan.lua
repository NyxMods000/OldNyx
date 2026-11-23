--//Services
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

--//Variables
local Client = Players.LocalPlayer

--//Tables
local Fly = {
  States = {
    IsFlying = false,
    
    CurrentTrack = nil,
    
    MaxSpeed = 200,
    CurrentSpeed = 0,
    Aceleration = 60,
    VerticalSpeed = 100,
    
    LastMovement = nil,
    
    Landed = false,
    Up = false,
    Down = false,
  },

  Animations = {
    Float = "110374347936429",
    SlowFly = "110637848614810",
    FastFly = "126476030340764",
    Up = "71583407731269",
    Down = "82054441879488",
    Landed = "137479353652377",
  },

  FlyStates = {},
  
  Objects = {
    BodyVelocity = nil,
    BodyGyro = nil,
  },
  Connection = nil,
}

local Habilities = {
  States = {
    IsUsingHability = false,
    UltraInstinct = false,
    Dodge = false,
  },
  Animations = {
    BigPunch = "135011559207475",
    FastPunchs = "78141686608052",
    Kamehameha = "86834901481293",
    Genkidama = "96643028604165",
    Teleport = "133631846764964",
    Dodge = "115224081675227",
    Charge = {
      ChargeStart = "112220709701439",
      ChargeEnd = "132846696697494",
    }
  }
}

local MovementAnimations = {
  Idle = "79770827380799",
  Walk = "94694566780187",
  Run = "122493804575566",
  Jump = "123623386947069",
  Fall = "81582918973617",
}

local Cache = {
  
}

--//Utilities
local function ItsAPlayerInstance(Instance)
  local Model = Instance:FindFirstAncestorOfClass("Model")
  if Model then
    local Player = Players:GetPlayerFromCharacter(Model)
    if Player then
      return Player
     end
  end
  return nil
end

local function GetHumanoid(Player)
  local Character = Player.Character
  if Character then
    local Humanoid = Character:FindFirstChild("Humanoid")
    if Humanoid then
      return Humanoid
    end
  end
  return nil
end

local function GetRootPart(Player)
  local Character = Player.Character
  if Character then
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
    if RootPart then
      return RootPart
    end
  end
  return nil
end

local function GetAnimate(Player)
  local Character = Player.Character
  if Character then
    local Animate = Character:FindFirstChild("Animate")
    if Animate then
      return Animate
    end
  end
  return nil
end

local function GetClosestPlayer()
  local MaxDistance = math.huge
  local ClosestPlayer = nil
  for i,Player in ipairs(Players:GetPlayers()) do
    if Player == Client then continue end
    local TRootPart = GetRootPart(Player)
    local RootPart = GetRootPart(Client)
    if TRootPart and RootPart then
      local Distance = (RootPart.Position - TRootPart.Position).Magnitude
      
      if Distance < MaxDistance then
        MaxDistance = Distance
        ClosestPlayer = Player
      end
    end
  end
  return ClosestPlayer
end

local function StopAllAnimationTracks(Humanoid)
  for i,Track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
    Track:Stop()
  end
end

local function GetAnimationTrack(Humanoid,AnimationId)
  for i,Track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
    local Animation = Track and Track.Animation
    if Animation then
      if Animation.AnimationId == "rbxassetid://"..AnimationId then
        return Track
      end
    end
  end
  return nil
end

local function PlayAnimation(Humanoid,Id,Speed,Time,Paused,Looped,Priority)
  local Animation = Instance.new("Animation")
  Animation.AnimationId = "rbxassetid://"..Id
  
  local Track = Humanoid:LoadAnimation(Animation)
  Track:Play()
  
  Track.TimePosition = Time
  Track.Looped = Looped
  Track.Priority = Priority
  Track:AdjustSpeed(Speed)
  
  if Paused then
    Track.TimePosition = Time
    Track:AdjustSpeed(0)
  end
  
  return Track
end

local function ResetAnimate()
  local Animate = GetAnimate(Client)
  if Animate then
    Animate.Disabled = true
    task.wait(0.01)
    Animate.Enabled = true
  end
end

--//SetMovementAnimations
local function SetMovementAnimations()
  local Animate = GetAnimate(Client)
  if Animate then
    for Type,Id in pairs(MovementAnimations) do
      local Folder = Animate:FindFirstChild(string.lower(tostring(Type)))
      if Folder then
        Folder:ClearAllChildren()
        
        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://"..Id
        Animation.Parent = Folder
      else
        return false
      end
    end
    local Humanoid = GetHumanoid(Client)
    if Humanoid then
      StopAllAnimationTracks(Humanoid)
      return true
    end
  end
  return false
end

--//Fly
function Fly.FlyStates:Float()
  local Humanoid = GetHumanoid(Client)
  if Humanoid then
    local AnimationId = Fly.Animations.Float
    if AnimationId ~= nil then
      
      if GetAnimationTrack(Humanoid,AnimationId) then
        return
      end
      
      if Fly.States.CurrentTrack then
        Fly.States.CurrentTrack:Stop()
        Fly.States.CurrentTrack = nil
      end
      
      local Track = PlayAnimation(Humanoid,AnimationId,1,0,false,true,Enum.AnimationPriority.Action)
      
      Fly.States.CurrentTrack = Track
    end
  end
end

function Fly.FlyStates:SlowFly()
  local Humanoid = GetHumanoid(Client)
  if Humanoid then
    local AnimationId = Fly.Animations.SlowFly
    if AnimationId ~= nil then
      
      if GetAnimationTrack(Humanoid,AnimationId) then
        return
      end
      
      if Fly.States.CurrentTrack then
        Fly.States.CurrentTrack:Stop()
        Fly.States.CurrentTrack = nil
      end
      
      local Track = PlayAnimation(Humanoid,AnimationId,1,0,false,true,Enum.AnimationPriority.Action)
      
      Fly.States.CurrentTrack = Track
    end
  end
end

function Fly.FlyStates:FastFly()
  local Humanoid = GetHumanoid(Client)
  if Humanoid then
    local AnimationId = Fly.Animations.FastFly
    if AnimationId ~= nil then
      
      if GetAnimationTrack(Humanoid,AnimationId) then
        return
      end
      
      if Fly.States.CurrentTrack then
        Fly.States.CurrentTrack:Stop()
        Fly.States.CurrentTrack = nil
      end
      
      local Track = PlayAnimation(Humanoid,AnimationId,1,0,false,true,Enum.AnimationPriority.Action)
      
      Fly.States.CurrentTrack = Track
    end
  end
end

function Fly.FlyStates:Up()
  local Humanoid = GetHumanoid(Client)
  if Humanoid then
    local AnimationId = Fly.Animations.Up
    if AnimationId ~= nil then
      
      if GetAnimationTrack(Humanoid,AnimationId) then
        return
      end
      
      if Fly.States.CurrentTrack then
        Fly.States.CurrentTrack:Stop()
        Fly.States.CurrentTrack = nil
      end
      
      local Track = PlayAnimation(Humanoid,AnimationId,1,0,false,true,Enum.AnimationPriority.Action)
      
      Fly.States.CurrentTrack = Track
    end
  end
end

function Fly.FlyStates:Down()
  local Humanoid = GetHumanoid(Client)
  if Humanoid then
    local AnimationId = Fly.Animations.Down
    if AnimationId ~= nil then
      
      if GetAnimationTrack(Humanoid,AnimationId) then
        return
      end
      
      if Fly.States.CurrentTrack then
        Fly.States.CurrentTrack:Stop()
        Fly.States.CurrentTrack = nil
      end
      
      local Track = PlayAnimation(Humanoid,AnimationId,1,0,false,true,Enum.AnimationPriority.Action)
      
      Fly.States.CurrentTrack = Track
    end
  end
end

function Fly.FlyStates:Landed()
  local Humanoid = GetHumanoid(Client)
  if Humanoid then
    local AnimationId = Fly.Animations.Landed
    if AnimationId ~= nil then
      
      if GetAnimationTrack(Humanoid,AnimationId) then
        return
      end
      
      if Fly.States.CurrentTrack then
        Fly.States.CurrentTrack:Stop()
        Fly.States.CurrentTrack = nil
      end
      
      local Track = PlayAnimation(Humanoid,AnimationId,1,0,false,true,Enum.AnimationPriority.Action)
      
      Fly.States.CurrentTrack = Track
    end
  end
end

local function CreateBodyVelocity()
  local RootPart = GetRootPart(Client)
  if RootPart then
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Name = "BV"
    BodyVelocity.MaxForce = Vector3.new(9e9,9e9,9e9)
    BodyVelocity.P = 30000
    BodyVelocity.Velocity = Vector3.zero
    BodyVelocity.Parent = RootPart
    
    Fly.Objects.BodyVelocity = BodyVelocity
    
    return BodyVelocity
  end
end

local function CreateBodyGyro()
  local RootPart = GetRootPart(Client)
  if RootPart then
    local BodyGyro = Instance.new("BodyGyro")
    BodyGyro.CFrame = RootPart.CFrame
    BodyGyro.Name = "BG"
    BodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
    BodyGyro.P = 30000
    BodyGyro.D = 1000
    BodyGyro.Parent = RootPart
    
    Fly.Objects.BodyGyro = BodyGyro
    
    return BodyGyro
  end
end

local function GetFlyState(dt)
  local Humanoid = GetHumanoid(Client)
  if Humanoid then
    
    if Fly.States.Landed then
      return "Landed"
    end
    if Fly.States.Up then
      return "Up"
    end
    if Fly.States.Down then
      return "Down"
    end
    
    local MoveDirection = Humanoid.MoveDirection
    if MoveDirection.Magnitude > 0 then
      local LastMovement = Fly.States.LastMovement 
      if not LastMovement then
        Fly.States.LastMovement = os.clock()
        LastMovement = Fly.States.LastMovement
      end
      Fly.States.CurrentSpeed = math.clamp(Fly.States.CurrentSpeed + Fly.States.Aceleration * dt,1,Fly.States.MaxSpeed)
      if os.clock() - LastMovement < 2 then
        return "SlowFly"
      elseif os.clock() - LastMovement > 2 then
        return "FastFly"
      end
    else
      Fly.States.CurrentSpeed = 0
      Fly.States.LastMovement = nil
      return "Float"
    end
    
  end
end

local function GetFlyStateFunction(State)
  if State == "Float" then
    return Fly.FlyStates.Float
  elseif State == "SlowFly" then
    return Fly.FlyStates.SlowFly
  elseif State == "FastFly" then
    return Fly.FlyStates.FastFly
  elseif State == "Up" then
    return Fly.FlyStates.Up
  elseif State == "Down" then
    return Fly.FlyStates.Down
  elseif State == "Landed" then
    return Fly.FlyStates.Landed
  else
    return nil
  end
end

local function UpdateBodyVelocity(BodyVelocity,dt)
  local RootPart = GetRootPart(Client)
  local Humanoid = GetHumanoid(Client)
  local Camera = Workspace.CurrentCamera
  if BodyVelocity and RootPart and Humanoid and Camera then
    local FlyState = GetFlyState(dt)
    
    local MoveDirection = Camera.CFrame:VectorToObjectSpace(Humanoid.MoveDirection)
    
    local Direction = Camera.CFrame.LookVector * -MoveDirection.Z + Camera.CFrame.RightVector * MoveDirection.X
    
    if Fly.States.Up then
      BodyVelocity.Velocity = Vector3.new(0,Fly.States.VerticalSpeed,0)
    elseif Fly.States.Down then
      BodyVelocity.Velocity = Vector3.new(0,-Fly.States.VerticalSpeed,0)
    elseif Fly.States.Landed then
      BodyVelocity.Velocity = Vector3.zero
    elseif FlyState == "Float" then
      BodyVelocity.Velocity = Vector3.zero
    elseif FlyState == "SlowFly" then
      BodyVelocity.Velocity = Direction.Unit * Fly.States.CurrentSpeed
    elseif FlyState == "FastFly" then
      BodyVelocity.Velocity = Direction.Unit * Fly.States.CurrentSpeed
    end
    
  end
end

local function UpdateBodyGyro(BodyGyro)
  local RootPart = GetRootPart(Client)
  local Camera = Workspace.CurrentCamera
  if BodyGyro and RootPart and Camera then
    BodyGyro.CFrame = CFrame.lookAt(RootPart.Position,RootPart.Position + Camera.CFrame.LookVector)
  end
end

local function StopFly()
  local BodyVelocity = Fly.Objects.BodyVelocity
  local BodyGyro = Fly.Objects.BodyGyro
  local Connection = Fly.Connection
  
  if BodyVelocity then BodyVelocity:Destroy() end
  if BodyGyro then BodyGyro:Destroy() end
  if Connection then Connection:Disconnect() Connection = nil end
  
  if Fly.States.CurrentTrack then 
    Fly.States.CurrentTrack:Stop()
    Fly.States.CurrentTrack = nil
  end
  ResetAnimate()
end

local function InitFly()
  Fly.Connection = RunService.Heartbeat:Connect(function(dt)
    local RootPart = GetRootPart(Client)
    if RootPart then
      if not RootPart:FindFirstChildOfClass("BodyVelocity") then
        CreateBodyVelocity()
      end
      if not RootPart:FindFirstChildOfClass("BodyGyro") then
        CreateBodyGyro()
      end
      
      if not Fly.States.IsFlying then
        StopFly()
      end
      
      local State = GetFlyState(dt)
      local StateFunction = GetFlyStateFunction(State)
      if StateFunction then
        StateFunction()
      end
      
      local BodyVelocity = Fly.Objects.BodyVelocity
      UpdateBodyVelocity(BodyVelocity,dt)
      
      local BodyGyro = Fly.Objects.BodyGyro
      UpdateBodyGyro(BodyGyro)
      
    end
  end)
end

--//Habilities
local function StopFling(Connection)
  Connection:Disconnect()
  
  local Humanoid = GetHumanoid(Client)
  if Humanoid then
    Humanoid.CameraOffset = Vector3.zero
  end
end

local function Fling(Target,Direction)
  if not Target then return end
  
  local Frames = 0
  local FlingEnded = false
  local Connection
  Connection = RunService.Heartbeat:Connect(function()
    Frames = Frames + 1
    if Frames > 120 then
      StopFling(Connection)
      FlingEnded = true
      return
    end
    if not Target then
      StopFling(Connection)
      FlingEnded = true
      return
    end
    
    local RootPart = GetRootPart(Client)
    local TRootPart = GetRootPart(Target)
    local Humanoid = GetHumanoid(Client)
    local Camera = Workspace.CurrentCamera
    
    if not RootPart then return end
    if not TRootPart then return end
    if not Humanoid then return end
    
    local OldCFrame = RootPart.CFrame
    local OldCameraOffset = Humanoid.CameraOffset
    local OldAngular = RootPart.AssemblyAngularVelocity
    local OldLinear = RootPart.AssemblyLinearVelocity
    local OldVelocity = RootPart.Velocity
    local OldRot = RootPart.RotVelocity
    
    local TargetCFrame = TRootPart.CFrame
    
    if sethiddenproperty then
      sethiddenproperty(RootPart,"PhysicsRepRootPart",TRootPart)
      RootPart.CFrame = TRootPart.CFrame
    else
      RootPart.CFrame = (TRootPart.CFrame + TRootPart.AssemblyLinearVelocity / 1.3) * CFrame.Angles(math.random(0,360),math.random(0,360),math.random(0,360))
    end
    
    RootPart.AssemblyAngularVelocity = Direction.Unit * 10000
    
    local CameraOffset = TargetCFrame:ToObjectSpace(OldCFrame).Position
    Humanoid.CameraOffset = CameraOffset
    
    RunService.RenderStepped:Wait()
    
    RootPart.CFrame = OldCFrame * CFrame.new(0,-0.01,0)
    RootPart.AssemblyAngularVelocity = OldAngular
    RootPart.AssemblyLinearVelocity = OldLinear
    RootPart.Velocity = OldVelocity
    RootPart.RotVelocity = OldRot
    Humanoid.CameraOffset = OldCameraOffset
    
    if TRootPart.Velocity.Magnitude > 1000 then
      StopFling(Connection)
      FlingEnded = true
      return
    end
    
  end)
  repeat task.wait() until FlingEnded
end

local function BigPunch()
  if Habilities.States.IsUsingHability then return end
  Habilities.States.IsUsingHability = true
  
  local ClosestPlayer = GetClosestPlayer()
  if ClosestPlayer then
    local RootPart = GetRootPart(Client)
    local Humanoid = GetHumanoid(Client)
    local ClosestRootPart = GetRootPart(ClosestPlayer)
    if RootPart and Humanoid and ClosestRootPart then
      local Distance = (RootPart.Position - ClosestRootPart.Position).Magnitude
      if Distance > 10 then 
        Habilities.States.IsUsingHability = false
        return 
      end
      
      RootPart.CFrame = ClosestRootPart.CFrame * CFrame.new(0,0,-1) * CFrame.Angles(0,math.rad(180),0)
      local Track = PlayAnimation(Humanoid,Habilities.Animations.BigPunch,2,0,false,false,Enum.AnimationPriority.Action4)
      task.wait(0.25)
      Fling(ClosestPlayer,RootPart.CFrame.LookVector)
    end
  end
  Habilities.States.IsUsingHability = false
end

local function FastPunchs()
  if Habilities.States.IsUsingHability then return end
  Habilities.States.IsUsingHability = true
  
  local ClosestPlayer = GetClosestPlayer()
  if ClosestPlayer then
    local RootPart = GetRootPart(Client)
    local Humanoid = GetHumanoid(Client)
    local ClosestRootPart = GetRootPart(ClosestPlayer)
    if RootPart and Humanoid and ClosestRootPart then
      local Distance = (RootPart.Position - ClosestRootPart.Position).Magnitude
      if Distance > 10 then 
        Habilities.States.IsUsingHability = false
        return 
      end
      
      task.spawn(function()
        for i = 1,100,1 do
          RootPart.CFrame = ClosestRootPart.CFrame * CFrame.new(0,0,-1) * CFrame.Angles(0,math.rad(180),0)
          task.wait(0.01)
        end
      end)
      local Track = PlayAnimation(Humanoid,Habilities.Animations.FastPunchs,2,0,false,true,Enum.AnimationPriority.Action4)
      task.wait(1.5)
      Track:Stop()
      Fling(ClosestPlayer,RootPart.CFrame.LookVector)
    end
  end
  Habilities.States.IsUsingHability = false
end

local function CreateKamehameha()

  --//==================================================
  --// CONFIG
  --//==================================================

  local PartsPerStud = 2

  local SpiralDistance = 3

  local Spiral1Turns = 18
  local Spiral2Turns = 13


  --//==================================================
  --// BEAM
  --//==================================================

  local Beam = Instance.new("Part")

  Beam.Shape = Enum.PartType.Cylinder
  Beam.Material = Enum.Material.Neon

  Beam.Size = Vector3.new(0, 0, 0)

  Beam.Color =
    Color3.fromRGB(0, 170, 255)

  Beam.Transparency = 1

  Beam.CanCollide = false
  Beam.CanQuery = false
  Beam.CanTouch = false

  Beam.CastShadow = false
  Beam.Anchored = true

  Beam.Parent = Workspace


  --//==================================================
  --// LIGHT
  --//==================================================

  local Light = Instance.new("PointLight")

  Light.Color =
    Color3.fromRGB(0, 170, 255)

  Light.Brightness = 0
  Light.Range = 0

  Light.Shadows = true

  Light.Parent = Beam


  --//==================================================
  --// AURA
  --//==================================================

  local Aura = Instance.new("Highlight")

  Aura.FillTransparency = 1

  Aura.OutlineColor =
    Color3.fromRGB(0, 220, 255)

  Aura.OutlineTransparency = 0

  Aura.DepthMode =
    Enum.HighlightDepthMode.Occluded

  Aura.Parent = Beam


  --//==================================================
  --// CORE
  --//==================================================

  local Core = Instance.new("Part")

  Core.Shape = Enum.PartType.Cylinder
  Core.Material = Enum.Material.Neon

  Core.Color =
    Color3.fromRGB(230, 250, 255)

  Core.Transparency = 1

  Core.CanCollide = false
  Core.CanQuery = false
  Core.CanTouch = false

  Core.CastShadow = false
  Core.Anchored = true

  Core.Parent = Workspace


  --// Core Aura
  local CoreAura = Instance.new("Highlight")

  CoreAura.FillTransparency = 1

  CoreAura.OutlineColor =
    Color3.fromRGB(180, 245, 255)

  CoreAura.OutlineTransparency = 0

  CoreAura.DepthMode =
    Enum.HighlightDepthMode.Occluded

  CoreAura.Parent = Core


  --// Core Light
  local CoreLight = Instance.new("PointLight")

  CoreLight.Color =
    Color3.fromRGB(180, 240, 255)

  CoreLight.Brightness = 0
  CoreLight.Range = 0

  CoreLight.Shadows = false

  CoreLight.Parent = Core


  --//==================================================
  --// SPARKLES
  --//==================================================

  local Sparkles = Instance.new("Sparkles")

  Sparkles.SparkleColor =
    Color3.fromRGB(220, 250, 255)

  Sparkles.Enabled = true

  Sparkles.Parent = Beam


  --//==================================================
  --// SPIRALS
  --//==================================================

  local Spiral = {
    Speed = 15,
    Angle = 0
  }

  local Spiral2 = {
    Speed = 21,
    Angle = math.pi
  }


  --//==================================================
  --// PART TABLES
  --//==================================================

  local Parts = {}
  local Parts2 = {}

  local Connection


  --//==================================================
  --// HEARTBEAT
  --//==================================================

  Connection = RunService.Heartbeat:Connect(function(dt)

    --// Beam destroyed
    if not Beam.Parent then

      Connection:Disconnect()

      Core:Destroy()

      for _, Part in ipairs(Parts) do
        Part:Destroy()
      end

      for _, Part in ipairs(Parts2) do
        Part:Destroy()
      end

      table.clear(Parts)
      table.clear(Parts2)

      return
    end


    local BeamSize = Beam.Size


    --//==================================================
    --// LENGTH
    --//==================================================

    local Length = math.max(
      0,
      math.floor(
        BeamSize.X * PartsPerStud
      )
    )


    --//==================================================
    --// PART SIZES
    --//==================================================

    --// Pequeñas para evitar que se vean estiradas
    local PartSize = Vector3.new(
  0.45,
  math.clamp(
    BeamSize.Y / 3,
    1,
    5 -- máximo 7
  ),
  math.clamp(
    BeamSize.Z / 3,
    1,
    5 -- máximo 7
  )
)


local PartSize2 = Vector3.new(
  0.3,
  math.clamp(
    BeamSize.Y / 5,
    1,
    3 -- máximo 5
  ),
  math.clamp(
    BeamSize.Z / 5,
    1,
    3 -- máximo 5
  )
)


    --//==================================================
    --// CREATE SPIRAL 1
    --//==================================================

    for i = 1, Length do

      if not Parts[i] then

        local Part = Instance.new("Part")

        Part.Anchored = true

        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false

        Part.CastShadow = false

        Part.Material =
          Enum.Material.Neon

        Part.Color =
          Color3.fromRGB(
            235,
            250,
            255
          )

        Part.Parent = Workspace

        Parts[i] = Part
      end
    end


    --//==================================================
    --// CREATE SPIRAL 2
    --//==================================================

    for i = 1, Length do

      if not Parts2[i] then

        local Part = Instance.new("Part")

        Part.Anchored = true

        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false

        Part.CastShadow = false

        Part.Material =
          Enum.Material.Neon

        Part.Color =
          Color3.fromRGB(
            70,
            190,
            255
          )

        Part.Parent = Workspace

        Parts2[i] = Part
      end
    end


    --//==================================================
    --// REMOVE EXCESS
    --//==================================================

    for i = #Parts, Length + 1, -1 do

      Parts[i]:Destroy()
      Parts[i] = nil

    end


    for i = #Parts2, Length + 1, -1 do

      Parts2[i]:Destroy()
      Parts2[i] = nil

    end


    --//==================================================
    --// ROTATION
    --//==================================================

    Spiral.Angle +=
      Spiral.Speed * dt

    Spiral2.Angle +=
      Spiral2.Speed * dt


    --//==================================================
    --// RADIUS
    --//==================================================

    --// La espiral queda SpiralDistance
    --// studs fuera de la superficie del Beam

    local Radius =
      math.max(
        BeamSize.Y,
        BeamSize.Z
      ) / 2
      + SpiralDistance


    --// Segunda espiral más cerca
    local Radius2 =
      Radius * 0.72


    --//==================================================
    --// PULSE
    --//==================================================

    local Pulse =
      (
        math.sin(
          Spiral.Angle * 6
        ) + 1
      ) / 2


    --//==================================================
    --// SPIRAL 1
    --//==================================================

    for i, Part in ipairs(Parts) do

      --// IMPORTANTE:
      --// Alpha representa la posición REAL
      --// dentro del largo del Beam.

      local Alpha =
        (i - 0.5) / Length


      --// Esto evita que las Parts
      --// se salgan del Beam en X.

      local X =
        -BeamSize.X / 2
        + Alpha * BeamSize.X


      --// Vueltas
      local Angle =
        Spiral.Angle
        + Alpha
        * math.pi
        * 2
        * Spiral1Turns


      --// Ondulación
      local Wave =
        math.sin(
          Spiral.Angle * 4
          + Alpha * math.pi * 12
        ) * 1.5


      local CurrentRadius =
        Radius + Wave


      local Y =
        math.cos(Angle)
        * CurrentRadius


      local Z =
        math.sin(Angle)
        * CurrentRadius


      Part.CFrame =
        Beam.CFrame
        * CFrame.new(
          X,
          Y,
          Z
        )


      Part.Size =
        PartSize


      --// Brillo variable
      local ColorWave =
        (
          math.sin(
            Spiral.Angle * 5
            + Alpha * math.pi * 8
          ) + 1
        ) / 2


      Part.Color =
        Color3.new(
          0.78 + ColorWave * 0.22,
          0.92 + ColorWave * 0.08,
          1
        )


      Part.Transparency =
        math.clamp(
          Beam.Transparency
          + 0.1
          - Pulse * 0.1,
          0,
          1
        )


      Part.Material =
        Beam.Material
    end


    --//==================================================
    --// SPIRAL 2
    --//==================================================

    for i, Part in ipairs(Parts2) do

      local Alpha =
        (i - 0.5) / Length


      --// MISMA CORRECCIÓN:
      --// siempre dentro del Beam.

      local X =
        -BeamSize.X / 2
        + Alpha * BeamSize.X


      --// Dirección contraria
      local Angle =
        Spiral2.Angle
        + Alpha
        * math.pi
        * 2
        * Spiral2Turns


      local Wave =
        math.cos(
          Spiral2.Angle * 5
          + Alpha * math.pi * 10
        ) * 1


      local CurrentRadius =
        Radius2 + Wave


      local Y =
        math.cos(Angle)
        * CurrentRadius


      local Z =
        math.sin(Angle)
        * CurrentRadius


      Part.CFrame =
        Beam.CFrame
        * CFrame.new(
          X,
          Y,
          Z
        )


      Part.Size =
        PartSize2


      Part.Transparency =
        math.clamp(
          Beam.Transparency
          + 0.2
          - Pulse * 0.15,
          0,
          1
        )


      Part.Material =
        Beam.Material
   
    end


    --//==================================================
    --// CORE
    --//==================================================

    Core.CFrame =
      Beam.CFrame


    local CoreScale =
      0.38
      + Pulse * 0.10


    Core.Size =
      Vector3.new(
        BeamSize.X,

        math.max(
          BeamSize.Y
          * CoreScale,
          0
        ),

        math.max(
          BeamSize.Z
          * CoreScale,
          0
        )
      )


    Core.Transparency =
      Beam.Transparency


    --//==================================================
    --// CORE EFFECTS
    --//==================================================

    CoreAura.OutlineTransparency =
      0.05
      + Pulse * 0.3


    CoreLight.Brightness =
      4
      + Pulse * 8


    CoreLight.Range =
      math.max(
        BeamSize.X * 0.5,
        8
      )


    --//==================================================
    --// AURA
    --//==================================================

    Aura.OutlineTransparency =
      0.05
      + Pulse * 0.3


    --//==================================================
    --// SPARKLES
    --//==================================================

    Sparkles.SparkleColor =
      Color3.fromRGB(
        170 + Pulse * 85,
        225 + Pulse * 30,
        255
      )


    --//==================================================
    --// LIGHT
    --//==================================================

    Light.Brightness =
      math.min(
        Light.Brightness
        + dt * 10,
        10
      )


    Light.Brightness +=
      Pulse * 0.15


    Light.Range =
      BeamSize.X

  end)


  --//==================================================
  --// RETURN
  --//==================================================

  return Beam, Light, Aura

end

local function Kamehameha()
  if Habilities.States.IsUsingHability then return end
  Habilities.States.IsUsingHability = true
  
  local RootPart = GetRootPart(Client)
  local Humanoid = GetHumanoid(Client)
  if RootPart and Humanoid then
    local Track = PlayAnimation(Humanoid,Habilities.Animations.Kamehameha,3,0,false,false,Enum.AnimationPriority.Action4)
    task.wait(2.25)
    local Track = PlayAnimation(Humanoid,Habilities.Animations.Kamehameha,1,7,true,false,Enum.AnimationPriority.Action4)
    local Kamehameha,Light,Aura = CreateKamehameha()
    local UpdateKamehamehaCFrame = true
    local Connection
    Connection = RunService.Heartbeat:Connect(function()
      if not Kamehameha then
        Connection:Disconnect()
        Connection = nil
        return
      end
      local X = math.clamp(Kamehameha.Size.X + 8,0,150)
      local Y = math.clamp(Kamehameha.Size.X / 16,0,20)
      local Z = math.clamp(Kamehameha.Size.X / 16,0,20)
      
      Kamehameha.Size = Vector3.new(X,Y,Z)
      Kamehameha.Transparency = Kamehameha.Transparency - 0.01
      
      if UpdateKamehamehaCFrame then
        if RootPart then
          Kamehameha.CFrame = RootPart.CFrame * CFrame.new(0,0,-2 + -Kamehameha.Size.X / 2) * CFrame.Angles(0,math.rad(90),0)
        else
          Connection:Disconnect()
          Connection = nil
          return
        end
      end
    end)
    local AlreadyHit = {}
    local HitConnection
    HitConnection = RunService.Heartbeat:Connect(function()
      if not Kamehameha then
        HitConnection:Disconnect()
        HitConnection = nil
        return
      end
      
      local PartsBoundInBox = Workspace:GetPartBoundsInBox(Kamehameha.CFrame,Kamehameha.Size)
      for i,Part in ipairs(PartsBoundInBox) do
        local Player = ItsAPlayerInstance(Part)
        if Player and Player ~= Client then
          if not AlreadyHit[Player] then
            AlreadyHit[Player] = true
            
            local Character = Player.Character
            if Character then
              for i,Instance in ipairs(Character:GetDescendants()) do
                if Instance:IsA("BasePart") and Instance.Name ~= "HumanoidRootPart" then
                  Instance.Transparency = 1
                end
              end
            end
            
          end
        end
      end
    end)
    task.wait(6)
  Connection:Disconnect()
  Connection = nil
  local Connection
  Connection = RunService.Heartbeat:Connect(function()
    if not Kamehameha then
      Connection:Disconnect()
      Connection = nil
      return
    end
      local X = Kamehameha.Size.X - 8
      local Y = Kamehameha.Size.Y - 2
      local Z = Kamehameha.Size.Z - 2
      
      Kamehameha.Size = Vector3.new(X,Y,Z)
      Kamehameha.Transparency = Kamehameha.Transparency + 0.01
      
        if RootPart then
          Kamehameha.CFrame = RootPart.CFrame * CFrame.new(0,0,-1 + -Kamehameha.Size.X / 2) * CFrame.Angles(0,math.rad(90),0)
        end
  end)
  repeat RunService.Heartbeat:Wait() until Kamehameha and Kamehameha.Size.Y < 1
  Kamehameha:Destroy()
  Track:Stop()
  HitConnection:Disconnect()
  HitConnection = nil
  
  for Player,_ in pairs(AlreadyHit) do
    if RootPart then
      Fling(Player,RootPart.CFrame.LookVector)
    end
    local Character = Player.Character
    if Character then
      for _,Part in ipairs(Character:GetDescendants()) do
        if Part:IsA("BasePart") and Part.Name ~= "HumanoidRootPart" then
          Part.Transparency = 0
        end
      end
    end
  end
  
  end
  Habilities.States.IsUsingHability = false
end

local function CreateGenkidama()
  --// Services
  local RunService = game:GetService("RunService")
  local Workspace = game:GetService("Workspace")

  --// Main Genkidama
  local Genkidama = Instance.new("Part")
  Genkidama.Shape = Enum.PartType.Ball
  Genkidama.Material = Enum.Material.Neon
  Genkidama.Size = Vector3.new(0, 0, 0)
  Genkidama.Transparency = 0
  Genkidama.Color = Color3.fromRGB(40, 190, 255)
  Genkidama.CanCollide = false
  Genkidama.CanQuery = false
  Genkidama.CanTouch = false
  Genkidama.CastShadow = false
  Genkidama.Anchored = true
  Genkidama.Parent = Workspace

  --// Main Aura
  local Aura = Instance.new("Highlight")
  Aura.FillColor = Color3.fromRGB(0, 170, 255)
  Aura.FillTransparency = 1
  Aura.OutlineColor = Color3.fromRGB(170, 245, 255)
  Aura.OutlineTransparency = 0
  Aura.DepthMode = Enum.HighlightDepthMode.Occluded
  Aura.Parent = Genkidama

  --// Main Light
  local Light = Instance.new("PointLight")
  Light.Color = Color3.fromRGB(80, 210, 255)
  Light.Brightness = 0
  Light.Range = 0
  Light.Shadows = false
  Light.Parent = Genkidama

  --------------------------------------------------
  --// Inner Energy
  --------------------------------------------------

  local Core = Instance.new("Part")
  Core.Shape = Enum.PartType.Ball
  Core.Material = Enum.Material.Neon
  Core.Size = Vector3.new(0, 0, 0)
  Core.Transparency = 0
  Core.Color = Color3.fromRGB(225, 250, 255)
  Core.CanCollide = false
  Core.CanQuery = false
  Core.CanTouch = false
  Core.CastShadow = false
  Core.Anchored = true
  Core.Parent = Workspace

  local CoreLight = Instance.new("PointLight")
  CoreLight.Color = Color3.fromRGB(220, 250, 255)
  CoreLight.Brightness = 0
  CoreLight.Range = 0
  CoreLight.Shadows = false
  CoreLight.Parent = Core

  --------------------------------------------------
  --// Outer Aura Sphere
  --------------------------------------------------

  local OuterAura = Instance.new("Part")
  OuterAura.Shape = Enum.PartType.Ball
  OuterAura.Material = Enum.Material.ForceField
  OuterAura.Size = Vector3.new(0, 0, 0)
  OuterAura.Transparency = 0.72
  OuterAura.Color = Color3.fromRGB(0, 140, 255)
  OuterAura.CanCollide = false
  OuterAura.CanQuery = false
  OuterAura.CanTouch = false
  OuterAura.CastShadow = false
  OuterAura.Anchored = true
  OuterAura.Parent = Workspace

  --------------------------------------------------
  --// Energy Balls
  --------------------------------------------------

  local EnergyBalls = {}

  local MaxEnergyBalls = 80

  --------------------------------------------------
  --// Orbiting Energy
  --------------------------------------------------

  local Orbiters = {}

  for i = 1, 14 do
    local Orb = Instance.new("Part")

    Orb.Shape = Enum.PartType.Ball
    Orb.Material = Enum.Material.Neon
    Orb.Size = Vector3.new(
      math.random(2, 5) / 10,
      math.random(2, 5) / 10,
      math.random(2, 5) / 10
    )

    Orb.Color = Color3.fromRGB(
      math.random(80, 150),
      math.random(200, 255),
      255
    )

    Orb.CanCollide = false
    Orb.CanQuery = false
    Orb.CanTouch = false
    Orb.CastShadow = false
    Orb.Anchored = true
    Orb.Parent = Workspace

    table.insert(Orbiters, {
      Part = Orb,
      Angle = (math.pi * 2 / 14) * i,
      Height = math.random(-100, 100) / 100,
      Speed = math.random(8, 15) / 10,
      Distance = math.random(13, 20) / 10
    })
  end

  --------------------------------------------------
  --// Energy Streaks
  --------------------------------------------------

  local Streaks = {}

  for i = 1, 10 do
    local Streak = Instance.new("Part")

    Streak.Material = Enum.Material.Neon
    Streak.Shape = Enum.PartType.Cylinder
    Streak.Size = Vector3.new(0.08, 1, 0.08)

    Streak.Color = Color3.fromRGB(
      math.random(80, 160),
      math.random(200, 255),
      255
    )

    Streak.Transparency = 0.15

    Streak.CanCollide = false
    Streak.CanQuery = false
    Streak.CanTouch = false
    Streak.CastShadow = false
    Streak.Anchored = true
    Streak.Parent = Workspace

    table.insert(Streaks, {
      Part = Streak,
      Angle = math.random() * math.pi * 2,
      Speed = math.random(1, 3),
      Length = math.random(3, 8) / 10
    })
  end

  --------------------------------------------------
  --// State
  --------------------------------------------------

  local LastSize = Genkidama.Size
  local Time = 0

  local Connection

  --------------------------------------------------
  --// Heartbeat
  --------------------------------------------------

  Connection = RunService.Heartbeat:Connect(function(dt)

    if not Genkidama.Parent then
      Connection:Disconnect()

      for _, Energy in ipairs(EnergyBalls) do
        if Energy.Part then
          Energy.Part:Destroy()
        end
      end

      for _, Orb in ipairs(Orbiters) do
        Orb.Part:Destroy()
      end

      for _, Streak in ipairs(Streaks) do
        Streak.Part:Destroy()
      end

      Core:Destroy()
      OuterAura:Destroy()

      table.clear(EnergyBalls)
      table.clear(Orbiters)
      table.clear(Streaks)

      return
    end

    Time += dt

    local Size = Genkidama.Size

    local Radius = math.max(
      Size.X,
      Size.Y,
      Size.Z
    ) / 2

    --------------------------------------------------
    --// Detect Size Change
    --------------------------------------------------

    local Grew =
      Size.X > LastSize.X
      or Size.Y > LastSize.Y
      or Size.Z > LastSize.Z

    if Grew and #EnergyBalls < MaxEnergyBalls then

      local Amount = math.clamp(
        math.floor(
          (Size.Magnitude - LastSize.Magnitude) * 2
        ),
        1,
        8
      )

      for _ = 1, Amount do

        if #EnergyBalls >= MaxEnergyBalls then
          break
        end

        local Energy = Instance.new("Part")

        Energy.Shape = Enum.PartType.Ball
        Energy.Material = Enum.Material.Neon

        local EnergySize = math.random(25, 70) / 100

        Energy.Size = Vector3.new(
          EnergySize,
          EnergySize,
          EnergySize
        )

        Energy.Color = Color3.fromRGB(
          math.random(60, 140),
          math.random(190, 255),
          255
        )

        Energy.CanCollide = false
        Energy.CanQuery = false
        Energy.CanTouch = false
        Energy.CastShadow = false
        Energy.Anchored = true

        Energy.Parent = Workspace

        --------------------------------------------------
        --// Trail
        --------------------------------------------------

        local Attachment0 = Instance.new("Attachment")
        Attachment0.Position = Vector3.new(0, 0, -EnergySize / 2)
        Attachment0.Parent = Energy

        local Attachment1 = Instance.new("Attachment")
        Attachment1.Position = Vector3.new(0, 0, EnergySize / 2)
        Attachment1.Parent = Energy

        local Trail = Instance.new("Trail")

        Trail.Attachment0 = Attachment0
        Trail.Attachment1 = Attachment1

        Trail.Lifetime = 0.18
        Trail.MinLength = 0
        Trail.LightEmission = 1

        Trail.Color = ColorSequence.new({
          ColorSequenceKeypoint.new(
            0,
            Color3.fromRGB(255, 255, 255)
          ),

          ColorSequenceKeypoint.new(
            0.35,
            Color3.fromRGB(80, 220, 255)
          ),

          ColorSequenceKeypoint.new(
            1,
            Color3.fromRGB(0, 100, 255)
          )
        })

        Trail.Transparency = NumberSequence.new({
          NumberSequenceKeypoint.new(0, 0),
          NumberSequenceKeypoint.new(1, 1)
        })

        Trail.Parent = Energy

        --------------------------------------------------
        --// Spawn Around Genkidama
        --------------------------------------------------

        local Direction = Vector3.new(
          math.random(-100, 100),
          math.random(-100, 100),
          math.random(-100, 100)
        ).Unit

        local Distance = Radius + math.random(15, 30)

        local StartPosition =
          Genkidama.Position
          + Direction * Distance

        Energy.Position = StartPosition

        table.insert(EnergyBalls, {
          Part = Energy,

          Direction = Direction,

          Speed = math.random(18, 32),

          Distance = Distance,

          Life = 0,

          Curve = math.random() * math.pi * 2,

          CurveSpeed = math.random(3, 7)
        })
      end
    end

    LastSize = Size

    --------------------------------------------------
    --// Main Sphere Pulse
    --------------------------------------------------

    local Pulse =
      1 + math.sin(Time * 5) * 0.035

    Genkidama.CFrame =
      Genkidama.CFrame

    Core.CFrame =
      Genkidama.CFrame

    OuterAura.CFrame =
      Genkidama.CFrame

    Core.Size = Vector3.new(
      Size.X * 0.72,
      Size.Y * 0.72,
      Size.Z * 0.72
    ) * Pulse

    OuterAura.Size = Vector3.new(
      Size.X * 1.12,
      Size.Y * 1.12,
      Size.Z * 1.12
    ) * Pulse

    --------------------------------------------------
    --// Lighting
    --------------------------------------------------

    Light.Brightness =
      math.clamp(Radius * 0.9, 0, 18)

    Light.Range =
      math.clamp(Radius * 4, 0, 70)

    CoreLight.Brightness =
      math.clamp(Radius * 1.5, 0, 25)

    CoreLight.Range =
      math.clamp(Radius * 3, 0, 50)

    --------------------------------------------------
    --// Orbiting Energy
    --------------------------------------------------

    for _, Orb in ipairs(Orbiters) do

      Orb.Angle +=
        Orb.Speed * dt

      local OrbRadius =
        Radius + Orb.Distance

      local X =
        math.cos(Orb.Angle) *
        OrbRadius

      local Z =
        math.sin(Orb.Angle) *
        OrbRadius

      local Y =
        math.sin(
          Orb.Angle * 2
          + Orb.Height
        ) * (OrbRadius * 0.35)

      Orb.Part.Position =
        Genkidama.Position
        + Vector3.new(X, Y, Z)

      local OrbPulse =
        1 + math.sin(
          Time * 8
          + Orb.Angle
        ) * 0.25

      Orb.Part.Size *=
        1 + ((OrbPulse - 1) * dt * 8)
    end

    --------------------------------------------------
    --// Energy Streaks
    --------------------------------------------------

    for _, Streak in ipairs(Streaks) do

      Streak.Angle +=
        Streak.Speed * dt

      local Direction = Vector3.new(
        math.cos(Streak.Angle),
        math.sin(
          Streak.Angle * 2
          + Time
        ) * 0.5,
        math.sin(Streak.Angle)
      ).Unit

      local Distance =
        Radius + 1.5

      local Position =
        Genkidama.Position
        + Direction * Distance

      Streak.Part.CFrame =
        CFrame.lookAt(
          Position,
          Position + Direction
        )
        * CFrame.Angles(
          math.rad(90),
          0,
          0
        )

      Streak.Part.Size =
        Vector3.new(
          0.08,
          Streak.Length *
            (1 + math.sin(Time * 10) * 0.5),
          0.08
        )
    end

    --------------------------------------------------
    --// Absorbing Energy
    --------------------------------------------------

    for i = #EnergyBalls, 1, -1 do

      local Energy = EnergyBalls[i]
      local Part = Energy.Part

      if not Part or not Part.Parent then
        table.remove(EnergyBalls, i)
        continue
      end

      Energy.Life += dt

      local Target =
        Genkidama.Position

      local Distance =
        (Part.Position - Target).Magnitude

      --------------------------------------------------
      --// Curve
      --------------------------------------------------

      local Curve =
        Vector3.new(
          math.cos(
            Energy.Life *
            Energy.CurveSpeed +
            Energy.Curve
          ),

          math.sin(
            Energy.Life *
            (Energy.CurveSpeed * 0.7) +
            Energy.Curve
          ),

          math.sin(
            Energy.Life *
            Energy.CurveSpeed +
            Energy.Curve
          )
        )

      local CurveStrength =
        math.clamp(
          Distance / 20,
          0,
          1
        ) * 3

      local Direction =
        (
          Target
          + Curve * CurveStrength
          - Part.Position
        ).Unit

      --------------------------------------------------
      --// Accelerate Near The Genkidama
      --------------------------------------------------

      local SpeedMultiplier =
        1 + math.clamp(
          (1 - Distance / (Radius + 25)),
          0,
          1
        ) * 2.5

      Part.Position +=
        Direction
        * Energy.Speed
        * SpeedMultiplier
        * dt

      --------------------------------------------------
      --// Spin
      --------------------------------------------------

      Part.CFrame *=
        CFrame.Angles(
          dt * 8,
          dt * 10,
          dt * 6
        )

      --------------------------------------------------
      --// Absorbed
      --------------------------------------------------

      if Distance <= math.max(Radius * 0.8, 1) then

        Part:Destroy()

        table.remove(
          EnergyBalls,
          i
        )
      end
    end
  end)

  return Genkidama, Light, Aura
end

local function Genkidama()
  if Habilities.States.IsUsingHability then return end
  Habilities.States.IsUsingHability = true
  
  local RootPart = GetRootPart(Client)
  local Humanoid = GetHumanoid(Client)
  local Camera = Workspace.CurrentCamera
  if RootPart and Humanoid and Camera then
    local Track = PlayAnimation(Humanoid,Habilities.Animations.Genkidama,1,0,true,false,Enum.AnimationPriority.Action4)
    local Genkidama,Light,Aura = CreateGenkidama()
    
    local LookAtConnection
    LookAtConnection = RunService.Heartbeat:Connect(function()
      if RootPart and Camera and not Fly.States.IsFlying then
        RootPart.CFrame = CFrame.lookAt(RootPart.Position,RootPart.Position + Vector3.new(Camera.CFrame.LookVector.X,0,Camera.CFrame.LookVector.Z))
      end
    end)
    
    local Connection
    Connection = RunService.Heartbeat:Connect(function()
      if not Genkidama then
        Connection:Disconnect()
        Connection = nil
        return
      end
      if not RootPart then
        Connection:Disconnect()
        Connection = nil
        return
      end
      
      local X = math.clamp(Genkidama.Size.X + 0.1,0,100)
      local Y = math.clamp(Genkidama.Size.Y + 0.1,0,100)
      local Z = math.clamp(Genkidama.Size.Z + 0.1,0,100)
      
      Genkidama.Size = Vector3.new(X,Y,Z)
      Genkidama.CFrame = RootPart.CFrame * CFrame.new(0,10 + Y / 2,0)
      Genkidama.Transparency = Genkidama.Transparency - 0.01
    end)
    repeat task.wait() until Genkidama.Size.Y > 90
    if Connection then
      Connection:Disconnect()
      Connection = nil
    end
    if Humanoid and Camera then
      if Track then
        Track:Stop()
        Track = nil
      end
      
      local CurrentLerp = 0
      local Track = PlayAnimation(Humanoid,Habilities.Animations.Genkidama,1,0,false,false,Enum.AnimationPriority.Action4)
      Track.Ended:Wait()
      if Track then
        Track:Stop()
        Track = nil
      end
      --Last Animation
      if RootPart then
        RootPart.Anchored = true
        LookAtConnection:Disconnect()
        LookAtConnection = nil
      end
      local Track = PlayAnimation(Humanoid,Habilities.Animations.Genkidama,1,2,true,false,Enum.AnimationPriority.Action4)
      local StartCFrame = Genkidama.CFrame
      local TargetCFrame = Genkidama.CFrame + Camera.CFrame.LookVector.Unit * 200
      local AlreadyHit = {}
      local TouchedPlayers = 0
      local Connection
      Connection = RunService.Heartbeat:Connect(function()
        if not Genkidama then
          Connection:Disconnect()
          Connection = nil
        end
        
        local Speed = TouchedPlayers > 0 and 0.01 / TouchedPlayers * 2 or 0.01
        CurrentLerp = CurrentLerp + 0.01 
        Genkidama.CFrame = StartCFrame:Lerp(TargetCFrame,CurrentLerp)
        
        if (Genkidama.CFrame.Position - TargetCFrame.Position).Magnitude <= 10 then
          Connection:Disconnect()
          Connection = nil
        end
        
      end)
    local HitConnection
    HitConnection = RunService.Heartbeat:Connect(function()
      if not Genkidama then
        HitConnection:Disconnect()
        HitConnection = nil
        return
      end
      
      local PartsBoundInBox = Workspace:GetPartBoundsInBox(Genkidama.CFrame,Genkidama.Size)
      for i,Part in ipairs(PartsBoundInBox) do
        local Player = ItsAPlayerInstance(Part)
        if Player and Player ~= Client then
          if not AlreadyHit[Player] then
            AlreadyHit[Player] = true
            TouchedPlayers = TouchedPlayers + 1
            local Character = Player.Character
            if Character then
              for i,Instance in ipairs(Character:GetDescendants()) do
                if Instance:IsA("BasePart") and Instance.Name ~= "HumanoidRootPart" then
                  Instance.Transparency = 1
                end
              end
            end
            
          end
        end
      end
    end)
      task.wait(5)
      if Connection then
        Connection:Disconnect()
        Connection = nil
      end
      local Connection
      Connection = RunService.Heartbeat:Connect(function()
        if not Genkidama then
          Connection:Disconnect()
        Connection = nil
        return
        end
        
        local X = Genkidama.Size.X - 8
        local Y = Genkidama.Size.Y - 8
        local Z = Genkidama.Size.Z - 8
        
        Genkidama.Size = Vector3.new(X,Y,Z)
        Genkidama.Transparency = Genkidama.Transparency - 0.01
      end)
      repeat task.wait() until Genkidama.Size.Y < 1
      Genkidama:Destroy()
      if HitConnection then
      HitConnection:Disconnect()
      HitConnection = nil
      end
      if RootPart then
        RootPart.Anchored = false
      end
      if Track then
        Track:Stop()
        Track = nil
      end
      
      for Player,_ in pairs(AlreadyHit) do
    if RootPart then
      Fling(Player,RootPart.CFrame.LookVector)
    end
    local Character = Player.Character
    if Character then
      for _,Part in ipairs(Character:GetDescendants()) do
        if Part:IsA("BasePart") and Part.Name ~= "HumanoidRootPart" then
          Part.Transparency = 0
        end
      end
    end
      end

    end
  end
  Habilities.States.IsUsingHability = false
end

local function Teleport(Player)
  if not Player then return end
  
  local PlayerRootPart = GetRootPart(Player)
  local RootPart = GetRootPart(Client)
  local Humanoid = GetHumanoid(Client)
  if PlayerRootPart and RootPart and Humanoid then
    local Track = PlayAnimation(Humanoid,Habilities.Animations.Teleport,1,0,false,false,Enum.AnimationPriority.Action4)
    task.wait(0.1)
    RootPart.CFrame = PlayerRootPart.CFrame * CFrame.new(0,0,-2) * CFrame.Angles(0,math.rad(180),0)
    task.wait(0.1)
    if Track then
      Track:Stop()
      Track = nil
    end
  end
end

local function Dodge()
  local OldCollisions = {}
  local Track
  local Connection
  Connection = RunService.Heartbeat:Connect(function()
    local RootPart = GetRootPart(Client)
    local Humanoid = GetHumanoid(Client)
    if RootPart and Humanoid then
      
      if not Habilities.States.UltraInstinct then
        for i,Instance in ipairs(Client.Character:GetDescendants()) do
                if not Instance:IsA("BasePart") then continue end
                if OldCollisions[Instance.Name] == true or OldCollisions[Instance.Name] == false then
                  Instance.CanCollide = OldCollisions[Instance.Name]
                end
              end
              if Track then
                Track:Stop()
                Track = nil
              end
              Connection:Disconnect()
              Connection = nil
      end
      
      local PlayerWithVelocityFound = false
      
      for i,Player in ipairs(Players:GetPlayers()) do
        local PlayerRootPart = GetRootPart(Player)
        if PlayerRootPart then
          local Distance = (RootPart.Position - PlayerRootPart.Position).Magnitude
          local Velocity = PlayerRootPart.Velocity
          local AngularVel = PlayerRootPart.AssemblyAngularVelocity
          if Velocity.Magnitude > 300 or AngularVel.Magnitude > 300 then
            PlayerWithVelocityFound = true
            
            if Player and Player.Character then
              
            for i,Instance in ipairs(Player.Character:GetDescendants()) do
              if Instance:IsA("BasePart") then
                Instance.CanCollide = false
              end
            end
            
            end
            
            if Distance <= 5 then
              if not Track then
                Track = PlayAnimation(Humanoid,Habilities.Animations.Dodge,4,0,false,true,Enum.AnimationPriority.Action4)
              end
            elseif Distance > 5 then
              if Track then
                Track:Stop()
                Track = nil
              end
            end
          end
        end
      end
      
      if PlayerWithVelocityFound then
        for i,Instance in ipairs(Client.Character:GetDescendants()) do
                if not Instance:IsA("BasePart") then continue end
                if OldCollisions[Instance.Name] ~= true and OldCollisions[Instance.Name] ~= false then
                  OldCollisions[Instance.Name] = Instance.CanCollide
                end
                Instance.CanCollide = false
        end
          else
            for i,Instance in ipairs(Client.Character:GetDescendants()) do
                if not Instance:IsA("BasePart") then continue end
                if OldCollisions[Instance.Name] == true or OldCollisions[Instance.Name] == false then
                  Instance.CanCollide = OldCollisions[Instance.Name]
                end
              end
              if Track then
                Track:Stop()
                Track = nil
              end
      end
      
    end
  end)
end

local function CreateCosmicAura(Character, State)

    Character = Character or Client.Character

    Client:SetAttribute(
        "CosmicAura",
        State
    )

    --------------------------------------------------
    --// REMOVE PREVIOUS AURA
    --------------------------------------------------

    local OldAura =
        workspace:FindFirstChild("CosmicAura")

    if OldAura then
        OldAura:Destroy()
    end

    if Character then

        local OldHighlight =
            Character:FindFirstChild("CosmicHighlight")

        if OldHighlight then
            OldHighlight:Destroy()
        end

        local OldRootPart =
            Character:FindFirstChild(
                "HumanoidRootPart"
            )

        if OldRootPart then

            local OldLight =
                OldRootPart:FindFirstChild(
                    "CosmicLight"
                )

            if OldLight then
                OldLight:Destroy()
            end

        end

    end

    --------------------------------------------------
    --// DISABLED
    --------------------------------------------------

    if not State then
        return
    end

    --------------------------------------------------
    --// COLORS
    --------------------------------------------------

    local White =
        Color3.fromRGB(
            255,
            255,
            255
        )

    local Colors = {

        Color3.fromRGB(
            255,
            255,
            255
        ),

        Color3.fromRGB(
            120,
            180,
            255
        ),

        Color3.fromRGB(
            180,
            100,
            255
        ),

        Color3.fromRGB(
            255,
            100,
            180
        ),

        Color3.fromRGB(
            80,
            255,
            220
        ),

        Color3.fromRGB(
            255,
            180,
            70
        ),

        Color3.fromRGB(
            100,
            120,
            255
        )

    }

    local FlashColors = {

        Color3.fromRGB(
            255,
            40,
            40
        ),

        Color3.fromRGB(
            255,
            120,
            30
        ),

        Color3.fromRGB(
            50,
            120,
            255
        ),

        Color3.fromRGB(
            50,
            255,
            100
        ),

        Color3.fromRGB(
            190,
            50,
            255
        ),

        Color3.fromRGB(
            255,
            50,
            190
        ),

        Color3.fromRGB(
            255,
            255,
            50
        )

    }

    --------------------------------------------------
    --// AURA FOLDER
    --------------------------------------------------

    local Aura =
        Instance.new("Folder")

    Aura.Name =
        "CosmicAura"

    Aura.Parent =
        workspace

    --------------------------------------------------
    --// OBJECTS
    --------------------------------------------------

    local Objects = {}

    --------------------------------------------------
    --// CREATE ORB
    --------------------------------------------------

    local function CreateOrb(
        Name,
        Size,
        Color,
        Transparency
    )

        local Orb =
            Instance.new("Part")

        Orb.Name =
            Name

        Orb.Shape =
            Enum.PartType.Ball

        Orb.Size =
            Vector3.new(
                Size,
                Size,
                Size
            )

        Orb.Color =
            Color

        Orb.Material =
            Enum.Material.Neon

        Orb.Anchored =
            true

        Orb.CanCollide =
            false

        Orb.CanTouch =
            false

        Orb.CanQuery =
            false

        Orb.CastShadow =
            false

        Orb.Transparency =
            Transparency

        Orb.Parent =
            Aura

        table.insert(
            Objects,
            Orb
        )

        return Orb

    end

    --------------------------------------------------
    --// SMALL COSMIC PARTICLES
    --------------------------------------------------

    local Particles = {}

    for i = 1, 80 do

        local Size =
            math.random(
                5,
                35
            ) / 100

        local Orb =
            CreateOrb(

                "CosmicOrb_" .. i,

                Size,

                Colors[
                    math.random(
                        1,
                        #Colors
                    )
                ],

                math.random(
                    5,
                    45
                ) / 100

            )

        Particles[i] = {

            Part = Orb,

            Angle =
                math.random()
                * math.pi
                * 2,

            Radius =
                math.random(
                    12,
                    45
                ) / 10,

            Height =
                math.random(
                    -35,
                    40
                ) / 10,

            Speed =
                math.random(
                    3,
                    15
                ) / 10,

            VerticalSpeed =
                math.random(
                    5,
                    20
                ) / 10,

            Offset =
                math.random()
                * 100,

            BaseSize =
                Size

        }

    end

    --------------------------------------------------
    --// BIG COSMIC PARTICLES
    --------------------------------------------------

    local BigParticles = {}

    for i = 1, 15 do

        local Size =
            math.random(
                35,
                80
            ) / 100

        local Orb =
            CreateOrb(

                "BigCosmicOrb_" .. i,

                Size,

                Colors[
                    math.random(
                        1,
                        #Colors
                    )
                ],

                0.1

            )

        BigParticles[i] = {

            Part = Orb,

            Angle =
                math.random()
                * math.pi
                * 2,

            Radius =
                math.random(
                    25,
                    50
                ) / 10,

            Height =
                math.random(
                    -30,
                    35
                ) / 10,

            Speed =
                math.random(
                    2,
                    7
                ) / 10,

            Offset =
                math.random()
                * 100,

            BaseSize =
                Size

        }

    end

    --------------------------------------------------
    --// CHARACTER EFFECTS
    --------------------------------------------------

    local Highlight

    local Light

    local RootPart =
        Character
        and Character:FindFirstChild(
            "HumanoidRootPart"
        )

    --------------------------------------------------
    --// CREATE HIGHLIGHT
    --------------------------------------------------

    local function CreateHighlight()

        if not Character then
            return
        end

        if Highlight
            and Highlight.Parent then

            return

        end

        Highlight =
            Instance.new("Highlight")

        Highlight.Name =
            "CosmicHighlight"

        Highlight.FillColor =
            White

        Highlight.OutlineColor =
            White

        Highlight.FillTransparency =
            0.8

        Highlight.OutlineTransparency =
            0.1

        Highlight.DepthMode =
            Enum.HighlightDepthMode.Occluded

        Highlight.Parent =
            Character

    end

    --------------------------------------------------
    --// CREATE LIGHT
    --------------------------------------------------

    local function CreateLight()

        if not RootPart then
            return
        end

        if Light
            and Light.Parent then

            return

        end

        Light =
            Instance.new("PointLight")

        Light.Name =
            "CosmicLight"

        Light.Color =
            White

        Light.Brightness =
            0.5

        Light.Range =
            8

        Light.Shadows =
            false

        Light.Parent =
            RootPart

    end

    --------------------------------------------------
    --// INITIAL EFFECTS
    --------------------------------------------------

    CreateHighlight()

    CreateLight()

    --------------------------------------------------
    --// FLASH STATE
    --------------------------------------------------

    local NextFlash =
        math.random(
            20,
            50
        ) / 10

    local Flashing =
        false

    local FlashTime =
        0

    local FlashColor

    --------------------------------------------------
    --// STATE
    --------------------------------------------------

    local Time =
        0

    local CurrentCharacter =
        Character

    local Connection

    --------------------------------------------------
    --// HEARTBEAT
    --------------------------------------------------

    Connection =
        RunService.Heartbeat:Connect(
            function(Delta)

                --------------------------------------------------
                --// ATTRIBUTE OFF
                --------------------------------------------------

                if not Client:GetAttribute(
                    "CosmicAura"
                ) then

                    if Aura.Parent then
                        Aura:Destroy()
                    end

                    return

                end

                --------------------------------------------------
                --// GET CURRENT CHARACTER
                --------------------------------------------------

                local NewCharacter =
                    Client.Character

                if not NewCharacter then
                    return
                end

                --------------------------------------------------
                --// CHARACTER CHANGED
                --------------------------------------------------

                if NewCharacter
                    ~= CurrentCharacter then

                    --------------------------------------------------
                    --// REMOVE OLD EFFECTS
                    --------------------------------------------------

                    if Highlight
                        and Highlight.Parent then

                        Highlight:Destroy()

                    end

                    if Light
                        and Light.Parent then

                        Light:Destroy()

                    end

                    Highlight =
                        nil

                    Light =
                        nil

                    RootPart =
                        nil

                    --------------------------------------------------
                    --// UPDATE CHARACTER
                    --------------------------------------------------

                    CurrentCharacter =
                        NewCharacter

                    Character =
                        NewCharacter

                end

                --------------------------------------------------
                --// FIND ROOT PART
                --------------------------------------------------

                if not RootPart
                    or not RootPart.Parent then

                    RootPart =
                        Character:FindFirstChild(
                            "HumanoidRootPart"
                        )

                end

                --------------------------------------------------
                --// CHARACTER STILL LOADING
                --------------------------------------------------

                if not RootPart then
                    return
                end

                --------------------------------------------------
                --// CREATE MISSING EFFECTS
                --------------------------------------------------

                CreateHighlight()

                CreateLight()

                --------------------------------------------------
                --// INVALID EFFECTS
                --------------------------------------------------

                if not Highlight
                    or not Highlight.Parent then

                    return

                end

                if not Light
                    or not Light.Parent then

                    return

                end

                --------------------------------------------------
                --// TIME
                --------------------------------------------------

                Time += Delta

                --------------------------------------------------
                --// SMALL PARTICLES
                --------------------------------------------------

                for _, Data
                    in ipairs(Particles) do

                    if Data.Part
                        and Data.Part.Parent then

                        local Angle =
                            Data.Angle
                            + Time
                            * Data.Speed

                        local ChaosX =
                            math.sin(
                                Time * 2.3
                                + Data.Offset
                            )

                        local ChaosY =
                            math.sin(
                                Time
                                * Data.VerticalSpeed
                                + Data.Offset
                            )

                        local ChaosZ =
                            math.cos(
                                Time * 1.7
                                + Data.Offset
                            )

                        local Radius =
                            Data.Radius
                            + ChaosX * 0.5

                        local Position =
                            RootPart.CFrame:PointToWorldSpace(

                                Vector3.new(

                                    math.cos(
                                        Angle
                                    )
                                    * Radius
                                    + ChaosX * 0.35,

                                    Data.Height
                                    + ChaosY * 0.7,

                                    math.sin(
                                        Angle
                                    )
                                    * Radius
                                    + ChaosZ * 0.35

                                )

                            )

                        Data.Part.CFrame =
                            CFrame.new(
                                Position
                            )

                        --------------------------------------------------
                        --// PULSE
                        --------------------------------------------------

                        local Pulse =
                            (
                                math.sin(
                                    Time * 5
                                    + Data.Offset
                                )
                                + 1
                            ) / 2

                        local Size =
                            Data.BaseSize
                            * (
                                0.5
                                + Pulse * 0.9
                            )

                        Data.Part.Size =
                            Vector3.new(
                                Size,
                                Size,
                                Size
                            )

                    end

                end

                --------------------------------------------------
                --// BIG PARTICLES
                --------------------------------------------------

                for _, Data
                    in ipairs(BigParticles) do

                    if Data.Part
                        and Data.Part.Parent then

                        local Angle =
                            Data.Angle
                            + Time
                            * Data.Speed

                        local Chaos =
                            math.sin(
                                Time * 1.8
                                + Data.Offset
                            )

                        local Radius =
                            Data.Radius
                            + Chaos * 0.7

                        local Position =
                            RootPart.CFrame:PointToWorldSpace(

                                Vector3.new(

                                    math.cos(
                                        Angle
                                    )
                                    * Radius,

                                    Data.Height
                                    + math.sin(
                                        Time * 1.5
                                        + Data.Offset
                                    ) * 0.8,

                                    math.sin(
                                        Angle
                                    )
                                    * Radius

                                )

                            )

                        Data.Part.CFrame =
                            CFrame.new(
                                Position
                            )

                        --------------------------------------------------
                        --// PULSE
                        --------------------------------------------------

                        local Pulse =
                            (
                                math.sin(
                                    Time * 3
                                    + Data.Offset
                                )
                                + 1
                            ) / 2

                        local Size =
                            Data.BaseSize
                            * (
                                0.75
                                + Pulse * 0.45
                            )

                        Data.Part.Size =
                            Vector3.new(
                                Size,
                                Size,
                                Size
                            )

                    end

                end

                --------------------------------------------------
                --// LIGHT PULSE
                --------------------------------------------------

                local LightPulse =
                    (
                        math.sin(
                            Time * 4
                        )
                        + 1
                    ) / 2

                Light.Brightness =
                    0.35
                    + LightPulse * 0.65

                Light.Range =
                    7
                    + LightPulse * 3

                --------------------------------------------------
                --// RANDOM COLOR FLASH
                --------------------------------------------------

                if not Flashing then

                    NextFlash -= Delta

                    if NextFlash <= 0 then

                        Flashing =
                            true

                        FlashTime =
                            0

                        FlashColor =
                            FlashColors[
                                math.random(
                                    1,
                                    #FlashColors
                                )
                            ]

                    end

                else

                    FlashTime += Delta

                    --------------------------------------------------
                    --// FLASH DURATION
                    --------------------------------------------------

                    local Alpha =
                        math.clamp(
                            FlashTime / 0.2,
                            0,
                            1
                        )

                    local CurrentColor =
                        FlashColor:Lerp(
                            White,
                            Alpha
                        )

                    Highlight.FillColor =
                        CurrentColor

                    Highlight.OutlineColor =
                        CurrentColor

                    Light.Color =
                        CurrentColor

                    --------------------------------------------------
                    --// FLASH END
                    --------------------------------------------------

                    if FlashTime >= 0.2 then

                        Flashing =
                            false

                        NextFlash =
                            math.random(
                                20,
                                50
                            ) / 10

                        Highlight.FillColor =
                            White

                        Highlight.OutlineColor =
                            White

                        Light.Color =
                            White

                    end

                end

            end
        )

    --------------------------------------------------
    --// CLEANUP
    --------------------------------------------------

    Aura.Destroying:Connect(
        function()

            --------------------------------------------------
            --// DISCONNECT
            --------------------------------------------------

            if Connection then

                Connection:Disconnect()

                Connection =
                    nil

            end

            --------------------------------------------------
            --// REMOVE LIGHT
            --------------------------------------------------

            if Light
                and Light.Parent then

                Light:Destroy()

            end

            --------------------------------------------------
            --// REMOVE HIGHLIGHT
            --------------------------------------------------

            if Highlight
                and Highlight.Parent then

                Highlight:Destroy()

            end

            --------------------------------------------------
            --// REMOVE PARTICLES
            --------------------------------------------------

            for _, Object
                in ipairs(Objects) do

                if Object
                    and Object.Parent then

                    Object:Destroy()

                end

            end

        end
    )

    return Aura

end

local function UltraInstinct(State)
  local Character = Client.Character
  CreateCosmicAura(Character,State)
  if State then
    Dodge()
  end
end

--//Interface

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/pruebasjoao/test/refs/heads/main/JmodsLibV1.0"))()

local Window = Library:CreateWindow({
  Name = "Fe Goku | NyxMods",
  Icon = 86507528059862,
  LoadingTitle = "Cargando... espera...",
  LoadingSubtitle = "ya casi está",
  Theme = "neon_indigo",
  OpenButtomImage = 86507528059862,
  Intro = false,
  IntroIcon = 86507528059862,
  AnimationIntro = 3,
  DragImage = 86507528059862
})

local Main = Window:CreateTab("Main")
local Options = Main:CreateSection("Options")

Main:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Callback = function(State)
      Fly.States.IsFlying = State
        if State then
          InitFly()
        else
          StopFly()
        end
    end
})

Main:CreateSlider({
    Name = "Max Speed",
    Range = {1, 1000},
    Increment = 1,
    Suffix = "studs/s",
    CurrentValue = 200,
    Callback = function(Value)
        Fly.States.MaxSpeed = Value
    end
})

Main:CreateSlider({
    Name = "Aceleration",
    Range = {1, 1000},
    Increment = 1,
    Suffix = "studs/s",
    CurrentValue = 60,
    Callback = function(Value)
        Fly.States.Aceleration = Value
    end
})

Main:CreateSlider({
    Name = "Vertical Speed",
    Range = {1, 1000},
    Increment = 1,
    Suffix = "studs/s",
    CurrentValue = 100,
    Callback = function(Value)
        Fly.States.VerticalSpeed = Value
    end
})

Main:CreateButton({
    Name = "Up",
    Callback = function()
        Fly.States.Up = true
    end
})

Main:CreateButton({
    Name = "Down",
    Callback = function()
        Fly.States.Down = true
    end
})

Main:CreateButton({
    Name = "Landed",
    Callback = function()
        Fly.States.Landed = true
    end
})

Main:CreateButton({
    Name = "Stop Vertical",
    Callback = function()
        Fly.States.Up = false
        Fly.States.Down = false
        Fly.States.Landed = false
    end
})

Main:CreateButton({
    Name = "Fling Closest",
    Callback = function()
        Fling(GetClosestPlayer())
    end
})

Main:CreateButton({
    Name = "Big Punch",
    Callback = function()
        BigPunch()
    end
})

Main:CreateButton({
    Name = "Fast Punchs",
    Callback = function()
        FastPunchs()
    end
})

Main:CreateButton({
    Name = "Kamehameha",
    Callback = function()
        Kamehameha()
    end
})

Main:CreateButton({
    Name = "Genkidama",
    Callback = function()
        Genkidama()
    end
})

Main:CreateButton({
    Name = "Tp",
    Callback = function()
        Teleport(GetClosestPlayer())
    end
})

Main:CreateToggle({
    Name = "Dodge",
    CurrentValue = false,
    Callback = function(State)
      Habilities.States.UltraInstinct = State
        if State then
          Dodge()
        end
    end
})

Main:CreateToggle({
    Name = "Ultra Instinct",
    CurrentValue = false,
    Callback = function(State)
      Habilities.States.UltraInstinct = State
      UltraInstinct(State)
    end
})