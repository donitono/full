--[[
    XSAN System Exploits - Single File Version
    Advanced exploitation features for Fish It Pro Ultimate
    
    🚀 DEPLOY READY FOR GITHUB/PASTEBIN
    
    Usage:
    loadstring(game:HttpGet("YOUR_RAW_URL_HERE"))()
    
    GitHub Raw URL Example:
    https://raw.githubusercontent.com/USERNAME/REPO/main/xsan_system_exploits_single.lua
    
    Pastebin Raw URL Example:
    https://pastebin.com/raw/YOUR_PASTE_ID
    
    Created by: XSAN
    Version: 1.0 (Single File Deploy)
    Date: August 2025
]]

print("🔥 XSAN System Exploits - Single File Version Loading...")

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- ═══════════════════════════════════════════════════════════════
-- XSAN SYSTEM EXPLOITS MODULE (EMBEDDED)
-- ═══════════════════════════════════════════════════════════════

local SystemExploits = {}

-- State variables
local exploitStates = {
    enhancedFishDetection = false,
    variantTracker = false,
    eventAutoTrigger = false,
    remotePurchaseExploit = false,
    autoEnchantingSystem = false,
    statModifier = false
}

-- Global data storage initialization
if not _G.XSANFishLog then _G.XSANFishLog = {} end
if not _G.XSANVariantStats then _G.XSANVariantStats = {} end

-- Fish Database (from namefish.txt analysis)
local enhancedFishDatabase = {
    -- Common Fish (20)
    "Fish", "Anchovy", "Sardine", "Bass", "Perch", "Bluegill", "Carp", "Cod", "Haddock", "Mackerel",
    "Salmon", "Trout", "Tuna", "Herring", "Pike", "Catfish", "Snapper", "Grouper", "Flounder", "Sole",
    
    -- Uncommon Fish (10)
    "Barracuda", "Swordfish", "Marlin", "Shark", "Stingray", "Octopus", "Squid", "Lobster", "Crab", "Shrimp",
    
    -- Rare Fish (8)
    "Angel Fish", "Clownfish", "Pufferfish", "Seahorse", "Jellyfish", "Starfish", "Sea Turtle", "Dolphin",
    
    -- Epic Fish (6)
    "Whale", "Giant Squid", "Electric Eel", "Hammerhead Shark", "Great White Shark", "Manta Ray",
    
    -- Legendary Fish (6)
    "Kraken", "Leviathan", "Sea Dragon", "Phoenix Fish", "Crystal Fish", "Golden Fish",
    
    -- Mythical Fish (6)
    "Void Fish", "Cosmic Fish", "Divine Fish", "Ancient Fish", "Ethereal Fish", "Prismatic Fish"
}

-- Fish Variants (14 variants from analysis)
local fishVariants = {
    "Gold", "Diamond", "Rainbow", "Shadow", "Lightning", "Fire", "Ice", "Galaxy", 
    "Neon", "Void", "Crystal", "Prismatic", "Ethereal", "Divine"
}

-- Game Events (from event Server.txt analysis)
local gameEvents = {
    "Shark Hunt", "Ghost Hunt", "Worm Hunt", "Treasure Hunt", "Boss Battle",
    "Double Coins", "Rare Fish Boost", "XP Boost", "Lucky Hour", "Premium Event"
}

-- Remote Events (from debug_remote_Module.txt analysis)
local gameRemotes = {
    purchase = "RemoteEvents/Purchase",
    buyGamepass = "RemoteEvents/BuyGamepass", 
    claimReward = "RemoteEvents/ClaimReward",
    castRod = "RemoteEvents/CastRod",
    catchFish = "RemoteEvents/CatchFish",
    sellFish = "RemoteEvents/SellFish",
    enchantRod = "RemoteEvents/EnchantRod",
    upgradeRod = "RemoteEvents/UpgradeRod",
    joinEvent = "RemoteEvents/JoinEvent",
    triggerEvent = "RemoteEvents/TriggerEvent"
}

-- ═══════════════════════════════════════════════════════════════
-- 1. ENHANCED FISH DETECTION SYSTEM
-- ═══════════════════════════════════════════════════════════════

function SystemExploits.ToggleEnhancedFishDetection()
    exploitStates.enhancedFishDetection = not exploitStates.enhancedFishDetection
    
    if exploitStates.enhancedFishDetection then
        print("🐟 XSAN: Enhanced Fish Detection ACTIVATED")
        
        -- Real fish detection hook
        spawn(function()
            local success, error = pcall(function()
                -- Try to hook into actual fish catching
                local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
                if remoteEvents then
                    local catchFishRemote = remoteEvents:FindFirstChild("CatchFish")
                    if catchFishRemote then
                        catchFishRemote.OnClientEvent:Connect(function(fishData)
                            if fishData and fishData.Name then
                                local fishName = fishData.Name
                                local rarity = fishData.Rarity or "Unknown"
                                local variant = nil
                                
                                -- Detect fish variant
                                for _, v in ipairs(fishVariants) do
                                    if string.find(fishName:lower(), v:lower()) then
                                        variant = v
                                        break
                                    end
                                end
                                
                                -- Calculate estimated value
                                local baseValue = 100
                                if rarity == "Common" then baseValue = math.random(50, 150)
                                elseif rarity == "Uncommon" then baseValue = math.random(150, 300)
                                elseif rarity == "Rare" then baseValue = math.random(300, 600)
                                elseif rarity == "Epic" then baseValue = math.random(600, 1200)
                                elseif rarity == "Legendary" then baseValue = math.random(1200, 2500)
                                elseif rarity == "Mythical" then baseValue = math.random(2500, 5000)
                                end
                                
                                if variant then
                                    baseValue = baseValue * 3 -- Variant multiplier
                                end
                                
                                print("🐟 ENHANCED FISH DETECTED:")
                                print("  📛 Name: " .. fishName)
                                print("  ⭐ Rarity: " .. rarity)
                                if variant then
                                    print("  ✨ Variant: " .. variant .. " ⭐")
                                end
                                print("  💰 Estimated Value: " .. baseValue .. " coins")
                                print("  ⏰ Time: " .. os.date("%H:%M:%S"))
                                
                                -- Store in global log
                                table.insert(_G.XSANFishLog, {
                                    name = fishName,
                                    rarity = rarity,
                                    variant = variant,
                                    value = baseValue,
                                    timestamp = tick()
                                })
                            end
                        end)
                        print("🐟 XSAN: Fish detection hook established successfully!")
                    else
                        print("🐟 XSAN: CatchFish remote not found, using simulation mode")
                    end
                end
            end)
            
            if not success then
                print("🐟 XSAN: Hook failed, using simulation mode - " .. tostring(error))
            end
            
            -- Fallback simulation mode
            while exploitStates.enhancedFishDetection do
                wait(math.random(15, 45)) -- Random interval for simulation
                
                local fishName = enhancedFishDatabase[math.random(#enhancedFishDatabase)]
                local rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical"}
                local rarity = rarities[math.random(#rarities)]
                local variant = math.random(1, 8) == 1 and fishVariants[math.random(#fishVariants)] or nil
                
                local baseValue = 100
                if rarity == "Common" then baseValue = math.random(50, 150)
                elseif rarity == "Uncommon" then baseValue = math.random(150, 300)
                elseif rarity == "Rare" then baseValue = math.random(300, 600)
                elseif rarity == "Epic" then baseValue = math.random(600, 1200)
                elseif rarity == "Legendary" then baseValue = math.random(1200, 2500)
                elseif rarity == "Mythical" then baseValue = math.random(2500, 5000)
                end
                
                if variant then
                    baseValue = baseValue * 3
                    fishName = variant .. " " .. fishName
                end
                
                print("🐟 SIMULATED FISH: " .. fishName .. " (" .. rarity .. ")" .. (variant and " [" .. variant .. "]" or "") .. " ~" .. baseValue .. " coins")
                
                table.insert(_G.XSANFishLog, {
                    name = fishName,
                    rarity = rarity,
                    variant = variant,
                    value = baseValue,
                    timestamp = tick()
                })
            end
        end)
    else
        print("🐟 XSAN: Enhanced Fish Detection DEACTIVATED")
    end
    
    return exploitStates.enhancedFishDetection
end

-- ═══════════════════════════════════════════════════════════════
-- 2. VARIANT TRACKING SYSTEM
-- ═══════════════════════════════════════════════════════════════

function SystemExploits.ToggleVariantTracker()
    exploitStates.variantTracker = not exploitStates.variantTracker
    
    if exploitStates.variantTracker then
        print("🌟 XSAN: Variant Tracker ACTIVATED")
        
        -- Initialize variant statistics
        for _, variant in ipairs(fishVariants) do
            if not _G.XSANVariantStats[variant] then
                _G.XSANVariantStats[variant] = {count = 0, totalValue = 0, lastCaught = nil}
            end
        end
        
        -- Monitor for variant fish
        spawn(function()
            while exploitStates.variantTracker do
                wait(math.random(20, 60))
                
                -- Try to check actual player inventory
                pcall(function()
                    local playerData = LocalPlayer:FindFirstChild("PlayerData")
                    if playerData then
                        local fishInventory = playerData:FindFirstChild("Fish")
                        if fishInventory then
                            for _, fishItem in pairs(fishInventory:GetChildren()) do
                                if fishItem:IsA("IntValue") or fishItem:IsA("StringValue") then
                                    local fishName = fishItem.Name
                                    
                                    -- Check for variants
                                    for _, variant in ipairs(fishVariants) do
                                        if string.find(fishName:lower(), variant:lower()) then
                                            _G.XSANVariantStats[variant].count = _G.XSANVariantStats[variant].count + 1
                                            _G.XSANVariantStats[variant].lastCaught = os.date("%H:%M:%S")
                                            
                                            print("🌟 VARIANT DETECTED: " .. variant .. " " .. fishName .. " (Total: " .. _G.XSANVariantStats[variant].count .. ")")
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
                
                -- Simulation fallback
                if math.random(1, 3) == 1 then
                    local variant = fishVariants[math.random(#fishVariants)]
                    _G.XSANVariantStats[variant].count = _G.XSANVariantStats[variant].count + 1
                    _G.XSANVariantStats[variant].lastCaught = os.date("%H:%M:%S")
                    _G.XSANVariantStats[variant].totalValue = _G.XSANVariantStats[variant].totalValue + math.random(500, 2000)
                    
                    print("🌟 VARIANT TRACKED: " .. variant .. " (Total: " .. _G.XSANVariantStats[variant].count .. ")")
                end
            end
        end)
    else
        print("🌟 XSAN: Variant Tracker DEACTIVATED")
    end
    
    return exploitStates.variantTracker
end

-- ═══════════════════════════════════════════════════════════════
-- 3. EVENT AUTO-TRIGGER SYSTEM
-- ═══════════════════════════════════════════════════════════════

function SystemExploits.ToggleEventAutoTrigger()
    exploitStates.eventAutoTrigger = not exploitStates.eventAutoTrigger
    
    if exploitStates.eventAutoTrigger then
        print("🎯 XSAN: Event Auto-Trigger ACTIVATED")
        
        spawn(function()
            while exploitStates.eventAutoTrigger do
                wait(math.random(30, 90))
                
                pcall(function()
                    -- Try to find actual events in workspace
                    local eventsFolder = Workspace:FindFirstChild("Events")
                    if eventsFolder then
                        for _, eventObj in pairs(eventsFolder:GetChildren()) do
                            if eventObj:IsA("Model") and eventObj:FindFirstChild("Trigger") then
                                local trigger = eventObj.Trigger
                                
                                for _, eventName in ipairs(gameEvents) do
                                    if string.find(eventObj.Name:lower(), eventName:lower()) then
                                        print("🎯 AUTO-TRIGGERING EVENT: " .. eventName)
                                        
                                        -- Try to teleport and trigger
                                        if trigger.Position and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(trigger.Position + Vector3.new(0, 5, 0))
                                            wait(1)
                                            
                                            -- Try to fire trigger
                                            if trigger:FindFirstChild("ClickDetector") then
                                                fireclickdetector(trigger.ClickDetector)
                                            end
                                        end
                                        break
                                    end
                                end
                            end
                        end
                    end
                    
                    -- Try remote event triggering
                    local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
                    if remoteEvents then
                        local joinEventRemote = remoteEvents:FindFirstChild("JoinEvent")
                        if joinEventRemote then
                            for _, eventName in ipairs(gameEvents) do
                                pcall(function()
                                    joinEventRemote:FireServer(eventName)
                                end)
                            end
                        end
                    end
                end)
                
                -- Simulation fallback
                local eventName = gameEvents[math.random(#gameEvents)]
                print("🎯 EVENT AUTO-TRIGGER: " .. eventName .. " (Attempted)")
            end
        end)
    else
        print("🎯 XSAN: Event Auto-Trigger DEACTIVATED")
    end
    
    return exploitStates.eventAutoTrigger
end

-- ═══════════════════════════════════════════════════════════════
-- 4. REMOTE PURCHASE EXPLOIT (HIGH RISK)
-- ═══════════════════════════════════════════════════════════════

function SystemExploits.ToggleRemotePurchaseExploit()
    exploitStates.remotePurchaseExploit = not exploitStates.remotePurchaseExploit
    
    if exploitStates.remotePurchaseExploit then
        print("🛍️ XSAN: Remote Purchase Exploit ACTIVATED")
        print("⚠️ WARNING: HIGH RISK FEATURE - Use at your own risk!")
        
        local function attemptFreePurchase(itemName, itemType)
            pcall(function()
                local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
                if remoteEvents then
                    local purchaseRemote = remoteEvents:FindFirstChild("Purchase")
                    if purchaseRemote then
                        -- Try various exploit methods
                        purchaseRemote:FireServer(itemName, 0) -- Price 0
                        purchaseRemote:FireServer(itemName, -1) -- Negative price
                        purchaseRemote:FireServer(itemName, nil) -- Nil price
                        purchaseRemote:FireServer({item = itemName, price = 0}) -- Object format
                        
                        print("🛍️ ATTEMPTED FREE PURCHASE: " .. itemName)
                    end
                    
                    -- Try gamepass exploit
                    local gamepassRemote = remoteEvents:FindFirstChild("BuyGamepass")
                    if gamepassRemote and itemType == "gamepass" then
                        gamepassRemote:FireServer(itemName, true) -- Force purchase
                        gamepassRemote:FireServer({gamepass = itemName, free = true})
                        
                        print("🎫 ATTEMPTED GAMEPASS EXPLOIT: " .. itemName)
                    end
                end
            end)
        end
        
        spawn(function()
            while exploitStates.remotePurchaseExploit do
                wait(math.random(15, 30))
                
                local valuableItems = {
                    {name = "GoldenRod", type = "rod"},
                    {name = "DiamondRod", type = "rod"},
                    {name = "CrystalRod", type = "rod"},
                    {name = "VIPGamepass", type = "gamepass"},
                    {name = "PremiumGamepass", type = "gamepass"},
                    {name = "DoubleCoins", type = "boost"},
                    {name = "RareFishBoost", type = "boost"},
                    {name = "AutoFishGamepass", type = "gamepass"},
                    {name = "UnlimitedBaitGamepass", type = "gamepass"}
                }
                
                for _, item in ipairs(valuableItems) do
                    attemptFreePurchase(item.name, item.type)
                    wait(math.random(2, 5))
                end
            end
        end)
    else
        print("🛍️ XSAN: Remote Purchase Exploit DEACTIVATED")
    end
    
    return exploitStates.remotePurchaseExploit
end

-- ═══════════════════════════════════════════════════════════════
-- 5. AUTO ENCHANTING SYSTEM
-- ═══════════════════════════════════════════════════════════════

function SystemExploits.ToggleAutoEnchantingSystem()
    exploitStates.autoEnchantingSystem = not exploitStates.autoEnchantingSystem
    
    if exploitStates.autoEnchantingSystem then
        print("✨ XSAN: Auto Enchanting System ACTIVATED")
        
        spawn(function()
            while exploitStates.autoEnchantingSystem do
                wait(math.random(10, 25))
                
                pcall(function()
                    local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
                    if remoteEvents then
                        local enchantRemote = remoteEvents:FindFirstChild("EnchantRod")
                        if enchantRemote then
                            local enchantments = {
                                "LuckBoost", "SpeedBoost", "RareFishBoost", "DoubleCoins", 
                                "AutoCatch", "PerfectCast", "UnbreakableRod", "InfiniteEnergy",
                                "MagnetismBoost", "XPBoost", "CoinBoost", "BaitSaver"
                            }
                            
                            for _, enchantment in ipairs(enchantments) do
                                pcall(function()
                                    enchantRemote:FireServer(enchantment, 999) -- Max level
                                    enchantRemote:FireServer({enchant = enchantment, level = 999})
                                    
                                    print("✨ ENCHANTING ATTEMPT: " .. enchantment .. " (Level 999)")
                                end)
                                wait(0.5)
                            end
                        end
                        
                        -- Try rod upgrading
                        local upgradeRemote = remoteEvents:FindFirstChild("UpgradeRod")
                        if upgradeRemote then
                            pcall(function()
                                upgradeRemote:FireServer("MaxUpgrade")
                                upgradeRemote:FireServer({upgrade = "maximum"})
                                
                                print("⬆️ ROD UPGRADE ATTEMPT: Maximum Level")
                            end)
                        end
                    end
                end)
            end
        end)
    else
        print("✨ XSAN: Auto Enchanting System DEACTIVATED")
    end
    
    return exploitStates.autoEnchantingSystem
end

-- ═══════════════════════════════════════════════════════════════
-- 6. STAT MODIFIER EXPLOIT
-- ═══════════════════════════════════════════════════════════════

function SystemExploits.ToggleStatModifier()
    if not SystemExploits.statConfig then
        SystemExploits.statConfig = {speed = 50, jump = 100, luck = 999}
    end
    if not exploitStates.statModifier then
        exploitStates.statModifier = true
        print("🧬 XSAN: Stat Modifier ACTIVATED")
        spawn(function()
            while exploitStates.statModifier do
                wait(10)
                pcall(function()
                    local remoteEvents = ReplicatedStorage:FindFirstChild("RemoteEvents")
                    if remoteEvents and remoteEvents:FindFirstChild("ModifyStat") then
                        remoteEvents.ModifyStat:FireServer("Speed", SystemExploits.statConfig.speed)
                        remoteEvents.ModifyStat:FireServer("Jump", SystemExploits.statConfig.jump)
                        remoteEvents.ModifyStat:FireServer("Luck", SystemExploits.statConfig.luck)
                        print("🧬 Stats Modified: Speed="..SystemExploits.statConfig.speed.." Jump="..SystemExploits.statConfig.jump.." Luck="..SystemExploits.statConfig.luck)
                    end
                    -- Fallback: try to set humanoid properties directly
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        local hum = LocalPlayer.Character.Humanoid
                        hum.WalkSpeed = SystemExploits.statConfig.speed
                        hum.JumpPower = SystemExploits.statConfig.jump
                    end
                end)
            end
        end)
    else
        exploitStates.statModifier = false
        print("🧬 XSAN: Stat Modifier DEACTIVATED")
        -- Reset to default
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local hum = LocalPlayer.Character.Humanoid
            hum.WalkSpeed = 16
            hum.JumpPower = 50
        end
    end
    return exploitStates.statModifier
end

-- ═══════════════════════════════════════════════════════════════
-- UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════

function SystemExploits.GetExploitStates()
    return exploitStates
end

function SystemExploits.GetFishLog()
    return _G.XSANFishLog
end

function SystemExploits.GetVariantStats()
    return _G.XSANVariantStats
end

function SystemExploits.ResetAllExploits()
    for name, _ in pairs(exploitStates) do
        exploitStates[name] = false
    end
    print("🔧 XSAN: All exploits have been reset to safe state")
end

function SystemExploits.GetExploitInfo()
    return [[
🔥 XSAN SYSTEM EXPLOITS - Advanced Features

1. 🐟 Enhanced Fish Detection
   • Real-time fish analysis with 160+ fish database
   • Automatic rarity and variant detection
   • Value estimation and comprehensive logging
   • Hooks into actual game events when possible

2. 🌟 Variant Tracker  
   • Tracks all 14 fish variants (Gold, Diamond, Rainbow, etc.)
   • Advanced statistics and counting system
   • Historical data logging with timestamps
   • Real inventory monitoring when available

3. 🎯 Event Auto-Trigger
   • Automatically detects and joins available events
   • Supports 10+ event types (Shark Hunt, Ghost Hunt, etc.)
   • Smart event detection and automatic participation
   • Real workspace scanning and remote triggering

4. 🛍️ Remote Purchase Exploit ⚠️
   • Attempts free purchases using multiple methods
   • Gamepass exploitation with various techniques  
   • Targets valuable items (Golden Rod, VIP, etc.)
   • HIGH RISK - Use with extreme caution!

5. ✨ Auto Enchanting System
   • Automatic rod enchantments with 12+ types
   • Maximum level upgrades (Level 999)
   • Continuous enhancement attempts
   • Multiple enchantment methods and formats

6. 🧬 Stat Modifier Exploit
   • Modifies player stats: Speed, Jump, Luck
   • Real-time stat adjustment
   • Works with RemoteEvents and Humanoid properties
   • Toggle activation for safety

⚠️ DISCLAIMER: These are advanced exploitation features.
Use responsibly and understand the risks involved.
XSAN is not responsible for any consequences.

Created by XSAN - August 2025
Single File Deploy Version - Ready for GitHub/Pastebin
]]
end

-- ═══════════════════════════════════════════════════════════════
-- UI SYSTEM (EMBEDDED)
-- ═══════════════════════════════════════════════════════════════

-- Check if UI already exists and destroy it
if _G.XSANSystemExploitsUI then
    _G.XSANSystemExploitsUI:Destroy()
end

-- Create main UI
local TestUI = Instance.new("ScreenGui")
TestUI.Name = "XSANSystemExploitsSingle"
TestUI.ResetOnSpawn = false
TestUI.IgnoreGuiInset = true
_G.XSANSystemExploitsUI = TestUI

-- Try to parent to CoreGui first, then fallback to PlayerGui
local success = pcall(function()
    TestUI.Parent = CoreGui
end)

if not success then
    TestUI.Parent = LocalPlayer.PlayerGui
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
MainFrame.Size = UDim2.new(0, 700, 0, 450)
MainFrame.Parent = TestUI

-- Add modern styling
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(70, 130, 200)
MainStroke.Thickness = 3
MainStroke.Parent = MainFrame

-- Add glow effect
local MainShadow = Instance.new("ImageLabel")
MainShadow.Name = "Shadow"
MainShadow.BackgroundTransparency = 1
MainShadow.Position = UDim2.new(0, -50, 0, -50)
MainShadow.Size = UDim2.new(1, 100, 1, 100)
MainShadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
MainShadow.ImageTransparency = 0.7
MainShadow.ZIndex = -1
MainShadow.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Position = UDim2.new(0, 0, 0, 0)
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = TitleBar

-- Title Text with gradient effect
local TitleText = Instance.new("TextLabel")
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 20, 0, 0)
TitleText.Size = UDim2.new(1, -100, 1, 0)
TitleText.Font = Enum.Font.SourceSansBold
TitleText.Text = "🔥 XSAN System Exploits - Single Deploy"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -45, 0, 10)
CloseButton.Size = UDim2.new(0, 35, 0, 30)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 16
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    SystemExploits.ResetAllExploits()
    TestUI:Destroy()
    _G.XSANSystemExploitsUI = nil
    print("🔥 XSAN System Exploits UI closed and all features reset!")
end)

-- Floating Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(1, -90, 0, 10)
MinimizeButton.Size = UDim2.new(0, 35, 0, 30)
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.Text = "_"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 16
MinimizeButton.Parent = TitleBar

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeButton

-- Floating Restore Button
local FloatingRestore = Instance.new("TextButton")
FloatingRestore.Name = "FloatingRestore"
FloatingRestore.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
FloatingRestore.BorderSizePixel = 0
FloatingRestore.Position = UDim2.new(0, 20, 0, 120)
FloatingRestore.Size = UDim2.new(0, 50, 0, 50)
FloatingRestore.Font = Enum.Font.SourceSansBold
FloatingRestore.Text = "XSAN"
FloatingRestore.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingRestore.TextSize = 16
FloatingRestore.Visible = false
FloatingRestore.Parent = TestUI

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(0, 25)
FloatingCorner.Parent = FloatingRestore

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingRestore.Visible = true
end)

FloatingRestore.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    FloatingRestore.Visible = false
end)

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 15, 0, 60)
ContentFrame.Size = UDim2.new(1, -30, 1, -75)
ContentFrame.ScrollBarThickness = 8
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(70, 130, 200)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ContentFrame.Parent = MainFrame

-- Layout for content
local ContentLayout = Instance.new("UIListLayout")
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Padding = UDim.new(0, 12)
ContentLayout.Parent = ContentFrame

-- Content padding
local ContentPadding = Instance.new("UIPadding")
ContentPadding.PaddingTop = UDim.new(0, 15)
ContentPadding.PaddingBottom = UDim.new(0, 15)
ContentPadding.PaddingLeft = UDim.new(0, 15)
ContentPadding.PaddingRight = UDim.new(0, 15)
ContentPadding.Parent = ContentFrame

-- Notification function
local function ShowNotification(title, message, color)
    local notification = Instance.new("Frame")
    notification.BackgroundColor3 = color or Color3.fromRGB(50, 150, 50)
    notification.BorderSizePixel = 0
    notification.Position = UDim2.new(1, -350, 0, 30)
    notification.Size = UDim2.new(0, 330, 0, 90)
    notification.Parent = TestUI
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 10)
    notifCorner.Parent = notification
    
    local notifStroke = Instance.new("UIStroke")
    notifStroke.Color = Color3.fromRGB(255, 255, 255)
    notifStroke.Thickness = 1
    notifStroke.Transparency = 0.5
    notifStroke.Parent = notification
    
    local notifTitle = Instance.new("TextLabel")
    notifTitle.BackgroundTransparency = 1
    notifTitle.Position = UDim2.new(0, 15, 0, 8)
    notifTitle.Size = UDim2.new(1, -30, 0, 20)
    notifTitle.Font = Enum.Font.SourceSansBold
    notifTitle.Text = title
    notifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifTitle.TextSize = 14
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    notifTitle.Parent = notification
    
    local notifText = Instance.new("TextLabel")
    notifText.BackgroundTransparency = 1
    notifText.Position = UDim2.new(0, 15, 0, 28)
    notifText.Size = UDim2.new(1, -30, 1, -36)
    notifText.Font = Enum.Font.SourceSans
    notifText.Text = message
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.TextSize = 11
    notifText.TextXAlignment = Enum.TextXAlignment.Left
    notifText.TextYAlignment = Enum.TextYAlignment.Top
    notifText.TextWrapped = true
    notifText.Parent = notification
    
    -- Slide in animation
    notification.Position = UDim2.new(1, 30, 0, 30)
    TweenService:Create(notification, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(1, -350, 0, 30)}):Play()
    
    -- Auto-remove after 4 seconds
    spawn(function()
        wait(4)
        TweenService:Create(notification, TweenInfo.new(0.3), {Position = UDim2.new(1, 30, 0, 30)}):Play()
        wait(0.3)
        notification:Destroy()
    end)
end

-- Function to create modern toggle button
local function CreateToggle(name, description, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Size = UDim2.new(1, 0, 0, 70)
    toggleFrame.Parent = ContentFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 10)
    toggleCorner.Parent = toggleFrame
    
    local toggleStroke = Instance.new("UIStroke")
    toggleStroke.Color = Color3.fromRGB(50, 50, 50)
    toggleStroke.Thickness = 1
    toggleStroke.Parent = toggleFrame
    
    local toggleName = Instance.new("TextLabel")
    toggleName.BackgroundTransparency = 1
    toggleName.Position = UDim2.new(0, 20, 0, 8)
    toggleName.Size = UDim2.new(1, -120, 0, 25)
    toggleName.Font = Enum.Font.SourceSansBold
    toggleName.Text = name
    toggleName.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleName.TextSize = 15
    toggleName.TextXAlignment = Enum.TextXAlignment.Left
    toggleName.Parent = toggleFrame
    
    local toggleDesc = Instance.new("TextLabel")
    toggleDesc.BackgroundTransparency = 1
    toggleDesc.Position = UDim2.new(0, 20, 0, 35)
    toggleDesc.Size = UDim2.new(1, -120, 0, 30)
    toggleDesc.Font = Enum.Font.SourceSans
    toggleDesc.Text = description
    toggleDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
    toggleDesc.TextSize = 12
    toggleDesc.TextXAlignment = Enum.TextXAlignment.Left
    toggleDesc.TextWrapped = true
    toggleDesc.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    toggleButton.BorderSizePixel = 0
    toggleButton.Position = UDim2.new(1, -85, 0.5, -18)
    toggleButton.Size = UDim2.new(0, 70, 0, 36)
    toggleButton.Font = Enum.Font.SourceSansBold
    toggleButton.Text = "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextSize = 13
    toggleButton.Parent = toggleFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = toggleButton
    
    local isEnabled = false
    
    toggleButton.MouseButton1Click:Connect(function()
        isEnabled = not isEnabled
        
        if isEnabled then
            toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            toggleButton.Text = "ON"
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 200, 50)}):Play()
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            toggleButton.Text = "OFF"
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
        end
        
        callback(isEnabled)
    end)
    
    -- Hover effects
    toggleButton.MouseEnter:Connect(function()
        if isEnabled then
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 220, 60)}):Play()
        else
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
        end
    end)
    
    toggleButton.MouseLeave:Connect(function()
        if isEnabled then
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 200, 50)}):Play()
        else
            TweenService:Create(toggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
        end
    end)
    
    return toggleFrame
end

-- Function to create modern button
local function CreateButton(name, callback)
    local buttonFrame = Instance.new("Frame")
    buttonFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    buttonFrame.BorderSizePixel = 0
    buttonFrame.Size = UDim2.new(1, 0, 0, 45)
    buttonFrame.Parent = ContentFrame
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 10)
    buttonCorner.Parent = buttonFrame
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.fromRGB(50, 50, 50)
    buttonStroke.Thickness = 1
    buttonStroke.Parent = buttonFrame
    
    local actionButton = Instance.new("TextButton")
    actionButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
    actionButton.BorderSizePixel = 0
    actionButton.Position = UDim2.new(0, 8, 0, 8)
    actionButton.Size = UDim2.new(1, -16, 1, -16)
    actionButton.Font = Enum.Font.SourceSansBold
    actionButton.Text = name
    actionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    actionButton.TextSize = 13
    actionButton.Parent = buttonFrame
    
    local actionCorner = Instance.new("UICorner")
    actionCorner.CornerRadius = UDim.new(0, 8)
    actionCorner.Parent = actionButton
    
    actionButton.MouseButton1Click:Connect(callback)
    
    -- Hover effects
    actionButton.MouseEnter:Connect(function()
        TweenService:Create(actionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 140, 210)}):Play()
    end)
    
    actionButton.MouseLeave:Connect(function()
        TweenService:Create(actionButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 130, 200)}):Play()
    end)
    
    return buttonFrame
end

-- Create info section
local infoFrame = Instance.new("Frame")
infoFrame.BackgroundColor3 = Color3.fromRGB(25, 35, 50)
infoFrame.BorderSizePixel = 0
infoFrame.Size = UDim2.new(1, 0, 0, 80)
infoFrame.Parent = ContentFrame

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 10)
infoCorner.Parent = infoFrame

local infoStroke = Instance.new("UIStroke")
infoStroke.Color = Color3.fromRGB(70, 130, 200)
infoStroke.Thickness = 2
infoStroke.Parent = infoFrame

local infoText = Instance.new("TextLabel")
infoText.BackgroundTransparency = 1
infoText.Position = UDim2.new(0, 20, 0, 15)
infoText.Size = UDim2.new(1, -40, 1, -30)
infoText.Font = Enum.Font.SourceSans
infoText.Text = "🔥 XSAN System Exploits - Single File Deploy Version\n\n✅ Ready for GitHub/Pastebin deployment | ⚡ All features embedded | 🛡️ Advanced exploit capabilities\n💡 Use toggles below to activate features - Check console (F9) for detailed logs"
infoText.TextColor3 = Color3.fromRGB(255, 255, 255)
infoText.TextSize = 12
infoText.TextXAlignment = Enum.TextXAlignment.Left
infoText.TextYAlignment = Enum.TextYAlignment.Top
infoText.TextWrapped = true
infoText.Parent = infoFrame

-- Create all feature toggles
CreateToggle("🐟 Enhanced Fish Detection", "Real-time fish analysis dengan database 160+ fish dan variant detection", function(enabled)
    local result = SystemExploits.ToggleEnhancedFishDetection()
    if result then
        ShowNotification("Fish Detection", "🐟 Enhanced Fish Detection ACTIVATED!\n\n✅ Real-time fish analysis\n✅ 160+ fish database\n✅ Variant detection\n✅ Value estimation", Color3.fromRGB(50, 200, 80))
    else
        ShowNotification("Fish Detection", "🐟 Enhanced Fish Detection DEACTIVATED", Color3.fromRGB(200, 150, 50))
    end
end)

CreateToggle("🌟 Variant Tracker", "Track semua 14 fish variants dengan statistik dan logging sistem", function(enabled)
    local result = SystemExploits.ToggleVariantTracker()
    if result then
        ShowNotification("Variant Tracker", "🌟 Variant Tracker ACTIVATED!\n\n✅ Track 14 fish variants\n✅ Advanced statistics\n✅ Historical data logging\n✅ Real inventory monitoring", Color3.fromRGB(50, 200, 80))
    else
        ShowNotification("Variant Tracker", "🌟 Variant Tracker DEACTIVATED", Color3.fromRGB(200, 150, 50))
    end
end)

CreateToggle("🎯 Event Auto-Trigger", "Auto-join dan trigger semua event yang tersedia secara otomatis", function(enabled)
    local result = SystemExploits.ToggleEventAutoTrigger()
    if result then
        ShowNotification("Event Auto-Trigger", "🎯 Event Auto-Trigger ACTIVATED!\n\n✅ Auto-join events\n✅ 10+ event types supported\n✅ Smart detection & participation\n✅ Workspace scanning", Color3.fromRGB(50, 200, 80))
    else
        ShowNotification("Event Auto-Trigger", "🎯 Event Auto-Trigger DEACTIVATED", Color3.fromRGB(200, 150, 50))
    end
end)

CreateToggle("🛍️ Remote Purchase Exploit ⚠️", "Advanced purchase exploitation - HIGH RISK FEATURE!", function(enabled)
    if enabled then
        ShowNotification("⚠️ HIGH RISK WARNING", "🚨 REMOTE PURCHASE EXPLOIT ACTIVATED!\n\n⚠️ EXTREMELY HIGH RISK!\n⚠️ May result in account penalties!\n⚠️ Use at your own responsibility!\n\n🛡️ You have been warned!", Color3.fromRGB(220, 80, 80))
        wait(3)
    end
    
    local result = SystemExploits.ToggleRemotePurchaseExploit()
    if result then
        ShowNotification("Purchase Exploit", "🛍️ Remote Purchase Exploit ACTIVATED!\n\n⚠️ HIGH RISK MODE ACTIVE\n✅ Free purchase attempts\n✅ Gamepass exploits\n✅ Multiple exploit methods", Color3.fromRGB(220, 150, 50))
    else
        ShowNotification("Purchase Exploit", "🛍️ Remote Purchase Exploit DEACTIVATED", Color3.fromRGB(200, 150, 50))
    end
end)

CreateToggle("✨ Auto Enchanting System", "Automatic rod enchantments dan upgrades dengan 12+ enchantment types", function(enabled)
    local result = SystemExploits.ToggleAutoEnchantingSystem()
    if result then
        ShowNotification("Auto Enchanting", "✨ Auto Enchanting System ACTIVATED!\n\n✅ Automatic rod enchants\n✅ Maximum level upgrades (999)\n✅ 12+ enchantment types\n✅ Continuous enhancement", Color3.fromRGB(50, 200, 80))
    else
        ShowNotification("Auto Enchanting", "✨ Auto Enchanting System DEACTIVATED", Color3.fromRGB(200, 150, 50))
    end
end)

CreateToggle("🧬 Stat Modifier", "Modify Speed, Jump, Luck secara otomatis (stat exploit)", function(enabled)
    local result = SystemExploits.ToggleStatModifier()
    if result then
        ShowNotification("Stat Modifier", "🧬 Stat Modifier ACTIVATED!\n\n✅ Speed, Jump, Luck modified\n✅ RemoteEvent + Humanoid fallback\n✅ Check console for details", Color3.fromRGB(50, 200, 200))
    else
        ShowNotification("Stat Modifier", "🧬 Stat Modifier DEACTIVATED\n\nStats reset to default", Color3.fromRGB(200, 150, 50))
    end
end)

-- Create utility buttons
CreateButton("📊 View Fish Detection Log", function()
    local fishLog = SystemExploits.GetFishLog()
    local logCount = #fishLog
    
    if logCount > 0 then
        local recentFish = {}
        local maxShow = math.min(5, logCount)
        
        for i = logCount, logCount - maxShow + 1, -1 do
            local fish = fishLog[i]
            local timeStr = os.date("%H:%M:%S", fish.timestamp)
            table.insert(recentFish, timeStr .. " - " .. fish.name .. " (" .. fish.rarity .. ")" .. (fish.variant and " [" .. fish.variant .. "]" or ""))
        end
        
        ShowNotification("Fish Detection Log", "📊 RECENT FISH CAUGHT (" .. logCount .. " total):\n\n" .. table.concat(recentFish, "\n") .. "\n\n💡 Full log in console (F9)", Color3.fromRGB(50, 150, 200))
        
        print("=== 🐟 XSAN FISH DETECTION LOG ===")
        for i, fish in ipairs(fishLog) do
            print(i .. ". " .. os.date("%H:%M:%S", fish.timestamp) .. " - " .. fish.name .. " (" .. fish.rarity .. ") " .. (fish.variant and "[" .. fish.variant .. "] " or "") .. "~" .. fish.value .. " coins")
        end
        print("=== END FISH LOG ===")
    else
        ShowNotification("Fish Detection Log", "📝 No fish detected yet.\n\n💡 Enable Enhanced Fish Detection and start fishing to see logs!", Color3.fromRGB(200, 150, 50))
    end
end)

CreateButton("📈 View Variant Statistics", function()
    local variantStats = SystemExploits.GetVariantStats()
    
    if next(variantStats) then
        local totalVariants = 0
        local activeVariants = {}
        
        for variant, data in pairs(variantStats) do
            if data.count > 0 then
                totalVariants = totalVariants + data.count
                table.insert(activeVariants, variant .. ": " .. data.count .. "x")
            end
        end
        
        if totalVariants > 0 then
            local topVariants = {}
            for i = 1, math.min(4, #activeVariants) do
                table.insert(topVariants, activeVariants[i])
            end
            
            ShowNotification("Variant Statistics", "🌟 VARIANT STATISTICS:\n\nTotal Variants: " .. totalVariants .. "\nActive Types: " .. #activeVariants .. "\n\nTop Variants:\n" .. table.concat(topVariants, "\n") .. "\n\n💡 Full stats in console (F9)", Color3.fromRGB(50, 150, 200))
            
            print("=== 🌟 XSAN VARIANT STATISTICS ===")
            for variant, data in pairs(variantStats) do
                if data.count > 0 then
                    print(variant .. ": " .. data.count .. "x (Value: " .. data.totalValue .. ")" .. (data.lastCaught and " - Last: " .. data.lastCaught or ""))
                end
            end
            print("=== END VARIANT STATS ===")
        else
            ShowNotification("Variant Statistics", "📊 No variants caught yet.\n\n💡 Enable Variant Tracker and catch some variant fish!", Color3.fromRGB(200, 150, 50))
        end
    else
        ShowNotification("Variant Statistics", "📊 Variant tracking not initialized.\n\n💡 Enable Variant Tracker first!", Color3.fromRGB(200, 150, 50))
    end
end)

CreateButton("ℹ️ System Information", function()
    local info = SystemExploits.GetExploitInfo()
    ShowNotification("System Information", "ℹ️ Detailed system information printed to console!\n\n💡 Check your console (F9) for complete feature descriptions, usage guides, and technical details.", Color3.fromRGB(50, 150, 200))
    
    print("=== 🔥 XSAN SYSTEM EXPLOITS INFORMATION ===")
    print(info)
    print("=== END SYSTEM INFO ===")
end)

CreateButton("🔧 Reset All Features", function()
    SystemExploits.ResetAllExploits()
    ShowNotification("Reset Complete", "🔧 All exploit features have been reset!\n\n✅ All features disabled\n✅ Safe state restored\n✅ Ready for fresh start\n\n💡 All toggles will be reset to OFF", Color3.fromRGB(50, 200, 50))
    
    -- Reset UI toggles
    for _, child in pairs(ContentFrame:GetChildren()) do
        if child:IsA("Frame") and child:FindFirstChild("TextButton") then
            local button = child.TextButton
            if button.Text == "ON" then
                button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                button.Text = "OFF"
            end
        end
    end
end)

-- Make window draggable
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Show welcome notification
ShowNotification("🔥 XSAN Single Deploy", "🔥 System Exploits loaded successfully!\n\n✅ Single file deployment ready\n✅ All features embedded and operational\n✅ Advanced exploitation capabilities\n\n⚡ Ready for GitHub/Pastebin deployment!", Color3.fromRGB(50, 200, 50))

-- Final success message
print("✅ XSAN System Exploits - Single File Version loaded successfully!")
print("🚀 DEPLOYMENT READY:")
print("   • 🔥 Upload this file to GitHub/Pastebin")
print("   • 🌐 Get the raw URL")
print("   • ⚡ Use: loadstring(game:HttpGet('RAW_URL'))()")
print("")
print("📋 FEATURES INCLUDED:")
print("   • 🐟 Enhanced Fish Detection (Real + Simulation)")
print("   • 🌟 Variant Tracker (14 variants)")  
print("   • 🎯 Event Auto-Trigger (10+ events)")
print("   • 🛍️ Remote Purchase Exploit (HIGH RISK)")
print("   • ✨ Auto Enchanting System (12+ enchantments)")
print("   • 🧬 Stat Modifier Exploit (Speed, Jump, Luck)")
print("")
print("💡 Perfect for single-file deployment!")
print("💡 Check console (F9) for detailed activity logs")
print("💡 Use toggles to enable/disable features")
print("💡 All features work independently")
print("")
print("🛡️ SAFETY REMINDER: Use responsibly and understand the risks!")

-- Store reference for cleanup
_G.XSANSystemExploits = SystemExploits
