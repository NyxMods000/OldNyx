--//Variables
local NyxModsUniversal = getgenv().NyxModsUniversal
local Window = NyxModsUniversal.Window
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Client = Players.LocalPlayer

local Config = {
  Enabled = false,
  Size = 10,
  Transparency = 0.5,
  Color = Color3.fromRGB(0,0,0),
  Shape = "Block", --// Ball
  Part = "HumanoidRootPart", --// or 
  DefaultHumanoidRootPartShape = nil,
  DefaultHumanoidRootPartColor = nil,
  DefaultHumanoidRootPartSize = nil,
  DefaultHumanoidRootPartTransparency = nil,
}

local Tab = Window:CreateTab("Hitbox")
local Section = Tab:CreateSection("Options")

function RestoreHitbox()
  for i,Player in ipairs(Players:GetPlayers()) do
        if Player ~= Client then
          local Character = Player and Player.Character
          if Character then
            local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
            local TargetPart = Character and Character:FindFirstChild(Config.Part)
            if HumanoidRootPart and TargetPart then
              if Config.DefaultHumanoidRootPartShape then
                HumanoidRootPart.Shape = Config.DefaultHumanoidRootPartShape
              end
              if Config.DefaultHumanoidRootPartColor then
                HumanoidRootPart.Color = Config.DefaultHumanoidRootPartColor
              end
              if Config.DefaultHumanoidRootPartSize then
                HumanoidRootPart.Size = Config.DefaultHumanoidRootPartSize
              end
              if Config.DefaultHumanoidRootPartTransparency then
                HumanoidRootPart.Transparency = Config.DefaultHumanoidRootPartTransparency
              end
            end
          end
        end
      end
end

function Hitbox()
  task.spawn(function()
    while true do
      if not Config.Enabled then
        RestoreHitbox()
        break
      end
      for i,Player in ipairs(Players:GetPlayers()) do
        if Player ~= Client then
          local Character = Player and Player.Character
          if Character then
            local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
            local TargetPart = Character and Character:FindFirstChild(Config.Part)
            if HumanoidRootPart and TargetPart then

              if not Config.DefaultHumanoidRootPartShape then
                 Config.DefaultHumanoidRootPartShape = HumanoidRootPart.Shape
              end
              if not Config.DefaultHumanoidRootPartColor then
                Config.DefaultHumanoidRootPartColor = HumanoidRootPart.Color
              end
              if not Config.DefaultHumanoidRootPartSize then
                Config.DefaultHumanoidRootPartSize = HumanoidRootPart.Size
              end
              if not Config.DefaultHumanoidRootPartTransparency then
                Config.DefaultHumanoidRootPartTransparency = HumanoidRootPart.Transparency
              end

              TargetPart.Size = Vector3.new(Config.Size,Config.Size,Config.Size)
              TargetPart.Transparency = Config.Transparency
              TargetPart.Color = Config.Color
              TargetPart.Shape = Enum.PartType[Config.Shape]
              TargetPart.CanCollide = false

            end
          end
        end
      end
      task.wait(0.01)
    end
  end)
end

Tab:CreateToggle({
    Name = "Enable Hitbox",
    CurrentValue = false,
    Callback = function(State)
      Config.Enabled = State
      if State then
      Hitbox()
      end
    end
})

Tab:CreateSlider({
    Name = "Hitbox size",
    Range = {0, 100}, --- Mínimo y máximo
    Increment = 0.1, --- De cuánto en cuánto cambia
    Suffix = "Size", --- Texto después del valor
    CurrentValue = 10, --- Valor inicial
    Callback = function(Value)
      Config.Size = Value
    end
})

Tab:CreateSlider({
    Name = "Hitbox Transparency",
    Range = {0, 1}, --- Mínimo y máximo
    Increment = 0.1, --- De cuánto en cuánto cambia
    Suffix = "Transparency", --- Texto después del valor
    CurrentValue = 0.5, --- Valor inicial
    Callback = function(Value)
      Config.Transparency = Value
    end
})

Tab:CreateColorPicker({
    Name = "Hitbox color",
    Color = Color3.fromRGB(255, 0, 0),
    Callback = function(Color)
      Config.Color = Color
    end
})

Tab:CreateDropdown({
    Name = "Hitbox shape",
    Options = {
      "Block",
      "Ball",
    },
    Callback = function(Option)
        Config.Shape = Option
    end
})