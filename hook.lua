-- ⚡ Module Function Hooker – FULL, self‑contained (with list, hook, save, minimize)
-- Fitur:
--  • Scan ModuleScript dari ReplicatedStorage, StarterPlayer & PlayerScripts (LocalPlayer)
--  • Panel kiri = daftar module + search
--  • Panel kanan = log (call/return + argumen)
--  • Tombol: Start Hook, Stop Hook, Clear Log, Save Log, Refresh, Close, Floating Minimize
--  • Hook top‑level function di module (table). Stop Hook mengembalikan fungsi aslinya
-- Catatan: hanya mem‐hook panggilan yang terjadi setelah tombol Start Hook ditekan.

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local SP = game:GetService("StarterPlayer")
local LP = Players.LocalPlayer
local PS = LP:WaitForChild("PlayerScripts")

-- ======================= UTIL =======================
local function now()
    local t = os.date("!*t")
    return string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
end

local function safe_tostring(v)
    local t = typeof(v)
    if t == "string" then
        return string.format("\"%s\"", v)
    elseif t == "Instance" then
        local ok, path = pcall(function() return v:GetFullName() end)
        return ok and (v.ClassName..":"..path) or (v.ClassName)
    elseif t == "table" then
        local ok, js = pcall(function() return HttpService:JSONEncode(v) end)
        if ok then return js end
        local out, n = {}, 0
        for k,val in pairs(v) do
            n += 1; if n > 8 then table.insert(out, "…") break end
            table.insert(out, tostring(k)..":"..tostring(val))
        end
        return "{"..table.concat(out, ", ").."}"
    else
        return tostring(v)
    end
end

local function serialize_args(argtbl)
    local out = {}
    for i = 1, #argtbl do
        out[i] = safe_tostring(argtbl[i])
    end
    return table.concat(out, ", ")
end

local function write_file(name, text, append)
    if append and appendfile then appendfile(name, text)
    elseif writefile then writefile(name, text)
    else warn("[Hooker] writefile/appendfile tidak tersedia di executor.") end
end

-- ======================= SCAN =======================
local function collectModules()
    local list = {}
    local containers = {RS, SP, PS}
    for _, container in ipairs(containers) do
        for _, obj in ipairs(container:GetDescendants()) do
            if obj:IsA("ModuleScript") then
                table.insert(list, obj)
            end
        end
    end
    table.sort(list, function(a,b)
        return a:GetFullName():lower() < b:GetFullName():lower()
    end)
    return list
end

-- ======================= UI =======================
local sg = Instance.new("ScreenGui")
sg.Name = "ModuleHookerUI"
sg.ResetOnSpawn = false
sg.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 880, 0, 520)
frame.Position = UDim2.new(0.5, -440, 0.5, -260)
frame.BackgroundColor3 = Color3.fromRGB(26,26,26)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = sg

local topBar = Instance.new("Frame", frame)
topBar.Size = UDim2.new(1, 0, 0, 44)
topBar.BackgroundColor3 = Color3.fromRGB(36,36,36)
topBar.BorderSizePixel = 0

local title = Instance.new("TextLabel", topBar)
title.Size = UDim2.new(1, -90, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "⚡ Module Function Hooker (Full)"

local closeBtn = Instance.new("TextButton", topBar)
closeBtn.Size = UDim2.new(0, 36, 0, 28)
closeBtn.Position = UDim2.new(1, -44, 0.5, -14)
closeBtn.Text = "X"
closeBtn.AutoButtonColor = true
closeBtn.BackgroundColor3 = Color3.fromRGB(160,40,40)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.MouseButton1Click:Connect(function()
    sg.Enabled = false
end)

-- Floating minimize button
local miniBtn = Instance.new("TextButton", sg)
miniBtn.Size = UDim2.new(0, 40, 0, 40)
miniBtn.Position = UDim2.new(1, -50, 1, -50)
miniBtn.Text = "≡"
miniBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
miniBtn.TextColor3 = Color3.new(1,1,1)
miniBtn.Font = Enum.Font.SourceSansBold
miniBtn.TextSize = 20
miniBtn.AutoButtonColor = true
miniBtn.Draggable = true
miniBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

-- Left panel (list)
local left = Instance.new("Frame", frame)
left.Size = UDim2.new(0, 360, 1, -52)
left.Position = UDim2.new(0, 10, 0, 50)
left.BackgroundColor3 = Color3.fromRGB(33,33,33)
left.BorderSizePixel = 0

local search = Instance.new("TextBox", left)
search.Size = UDim2.new(1, -20, 0, 30)
search.Position = UDim2.new(0, 10, 0, 10)
search.PlaceholderText = "Search module name/path…"
search.Text = ""
search.TextColor3 = Color3.new(1,1,1)
search.PlaceholderColor3 = Color3.fromRGB(170,170,170)
search.BackgroundColor3 = Color3.fromRGB(45,45,45)
search.BorderSizePixel = 0
search.ClearTextOnFocus = false

local listFrame = Instance.new("ScrollingFrame", left)
listFrame.Size = UDim2.new(1, -20, 1, -60)
listFrame.Position = UDim2.new(0, 10, 0, 50)
listFrame.BackgroundColor3 = Color3.fromRGB(28,28,28)
listFrame.BorderSizePixel = 0
listFrame.ScrollBarThickness = 6

local uiList = Instance.new("UIListLayout", listFrame)
uiList.Padding = UDim.new(0, 4)
uiList.SortOrder = Enum.SortOrder.LayoutOrder

-- Right panel (controls + log)
local right = Instance.new("Frame", frame)
right.Size = UDim2.new(1, -390, 1, -52)
right.Position = UDim2.new(0, 380, 0, 50)
right.BackgroundColor3 = Color3.fromRGB(33,33,33)
right.BorderSizePixel = 0

local buttons = Instance.new("Frame", right)
buttons.Size = UDim2.new(1, -20, 0, 36)
buttons.Position = UDim2.new(0, 10, 0, 10)
buttons.BackgroundTransparency = 1

local function makeBtn(txt, x)
    local b = Instance.new("TextButton", buttons)
    b.Size = UDim2.new(0, 120, 1, 0)
    b.Position = UDim2.new(0, x, 0, 0)
    b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(70,70,70)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 18
    return b
end

local btnStart = makeBtn("Start Hook", 0)
local btnStop  = makeBtn("Stop Hook", 130)
local btnClear = makeBtn("Clear Log", 260)
local btnSave  = makeBtn("Save Log", 390)
local btnRefresh = makeBtn("Refresh", 520)

local logBox = Instance.new("TextBox", right)
logBox.Size = UDim2.new(1, -20, 1, -60)
logBox.Position = UDim2.new(0, 10, 0, 50)
logBox.TextXAlignment = Enum.TextXAlignment.Left
logBox.TextYAlignment = Enum.TextYAlignment.Top
logBox.ClearTextOnFocus = false
logBox.MultiLine = true
logBox.RichText = false
logBox.TextEditable = false
logBox.TextWrapped = false
logBox.Font = Enum.Font.Code
logBox.TextSize = 16
logBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
logBox.TextColor3 = Color3.fromRGB(230,230,230)
logBox.Text = ""

local function appendLog(msg)
    logBox.Text = (logBox.Text == "" and "" or (logBox.Text.."\n")) .. string.format("%s  %s", now(), msg)
    logBox.CursorPosition = #logBox.Text + 1
end

-- ======================= LIST/SELECTION =======================
local allModules = {}
local currentModule :: ModuleScript? = nil
local selectedBtn: TextButton? = nil

local function setSelected(btn, mod)
    if selectedBtn then selectedBtn.BackgroundColor3 = Color3.fromRGB(48,48,48) end
    selectedBtn = btn
    currentModule = mod
    btn.BackgroundColor3 = Color3.fromRGB(90,90,90)
    appendLog("Selected: "..mod:GetFullName())
end

local function makeItem(mod)
    local item = Instance.new("TextButton")
    item.Size = UDim2.new(1, -8, 0, 28)
    item.BackgroundColor3 = Color3.fromRGB(48,48,48)
    item.TextColor3 = Color3.new(1,1,1)
    item.Font = Enum.Font.SourceSans
    item.TextSize = 16
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.AutoButtonColor = true
    item.Text = string.format("[Module] %s", mod.Name)

    local tip = Instance.new("TextLabel", item)
    tip.Size = UDim2.new(1, -10, 1, 0)
    tip.Position = UDim2.new(0, 10, 0, 0)
    tip.BackgroundTransparency = 1
    tip.TextXAlignment = Enum.TextXAlignment.Left
    tip.Font = Enum.Font.SourceSans
    tip.TextSize = 14
    tip.TextColor3 = Color3.fromRGB(220,220,220)
    tip.Text = string.format("%s", mod:GetFullName())

    item.MouseButton1Click:Connect(function()
        setSelected(item, mod)
    end)
    item.Parent = listFrame
    return item
end

local function populateList()
    listFrame:ClearAllChildren()
    local q = search.Text:lower()
    for _, mod in ipairs(allModules) do
        if q == "" or mod.Name:lower():find(q, 1, true) or mod:GetFullName():lower():find(q, 1, true) then
            makeItem(mod)
        end
    end
end

search:GetPropertyChangedSignal("Text"):Connect(populateList)

local function refreshList()
    allModules = collectModules()
    populateList()
    appendLog("Modules scanned: "..tostring(#allModules))
end

btnRefresh.MouseButton1Click:Connect(refreshList)

-- ======================= HOOK ENGINE =======================
local activeHooks = { }  -- name -> original function
local hookedExport = nil  -- reference to required table/function

local function wrapFunction(fname, fn)
    return function(...)
        local args = { ... }
        appendLog(string.format("CALL  %s(%s)", fname, serialize_args(args)))
        local results = { fn(table.unpack(args)) }
        local out = {}
        for i=1,#results do out[i] = safe_tostring(results[i]) end
        appendLog(string.format("RET   %s => %s", fname, table.concat(out, ", ")))
        return table.unpack(results)
    end
end

local function startHook()
    if not currentModule then
        appendLog("✖ Belum memilih module.")
        return
    end
    if next(activeHooks) ~= nil then
        appendLog("⚠ Sudah aktif. Stop Hook dulu jika ingin pindah module.")
        return
    end
    local ok, export = pcall(require, currentModule)
    if not ok then
        appendLog("✖ Gagal require: "..tostring(export))
        return
    end
    hookedExport = export
    if typeof(export) == "table" then
        local n = 0
        for k, v in pairs(export) do
            if type(v) == "function" then
                activeHooks[k] = v
                export[k] = wrapFunction(tostring(k), v)
                n += 1
            end
        end
        appendLog("✔ Hooked "..tostring(n).." function(s) pada table module.")
    elseif type(export) == "function" then
        -- NB: tidak bisa mengganti referensi yang sudah dipegang script lain.
        activeHooks["__call__"] = export
        local wrapped = wrapFunction(currentModule.Name.."<fn>", export)
        hookedExport = wrapped  -- referensi lokal (berguna jika ada script yang require setelah ini)
        appendLog("✔ Module mengembalikan function tunggal. Wrap siap untuk panggilan baru.")
    else
        appendLog("ℹ Module tidak mengembalikan table/function ("..typeof(export).."). Tidak ada yang di-hook.")
    end
end

local function stopHook()
    if not next(activeHooks) then
        appendLog("ℹ Tidak ada hook aktif.")
        return
    end
    if typeof(hookedExport) == "table" then
        for k, orig in pairs(activeHooks) do
            if typeof(hookedExport[k]) == "function" then
                hookedExport[k] = orig
            end
        end
    end
    activeHooks = {}
    hookedExport = nil
    appendLog("✔ Hook dilepas dan fungsi asli dipulihkan.")
end

btnStart.MouseButton1Click:Connect(startHook)
btnStop.MouseButton1Click:Connect(stopHook)
btnClear.MouseButton1Click:Connect(function()
    logBox.Text = ""
end)
btnSave.MouseButton1Click:Connect(function()
    local name = string.format("ModuleSpyLog_%s.txt", os.time())
    write_file(name, logBox.Text, false)
    appendLog("Saved to "..name)
end)

-- ======================= BOOT =======================
appendLog("UI siap. Pilih module di kiri lalu tekan Start Hook.")
refreshList()
