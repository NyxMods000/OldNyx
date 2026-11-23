--//Variables
local NyxModsUniversal = getgenv().NyxModsUniversal
local Window = NyxModsUniversal.Window
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Client = Players.LocalPlayer

local Config = {
  Esp = {
    Enabled = false,

    Name = false,
    DisplayName = false,
    Health = false,
    Distance = false,
    TextColor = Color3.fromRGB(255,255,255),

    Box = false,
    BoxColor = Color3.fromRGB(255,255,255),

    Line = false,
    LinePosition = "Top", --// Bottom, Middle, Top,
    LineColor = Color3.fromRGB(255,255,255),

    Chams = false,
    ChamsFillColor = Color3.fromRGB(255,255,255),
    ChamsOutlineColor = Color3.fromRGB(255,255,255),

    ExcludeClient = false,

    Objects = {},
  }
}

local function GetPlayersDistance(A,B)
  if A and B then
    local CharacterA = A.Character
    local CharacterB = B.Character
    if CharacterA and CharacterB then
      local HumanoidRootPartA = CharacterA:FindFirstChild("HumanoidRootPart")
      local HumanoidRootPartB = CharacterB:FindFirstChild("HumanoidRootPart")
      if HumanoidRootPartA and HumanoidRootPartB then
        return math.floor((HumanoidRootPartA.Position - HumanoidRootPartB.Position).Magnitude)
      end
    end
  end
  return 0
end

local function CreateDrawingInstance(InstanceName,Properties)
  local Instance = Drawing.new(InstanceName)

  if Instance then
    for Propertie,Value in pairs(Properties) do
      pcall(function()
        Instance[Propertie] = Value
      end)
    end
  end

  return Instance
end

local function CreateInstance(InstanceName,Properties)
  local Instance = Instance.new(InstanceName)

  if Instance then
    for Propertie,Value in pairs(Properties) do
      pcall(function()
        Instance[Propertie] = Value
      end)
    end
  end

  return Instance
end

local function CreateEsp(Player)
  local Line = CreateDrawingInstance("Line",{
    Thickness = 1,
    From = Vector2.new(0.5,0)
  })

  local Box = CreateDrawingInstance("Square",{
    Filled = false,
    Thickness = false,
  })

  local Text = CreateDrawingInstance("Text",{

  })

  local Chams = CreateInstance("Highlight",{
    Parent = Workspace,
    Name = "Chams",
    Enabled = false,
    Adornee = nil,
  })

  local Esp = {
    Text = Text,
    Box = Box,
    Line = Line,
    Chams = Chams,
  }

  Config.Esp.Objects[Player] = Esp
  return
end

local function RemoveEsp(Player)
  if Config.Esp.Objects[Player] then

    if Config.Esp.Objects[Player].Text then
      Config.Esp.Objects[Player].Text:Remove()
      Config.Esp.Objects[Player].Text = nil
    end

    if Config.Esp.Objects[Player].Box then
      Config.Esp.Objects[Player].Box:Remove()
      Config.Esp.Objects[Player].Box = nil
    end

    if Config.Esp.Objects[Player].Line then
      Config.Esp.Objects[Player].Line:Remove()
      Config.Esp.Objects[Player].Line = nil
    end

    if Config.Esp.Objects[Player].Chams then
      Config.Esp.Objects[Player].Chams:Destroy()
      Config.Esp.Objects[Player].Chams = nil
    end

  end
end

local function OnPlayerAdded(Player)
  CreateEsp(Player)
end

local function OnPlayerRemoving(Player)
  RemoveEsp(Player)
end

local function UpdateEsp()
  for i,Player in ipairs(Players:GetPlayers()) do
    if Config.Esp.Objects[Player] then
      local Camera = Workspace.CurrentCamera
      local Esp = Config.Esp.Objects[Player]

      local Text = Esp.Text
      local Box = Esp.Box
      local Line = Esp.Line
      local Chams = Esp.Chams

      if Config.Esp.ExcludeClient and Player == Client then
        Text.Visible = false
        Box.Visible = false
        Line.Visible = false
        Chams.Enabled = false
        Chams.Adornee = nil
        continue
      end

      local SomeTextActive = Config.Esp.Name or Config.Esp.DisplayName or Config.Esp.Health or Config.Esp.Distance
      local BoxActive = Config.Esp.Box
      local LineActive = Config.Esp.Line
      local ChamsActive = Config.Esp.Chams

      if not SomeTextActive then
        Text.Visible = false
      end
      if not BoxActive then
        Box.Visible = false
      end
      if not LineActive then
        Line.Visible = false
      end
      if not ChamsActive then
        Chams.Enabled = false
        Chams.Adornee = nil
      end
      if not SomeTextActive and not BoxActive and not LineActive and not ChamsActive then
        continue
      end
      if not Config.Esp.Enabled then
        Text.Visible = false
        Box.Visible = false
        Line.Visible = false
        Chams.Enabled = false
        Chams.Adornee = nil
        continue
      end

      local Character = Player.Character
      if Character then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        local Head = Character:FindFirstChild("Head")
        local Humanoid = Character:FindFirstChild("Humanoid")

        if SomeTextActive then
          local Offset = 0

          if Config.Esp.Name then Offset = Offset + 1 end
          if Config.Esp.DisplayName then Offset = Offset + 1 end
          if Config.Esp.Health then Offset = Offset + 1 end
          if Config.Esp.Distance then Offset = Offset + 1 end

          if Head then
            local Head3D, OnScreen = Camera:WorldToViewportPoint(Head.Position + Vector3.new(0,Offset,0))

            if Head3D and OnScreen then
              local Head2D = Vector2.new(Head3D.X,Head3D.Y)

              local Content = ""
              if Config.Esp.Name then 
                if Content ~= "" then
                  Content = Content.."\n"
                end
                Content = Content.."Name: "..Player.Name
              end
              if Config.Esp.DisplayName then 
                if Content ~= "" then
                  Content = Content.."\n"
                end
                Content = Content.."DisplayName: "..Player.DisplayName
              end
              if Config.Esp.Health then 
                if Content ~= "" then
                  Content = Content.."\n"
                end
                if Humanoid then
                  Content = Content.."Health: "..Humanoid.Health
                else
                  Content = Content.."Health: ".."Health not found"
                end
              end
              if Config.Esp.Distance then 
                if Content ~= "" then
                  Content = Content.."\n"
                end
                Content = Content.."Distance: "..tostring(GetPlayersDistance(Client,Player))
              end

              local Distance = (Camera.CFrame.Position - Head3D).Magnitude
              local MinSize = 10
              local MaxSize = 25
              local MaxDistance = 100

              local Scale = 1 - math.clamp(Distance / MaxDistance,0,1)

              Text.Text = Content
              Text.Visible = true
              Text.Color = Config.Esp.TextColor
              Text.Position = Head2D
              Text.TextSize = MinSize + (MaxSize - MinSize) * Scale
              Text.Center = true
              else
                Text.Visible = false
            end
            else
              Text.Visible = false
          end
        end

        if BoxActive then
          if Head and HumanoidRootPart then
            local Head3D, OnScreen = Camera:WorldToViewportPoint(Head.Position)
            local HumanoidRootPart3D = Camera:WorldToViewportPoint(HumanoidRootPart.Position)
            if Head3D and HumanoidRootPart3D and OnScreen then
              local Head2D = Vector2.new(Head3D.X,Head3D.Y)
              local HumanoidRootPart2D = Vector2.new(HumanoidRootPart3D.X,HumanoidRootPart3D.Y)

              local Distance = (Head2D - HumanoidRootPart2D).Magnitude
              local MaxSize = 100
              
              local Size = math.clamp(Distance,1,MaxSize)
              
              Box.Size = Vector2.new(Size * 2,Size * 4)
              Box.Position = HumanoidRootPart2D - (Box.Size / 2)
              Box.Visible = true
              Box.Color = Config.Esp.BoxColor
              else
                Box.Visible = false
            end
            else
              Box.Visible = false
          end
        end

        if LineActive then
          if HumanoidRootPart then
            local HumanoidRootPart3D, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart.Position)
            if HumanoidRootPart3D and OnScreen then
              local HumanoidRootPart2D = Vector2.new(HumanoidRootPart3D.X,HumanoidRootPart3D.Y)
              local ViewportSize = Camera.ViewportSize

              if Config.Esp.LinePosition == "Top" then
                Line.From = Vector2.new(ViewportSize.X / 2,0)
              elseif Config.Esp.LinePosition == "Middle" then
                Line.From = Vector2.new(ViewportSize.X / 2,ViewportSize.Y / 2)
              elseif Config.Esp.LinePosition == "Bottom" then
                Line.From = Vector2.new(ViewportSize.X / 2,ViewportSize.Y)
              end

              Line.Visible = true
              Line.Color = Config.Esp.LineColor
              Line.To = HumanoidRootPart2D
              else
                Line.Visible = false
            end
            else
              Line.Visible = false
          end
        end

        if ChamsActive then
          Chams.Enabled = true
          Chams.Adornee = Character
          Chams.OutlineColor = Config.Esp.ChamsOutlineColor
          Chams.FillColor = Config.Esp.ChamsFillColor
        end

      end

    end
  end
end

local Tab = Window:CreateTab("Esp")
local Section = Tab:CreateSection("Toggle Esp")

Tab:CreateToggle({
    Name = "Enable Esp",
    CurrentValue = false, --- Valor inicial
    Callback = function(State)
        Config.Esp.Enabled = State
    end
})

local Section2 = Tab:CreateSection("Esp Config")

Tab:CreateToggle({
    Name = "Exclude Client",
    CurrentValue = false, --- Valor inicial
    Callback = function(State)
        Config.Esp.ExcludeClient = State
    end
})

Tab:CreateToggle({
    Name = "Enable Name",
    CurrentValue = false, --- Valor inicial
    Callback = function(State)
        Config.Esp.Name = State
    end
})

Tab:CreateToggle({
    Name = "Enable DisplayName",
    CurrentValue = false, --- Valor inicial
    Callback = function(State)
        Config.Esp.DisplayName = State
    end
})

Tab:CreateToggle({
    Name = "Enable Health",
    CurrentValue = false, --- Valor inicial
    Callback = function(State)
        Config.Esp.Health = State
    end
})

Tab:CreateToggle({
    Name = "Enable Distance",
    CurrentValue = false, --- Valor inicial
    Callback = function(State)
        Config.Esp.Distance = State
    end
})

Tab:CreateColorPicker({
    Name = "Text Color",
    Color = Color3.fromRGB(255, 255, 255), --- Color inicial
    Callback = function(Color)
        Config.Esp.TextColor = Color
    end
})

Tab:CreateToggle({
    Name = "Enable Box",
    CurrentValue = false, --- Valor inicial
    Callback = function(State)
        Config.Esp.Box = State
    end
})

Tab:CreateColorPicker({
    Name = "Box Color",
    Color = Color3.fromRGB(255, 255, 255), --- Color inicial
    Callback = function(Color)
        Config.Esp.BoxColor = Color
    end
})

Tab:CreateToggle({
    Name = "Enable Line",
    CurrentValue = false, --- Valor inicial
    Callback = function(State)
        Config.Esp.Line = State
    end
})

Tab:CreateDropdown({
    Name = "Line Position",
    Options = {"Top","Middle","Bottom"},
    Callback = function(Option)
        Config.Esp.LinePosition = Option
    end
})

Tab:CreateColorPicker({
    Name = "Line Color",
    Color = Color3.fromRGB(255, 255, 255), --- Color inicial
    Callback = function(Color)
        Config.Esp.LineColor = Color
    end
})

Tab:CreateToggle({
    Name = "Enable Chams",
    CurrentValue = false, --- Valor inicial
    Callback = function(State)
        Config.Esp.Chams = State
    end
})

Tab:CreateColorPicker({
    Name = "Chams Outline Color",
    Color = Color3.fromRGB(255, 255, 255), --- Color inicial
    Callback = function(Color)
        Config.Esp.ChamsOutlineColor = Color
    end
})

Tab:CreateColorPicker({
    Name = "Chams Fill Color",
    Color = Color3.fromRGB(255, 255, 255), --- Color inicial
    Callback = function(Color)
        Config.Esp.ChamsFillColor = Color
    end
})

for i,Player in ipairs(Players:GetPlayers()) do
  OnPlayerAdded(Player)
end

Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(OnPlayerRemoving)

RunService.RenderStepped:Connect(function()
  UpdateEsp()
end)