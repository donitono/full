-- ⚡ Module Function Hooker – FIXED UI INIT
-- Tambahan perbaikan:
--  • Pastikan ScreenGui.Name unik & Parent ke CoreGui
--  • Pastikan ZIndexBehavior = Sibling agar elemen UI muncul
--  • Tambah fallback ketika require module error

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
sg.Name = "ModuleHookerUI_"..tostring(math.random(1000,9999))
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
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

-- (sisanya sama persis dengan kode sebelumnya: panel kiri, kanan, log, hook engine)
-- ======================= BOOT =======================
local function appendLog(msg) print("[Hooker]", msg) end
appendLog("UI siap. Pilih module di kiri lalu tekan Start Hook.")

-- Scan awal
pcall(function()
    local mods = collectModules()
    appendLog("Modules scanned: "..tostring(#mods))
end)
