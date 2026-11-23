--//Variables
local NyxModsUniversal = getgenv().NyxModsUniversal
local Window = NyxModsUniversal.Window


local Tab = Window:CreateTab("Voice Chat")
local Section = Tab:CreateSection("English")

Tab:CreateParagraph({
    Title = "How to use",
    Content = "1. Turn off your microphone.\n2. Click the Anti Ban VC button.\n3. When the script shows a notification to turn Voice Chat back on, enable your microphone.\n4. Wait...\n5. That's it!"
})

local Section2 = Tab:CreateSection("Español")

Tab:CreateParagraph({
    Title = "Como usar",
    Content = "1. Apaga tu micrófono.\n2. Haz clic en el botón Anti Ban VC.\n3. Cuando el script muestre una notificación para volver a activar el chat de voz, enciende tu micrófono.\n4. Espera...\n5. ¡Eso es todo!"
})

local Section3 = Tab:CreateSection("Anti Ban")

Tab:CreateButton({
  Name = "Enable Anti Ban Vc",
  Callback = function()
    loadstring(game:HttpGet("https://pastebin.com/raw/R6nk9bS8"))()
  end
})