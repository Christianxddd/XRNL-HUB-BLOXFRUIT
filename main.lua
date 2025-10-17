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
        Image = "rbxassetid://100423565495876",  -- tu icono
        BackgroundTransparency = 0,
        Size = UDim2.new(0, 80, 0, 80)  -- tamaño más grande: ancho 80, alto 80
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
local tab_ok, Tab1 = tryCall("Window:MakeTab({'Test','cherry'})", function()
    return Window:MakeTab({"Test","cherry"})
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
local Section1 = Tab1:AddSection({"Debug Section"})

-- Párrafo
local Paragraph1 = Tab1:AddParagraph({
    "Paragraph",
    "Linea 1\nLinea 2"
})

-- Button
Tab1:AddButton({
    "TestButton",
    function()
        safePrint("Button pressed")
    end
})

-- Toggle con variable para callback separado
local Toggle1 = Tab1:AddToggle({
    Name = "DbgToggle",
    Description = "Toggle de prueba",
    Default = false
})
Toggle1:Callback(function(Value)
    safePrint("Toggle value:", Value)
end)

-- Slider
Tab1:AddSlider({
    Name = "DbgSlider",
    Min = 1,
    Max = 10,
    Increase = 1,
    Default = 5,
    Callback = function(Value)
        safePrint("Slider value:", Value)
    end
})

-- Dropdown
local Dropdown1 = Tab1:AddDropdown({
    Name = "DbgDropdown",
    Options = {"one","two"},
    Default = "one",
    Callback = function(Value)
        safePrint("Dropdown selected:", Value)
    end
})

-- TextBox
Tab1:AddTextBox({
    Name = "DbgText",
    Description = "Caja de texto de prueba",
    PlaceholderText = "Escribe algo...",
    Callback = function(Value)
        safePrint("TextBox value:", Value)
    end
})

-- Discord Invite
Tab1:AddDiscordInvite({
    Name = "DbgDiscord",
    Description = "Unirse al servidor",
    Logo = "rbxassetid://18751483361",
    Invite = "https://discord.gg/test"
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

-- =========================
-- 8) Agregar sección + botón de prueba en cada tab
-- =========================
for name, tab in pairs(createdTabs) do
    local Sec = tab:AddSection({{name}})
    tab:AddButton({
        "Test "..name,
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
