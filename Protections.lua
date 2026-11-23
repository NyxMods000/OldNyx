--//Variables
local NyxModsUniversal = getgenv().NyxModsUniversal
local Window = NyxModsUniversal.Window
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Client = Players.LocalPlayer

local Config = {
  AntiFling = false,
  OldCollisions = {},

  AntiFreeze = false,
  AntiAfk = false,
  AntiSit = false,
  AntiSitBlockState = false,
  AntiFallDamage = false,
  UnlockCamera = false,
  OldCameraMode = nil,
  HumanoidStateChanged = nil,
  HumanoidGetPropertyChangedSignal = nil,
  HumanoidRootPartGetPropertyChangedSignal = nil,
  OldCollisions = {},
}

local Tab = Window:CreateTab("Protections")
local Section = Tab:CreateSection("Options")

local function OnCharacterAdded()
  local Character = Client and Client.Character or Client.CharacterAdded:Wait()
  if Character then
    local Humanoid = Character and Character:FindFirstChild("Humanoid") or Character and Character:WaitForChild("Humanoid")
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart")
    if Humanoid and HumanoidRootPart then

      if Config.HumanoidStateChanged then 
        Config.HumanoidStateChanged:Disconnect()
        Config.HumanoidStateChanged = nil
      end

      Config.HumanoidStateChanged = Humanoid.StateChanged:Connect(function(_,NewState)
        if NewState == Enum.HumanoidStateType.Seated then
          if Config.AntiSitBlockState then
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
            Humanoid.Jump = true
          else
            Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
          end
        end
      end)

      if Config.HumanoidGetPropertyChangedSignal then
        Config.HumanoidGetPropertyChangedSignal:Disconnect()
        Config.HumanoidGetPropertyChangedSignal = nil
      end

      Config.HumanoidGetPropertyChangedSignal = Humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
        if Config.AntiSit then
        Humanoid.Jump = true
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
        else
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
        end
      end)



      if Config.HumanoidRootPartGetPropertyChangedSignal then
        Config.HumanoidRootPartGetPropertyChangedSignal:Disconnect()
        Config.HumanoidRootPartGetPropertyChangedSignal = nil
      end

      Config.HumanoidRootPartGetPropertyChangedSignal = HumanoidRootPart:GetPropertyChangedSignal("Anchored"):Connect(function()
        if Config.AntiFreeze then
          if HumanoidRootPart.Anchored then
            if Config.AntiFreeze then
              HumanoidRootPart.Anchored = false
            end
          end
        end
      end)

    end
  end
end

Tab:CreateToggle({
    Name = "Anti fling",
    CurrentValue = false,
    Callback = function(State)
      Config.AntiFling = State
      if not State then
        local Character = Client.Character
        if Character then
          for i,v in ipairs(Character:GetChildren()) do
            if v:IsA("BasePart") then
              if Config.OldCollisions[v.Name] then
                v.CanCollide = Config.OldCollisions[v.Name]
              end
            end
          end
        end

        for i,Player in ipairs(Players:GetPlayers()) do
          local Character = Player.Character
          if Character then
            for i,Instance in ipairs(Character:GetChildren()) do
              if Instance:IsA("BasePart") then
                if Config.OldCollisions[Player][Instance.Name] then
                  Instance.CanCollide = Config.OldCollisions[Player][Instance.Name]
                end
              end
            end
          end
        end

      end
    end
})

Tab:CreateToggle({
    Name = "Anti Fall Damage",
    CurrentValue = false,
    Callback = function(State)
      Config.AntiFallDamage = State
    end
})

Tab:CreateToggle({
    Name = "Anti Freeze",
    CurrentValue = false,
    Callback = function(State)
      Config.AntiFreeze = State
      if State then
        local Character = Client.Character
        if Character then
          for i,v in ipairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then
              v.Anchored = false
            end
          end
        end
      end
    end
})

Tab:CreateToggle({
    Name = "Anti Afk",
    CurrentValue = false,
    Callback = function(State)
      Config.AntiAfk = State
    end
})

Tab:CreateToggle({
    Name = "Anti Sit",
    CurrentValue = false,
    Callback = function(State)
      Config.AntiSit = State
      if State then
      local Character = Client and Client.Character
      if Character then
        local Humanoid = Character:FindFirstChild("Humanoid")
        if Humanoid then
          Humanoid.Sit = false
          Humanoid.Jump = true
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
        end
      end
      end
    end
})

Tab:CreateToggle({
    Name = "Anti Sit Block State",
    CurrentValue = false,
    Callback = function(State)
      Config.AntiSitBlockState = State
      if State then
        local Character = Client and Client.Character
      if Character then
        local Humanoid = Character:FindFirstChild("Humanoid")
        if Humanoid then
          Humanoid.Sit = false
          Humanoid.Jump = true
          Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,true)
        end
      end
      end
    end
})

Tab:CreateToggle({
    Name = "Unlock Camera",
    CurrentValue = false,
    Callback = function(State)
      Config.UnlockCamera = State
      if not Config.OldCameraMode then
        Config.OldCameraMode = Client.CameraMode
      end

      if State then
        Client.CameraMode = Enum.CameraMode.Classic
      else
        Client.CameraMode = Config.OldCameraMode
      end
    end
})


OnCharacterAdded()

Client.Idled:Connect(function()
  if Config.AntiAfk then
    local Character = Client and Client.Character or Client.CharacterAdded:Wait()
    if Character then
      local Humanoid = Character:FindFirstChild("Humanoid") or Character:WaitForChild("Humanoid")
      local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart") or Character:WaitForChild("HumanoidRootPart")
      if Humanoid and HumanoidRootPart then
        Humanoid:MoveTo(HumanoidRootPart.Position + Vector3.new(0,0,0.1))
      end
    end
  end
end)

Client:GetPropertyChangedSignal("CameraMode"):Connect(function()
  if Client.CameraMode == Enum.CameraMode.LockFirstPerson then
    if Config.UnlockCamera then
      Client.CameraMode = Enum.CameraMode.Classic
    end
  end
end)



RunService.Heartbeat:Connect(function()
  local Character = Client.Character
  if Character then
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    if HumanoidRootPart then
      if Config.AntiFallDamage then
        local OldVelocity = HumanoidRootPart.AssemblyLinearVelocity

        HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
        RunService.RenderStepped:Wait()
        HumanoidRootPart.AssemblyLinearVelocity = OldVelocity
      end

      if Config.AntiFling then
        for i,v in ipairs(Character:GetChildren()) do
          if v:IsA("BasePart") then
            if not Config.OldCollisions[v.Name] then
              Config.OldCollisions[v.Name] = v.CanCollide
            end
            v.CanCollide = false
          end
        end
        
        for i,Player in ipairs(Players:GetPlayers()) do
          if Player ~= Client then
          local Character = Player.Character
          if Character then
            for i,Instance in ipairs(Character:GetChildren()) do
              if Instance:IsA("BasePart") then
                if not Config.OldCollisions[Player] then
                  Config.OldCollisions[Player] = {}
                end
                if not Config.OldCollisions[Player][Instance.Name] then
                  Config.OldCollisions[Player][Instance.Name] = Instance.CanCollide
                end
                Instance.CanCollide = false
              end
            end
          end
          end
      end
      end
    end
  end
end)

Client.CharacterAdded:Connect(OnCharacterAdded)