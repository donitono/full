-- ⚡ Module Function Hooker – UI FIXED with Module List
-- Perbaikan:
--  • Tambah List module di panel kiri
--  • Tambah tombol Start/Stop/Clear
--  • Tambah area log kanan
--  • Floating minimize button

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

local function appendLog(msg)
    if typeof(msg) ~= "string" then msg = tostring(msg) end
    if _G.HookerLogBox then
        _G.HookerLogBox.Text = _G.HookerLogBox.Text .. "\n" .. now() .. "  " .. msg
    end
    print("[Hooker]", msg)
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

-- Panel kiri untuk list module
local leftPanel = Instance.new("ScrollingFrame", frame)
leftPanel.Size = UDim2.new(0, 300, 1, -44)
leftPanel.Position = UDim2.new(0,0,0,44)
leftPanel.BackgroundColor3 = Color3.fromRGB(40,40,40)
leftPanel.ScrollBarThickness = 6

-- Panel kanan untuk log + tombol
local rightPanel = Instance.new("Frame", frame)
rightPanel.Size = UDim2.new(1, -300, 1, -44)
rightPanel.Position = UDim2.new(0, 300, 0, 44)
rightPanel.BackgroundColor3 = Color3.fromRGB(30,30,30)

local logBox = Instance.new("TextBox", rightPanel)
logBox.Size = UDim2.new(1, -20, 1, -80)
logBox.Position = UDim2.new(0, 10, 0, 10)
logBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
logBox.TextColor3 = Color3.new(1,1,1)
logBox.TextXAlignment = Enum.TextXAlignment.Left
logBox.TextYAlignment = Enum.TextYAlignment.Top
logBox.ClearTextOnFocus = false
logBox.MultiLine = true
logBox.TextWrapped = false
logBox.Font = Enum.Font.Code
logBox.TextSize = 15
logBox.Text = ""
logBox.RichText = false
_G.HookerLogBox = logBox

-- Tombol Start/Stop/Clear
local btnStart = Instance.new("TextButton", rightPanel)
btnStart.Size = UDim2.new(0, 100, 0, 30)
btnStart.Position = UDim2.new(0, 10, 1, -60)
btnStart.Text = "Start Hook"

local btnStop = Instance.new("TextButton", rightPanel)
btnStop.Size = UDim2.new(0, 100, 0, 30)
btnStop.Position = UDim2.new(0, 120, 1, -60)
btnStop.Text = "Stop Hook"

local btnClear = Instance.new("TextButton", rightPanel)
btnClear.Size = UDim2.new(0, 100, 0, 30)
btnClear.Position = UDim2.new(0, 230, 1, -60)
btnClear.Text = "Clear Log"
btnClear.MouseButton1Click:Connect(function()
    logBox.Text = ""
end)

-- Populate module list
local mods = collectModules()
appendLog("Modules scanned: "..tostring(#mods))

local y = 0
for i,mod in ipairs(mods) do
    local btn = Instance.new("TextButton", leftPanel)
    btn.Size = UDim2.new(1, -10, 0, 28)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.Text = "[Module] "..mod.Name
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16
    btn.MouseButton1Click:Connect(function()
        _G.SelectedModule = mod
        appendLog("Dipilih module: "..mod:GetFullName())
    end)
    y = y + 32
end

appendLog("UI siap. Pilih module di kiri lalu tekan Start Hook.")
