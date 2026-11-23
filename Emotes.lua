--//Variables
local NyxModsUniversal = getgenv().NyxModsUniversal
local HttpService = game:GetService("HttpService")
local Window = NyxModsUniversal.Window
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Client = Players.LocalPlayer

local Config = {
  EmotesLoaded = false,
  EmoteSpeed = 1,
  EmoteSelected = nil,
  CurrentTrack = nil,
  EmotesTable = {},
  StopPlayLastEmoteKeybind = "X",
}

local EmotesApi = "https://pastebin.com/raw/h4981hMA"

local Tab = Window:CreateTab("Emotes")

function StopAllAnimations()
  local Character = Client and Client.Character
  if Character then
    local Humanoid = Character and Character:FindFirstChild("Humanoid")
    if Humanoid then
      local Animator = Humanoid and Humanoid:FindFirstChild("Animator") or Humanoid
      if Animator then
        for i,Track in ipairs(Animator:GetPlayingAnimationTracks()) do
          Track:Stop()
        end
      end
    end
  end
end

function PlayEmote()
  local Character = Client and Client.Character
  if Character then
    local Humanoid = Character and Character:FindFirstChild("Humanoid")
    if Humanoid then
      local Animator = Humanoid and Humanoid:FindFirstChild("Animator") or Humanoid
      if Animator then
        local Name = Config.EmoteSelected
        if Name then
          local Id = Config.EmotesTable[Name]
          if Id then
            StopAllAnimations()

            local Animation = Instance.new("Animation")
            Animation.AnimationId = Id

            local Track = Animator:LoadAnimation(Animation)
            Track.Priority = Enum.AnimationPriority.Action4
            Track:Play()
            
            Config.CurrentTrack = Track
          end
        end
      end
    end
  end
end

function LoadEmotes()
  local Table = {}
  local Section = Tab:CreateSection("Emotes")
  local EmotesTable = HttpService:JSONDecode(game:HttpGet(EmotesApi))

  if EmotesTable then
    for i,Data in ipairs(EmotesTable) do
      local Name = Data["name"]
      local Id = Data["animationid"]

      Table[Name] = Id
    end
  end

  for Name,Id in pairs(Table) do
    Tab:CreateButton({
    Name = Name,
    Callback = function()
      Config.EmoteSelected = Name
      PlayEmote()
    end
    })
  end

  Config.EmotesLoaded = true
  Config.EmotesTable = Table
end

Tab:CreateButton({
    Name = "Load Emotes",
    Callback = function()
      if not Config.EmotesLoaded then
        LoadEmotes()
      end
    end
})

Tab:CreateSlider({
    Name = "Emote speed",
    Range = {0, 10}, --- Mínimo y máximo
    Increment = 0.1, --- De cuánto en cuánto cambia
    Suffix = "", --- Texto después del valor
    CurrentValue = 1, --- Valor inicial
    Callback = function(Value)
        Config.EmoteSpeed = Value
    end
})

Tab:CreateButton({
    Name = "Stop emote",
    Callback = function()
      if Config.CurrentTrack then
        Config.CurrentTrack:Stop()
      end
    end
})

Tab:CreateButton({
    Name = "Play last emote",
    Callback = function()
      if Config.CurrentTrack then
        Config.CurrentTrack:Play()
      end
    end
})
 
local PlayEmoteFloatButton = Tab:CreateButtonFloat({
    Name     = "Play last emote",
    Width    = 110,
    Height   = 42,
    X        = 0.5,    --- centro horizontal
    Y        = 0.5,    --- abajo
    Draggable = true,  --- el usuario puede moverlo
    Callback = function()
        if Config.CurrentTrack then
          Config.CurrentTrack:Play()
        end
    end
})

local StopEmoteFloatButton = Tab:CreateButtonFloat({
    Name     = "Stop emote",
    Width    = 110,
    Height   = 42,
    X        = 0.6,    --- centro horizontal
    Y        = 0.5,    --- abajo
    Draggable = true,  --- el usuario puede moverlo
    Callback = function()
        if Config.CurrentTrack then
          Config.CurrentTrack:Stop()
        end
    end
})

PlayEmoteFloatButton:Hide()
StopEmoteFloatButton:Hide()

Tab:CreateToggle({
    Name = "Play/Stop Emote Floating Buttons",
    CurrentValue = false, --- Valor inicial
    Callback = function(State)
        PlayEmoteFloatButton:SetVisible(State)
        StopEmoteFloatButton:SetVisible(State)
    end
})

Tab:CreateInput({
    Name = "Play/Stop Emote Keybind",
    PlaceholderText = "Enter keybind",
    Callback = function(Text)
        Config.StopPlayLastEmoteKeybind = string.upper(Text)
    end
})

RunService.Heartbeat:Connect(function()
  if Config.EmotesLoaded then
    if Config.EmoteSelected then
      if Config.CurrentTrack then
        Config.CurrentTrack:AdjustSpeed(Config.EmoteSpeed)
      end
    else
      return
    end
  else
    return
  end
end)


local Played = false

UserInputService.InputBegan:Connect(function(Input,Game)
  if Game then
    return
  end
  
  local KeyCode = Enum.KeyCode[string.upper(Config.StopPlayLastEmoteKeybind)]
  
  if Input.KeyCode == KeyCode then
    if Config.CurrentTrack then
      if Played then
        Config.CurrentTrack:Play()
        Played = true
      else
        Config.CurrentTrack:Stop()
        Played = false
      end
    end
  end
end)