-- XRNL HUB - Diagnostic + Robust creator (usa únicamente RedzLib)
-- Ejecuta esto y pega aquí el Output si ves FAILs.

local function safePrint(...) print("[XRNL-DBG]", ...) end

-- 1) Try to load redzlib
local ok, redzlib = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()
end)
if not ok then
    safePrint("ERROR: loadstring failed. ok:", ok, "error:", tostring(redzlib))
    return
end
if type(redzlib) ~= "table" then
    safePrint("ERROR: redzlib loaded but is not a table. type:", type(redzlib))
    return
end
safePrint("OK: redzlib loaded. type:", type(redzlib))

-- 2) Print top-level keys in redzlib (helps detectar API)
safePrint("redzlib keys:")
for k,v in pairs(redzlib) do
    safePrint("  -", k, "(", type(v), ")")
end

-- 3) Try to create Window safely and inspect Window methods
local win_ok, Window_or_err = pcall(function()
    return redzlib:MakeWindow({
        Title = "XRNL DIAG",
        SubTitle = "diagnostic window",
        SaveFolder = "XRNL_diag"
    })
end)
if not win_ok or not Window_or_err then
    safePrint("FAIL: MakeWindow failed. success:", win_ok, "err:", tostring(Window_or_err))
    return
end
local Window = Window_or_err
safePrint("OK: Window created. type:", type(Window))

safePrint("Window keys/methods:")
for k,v in pairs(Window) do
    safePrint("  -", k, "(", type(v), ")")
end

-- helper to try calls and log result
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

-- 4) Create a test tab to ensure MakeTab works, and record the returned object keys
local tab_ok, Tab1 = tryCall("Window:MakeTab({'Test','cherry'})", function()
    return Window:MakeTab({"Test","cherry"})
end)
if not tab_ok then
    safePrint("Aborting: MakeTab failed, cannot continue creating tabs.")
    return
end

safePrint("Tab1 created. Listing Tab1 methods/keys:")
for k,v in pairs(Tab1) do safePrint("  -", k, "(", type(v), ")") end

-- 5) Test a set of common widget methods (AddSection, AddParagraph, AddButton, AddToggle, AddSlider, AddDropdown, AddTextBox, AddDiscordInvite, AddMinimizeButton, Dialog)
local widget_tests = {
    {"AddSection", function() return Tab1:AddSection({"Debug Section"}) end},
    {"AddParagraph", function() return Tab1:AddParagraph({"P","Line1\nLine2"}) end},
    {"AddButton", function() return Tab1:AddButton({"TestButton", function() safePrint('Button pressed') end}) end},
    {"AddToggle", function() return Tab1:AddToggle({Name="DbgToggle", Default=false, Callback=function(v) safePrint('Toggle',v) end}) end},
    {"AddSlider", function() return Tab1:AddSlider({Name="DbgSlider", Min=1, Max=10, Increase=1, Default=5, Callback=function(v) safePrint('Slider',v) end}) end},
    {"AddDropdown", function() return Tab1:AddDropdown({Name="DbgDropdown", Options={'one','two'}, Default='one', Callback=function(v) safePrint('Dropdown',v) end}) end},
    {"AddTextBox", function() return Tab1:AddTextBox({Name='DbgText', Description='desc', PlaceholderText='txt', Callback=function(v) safePrint('Text',v) end}) end},
    {"AddDiscordInvite", function() return Tab1:AddDiscordInvite({Name='Dbg', Description='Join', Logo='rbxassetid://18751483361', Invite='https://discord.gg/test'}) end},
    {"Window:AddMinimizeButton", function() return Window:AddMinimizeButton({Button={Image='rbxassetid://100423565495876', BackgroundTransparency=0}, Corner={CornerRadius=UDim.new(35,1)}}) end},
    {"Window:Dialog", function() return Window:Dialog({Title='Dlg', Text='Hello', Options={{'OK', function() safePrint('Dlg OK') end}}}) end}
}

for _, t in ipairs(widget_tests) do
    local name, fn = t[1], t[2]
    tryCall(name, fn)
end

-- 6) If all worked, attempt to create the full set of tabs you requested (wrapped in pcall per tab)
local requested_tabs = {
    {"Discord", {"Discord", "discord"}},
    {"Farm", {"Farm", "farm"}},
    {"Setting", {"Setting", "setting"}},
    {"QuestItem", {"Quest / Item", "quest"}},
    {"RaceMirage", {"Race / Mirage", "race"}},
    {"Event", {"Event", "event"}},
    {"Player", {"Player", "player"}},
    {"Visual", {"Visual", "visual"}},
    {"Raid", {"Raid", "raid"}},
    {"Teleport", {"Teleport", "tp"}},
    {"Shop", {"Shop", "shop"}},
    {"DevilFruit", {"Devil Fruit", "fruit"}},
    {"Misc", {"Miscellaneous", "misc"}}
}

local createdTabs = {}
for _, info in ipairs(requested_tabs) do
    local key, args = info[1], info[2]
    local desc = "Window:MakeTab("..tostring(args[1])..")"
    local okc, tab = tryCall(desc, function() return Window:MakeTab(args) end)
    if okc and tab then
        createdTabs[key] = tab
        safePrint("CREATED TAB:", key)
    else
        safePrint("FAILED TAB:", key, "reason:", tostring(tab))
    end
end

-- 7) For each created tab, attempt to add a section + a button (safe)
for name, tab in pairs(createdTabs) do
    tryCall("Tab "..name..":AddSection", function() return tab:AddSection({{name}}) end)
    tryCall("Tab "..name..":AddButton", function() return tab:AddButton({"Test "..name, function() safePrint("Pressed "..name) end}) end)
end

-- 8) Final status summary
safePrint("DIAG COMPLETE. Summary:")
safePrint(" - redzlib loaded:", ok)
safePrint(" - Window created:", win_ok and tostring(Window) or "no")
safePrint(" - Created tabs count:", (function() local c=0; for _ in pairs(createdTabs) do c=c+1 end; return c end)())

safePrint("INSTRUCCIONES:")
safePrint("  - Si ves FAIL lines, copia EXACTAMENTE esas líneas y pégalas aquí.")
safePrint("  - Si todo OK, dime y te genero YA el script completo funcional con todas las funciones en esas pestañas.")
