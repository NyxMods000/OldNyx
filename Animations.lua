--//Variables
local NyxModsUniversal = getgenv().NyxModsUniversal
local HttpService = game:GetService("HttpService")
local Window = NyxModsUniversal.Window
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Client = Players.LocalPlayer

local RobloxAnimationsApi = "https://pastebin.com/raw/14q07TEP"
local CommunityAnimationsApi = "https://pastebin.com/raw/KGK2inGd"

local Config = {
  AnimationsLoaded = false,
  AnimationSelected = nil,
  Animations = {},
  CharacterAddedConnection = nil,
}

local Order = {
  "idle1",
  "idle2",
  "walk",
  "run",
  "jump",
  "fall",
  "climb",
}

local Tab = Window:CreateTab("Animation packs")

function SetAnimation()
  if Config.AnimationSelected then
          local AnimationData = Config.Animations[Config.AnimationSelected]
          if AnimationData then
            local Character = Client and Client.Character or Client.CharacterAdded:Wait()
            if Character then
              local Animate = Character:FindFirstChild("Animate") or Character:WaitForChild("Animate")
              if Animate then
                  local ClearedIdle = false
                for AnimationType,Id in pairs(AnimationData) do
                    if tostring(AnimationType):lower():find("idle") then
                        local AnimationName = AnimationType == "idle1" and "Animation1" or AnimationType == "idle2" and "Animation2"
                        local IdleFolder = Animate:FindFirstChild("idle")
                        if IdleFolder then
                            if not ClearedIdle then
                                IdleFolder:ClearAllChildren()
                                ClearedIdle = true
                            end
                            local Animation = Instance.new("Animation")
                            Animation.AnimationId = Id
                            Animation.Name = AnimationName
                            Animation.Parent = IdleFolder
                            
                            local Weight = Instance.new("NumberValue")
                            Weight.Name = "Weight"
                            Weight.Value = AnimationName == "Animation1" and 9 or AnimationName == "Animation2" and 1
                            Weight.Parent = Animation
                        end
                    else
                        local AnimationFolder = Animate:FindFirstChild(tostring(AnimationType))
                        if AnimationFolder then
                            AnimationFolder:ClearAllChildren()
                            
                            local Animation = Instance.new("Animation")
                            Animation.AnimationId = Id
                            Animation.Name = "Animation"
                            Animation.Parent = AnimationFolder
                        end
                    end
                end
              end
            end
          end
        end
end

local function LoadAnimations()
  local Table = {}
  local RobloxSection = Tab:CreateSection("Animations")
  local RobloxTable = HttpService:JSONDecode(game:HttpGet(RobloxAnimationsApi))

  if RobloxTable then
    for Name,Data in pairs(RobloxTable) do
      Table[Name] = Data
    end
  end

  local CommunityTable = HttpService:JSONDecode(game:HttpGet(CommunityAnimationsApi))

  if CommunityTable then
    for Name,Data in pairs(CommunityTable) do
      Table[Name] = Data
    end
  end

  for AnimationName,Data in pairs(Table) do
    if not AnimationName:lower():find("joao") then
    Tab:CreateButton({
    Name = AnimationName,
    Callback = function()
      Config.AnimationSelected = AnimationName
      SetAnimation()
    end
    })
    end
  end

  Config.Animations = Table
  Config.AnimationsLoaded = true
end

--- Botón que ejecuta script externo
Tab:CreateButton({
    Name = "Load Animations",
    Callback = function()
      if not Config.AnimationsLoaded then
        LoadAnimations()
      end
    end
})

Client.CharacterAdded:Connect(function()
  SetAnimation()
end)