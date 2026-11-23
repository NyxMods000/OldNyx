local NyxModsUniversal = getgenv().NyxModsUniversal
local Window = NyxModsUniversal.Window

local Tab = Window:CreateTab("NyxMods Scripts")

local ScriptsOrder = {
    "+1SMS",
    "Vehicle Legends",
    "Murder Mistery 2"
}

local ScriptsNames = {
    ["+1SMS"] = "+1 Speed Monkey Scape",
    ["Vehicle Legends"] = "Vehicle Legends",
    ["Murder Mistery 2"] = "Murder Mistery 2",
}

local ScriptsUrl = {
    ["+1SMS"] = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/%2B1SMS.lua",
    ["Vehicle Legends"] = "https://raw.githubusercontent.com/NyxMods000/NyxModsUniversal/refs/heads/main/VehicleLegends.lua",
    ["Murder Mistery 2"] = "https://pastebin.com/raw/vWdaz6J8",
}

local function CreateButton(Name,Function)
    Tab:CreateButton({
    Name = Name,
    Callback = function()
        Function()
    end
})
end

for _,v in ipairs(ScriptsOrder) do
  local Executed, Error = pcall(function()
    local Url = ScriptsUrl[v]
    local Name = ScriptsNames[v]
    if Url ~= "" then
        CreateButton(Name,loadstring(game:HttpGet(Url)))
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