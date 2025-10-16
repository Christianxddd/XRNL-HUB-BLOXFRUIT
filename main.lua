--// Carga la librería UI
local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

--// Crea la ventana principal
local Window = redzlib:MakeWindow({
    Title = "Redz Hub : Blox Fruits",
    SubTitle = "by redz9999",
    SaveFolder = "RedzHub | BloxFruits"
})

--// Tema
redzlib:SetTheme("Darker")

--// Botón para minimizar
Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://71014873973869", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

--// Tabs
local MainTab = Window:MakeTab({"🏝️ Farm", "cherry"})
local PlayerTab = Window:MakeTab({"⚔️ Player", "grape"})
local TeleportTab = Window:MakeTab({"🌀 Teleport", "berry"})
local SettingsTab = Window:MakeTab({"⚙️ Settings", "apple"})
local CreditsTab = Window:MakeTab({"❤️ Créditos", "strawberry"})

--// Selecciona el tab inicial
Window:SelectTab(MainTab)

-----------------------------------------------------
-- 🏝️ FARM TAB
-----------------------------------------------------
local Section = MainTab:AddSection({"Auto Farm"})
local AutoFarm = MainTab:AddToggle({
    Name = "Auto Farm Enemigos",
    Description = "Farmea enemigos automáticamente",
    Default = false
})

AutoFarm:Callback(function(State)
    getgenv().AutoFarm = State
    if State then
        task.spawn(function()
            while getgenv().AutoFarm do
                task.wait(1)
                print("Auto farmeando enemigos...")
                -- aquí puedes agregar el código de farm real
            end
        end)
    else
        print("AutoFarm desactivado.")
    end
end)

MainTab:AddButton({"Farm Beli 💰", function()
    print("Farm Beli activado!")
end})

MainTab:AddParagraph({"Tips", "Usa el AutoFarm con precaución.\nRecomendado tener buena conexión."})

-----------------------------------------------------
-- ⚔️ PLAYER TAB
-----------------------------------------------------
local PlayerSection = PlayerTab:AddSection({"Configuraciones del Jugador"})

PlayerTab:AddSlider({
    Name = "Velocidad",
    Min = 16,
    Max = 300,
    Increase = 2,
    Default = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

PlayerTab:AddSlider({
    Name = "Salto",
    Min = 50,
    Max = 500,
    Increase = 10,
    Default = 50,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

PlayerTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(State)
        getgenv().Noclip = State
        if State then
            game:GetService("RunService").Stepped:Connect(function()
                if getgenv().Noclip then
                    for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") then
                            v.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
})

-----------------------------------------------------
-- 🌀 TELEPORT TAB
-----------------------------------------------------
local TeleSection = TeleportTab:AddSection({"Zonas Rápidas"})

local Dropdown = TeleportTab:AddDropdown({
    Name = "Teleportar a:",
    Description = "Selecciona una zona",
    Options = {"Marine Start", "Pirate Start", "Middle Town", "Jungle"},
    Default = "Middle Town",
    Callback = function(Value)
        local C = game.Players.LocalPlayer.Character.HumanoidRootPart
        local Teleports = {
            ["Marine Start"] = Vector3.new(-2703, 72, 2185),
            ["Pirate Start"] = Vector3.new(1077, 16, 1445),
            ["Middle Town"] = Vector3.new(-655, 8, 1576),
            ["Jungle"] = Vector3.new(-1613, 36, 146)
        }
        C.CFrame = CFrame.new(Teleports[Value])
    end
})

-----------------------------------------------------
-- ⚙️ SETTINGS TAB
-----------------------------------------------------
local SettingsSection = SettingsTab:AddSection({"Ajustes de Interfaz"})

SettingsTab:AddButton({"Tema Oscuro", function()
    redzlib:SetTheme("Dark")
end})

SettingsTab:AddButton({"Tema Morado", function()
    redzlib:SetTheme("Purple")
end})

SettingsTab:AddButton({"Tema Más Oscuro", function()
    redzlib:SetTheme("Darker")
end})

SettingsTab:AddTextBox({
    Name = "Set Key",
    Description = "Ingresa tu key privada",
    PlaceholderText = "Ej: XRNL123",
    Callback = function(Value)
        print("Key ingresada:", Value)
    end
})

-----------------------------------------------------
-- ❤️ CRÉDITOS TAB
-----------------------------------------------------
CreditsTab:AddSection({"Creditos"})
CreditsTab:AddParagraph({"Redz Hub", "Script UI creado con RedzLib V5.\nAdaptado para Blox Fruits."})

CreditsTab:AddDiscordInvite({
    Name = "Redz Community",
    Description = "Únete al servidor oficial",
    Logo = "rbxassetid://18751483361",
    Invite = "https://discord.gg/yourserver"
})

CreditsTab:AddButton({"Copiar Discord", function()
    setclipboard("https://discord.gg/yourserver")
end})

-----------------------------------------------------
print("✅ Redz Hub para Blox Fruits cargado correctamente.")
