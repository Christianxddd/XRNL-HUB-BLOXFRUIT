--====================================================
-- XRNL HUB : Blox Fruits (By Gato23)
-- 100% integrado en RedzLib
-- Librería oficial: https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui
--====================================================

-- Cargar librería principal
local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

-- Crear ventana principal
local Window = redzlib:MakeWindow({
    Title = "XRNL HUB : Blox Fruits",
    SubTitle = "by Gato23",
    SaveFolder = "XRNL_HUB_Config.lua"
})

-- Ícono flotante personalizado
Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://100423565495876", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

-- Tema visual
redzlib:SetTheme("Dark")

--====================================================
--  Crear Secciones Principales
--====================================================

local Tabs = {
    Discord = Window:MakeTab({"Discord",}),
    Farm = Window:MakeTab({"Farm",}),
    Setting = Window:MakeTab({"Setting",}),
    Quest = Window:MakeTab({"Quest / Item",}),
    Race = Window:MakeTab({"Race / Mirage",}),
    Event = Window:MakeTab({"Event",}),
    Player = Window:MakeTab({"Player",}),
    Visual = Window:MakeTab({"Visual",}),
    Raid = Window:MakeTab({"Raid",}),
    Teleport = Window:MakeTab({"Teleport",}),
    Shop = Window:MakeTab({"Shop",}),
    DevilFruit = Window:MakeTab({"Devil Fruit",}),
    Misc = Window:MakeTab({"Miscellaneous",})
}

-- Mostrar primera pestaña
Window:SelectTab(Tabs.Discord)

--====================================================
--  DISCORD TAB
--====================================================
Tabs.Discord:AddSection({"Join our Community"})
Tabs.Discord:AddDiscordInvite({
    Name = "XRNL Community",
    Description = "Join our Discord for updates and support!",
    Logo = "rbxassetid://18751483361",
    Invite = "https://discord.gg/example"
})

Tabs.Discord:AddButton({"Copy Discord Link", function()
    setclipboard("https://discord.gg/example")
end})

Tabs.Discord:AddParagraph({"Info", "Welcome to XRNL HUB!\nStay tuned for upcoming updates."})

--====================================================
--  FARM TAB
--====================================================
Tabs.Farm:AddSection({"Auto Farm Settings"})

Tabs.Farm:AddToggle({
    Name = "Auto Farm Level",
    Default = false,
    Callback = function(v)
        if v then
            print("Auto Farm Level: ON")
        else
            print("Auto Farm Level: OFF")
        end
    end
})

Tabs.Farm:AddToggle({
    Name = "Auto Farm Boss",
    Default = false,
    Callback = function(v)
        print("Auto Farm Boss:", v)
    end
})

Tabs.Farm:AddSlider({
    Name = "Farm Distance",
    Min = 10,
    Max = 500,
    Default = 100,
    Callback = function(v)
        print("Farm Distance set to:", v)
    end
})

--====================================================
--  SETTING TAB
--====================================================
Tabs.Setting:AddSection({"Settings"})
Tabs.Setting:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 300,
    Default = 16,
    Callback = function(v)
        local plr = game.Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
            plr.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = v
        end
    end
})

Tabs.Setting:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 300,
    Default = 50,
    Callback = function(v)
        local plr = game.Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
            plr.Character:FindFirstChildOfClass("Humanoid").JumpPower = v
        end
    end
})

--====================================================
--  QUEST / ITEM TAB
--====================================================
Tabs.Quest:AddSection({"Quest Manager"})
Tabs.Quest:AddButton({"Auto Quest", function()
    print("Auto Quest started!")
end})

Tabs.Quest:AddTextBox({
    Name = "Quest Name",
    PlaceholderText = "Enter quest name...",
    Callback = function(v)
        print("Selected Quest:", v)
    end
})

--====================================================
--  RACE / MIRAGE TAB
--====================================================
Tabs.Race:AddSection({"Race Abilities"})
Tabs.Race:AddButton({"Use Race Ability", function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, "V", false, game)
    task.wait(0.2)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, "V", false, game)
end})

--====================================================
--  EVENT TAB
--====================================================
Tabs.Event:AddSection({"Special Events"})
Tabs.Event:AddParagraph({"Info", "This section will include limited events like Christmas or Halloween."})

--====================================================
--  PLAYER TAB
--====================================================
Tabs.Player:AddSection({"Player Settings"})

Tabs.Player:AddSlider({
    Name = "Camera FOV",
    Min = 70,
    Max = 120,
    Default = 70,
    Callback = function(v)
        game.Workspace.CurrentCamera.FieldOfView = v
    end
})

Tabs.Player:AddToggle({
    Name = "ESP Players",
    Default = false,
    Callback = function(v)
        print("ESP Players:", v)
    end
})

--====================================================
--  VISUAL TAB
--====================================================
Tabs.Visual:AddSection({"Visual Enhancements"})
Tabs.Visual:AddToggle({
    Name = "FullBright",
    Default = false,
    Callback = function(v)
        if v then
            game.Lighting.Brightness = 2
            game.Lighting.ClockTime = 12
            game.Lighting.FogEnd = 1e10
        else
            game.Lighting.ClockTime = 14
        end
    end
})

--====================================================
--  RAID TAB
--====================================================
Tabs.Raid:AddSection({"Raid Tools"})
Tabs.Raid:AddButton({"Start Raid", function()
    print("Raid started!")
end})

--====================================================
--  TELEPORT TAB
--====================================================
Tabs.Teleport:AddSection({"Teleport Options"})

Tabs.Teleport:AddDropdown({
    Name = "Teleport To",
    Options = {"Start Island", "Marine Base", "Middle Town", "Colosseum"},
    Default = "Start Island",
    Callback = function(v)
        print("Teleport to:", v)
    end
})

Tabs.Teleport:AddButton({"Teleport", function()
    print("Teleport executed!")
end})

--====================================================
--  SHOP TAB
--====================================================
Tabs.Shop:AddSection({"Shop & Items"})
Tabs.Shop:AddButton({"Open Shop", function()
    print("Shop opened!")
end})

--====================================================
--  DEVIL FRUIT TAB
--====================================================
Tabs.DevilFruit:AddSection({"Fruit Tools"})
Tabs.DevilFruit:AddButton({"Find Fruits", function()
    print("Searching for fruits...")
end})

Tabs.DevilFruit:AddToggle({
    Name = "Auto Collect Fruits",
    Default = false,
    Callback = function(v)
        print("Auto Collect Fruits:", v)
    end
})

--====================================================
--  MISC TAB
--====================================================
Tabs.Misc:AddSection({"Miscellaneous"})
Tabs.Misc:AddButton({"Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end})

Tabs.Misc:AddButton({"Server Hop", function()
    print("Server Hop started!")
end})

Tabs.Misc:AddParagraph({"Info", "XRNL HUB - Stable version inside RedzLib.\nAll rights reserved © 2025"})

print("✅ XRNL HUB Loaded Successfully with RedzLib UI")

--====================================================
-- END OF SCRIPT
--====================================================
