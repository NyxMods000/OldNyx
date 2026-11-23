if request then
    pcall(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/Loaderv2.lua"))()
    end)
end

pcall(function()
local function bypass_client_detections()
    -- Verifica que las funciones necesarias estén disponibles
    if typeof(filtergc) ~= "function"
        or typeof(debug) ~= "table"
        or typeof(debug.getupvalues) ~= "function" then

        return false, "filtergc no disponible"
    end

    -- Busca una función que contenga "gmatch" y "GetFullName"
    local success, detection_function = pcall(function()
        return filtergc("function", {
            Constants = {
                "gmatch",
                "GetFullName"
            }
        }, true)
    end)

    if not success or typeof(detection_function) ~= "function" then
        return false, "función de detección no encontrada"
    end

    -- Obtiene una función para modificar el metatable
    local set_metatable_function =
        (typeof(setrawmetatable) == "function" and setrawmetatable)
        or (typeof(setmetatable) == "function" and setmetatable)

    if not set_metatable_function then
        return false, "setmetatable no disponible"
    end

    local modified_tables = 0

    -- Obtiene los upvalues de la función encontrada
    local success_upvalues, upvalues =
        pcall(debug.getupvalues, detection_function)

    if not success_upvalues or typeof(upvalues) ~= "table" then
        return false, "no se pudieron obtener los upvalues"
    end

    -- Recorre los upvalues
    for _, value in pairs(upvalues) do
        if typeof(value) == "table" then

            local success_set = pcall(
                set_metatable_function,
                value,
                {
                    __newindex = function()
                        -- Bloquea nuevas asignaciones
                    end
                }
            )

            if success_set then
                modified_tables += 1
            end
        end
    end

    -- Devuelve si consiguió modificar al menos una tabla
    return modified_tables > 0, modified_tables
end


if game.PlaceId == 107778070777162 then
  local Bypass = bypass_client_detections()
   print(Bypass,"Bypassed")
end
end)




local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/pruebasjoao/test/refs/heads/main/JmodsLibV1.0'))()

function Notify(Title,Content,Time)
  Library:Notify({
    Title = Title,
    Content = Content,
    Duration = Time
})
end

getgenv().NyxModsUniversal = {
  Version = "0.1.2",
  Window = nil,
  TabsOrder = {
    "Home",
    "Movement",
    "Troll",
    "Emotes",
    "Animations",
    "Animations 2",
    "VoiceChat",
    "Visuals",
    "Esp",
    "NyxModsScripts",
    "Scripts",
    "Games",
    "Aimbot",
    "Hitbox",
    "Protections",
    "Misc",
    "Credits",
  },
  TabsUrl = {
    Home = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/Home.lua",
    Movement = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/Movement.lua",
    Troll = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/Troll.lua",
    Visuals = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/Visuals.lua",
    Esp = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/Esp.lua",
    NyxModsScripts = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/NyxMods%20Scripts.lua",
    Scripts = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/Scripts.lua",
    Games = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/Games.lua",
    Emotes = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/Emotes.lua",
    Animations = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/Animations.lua",
    ["Animations 2"] = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/Animations%202.lua",
    Aimbot = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/Aimbot.lua",
    Protections = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/Protections.lua",
    Hitbox = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/Hitbox.lua",
    VoiceChat = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/VoiceChat.lua",
    Misc = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/Misc.lua",
    Credits = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/Credits.lua",
  },
}

local NyxModsUniversal = getgenv().NyxModsUniversal

NyxModsUniversal.Window = Library:CreateWindow({
  Name = "NyxMods Universal",
  Icon = 86507528059862,
  LoadingTitle = "Cargando... espera...",
  LoadingSubtitle = "ya casi está",
  Theme = "neon_indigo",
  OpenButtomImage = 86507528059862,
  Intro = true,
  IntroIcon = 86507528059862,
  AnimationIntro = 3,
  DragImage = 86507528059862
})

for _,v in ipairs(NyxModsUniversal.TabsOrder) do
  local Executed, Error = pcall(function()
    local Url = NyxModsUniversal.TabsUrl[v]
    if Url ~= "" then
    loadstring(game:HttpGet(Url))()
    else
      print(tostring(v) .." doesn't have a URL")
    end
  end)
  if not Executed then
    print("Failed to execute: " .. tostring(v) .. "\nError: " .. Error)
  else
    print(tostring(v) .. " Executed successfully")
  end
end