
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
  Fullbright = {
    Enabled = false,
    DefaultBrightness = nil,
    DefaultGlobalShadows = nil,
    Brightness = nil,
  },
  Ambient = {
    Enabled = false,
    Color = nil,
    DefaultColor = nil,
  },
  OutdoorAmbient = {
    Enabled = false,
    Color = nil,
    DefaultColor = nil,
  },
  RemoveFog = {
    DefaultFogStart = nil,
    DefaultFogEnd = nil,
  },
  ClockTime = {
    Enabled = false,
    Time = nil,
    DefaultTime = nil,
  },
  Contrast = {
    Enabled = false,
    Contrast = nil,
    DefaultContrast = nil,
    CreatedByScript = false,
  },
  Xray = {
    DefaultTransparency = {},
  },
  FakeKorblox = {
    Enabled = false,
    Parts = {
      RightUpperLeg = {
        OriginalMeshId = nil,
        OriginalTextureId = nil,
        KorbloxMeshId = "https://assetdelivery.roblox.com/v1/asset/?id=9598310133",
        KorbloxTextureId = "https://www.roblox.com/asset/?id=902843398",
      },
      RightLowerLeg = {
        OriginalMeshId = nil,
        KorbloxMeshId = "https://assetdelivery.roblox.com/v1/asset/?id=9598310138",
      },
      RightFoot = {
        OriginalMeshId = nil,
        KorbloxMeshId = "https://assetdelivery.roblox.com/v1/asset/?id=9598310128",
      },
    }
  },
  FakeHeadless = {
    Enabled = false,
    OriginalTransparency = nil,
  }
}

 


--//Functions

local function Fullbright()

task.spawn(function()
  while true do
  if Config.Fullbright.Enabled then
    if not Config.Fullbright.DefaultBrightness then
      Config.Fullbright.DefaultBrightness = Lighting.Brightness
    end
    if not Config.Fullbright.DefaultGlobalShadows then
      Config.Fullbright.DefaultGlobalShadows = Lighting.GlobalShadows
    end
    Lighting.Brightness = tonumber(Config.Fullbright.Brightness) or Config.Fullbright.DefaultBrightness or 1
    Lighting.GlobalShadows = false
  else

    if Config.Fullbright.DefaultBrightness then
      Lighting.Brightness = Config.Fullbright.DefaultBrightness
    end

    if Config.Fullbright.DefaultGlobalShadows then
      Lighting.GlobalShadows = Config.Fullbright.DefaultGlobalShadows
    end

    break
  end
  task.wait(0.01)
  end
end)

end

local function AmbientColor()
  task.spawn(function()
    while true do
      if Config.Ambient.Enabled then
        if not Config.Ambient.DefaultColor then
          Config.Ambient.DefaultColor = Lighting.Ambient
        end
        Lighting.Ambient = Config.Ambient.Color or Color3.fromRGB(0,0,0)
      else
        if Config.Ambient.DefaultColor then
          Lighting.Ambient = Config.Ambient.DefaultColor
        end
        break
      end
      task.wait(0.01)
    end
  end)
end

local function OutdoorAmbientColor()
  task.spawn(function()
    while true do
      if Config.OutdoorAmbient.Enabled then
        if not Config.OutdoorAmbient.DefaultColor then
          Config.OutdoorAmbient.DefaultColor = Lighting.OutdoorAmbient
        end
        Lighting.OutdoorAmbient = Config.OutdoorAmbient.Color or Color3.fromRGB(0,0,0)
      else
        if Config.OutdoorAmbient.DefaultColor then
          Lighting.OutdoorAmbient = Config.OutdoorAmbient.DefaultColor
        end
        break
      end
      task.wait(0.01)
    end
  end)
end

local function RemoveFog(State)
  if not Config.RemoveFog.DefaultFogStart then
    Config.RemoveFog.DefaultFogStart = Lighting.FogStart
  end
  if not Config.RemoveFog.DefaultFogEnd then
    Config.RemoveFog.DefaultFogEnd = Lighting.FogEnd
  end

  if State then
    Lighting.FogStart = 10000000
    Lighting.FogEnd = 10000000
  else
    Lighting.FogStart = Config.RemoveFog.DefaultFogStart or 0
    Lighting.FogEnd = Config.RemoveFog.DefaultFogEnd or 2000
  end

end

local function ClockTime()
  task.spawn(function()
    while true do
      if Config.ClockTime.Enabled then
        if not Config.ClockTime.DefaultTime then
          Config.ClockTime.DefaultTime = Lighting.ClockTime
        end
        Lighting.ClockTime = Config.ClockTime.Time
      else
        if Config.ClockTime.DefaultTime then
          Lighting.ClockTime = Config.ClockTime.DefaultTime
        end
        break
      end
      task.wait(0.01)
    end
  end)
end

local function Contrast()
  task.spawn(function()
    while true do
      if Config.Contrast.Enabled then
        if Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect") then
          local ColorCorrectionEffect = Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect")

          if not Config.Contrast.DefaultContrast and not Config.Contrast.CreatedByScript then
            Config.Contrast.DefaultContrast = ColorCorrectionEffect.Contrast
          end

          ColorCorrectionEffect.Contrast = Config.Contrast.Contrast
        else
          local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect")
          ColorCorrectionEffect.Parent = Lighting

          Config.Contrast.CreatedByScript = true

          ColorCorrectionEffect.Contrast = Config.Contrast.Contrast
        end
      else
        if not Config.Contrast.CreatedByScript then
          if Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect") then
            local ColorCorrectionEffect = Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect")

            ColorCorrectionEffect.Contrast = Config.Contrast.DefaultContrast
          end
        else
          if Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect") then
            local ColorCorrectionEffect = Lighting:FindFirstChildWhichIsA("ColorCorrectionEffect")

            ColorCorrectionEffect:Destroy()
            Config.Contrast.CreatedByScript = false
          end
        end
        break
      end
      task.wait(0.01)
    end
  end)
end

local function Xray(State)
  if State then
    for i,v in ipairs(Workspace:GetDescendants()) do
      if v:IsA("BasePart") then
        if not Config.Xray.DefaultTransparency[v] then
          Config.Xray.DefaultTransparency[v] = v.Transparency
        end
        v.Transparency = 0.6
      end
    end
  else
    for i,v in ipairs(Workspace:GetDescendants()) do
      if v:IsA("BasePart") then
        if Config.Xray.DefaultTransparency[v] then
          v.Transparency = Config.Xray.DefaultTransparency[v]
        else
          v.Transparency = 0
        end
      end
    end
  end
end

local function SetUpFakeKorblox()
  local Character = Client.Character
  if Character then
    for PartName,Table in pairs(Config.FakeKorblox.Parts) do
      print("1")
      local Part = Character:FindFirstChild(PartName)
      if Part then
        print("2")
        if not Table.OriginalMeshId then
          Config.FakeKorblox.Parts[PartName].OriginalMeshId = Part.MeshId
        end
        print("3")
        if not Table.OriginalTextureId then
          Config.FakeKorblox.Parts[PartName].OriginalTextureId = Part.TextureID
        end
        print("4")
        if Table.KorbloxMeshId then
          Part.MeshId = Table.KorbloxMeshId
        end
        print("5")
        if Table.KorbloxTextureId then
          Part.TextureID = Table.KorbloxTextureId
        end
        print("6")
        if PartName == "RightLowerLeg" or PartName == "RightFoot" then
          Part.Transparency = 1
        end
        print("7")
        
      end
    end
  end
end

local function SetDownFakeKorblox()
  local Character = Client.Character
  if Character then
    for PartName,Table in pairs(Config.FakeKorblox.Parts) do
      local Part = Character:FindFirstChild(PartName)
      if Part then
        if Table.OriginalMeshId then
          Part.MeshId = Config.FakeKorblox.Parts[PartName].OriginalMeshId
        end
        if Table.OriginalTextureId then
          Part.TextureID = Config.FakeKorblox.Parts[PartName].OriginalTextureId
        end
        Part.Transparency = 0
      end
    end
  end
end

local function SetUpFakeHeadless()
  local Character = Client.Character
  if Character then
    local Head = Character:FindFirstChild("Head")
    if Head then
      if not Config.FakeHeadless.OriginalTransparency then
        Config.FakeHeadless.OriginalTransparency = Head.Transparency
      end
      Head.Transparency = 1
    end
  end
end

local function SetDownFakeHeadless()
  local Character = Client.Character
  if Character then
    local Head = Character:FindFirstChild("Head")
    if Head then
      if Config.FakeHeadless.OriginalTransparency then
        Head.Transparency = Config.FakeHeadless.OriginalTransparency
      end
    end
  end
end

--//Library
local Tab = Window:CreateTab("Visuals")
local Section = Tab:CreateSection("World / Lighting")

Tab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Callback = function(State)
      Config.Fullbright.Enabled = State
      Fullbright()
    end
})

Tab:CreateSlider({
    Name = "Fullbright Value",
    Range = {0, 100}, --- Mínimo y máximo
    Increment = 1, --- De cuánto en cuánto cambia
    Suffix = "Brightness", --- Texto después del valor
    CurrentValue = 1, --- Valor inicial
    Callback = function(Value)
      Config.Fullbright.Brightness = Value
    end
})

Tab:CreateToggle({
    Name = "Ambient Color",
    CurrentValue = false,
    Callback = function(State)
      Config.Ambient.Enabled = State
      AmbientColor()
    end
})

Tab:CreateColorPicker({
    Name = "Ambient Color Value",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(Color)
      Config.Ambient.Color = Color
    end
})

Tab:CreateToggle({
    Name = "OutdoorAmbient Color",
    CurrentValue = false,
    Callback = function(State)
      Config.OutdoorAmbient.Enabled = State
      OutdoorAmbientColor()
    end
})

Tab:CreateColorPicker({
    Name = "OutdoorAmbient Color Value",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(Color)
      Config.OutdoorAmbient.Color = Color
    end
})

Tab:CreateToggle({
    Name = "Remove Fog",
    CurrentValue = false,
    Callback = function(State)
      RemoveFog(State)
    end
})

Tab:CreateToggle({
    Name = "Clock Time",
    CurrentValue = false,
    Callback = function(State)
      Config.ClockTime.Enabled = State
      ClockTime()
    end
})

Tab:CreateSlider({
    Name = "Clock Time Value",
    Range = {0, 24}, --- Mínimo y máximo
    Increment = 0.01, --- De cuánto en cuánto cambia
    Suffix = "Brightness", --- Texto después del valor
    CurrentValue = 1, --- Valor inicial
    Callback = function(Value)
      Config.ClockTime.Time = Value
    end
})

Tab:CreateToggle({
    Name = "Contrast",
    CurrentValue = false,
    Callback = function(State)
      Config.Contrast.Enabled = State
      Contrast()
    end
})

Tab:CreateSlider({
    Name = "Contrast Value",
    Range = {0, 20}, --- Mínimo y máximo
    Increment = 0.01, --- De cuánto en cuánto cambia
    Suffix = "Contrast", --- Texto después del valor
    CurrentValue = 1, --- Valor inicial
    Callback = function(Value)
      Config.Contrast.Contrast = Value
    end
})

Tab:CreateToggle({
    Name = "Xray",
    CurrentValue = false,
    Callback = function(State)
      Xray(State)
    end
})

local CharacterSection = Tab:CreateSection("Character")

Tab:CreateToggle({
    Name = "Fake Korblox",
    CurrentValue = false,
    Callback = function(State)
      Config.FakeKorblox.Enabled = State
      if State then
        SetUpFakeKorblox()
      else
        SetDownFakeKorblox()
      end
    end
})

Tab:CreateToggle({
    Name = "Fake Headless",
    CurrentValue = false,
    Callback = function(State)
      Config.FakeHeadless.Enabled = State
      if State then
        SetUpFakeHeadless()
      else
        SetDownFakeHeadless()
      end
    end
})

--//Events
Client.CharacterAdded:Connect(function()
  if Config.FakeKorblox.Enabled then
    local Character = Client.Character
    if Character then
      local RightUpperLeg = Character:FindFirstChild("RightUpperLeg") or Character:WaitForChild("RightUpperLeg")
      if RightUpperLeg then
        SetUpFakeKorblox()
      end
    end
  end
  if Config.FakeHeadless.Enabled then
    local Character = Client.Character
    if Character then
      local Head = Character:FindFirstChild("Head") or Character:WaitForChild("Head")
      if Head then
        SetUpFakeHeadless()
      end
    end
  end
end)

--//Loops