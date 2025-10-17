-- =============================================
-- XRNL HUB - Diagnostic + Robust Creator
-- Usa únicamente RedzLib
-- Ejecuta esto y revisa el Output si hay FAILs
-- =============================================

-- Helper para debug
local function safePrint(...) 
    print("[XRNL-DBG]", ...) 
end

-- =========================
-- 1) Cargar librería RedzLib
-- =========================
local ok, redzlib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()
end)

if not ok then
    safePrint("ERROR: loadstring failed. ok:", ok, "error:", tostring(redzlib))
    return
end

if type(redzlib) ~= "table" then
    safePrint("ERROR: redzlib cargada, pero no es una tabla. type:", type(redzlib))
    return
end

safePrint("OK: redzlib cargada. type:", type(redzlib))
safePrint("redzlib keys:")
for k,v in pairs(redzlib) do
    safePrint("  -", k, "(", type(v), ")")
end

-- =========================
-- 2) Crear ventana principal
-- =========================
local win_ok, Window_or_err = pcall(function()
    return redzlib:MakeWindow({
        Title = "XRNL HUB",
        SubTitle = "By Robles Sebastian",
        SaveFolder = "XRNL_diag"
    })
end)

if not win_ok or not Window_or_err then
    safePrint("FAIL: MakeWindow failed. success:", win_ok, "err:", tostring(Window_or_err))
    return
end

local Window = Window_or_err
safePrint("OK: Window created. type:", type(Window))

-- =========================
-- 3) Agregar icono cuadrado
-- =========================
-- Icono flotante grande, con bordes redondeados pero forma cuadrada
Window:AddMinimizeButton({
    Button = { 
        Image = "rbxassetid://127384234938681",  -- tu icono
        BackgroundTransparency = 0,
        Size = UDim2.new(0, 50, 0, 50)  -- tamaño más grande: ancho 80, alto 80
    },
    Corner = { 
        CornerRadius = UDim.new(0, 15)  -- esquinas redondeadas (15px)
    }
})


-- =========================
-- 4) Función helper para pcall
-- =========================
local function tryCall(desc, fn)
    local s, r = pcall(fn)
    if s then
        safePrint("OK:", desc)
        return true, r
    else
        safePrint("FAIL:", desc, "->", tostring(r))
        return false, r
    end
end

-- =========================
-- 5) Crear pestañas de prueba
-- =========================
local tab_ok, Tab1 = tryCall("Window:MakeTab({'Home','cherry'})", function()
    return Window:MakeTab({"Home","cherry"})
end)

if not tab_ok then
    safePrint("Aborting: MakeTab failed, cannot continue creating tabs.")
    return
end

safePrint("Tab1 created. Listing methods/keys:")
for k,v in pairs(Tab1) do safePrint("  -", k, "(", type(v), ")") end

-- =========================
-- 6) Widgets de prueba ordenados
-- =========================

-- Sección
local Section1 = Tab1:AddSection({"XRNL hub :3 "})


-- Discord Invite
Tab1:AddDiscordInvite({
    Name = "XRNL hub",
    Description = "Unirse al servidor",
    Logo = "rbxassetid://99023795298267",
    Invite = "https://discord.gg/zduuwXTcxf"
})

-- STATUS DEL JUGADOR - Blox Fruits
local Player = game.Players.LocalPlayer
local Stats = Player:WaitForChild("leaderstats") -- Leaderstats de Blox Fruits
local Data = Player:FindFirstChild("Data") -- Info adicional del jugador

-- Función para obtener toda la info dinámica del jugador
local function GetPlayerInfo()
    local info = {}
    
    info.Name = Player.Name
    info.Race = Data and Data:FindFirstChild("Race") and Data.Race.Value or "Desconocida"
    info.Nivel = Stats:FindFirstChild("Level") and Stats.Level.Value or "N/A"
    info.EXP = Stats:FindFirstChild("EXP") and Stats.EXP.Value or "N/A"
    info.Bounty = Stats:FindFirstChild("Bounty") and Stats.Bounty.Value or "N/A"
    info.Fragments = Stats:FindFirstChild("Fragments") and Stats.Fragments.Value or "N/A"
    info.DevilFruit = Data and Data:FindFirstChild("DevilFruit") and Data.DevilFruit.Value or "Ninguna"
    info.Dinero = Stats:FindFirstChild("Money") and Stats.Money.Value or "N/A"

    return info
end

-- Crear el párrafo dinámico en tu Tab1
local PlayerInfo = GetPlayerInfo()
local ParagraphHome = Tab1:AddParagraph({
    "STATUS DEL JUGADOR",
    string.format(
        "Jugador: %s\nRace: %s\nNivel: %s\nEXP: %s\nBounty: %s\nFragments: %s\nDevil Fruit: %s\nDinero: %s",
        PlayerInfo.Name, PlayerInfo.Race, PlayerInfo.Nivel, PlayerInfo.EXP,
        PlayerInfo.Bounty, PlayerInfo.Fragments, PlayerInfo.DevilFruit, PlayerInfo.Dinero
    )
})

-- Botón para actualizar info en cualquier momento
Tab1:AddButton({
    "Actualizar Status",
    function()
        local info = GetPlayerInfo()
        ParagraphHome:UpdateContent({
            "STATUS THE PLAYER (BETA)",
            string.format(
                "Jugador: %s\nRace: %s\nNivel: %s\nEXP: %s\nBounty: %s\nFragments: %s\nDevil Fruit: %s\nDinero: %s",
                info.Name, info.Race, info.Nivel, info.EXP,
                info.Bounty, info.Fragments, info.DevilFruit, info.Dinero
            )
        })
        safePrint("Información del jugador actualizada correctamente")
    end
})


-- Dialog
Window:Dialog({
    Title = "Dlg",
    Text = "Esto es un dialogo",
    Options = {
        {"OK", function() safePrint("Dialog OK") end},
        {"Cancel", function() safePrint("Dialog Cancel") end}
    }
})

-- =========================
-- 7) Crear todas las pestañas finales
-- =========================
local tabsToCreate = {
    {"Discord", {"Discord","discord"}},
    {"Farm", {"Farm","farm"}},
    {"Setting", {"Setting","setting"}},
    {"QuestItem", {"Quest / Item","quest"}},
    {"RaceMirage", {"Race / Mirage","race"}},
    {"Event", {"Event","event"}},
    {"Player", {"Player","player"}},
    {"Visual", {"Visual","visual"}},
    {"Raid", {"Raid","raid"}},
    {"Teleport", {"Teleport","tp"}},
    {"Shop", {"Shop","shop"}},
    {"DevilFruit", {"Devil Fruit","fruit"}},
    {"Misc", {"Miscellaneous","misc"}}
}

local createdTabs = {}
for _, info in ipairs(tabsToCreate) do
    local key, args = info[1], info[2]
    local okc, tab = tryCall("Window:MakeTab("..args[1]..")", function()
        return Window:MakeTab(args)
    end)
    if okc and tab then
        createdTabs[key] = tab
        safePrint("CREATED TAB:", key)
    end
end
-------------------------------------------------------------------------------------------------------------------------
-- =====================================================
-- 🌈 VISUAL SECTION (Blox Fruits)
-- =====================================================
local VisualTab = createdTabs["Visual"]

------------------------------------------------------------
-- 🧠 ESP MENU
------------------------------------------------------------
local espSection = VisualTab:AddSection({"ESP Menu"})

-- ESP Players
VisualTab:AddToggle({
    Name = "ESP Players",
    Default = false,
    Callback = function(state)
        espPlayers = state
        safePrint("👁️ ESP Players " .. (state and "Activado" or "Desactivado"))
        if state then
            task.spawn(function()
                while espPlayers do
                    task.wait(1)
                    for _, player in ipairs(game.Players:GetPlayers()) do
                        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local highlight = Instance.new("Highlight")
                            highlight.FillColor = Color3.fromRGB(255, 100, 100)
                            highlight.OutlineColor = Color3.new(1, 1, 1)
                            highlight.Adornee = player.Character
                            highlight.Parent = player.Character
                        end
                    end
                end
            end)
        else
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChildOfClass("Highlight") then
                    player.Character:FindFirstChildOfClass("Highlight"):Destroy()
                end
            end
        end
    end
})

-- ESP Fruit
VisualTab:AddToggle({
    Name = "ESP Fruit",
    Default = false,
    Callback = function(state)
        espFruit = state
        safePrint("🍎 ESP Fruit " .. (state and "Activado" or "Desactivado"))
        if state then
            task.spawn(function()
                while espFruit do
                    task.wait(2)
                    for _, v in pairs(workspace:GetChildren()) do
                        if v:IsA("Tool") and string.find(v.Name, "Fruit") then
                            if not v:FindFirstChild("Highlight") then
                                local hl = Instance.new("Highlight", v)
                                hl.FillColor = Color3.fromRGB(255, 0, 0)
                            end
                        end
                    end
                end
            end)
        else
            for _, v in pairs(workspace:GetChildren()) do
                if v:IsA("Tool") and v:FindFirstChild("Highlight") then
                    v.Highlight:Destroy()
                end
            end
        end
    end
})

-- ESP Berries (cofres)
VisualTab:AddToggle({
    Name = "ESP Berries (Chests)",
    Default = false,
    Callback = function(state)
        espChests = state
        safePrint("💰 ESP Chests " .. (state and "Activado" or "Desactivado"))
        if state then
            task.spawn(function()
                while espChests do
                    task.wait(3)
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("MeshPart") and string.find(string.lower(obj.Name), "chest") then
                            if not obj:FindFirstChild("Highlight") then
                                local hl = Instance.new("Highlight", obj)
                                hl.FillColor = Color3.fromRGB(255, 215, 0)
                            end
                        end
                    end
                end
            end)
        else
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("MeshPart") and obj:FindFirstChild("Highlight") then
                    obj.Highlight:Destroy()
                end
            end
        end
    end
})

-- ESP Islands
VisualTab:AddToggle({
    Name = "ESP Islands",
    Default = false,
    Callback = function(state)
        espIslands = state
        safePrint("🏝️ ESP Islands " .. (state and "Activado" or "Desactivado"))
        if state then
            task.spawn(function()
                while espIslands do
                    task.wait(4)
                    for _, island in pairs(workspace:GetChildren()) do
                        if island:IsA("Model") and island:FindFirstChild("IslandName") then
                            if not island:IsA("Highlight") then
                                local hl = Instance.new("Highlight", island)
                                hl.FillColor = Color3.fromRGB(0, 255, 255)
                            end
                        end
                    end
                end
            end)
        else
            for _, island in pairs(workspace:GetChildren()) do
                if island:FindFirstChild("Highlight") then
                    island.Highlight:Destroy()
                end
            end
        end
    end
})

------------------------------------------------------------
-- ⚡ HABILITIES
------------------------------------------------------------
local habSection = VisualTab:AddSection({"Habilities"})

VisualTab:AddToggle({
    Name = "Infinite Energy",
    Default = false,
    Callback = function(state)
        infEnergy = state
        safePrint("⚡ Infinite Energy " .. (state and "Activado" or "Desactivado"))
        task.spawn(function()
            while infEnergy do
                task.wait(0.2)
                local plr = game.Players.LocalPlayer
                if plr and plr.Character and plr.Character:FindFirstChild("Energy") then
                    plr.Character.Energy.Value = plr.Character.Energy.MaxValue
                end
            end
        end)
    end
})

VisualTab:AddToggle({
    Name = "Infinite Ability",
    Default = false,
    Callback = function(state)
        infAbility = state
        safePrint("🌀 Infinite Ability " .. (state and "Activado" or "Desactivado"))
        -- Aquí podrías conectar con tus habilidades especiales
    end
})

VisualTab:AddToggle({
    Name = "Infinite Observation Range",
    Default = false,
    Callback = function(state)
        infObservation = state
        safePrint("👁️ Infinite Observation Range " .. (state and "Activado" or "Desactivado"))
        -- Podrías aumentar el rango de visión si lo deseas
    end
})

------------------------------------------------------------
-- 🖥️ GRAPHIC
------------------------------------------------------------
local graphSection = VisualTab:AddSection({"Graphic"})

VisualTab:AddToggle({
    Name = "Remove Fog",
    Default = false,
    Callback = function(state)
        safePrint("🌫️ Fog " .. (state and "Removida" or "Restaurada"))
        game.Lighting.FogEnd = state and 100000 or 250
    end
})

VisualTab:AddToggle({
    Name = "Remove Lava",
    Default = false,
    Callback = function(state)
        safePrint("🔥 Lava " .. (state and "Desactivada" or "Restaurada"))
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and string.find(string.lower(obj.Name), "lava") then
                obj.CanCollide = not state
                obj.Transparency = state and 1 or 0.5
            end
        end
    end
})

VisualTab:AddToggle({
    Name = "Unlock FPS",
    Default = false,
    Callback = function(state)
        safePrint("🚀 FPS Unlock " .. (state and "Activado" or "Desactivado"))
        if setfpscap then
            setfpscap(state and 9999 or 60)
        end
    end
})

------------------------------------------------------------
-- 🍇 DEVIL FRUIT TAB - XRNL HUB
------------------------------------------------------------
local DevilFruitTab = createdTabs["DevilFruit"]
if DevilFruitTab then

    ------------------------------------------------------------
    -- 🧭 SECCIÓN: SNIPER
    ------------------------------------------------------------
    local SniperSection = DevilFruitTab:AddSection({"Sniper"})

    -- Lista de frutas que se pueden seleccionar
    local fruitsList = {"Bomb", "Magma", "Light", "Dark", "Phoenix", "Dragon", "Leopard", "Portal", "Gravity"}
    local selectedFruit = fruitsList[1]
    local autoBuySniper = false

    -- Dropdown: seleccionar fruta
    local FruitDropdown = DevilFruitTab:AddDropdown({
        Name = "Select Fruit Sniper",
        Description = "Selecciona la fruta que deseas buscar o comprar",
        Options = fruitsList,
        Default = selectedFruit,
        Callback = function(value)
            selectedFruit = value
            safePrint("🍇 Fruta seleccionada para sniper: " .. value)
        end
    })

    -- Toggle: activar/desactivar auto buy sniper
    DevilFruitTab:AddToggle({
        Name = "Auto Buy Fruit Sniper",
        Default = false,
        Callback = function(state)
            autoBuySniper = state
            if state then
                safePrint("🛒 Auto Buy Fruit Sniper ACTIVADO para: " .. selectedFruit)
                -- Aquí puedes agregar el script real del snipeo
            else
                safePrint("❌ Auto Buy Fruit Sniper DESACTIVADO")
            end
        end
    })


    ------------------------------------------------------------
    -- 🍀 SECCIÓN: OTHERS
    ------------------------------------------------------------
    local OtherSection = DevilFruitTab:AddSection({"Others"})

    -- Botón: Random Fruit
    DevilFruitTab:AddButton({
        Name = "Random Fruit",
        Callback = function()
            safePrint("🍉 Girando fruta aleatoria (Random Fruit)...")
            -- Aquí tu script de random fruit
        end
    })

    -- Botón: Open Devil Shop
    DevilFruitTab:AddButton({
        Name = "Open Devil Shop",
        Callback = function()
            safePrint("🛍 Abriendo Devil Shop...")
            -- Aquí tu script de abrir la Devil Shop
        end
    })

    -- Botón: Open Devil Shop Mirage
    DevilFruitTab:AddButton({
        Name = "Open Devil Shop Mirage",
        Callback = function()
            safePrint("✨ Abriendo Devil Shop Mirage...")
            -- Aquí tu script de abrir la Devil Shop Mirage
        end
    })

    -- Toggle: Auto Store Fruit
    local autoStore = true
    DevilFruitTab:AddToggle({
        Name = "Auto Store Fruit",
        Default = true,
        Callback = function(state)
            autoStore = state
            safePrint("📦 Auto Store Fruit " .. (state and "ACTIVADO" or "DESACTIVADO"))
            -- Aquí puedes colocar la función de auto almacenar fruta si la tienes
        end
    })

else
    safePrint("⚠️ No se encontró la pestaña DevilFruit en createdTabs")
end
-------------------------------------------------------------------------------------------------------------------------------

-- =========================
-- 10) Controles del Jugador (Speed / Jump / Noclip / Fly)
-- =========================

local PlayerTab = createdTabs["Player"]
if PlayerTab then
    local Section = PlayerTab:AddSection({"Player Controls"})

    -- Variables de control
    local speedEnabled = false
    local jumpEnabled = false
    local noclipEnabled = false
    local flyEnabled = false
    local speedValue = 16
    local jumpValue = 50

    -- === SPEED ===
    PlayerTab:AddToggle({
        Name = "Enable Speed",
        Default = false,
        Callback = function(state)
            speedEnabled = state
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                if state then
                    humanoid.WalkSpeed = speedValue
                else
                    humanoid.WalkSpeed = 16
                end
            end
        end
    })

    PlayerTab:AddSlider({
        Name = "Speed Value",
        Min = 16,
        Max = 200,
        Default = 16,
        Increase = 1,
        Callback = function(val)
            speedValue = val
            if speedEnabled then
                local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then humanoid.WalkSpeed = speedValue end
            end
        end
    })

    -- === JUMP ===
    PlayerTab:AddToggle({
        Name = "Enable Jump Power",
        Default = false,
        Callback = function(state)
            jumpEnabled = state
            local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                if state then
                    humanoid.UseJumpPower = true
                    humanoid.JumpPower = jumpValue
                else
                    humanoid.JumpPower = 50
                end
            end
        end
    })

    PlayerTab:AddSlider({
        Name = "Jump Power Level",
        Min = 50,
        Max = 300,
        Default = 50,
        Increase = 10,
        Callback = function(val)
            jumpValue = val
            if jumpEnabled then
                local humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then humanoid.JumpPower = jumpValue end
            end
        end
    })

    -- === NOCLIP ===
    PlayerTab:AddToggle({
        Name = "Enable Noclip",
        Default = false,
        Callback = function(state)
            noclipEnabled = state
            game:GetService("RunService").Stepped:Connect(function()
                if noclipEnabled then
                    local char = game.Players.LocalPlayer.Character
                    if char then
                        for _, v in pairs(char:GetChildren()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                end
            end)
        end
    })

    -- === FLY ===
    PlayerTab:AddButton({
        Name = "Enable Fly",
        Callback = function()
            flyEnabled = not flyEnabled
            local char = game.Players.LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")

            if flyEnabled then
                safePrint("Fly ON")
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local bv = Instance.new("BodyVelocity", hrp)
                bv.Velocity = Vector3.new(0,0,0)
                bv.MaxForce = Vector3.new(4000,4000,4000)

                local userInput = game:GetService("UserInputService")
                local flyConn
                flyConn = game:GetService("RunService").RenderStepped:Connect(function()
                    if not flyEnabled or not hrp then
                        bv:Destroy()
                        flyConn:Disconnect()
                        return
                    end

                    local moveDir = Vector3.new()
                    if userInput:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + hrp.CFrame.LookVector end
                    if userInput:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - hrp.CFrame.LookVector end
                    if userInput:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - hrp.CFrame.RightVector end
                    if userInput:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + hrp.CFrame.RightVector end

                    bv.Velocity = moveDir * 80
                end)
            else
                safePrint("Fly OFF")
            end
        end
            
    })
end

------------------------------------------------------------
-- 🔥 NUEVO BLOQUE MEJORADO: Player Actions (Respawn / Teleport / Spectate / FlyTo / WalkWater)
------------------------------------------------------------
local Section2 = PlayerTab:AddSection({"Player Actions"})

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Variables de control
local playersList = {}
local selectedPlayer = nil
local flyActive = false
local spectating = false
local walkOnWater = false
local flySpeed = 3

-- Crear lista de jugadores inicial
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= Players.LocalPlayer then
        table.insert(playersList, plr.Name)
    end
end

-- Dropdown de selección de jugador
local Dropdown = PlayerTab:AddDropdown({
    Name = "Select Player",
    Description = "Selecciona un jugador objetivo",
    Options = playersList,
    Default = playersList[1],
    Callback = function(value)
        selectedPlayer = Players:FindFirstChild(value)
    end
})

-- Botón para refrescar lista de jugadores
PlayerTab:AddButton({
    Name = "Refresh Players",
    Callback = function()
        playersList = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= Players.LocalPlayer then
                table.insert(playersList, plr.Name)
            end
        end
        Dropdown:Refresh(playersList)
        safePrint("Lista de jugadores actualizada")
    end
})

-- Botón para hacer respawn
PlayerTab:AddButton({
    Name = "Respawn",
    Callback = function()
        local player = Players.LocalPlayer
        player:LoadCharacter()
        safePrint("Respawn ejecutado")
    end
})

-- Toggle para spectate
PlayerTab:AddToggle({
    Name = "Spectate Player",
    Default = false,
    Callback = function(state)
        spectating = state
        local cam = workspace.CurrentCamera
        if state and selectedPlayer and selectedPlayer.Character then
            cam.CameraSubject = selectedPlayer.Character:FindFirstChild("Humanoid")
            safePrint("👁 Specteando a " .. selectedPlayer.Name)
        else
            cam.CameraSubject = Players.LocalPlayer.Character:FindFirstChild("Humanoid")
            safePrint("Spectate desactivado")
        end
    end
})

-- Slider para ajustar velocidad de vuelo
PlayerTab:AddSlider({
    Name = "Fly Speed",
    Min = 1,
    Max = 30,
    Default = 3,
    Increase = 0.5,
    Callback = function(value)
        flySpeed = value
    end
})

-- Toggle: volar hacia el jugador seleccionado (con levitación)
PlayerTab:AddToggle({
    Name = "Fly To Selected Player",
    Default = false,
    Callback = function(state)
        flyActive = state
        local lp = Players.LocalPlayer
        local char = lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        
        if state then
            if not selectedPlayer or not selectedPlayer.Character then
                safePrint("❌ Selecciona un jugador válido antes de volar.")
                return
            end
            
            local target = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not (target and hrp) then return end
            
            safePrint("✈️ Iniciando vuelo hacia " .. selectedPlayer.Name)
            
            -- Elevar al jugador suavemente
            TweenService:Create(hrp, TweenInfo.new(1, Enum.EasingStyle.Sine), {CFrame = hrp.CFrame + Vector3.new(0, 20, 0)}):Play()

            -- Mantener vuelo activo y levitando
            task.spawn(function()
                local bv = Instance.new("BodyVelocity")
                bv.Velocity = Vector3.zero
                bv.MaxForce = Vector3.new(4000, 4000, 4000)
                bv.Parent = hrp

                while flyActive and target and target.Parent do
                    task.wait(0.05)
                    local dir = (target.Position - hrp.Position).Unit
                    bv.Velocity = dir * (flySpeed * 10) + Vector3.new(0, 3, 0)
                end

                bv:Destroy()
                safePrint("🛑 Vuelo detenido")
            end)
        else
            safePrint("🛑 FlyTo desactivado manualmente")
        end
    end
})

-- Toggle: Walk on Water (Versión mejorada - convierte el agua en piso sólido)
PlayerTab:AddToggle({
    Name = "Walk on Water",
    Default = false,
    Callback = function(state)
        walkOnWater = state
        safePrint("🌊 Walk on Water " .. (state and "ACTIVADO" or "DESACTIVADO"))

        -- Proteger contra errores
        local success, err = pcall(function()
            -- Buscar el agua en el mapa (Workspace)
            local waterParts = {}

            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and string.find(string.lower(obj.Name), "water") then
                    table.insert(waterParts, obj)
                end
            end

            if #waterParts == 0 then
                safePrint("⚠️ No se encontraron partes de agua en el mapa.")
                return
            end

            -- Aplicar comportamiento según el estado
            for _, water in ipairs(waterParts) do
                if state then
                    -- Convertir en piso sólido invisible
                    water.CanCollide = true
                    water.Transparency = 0.6
                    water.Material = Enum.Material.Glass
                    water.Color = Color3.fromRGB(100, 200, 255)
                else
                    -- Restaurar apariencia original (agua)
                    water.CanCollide = false
                    water.Transparency = 0.8
                    water.Material = Enum.Material.Water
                    water.Color = Color3.fromRGB(0, 119, 255)
                end
            end

            safePrint("✅ El agua fue " .. (state and "solidificada" or "restaurada") .. " correctamente.")
        end)

        if not success then
            warn("❌ Error al modificar el agua: " .. tostring(err))
        end
    end
})


-- Hilo que mantiene el efecto de caminar sobre el agua si está activo
task.spawn(function()
    local lp = Players.LocalPlayer
    while task.wait(0.2) do
        if walkOnWater then
            local char = lp.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local hrp = char.HumanoidRootPart
                local ray = Ray.new(hrp.Position, Vector3.new(0, -10, 0))
                local part, pos = workspace:FindPartOnRay(ray, char)
                if part and part.Name == "Water" then
                    hrp.Velocity = Vector3.new(0, 3, 0)
                end
            end
        end
    end
end)

-- =========================
-- 9) Resumen final
-- =========================
safePrint("DIAG COMPLETE. Summary:")
safePrint(" - redzlib loaded:", ok)
safePrint(" - Window created:", win_ok and tostring(Window) or "no")
safePrint(" - Created tabs count:", (function() local c=0; for _ in pairs(createdTabs) do c=c+1 end; return c end)())

safePrint("INSTRUCCIONES:")
safePrint("  - Si ves FAIL lines, copia EXACTAMENTE esas líneas y pégalas aquí.")
safePrint("  - Si todo OK, este código está listo para crear tu HUB funcional con todas las pestañas y widgets ordenados.")
