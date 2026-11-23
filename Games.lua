local NyxModsUniversal = getgenv().NyxModsUniversal
local Window = NyxModsUniversal.Window

local Config = {
  Scripts = {
  ["MM2 Yarhm"] = "https://rawscripts.net/raw/Universal-Script-YARHM-12403",
  ["99 Night in the Forest FoxName"] = "https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FoxnameHub.lua",
  ["MM2 FoxName"] = "https://raw.githubusercontent.com/xv3gasx/Murder-Mystery-2/refs/heads/main/Release.lua",
  ["Animal Hospital FoxName"] = "https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/FN_AnimalHospital.lua",
  ["KAT"] = "https://raw.githubusercontent.com/xv3gasx/KAT/refs/heads/main/main.lua",
  ["Sell Lemons (Key)"] = "https://raw.githubusercontent.com/Fluxyyy333/HoshiOnTop/main/loader.lua",
  ["Natural Disaster"] = "https://rawscripts.net/raw/Universal-Script-Fire-Hub-Solara-and-mobile-support-17673",
  ["Brookhaven"] = "https://raw.githubusercontent.com/KitUserss/DarkHub/refs/heads/main/carregamento",
  ["Build a Boat (Key)"] = "https://raw.githubusercontent.com/TheRealAsu/BABFT/refs/heads/main/Loader.lua",
  ["Blox Fruits (Key)"] = "https://rawscripts.net/raw/Universal-Script-Radius-Hub-15-Games-61719",
  ["99 Nights in the Forest"] = "https://raw.githubusercontent.com/speedkingofs/99nights/refs/heads/main/Script.lua",
  ["Rivals (Silent Aim)"] = "https://raw.githubusercontent.com/JNHHGaming/Rivals7/refs/heads/main/JN%20HH%20Gaming",
  ["Fisch"] = "https://raw.githubusercontent.com/GrexXMeng/Mengs/refs/heads/main/library",
  ["Forsaken"] = "https://rawscripts.net/raw/Forsaken-Catsaken-Keyless-100-features-script-with-full-autoblock-237661",
  ["Blade Ball"] = "https://gist.githubusercontent.com/foreverspacexc-blip/a6314a7e288864eed8a004246cf25ab4/raw/e6d4befa29136f073f0658851e0b05fc6e6eaade/gistfile1.txt",
  ["Prison Life (Key)"] = "https://scripts.getv3.lol/sportsclub.luau",
  ["The Strongest Battlegrounds"] = "https://raw.githubusercontent.com/khengieslayer-oss/Html/refs/heads/main/protected_max.lua.txt",
  }
}




local Tab = Window:CreateTab("Games")
local Section = Tab:CreateSection("Scripts for games")

for Name,Url in pairs(Config.Scripts) do
  if Url ~= "" then
    Tab:CreateButton({
    Name = tostring(Name),
    Callback = function()
        loadstring(game:HttpGet(Url))()
    end
    })
  end
end