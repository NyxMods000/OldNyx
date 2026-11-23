local NyxModsUniversal = getgenv().NyxModsUniversal
local Window = NyxModsUniversal.Window
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Client = Players.LocalPlayer

local Config = {
  WallCheck = false,
  TeamCheck = false,
  IgnoredTeams = {},
  Teams = {},
  AimCharacter = false,
  AimCamera = true,

  Enabled = false,
  MaxDistance = math.huge,
  TargetPart = "Head",
  OnlyInCamera = false,
  IgnoreDead = false,
  Prediction = false,
  PredictionAmount = 0,
  Smoothness = 1,
  AimKeybind = "K",

  Target = {
                  Enabled = false,
                  SelectedTarget = nil,
  },
}

for i,Team in ipairs(game:GetService("Teams"):GetChildren()) do
  local Name = Team.Name
  if Name then
    table.insert(Config.Teams,tostring(Name))
  end
end

local function GetPlayerWithPartialName(Name)
  local Target = nil
  for i,v in ipairs(Players:GetPlayers()) do
    if v and v.Name:lower():find(Name:lower()) or v and v.DisplayName:lower():find(Name:lower()) then
    Target = v
    break
    end
  end
  return Target
end

local function InCamera(Part)
  local Camera = Workspace.CurrentCamera
  if Camera and Part then
    local Position, Visible = Camera:WorldToViewportPoint(Part.Position)
    if Visible then
      return true
    else
      return false
    end
  end
end

local function WallCheck(Part)
  local Camera = Workspace.CurrentCamera
  if Camera and Part then
    local Character = Client and Client.Character
    local TargetCharacter = Part.Parent and Part.Parent:IsA("Model") and Part.Parent or Part.Parent.Parent and Part.Parent.Parent:IsA("Model") and Part.Parent.Parent or Part.Parent.Parent.Parent and Part.Parent.Parent.Parent:IsA("Model") and Part.Parent.Parent.Parent
    if Character and TargetCharacter then
      local Origin = Camera.CFrame.Position
      local Direction = Part.Position - Origin
      local Params = RaycastParams.new()
      Params.FilterType = Enum.RaycastFilterType.Exclude
      Params.FilterDescendantsInstances = {Character}

      local Result = Workspace:Raycast(Origin,Direction,Params)

      if Result then
        if Result.Instance and Result.Instance:IsDescendantOf(TargetCharacter) then
          return false
        else
          return true
        end
      end

    end
  end
end

local function TeamCheck(PlayerA,PlayerB)
  return PlayerA and PlayerB and PlayerA.Team == PlayerB.Team or PlayerA and PlayerB and PlayerA.TeamColor == PlayerB.TeamColor or PlayerB and PlayerB.Team and  Config.IgnoredTeams[PlayerB.Team.Name] or false
end

local function GetDistance(a,b)
  return (a - b).Magnitude
end

local function IsDead(Player)
  local Character = Player and Player.Character
  if Character then
    local Humanoid = Character and Character:FindFirstChild("Humanoid")
    if Humanoid then
      if Humanoid.Health <= 0 then
        return true
      else
        return false
      end
    else
      return true
    end
  end
end

local function GetClosestTarget()
  local ClosestTarget = nil
  local ClosestDistance = math.huge

  for _,Player in ipairs(Players:GetPlayers()) do
    if Player ~= Client then
      local Character = Player.Character
      local MyCharacter = Client.Character
      if Character and MyCharacter then
        local Humanoid = Character:FindFirstChild("Humanoid")
        local MyHumanoid = MyCharacter:FindFirstChild("Humanoid")
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        local MyHumanoidRootPart = MyCharacter:FindFirstChild("HumanoidRootPart")
        if Humanoid and MyHumanoid and HumanoidRootPart and MyHumanoidRootPart then

          if Config.Target.Enabled and not Config.Target.SelectedTarget then
           continue
          end

          if Config.Target.Enabled and Config.Target.SelectedTarget ~= Player then
            continue
          end

          if Config.IgnoreDead and IsDead(Player) then
            continue
          end

          if Config.WallCheck and WallCheck(HumanoidRootPart) then
            continue
          end

          if Config.TeamCheck and TeamCheck(Client,Player) and not Config.Target.Enabled then
            continue
          end

          if Config.OnlyInCamera and not InCamera(HumanoidRootPart) then
            continue
          end

          local Distance = GetDistance(MyHumanoidRootPart.Position,HumanoidRootPart.Position)

          if Distance <= Config.MaxDistance and Distance < ClosestDistance then
            ClosestTarget = Player
            ClosestDistance = Distance
          end

        end
      end
    end
  end
  return ClosestTarget
end

local function EnableAimbot()
    task.spawn(function()
    local LastUpdate = CFrame.new(0,0,0)
    local Connection = nil
        Connection = RunService.Heartbeat:Connect(function()
            if not Config.Enabled then
                Connection:Disconnect()
                
            end

            local Character = Client and Client.Character
            local Camera = Workspace.CurrentCamera
            
          

            if Character and Camera then
                local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
                local Humanoid = Character:FindFirstChild("Humanoid")

                if HumanoidRootPart and Humanoid then
                    local ClosestTarget = GetClosestTarget()

                    if ClosestTarget then
                        local TargetCharacter = ClosestTarget.Character

                        if TargetCharacter then
                            local TargetPart = TargetCharacter:FindFirstChild(Config.TargetPart)

                            if TargetPart then
                                local TargetPosition = TargetPart.Position

                                if Config.Prediction then
                                    TargetPosition = TargetPosition + (TargetPart.AssemblyLinearVelocity * Config.PredictionAmount)
                                end

                                if Config.AimCamera then
                                
                                    local CameraPosition = Camera.CFrame.Position
                                    local Direction = (TargetPosition - CameraPosition).Unit
                                    
                                    local TargetCFrame = CFrame.new(CameraPosition,CameraPosition + Direction)
                                    Camera.CFrame = Camera.CFrame:Lerp(TargetCFrame,Config.Smoothness)
                                    
                                end

                                if Config.AimCharacter then
                                    local TargetCFrame = CFrame.lookAt(
    HumanoidRootPart.Position,
    Vector3.new(
        TargetPosition.X,
        HumanoidRootPart.Position.Y,
        TargetPosition.Z
    )
)

HumanoidRootPart.CFrame = HumanoidRootPart.CFrame:Lerp(
    TargetCFrame,
    Config.Smoothness
)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end)
end


local Tab = Window:CreateTab("Aimbot")
local AimSection = Tab:CreateSection("Aimbot settings")

Tab:CreateToggle({
    Name = "Enable Aimbot",
    CurrentValue = false, --- Valor inicial
    Callback = function(State)
        Config.Enabled = State
        if State then
        EnableAimbot()
        end

        if State then
          Notify("Aimbot","Enabled",2)
        else
           Notify("Aimbot","Disabled",2)
        end
    end
})

Tab:CreateInput({
    Name = "Aimbot Keybind",
    PlaceholderText = "Put a Keybind",
    Callback = function(Text)
      Config.AimKeybind = Text
    end
})

Tab:CreateToggle({
    Name = "Custom Target",
    CurrentValue = false, --- Valor inicial
    Callback = function(State)
        Config.Target.Enabled = State

        if State then
          Notify("Custom Target","Enabled",2)
        else
           Notify("Custom Target","Disabled",2)
        end
    end
})

Tab:CreateInput({
    Name = "Custom Target Name",
    PlaceholderText = "Put A Name",
    Callback = function(Text)
      local Target = GetPlayerWithPartialName(Text)

      Config.Target.SelectedTarget = Target
      if Target then
         Notify("Custom Target","Player Found And Selected",2)
      else
         Notify("Custom Target","Player Not Found",2)
      end
    end
})

Tab:CreateToggle({
    Name = "WallCheck",
    CurrentValue = false, --- Valor inicial
    Callback = function(State)
        Config.WallCheck = State

        if State then
          Notify("WallCheck","Enabled",2)
        else
           Notify("WallCheck","Disabled",2)
        end
    end
})

Tab:CreateToggle({
    Name = "TeamCheck",
    CurrentValue = false, --- Valor inicial
    Callback = function(State)
        Config.TeamCheck = State

        if State then
          Notify("TeamCheck","Enabled",2)
        else
           Notify("TeamCheck","Disabled",2)
        end
    end
})

Tab:CreateDropdown({
    Name = "Ignored teams",
    Options = Config.Teams,
    Callback = function(Option)
        if not Config.IgnoredTeams[Option] then
          Notify("Advertisement","Ignoring: "..Option.." Team",3)
          Config.IgnoredTeams[Option] = true
        else
          Notify("Advertisement","Stop Ignoring: "..Option.." Team",3)
          Config.IgnoredTeams[Option] = false
        end
    end
})

Tab:CreateButton({
  Name = "Reset Ignored Teams",
  Callback = function()
    Notify("Advertisement","Ignored Teams reseted",3)
    for i,v in pairs(Config.IgnoredTeams) do
      Config.IgnoredTeams[i] = false
    end
  end
})

Tab:CreateToggle({
    Name = "Aim Camera",
    CurrentValue = true, --- Valor inicial
    Callback = function(State)
        Config.AimCamera = State

        if State then
          Notify("Aim Camera","Enabled",2)
        else
           Notify("Aim Camera","Disabled",2)
        end
    end
})

Tab:CreateToggle({
    Name = "Aim Character",
    CurrentValue = false, --- Valor inicial
    Callback = function(State)
        Config.AimCharacter = State

        if State then
          Notify("Aim Character","Enabled",2)
        else
           Notify("Aim Character","Disabled",2)
        end
    end
})

Tab:CreateToggle({
    Name = "Only in camera",
    CurrentValue = false, --- Valor inicial
    Callback = function(State)
        Config.OnlyInCamera = State

        if State then
          Notify("Only in camera","Enabled",2)
        else
           Notify("Only in camera","Disabled",2)
        end
    end
})

Tab:CreateToggle({
    Name = "Ignore Dead",
    CurrentValue = false, --- Valor inicial
    Callback = function(State)
        Config.IgnoreDead = State

        if State then
          Notify("Ignore Dead","Enabled",2)
        else
           Notify("Ignore Dead","Disabled",2)
        end
    end
})

Tab:CreateToggle({
    Name = "Prediction",
    CurrentValue = false, --- Valor inicial
    Callback = function(State)
        Config.Prediction = State

        if State then
          Notify("Prediction","Enabled",2)
        else
           Notify("Prediction","Disabled",2)
        end
    end
})

Tab:CreateSlider({
    Name = "Prediction Amount",
    Range = {0, 1}, --- Mínimo y máximo
    Increment = 0.01, --- De cuánto en cuánto cambia
    Suffix = "", --- Texto después del valor
    CurrentValue = 0, --- Valor inicial
    Callback = function(Value)
        Config.PredictionAmount = Value
    end
})

Tab:CreateSlider({
    Name = "Smoothness",
    Range = {0, 1}, --- Mínimo y máximo
    Increment = 0.01, --- De cuánto en cuánto cambia
    Suffix = "", --- Texto después del valor
    CurrentValue = 1, --- Valor inicial
    Callback = function(Value)
        Config.Smoothness = Value
    end
})

Tab:CreateDropdown({
    Name = "Target Part",
    Options = {"Head","HumanoidRootPart"},
    Callback = function(Option)
      Notify("Advertisement","Target Part: "..Option.." Selected",3)
        Config.TargetPart = Option
    end
})

UserInputService.InputBegan:Connect(function(Input,Game)
  if Game then
    return
  end

  local KeyCode = Enum.KeyCode[string.upper(Config.AimKeybind)]

  if KeyCode and Input.KeyCode == KeyCode then
    Config.Enabled = not Config.Enabled

    if Config.Enabled then
      EnableAimbot()
    end
  end
end) 