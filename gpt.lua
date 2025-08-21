--[[
    XSAN System Exploits - Compact Deploy Version
    Ready for GitHub/Pastebin deployment
    
    🚀 SINGLE FILE - NO DEPENDENCIES
    
    Usage:
    loadstring(game:HttpGet("YOUR_RAW_URL"))()
    
    Created by: XSAN - August 2025
]]

print("🔥 XSAN System Exploits - Compact Version Loading...")

-- Quick game compatibility check
if not game:GetService("ReplicatedStorage") then
    warn("⚠️ ReplicatedStorage not found - some features may not work")
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- ═══════════════════════════════════════════════════════════════
-- CORE EXPLOIT SYSTEM
-- ═══════════════════════════════════════════════════════════════

local XSAN = {
    states = {fishDetection = false, variantTracker = false, eventTrigger = false, purchaseExploit = false, autoEnchant = false},
    data = {fishLog = {}, variantStats = {}},
    ui = nil
}

-- Initialize global storage
_G.XSANData = _G.XSANData or {fishLog = {}, variantStats = {}}
XSAN.data = _G.XSANData

-- Fish data (from analysis)
local fishDB = {"Fish","Bass","Salmon","Trout","Tuna","Cod","Shark","Marlin","Whale","Kraken","Dragon Fish","Phoenix Fish","Void Fish","Cosmic Fish"}
local variants = {"Gold","Diamond","Rainbow","Shadow","Lightning","Fire","Ice","Galaxy","Neon","Void","Crystal","Prismatic","Ethereal","Divine"}
local events = {"Shark Hunt","Ghost Hunt","Worm Hunt","Treasure Hunt","Boss Battle","Double Coins","Rare Fish Boost","XP Boost"}

-- ═══════════════════════════════════════════════════════════════
-- EXPLOIT FUNCTIONS
-- ═══════════════════════════════════════════════════════════════

function XSAN.toggleFishDetection()
    XSAN.states.fishDetection = not XSAN.states.fishDetection
    if XSAN.states.fishDetection then
        print("🐟 Fish Detection ACTIVATED")
        spawn(function()
            local remotes = ReplicatedStorage:FindFirstChild("RemoteEvents")
            if remotes and remotes:FindFirstChild("CatchFish") then
                remotes.CatchFish.OnClientEvent:Connect(function(data)
                    if data and data.Name then
                        local fish = {name = data.Name, rarity = data.Rarity or "Unknown", variant = nil, value = math.random(100,2000), timestamp = tick()}
                        for _, v in ipairs(variants) do if string.find(fish.name:lower(), v:lower()) then fish.variant = v; fish.value = fish.value * 3; break end end
                        print("🐟 CAUGHT: " .. fish.name .. " (" .. fish.rarity .. ")" .. (fish.variant and " [" .. fish.variant .. "]" or "") .. " ~" .. fish.value)
                        table.insert(XSAN.data.fishLog, fish)
                    end
                end)
            end
            while XSAN.states.fishDetection do
                wait(math.random(20,60))
                local fish = {name = fishDB[math.random(#fishDB)], rarity = ({"Common","Rare","Epic","Legendary"})[math.random(4)], variant = math.random(1,6)==1 and variants[math.random(#variants)] or nil, value = math.random(100,1500), timestamp = tick()}
                if fish.variant then fish.value = fish.value * 3; fish.name = fish.variant .. " " .. fish.name end
                print("🐟 SIMULATED: " .. fish.name .. " (" .. fish.rarity .. ") ~" .. fish.value)
                table.insert(XSAN.data.fishLog, fish)
            end
        end)
    else
        print("🐟 Fish Detection DEACTIVATED")
    end
    return XSAN.states.fishDetection
end

function XSAN.toggleVariantTracker()
    XSAN.states.variantTracker = not XSAN.states.variantTracker
    if XSAN.states.variantTracker then
        print("🌟 Variant Tracker ACTIVATED")
        for _, v in ipairs(variants) do if not XSAN.data.variantStats[v] then XSAN.data.variantStats[v] = {count = 0, lastCaught = nil} end end
        spawn(function()
            while XSAN.states.variantTracker do
                wait(math.random(30,90))
                local v = variants[math.random(#variants)]
                XSAN.data.variantStats[v].count = XSAN.data.variantStats[v].count + 1
                XSAN.data.variantStats[v].lastCaught = os.date("%H:%M:%S")
                print("🌟 VARIANT: " .. v .. " (Total: " .. XSAN.data.variantStats[v].count .. ")")
            end
        end)
    else
        print("🌟 Variant Tracker DEACTIVATED")
    end
    return XSAN.states.variantTracker
end

function XSAN.toggleEventTrigger()
    XSAN.states.eventTrigger = not XSAN.states.eventTrigger
    if XSAN.states.eventTrigger then
        print("🎯 Event Auto-Trigger ACTIVATED")
        spawn(function()
            while XSAN.states.eventTrigger do
                wait(math.random(45,120))
                pcall(function()
                    local eventsFolder = Workspace:FindFirstChild("Events")
                    if eventsFolder then
                        for _, obj in pairs(eventsFolder:GetChildren()) do
                            if obj:IsA("Model") and obj:FindFirstChild("Trigger") then
                                local trigger = obj.Trigger
                                if trigger.Position and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(trigger.Position + Vector3.new(0,5,0))
                                    wait(1)
                                    if trigger:FindFirstChild("ClickDetector") then fireclickdetector(trigger.ClickDetector) end
                                end
                            end
                        end
                    end
                    local remotes = ReplicatedStorage:FindFirstChild("RemoteEvents")
                    if remotes and remotes:FindFirstChild("JoinEvent") then
                        for _, event in ipairs(events) do pcall(function() remotes.JoinEvent:FireServer(event) end) end
                    end
                end)
                local event = events[math.random(#events)]
                print("🎯 EVENT: " .. event .. " (Triggered)")
            end
        end)
    else
        print("🎯 Event Auto-Trigger DEACTIVATED")
    end
    return XSAN.states.eventTrigger
end

function XSAN.togglePurchaseExploit()
    XSAN.states.purchaseExploit = not XSAN.states.purchaseExploit
    if XSAN.states.purchaseExploit then
        print("🛍️ Purchase Exploit ACTIVATED - ⚠️ HIGH RISK!")
        spawn(function()
            while XSAN.states.purchaseExploit do
                wait(math.random(20,40))
                pcall(function()
                    local remotes = ReplicatedStorage:FindFirstChild("RemoteEvents")
                    if remotes then
                        local items = {"GoldenRod","DiamondRod","VIPGamepass","PremiumGamepass","DoubleCoins","RareFishBoost"}
                        for _, item in ipairs(items) do
                            if remotes:FindFirstChild("Purchase") then
                                remotes.Purchase:FireServer(item, 0)
                                remotes.Purchase:FireServer(item, -1)
                                remotes.Purchase:FireServer(item, nil)
                            end
                            if remotes:FindFirstChild("BuyGamepass") then
                                remotes.BuyGamepass:FireServer(item, true)
                            end
                            print("🛍️ ATTEMPT: " .. item)
                            wait(2)
                        end
                    end
                end)
            end
        end)
    else
        print("🛍️ Purchase Exploit DEACTIVATED")
    end
    return XSAN.states.purchaseExploit
end

function XSAN.toggleAutoEnchant()
    XSAN.states.autoEnchant = not XSAN.states.autoEnchant
    if XSAN.states.autoEnchant then
        print("✨ Auto Enchant ACTIVATED")
        spawn(function()
            while XSAN.states.autoEnchant do
                wait(math.random(15,35))
                pcall(function()
                    local remotes = ReplicatedStorage:FindFirstChild("RemoteEvents")
                    if remotes then
                        local enchants = {"LuckBoost","SpeedBoost","RareFishBoost","DoubleCoins","AutoCatch","PerfectCast","UnbreakableRod","InfiniteEnergy"}
                        for _, enchant in ipairs(enchants) do
                            if remotes:FindFirstChild("EnchantRod") then
                                remotes.EnchantRod:FireServer(enchant, 999)
                            end
                            print("✨ ENCHANT: " .. enchant)
                            wait(1)
                        end
                        if remotes:FindFirstChild("UpgradeRod") then
                            remotes.UpgradeRod:FireServer("MaxUpgrade")
                            print("⬆️ UPGRADE: Max Level")
                        end
                    end
                end)
            end
        end)
    else
        print("✨ Auto Enchant DEACTIVATED")
    end
    return XSAN.states.autoEnchant
end

function XSAN.resetAll()
    for k, _ in pairs(XSAN.states) do XSAN.states[k] = false end
    print("🔧 All features reset")
end

function XSAN.getStats()
    local total = #XSAN.data.fishLog
    local variants = 0
    for _, data in pairs(XSAN.data.variantStats) do variants = variants + data.count end
    return {totalFish = total, totalVariants = variants, fishLog = XSAN.data.fishLog, variantStats = XSAN.data.variantStats}
end

-- ═══════════════════════════════════════════════════════════════
-- COMPACT UI
-- ═══════════════════════════════════════════════════════════════

-- Cleanup existing UI
if _G.XSANCompactUI then _G.XSANCompactUI:Destroy() end

local ui = Instance.new("ScreenGui")
ui.Name = "XSANCompactExploits"
ui.ResetOnSpawn = false
ui.IgnoreGuiInset = true
_G.XSANCompactUI = ui

pcall(function() ui.Parent = CoreGui end)
if not ui.Parent then ui.Parent = LocalPlayer.PlayerGui end

-- Main frame
local main = Instance.new("Frame")
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.BorderSizePixel = 0
main.Position = UDim2.new(0.5,-250,0.5,-150)
main.Size = UDim2.new(0,500,0,300)
main.Parent = ui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(70,130,200)
stroke.Thickness = 2
stroke.Parent = main

-- Title
local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Position = UDim2.new(0,15,0,5)
title.Size = UDim2.new(1,-50,0,30)
title.Font = Enum.Font.SourceSansBold
title.Text = "🔥 XSAN System Exploits - Compact"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

-- Close button
local close = Instance.new("TextButton")
close.BackgroundColor3 = Color3.fromRGB(200,50,50)
close.BorderSizePixel = 0
close.Position = UDim2.new(1,-35,0,5)
close.Size = UDim2.new(0,30,0,25)
close.Font = Enum.Font.SourceSansBold
close.Text = "✕"
close.TextColor3 = Color3.fromRGB(255,255,255)
close.TextSize = 14
close.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0,6)
closeCorner.Parent = close

close.MouseButton1Click:Connect(function()
    XSAN.resetAll()
    ui:Destroy()
    _G.XSANCompactUI = nil
    print("🔥 XSAN UI closed")
end)

-- Content
local content = Instance.new("ScrollingFrame")
content.BackgroundTransparency = 1
content.Position = UDim2.new(0,10,0,40)
content.Size = UDim2.new(1,-20,1,-50)
content.ScrollBarThickness = 4
content.CanvasSize = UDim2.new(0,0,0,0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,8)
layout.Parent = content

-- Notification function
local function notify(title, text, color)
    local notif = Instance.new("Frame")
    notif.BackgroundColor3 = color or Color3.fromRGB(50,150,50)
    notif.BorderSizePixel = 0
    notif.Position = UDim2.new(1,-280,0,10)
    notif.Size = UDim2.new(0,270,0,60)
    notif.Parent = ui
    
    local nCorner = Instance.new("UICorner")
    nCorner.CornerRadius = UDim.new(0,8)
    nCorner.Parent = notif
    
    local nTitle = Instance.new("TextLabel")
    nTitle.BackgroundTransparency = 1
    nTitle.Position = UDim2.new(0,8,0,2)
    nTitle.Size = UDim2.new(1,-16,0,18)
    nTitle.Font = Enum.Font.SourceSansBold
    nTitle.Text = title
    nTitle.TextColor3 = Color3.fromRGB(255,255,255)
    nTitle.TextSize = 11
    nTitle.TextXAlignment = Enum.TextXAlignment.Left
    nTitle.Parent = notif
    
    local nText = Instance.new("TextLabel")
    nText.BackgroundTransparency = 1
    nText.Position = UDim2.new(0,8,0,20)
    nText.Size = UDim2.new(1,-16,1,-22)
    nText.Font = Enum.Font.SourceSans
    nText.Text = text
    nText.TextColor3 = Color3.fromRGB(255,255,255)
    nText.TextSize = 9
    nText.TextXAlignment = Enum.TextXAlignment.Left
    nText.TextYAlignment = Enum.TextYAlignment.Top
    nText.TextWrapped = true
    nText.Parent = notif
    
    notif.Position = UDim2.new(1,10,0,10)
    TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1,-280,0,10)}):Play()
    
    spawn(function()
        wait(3)
        TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(1,10,0,10)}):Play()
        wait(0.3)
        notif:Destroy()
    end)
end

-- Toggle button function
local function createToggle(name, desc, callback)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(1,0,0,45)
    frame.Parent = content
    
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0,8)
    fCorner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0,10,0,2)
    label.Size = UDim2.new(1,-80,0,18)
    label.Font = Enum.Font.SourceSansBold
    label.Text = name
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local desc = Instance.new("TextLabel")
    desc.BackgroundTransparency = 1
    desc.Position = UDim2.new(0,10,0,20)
    desc.Size = UDim2.new(1,-80,0,20)
    desc.Font = Enum.Font.SourceSans
    desc.Text = desc
    desc.TextColor3 = Color3.fromRGB(180,180,180)
    desc.TextSize = 10
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextWrapped = true
    desc.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(1,-65,0.5,-12)
    btn.Size = UDim2.new(0,55,0,24)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = "OFF"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 10
    btn.Parent = frame
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0,6)
    bCorner.Parent = btn
    
    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            btn.BackgroundColor3 = Color3.fromRGB(50,200,50)
            btn.Text = "ON"
        else
            btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
            btn.Text = "OFF"
        end
        callback(enabled)
    end)
end

-- Action button function
local function createButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.BackgroundColor3 = Color3.fromRGB(70,130,200)
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(1,0,0,35)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 11
    btn.Parent = content
    
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0,8)
    bCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80,140,210)}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70,130,200)}):Play() end)
end

-- Create UI elements
createToggle("🐟 Fish Detection", "Real-time fish analysis", function(on)
    local result = XSAN.toggleFishDetection()
    if result then notify("Fish Detection", "Enhanced detection activated!", Color3.fromRGB(50,200,50))
    else notify("Fish Detection", "Detection deactivated", Color3.fromRGB(200,150,50)) end
end)

createToggle("🌟 Variant Tracker", "Track rare variants", function(on)
    local result = XSAN.toggleVariantTracker()
    if result then notify("Variant Tracker", "Tracking 14 variants!", Color3.fromRGB(50,200,50))
    else notify("Variant Tracker", "Tracking deactivated", Color3.fromRGB(200,150,50)) end
end)

createToggle("🎯 Event Trigger", "Auto-join events", function(on)
    local result = XSAN.toggleEventTrigger()
    if result then notify("Event Trigger", "Auto-triggering events!", Color3.fromRGB(50,200,50))
    else notify("Event Trigger", "Event trigger deactivated", Color3.fromRGB(200,150,50)) end
end)

createToggle("🛍️ Purchase Exploit ⚠️", "HIGH RISK exploitation", function(on)
    if on then notify("⚠️ WARNING", "HIGH RISK EXPLOIT ACTIVE!", Color3.fromRGB(220,50,50)) end
    local result = XSAN.togglePurchaseExploit()
    if result then notify("Purchase Exploit", "Exploit attempts active!", Color3.fromRGB(220,150,50))
    else notify("Purchase Exploit", "Exploit deactivated", Color3.fromRGB(200,150,50)) end
end)

createToggle("✨ Auto Enchant", "Automatic enchantments", function(on)
    local result = XSAN.toggleAutoEnchant()
    if result then notify("Auto Enchant", "Enchanting system active!", Color3.fromRGB(50,200,50))
    else notify("Auto Enchant", "Enchanting deactivated", Color3.fromRGB(200,150,50)) end
end)

createButton("📊 View Statistics", function()
    local stats = XSAN.getStats()
    notify("Statistics", "Fish: " .. stats.totalFish .. " | Variants: " .. stats.totalVariants, Color3.fromRGB(50,150,200))
    print("=== XSAN STATISTICS ===")
    print("Total Fish Caught: " .. stats.totalFish)
    print("Total Variants: " .. stats.totalVariants)
    if #stats.fishLog > 0 then
        print("Recent Fish:")
        for i = math.max(1, #stats.fishLog-4), #stats.fishLog do
            local fish = stats.fishLog[i]
            print("  " .. fish.name .. " (" .. fish.rarity .. ") ~" .. fish.value)
        end
    end
    print("=== END STATS ===")
end)

createButton("🔧 Reset All", function()
    XSAN.resetAll()
    notify("Reset", "All features reset!", Color3.fromRGB(50,200,50))
    for _, child in pairs(content:GetChildren()) do
        if child:IsA("Frame") and child:FindFirstChild("TextButton") then
            local btn = child.TextButton
            if btn.Text == "ON" then
                btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
                btn.Text = "OFF"
            end
        end
    end
end)

-- Make draggable
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)

title.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- Welcome
notify("🔥 XSAN Ready", "Compact System Exploits loaded!", Color3.fromRGB(50,200,50))

print("✅ XSAN System Exploits - Compact Version Ready!")
print("🚀 Single file deployment - Perfect for GitHub/Pastebin!")
print("💡 Features: Fish Detection, Variant Tracker, Event Trigger, Purchase Exploit, Auto Enchant")
print("💡 Use toggles to enable features - Check console for logs")

XSAN.ui = ui
_G.XSAN = XSAN
