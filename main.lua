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


-- =========================
-- 8) Agregar sección + botón de prueba en cada tab
-- =========================
for name, tab in pairs(createdTabs) do
    local Sec = tab:AddSection({{name}})
    tab:AddButton({
        "Home "..name,
        function()
            safePrint("Pressed "..name)
        end
    })
end

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
