--//Variables
local NyxModsUniversal = getgenv().NyxModsUniversal
local Window = NyxModsUniversal.Window
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Client = Players.LocalPlayer

local Config = {
  Target = nil,
  TargetCharacterAdded = nil,
  Fling = {
    FlingInProgress = false,
    FlingPower = 14000,
    StopFling = false,
    
    FlingMode = "Normal",
  },
  PunchFling = {
    Enabled = false,
    Clicked = false,

    PunchAnimation = "139643944264511",

    FlingInProgress = nil,
    FlingPower = 14000,
  },
  Spectate = {
    Enabled = false,
  },
  Bang = {
    Enabled = false,
    Speed = 0.5,
    BangAnimation = {
      Id = 86711105179267,
      TimePosition = 0.2,
      Pause = true,
      Speed = 0,
      Looped = true
    }
  },
  FaceBang = {
    Enabled = false,
    Speed = 0.5,
    FaceBangAnimation = {
      Id = 86711105179267,
      TimePosition = 0.2,
      Pause = true,
      Speed = 0,
      Looped = true
    }
  },
  Suck = {
    Enabled = false,
    Speed = 0.5,
    SuckAnimation = {
      Id = 123822744060080,
      TimePosition = 0.5,
      Pause = true,
      Speed = 0,
      Looped = true
    }
  },
  GetBang = {
    Enabled = false,
    Speed = 0.5,
    GetBangAnimation = {
      Id = 80401449796551,
      TimePosition = 0,
      Pause = false,
      Speed = 1,
      Looped = true
    }
  },
  Orbit = {
    Enabled = false,
    Speed = 10,
    Radius = 10,
    Irregular = false
  },
  Invisible = {
    Enabled = false,
    FloatingButton = false,

    HumanoidHealthChanged = nil,
    VoidRunService = nil,
  },
  PlayerLift = {
    Enabled = false,
    Height = 0,
  }
}

--//Functions
local function GetPlayersNamesList(ExcludeClient)
  local List = {}
  for i,Player in ipairs(Players:GetPlayers()) do
    if ExcludeClient and Player == Client then continue end
    table.insert(List,Player.Name.." ("..Player.DisplayName..")")
  end
  return List
end

local function GetPlayerByPartialName(Text)
  local Name = Text and Text:lower()
  for i,v in ipairs(Players:GetPlayers()) do
    if v.Name:lower():sub(1,#Name) == Name or v.DisplayName:lower():sub(1,#Name) == Name then
      return v
    end
  end
end

local function GetClosestPlayer()
  local ClosestPlayer = nil
  local MaxDistance = math.huge

  local Character = Client.Character
  if Character then
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart then
      for i,Player in ipairs(Players:GetPlayers()) do
        local Char = Player.Character
        if Char then
          local RootPart = Char:FindFirstChild("HumanoidRootPart")
          if RootPart then
            local Distance = (HumanoidRootPart.Position - RootPart.Position).Magnitude
            if Distance < MaxDistance then
              MaxDistance = Distance
              ClosestPlayer = Player
            end
          end
        end
      end
    end
  end
  return ClosestPlayer
end

local function GetHumanoidRootPart(Player)
  local Character = Player.Character
  if Character then
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart then
      return HumanoidRootPart
    end
  end
end

local function GetHumanoid(Player)
  local Character = Player.Character
  if Character then
    local Humanoid = Character:FindFirstChild("Humanoid")
    if Humanoid then
      return Humanoid
    end
  end
end

local function ItsPlayingAnimation(Player,Id)
  local Humanoid = GetHumanoid(Player)
  if Humanoid then
    for _,Track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
      local Animation = Track and Track.Animation
      if Animation then
        if Animation.AnimationId == Id or Animation.AnimationId == "rbxassetid://"..Id then
          return true
        end
      end
    end
    return nil
  end
  return nil
end

local function PlayAnimation(Id,Pause,Time,Speed,Looped)
  local Humanoid = GetHumanoid(Client)
  if Humanoid then
    local Animator = Humanoid:FindFirstChild("Animator")
    if Animator then
      local Animation = Instance.new("Animation")
      Animation.AnimationId = "rbxassetid://"..Id

      local Track = Animator:LoadAnimation(Animation)
      Track.Priority = Enum.AnimationPriority.Action4
      Track:Play()

      Track:AdjustSpeed(Speed)
      Track.TimePosition = Time

      if Pause then
        Track.TimePosition = Time
        Track:AdjustSpeed(0)
      end

      if Looped then
        Track.Looped = true
      end

    elseif Humanoid then
      local Animation = Instance.new("Animation")
      Animation.AnimationId = "rbxassetid://"..Id

      local Track = Humanoid:LoadAnimation(Animation)
      Track:Play()

      Track:AdjustSpeed(Speed)
      Track.TimePosition = Time

      if Pause then
        Track.TimePosition = Time
        Track.AdjustSpeed(0)
      end
    end
  end
end

local function StopAnimation(Id)
  local Humanoid = GetHumanoid(Client)
  if Humanoid then
    for _,Track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
      local Animation = Track and Track.Animation
      if Animation then
        if Animation.AnimationId == Id or Animation.AnimationId == "rbxassetid://"..Id then
          Track:Stop()
        end
      end
    end
    return nil
  end
  return nil
end

local function TeleportToPlayer(Player)
  local TargetHumanoidRootPart = GetHumanoidRootPart(Player)
  local HumanoidRootPart = GetHumanoidRootPart(Client)
  if TargetHumanoidRootPart and HumanoidRootPart then
    HumanoidRootPart.CFrame = TargetHumanoidRootPart.CFrame
  end
end

local function FlingPlayer(Target)
  if Config.Fling.FlingInProgress then
    Config.Fling.StopFling = true
    task.wait(0.1)
    Config.Fling.StopFling = false
  end

  local AlreadyFlinged = false
  local OldPosition = nil
  local i = 0
  task.spawn(function()
    Config.Fling.FlingInProgress = true
    while true do
      if Target then
        local TargetHumanoidRootPart = GetHumanoidRootPart(Target)
        local TargetHumanoid = GetHumanoid(Target)
        local HumanoidRootPart = GetHumanoidRootPart(Client)
        if TargetHumanoidRootPart and HumanoidRootPart then

          
          --// Save initial position
          if not OldPosition then
            OldPosition = HumanoidRootPart.CFrame
          end
          --// Stop fling
          if AlreadyFlinged or Config.Fling.StopFling or not Target or i >= 100 then
            if OldPosition then
              for i = 1,50,1 do
                HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
                HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0,0,0)
                RunService.Heartbeat:Wait()
                HumanoidRootPart.CFrame = OldPosition
                task.wait(0.01)
              end
            end
            Config.Fling.FlingInProgress = false
            break
          end

          if Target and TargetHumanoidRootPart and TargetHumanoidRootPart.Velocity.Magnitude >= 1000 then
            AlreadyFlinged = true
          end

          if not AlreadyFlinged and not Config.Fling.StopFling and Target and TargetHumanoidRootPart and HumanoidRootPart then
            local MoveVelocity = TargetHumanoidRootPart.AssemblyLinearVelocity

            HumanoidRootPart.CFrame = (TargetHumanoidRootPart.CFrame + MoveVelocity / 1.5) * CFrame.new(math.random(-5,5),math.random(-5,5),math.random(-5,5))
            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(math.rad(math.random(-360,360)),math.rad(math.random(-360,360)),math.rad(math.random(-360,360)))
            HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(9e7,9e7,9e7)
          end


        end
      end
      i = i + 1
      task.wait(0.01)
    end
  end)
end

local function ItsAPlayerInstance(Instance)
  if not Instance then return end
  
  for i,Player in ipairs(Players:GetPlayers()) do
    local Character = Player and Player.Character
    if Character then
      if Instance:IsDescendantOf(Character) then
        return true
      end
    end
  end
  return false
end

local function GetOwnershipParts()
    local Parts = {}
    
    for i,Instance in ipairs(Workspace:GetDescendants()) do
        if Instance:IsA("BasePart") then
          
          if sethiddenproperty then
            sethiddenproperty(Client,"SimulationRadius",50000)
            sethiddenproperty(Client,"MaxSimulationRadius",50000)
          end
            
            if not Instance then
                continue
            end
            
            if Instance.Anchored then
              continue
            end
            
           if ItsAPlayerInstance(Instance) then
             continue
           end
            
            if not isnetworkowner then
              continue
            end
            
            if not isnetworkowner(Instance) then
              continue
            end
            
            table.insert(Parts,Instance)
        end
    end
    return Parts
end

local function FlingPlayerWithParts(Target)
  local Parts = GetOwnershipParts()
  
  if Config.Fling.FlingInProgress then
    Config.Fling.StopFling = true
    task.wait(0.1)
    Config.Fling.StopFling = false
  end

  local AlreadyFlinged = false
  local OldPosition = nil
  local i = 0
  local t = 0
  task.spawn(function()
    Config.Fling.FlingInProgress = true
    while true do
      
      if sethiddenproperty then
            sethiddenproperty(Client,"SimulationRadius",50000)
            sethiddenproperty(Client,"MaxSimulationRadius",50000)
          end
      
      t = t + 60 * 0.01
      if Target then
        local TargetHumanoidRootPart = GetHumanoidRootPart(Target)
        local TargetHumanoid = GetHumanoid(Target)
        if TargetHumanoidRootPart then
          --// Stop fling
          if AlreadyFlinged or Config.Fling.StopFling or not Target or i >= 50 then
            Config.Fling.FlingInProgress = false
            break
          end

          if Target and TargetHumanoidRootPart and TargetHumanoidRootPart.Velocity.Magnitude >= 1000 then
            AlreadyFlinged = true
          end

          if not AlreadyFlinged and not Config.Fling.StopFling and Target and TargetHumanoidRootPart then
              
              if #Parts < 1 then
                  AlreadyFlinged = true
              end
              
              for i,Part in ipairs(Parts) do
                if not Part or not Part:IsDescendantOf(Workspace) then
                  continue
                end
                
                  Part.AssemblyLinearVelocity = Vector3.new(10000,10000,10000)
                  
                  local MoveVelocity = TargetHumanoidRootPart.AssemblyLinearVelocity
                  
                  local X = math.sin(t) * MoveVelocity.X * 0.9
                  local Z = math.cos(t) * MoveVelocity.Z * 0.9
                  
                  local TargetCFrame = nil
                  
                  if MoveVelocity.Magnitude > 1 then
                 TargetCFrame = TargetHumanoidRootPart.CFrame * CFrame.new(X,0,Z)
                 else
                   TargetCharacter = TargetHumanoidRootPart.CFrame * CFrame.new(math.random(-1,1),math.random(-1,1),math.random(-1,1))
                  end
                  
                  if TargetCFrame then
                  Part.CFrame = TargetCFrame
                  end
            Part.CFrame = Part.CFrame * CFrame.Angles(math.rad(math.random(-360,360)),math.rad(math.random(-360,360)),math.rad(math.random(-360,360)))
              end
          end


        end
      end
      i = i + 1
      task.wait(0.01)
    end
  end)
end

local function VehicleFlingPlayer(Target)
  if Config.Fling.FlingInProgress then
    Config.Fling.StopFling = true
    task.wait(0.1)
    Config.Fling.StopFling = false
  end

  local AlreadyFlinged = false
  local OldPosition = nil
  local OldTargetPosition = nil
  local i = 0
  task.spawn(function()
    Config.Fling.FlingInProgress = true
    while true do
      if Target then
        local TargetHumanoidRootPart = GetHumanoidRootPart(Target)
        local TargetHumanoid = GetHumanoid(Target)
        local Humanoid = GetHumanoid(Client)
        if TargetHumanoidRootPart and Humanoid and TargetHumanoid then
          
          local Seat = Humanoid.SeatPart
          
          if not Seat then AlreadyFlinged = true end
          
          if Seat then
            if not OldPosition then
            OldPosition = Seat.CFrame
          end
          end
          --// Save initial position
          --// Stop fling
          if AlreadyFlinged or Config.Fling.StopFling or not Target or i >= 50 then
            if Seat and OldPosition then
              for i = 1,40,1 do
                Seat.CFrame = OldPosition
                task.wait(0.01)
              end
            end
            Config.Fling.FlingInProgress = false
            break
          end

          if Target and TargetHumanoidRootPart and OldTargetPosition and (TargetHumanoidRootPart.CFrame.Position - OldTargetPosition).Magnitude >= 1000 then
            AlreadyFlinged = true
          end

          if not AlreadyFlinged and not Config.Fling.StopFling and Target and TargetHumanoidRootPart and Seat and TargetHumanoid then
            if not OldTargetPosition then
              OldTargetPosition = TargetHumanoidRootPart.CFrame.Position
            end
            
            Seat.CFrame = TargetHumanoidRootPart.CFrame * CFrame.new(math.random(-5,5),math.random(-5,5),math.random(-5,5))
            
            if TargetHumanoid and TargetHumanoid.Sit and TargetHumanoid.SeatPart then
              local OldDestroyFallenPartsHeight = Workspace.FallenPartsDestroyHeight
              Workspace.FallenPartsDestroyHeight = -10000000
              task.wait(0.1)
              while true do
                if (not TargetHumanoidRootPart or not TargetHumanoid) or (TargetHumanoid and not TargetHumanoid.SeatPart) then
                  break
                end
              Seat.CFrame = CFrame.new(0,OldDestroyFallenPartsHeight - 2,0)
              task.wait(0.01)
              end
              Seat.CFrame = OldPosition
              AlreadyFlinged = true
              task.wait(0.5)
              Workspace.FallenPartsDestroyHeight = OldDestroyFallenPartsHeight
            end
            
          end


        end
      end
      i = i + 1
      task.wait(0.01)
    end
  end)
end

local function FlingAll()
  for i,Player in ipairs(Players:GetPlayers()) do
    if Config.Fling.FlingInProgress then
      while true do
        if not Config.Fling.FlingInProgress then
          break
        end
        task.wait(0.00000001)
      end
    end
    if Player ~= Client then
      FlingPlayer(Player)
    end
  end
end

local function SpectatePlayer(Player)
  local Camera = Workspace.CurrentCamera
  local Humanoid = GetHumanoid(Player)
  if Humanoid then
    Camera.CameraSubject = Humanoid
  end
end

local function Bang()
  task.spawn(function()
    local i = 1
    local Direction = 1
    local OrignalGravity = Workspace.Gravity
    while true do
      local Target = Config.Target
      local Speed = Config.Bang.Speed
      if not Config.Bang.Enabled then
        StopAnimation(Config.Bang.BangAnimation.Id)
        Workspace.Gravity = OrignalGravity
        break
      end

      if i <= 1 then
        Direction = 1
      elseif i >= 7 then
        Direction = 0
      end

      if Direction == 0 then
        i = i - Speed
      elseif Direction == 1 then
        i = i + Speed
      end

      if Target then
        local TargetHumanoidRootPart = GetHumanoidRootPart(Target)
        local HumanoidRootPart = GetHumanoidRootPart(Client)
        if TargetHumanoidRootPart and HumanoidRootPart then

          


          HumanoidRootPart.CFrame = TargetHumanoidRootPart.CFrame * CFrame.new(0,0,i)
          HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(0),0)
          if not ItsPlayingAnimation(Client,Config.Bang.BangAnimation.Id) then
            PlayAnimation(Config.Bang.BangAnimation.Id,Config.Bang.BangAnimation.Pause,Config.Bang.BangAnimation.TimePosition,Config.Bang.BangAnimation.Speed,Config.Bang.BangAnimation.Looped)
          end
        end
      else
        StopAnimation(Config.Bang.BangAnimation.Id)
        Workspace.Gravity = OrignalGravity
        break
      end

      task.wait(0.01)
    end
  end)
end

local function FaceBang()
  task.spawn(function()
    local i = 1
    local Direction = 1
    local OrignalGravity = Workspace.Gravity
    while true do
      local Target = Config.Target
      local Speed = Config.FaceBang.Speed
      if not Config.FaceBang.Enabled then
        StopAnimation(Config.FaceBang.FaceBangAnimation.Id)
        Workspace.Gravity = OrignalGravity
        break
      end

      if i <= -5 then
        Direction = 1
      elseif i >= -1 then
        Direction = 0
      end

      if Direction == 0 then
        i = i - Speed
      elseif Direction == 1 then
        i = i + Speed
      end

      if Target then
        local TargetCharacter = Target.Character
        local HumanoidRootPart = GetHumanoidRootPart(Client)
        if TargetCharacter and HumanoidRootPart then
          local Head = TargetCharacter:FindFirstChild("Head")
          local TargetHumanoidRootPart = TargetCharacter:FindFirstChild("HumanoidRootPart")
          if Head and TargetHumanoidRootPart then

            

            HumanoidRootPart.CFrame = Head.CFrame * CFrame.new(0,1.5,i)
            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(180),0)
            if not ItsPlayingAnimation(Client,Config.FaceBang.FaceBangAnimation.Id) then
            PlayAnimation(Config.FaceBang.FaceBangAnimation.Id,Config.FaceBang.FaceBangAnimation.Pause,Config.FaceBang.FaceBangAnimation.TimePosition,Config.FaceBang.FaceBangAnimation.Speed,Config.FaceBang.FaceBangAnimation.Looped)
          end
          end
        end
      else
        StopAnimation(Config.FaceBang.FaceBangAnimation.Id)
        Workspace.Gravity = OrignalGravity
        break
      end

      task.wait(0.01)
    end
  end)
end

local function Suck()
  task.spawn(function()
    local i = 1
    local Direction = 1
    local OrignalGravity = Workspace.Gravity
    while true do
      local Target = Config.Target
      local Speed = Config.Suck.Speed
      if not Config.Suck.Enabled then
        StopAnimation(Config.Suck.SuckAnimation.Id)
        Workspace.Gravity = OrignalGravity
        break
      end

      if i <= -7 then
        Direction = 1
      elseif i >= -2.5 then
        Direction = 0
      end

      if Direction == 0 then
        i = i - Speed
      elseif Direction == 1 then
        i = i + Speed
      end

      if Target then
        local HumanoidRootPart = GetHumanoidRootPart(Client)
        local TargetHumanoidRootPart = GetHumanoidRootPart(Target)
        if TargetHumanoidRootPart and HumanoidRootPart then

          

            HumanoidRootPart.CFrame = TargetHumanoidRootPart.CFrame * CFrame.new(0,0.5,i)
            HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(180),0)
            if not ItsPlayingAnimation(Client,Config.Suck.SuckAnimation.Id) then
            PlayAnimation(Config.Suck.SuckAnimation.Id,Config.Suck.SuckAnimation.Pause,Config.Suck.SuckAnimation.TimePosition,Config.Suck.SuckAnimation.Speed,Config.Suck.SuckAnimation.Looped)
          end
        end
      else
        StopAnimation(Config.Suck.SuckAnimation.Id)
        Workspace.Gravity = OrignalGravity
        break
      end

      task.wait(0.01)
    end
  end)
end

local function GetBang()
  task.spawn(function()
    local i = 1
    local Direction = 1
    local OrignalGravity = Workspace.Gravity
    while true do
      local Target = Config.Target
      local Speed = Config.GetBang.Speed
      if not Config.GetBang.Enabled then
        StopAnimation(Config.GetBang.GetBangAnimation.Id)
        Workspace.Gravity = OrignalGravity
        break
      end

      if i <= -7 then
        Direction = 1
      elseif i >= -1 then
        Direction = 0
      end

      if Direction == 0 then
        i = i - Speed
      elseif Direction == 1 then
        i = i + Speed
      end

      if Target then
        local HumanoidRootPart = GetHumanoidRootPart(Client)
        local TargetHumanoidRootPart = GetHumanoidRootPart(Target)
        if TargetHumanoidRootPart and HumanoidRootPart then

          

            HumanoidRootPart.CFrame = TargetHumanoidRootPart.CFrame * CFrame.new(0,0.5,i)
            if not ItsPlayingAnimation(Client,Config.GetBang.GetBangAnimation.Id) then
            PlayAnimation(Config.GetBang.GetBangAnimation.Id,Config.GetBang.GetBangAnimation.Pause,Config.GetBang.GetBangAnimation.TimePosition,Config.GetBang.GetBangAnimation.Speed,Config.GetBang.GetBangAnimation.Looped)
          end
        end
      else
        StopAnimation(Config.GetBang.GetBangAnimation.Id)
        Workspace.Gravity = OrignalGravity
        break
      end

      task.wait(0.01)
    end
  end)
end

local function Orbit()
  task.spawn(function()
    local i = 0
    local OrignalGravity = Workspace.Gravity
    while true do
      if not Config.Orbit.Enabled then
        Workspace.Gravity = OrignalGravity
        break
      end

      local Target = Config.Target
      local Speed = Config.Orbit.Speed / 200
      local Radius = Config.Orbit.Radius
      local Irregular = Config.Orbit.Irregular

      if Target then
        local TargetHumanoidRootPart = GetHumanoidRootPart(Target)
        local HumanoidRootPart = GetHumanoidRootPart(Client)
        if TargetHumanoidRootPart and HumanoidRootPart then

          

          local X = nil
          local Y = nil
          local Z = nil

          if Irregular then
            X = math.sin(i) * Radius
            Y = math.sin(i) * math.random(-5,5)
            Z = math.cos(i) * Radius
          else
            X = math.sin(i) * Radius
            Y = 0
            Z = math.cos(i) * Radius
          end

          HumanoidRootPart.CFrame = TargetHumanoidRootPart.CFrame * CFrame.new(X,Y,Z)
          Workspace.Gravity = 0

          i = i + Speed
        end
      else
        Workspace.Gravity = OrignalGravity
        break
      end
      task.wait(0.01)
    end
  end)
end

local function PunchFling()
  local OldCollisions = {}
  local Connection = nil
  Connection = RunService.Heartbeat:Connect(function()

     local Character = Client.Character
     if Character then
       if not Config.PunchFling.Enabled then
         for i,v in ipairs(Players:GetPlayers()) do
           if not OldCollisions[v] then continue end
           local Character = v.Character
           if Character then
             for a,b in ipairs(Character:GetChildren()) do
               if not b:IsA("BasePart") then continue end
               if OldCollisions[v] and OldCollisions[v][b.Name] then
                 b.CanCollide = OldCollisions[v][b.Name]
               end
             end
           end
         end
      Connection:Disconnect()
    end
       local RootPart = Character:FindFirstChild("HumanoidRootPart")
       if RootPart then
         for i,v in ipairs(Players:GetPlayers()) do
           if not OldCollisions[v] then
             OldCollisions[v] = {}
           end
           local Character = v.Character
           if Character then
             for a,b in ipairs(Character:GetChildren()) do
               if not b:IsA("BasePart") then continue end
               if not OldCollisions[v][b.Name] then
                 OldCollisions[v][b.Name] = b.CanCollide
               end
               b.CanCollide = false
             end
           end
         end

         if Config.PunchFling.Clicked then
         local OldVelocity = RootPart.AssemblyLinearVelocity
         RootPart.AssemblyLinearVelocity = Vector3.new(0,Config.PunchFling.FlingPower,Config.PunchFling.FlingPower)
         RunService.RenderStepped:Wait()
         RootPart.AssemblyLinearVelocity = Vector3.zero
         RunService.RenderStepped:Wait()
         RootPart.AssemblyLinearVelocity = OldVelocity
         end
       end
     end
   end) 
end

local function CreateFakeCharacter()
  local RealCharacter = Workspace:FindFirstChild(Client.Name)
  if RealCharacter then

    if Config.Invisible.FakeCharacter then
      Config.Invisible.FakeCharacter:Destroy()
      Config.Invisible.FakeCharacter = nil
    end

    RealCharacter.Archivable = true

    local FakeCharacter = RealCharacter:Clone()
    FakeCharacter.Name = Client.Name.."_Fake"
    for i,Instance in ipairs(FakeCharacter:GetDescendants()) do
      if Instance:IsA("BasePart") then
        Instance.Velocity = Vector3.zero
        Instance.AssemblyAngularVelocity = Vector3.zero
        Instance.AssemblyLinearVelocity = Vector3.zero
      end
    end
    FakeCharacter.Parent = Workspace

    Config.Invisible.FakeCharacter = FakeCharacter

    return FakeCharacter
  end
end

local function GetRealCharacter()
  local Found = nil

  for i,Instance in ipairs(Workspace:GetDescendants()) do
    if Instance:IsA("Model") then
      if Instance.Name == Client.Name and Instance ~= Config.Invisible.FakeCharacter then
        Found = Instance
        break
      end
    end
  end

  return Found
end

local function SetCharacter(Character)
  local Camera = Workspace.CurrentCamera
  if Camera then
    local CameraSubject = Camera.CameraSubject and Camera.CameraSubject.Name
    if CameraSubject then
      local SubjectInstance = Character and Character:FindFirstChild(CameraSubject)
      if SubjectInstance then
        Camera.CameraSubject = SubjectInstance
        Client.Character = Character
      end
    end
  end
end

local function Invisible(Position)
  local InitialCFrame = nil
  local FallenPartsDestroyHeight = Workspace.FallenPartsDestroyHeight
  local RealCharacter = GetRealCharacter()
  if RealCharacter then
    local HumanoidRootPart = RealCharacter:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart then
      local OldCFrame = Position or HumanoidRootPart.CFrame
      if not InitialCFrame then
        InitialCFrame = OldCFrame
      end
      HumanoidRootPart.CFrame = CFrame.new(0,9e7 * 2,9e7)

      local FakeCharacter = CreateFakeCharacter()
      if FakeCharacter then
        local FakeHumanoidRootPart = FakeCharacter:FindFirstChild("HumanoidRootPart")
        if FakeHumanoidRootPart then
          FakeHumanoidRootPart.CFrame = OldCFrame
          SetCharacter(FakeCharacter)
        end
        for i,Instance in ipairs(FakeCharacter:GetDescendants()) do
          if Instance:IsA("BasePart") then
            if Instance.Name ~= "HumanoidRootPart" then
              Instance.Transparency = 0.7
            end
          end
        end
      end


      if Config.Invisible.VoidRunService then 
        Config.Invisible.VoidRunService:Disconnect()
        Config.Invisible.VoidRunService = nil
      end

      Config.Invisible.VoidRunService = RunService.Heartbeat:Connect(function()
        if FakeCharacter then
          local FakeHumanoidRootPart = FakeCharacter:FindFirstChild("HumanoidRootPart")
          if FakeHumanoidRootPart then
            local Y = FakeHumanoidRootPart.Position.Y
            if (Y - FallenPartsDestroyHeight) <= 5 then
              if InitialCFrame then
                FakeHumanoidRootPart.CFrame = InitialCFrame
              end
            end
          end
        end
      end)


      if Config.Invisible.HumanoidHealthChanged then
        Config.Invisible.HumanoidHealthChanged:Disconnect()
        Config.Invisible.HumanoidHealthChanged = nil
      end

      local FakeHumanoid = FakeCharacter:FindFirstChild("Humanoid")
      if FakeHumanoid then
        Config.Invisible.HumanoidHealthChanged = FakeHumanoid.HealthChanged:Connect(function(New)
          if New <= 0 then
            task.wait(Players.RespawnTime)
            Invisible(InitialCFrame)
          end
        end)
      end

    end
  end
end

local function Visible()
  local RealCharacter = GetRealCharacter()
  local FakeCharacter = Config.Invisible.FakeCharacter
  if RealCharacter and FakeCharacter then
    local RealHumanoidRP = RealCharacter:FindFirstChild("HumanoidRootPart")
    local FakeHumanoidRP = FakeCharacter:FindFirstChild("HumanoidRootPart")
    if RealHumanoidRP and FakeHumanoidRP then
      local FakeHumanoidRPCFrame = FakeHumanoidRP.CFrame

      if Config.Invisible.HumanoidHealthChanged then
        Config.Invisible.HumanoidHealthChanged:Disconnect()
        Config.Invisible.HumanoidHealthChanged = nil
      end

      if Config.Invisible.VoidRunService then 
        Config.Invisible.VoidRunService:Disconnect()
        Config.Invisible.VoidRunService = nil
      end

      FakeCharacter:Destroy()
      Config.Invisible.FakeCharacter = nil

      for i,Instance in ipairs(RealCharacter:GetDescendants()) do
      if Instance:IsA("BasePart") then
        Instance.Velocity = Vector3.zero
        Instance.AssemblyAngularVelocity = Vector3.zero
        Instance.AssemblyLinearVelocity = Vector3.zero
      end
    end

      RealHumanoidRP.CFrame = FakeHumanoidRPCFrame
      SetCharacter(RealCharacter)
    end
  end
end

local function PlayerLift()
  local OldGravity = nil
  local OldCollisions = {}
  local StartY = nil
  task.spawn(function()
    while true do
      if not Config.PlayerLift.Enabled then
        if OldGravity then
          game.Workspace.Gravity = OldGravity
        end
        for i,Part in ipairs(Client.Character:GetDescendants()) do
          if Part:IsA("BasePart") then
            Part.CanCollide = OldCollisions[Part]
          end
        end

        if ItsPlayingAnimation(Client,131895285930138) then
          StopAnimation(131895285930138)
        end
        break
      end
      local Target = Config.Target
      if Target then
        local TargetCharacter = Target.Character
        if TargetCharacter then
        local TargetHumanoidRootPart = GetHumanoidRootPart(Target)
        local HumanoidRootPart = GetHumanoidRootPart(Client)
        if TargetHumanoidRootPart and HumanoidRootPart then

          for i,Part in ipairs(Client.Character:GetDescendants()) do
            if Part:IsA("BasePart") then
            OldCollisions[Part] = Part.CanCollide
            end
          end

          if not OldGravity then
            OldGravity = game.Workspace.Gravity
          end

          

          HumanoidRootPart.CFrame = CFrame.new(TargetHumanoidRootPart.Position.X,TargetHumanoidRootPart.Position.Y - 7,TargetHumanoidRootPart.Position.Z) * CFrame.new(0,Config.PlayerLift.Height,0)


          local Character = Client.Character
          if Character then

            for i,Part in ipairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") then
              Part.CanCollide = false
            end
          end

            for i,Part in ipairs(Character:GetDescendants()) do
            if Part:IsA("BasePart") then
              Part.AssemblyLinearVelocity = Vector3.new(0,0,0)
              Part.AssemblyAngularVelocity = Vector3.new(0,0,0)
              Part.Velocity = Vector3.new(0,0,0)
            end
          end
          end

          if not ItsPlayingAnimation(Client,131895285930138) then
            PlayAnimation(131895285930138,false,0,1,true)
          end
          game.Workspace.Gravity = 0
          else
            if OldGravity then
          game.Workspace.Gravity = OldGravity
        end
        for i,Part in ipairs(Client.Character:GetDescendants()) do
          if Part:IsA("BasePart") then
            Part.CanCollide = OldCollisions[Part]
          end
        end

        if ItsPlayingAnimation(Client,131895285930138) then
          StopAnimation(131895285930138)
        end
        end
        else
          if OldGravity then
          game.Workspace.Gravity = OldGravity
        end
        for i,Part in ipairs(Client.Character:GetDescendants()) do
          if Part:IsA("BasePart") then
            Part.CanCollide = OldCollisions[Part]
          end
        end

        if ItsPlayingAnimation(Client,131895285930138) then
          StopAnimation(131895285930138)
        end
        end
        else
          if OldGravity then
          game.Workspace.Gravity = OldGravity
        end
        for i,Part in ipairs(Client.Character:GetDescendants()) do
          if Part:IsA("BasePart") then
            Part.CanCollide = OldCollisions[Part]
          end
        end

        if ItsPlayingAnimation(Client,131895285930138) then
          StopAnimation(131895285930138)
        end
        break
    end
      task.wait(0.001)
    end
  end)
end

--//Library
local Tab = Window:CreateTab("Troll")
local Section = Tab:CreateSection("Select Target")

Tab:CreateInput({
  Name = "Player Name",
  PlaceholderText = "Write a name...",
  Callback = function(Text)
    local Player = GetPlayerByPartialName(Text)
    if Player then
      Config.Target = Player
      if Config.TargetCharacterAdded then
        Config.TargetCharacterAdded:Disconnect()
        Config.TargetCharacterAdded = nil
      end
      if not Config.TargetCharacterAdded then
        Config.TargetCharacterAdded = Player.CharacterAdded:Connect(function(Character)
          local Humanoid = GetHumanoid(Player)
          if not Humanoid then
            Character:WaitForChild("Humanoid")
          end
          if Config.Spectate.Enabled then
            if Config.Target then
              SpectatePlayer(Config.Target)
            end
          end
        end)
      end
    else

    end
  end
})

local PlayersList = Tab:CreateDropdown({
    Name = "Select Player",
    Options = GetPlayersNamesList(true),
    Callback = function(Option)
        local Name = Option:match("^%S+") or "xduwuxduwuxd"
        local Player = GetPlayerByPartialName(Name)
        if Player then
          Config.Target = Player
          if Config.TargetCharacterAdded then
        Config.TargetCharacterAdded:Disconnect()
        Config.TargetCharacterAdded = nil
      end
      if not Config.TargetCharacterAdded then
        Config.TargetCharacterAdded = Player.CharacterAdded:Connect(function(Character)
          local Humanoid = GetHumanoid(Player)
          if not Humanoid then
            Character:WaitForChild("Humanoid")
          end
          if Config.Spectate.Enabled then
            if Config.Target then
              SpectatePlayer(Config.Target)
            end
          end
        end)
      end
        end
    end
})

Tab:CreateToggle({
    Name = "Spectate",
    CurrentValue = false,
    Callback = function(State)
      Config.Spectate.Enabled = State
      if State then
        SpectatePlayer(Config.Target)
      else
        SpectatePlayer(Client)
      end
    end
})

Tab:CreateButton({
  Name = "Teleport",
  Callback = function()
    if Config.Target then
      TeleportToPlayer(Config.Target)
    end
  end
})

Tab:CreateDropdown({
    Name = "Fling Method",
    Options = {"Normal","Parts","Vehicle"},
    Callback = function(Option)
        Config.Fling.FlingMode = Option
    end
})

Tab:CreateButton({
  Name = "Fling Target",
  Callback = function()
    if Config.Fling.FlingMode == "Normal" then
        FlingPlayer(Config.Target)
    elseif Config.Fling.FlingMode == "Parts" then
        FlingPlayerWithParts(Config.Target)
    elseif Config.Fling.FlingMode == "Vehicle" then
      VehicleFlingPlayer(Config.Target)
    end
  end
})

Tab:CreateButton({
  Name = "Fling All",
  Callback = function()
    FlingAll()
  end
})

Tab:CreateToggle({
    Name = "Punch Fling",
    CurrentValue = false,
    Callback = function(State)
      Config.PunchFling.Enabled = State
      if State then
        PunchFling()
      end
    end
})

Tab:CreateToggle({
    Name = "Player Lift",
    CurrentValue = false,
    Callback = function(State)
      Config.PlayerLift.Enabled = State
      if State then
        PlayerLift()
      end
    end
})

Tab:CreateSlider({
    Name = "Player Lift Height",
    Range = {0, 20}, --- Mínimo y máximo
    Increment = 0.1, --- De cuánto en cuánto cambia
    Suffix = "", --- Texto después del valor
    CurrentValue = 0, --- Valor inicial
    Callback = function(Value)
      Config.PlayerLift.Height = Value
    end
})

Tab:CreateToggle({
    Name = "Bang",
    CurrentValue = false,
    Callback = function(State)
      Config.Bang.Enabled = State
      if State then
        Bang()
      end
    end
})

Tab:CreateSlider({
    Name = "Bang speed",
    Range = {0.1, 2}, --- Mínimo y máximo
    Increment = 0.01, --- De cuánto en cuánto cambia
    Suffix = "/s", --- Texto después del valor
    CurrentValue = 0.5, --- Valor inicial
    Callback = function(Value)
      Config.Bang.Speed = Value
    end
})

Tab:CreateToggle({
    Name = "Face Bang",
    CurrentValue = false,
    Callback = function(State)
      Config.FaceBang.Enabled = State
      if State then
        FaceBang()
      end
    end
})

Tab:CreateSlider({
    Name = "Face Bang speed",
    Range = {0.1, 2}, --- Mínimo y máximo
    Increment = 0.01, --- De cuánto en cuánto cambia
    Suffix = "/s", --- Texto después del valor
    CurrentValue = 0.5, --- Valor inicial
    Callback = function(Value)
      Config.FaceBang.Speed = Value
    end
})

Tab:CreateToggle({
    Name = "Suck",
    CurrentValue = false,
    Callback = function(State)
      Config.Suck.Enabled = State
      if State then
        Suck()
      end
    end
})

Tab:CreateSlider({
    Name = "Suck speed",
    Range = {0.1, 2}, --- Mínimo y máximo
    Increment = 0.01, --- De cuánto en cuánto cambia
    Suffix = "/s", --- Texto después del valor
    CurrentValue = 0.5, --- Valor inicial
    Callback = function(Value)
      Config.Suck.Speed = Value
    end
})

Tab:CreateToggle({
    Name = "Get bang",
    CurrentValue = false,
    Callback = function(State)
      Config.GetBang.Enabled = State
      if State then
        GetBang()
      end
    end
})

Tab:CreateSlider({
    Name = "Get bang speed",
    Range = {0.1, 2}, --- Mínimo y máximo
    Increment = 0.01, --- De cuánto en cuánto cambia
    Suffix = "/s", --- Texto después del valor
    CurrentValue = 0.5, --- Valor inicial
    Callback = function(Value)
      Config.GetBang.Speed = Value
    end
})

Tab:CreateToggle({
    Name = "Orbit",
    CurrentValue = false,
    Callback = function(State)
      Config.Orbit.Enabled = State
      if State then
        Orbit()
      end
    end
})

Tab:CreateToggle({
    Name = "Irregular orbit",
    CurrentValue = false,
    Callback = function(State)
      Config.Orbit.Irregular = State
    end
})

Tab:CreateSlider({
    Name = "Orbit speed",
    Range = {0.1, 100}, --- Mínimo y máximo
    Increment = 0.01, --- De cuánto en cuánto cambia
    Suffix = "/s", --- Texto después del valor
    CurrentValue = 10, --- Valor inicial
    Callback = function(Value)
      Config.Orbit.Speed = Value
    end
})

Tab:CreateSlider({
    Name = "Orbit radius",
    Range = {0.1, 100}, --- Mínimo y máximo
    Increment = 0.01, --- De cuánto en cuánto cambia
    Suffix = "/s", --- Texto después del valor
    CurrentValue = 10, --- Valor inicial
    Callback = function(Value)
      Config.Orbit.Radius = Value
    end
})

Tab:CreateToggle({
    Name = "Invisible",
    CurrentValue = false,
    Callback = function(State)
      Config.Invisible.Enabled = State
      if State then
        Invisible(nil)
      else
        Visible()
      end
    end
})

--//Events
Client.CharacterAdded:Connect(function(Character)
  local Humanoid = GetHumanoid(Client)
  if not Humanoid then
    Character:WaitForChild("Humanoid")
  end
  if Config.Spectate.Enabled then
    if Config.Target then
      SpectatePlayer(Config.Target)
    end
  end
end)

UserInputService.InputBegan:Connect(function(Input)
  task.spawn(function()
  if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
    if Config.PunchFling.Enabled then
      if Config.PunchFling.FlingInProgress then
        return
      end
     Config.PunchFling.FlingInProgress = true
      PlayAnimation(Config.PunchFling.PunchAnimation,false,0,1,false)
      task.wait(0.3)
      Config.PunchFling.Clicked = true
      task.wait(0.5)
      Config.Clicked = false
      StopAnimation(Config.PunchFling.PunchAnimation)
      task.wait(1)
      Config.PunchFling.FlingInProgress = false
    end
  end
  end)
end)

Players.PlayerAdded:Connect(function(Player)
  PlayersList:UpdateOnClose(GetPlayersNamesList(true))
end)
Players.PlayerRemoving:Connect(function(Player)
  PlayersList:UpdateOnClose(GetPlayersNamesList(true))
end)
--//Loop

RunService.RenderStepped:Connect(function()
  if Config.Fling.FlingMode == "Parts" then
    if sethiddenproperty then
      sethiddenproperty(Client,"SimulationRadius",50000)
      sethiddenproperty(Client,"MaxSimulationRadius",50000)
    end
  end
end)