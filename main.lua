-- XRNL HUB : Blox Fruits (Completo, integrado con RedzLib)
-- Tabs: Discord, Farm, Setting, Quest/Item, Race/Mirage, Event, Player, Visual, Raid, Teleport, Shop, Devil Fruit, Miscellaneous
-- Icon flotante: rbxassetid://100423565495876
-- Theme: Dark
-- Por Gato23 & redz9999 - adaptado por ChatGPT

-- ================== CARGA REDZLIB ==================
local ok, redzlib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()
end)
if not ok or type(redzlib) ~= "table" then
    warn("No se pudo cargar RedzLib. Asegúrate de ejecutar con un executor y que la URL esté disponible.")
    return
end

-- ================== CREAR WINDOW ==================
local Window = redzlib:MakeWindow({
    Title = "XRNL HUB : Blox Fruits",
    SubTitle = "by Gato23 & redz9999",
    SaveFolder = "XRNL_RedzLib_Complete"
})

-- Icon flotante (minimize)
pcall(function()
    Window:AddMinimizeButton({
        Button = { Image = "rbxassetid://100423565495876", BackgroundTransparency = 0 },
        Corner = { CornerRadius = UDim.new(35, 1) },
    })
end)

-- Tema
pcall(function() redzlib:SetTheme("Dark") end)

-- ================== GLOBALS Y HELPERS ==================
getgenv().XRNL = getgenv().XRNL or {}
local S = getgenv().XRNL

-- Defaults
S.WalkSpeed = S.WalkSpeed or 16
S.JumpPower = S.JumpPower or 50
S.ESP = S.ESP or false
S.AutoFarm = S.AutoFarm or false
S.FarmRange = S.FarmRange or 80
S.AttackDelay = S.AttackDelay or 0.45
S.AutoRaid = S.AutoRaid or false
S.DF_Detect = S.DF_Detect or false
S.Visual_FOV = S.Visual_FOV or 70

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

-- Safe character util
local function safeCharacter()
    if not LocalPlayer then return nil end
    local ch = LocalPlayer.Character
    if ch and ch:FindFirstChild("Humanoid") and ch:FindFirstChild("HumanoidRootPart") then return ch end
    return nil
end

-- Apply player settings
local function applyPlayerValues()
    local ch = safeCharacter()
    if not ch then return end
    pcall(function()
        ch.Humanoid.WalkSpeed = tonumber(S.WalkSpeed) or 16
        ch.Humanoid.JumpPower = tonumber(S.JumpPower) or 50
    end)
end

if LocalPlayer then
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.3)
        applyPlayerValues()
    end)
end

-- Simple notify (if RedzLib has a notify function, try it)
local function notify(text, duration)
    pcall(function()
        if redzlib.Notify then
            redzlib:Notify({Title = "XRNL HUB", Text = text, Duration = duration or 3})
            return
        end
    end)
    -- fallback: print
    print("[XRNL HUB] "..tostring(text))
end

-- Helper: equip first tool
local function equipTool()
    local ch = safeCharacter()
    if not ch then return nil end
    for _, item in ipairs(ch:GetChildren()) do
        if item:IsA("Tool") then
            pcall(function() ch.Humanoid:EquipTool(item) end)
            return item
        end
    end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            if item:IsA("Tool") then
                pcall(function() ch.Humanoid:EquipTool(item) end)
                return item
            end
        end
    end
    return nil
end

-- Find nearest NPC (generic)
local function getNearestNPC(range)
    range = range or S.FarmRange
    local ch = safeCharacter()
    if not ch then return nil end
    local root = ch.HumanoidRootPart
    local nearest, nd = nil, math.huge
    local searchFolders = { workspace:FindFirstChild("Enemies"), workspace:FindFirstChild("Monsters"), workspace }
    for _, folder in ipairs(searchFolders) do
        if folder then
            for _, obj in ipairs(folder:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                    local hum = obj:FindFirstChild("Humanoid")
                    if hum and hum.Health > 0 then
                        local dist = (root.Position - obj.HumanoidRootPart.Position).Magnitude
                        if dist < nd and dist <= range then
                            nearest = obj
                            nd = dist
                        end
                    end
                end
            end
        end
    end
    return nearest
end

-- Try to attack with tool (Activate)
local function attackWithTool(tool)
    if not tool then return end
    pcall(function()
        if tool.Parent == LocalPlayer.Character then
            if tool:FindFirstChildOfClass("LocalScript") and tool.Activate then
                pcall(function() tool:Activate() end)
            else
                -- try remote-ish attacks not implemented: safe fallback
                if tool:FindFirstChild("Handle") then
                    -- wiggle - not actual damage
                end
            end
        else
            pcall(function() LocalPlayer.Character.Humanoid:EquipTool(tool) end)
            if tool.Activate then pcall(function() tool:Activate() end) end
        end
    end)
end

-- ================== CREAR TABS SOLICITADOS ==================
local Tab_Discord = Window:MakeTab({"Discord", "discord"})
local Tab_Farm = Window:MakeTab({"Farm", "banana"})
local Tab_Setting = Window:MakeTab({"Setting", "gear"})
local Tab_QuestItem = Window:MakeTab({"Quest/Item", "book"})
local Tab_RaceMirage = Window:MakeTab({"Race/Mirage", "sparkles"})
local Tab_Event = Window:MakeTab({"Event", "calendar"})
local Tab_Player = Window:MakeTab({"Player", "grape"})
local Tab_Visual = Window:MakeTab({"Visual", "eye"})
local Tab_Raid = Window:MakeTab({"Raid", "shield"})
local Tab_Teleport = Window:MakeTab({"Teleport", "map"})
local Tab_Shop = Window:MakeTab({"Shop", "cart"})
local Tab_DevilFruit = Window:MakeTab({"Devil Fruit", "fruit"})
local Tab_Misc = Window:MakeTab({"Miscellaneous", "tool"})

Window:SelectTab(Tab_Discord)

-- ================== TAB: DISCORD ==================
local discordSec = Tab_Discord:AddSection({"Community"})
Tab_Discord:AddParagraph({"Discord", "Únete al Discord oficial para soporte, scripts y actualizaciones."})
Tab_Discord:AddDiscordInvite({
    Name = "XRNL Community",
    Description = "Join server",
    Logo = "rbxassetid://18751483361",
    Invite = "https://discord.gg/yourserver"
})
Tab_Discord:AddButton({"Copy Invite", function() pcall(setclipboard, "https://discord.gg/yourserver") notify("Invite copiado") end})
Tab_Discord:AddParagraph({"Notes", "Si quieres que ponga tu invite real aquí dímelo."})

-- ================== TAB: FARM ==================
local farmSec = Tab_Farm:AddSection({"Auto Farm & Utilities"})
Tab_Farm:AddParagraph({"AutoFarm", "AutoFarm genérico que busca NPCs con Humanoid y ataca con herramienta equipada."})

-- AutoFarm toggle
Tab_Farm:AddToggle({
    Name = "AutoFarm (Generic)",
    Default = S.AutoFarm,
    Callback = function(v)
        S.AutoFarm = v
        getgenv().XRNL_Farm = v
        if v then
            notify("AutoFarm activado")
            task.spawn(function()
                while getgenv().XRNL_Farm do
                    if not safeCharacter() then task.wait(1); continue end
                    local target = getNearestNPC(S.FarmRange)
                    if not target then task.wait(1); continue end
                    pcall(function()
                        -- tele a target (short)
                        local root = safeCharacter().HumanoidRootPart
                        root.CFrame = target.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                    end)
                    local tool = equipTool()
                    while target and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 and getgenv().XRNL_Farm do
                        if not tool then tool = equipTool() end
                        if tool then attackWithTool(tool) end
                        task.wait(S.AttackDelay or 0.45)
                    end
                    task.wait(0.25)
                end
            end)
        else
            notify("AutoFarm desactivado")
        end
    end
})

Tab_Farm:AddSlider({
    Name = "Farm Range",
    Min = 30,
    Max = 300,
    Increase = 5,
    Default = S.FarmRange,
    Callback = function(v) S.FarmRange = v end
})
Tab_Farm:AddSlider({
    Name = "Attack Delay",
    Min = 0.05,
    Max = 1,
    Increase = 0.05,
    Default = S.AttackDelay,
    Callback = function(v) S.AttackDelay = v end
})

Tab_Farm:AddButton({"Equip Tool Now", function()
    local t = equipTool()
    if t then notify("Herramienta equipada: "..t.Name) else notify("No hay herramientas en backpack/character") end
end})

-- Placeholder: Farm presets for Beli/XP
Tab_Farm:AddButton({"Farm Beli (Placeholder)", function()
    notify("Farm Beli placeholder — dime si quieres que implemente métodos específicos")
end})

-- ================== TAB: SETTING ==================
local setSec = Tab_Setting:AddSection({"Settings & Save"})
Tab_Setting:AddParagraph({"Settings", "Ajustes guardados en getgenv().XRNL localmente."})
Tab_Setting:AddToggle({
    Name = "AutoReapply Speed on Respawn",
    Default = true,
    Callback = function(v) S.AutoReapply = v end
})
Tab_Setting:AddSlider({
    Name = "UI Theme (try: Dark/Darker/Purple)",
    Min = 1, Max = 3, Increase = 1, Default = 1,
    Callback = function(v)
        if v == 1 then pcall(function() redzlib:SetTheme("Dark") end)
        elseif v == 2 then pcall(function() redzlib:SetTheme("Darker") end)
        else pcall(function() redzlib:SetTheme("Purple") end) end
    end
})
Tab_Setting:AddButton({"Reset Saved Settings", function()
    getgenv().XRNL = {}
    notify("Settings reseteados (local). Reinicia script si quieres defaults aplicados.")
end})

Tab_Setting:AddTextBox({
    Name = "Save Note",
    Description = "Guarda una nota local (ejemplo)",
    PlaceholderText = "Mi server note",
    Callback = function(v) S.Note = v notify("Nota guardada") end
})

-- ================== TAB: QUEST / ITEM ==================
local qiSec = Tab_QuestItem:AddSection({"Quest & Items"})
Tab_QuestItem:AddParagraph({"Info", "Aquí puedes añadir automations para quests específicas o recolectar items del mundo. Por seguridad, las remotes no están implementadas por defecto."})
Tab_QuestItem:AddButton({"Detect Nearby Quests (placeholder)", function()
    -- Ejemplo: buscar objetos llamados "Quest" en workspace
    local found = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if string.find(obj.Name:lower(), "quest") or string.find(obj.Name:lower(), "mission") then
            table.insert(found, obj:GetFullName())
        end
    end
    notify("Quests detectadas: "..tostring(#found))
    for i=1, math.min(5, #found) do print(" -> "..found[i]) end
end})
Tab_QuestItem:AddButton({"Claim Item Nearby (placeholder)", function()
    notify("Claim Item placeholder — dime qué item o remote usar y lo agrego.")
end})

-- ================== TAB: RACE / MIRAGE ==================
local rmSec = Tab_RaceMirage:AddSection({"Race & Mirage"})
Tab_RaceMirage:AddParagraph({"Race / Mirage", "Sección para carreras y modo Mirage. Añade remotes o acciones específicas que quieras automatizar."})
Tab_RaceMirage:AddButton({"Auto Race (placeholder)", function() notify("Auto Race placeholder") end})
Tab_RaceMirage:AddButton({"Mirage Tools (placeholder)", function() notify("Mirage placeholder") end})

-- ================== TAB: EVENT ==================
local evSec = Tab_Event:AddSection({"Events"})
Tab_Event:AddParagraph({"Events", "Eventos temporales del juego — aquí puedes añadir scripts para eventos concretos."})
Tab_Event:AddButton({"Event Helper (placeholder)", function() notify("Event helper placeholder") end})

-- ================== TAB: PLAYER ==================
local playerSec = Tab_Player:AddSection({"Player Controls"})

PlayerTab = Tab_Player -- alias friendly

PlayerTab:AddParagraph({"Player", "Ajusta WalkSpeed, JumpPower, Noclip, y más."})

PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 350,
    Increase = 1,
    Default = S.WalkSpeed,
    Callback = function(v)
        S.WalkSpeed = v
        applyPlayerValues()
    end
})

PlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 30,
    Max = 700,
    Increase = 5,
    Default = S.JumpPower,
    Callback = function(v)
        S.JumpPower = v
        applyPlayerValues()
    end
})

-- Noclip toggle
getgenv().XRNL_Noclip = getgenv().XRNL_Noclip or false
local noclipToggle = PlayerTab:AddToggle({
    Name = "Noclip",
    Default = false,
    Callback = function(v) getgenv().XRNL_Noclip = v end
})

-- Noclip run
RunService.Stepped:Connect(function()
    if getgenv().XRNL_Noclip then
        local ch = safeCharacter()
        if ch then
            for _, part in ipairs(ch:GetDescendants()) do
                if part:IsA("BasePart") then
                    pcall(function() part.CanCollide = false end)
                end
            end
        end
    end
end)

PlayerTab:AddButton({"TP to Spawn", function()
    local ch = safeCharacter()
    if ch and workspace:FindFirstChild("SpawnLocation") then
        pcall(function() ch.HumanoidRootPart.CFrame = workspace.SpawnLocation.CFrame + Vector3.new(0,3,0) end)
    else
        notify("Spawn not found or no character")
    end
end})

-- ================== TAB: VISUAL ==================
local visSec = Tab_Visual:AddSection({"Visuals & ESP"})

Tab_Visual:AddParagraph({"Visual", "ESP, FOV and visual options."})

-- ESP implementation (players)
local espMap = {}
local function addESPForPlayer(p)
    if not p or p == LocalPlayer then return end
    if espMap[p] then return end
    if not p.Character then return end
    local head = p.Character:FindFirstChild("Head")
    if not head then return end
    local bg = Instance.new("BillboardGui")
    bg.Name = "XRNL_ESP"
    bg.AlwaysOnTop = true
    bg.Size = UDim2.new(0,130,0,40)
    bg.Adornee = head
    local txt = Instance.new("TextLabel", bg)
    txt.Size = UDim2.new(1,0,1,0)
    txt.BackgroundTransparency = 1
    txt.Text = p.Name
    txt.TextScaled = true
    txt.TextColor3 = Color3.fromRGB(255,255,0)
    bg.Parent = head
    espMap[p] = bg
end
local function removeESPForPlayer(p)
    if espMap[p] and espMap[p].Parent then pcall(function() espMap[p]:Destroy() end) end
    espMap[p] = nil
end
local function toggleESP(on)
    if on then
        for _, p in pairs(Players:GetPlayers()) do if p~=LocalPlayer then addESPForPlayer(p) end end
        Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Wait(); addESPForPlayer(p) end)
        Players.PlayerRemoving:Connect(function(p) removeESPForPlayer(p) end)
    else
        for p,_ in pairs(espMap) do removeESPForPlayer(p) end
    end
    S.ESP = on
end

Tab_Visual:AddToggle({
    Name = "ESP Players",
    Default = S.ESP,
    Callback = function(v) toggleESP(v) end
})

-- FOV slider (if camera exists)
Tab_Visual:AddSlider({
    Name = "Camera FOV",
    Min = 50,
    Max = 120,
    Increase = 1,
    Default = S.Visual_FOV,
    Callback = function(v)
        pcall(function() workspace.CurrentCamera.FieldOfView = v end)
        S.Visual_FOV = v
    end
})

Tab_Visual:AddButton({"Reset Camera FOV", function() pcall(function() workspace.CurrentCamera.FieldOfView = 70 end) notify("FOV reseteado") end})

-- ================== TAB: RAID ==================
local raidSec = Tab_Raid:AddSection({"Raid Tools"})
Tab_Raid:AddParagraph({"Raid", "Herramientas para raids. Por seguridad, el auto-raid es placeholder hasta que me digas el método exacto."})
Tab_Raid:AddToggle({
    Name = "AutoRaid (placeholder)",
    Default = S.AutoRaid,
    Callback = function(v) S.AutoRaid = v notify("AutoRaid toggle: funciona como placeholder, dime remotes si quieres integración real") end
})
Tab_Raid:AddButton({"Start Raid Helper (placeholder)", function() notify("Raid helper placeholder") end})

-- ================== TAB: TELEPORT ==================
local tpSec = Tab_Teleport:AddSection({"Teleportation"})
Tab_Teleport:AddParagraph({"Teleports", "TP rápido a islas, jugadores, shops, bosses."})

local Teleports = {
    ["Starter Island"] = Vector3.new(-2703, 72, 2185),
    ["Pirate Village"] = Vector3.new(1077, 16, 1445),
    ["Middle Town"] = Vector3.new(-655, 8, 1576),
    ["Jungle"] = Vector3.new(-1613, 36, 146),
    -- puedes añadir más coordenadas aquí
}
local tpOpts = {}
for k,_ in pairs(Teleports) do table.insert(tpOpts, k) end

Tab_Teleport:AddDropdown({
    Name = "Islands",
    Description = "Teleport quick to known islands",
    Options = tpOpts,
    Default = tpOpts[1],
    Callback = function(v)
        local ch = safeCharacter()
        if ch and Teleports[v] then pcall(function() ch.HumanoidRootPart.CFrame = CFrame.new(Teleports[v] + Vector3.new(0,5,0)) end) end
    end
})

-- Players dropdown
local playersList = {}
for _,p in pairs(Players:GetPlayers()) do table.insert(playersList, p.Name) end
if #playersList == 0 then table.insert(playersList, "NoPlayers") end

local playersDropdown = Tab_Teleport:AddDropdown({
    Name = "Players List",
    Description = "Select a player",
    Options = playersList,
    Default = LocalPlayer and LocalPlayer.Name or playersList[1],
    Callback = function(v) end
})

-- Update players dropdown (try common methods UpdateOptions/SetOptions)
Players.PlayerAdded:Connect(function()
    local ok, _ = pcall(function() 
        if playersDropdown and playersDropdown.UpdateOptions then playersDropdown:UpdateOptions(table.pack( unpack(function()
            local t={}
            for _,p in pairs(Players:GetPlayers()) do table.insert(t,p.Name) end
            return table.unpack(t)
        end())))
        end
    end)
end)
-- Teleport to selected player button
Tab_Teleport:AddButton({"Teleport to Selected Player", function()
    local selected = nil
    pcall(function()
        if playersDropdown and playersDropdown.GetValue then selected = playersDropdown:GetValue() end
        if not selected and playersDropdown and playersDropdown.Default then selected = playersDropdown.Default end
    end)
    if not selected then notify("No player selected"); return end
    local target = Players:FindFirstChild(selected)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local ch = safeCharacter()
        if ch then pcall(function() ch.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,3,0) end) end
    else
        notify("Jugador inválido/No encontrado")
    end
end})

Tab_Teleport:AddTextBox({
    Name = "Teleport custom (x,y,z)",
    Description = "Formato: x,y,z",
    PlaceholderText = "0,10,0",
    Callback = function(val)
        local x,y,z = string.match(val or "", "%s*([%-%.%d]+)%s*,%s*([%-%.%d]+)%s*,%s*([%-%.%d]+)%s*")
        if x and y and z and safeCharacter() then
            local ch = safeCharacter()
            pcall(function() ch.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(tonumber(x), tonumber(y), tonumber(z)) + Vector3.new(0,5,0)) end)
        else
            notify("Formato inválido. Usa: x,y,z")
        end
    end
})

-- ================== TAB: SHOP ==================
local shopSec = Tab_Shop:AddSection({"Shop & Vendors"})
Tab_Shop:AddParagraph({"Shop", "Teleport to shop areas or quick-buy placeholders."})
Tab_Shop:AddButton({"Teleport to Shop (placeholder)", function()
    notify("Teleport to Shop placeholder - dime una ubicación concreta para agregarla")
end})
Tab_Shop:AddButton({"Open Shop UI (placeholder)", function() notify("Shop UI placeholder") end})

-- ================== TAB: DEVIL FRUIT ==================
local dfSec = Tab_DevilFruit:AddSection({"Devil Fruit Tools"})
Tab_DevilFruit:AddParagraph({"Devil Fruit", "Detector de fruta en mapa y lista de fruits visibles."})

-- Devil Fruit detector: busca items con nombre 'Fruit' o 'DevilFruit' en workspace
local function scanForFruits()
    local found = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = (obj.Name or ""):lower()
            if string.find(name, "fruit") or string.find(name, "devil") or string.find(name, "df") then
                table.insert(found, obj)
            end
        end
    end
    return found
end

Tab_DevilFruit:AddButton({"Scan for Fruits", function()
    local found = scanForFruits()
    notify("Fruits found: "..tostring(#found))
    for i=1, math.min(#found, 10) do
        local f = found[i]
        print(i..": "..(f:GetFullName()))
    end
end})

Tab_DevilFruit:AddToggle({
    Name = "Auto Notify New Fruit",
    Default = S.DF_Detect,
    Callback = function(v)
        S.DF_Detect = v
        if v then
            notify("Auto fruit detect ON")
        else
            notify("Auto fruit detect OFF")
        end
    end
})

-- Fruit detection runtime: watch workspace for inserted parts/models with 'fruit' in name
if S.DF_Detect then
    -- start watcher
    workspace.DescendantAdded:Connect(function(desc)
        local n = (desc.Name or ""):lower()
        if string.find(n, "fruit") or string.find(n, "devil") then
            notify("Devil Fruit detected: "..desc.Name)
        end
    end)
end

-- ================== TAB: MISCELLANEOUS ==================
local miscSec = Tab_Misc:AddSection({"Misc Tools"})
Tab_Misc:AddParagraph({"Misc", "Herramientas varias."})

Tab_Misc:AddButton({"Rejoin Server", function()
    pcall(function()
        local req = game:GetService("TeleportService")
        local job = tostring(game.JobId)
        notify("Rejoining...")
        req:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
end})

Tab_Misc:AddButton({"Copy PlaceId", function() pcall(setclipboard, tostring(game.PlaceId)); notify("PlaceId copiado") end})

Tab_Misc:AddButton({"Refresh UI (recreate)", function()
    notify("Para refresh completo reinicia el script. Esto intenta guardar settings y reabrir UI.")
    -- For safety, just notify. Full recreate complicated with RedzLib internals.
end})

-- ================== EVENT LOOP & WATCHERS ==================
-- Watch for new fruits if detection enabled
workspace.DescendantAdded:Connect(function(desc)
    if S.DF_Detect and desc and desc.Name then
        local n = (desc.Name or ""):lower()
        if string.find(n, "fruit") or string.find(n, "devil") then
            notify("Devil Fruit spawned: "..desc.Name)
        end
    end
end)

-- Re-apply settings on respawn if enabled
if S.AutoReapply == nil then S.AutoReapply = true end
Players.PlayerAdded:Connect(function() end)
if LocalPlayer then
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.3)
        if S.AutoReapply then applyPlayerValues() end
    end)
end

-- ================== FIN MESSAGE ==================
notify("XRNL HUB cargado - Tabs: Discord, Farm, Setting, Quest/Item, Race/Mirage, Event, Player, Visual, Raid, Teleport, Shop, Devil Fruit, Miscellaneous")
print("✅ XRNL HUB fully loaded (RedzLib). If you want specific automations (AutoRaid, Shop Buy, Quest complete), tell me the remote names or exact in-game objects and I will integrate them.")

-- ================== NOTAS PARA EL FUTURO ==================
-- Si quieres que implemente:
--  - AutoRaid: necesito el RemoteEvent/RemoteFunction o el sistema exacto (nombre del Remote y payload).
--  - Shop auto-buy: dime el nombre del objeto/remote o la UI que maneja la compra.
--  - Quest automation: dime el NPC/Remote o cómo se entregan/completan.
--  - Devil Fruit auto-pick: confirma si la fruta es un Part con Touch or a Model with ClickDetector, para que lo implemente seguro.
-- Puedo añadir y ajustar TODO lo anterior en el mismo script dentro de RedzLib sin salir de la librería.

return true
