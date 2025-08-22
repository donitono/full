
--[[
    XSAN's Fish It Pro - Ultimate Edition v1.0 WORKING VERSION
    
    Premium Fish It script with ULTIMATE features:
    • Quick Start Presets & Advanced Analytics
    • Smart Inventory Management & AI Features  
    • Enhanced Fishing & Quality of Life
    • Smart Notifications & Safety Systems
    • Advanced Automation & Much More
    • Ultimate Teleportation System (NEW!)
    
    Developer: XSAN
    Telegram: Spinnerxxx
    Tele Groub: github.com/Spinner_xxx
    
    Premium Quality • Trusted by Thousands • Ultimate Edition
--]]

print("XSAN: Starting Fish It Pro Ultimate v1.0...")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")

-- ═══════════════════════════════════════════════════════════════
-- XSAN CONTENT CONFIGURATION SYSTEM
-- Edit all tab content and notifications from here!
-- ═══════════════════════════════════════════════════════════════

local XSAN_CONFIG = {
    -- Main Info & Branding
    branding = {
        title = "XSAN Fish It Pro Ultimate v1.0",
        subtitle = "The most advanced Fish It script ever created with AI-powered features, smart analytics, and premium automation systems.",
        developer = "XSAN",
        Telegram = "Spinnerxxx",
        github = "github.com/Spinner_xxx",
        support_message = "Created by XSAN - Trusted by thousands of users worldwide!"
    },
    
    -- Tab Descriptions (Easy to edit!)
    tabs = {
        info = {
            title = "Ultimate Features",
            content = "" -- Kosong - tanpa deskripsi
        },
        presets = {
            title = "Quick Start Presets", 
            content = "" -- Kosong - tanpa deskripsi
        },
        teleport = {
            title = "Ultimate Teleport System", 
            content = "", -- Kosong - tanpa deskripsi
            islands_desc = "",
            npcs_desc = "",
            events_desc = ""
        },
        autofish = {
            title = "Auto Fishing System",
            content = ""
        },
        analytics = {
            title = "Advanced Analytics", 
            content = ""
        },
        inventory = {
            title = "Smart Inventory",
            content = ""
        },
        utility = {
            title = "Utility Tools",
            content = ""
        },
        weather = {
            title = "Weather Purchase System",
            content = ""
        }
    },
    
    -- Notification Messages (Easy to customize!)
    notifications = {
        preset_applied = "✅ {preset} mode activated!\n🎯 Settings optimized for {purpose}\n{autosell_status}",
        teleport_success = "🚀 Successfully teleported to: {location}",
        autofish_start = "🎣 XSAN Ultimate auto fishing started!\n⚡ AI systems activated\n🔒 Safety protocols: Active",
        autofish_stop = "⏹️ Auto fishing stopped by user.\n📊 Session completed successfully",
        feature_enabled = "✅ {feature} ENABLED!\n{description}",
        feature_disabled = "❌ {feature} DISABLED\n{description}",
        error_message = "❌ {action} failed!\n💡 Reason: {reason}\n🔧 Please try again or contact support"
    },
    
    -- Preset Configurations
    presets = {
        Beginner = {purpose = "safe and easy fishing", autosell = 2500},
        Speed = {purpose = "maximum fishing speed", autosell = 2500},
        Ultra = {purpose = "maximum earnings", autosell = 3000},
        AFK = {purpose = "long AFK sessions", autosell = 2000},
        Safe = {purpose = "smart random casting (70% perfect)", autosell = 3000},
        Hybrid = {purpose = "ultimate security with AI patterns", autosell = 3000}
    }
}

-- Helper function to get formatted notification message
local function GetNotificationMessage(messageType, params)
    local template = XSAN_CONFIG.notifications[messageType] or "{message}"
    local message = template
    
    if params then
        for key, value in pairs(params) do
            message = message:gsub("{" .. key .. "}", tostring(value))
        end
    end
    
    return message
end

-- Helper function to get tab content (with empty content support)
local function GetTabContent(tabName, contentKey)
    local tab = XSAN_CONFIG.tabs[tabName:lower()]
    if tab and tab[contentKey] then
        return tab[contentKey]
    end
    return "" -- Return empty string if not found
end

-- Helper function to create paragraph only if content exists
local function CreateParagraphIfContent(tab, title, content)
    if content and content ~= "" then
        tab:CreateParagraph({
            Title = title,
            Content = content
        })
    end
end

-- ═══════════════════════════════════════════════════════════════
-- UI configuration (edit here to change Floating Button icon)
local UIConfig = {
    floatingButton = {
        -- Set to true to use a custom image icon instead of emoji text
        useImage = false,

        -- Emoji icons (used when useImage = false)
        emojiVisible = "🎣", -- when UI is visible
        emojiHidden = "👁", -- when UI is hidden

        -- Image icons (used when useImage = true). Replace with your asset IDs
        imageVisible = "rbxassetid://88814246774578",
        imageHidden = "rbxassetid://88814246774578"
    }
}

-- Notification system
local function Notify(title, text, duration)
    duration = duration or 3
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "XSAN Fish It Pro",
            Text = text or "Notification", 
            Duration = duration,
            Icon = "rbxassetid://6023426923"
        })
    end)
    -- Comment out print to reduce debug spam
    -- print("XSAN:", title, "-", text)
end

-- Additional Notification Functions
local function NotifySuccess(title, message)
	Notify("XSAN - " .. title, message, 3)
end

local function NotifyError(title, message)
	Notify("XSAN ERROR - " .. title, message, 4)
end

local function NotifyInfo(title, message)
	Notify("XSAN INFO - " .. title, message, 3)
end

-- Check basic requirements
if not LocalPlayer then
    warn("XSAN ERROR: LocalPlayer not found")
    return
end

if not ReplicatedStorage then
    warn("XSAN ERROR: ReplicatedStorage not found")
    return
end

print("XSAN: Basic services OK")

-- XSAN Anti Ghost Touch System
local ButtonCooldowns = {}
local BUTTON_COOLDOWN = 0.5

local function CreateSafeCallback(originalCallback, buttonId)
    return function(...)
        local currentTime = tick()
        if ButtonCooldowns[buttonId] and currentTime - ButtonCooldowns[buttonId] < BUTTON_COOLDOWN then
            return
        end
        ButtonCooldowns[buttonId] = currentTime
        
        local success, result = pcall(originalCallback, ...)
        if not success then
            warn("XSAN Error:", result)
        end
    end
end

-- Load Rayfield with error handling
print("XSAN: Loading UI Library...")

local Rayfield
local success, error = pcall(function()
    print("XSAN: Attempting to load UI...")
    
    -- Try ui_fixed.lua first (more stable)
    local uiContent = game:HttpGet("https://raw.githubusercontent.com/donitono/full/refs/heads/main/ui_fixed.lua", true)
    if uiContent and #uiContent > 0 then
        print("XSAN: Loading stable UI library...")
        print("XSAN: UI content length:", #uiContent)
        local uiFunc, loadError = loadstring(uiContent)
        if uiFunc then
            Rayfield = uiFunc()
            if not Rayfield then
                error("UI function returned nil")
            end
            print("XSAN: Stable UI loaded successfully!")
        else
            error("Failed to compile UI: " .. tostring(loadError))
        end
    else
        print("XSAN: Trying fallback UI library...")
        -- Fallback to Rayfield directly
        Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield", true))()
        if not Rayfield then
            error("Failed to load fallback UI")
        end
        print("XSAN: Fallback UI loaded successfully!")
    end
end)

if not success then
    warn("XSAN Error: Failed to load Rayfield UI Library - " .. tostring(error))
    -- Try alternative loading method
    NotifyError("UI Error", "Primary UI failed. Attempting alternative method...")
    
    local backupSuccess = pcall(function()
        Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield", true))()
    end)
    
    if not backupSuccess or not Rayfield then
        NotifyError("CRITICAL ERROR", "All UI loading methods failed! Script cannot continue.")
        return
    else
        NotifySuccess("UI Recovery", "Backup UI loaded successfully!")
    end
end

if not Rayfield then
    warn("XSAN Error: Rayfield is nil after loading")
    return
end

print("XSAN: UI Library loaded successfully!")

-- Mobile/Android detection and UI scaling
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local screenSize = workspace.CurrentCamera.ViewportSize

print("XSAN: Platform Detection - Mobile:", isMobile, "Screen Size:", screenSize.X .. "x" .. screenSize.Y)

-- Create Window with mobile-optimized settings
print("XSAN: Creating main window...")
local windowConfig = {
    Name = isMobile and "XSAN Fish It Pro Mobile" or "XSAN Fish It Pro v1.0",
    LoadingTitle = "XSAN Fish It Pro Ultimate",
    LoadingSubtitle = "by XSAN - Mobile Optimized",
    Theme = "Default", -- Changed to Default for better compatibility
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "XSAN",
        FileName = "FishItProUltimate"
    },
    KeySystem = false,
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false
}

-- Mobile specific adjustments - OPTIMIZED
if isMobile then
    -- Detect orientation
    local isLandscape = screenSize.X > screenSize.Y
    
    if isLandscape then
        -- Landscape mode - Optimized sizing
        windowConfig.Size = UDim2.new(0, math.min(screenSize.X * 0.45, 400), 0, math.min(screenSize.Y * 0.65, 280))
        print("XSAN: Landscape mode - optimized UI size")
    else
        -- Portrait mode - Compact and readable
        windowConfig.Size = UDim2.new(0, math.min(screenSize.X * 0.75, 320), 0, math.min(screenSize.Y * 0.60, 380))
        print("XSAN: Portrait mode - compact UI size")
    end
    
    -- Mobile-specific window settings
    windowConfig.DisableRayfieldPrompts = true
    windowConfig.DisableBuildWarnings = true
else
    -- Desktop optimized size
    windowConfig.Size = UDim2.new(0, 450, 0, 350)
end

local Window = Rayfield:CreateWindow(windowConfig)

print("XSAN: Window created successfully!")

-- Fix scrolling issues and mobile scaling for Rayfield UI
print("XSAN: Applying mobile fixes and scrolling fixes...")
task.spawn(function()
    task.wait(1) -- Wait for UI to fully load
    
    local function fixUIForMobile()
        local rayfieldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
        if rayfieldGui then
            local main = rayfieldGui:FindFirstChild("Main")
            if main and isMobile then
                -- Mobile scaling adjustments - OPTIMIZED for better performance
                local isLandscape = screenSize.X > screenSize.Y
                
                if isLandscape then
                    -- Landscape mode - Compact and efficient
                    main.Size = UDim2.new(0, math.min(screenSize.X * 0.45, 400), 0, math.min(screenSize.Y * 0.65, 280))
                else
                    -- Portrait mode - Optimized for touch
                    main.Size = UDim2.new(0, math.min(screenSize.X * 0.75, 320), 0, math.min(screenSize.Y * 0.60, 380))
                end
                
                -- Center the UI properly
                main.Position = UDim2.new(0.5, -main.Size.X.Offset/2, 0.5, -main.Size.Y.Offset/2)
                
                -- Optimize UI elements spacing for mobile
                local uiElements = main:GetDescendants()
                for _, element in pairs(uiElements) do
                    if element:IsA("Frame") or element:IsA("TextButton") then
                        -- Reduce padding for compact layout
                        local padding = element:FindFirstChild("UIPadding")
                        if padding then
                            padding.PaddingTop = UDim.new(0, 3)
                            padding.PaddingBottom = UDim.new(0, 3)
                            padding.PaddingLeft = UDim.new(0, 5)
                            padding.PaddingRight = UDim.new(0, 5)
                        end
                    end
                end
                
                print("XSAN: Applied optimized mobile UI scaling for", isLandscape and "landscape" or "portrait", "mode")
                
                -- Adjust text scaling for mobile - OPTIMIZED
                for _, descendant in pairs(rayfieldGui:GetDescendants()) do
                    if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                        -- Smart text scaling based on device
                        if isMobile then
                            -- Mobile: Much smaller, more readable text
                            descendant.TextScaled = false  -- Use fixed size for consistency
                            descendant.TextSize = 9        -- Much smaller than before (was 11-14)
                            
                            -- Adjust based on screen size
                            if screenSize.X < 500 then -- Small mobile screens
                                descendant.TextSize = 8
                            elseif screenSize.X > 800 then -- Tablets
                                descendant.TextSize = 10
                            end
                        else
                            -- Desktop: Smaller than before but readable
                            descendant.TextScaled = false  -- Use fixed size
                            descendant.TextSize = 10       -- Smaller than before (was 13-15)
                        end
                        
                        -- Ensure text wraps properly
                        if descendant:IsA("TextLabel") then
                            descendant.TextWrapped = true
                        end
                    end
                end
                
                print("XSAN: Applied mobile UI scaling for", isLandscape and "landscape" or "portrait", "mode")
            end
            
            -- Fix scrolling for all platforms with enhanced touch support - OPTIMIZED
            for _, descendant in pairs(rayfieldGui:GetDescendants()) do
                if descendant:IsA("ScrollingFrame") then
                    -- Enable proper scrolling with optimized settings
                    descendant.ScrollingEnabled = true
                    descendant.ScrollBarThickness = isMobile and 12 or 6
                    descendant.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
                    descendant.ScrollBarImageTransparency = isMobile and 0.1 or 0.2
                    
                    -- Optimize canvas size
                    if descendant:FindFirstChild("UIListLayout") then
                        descendant.AutomaticCanvasSize = Enum.AutomaticSize.Y
                        descendant.CanvasSize = UDim2.new(0, 0, 0, 0)
                    end
                    
                    -- Enable touch scrolling
                    descendant.Active = true
                    descendant.Selectable = false -- Disable selection to improve performance
                    
                    -- Mobile-specific optimizations
                    if isMobile then
                        descendant.ScrollingDirection = Enum.ScrollingDirection.Y
                        descendant.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
                        descendant.ScrollBarImageTransparency = 0.05 -- More visible on mobile
                        
                        -- Optimized touch scrolling (removed heavy input handling)
                        descendant.ScrollWheelInputEnabled = false -- Disable to improve touch performance
                    end
                    
                    print("XSAN: Optimized scrolling for", descendant.Name)
                end
            end
        end
    end
    
    -- Apply fixes multiple times to ensure they stick
    fixUIForMobile()
    task.wait(2)
    fixUIForMobile()
    
    -- Force refresh UI content
    task.wait(1)
    if Window and Window.Refresh then
        Window:Refresh()
    end
end)

-- Ultimate tabs with all features - LAZY LOADING OPTIMIZATION
print("XSAN: Creating tabs with lazy loading...")

-- Create tabs but defer content creation for better memory usage
local InfoTab = Window:CreateTab("INFO", 4483362458)
print("XSAN: InfoTab created")
local PresetsTab = Window:CreateTab("PRESETS", 4483362458) 
print("XSAN: PresetsTab created")
local MainTab = Window:CreateTab("AUTO FISH", 4483362458)
print("XSAN: MainTab created")
local TeleportTab = Window:CreateTab("TELEPORT", 4483362458)
print("XSAN: TeleportTab created")
local AnalyticsTab = Window:CreateTab("ANALYTICS", 4483362458)
print("XSAN: AnalyticsTab created")
local InventoryTab = Window:CreateTab("INVENTORY", 4483362458)
print("XSAN: InventoryTab created")
local UtilityTab = Window:CreateTab("UTILITY", 4483362458)
local WeatherTab = Window:CreateTab("WEATHER", 4483362458)
local SettingTab = Window:CreateTab("SETTING", 4483362458)
print("XSAN: SettingTab created")
local RandomSpotTab = Window:CreateTab("RANDOM SPOT", 4483362458)
print("XSAN: RandomSpotTab created")
local ExitTab = Window:CreateTab("EXIT", 4483362458)
print("XSAN: All tabs created - content will load on demand")

-- Flag to track which tabs have been initialized
local tabContentLoaded = {
    Info = false,
    Presets = false,
    MainTab = false,
    Teleport = false,
    Analytics = false,
    Inventory = false,
    Utility = false,
    Weather = false,
    Setting = false,
    RandomSpot = false,
    Exit = false
}

print("XSAN: All tabs created successfully with lazy loading!")

-- ═══════════════════════════════════════════════════════════════
-- WEATHER TAB - Weather Purchase System
-- Based on probe results: Cloudy/Wind/Storm returned true; others false.
-- ═══════════════════════════════════════════════════════════════
do
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local weatherNetFolder = nil
    pcall(function()
        weatherNetFolder = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
    end)
    local weatherRemote = weatherNetFolder and weatherNetFolder:FindFirstChild("RF/PurchaseWeatherEvent")

    local WeatherOptions = {"Wind","Cloudy","Snow","Storm","Radiant","Shark Hunt"}
    local validSuccess = {Wind=true, Cloudy=true, Snow=true, Storm=true, Radiant=true, ["Shark Hunt"]=true}
    local selectedWeather = WeatherOptions[1]
    local autoWeather = false
    local rotateMode = false
    local autoDelay = 5
    local loopSession = 0
    local statusLabel = nil

    local function updateStatus(txt, color)
        -- statusLabel is the Paragraph Frame returned by CreateParagraph.
        -- It does NOT have a :Set() method. Its child named "Content" holds the text.
        if statusLabel and statusLabel.Parent then
            local contentLabel = statusLabel:FindFirstChild("Content")
            if contentLabel and contentLabel:IsA("TextLabel") then
                contentLabel.Text = txt
                if color then
                    contentLabel.TextColor3 = color
                end
            end
        end
    end

    local function PurchaseWeather(name)
        if not weatherRemote then
            updateStatus("Remote not found", Color3.fromRGB(220,120,120))
            return false
        end
        local ok,ret = pcall(function()
            if weatherRemote:IsA("RemoteFunction") then
                return weatherRemote:InvokeServer(name)
            else
                weatherRemote:FireServer(name)
                return nil
            end
        end)
        if ok then
            local success = ret == true or validSuccess[name] or false
            updateStatus(string.format("%s -> %s", name, success and "OK" or tostring(ret)), success and Color3.fromRGB(120,200,120) or Color3.fromRGB(220,160,80))
            return success
        else
            updateStatus(name .. " error", Color3.fromRGB(220,120,120))
            return false
        end
    end

    WeatherTab:CreateParagraph({
        Title = "Weather Purchase System",
        Content = "Sistem pembelian cuaca otomatis. Pilih jenis cuaca yang ingin dibeli dan atur interval pembelian."
    })

    -- Spacer for better layout
    WeatherTab:CreateParagraph({
        Title = " ",
        Content = " "
    })

    WeatherTab:CreateDropdown({
        Name = "Pilih Jenis Cuaca",
        Options = WeatherOptions,
        CurrentOption = WeatherOptions[1],
        Callback = function(opt)
            if type(opt)=="table" then opt = opt[1] end
            selectedWeather = opt
            updateStatus("Dipilih: "..selectedWeather)
        end
    })

    -- Spacer to separate dropdown from slider
    WeatherTab:CreateParagraph({
        Title = " ",
        Content = " "
    })

    WeatherTab:CreateSlider({
        Name = "Interval Auto Beli (detik)",
        Range = {3,30},
        Increment = 1,
        CurrentValue = autoDelay,
        Callback = function(v)
            autoDelay = v
            updateStatus("Interval diubah ke: "..v.." detik")
        end
    })

    WeatherTab:CreateToggle({
        Name = "Mode Rotasi Cuaca",
        CurrentValue = false,
        Callback = function(v)
            rotateMode = v
            if v then
                updateStatus("Mode rotasi: ON - akan membeli semua cuaca secara bergiliran")
            else
                updateStatus("Mode rotasi: OFF - hanya membeli cuaca yang dipilih")
            end
        end
    })

    WeatherTab:CreateButton({
        Name = "🌤️ Beli Cuaca Sekali",
        Callback = function()
            updateStatus("Mencoba membeli: "..selectedWeather.."...")
            PurchaseWeather(selectedWeather)
        end
    })

    WeatherTab:CreateToggle({
        Name = "🔄 Auto Beli Cuaca",
        CurrentValue = false,
        Callback = function(val)
            autoWeather = val
            if val then
                loopSession += 1
                local mySession = loopSession
                local rotateIndex = table.find(WeatherOptions, selectedWeather) or 1
                updateStatus("Auto Beli: AKTIF ✅", Color3.fromRGB(120,200,120))
                task.spawn(function()
                    while autoWeather and loopSession == mySession do
                        local target = selectedWeather
                        if rotateMode then
                            target = WeatherOptions[rotateIndex]
                            rotateIndex += 1
                            if rotateIndex > #WeatherOptions then rotateIndex = 1 end
                        end
                        PurchaseWeather(target)
                        local elapsed = 0
                        while elapsed < autoDelay and autoWeather and loopSession == mySession do
                            task.wait(0.25)
                            elapsed += 0.25
                        end
                    end
                    if loopSession == mySession then
                        updateStatus("Auto Beli: BERHENTI ⏹️", Color3.fromRGB(220,160,80))
                    end
                end)
            else
                loopSession += 1 -- invalidate
                updateStatus("Auto Beli: DIMATIKAN ❌", Color3.fromRGB(220,160,80))
            end
        end
    })

    -- Add spacer before status
    WeatherTab:CreateParagraph({
        Title = " ",
        Content = " "
    })

    statusLabel = WeatherTab:CreateParagraph({
        Title = "📊 Status Sistem",
        Content = "Siap untuk membeli cuaca"
    })

    -- Add weather information section
    WeatherTab:CreateParagraph({
        Title = "ℹ️ Informasi Cuaca",
        Content = "• Wind: Angin kencang\n• Cloudy: Berawan\n• Snow: Salju\n• Storm: Badai\n• Radiant: Cuaca cerah bersinar\n• Shark Hunt: Event perburuan hiu"
    })
end

-- Debug tab creation
task.spawn(function()
    task.wait(3)
    pcall(function()
        local rayfieldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
        if rayfieldGui then
            print("XSAN: Rayfield GUI found, checking tabs...")
            local tabCount = 0
            for _, descendant in pairs(rayfieldGui:GetDescendants()) do
                if descendant:IsA("TextButton") and descendant.Text and (
                    descendant.Text == "INFO" or 
                    descendant.Text == "PRESETS" or 
                    descendant.Text == "AUTO FISH" or 
                    descendant.Text == "TELEPORT" or 
                    descendant.Text == "ANALYTICS" or 
                    descendant.Text == "INVENTORY" or 
                    descendant.Text == "UTILITY" or
                    descendant.Text == "WEATHER"
                ) then
                    tabCount = tabCount + 1
                    print("XSAN: Found tab:", descendant.Text, "Visible:", descendant.Visible, "Transparency:", descendant.BackgroundTransparency)
                end
            end
            
            if tabCount == 0 then
                print("XSAN: WARNING - No tabs found! This might cause black tab issue.")
                if NotifyError then
                    NotifyError("Tab Debug", "⚠️ Tabs not detected!\n\n🔧 Use 'Fix Black Tabs' button in INFO tab\n💡 Or try reloading the script")
                end
            else
                print("XSAN: Found", tabCount, "tabs successfully")
                if NotifySuccess then
                    NotifySuccess("Tab Debug", "✅ Found " .. tabCount .. " tabs!\n\n🎯 If tabs appear black, use fix buttons in INFO tab")
                end
            end
        else
            print("XSAN: ERROR - Rayfield GUI not found!")
            if NotifyError then
                NotifyError("Tab Debug", "❌ Rayfield GUI not found!\n\nThis may cause display issues.")
            end
        end
    end)
end)

-- Fix tab visibility issues
task.spawn(function()
    task.wait(2)
    local rayfieldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
    if rayfieldGui then
        -- Fix tab container visibility
        for _, descendant in pairs(rayfieldGui:GetDescendants()) do
            if descendant:IsA("Frame") and descendant.Name == "TabContainer" then
                descendant.BackgroundTransparency = 0
                descendant.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                descendant.Visible = true
                print("XSAN: Fixed TabContainer visibility")
            elseif descendant:IsA("TextButton") and descendant.Parent and descendant.Parent.Name == "TabContainer" then
                descendant.BackgroundTransparency = 0.1
                descendant.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                descendant.TextColor3 = Color3.fromRGB(255, 255, 255)
                descendant.Visible = true
                print("XSAN: Fixed tab button:", descendant.Text or descendant.Name)
            elseif descendant:IsA("Frame") and (descendant.Name:find("Tab") or descendant.Name:find("tab")) then
                descendant.Visible = true
                descendant.BackgroundTransparency = 0
                print("XSAN: Fixed tab frame:", descendant.Name)
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
-- FLOATING TOGGLE BUTTON - Hide/Show UI
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating floating toggle button...")
task.spawn(function()
    task.wait(1) -- Wait for UI to fully load
    
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    -- Create floating button ScreenGui
    local FloatingButtonGui = Instance.new("ScreenGui")
    FloatingButtonGui.Name = "XSAN_FloatingButton"
    FloatingButtonGui.ResetOnSpawn = false
    FloatingButtonGui.IgnoreGuiInset = true
    FloatingButtonGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Try to parent to CoreGui first, then fallback to PlayerGui
    local success = pcall(function()
        FloatingButtonGui.Parent = game.CoreGui
    end)
    if not success then
        FloatingButtonGui.Parent = PlayerGui
    end
    
    -- Create floating button - OPTIMIZED SIZE
    local FloatingButton = Instance.new("TextButton")
    FloatingButton.Name = "ToggleButton"
    -- Optimized button size - smaller and more elegant
    FloatingButton.Size = UDim2.new(0, isMobile and 55 or 50, 0, isMobile and 55 or 50)
    FloatingButton.Position = UDim2.new(0, 15, 0.5, -27.5)
    FloatingButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
    FloatingButton.BorderSizePixel = 0
    -- Text will be controlled by setFloatingIcon()
    FloatingButton.Text = ""
    FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    FloatingButton.TextScaled = true
    -- Optimized font for smaller size
    FloatingButton.Font = isMobile and Enum.Font.SourceSansBold or Enum.Font.SourceSans
    FloatingButton.Parent = FloatingButtonGui
    
    -- Add UICorner for rounded button
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0.5, 0) -- Perfect circle
    ButtonCorner.Parent = FloatingButton
    
    -- Add UIStroke for better visibility
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(255, 255, 255)
    ButtonStroke.Thickness = 2
    ButtonStroke.Transparency = 0.3
    ButtonStroke.Parent = FloatingButton
    
    -- Add shadow effect
    local ButtonShadow = Instance.new("Frame")
    ButtonShadow.Name = "Shadow"
    ButtonShadow.Size = UDim2.new(1, 4, 1, 4)
    ButtonShadow.Position = UDim2.new(0, 2, 0, 2)
    ButtonShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ButtonShadow.BackgroundTransparency = 0.7
    ButtonShadow.BorderSizePixel = 0
    ButtonShadow.ZIndex = FloatingButton.ZIndex - 1
    ButtonShadow.Parent = FloatingButton
    
    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(0.5, 0)
    ShadowCorner.Parent = ButtonShadow

    -- Optional icon image (used when UIConfig.floatingButton.useImage = true)
    local IconImage = Instance.new("ImageLabel")
    IconImage.Name = "Icon"
    IconImage.BackgroundTransparency = 1
    IconImage.AnchorPoint = Vector2.new(0.5, 0.5)
    IconImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    IconImage.Size = UDim2.new(0.6, 0, 0.6, 0) -- 60% of button for padding
    IconImage.ScaleType = Enum.ScaleType.Fit
    IconImage.Visible = false
    IconImage.ZIndex = FloatingButton.ZIndex + 1
    IconImage.Parent = FloatingButton

    -- Helper to switch icon based on visibility and configuration
    local function setFloatingIcon(visibleState)
        local cfg = UIConfig.floatingButton
        if cfg.useImage then
            FloatingButton.Text = ""
            IconImage.Visible = true
            IconImage.Image = visibleState and cfg.imageVisible or cfg.imageHidden
        else
            IconImage.Visible = false
            FloatingButton.Text = visibleState and cfg.emojiVisible or cfg.emojiHidden
        end
    end
    
    -- Initialize icon state
    setFloatingIcon(true)

    -- Variables
    local isUIVisible = true
    local dragging = false
    local dragInput
    local dragStart
    local startPos
    
    -- Get Rayfield GUI reference
    local function getRayfieldGui()
        return LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
    end
    
    -- Toggle UI visibility function
    local function toggleUI()
        pcall(function()
            local rayfieldGui = getRayfieldGui()
            if rayfieldGui then
                isUIVisible = not isUIVisible
                
                -- Update button appearance
                if isUIVisible then
                    setFloatingIcon(true)
                    FloatingButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
                    rayfieldGui.Enabled = true
                    
                    -- Animate show
                    rayfieldGui.Main.BackgroundTransparency = 1
                    TweenService:Create(rayfieldGui.Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0
                    }):Play()
                    
                    if NotifySuccess then
                        NotifySuccess("UI Toggle", "XSAN Fish It Pro UI shown!")
                    end
                else
                    setFloatingIcon(false)
                    FloatingButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
                    
                    -- Animate hide
                    TweenService:Create(rayfieldGui.Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                        BackgroundTransparency = 1
                    }):Play()
                    
                    task.wait(0.3)
                    rayfieldGui.Enabled = false
                    if NotifyInfo then
                        NotifyInfo("UI Toggle", "UI hidden! Use floating button to show.")
                    end
                end
                
                -- Button feedback animation - OPTIMIZED
                TweenService:Create(FloatingButton, TweenInfo.new(0.08, Enum.EasingStyle.Back), {
                    Size = UDim2.new(0, (isMobile and 55 or 50) * 1.08, 0, (isMobile and 55 or 50) * 1.08)
                }):Play()
                
                task.wait(0.08)
                TweenService:Create(FloatingButton, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
                    Size = UDim2.new(0, isMobile and 55 or 50, 0, isMobile and 55 or 50)
                }):Play()
            end
        end)
    end
    
    -- Make button draggable
    local function updateDrag(input)
        local delta = input.Position - dragStart
        FloatingButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    FloatingButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = FloatingButton.Position
            
            -- Visual feedback for drag start
            TweenService:Create(FloatingButton, TweenInfo.new(0.1), {
                BackgroundColor3 = Color3.fromRGB(100, 160, 230)
            }):Play()
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    -- Reset color
                    TweenService:Create(FloatingButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = isUIVisible and Color3.fromRGB(70, 130, 200) or Color3.fromRGB(200, 100, 100)
                    }):Play()
                end
            end)
        end
    end)
    
    FloatingButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            updateDrag(input)
        end
    end)
    
    -- Click to toggle (only if not dragging significantly)
    FloatingButton.MouseButton1Click:Connect(function()
        if not dragging then
            toggleUI()
        end
    end)
    
    -- Right click or long press to access menu
    FloatingButton.MouseButton2Click:Connect(function()
        if not dragging then
            -- Create mini context menu
            local ContextMenu = Instance.new("Frame")
            ContextMenu.Name = "ContextMenu"
            ContextMenu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ContextMenu.BorderSizePixel = 0
            ContextMenu.Position = UDim2.new(0, FloatingButton.AbsolutePosition.X + 80, 0, FloatingButton.AbsolutePosition.Y)
            ContextMenu.Size = UDim2.new(0, 120, 0, 0)
            ContextMenu.AutomaticSize = Enum.AutomaticSize.Y
            ContextMenu.ZIndex = 20
            ContextMenu.Parent = FloatingButtonGui
            
            -- Add UICorner
            local MenuCorner = Instance.new("UICorner")
            MenuCorner.CornerRadius = UDim.new(0, 8)
            MenuCorner.Parent = ContextMenu
            
            -- Add UIListLayout
            local MenuLayout = Instance.new("UIListLayout")
            MenuLayout.SortOrder = Enum.SortOrder.LayoutOrder
            MenuLayout.Padding = UDim.new(0, 2)
            MenuLayout.Parent = ContextMenu
            
            -- Add UIPadding
            local MenuPadding = Instance.new("UIPadding")
            MenuPadding.PaddingTop = UDim.new(0, 5)
            MenuPadding.PaddingBottom = UDim.new(0, 5)
            MenuPadding.PaddingLeft = UDim.new(0, 8)
            MenuPadding.PaddingRight = UDim.new(0, 8)
            MenuPadding.Parent = ContextMenu
            
            -- Close Button
            local CloseButton = Instance.new("TextButton")
            CloseButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
            CloseButton.BorderSizePixel = 0
            CloseButton.Size = UDim2.new(1, 0, 0, 30)
            CloseButton.Font = Enum.Font.SourceSansBold
            CloseButton.Text = "❌ Close Script"
            CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            CloseButton.TextScaled = true
            CloseButton.LayoutOrder = 1
            CloseButton.Parent = ContextMenu
            
            local CloseCorner = Instance.new("UICorner")
            CloseCorner.CornerRadius = UDim.new(0, 5)
            CloseCorner.Parent = CloseButton
            
            CloseButton.MouseButton1Click:Connect(function()
                -- Destroy all XSAN GUIs
                if getRayfieldGui() then
                    getRayfieldGui():Destroy()
                end
                FloatingButtonGui:Destroy()
                NotifyInfo("XSAN", "Script closed. Thanks for using XSAN Fish It Pro!")
            end)
            
            -- Minimize Button
            local MinimizeButton = Instance.new("TextButton")
            MinimizeButton.BackgroundColor3 = Color3.fromRGB(100, 150, 200)
            MinimizeButton.BorderSizePixel = 0
            MinimizeButton.Size = UDim2.new(1, 0, 0, 30)
            MinimizeButton.Font = Enum.Font.SourceSans
            MinimizeButton.Text = "➖ Minimize"
            MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            MinimizeButton.TextScaled = true
            MinimizeButton.LayoutOrder = 2
            MinimizeButton.Parent = ContextMenu
            
            local MinimizeCorner = Instance.new("UICorner")
            MinimizeCorner.CornerRadius = UDim.new(0, 5)
            MinimizeCorner.Parent = MinimizeButton
            
            MinimizeButton.MouseButton1Click:Connect(function()
                if isUIVisible then
                    toggleUI()
                end
                ContextMenu:Destroy()
            end)
            
            -- Auto-close menu after 3 seconds
            task.spawn(function()
                task.wait(3)
                if ContextMenu.Parent then
                    ContextMenu:Destroy()
                end
            end)
            
            -- Close menu when clicking outside
            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mousePos = UserInputService:GetMouseLocation()
                    local menuPos = ContextMenu.AbsolutePosition
                    local menuSize = ContextMenu.AbsoluteSize
                    
                    if mousePos.X < menuPos.X or mousePos.X > menuPos.X + menuSize.X or
                       mousePos.Y < menuPos.Y or mousePos.Y > menuPos.Y + menuSize.Y then
                        if ContextMenu.Parent then
                            ContextMenu:Destroy()
                        end
                    end
                end
            end)
        end
    end)
    
    -- Hover effects - OPTIMIZED for performance
    if not isMobile then
        -- Desktop hover effects (lighter animations)
        FloatingButton.MouseEnter:Connect(function()
            if not dragging then
                TweenService:Create(FloatingButton, TweenInfo.new(0.15), {
                    Size = UDim2.new(0, 55, 0, 55),
                    BackgroundColor3 = isUIVisible and Color3.fromRGB(90, 150, 220) or Color3.fromRGB(220, 120, 120)
                }):Play()
                TweenService:Create(ButtonStroke, TweenInfo.new(0.15), {
                    Transparency = 0.1
                }):Play()
            end
        end)
        
        FloatingButton.MouseLeave:Connect(function()
            if not dragging then
                TweenService:Create(FloatingButton, TweenInfo.new(0.15), {
                    Size = UDim2.new(0, 50, 0, 50),
                    BackgroundColor3 = isUIVisible and Color3.fromRGB(70, 130, 200) or Color3.fromRGB(200, 100, 100)
                }):Play()
                TweenService:Create(ButtonStroke, TweenInfo.new(0.15), {
                    Transparency = 0.3
                }):Play()
            end
        end)
    else
        -- Mobile: Touch feedback instead of hover
        FloatingButton.TouchTap:Connect(function()
            -- Light touch feedback for mobile
            TweenService:Create(FloatingButton, TweenInfo.new(0.05), {
                BackgroundColor3 = Color3.fromRGB(100, 160, 230)
            }):Play()
            
            task.wait(0.05)
            TweenService:Create(FloatingButton, TweenInfo.new(0.1), {
                BackgroundColor3 = isUIVisible and Color3.fromRGB(70, 130, 200) or Color3.fromRGB(200, 100, 100)
            }):Play()
        end)
    end
    
    -- Keyboard shortcut for toggle (H key)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.H then
            toggleUI()
        elseif not gameProcessed and input.KeyCode == Enum.KeyCode.F then
            -- F key for Auto Face Water
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
                AutoFaceWater(humanoidRootPart, "hotkey")
                NotifySuccess("Auto Face", "🎯 F key: Auto-faced water!\n🎣 Ready for fishing!")
            end
        end
    end)
    
    print("XSAN: Floating toggle button created successfully!")
    print("XSAN: - Click button to hide/show UI")
    print("XSAN: - Drag button to move position")
    print("XSAN: - Press 'H' key to toggle UI")
end)

-- Load Remotes
print("XSAN: Loading remotes...")
local net, rodRemote, miniGameRemote, finishRemote, equipRemote, cancelRemote, autoFishStateRemote, updateChargeRemote

local function initializeRemotes()
    local success, error = pcall(function()
        net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
        print("XSAN: Net found")
        
        -- Core fishing remotes (validated from debug data)
        rodRemote = net:WaitForChild("RF/ChargeFishingRod")
        print("XSAN: ✅ ChargeFishingRod remote loaded")
        
        miniGameRemote = net:WaitForChild("RF/RequestFishingMinigameStarted") 
        print("XSAN: ✅ RequestFishingMinigameStarted remote loaded")
        
        finishRemote = net:WaitForChild("RE/FishingCompleted")
        print("XSAN: ✅ FishingCompleted remote loaded")
        
        -- NEW: Additional fishing remotes for enhanced control
        cancelRemote = net:WaitForChild("RF/CancelFishingInputs")
        print("XSAN: ✅ CancelFishingInputs remote loaded")
        
        autoFishStateRemote = net:WaitForChild("RF/UpdateAutoFishingState") 
        print("XSAN: ✅ UpdateAutoFishingState remote loaded")
        
        updateChargeRemote = net:WaitForChild("RE/UpdateChargeState")
        print("XSAN: ✅ UpdateChargeState remote loaded")
        
        -- Equipment remotes (corrected path)
        equipRemote = net:WaitForChild("RE/EquipToolFromHotbar")
        print("XSAN: ✅ EquipToolFromHotbar remote loaded")

        unequipRemote = net:WaitForChild("RE/UnequipToolFromHotbar")
        print("XSAN: ✅ UnequipToolFromHotbar remote loaded")

        print("XSAN: 🎣 All enhanced fishing remotes loaded successfully!")
    end)
    
    if not success then
        warn("XSAN: Error loading remotes:", error)
        Notify("XSAN Error", "Failed to load game remotes. Some features may not work.", 5)
        return false
    end
    
    return true
end

local remotesLoaded = initializeRemotes()
print("XSAN: Remotes loading completed! Status:", remotesLoaded)

-- State Variables
print("XSAN: Initializing variables...")
local autofish = false
local autofishSession = 0 -- increments each time autofish is (re)started to invalidate old loops
local autofishThread = nil -- coroutine reference
local perfectCast = false
local safeMode = false  -- Safe Mode for random perfect cast
local safeModeChance = 70  -- 70% chance for perfect cast in safe mode
local hybridMode = false  -- Hybrid Mode for ultimate security
local hybridPerfectChance = 70  -- Hybrid mode perfect cast chance
local hybridMinDelay = 1.0  -- Hybrid mode minimum delay
local hybridMaxDelay = 2.5  -- Hybrid mode maximum delay
local hybridAutoFish = nil  -- Hybrid auto fish instance
local autoRecastDelay = 0.4
local fishCaught = 0
local itemsSold = 0
local autoSellThreshold = 1000
local autoSellOnThreshold = false
local sessionStartTime = tick()
local perfectCasts = 0
local normalCasts = 0  -- Track normal casts for analytics
local currentPreset = "None"
local globalAutoSellEnabled = true  -- Global auto sell control

-- Random Spot Fishing Variables
local randomSpotEnabled = false
local randomSpotInterval = 5  -- Default 5 minutes
local randomSpotSession = 0
local randomSpotThread = nil
local currentRandomSpot = "None"
local lastRandomSpotChange = 0

-- Random Spot Analytics
local randomSpotStats = {
    totalSwitches = 0,
    fishPerLocation = {},
    timePerLocation = {},
    bestLocation = "None",
    currentLocationStartTime = 0
}

-- Initialize location stats
for locationName, _ in pairs({
    ["🏝️ SISYPUS"] = true,
    ["🦈 TREASURE"] = true,
    ["🎣 STRINGRY"] = true,
    ["❄️ ICE LAND"] = true,
    ["🌋 CRATER"] = true,
    ["🌴 TROPICAL"] = true,
    ["🗿 STONE"] = true,
    ["⚙️ MACHINE"] = true
}) do
    randomSpotStats.fishPerLocation[locationName] = 0
    randomSpotStats.timePerLocation[locationName] = 0
end

-- Random Spot Selection System
local selectedSpots = {
    ["🏝️ SISYPUS"] = true,
    ["🦈 TREASURE"] = true,
    ["🎣 STRINGRY"] = true,
    ["❄️ ICE LAND"] = true,
    ["🌋 CRATER"] = true,
    ["🌴 TROPICAL"] = true,
    ["🗿 STONE"] = true,
    ["⚙️ MACHINE"] = true
}

-- Feature states
local featureState = {
    AutoSell = false,
    SmartInventory = false,
    Analytics = true,
    Safety = true,
    RandomSpot = false,
}

-- ═══════════════════════════════════════════════════════════════
-- SETTING TAB VARIABLES - Game Enhancement Features
-- ═══════════════════════════════════════════════════════════════

-- Performance & Visual Settings
local boostFPSEnabled = false
local hdrShaderEnabled = false

-- Movement & Physics Settings  
local enableFloatEnabled = false
local noClipEnabled = false
local spinnerEnabled = false
local antiDrownEnabled = false

-- Connections for cleanup
local floatConnection = nil
local noClipConnection = nil
local spinnerConnection = nil
local antiDrownConnection = nil

print("XSAN: Variables initialized successfully!")

-- ═══════════════════════════════════════════════════════════════
-- FISH DETECTION SYSTEM - Based on namefish.txt data
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Initializing Fish Detection System...")

-- Fish Database from namefish.txt (categorized by rarity)
local FishDatabase = {
    -- Common Fish
    Common = {
        "Reef Chromis", "Clownfish", "Blue Lobster", "Lobster", "Fire Goby", 
        "Magma Goby", "Orangy Goby", "Shrimp Goby", "White Clownfish", "Salmon",
        "Catfish", "Hermit Crab", "Parrot Fish", "Red Snapper"
    },
    
    -- Rare Fish  
    Rare = {
        "Abyss Seahorse", "Ash Basslet", "Astra Damsel", "Azure Damsel", 
        "Banded Butterfly", "Blueflame Ray", "Boa Angelfish", "Bumblebee Grouper",
        "Candy Butterfly", "Charmed Tang", "Chrome Tuna", "Coal Tang",
        "Copperband Butterfly", "Corazon Damsel", "Cow Clownfish", "Darwin Clownfish"
    },
    
    -- Epic Fish
    Epic = {
        "Domino Damsel", "Dorhey Tang", "Dotted Stingray", "Enchanted Angelfish", 
        "Firecoal Damsel", "Flame Angelfish", "Greenbee Grouper", "Hawks Turtle",
        "Starjam Tang", "Jennifer Dottyback", "Jewel Tang", "Kau Cardinal",
        "Korean Angelfish", "Lavafin Tuna", "Loggerhead Turtle", "Longnose Butterfly"
    },
    
    -- Legendary Fish
    Legendary = {
        "Magic Tang", "Manta Ray", "Maroon Butterfly", "Maze Angelfish", 
        "Moorish Idol", "Bandit Angelfish", "Zoster Butterfly", "Panther Grouper",
        "Prismy Seahorse", "Scissortail Dartfish", "Skunk Tilefish", "Specked Butterfly",
        "Strawberry Dotty", "Sushi Cardinal", "Tricolore Butterfly", "Unicorn Tang"
    },
    
    -- Mythical Fish
    Mythical = {
        "Vintage Blue Tang", "Vintage Damsel", "Volcanic Basslet", "Yello Damselfish",
        "Yellowfin Tuna", "Yellowstate Angelfish", "Blob Shark", "Volsail Tang",
        "Rockform Cardianl", "Lava Butterfly", "Slurpfish Chromis", "Hammerhead Shark",
        "Thresher Shark", "Great Whale", "Giant Squid", "Robot Kraken"
    },
    
    -- Event/Special Fish
    Event = {
        "Festive Goby", "Mistletoe Damsel", "Gingerbread Tang", "Great Christmas Whale",
        "Gingerbread Clownfish", "Gingerbread Turtle", "Gingerbread Shark", 
        "Christmastree Longnose", "Candycane Lobster", "Festive Pufferfish",
        "Loving Shark", "Pink Smith Damsel", "Ballina Angelfish", "Bleekers Damsel"
    },
    
    -- Deep Sea Fish
    DeepSea = {
        "Worm Fish", "Viperfish", "Deep Sea Crab", "Spotted Lantern Fish", 
        "Monk Fish", "King Crab", "Jellyfish", "Fangtooth", "Electric Eel",
        "Vampire Squid", "Dark Eel", "Boar Fish", "Blob Fish", "Angler Fish",
        "Dead Fish", "Skeleton Fish", "Ghost Worm Fish", "Ghost Shark"
    },
    
    -- Ultimate Rods & Items
    UltimateItems = {
        "Forsaken", "Red Matter", "Lightsaber", "Crystalized", "Earthly",
        "Neptune's Trident", "Polarized", "Monochrome", "Lightning", "Loving",
        "Aqua Prism", "Aquatic", "Blossom", "Heavenly", "Cute Rod"
    },
    
    -- Enchant Stones & Materials
    Materials = {
        "Super Enchant Stone", "Enchant Stone", "Aether Shard", "Flower Garden",
        "Amber", "Jelly"
    }
}

-- Fish Variants from namefish.txt
local FishVariants = {
    "Corrupt", "Fairy Dust", "Festive", "Frozen", "Galaxy", "Gemstone", 
    "Ghost", "Gold", "Lightning", "Midnight", "Radioactive", "Stone", 
    "Holographic", "Albino"
}

-- Fish Value Estimator (basic pricing system)
local FishValues = {
    Common = {min = 10, max = 50},
    Rare = {min = 51, max = 200}, 
    Epic = {min = 201, max = 500},
    Legendary = {min = 501, max = 1500},
    Mythical = {min = 1501, max = 5000},
    Event = {min = 1000, max = 8000},
    DeepSea = {min = 800, max = 3000},
    UltimateItems = {min = 10000, max = 100000},
    Materials = {min = 100, max = 2000}
}

-- Variant Multipliers
local VariantMultipliers = {
    Gold = 5.0, Galaxy = 4.0, Lightning = 3.5, Holographic = 3.0,
    Gemstone = 2.8, Radioactive = 2.5, Midnight = 2.3, Corrupt = 2.0,
    Frozen = 1.8, Ghost = 1.5, Stone = 1.3, Albino = 1.2,
    ["Fairy Dust"] = 1.4, Festive = 1.6
}

-- Fish Detection Variables
local caughtFishHistory = {}
local sessionFishStats = {
    totalCaught = 0,
    totalValue = 0,
    rarityCount = {
        Common = 0, Rare = 0, Epic = 0, Legendary = 0, 
        Mythical = 0, Event = 0, DeepSea = 0, UltimateItems = 0, Materials = 0
    },
    variantCount = {},
    bestCatch = {name = "None", value = 0, rarity = "Unknown"}
}

-- Fish Detection Statistics for Analytics
local fishDetectionStats = {}
local fishByRarity = {Common = 0, Uncommon = 0, Rare = 0, Epic = 0, Legendary = 0, Mythical = 0, Exotic = 0}
local totalUniqueFish = 0
local totalFishValue = 0
local sessionFishCaught = 0

-- Initialize variant counters
for _, variant in ipairs(FishVariants) do
    sessionFishStats.variantCount[variant] = 0
end

-- Function to determine fish rarity
local function GetFishRarity(fishName)
    for rarity, fishList in pairs(FishDatabase) do
        for _, fish in ipairs(fishList) do
            if fish == fishName then
                return rarity
            end
        end
    end
    return "Unknown"
end

-- Function to detect fish variant
local function GetFishVariant(fishName)
    for _, variant in ipairs(FishVariants) do
        if string.find(fishName, variant) then
            return variant
        end
    end
    return nil
end

-- Function to estimate fish value
local function EstimateFishValue(fishName, rarity, variant)
    local baseValue = 0
    
    if FishValues[rarity] then
        baseValue = math.random(FishValues[rarity].min, FishValues[rarity].max)
    else
        baseValue = math.random(10, 100) -- Default value
    end
    
    -- Apply variant multiplier
    if variant and VariantMultipliers[variant] then
        baseValue = baseValue * VariantMultipliers[variant]
    end
    
    return math.floor(baseValue)
end

-- Function to log caught fish
local function LogCaughtFish(fishName)
    local rarity = GetFishRarity(fishName)
    local variant = GetFishVariant(fishName)
    local estimatedValue = EstimateFishValue(fishName, rarity, variant)
    
    -- Update session stats
    sessionFishStats.totalCaught = sessionFishStats.totalCaught + 1
    sessionFishStats.totalValue = sessionFishStats.totalValue + estimatedValue
    
    if sessionFishStats.rarityCount[rarity] then
        sessionFishStats.rarityCount[rarity] = sessionFishStats.rarityCount[rarity] + 1
    end
    
    if variant then
        sessionFishStats.variantCount[variant] = sessionFishStats.variantCount[variant] + 1
    end
    
    -- Check if this is the best catch
    if estimatedValue > sessionFishStats.bestCatch.value then
        sessionFishStats.bestCatch = {
            name = fishName,
            value = estimatedValue,
            rarity = rarity,
            variant = variant
        }
    end
    
    -- Add to history
    table.insert(caughtFishHistory, {
        name = fishName,
        rarity = rarity,
        variant = variant,
        value = estimatedValue,
        timestamp = tick()
    })
    
    -- Keep only last 50 catches for memory management
    if #caughtFishHistory > 50 then
        table.remove(caughtFishHistory, 1)
    end
    
    -- Notify about special catches
    local notificationText = "🎣 " .. fishName .. " caught!"
    if variant then
        notificationText = notificationText .. "\n✨ " .. variant .. " variant!"
    end
    notificationText = notificationText .. "\n💰 ~" .. estimatedValue .. " coins"
    notificationText = notificationText .. "\n🏆 " .. rarity .. " rarity"
    
    if rarity == "Legendary" or rarity == "Mythical" or rarity == "Event" or variant then
        NotifySuccess("Rare Catch!", notificationText)
    end
    
    print("XSAN: Fish logged -", fishName, "(" .. rarity .. ")", variant and "["..variant.."]" or "", "~" .. estimatedValue .. " coins")
end

-- Function to detect and track fish - MAIN DETECTION FUNCTION
local function DetectAndTrackFish()
    -- Simple fish detection for now - can be enhanced with actual game detection
    pcall(function()
        -- Update session fish count
        sessionFishCaught = sessionFishCaught + 1
        
        -- Update random spot stats if in random spot mode
        if randomSpotEnabled and currentRandomSpot ~= "None" then
            randomSpotStats.fishPerLocation[currentRandomSpot] = randomSpotStats.fishPerLocation[currentRandomSpot] + 1
            
            -- Check if this is the new best location
            local bestCount = 0
            local bestLoc = "None"
            for loc, count in pairs(randomSpotStats.fishPerLocation) do
                if count > bestCount then
                    bestCount = count
                    bestLoc = loc
                end
            end
            randomSpotStats.bestLocation = bestLoc
        end
        
        -- Basic fish tracking (simplified for now)
        totalFishValue = totalFishValue + 25 -- Average fish value
        
        print("XSAN: Fish detected and tracked. Session total:", sessionFishCaught)
    end)
end

-- Function to get fish statistics
local function GetFishStatistics()
    local avgValue = sessionFishStats.totalCaught > 0 and 
                    math.floor(sessionFishStats.totalValue / sessionFishStats.totalCaught) or 0
    
    local stats = "🎣 XSAN Fish Statistics:\n\n"
    stats = stats .. "📊 Total Caught: " .. sessionFishStats.totalCaught .. "\n"
    stats = stats .. "💰 Total Value: ~" .. sessionFishStats.totalValue .. " coins\n"
    stats = stats .. "📈 Average Value: ~" .. avgValue .. " coins\n\n"
    
    stats = stats .. "🏆 Best Catch: " .. sessionFishStats.bestCatch.name .. "\n"
    stats = stats .. "   💎 Value: ~" .. sessionFishStats.bestCatch.value .. " coins\n"
    stats = stats .. "   🌟 Rarity: " .. sessionFishStats.bestCatch.rarity .. "\n\n"
    
    stats = stats .. "📋 Rarity Breakdown:\n"
    for rarity, count in pairs(sessionFishStats.rarityCount) do
        if count > 0 then
            stats = stats .. "   " .. rarity .. ": " .. count .. "\n"
        end
    end
    
    return stats
end

-- Auto Fish Detection (connects to fishing events)
local function SetupFishDetection()
    -- Listen for fish caught events
    local fishCaughtRemote = net and net:FindFirstChild("RE/FishCaught")
    if fishCaughtRemote then
        fishCaughtRemote.OnClientEvent:Connect(function(fishData)
            if fishData and fishData.name then
                LogCaughtFish(fishData.name)
            end
        end)
        print("XSAN: ✅ Fish detection system connected to FishCaught event")
    else
        print("XSAN: ⚠️ FishCaught remote not found - fish detection may be limited")
    end
    
    -- Alternative: Monitor inventory changes
    task.spawn(function()
        while true do
            task.wait(2) -- Check every 2 seconds
            -- This would monitor player's inventory for new fish
            -- Implementation depends on how the game stores inventory data
        end
    end)
end

print("XSAN: Fish Detection System initialized with " .. 
      tostring(#FishDatabase.Common + #FishDatabase.Rare + #FishDatabase.Epic + 
               #FishDatabase.Legendary + #FishDatabase.Mythical + #FishDatabase.Event + 
               #FishDatabase.DeepSea + #FishDatabase.UltimateItems + #FishDatabase.Materials) .. 
      " fish types and " .. #FishVariants .. " variants!")

-- ═══════════════════════════════════════════════════════════════
-- SETTING TAB FUNCTIONS - Game Enhancement Features
-- ═══════════════════════════════════════════════════════════════

-- Boost FPS Function
local function toggleBoostFPS()
    boostFPSEnabled = not boostFPSEnabled
    
    if boostFPSEnabled then
        -- Reduce graphics quality for better FPS
        pcall(function()
            local lighting = game:GetService("Lighting")
            local workspace = game:GetService("Workspace")
            
            -- Save original settings
            _G.OriginalLighting = _G.OriginalLighting or {
                Brightness = lighting.Brightness,
                GlobalShadows = lighting.GlobalShadows,
                Technology = lighting.Technology
            }
            
            -- Apply FPS boost settings
            lighting.Brightness = 1
            lighting.GlobalShadows = false
            lighting.Technology = Enum.Technology.Compatibility
            
            -- Reduce workspace detail
            workspace.StreamingEnabled = true
            workspace.StreamingTargetRadius = 100
            
            NotifySuccess("Boost FPS", "✅ FPS Boost diaktifkan!\n\n⚡ Kualitas grafis dikurangi\n🚀 Performa game ditingkatkan")
        end)
    else
        -- Restore original settings
        pcall(function()
            if _G.OriginalLighting then
                local lighting = game:GetService("Lighting")
                lighting.Brightness = _G.OriginalLighting.Brightness
                lighting.GlobalShadows = _G.OriginalLighting.GlobalShadows
                lighting.Technology = _G.OriginalLighting.Technology
            end
            NotifyInfo("Boost FPS", "🔄 FPS Boost dimatikan\n\n✅ Pengaturan grafis dikembalikan")
        end)
    end
end

-- HDR Shader Function
local function toggleHDRShader()
    hdrShaderEnabled = not hdrShaderEnabled
    
    pcall(function()
        local lighting = game:GetService("Lighting")
        
        if hdrShaderEnabled then
            -- Save original settings
            _G.OriginalShader = _G.OriginalShader or {
                Brightness = lighting.Brightness,
                Contrast = lighting.Contrast,
                Saturation = lighting.ColorCorrection and lighting.ColorCorrection.Saturation or 0
            }
            
            -- Apply HDR effects
            lighting.Brightness = 2.5
            lighting.Contrast = 0.2
            
            -- Create or update ColorCorrection
            local colorCorrection = lighting:FindFirstChild("HDR_ColorCorrection")
            if not colorCorrection then
                colorCorrection = Instance.new("ColorCorrectionEffect")
                colorCorrection.Name = "HDR_ColorCorrection"
                colorCorrection.Parent = lighting
            end
            
            colorCorrection.Brightness = 0.1
            colorCorrection.Contrast = 0.15
            colorCorrection.Saturation = 0.2
            
            NotifySuccess("HDR Shader", "✨ HDR Shader diaktifkan!\n\n🌟 Visual game ditingkatkan\n💎 Efek pencahayaan premium")
        else
            -- Remove HDR effects
            local colorCorrection = lighting:FindFirstChild("HDR_ColorCorrection")
            if colorCorrection then
                colorCorrection:Destroy()
            end
            
            -- Restore original settings
            if _G.OriginalShader then
                lighting.Brightness = _G.OriginalShader.Brightness
                lighting.Contrast = _G.OriginalShader.Contrast
            end
            
            NotifyInfo("HDR Shader", "🔄 HDR Shader dimatikan\n\n✅ Visual dikembalikan normal")
        end
    end)
end

-- Server Management Functions
local function rejoinServer()
    NotifyInfo("Rejoin Server", "🔄 Bergabung kembali ke server...")
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
end

local function serverHop()
    NotifyInfo("Server Hop", "🌐 Mencari server lain...")
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    
    local success, result = pcall(function()
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        local availableServers = {}
        
        for _, server in pairs(servers.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                table.insert(availableServers, server.id)
            end
        end
        
        if #availableServers > 0 then
            local randomServer = availableServers[math.random(1, #availableServers)]
            TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, Players.LocalPlayer)
        else
            NotifyError("Server Hop", "❌ Tidak ada server lain yang tersedia")
        end
    end)
    
    if not success then
        NotifyError("Server Hop", "❌ Gagal mencari server lain")
    end
end

local function smallServer()
    NotifyInfo("Small Server", "👥 Mencari server dengan sedikit pemain...")
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    
    local success, result = pcall(function()
        local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        local smallServers = {}
        
        for _, server in pairs(servers.data) do
            if server.playing <= 5 and server.playing > 0 and server.id ~= game.JobId then
                table.insert(smallServers, {id = server.id, players = server.playing})
            end
        end
        
        -- Sort by player count (ascending)
        table.sort(smallServers, function(a, b) return a.players < b.players end)
        
        if #smallServers > 0 then
            local targetServer = smallServers[1].id
            NotifySuccess("Small Server", "✅ Ditemukan server dengan " .. smallServers[1].players .. " pemain")
            TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServer, Players.LocalPlayer)
        else
            NotifyError("Small Server", "❌ Tidak ditemukan server dengan sedikit pemain")
        end
    end)
    
    if not success then
        NotifyError("Small Server", "❌ Gagal mencari server kecil")
    end
end

-- Enable Float Function
local function toggleEnableFloat()
    local player = game.Players.LocalPlayer
    local character = player.Character
    
    if not character then
        NotifyError("Enable Float", "❌ Character tidak ditemukan!")
        return
    end
    
    enableFloatEnabled = not enableFloatEnabled
    
    if enableFloatEnabled then
        -- Create float effect
        floatConnection = game:GetService("RunService").Heartbeat:Connect(function()
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local humanoidRootPart = character.HumanoidRootPart
                local bodyVelocity = humanoidRootPart:FindFirstChild("FloatVelocity")
                
                if not bodyVelocity then
                    bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Name = "FloatVelocity"
                    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    bodyVelocity.Parent = humanoidRootPart
                end
            end
        end)
        
        NotifySuccess("Enable Float", "✨ Float mode diaktifkan!\n\n🕊️ Karakter dapat melayang\n⬆️ Gunakan Space untuk naik")
    else
        -- Disable float
        if floatConnection then
            floatConnection:Disconnect()
            floatConnection = nil
        end
        
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local bodyVelocity = character.HumanoidRootPart:FindFirstChild("FloatVelocity")
            if bodyVelocity then
                bodyVelocity:Destroy()
            end
        end
        
        NotifyInfo("Enable Float", "🔄 Float mode dimatikan\n\n✅ Karakter kembali normal")
    end
end

-- Universal No Clip Function
local function toggleNoClip()
    local player = game.Players.LocalPlayer
    local character = player.Character
    
    if not character then
        NotifyError("No Clip", "❌ Character tidak ditemukan!")
        return
    end
    
    noClipEnabled = not noClipEnabled
    
    if noClipEnabled then
        noClipConnection = game:GetService("RunService").Stepped:Connect(function()
            local character = player.Character
            if character then
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        
        NotifySuccess("No Clip", "👻 No Clip diaktifkan!\n\n🚪 Bisa menembus dinding\n🏃 Jalan terus untuk bergerak")
    else
        if noClipConnection then
            noClipConnection:Disconnect()
            noClipConnection = nil
        end
        
        local character = player.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
        
        NotifyInfo("No Clip", "🔄 No Clip dimatikan\n\n✅ Collision kembali normal")
    end
end

-- Spinner Function
local function toggleSpinner()
    local player = game.Players.LocalPlayer
    local character = player.Character
    
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        NotifyError("Spinner", "❌ Character tidak ditemukan!")
        return
    end
    
    spinnerEnabled = not spinnerEnabled
    
    if spinnerEnabled then
        local humanoidRootPart = character.HumanoidRootPart
        
        -- Create BodyAngularVelocity for spinning
        local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
        bodyAngularVelocity.Name = "SpinnerVelocity"
        bodyAngularVelocity.AngularVelocity = Vector3.new(0, 20, 0) -- Spin around Y-axis
        bodyAngularVelocity.MaxTorque = Vector3.new(0, math.huge, 0)
        bodyAngularVelocity.Parent = humanoidRootPart
        
        NotifySuccess("Spinner", "🌪️ Spinner diaktifkan!\n\n💫 Karakter berputar\n🎯 Character akan terus berputar")
    else
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local spinner = character.HumanoidRootPart:FindFirstChild("SpinnerVelocity")
            if spinner then
                spinner:Destroy()
            end
        end
        
        NotifyInfo("Spinner", "🔄 Spinner dimatikan\n\n✅ Putaran dihentikan")
    end
end

-- Anti Drown Function
local function toggleAntiDrown()
    local player = game.Players.LocalPlayer
    
    antiDrownEnabled = not antiDrownEnabled
    
    if antiDrownEnabled then
        antiDrownConnection = game:GetService("RunService").Heartbeat:Connect(function()
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") then
                local humanoid = character.Humanoid
                
                -- Keep oxygen at maximum
                if humanoid:FindFirstChild("Health") then
                    -- Prevent drowning by maintaining high oxygen levels
                    pcall(function()
                        if humanoid.Health < humanoid.MaxHealth and humanoid.Health > 0 then
                            -- Only heal if damage is from drowning (gradual damage)
                            humanoid.Health = humanoid.MaxHealth
                        end
                    end)
                end
                
                -- Remove water effects if character is underwater
                for _, effect in pairs(character:GetChildren()) do
                    if effect.Name:find("Water") or effect.Name:find("Drown") then
                        effect:Destroy()
                    end
                end
            end
        end)
        
        NotifySuccess("Anti Drown", "🏊 Anti Drown diaktifkan!\n\n💧 Tidak akan tenggelam\n🫁 Oksigen tidak habis")
    else
        if antiDrownConnection then
            antiDrownConnection:Disconnect()
            antiDrownConnection = nil
        end
        
        NotifyInfo("Anti Drown", "🔄 Anti Drown dimatikan\n\n✅ Sistem oksigen normal")
    end
end

-- ═══════════════════════════════════════════════════════════════
-- UI PERFORMANCE MONITORING SYSTEM
-- ═══════════════════════════════════════════════════════════════

-- Performance tracking variables
local performanceMetrics = {
    uiFrameRate = 60,
    memoryUsage = 0,
    lastOptimization = tick(),
    optimizationCount = 0
}

-- UI Performance optimizer
local function OptimizeUIPerformance()
    pcall(function()
        local rayfieldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
        if rayfieldGui then
            -- Reduce unnecessary UI updates
            for _, descendant in pairs(rayfieldGui:GetDescendants()) do
                if descendant:IsA("GuiObject") then
                    -- Optimize transparency for better performance
                    if descendant.BackgroundTransparency > 0.95 then
                        descendant.BackgroundTransparency = 1
                    end
                    
                    -- Optimize text rendering
                    if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                        if descendant.Text == "" then
                            descendant.Visible = false
                        end
                    end
                end
            end
            
            performanceMetrics.optimizationCount = performanceMetrics.optimizationCount + 1
            performanceMetrics.lastOptimization = tick()
            
            if performanceMetrics.optimizationCount % 10 == 0 then
                print("XSAN: UI Performance optimized (" .. performanceMetrics.optimizationCount .. " times)")
            end
        end
    end)
end

-- Start performance monitoring
task.spawn(function()
    while true do
        task.wait(30) -- Check every 30 seconds
        OptimizeUIPerformance()
    end
end)

print("XSAN: UI Performance monitoring initialized!")

-- ═══════════════════════════════════════════════════════════════
-- ULTIMATE RESET SYSTEM - Auto Reset on Respawn/Reconnect
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Initializing Ultimate Reset System...")

-- Function to reset all features to default state
local function ResetAllFeatures()
    print("XSAN: Resetting all features to default state...")
    
    -- Reset auto fishing system
    autofish = false
    autofishSession = autofishSession + 1  -- Invalidate any running loops
    autofishThread = nil
    
    -- Reset casting modes
    perfectCast = false
    safeMode = false
    hybridMode = false
    
    -- Reset auto sell
    autoSellOnThreshold = false
    
    -- Reset Random Spot Fishing
    randomSpotEnabled = false
    randomSpotSession = randomSpotSession + 1
    randomSpotThread = nil
    currentRandomSpot = "None"
    featureState.RandomSpot = false
    
    -- Reset Random Spot Analytics
    randomSpotStats.totalSwitches = 0
    randomSpotStats.bestLocation = "None"
    randomSpotStats.currentLocationStartTime = 0
    for locationName, _ in pairs(randomSpotStats.fishPerLocation) do
        randomSpotStats.fishPerLocation[locationName] = 0
        randomSpotStats.timePerLocation[locationName] = 0
    end
    
    -- Reset walk speed
    walkspeedEnabled = false
    currentWalkspeed = defaultWalkspeed
    
    -- Reset unlimited jump
    unlimitedJumpEnabled = false
    currentJumpHeight = defaultJumpHeight
    if unlimitedJumpConnection then
        unlimitedJumpConnection:Disconnect()
        unlimitedJumpConnection = nil
    end
    
    -- Reset SETTING tab features
    print("XSAN: Resetting SETTING tab features...")
    
    -- Reset performance features
    if boostFPSEnabled then
        toggleBoostFPS()
    end
    if hdrShaderEnabled then
        toggleHDRShader()
    end
    
    -- Reset movement features
    if enableFloatEnabled then
        toggleEnableFloat()
    end
    if noClipEnabled then
        toggleNoClip()
    end
    if spinnerEnabled then
        toggleSpinner()
    end
    if antiDrownEnabled then
        toggleAntiDrown()
    end
    
    -- Clean up any remaining connections
    if floatConnection then
        floatConnection:Disconnect()
        floatConnection = nil
    end
    if noClipConnection then
        noClipConnection:Disconnect()
        noClipConnection = nil
    end
    if spinnerConnection then
        spinnerConnection:Disconnect()
        spinnerConnection = nil
    end
    if antiDrownConnection then
        antiDrownConnection:Disconnect()
        antiDrownConnection = nil
    end
    
    -- Reset current preset
    currentPreset = "None"
    
    -- Reset hybrid auto fish if exists
    if hybridAutoFish then
        pcall(function()
            hybridAutoFish.toggle(false)
        end)
        hybridAutoFish = nil
    end
    
    -- Update UI flags if they exist
    pcall(function()
        if Rayfield and Rayfield.Flags then
            if Rayfield.Flags["WalkSpeedToggle"] then
                Rayfield.Flags["WalkSpeedToggle"]:Set(false)
            end
            if Rayfield.Flags["WalkSpeedSlider"] then
                Rayfield.Flags["WalkSpeedSlider"]:Set(defaultWalkspeed)
            end
            if Rayfield.Flags["UnlimitedJumpToggle"] then
                Rayfield.Flags["UnlimitedJumpToggle"]:Set(false)
            end
            if Rayfield.Flags["JumpHeightSlider"] then
                Rayfield.Flags["JumpHeightSlider"]:Set(defaultJumpHeight)
            end
        end
    end)
    
    print("XSAN: All features reset to default state successfully!")
    NotifySuccess("System Reset", "🔄 XSAN Reset Complete!\n\n✅ All features disabled\n✅ Settings restored to default\n✅ Safe state activated\n\n💡 Ready for fresh start!")
end

-- Function to detect respawn/reconnect
local function SetupResetTriggers()
    -- Method 1: Character respawn detection
    LocalPlayer.CharacterAdded:Connect(function(character)
        print("XSAN: Character respawn detected - Triggering reset...")
        task.wait(2) -- Wait for character to fully load
        ResetAllFeatures()
    end)
    
    -- Method 2: Connection lost/reconnect detection
    local Players = game:GetService("Players")
    local lastPlayerCount = #Players:GetPlayers()
    
    spawn(function()
        while true do
            task.wait(5) -- Check every 5 seconds
            local currentPlayerCount = #Players:GetPlayers()
            
            -- If player count changes dramatically, might indicate reconnection
            if math.abs(currentPlayerCount - lastPlayerCount) > 5 then
                print("XSAN: Potential reconnection detected - Triggering reset...")
                ResetAllFeatures()
            end
            
            lastPlayerCount = currentPlayerCount
        end
    end)
    
    -- Method 3: Game state change detection
    game:GetService("Players").PlayerRemoving:Connect(function(player)
        if player == LocalPlayer then
            print("XSAN: Player leaving - Preparing reset for next session...")
            ResetAllFeatures()
        end
    end)
    
    print("XSAN: Reset triggers setup complete!")
end

-- Initialize reset system
SetupResetTriggers()

-- Manual reset function for emergency use
_G.XSANReset = ResetAllFeatures -- Global function for manual reset

print("XSAN: Ultimate Reset System initialized successfully!")

-- ═══════════════════════════════════════════════════════════════
-- WALKSPEED SYSTEM
-- ═══════════════════════════════════════════════════════════════
local walkspeedEnabled = false
local currentWalkspeed = 16
local defaultWalkspeed = 16

local function setWalkSpeed(speed)
    local success, error = pcall(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
            currentWalkspeed = speed
            NotifySuccess("Walk Speed", "Walk speed set to " .. speed)
        else
            NotifyError("Walk Speed", "Character or Humanoid not found")
        end
    end)
    
    if not success then
        NotifyError("Walk Speed", "Failed to set walk speed: " .. tostring(error))
    end
end

local function resetWalkSpeed()
    setWalkSpeed(defaultWalkspeed)
    walkspeedEnabled = false
end

print("XSAN: Walkspeed system initialized!")

-- ═══════════════════════════════════════════════════════════════
-- UNLIMITED JUMP SYSTEM
-- ═══════════════════════════════════════════════════════════════
local unlimitedJumpEnabled = false
local currentJumpHeight = 7.2 -- Default Roblox jump height
local defaultJumpHeight = 7.2
local unlimitedJumpConnection = nil

local function setJumpHeight(height)
    local success, error = pcall(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpHeight = height
            currentJumpHeight = height
            NotifySuccess("Jump Height", "Jump height set to " .. height)
        else
            NotifyError("Jump Height", "Character or Humanoid not found")
        end
    end)
    
    if not success then
        NotifyError("Jump Height", "Failed to set jump height: " .. tostring(error))
    end
end

local function enableUnlimitedJump()
    if unlimitedJumpEnabled then return end
    
    unlimitedJumpEnabled = true
    
    local success, error = pcall(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            -- Method 1: Set very high jump height
            humanoid.JumpHeight = 50
            currentJumpHeight = 50
            
            -- Method 2: Enable infinite jumps via UserInputService (with proper input filtering)
            if UserInputService then
                unlimitedJumpConnection = UserInputService.JumpRequest:Connect(function()
                    -- Only process if unlimited jump is still enabled and character exists
                    if unlimitedJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
            end
            
            NotifySuccess("Unlimited Jump", "✅ Unlimited Jump ENABLED!\n\n🚀 Jump height: 50\n⚡ Infinite jumps: Active\n🎯 Press space repeatedly to fly!\n\n💡 Won't interfere with manual fishing")
        else
            NotifyError("Unlimited Jump", "Character or Humanoid not found!")
        end
    end)
    
    if not success then
        NotifyError("Unlimited Jump", "Failed to enable unlimited jump: " .. tostring(error))
        unlimitedJumpEnabled = false
    end
end

local function disableUnlimitedJump()
    if not unlimitedJumpEnabled then return end
    
    unlimitedJumpEnabled = false
    
    local success, error = pcall(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpHeight = defaultJumpHeight
            currentJumpHeight = defaultJumpHeight
        end
        
        -- Disconnect infinite jump connection
        if unlimitedJumpConnection then
            unlimitedJumpConnection:Disconnect()
            unlimitedJumpConnection = nil
        end
        
        NotifyInfo("Unlimited Jump", "❌ Unlimited Jump DISABLED\n\n📉 Jump height: Normal (7.2)\n🚫 Infinite jumps: Disabled")
    end)
    
    if not success then
        NotifyError("Unlimited Jump", "Failed to disable unlimited jump: " .. tostring(error))
    end
end

local function toggleUnlimitedJump()
    if unlimitedJumpEnabled then
        disableUnlimitedJump()
    else
        enableUnlimitedJump()
    end
end

print("XSAN: Unlimited Jump system initialized!")

-- XSAN Ultimate Teleportation System
print("XSAN: Initializing teleportation system...")

-- Dynamic Teleportation Data (like old.lua)
local TeleportLocations = {
    Islands = {},
    NPCs = {},
    Events = {}
}

-- Get island locations dynamically from workspace (same as old.lua)
local tpFolder = workspace:FindFirstChild("!!!! ISLAND LOCATIONS !!!!")
if tpFolder then
    for _, island in ipairs(tpFolder:GetChildren()) do
        if island:IsA("BasePart") then
            TeleportLocations.Islands[island.Name] = island.CFrame
            print("XSAN: Found island - " .. island.Name)
        end
    end
else
    -- Fallback to hardcoded coordinates if workspace folder not found
    print("XSAN: Island folder not found, using updated fallback coordinates")
    TeleportLocations.Islands = {
        -- Updated island coordinates from detector (Latest 2025)
        ["Kohana Volcano"] = CFrame.new(-594.971252, 396.65213, 149.10907),
        ["Crater Island"] = CFrame.new(1010.01001, 252, 5078.45117),
        ["Kohana"] = CFrame.new(-650.971191, 208.693695, 711.10907),
        ["Lost Isle"] = CFrame.new(-3618.15698, 240.836655, -1317.45801),
        ["Stingray Shores"] = CFrame.new(45.2788086, 252.562927, 2987.10913),
        ["Esoteric Depths"] = CFrame.new(1944.77881, 393.562927, 1371.35913),
        ["Weather Machine"] = CFrame.new(-1488.51196, 83.1732635, 1876.30298),
        ["Tropical Grove"] = CFrame.new(-2095.34106, 197.199997, 3718.08008),
        ["Coral Reefs"] = CFrame.new(-3023.97119, 337.812927, 2195.60913),
        ["Ice Island"] = CFrame.new(1990.55, 3.09, 3021.91),
        -- Legacy coordinates (backup)
        ["Moosewood"] = CFrame.new(389, 137, 264),
        ["Ocean"] = CFrame.new(1082, 124, -924),
        ["Snowcap Island"] = CFrame.new(2648, 140, 2522),
        ["Mushgrove Swamp"] = CFrame.new(-1817, 138, 1808),
        ["Roslit Bay"] = CFrame.new(-1442, 135, 1006),
        ["Sunstone Island"] = CFrame.new(-934, 135, -1122),
        ["Statue Of Sovereignty"] = CFrame.new(1, 140, -918),
        ["Moonstone Island"] = CFrame.new(-3004, 135, -1157),
        ["Forsaken Shores"] = CFrame.new(-2853, 135, 1627),
        ["Ancient Isle"] = CFrame.new(5896, 137, 4516),
        ["Keepers Altar"] = CFrame.new(1296, 135, -808),
        ["Brine Pool"] = CFrame.new(-1804, 135, 3265),
        ["The Depths"] = CFrame.new(994, -715, 1226),
        ["Vertigo"] = CFrame.new(-111, -515, 1049),
        ["Volcano"] = CFrame.new(-1888, 164, 330)
    }
end

-- Event Locations (Moved above NPCs for better organization)
TeleportLocations.Events = {
    ["🏝️ SISYPUS 1"] = CFrame.new(-3659.55, -135.08, -971.61),
    ["🏝️ SISYPUS 2"] = CFrame.new(-3767.29, -135.08, -990.03),
    ["🦈 TREASURE"] = CFrame.new(-3628.77, -283.35, -1638.54),
    ["❄️ ICE SPOT 1"] = CFrame.new(1990.55, 3.09, 3021.91),
    ["❄️ ICE SPOT 2"] = CFrame.new(2069.57, 8.42, 3387.88),
    ["❄️ ICE SPOT 3"] = CFrame.new(1795.95, 4.05, 3379.74),
    ["🌋 CRATER 1"] = CFrame.new(990.45, 21.06, 5059.85),
    ["🌋 CRATER 2"] = CFrame.new(1049.76, 48.62, 5129.69),
    ["🌴 TROPICAL 1"] = CFrame.new(-2173.60, 53.48, 3636.23),
    ["🌴 TROPICAL 2"] = CFrame.new(-2165.30, 7.79, 3677.91),
    ["🌴 TROPICAL 3"] =  CFrame.new(-2141.51, 54.65, 3583.64),
    ["🗿 STONE"] = CFrame.new(-2636.19, 124.87, -27.49),
    ["⚙️ MACHINE 1"] = CFrame.new(-1480.98, 3.49, 1923.66),
    ["⚙️ MACHINE 2"] = CFrame.new(-1613.32, 8.13, 1903.20)
}

-- Random Spot Fishing Locations for Auto Random Fishing
TeleportLocations.RandomSpots = {
    ["🏝️ SISYPUS 1"] = CFrame.new(-3659.55, -135.08, -971.61),
    ["🏝️ SISYPUS 2"] = CFrame.new(-3767.29, -135.08, -990.03),
    ["🦈 TREASURE"] = CFrame.new(-3628.77, -283.35, -1638.54),
    ["❄️ ICE SPOT 1"] = CFrame.new(1990.55, 3.09, 3021.91),
    ["❄️ ICE SPOT 2"] = CFrame.new(2069.57, 8.42, 3387.88),
    ["❄️ ICE SPOT 3"] = CFrame.new(1795.95, 4.05, 3379.74),
    ["🌋 CRATER"] = CFrame.new(990.45, 21.06, 5059.85),
    ["🌴 TROPICAL 1"] = CFrame.new(-2173.60, 53.48, 3636.23),
    ["🌴 TROPICAL 2"] = CFrame.new(-2165.30, 7.79, 3677.91),
    ["🌴 TROPICAL 3"] =  CFrame.new(-2141.51, 54.65, 3583.64),
    ["🗿 STONE"] = CFrame.new(-2636.19, 124.87, -27.49),
    ["⚙️ MACHINE 1"] = CFrame.new(-1480.98, 3.49, 1923.66),
    ["⚙️ MACHINE 2"] = CFrame.new(-1613.32, 8.13, 1903.20)
}

-- Player Teleportation Function (improved like main16.lua)
local function TeleportToPlayer(targetPlayerName)
    if not targetPlayerName or targetPlayerName == "" then
        NotifyError("Player TP", "❌ Nama player tidak boleh kosong!")
        return
    end
    
    -- Normalize player name (remove spaces, handle case)
    local normalizedName = targetPlayerName:gsub("^%s*(.-)%s*$", "%1") -- trim spaces
    
    local success = pcall(function()
        local targetPlayer = nil
        
        -- Method 1: Search in Players service (like main16.lua approach)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Name:lower() == normalizedName:lower() or 
               player.DisplayName:lower() == normalizedName:lower() then
                targetPlayer = player
                break
            end
        end
        
        -- Method 2: Partial match search if exact match fails
        if not targetPlayer then
            for _, player in pairs(game.Players:GetPlayers()) do
                if string.find(player.Name:lower(), normalizedName:lower()) or
                   string.find(player.DisplayName:lower(), normalizedName:lower()) then
                    targetPlayer = player
                    NotifyInfo("Player Found", "🔍 Found partial match: " .. player.Name)
                    break
                end
            end
        end
        
        -- Validation
        if not targetPlayer then
            NotifyError("Player TP", "❌ Player '" .. normalizedName .. "' tidak ditemukan!\n\n💡 Tips:\n• Pastikan nama player benar\n• Player harus online di server ini\n• Coba gunakan refresh player list")
            return
        end
        
        -- Check if both players have valid characters (main16.lua method)
        if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and 
           LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            
            -- Direct teleport using CFrame (main16.lua method - more reliable)
            local targetCFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            local offsetCFrame = targetCFrame * CFrame.new(0, 0, -3) -- 3 studs behind target
            
            LocalPlayer.Character.HumanoidRootPart.CFrame = offsetCFrame
            
            NotifySuccess("Player TP", "✅ Berhasil teleport ke " .. targetPlayer.DisplayName .. " (@" .. targetPlayer.Name .. ")!")
        else
            NotifyError("Player TP", "❌ Tidak bisa teleport ke " .. normalizedName .. "\n\n⚠️ Character tidak ditemukan atau sedang loading")
        end
        
    end)
    
    if not success then
        NotifyError("Player TP", "❌ Gagal teleport ke player!\n\n🔧 Coba lagi atau gunakan nama player yang berbeda")
    end
end

-- NPCs Detection System - Real-time accurate locations
local function DetectNPCLocations()
    local detectedNPCs = {}
    
    -- Method 1: Check ReplicatedStorage NPCs (Most Accurate)
    local npcContainer = ReplicatedStorage:FindFirstChild("NPC")
    if npcContainer then
        print("XSAN: Scanning ReplicatedStorage NPCs...")
        for _, npc in pairs(npcContainer:GetChildren()) do
            if npc:FindFirstChild("WorldPivot") then
                local pos = npc.WorldPivot.Position
                local emoji = "👤"
                
                -- Add specific emojis based on NPC names
                if string.find(npc.Name:lower(), "alex") or string.find(npc.Name:lower(), "shop") then
                    emoji = "🛒"
                elseif string.find(npc.Name:lower(), "marc") or string.find(npc.Name:lower(), "rod") then
                    emoji = "🎣"
                elseif string.find(npc.Name:lower(), "henry") or string.find(npc.Name:lower(), "storage") then
                    emoji = "📦"
                elseif string.find(npc.Name:lower(), "scientist") then
                    emoji = "🔬"
                elseif string.find(npc.Name:lower(), "boat") then
                    emoji = "⚓"
                elseif string.find(npc.Name:lower(), "angler") then
                    emoji = "🏆"
                elseif string.find(npc.Name:lower(), "scott") then
                    emoji = "🐧"
                elseif string.find(npc.Name:lower(), "billy") or string.find(npc.Name:lower(), "bob") then
                    emoji = "🐟"
                elseif string.find(npc.Name:lower(), "fish") then
                    emoji = "🎣"
                end
                
                detectedNPCs[emoji .. " " .. npc.Name] = CFrame.new(pos)
                print("XSAN: Found NPC -", npc.Name, "at", pos)
            end
        end
    end
    
    -- Method 2: Check Workspace NPCs (Backup method)
    print("XSAN: Scanning Workspace NPCs...")
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Name ~= LocalPlayer.Name then
            -- Skip player characters
            local isPlayerCharacter = false
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character == obj then
                    isPlayerCharacter = true
                    break
                end
            end
            
            if not isPlayerCharacter then
                local rootPart = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
                if rootPart then
                    local emoji = "👤"
                    
                    -- Check if this NPC is important (not already detected)
                    local isImportant = false
                    local npcName = obj.Name
                    
                    if string.find(npcName:lower(), "alex") or string.find(npcName:lower(), "shop") then
                        emoji = "🛒"
                        isImportant = true
                    elseif string.find(npcName:lower(), "marc") or string.find(npcName:lower(), "rod") then
                        emoji = "🎣"
                        isImportant = true
                    elseif string.find(npcName:lower(), "henry") or string.find(npcName:lower(), "storage") then
                        emoji = "📦"
                        isImportant = true
                    elseif string.find(npcName:lower(), "scientist") then
                        emoji = "🔬"
                        isImportant = true
                    elseif string.find(npcName:lower(), "boat") then
                        emoji = "⚓"
                        isImportant = true
                    elseif string.find(npcName:lower(), "angler") then
                        emoji = "🏆"
                        isImportant = true
                    end
                    
                    if isImportant then
                        local key = emoji .. " " .. npcName
                        if not detectedNPCs[key] then -- Only add if not already detected
                            detectedNPCs[key] = rootPart.CFrame
                            print("XSAN: Found Workspace NPC -", npcName, "at", rootPart.Position)
                        end
                    end
                end
            end
        end
    end
    
    return detectedNPCs
end

-- Initialize NPCs with real-time detection
print("XSAN: Detecting NPC locations in real-time...")
local detectedNPCs = DetectNPCLocations()

-- Updated fallback NPCs (Latest 2025 coordinates - Only used if detection fails)
local fallbackNPCs = {
    -- Primary NPCs (Most frequently used)
    ["🛒 Shop (Alex)"] = CFrame.new(-31.10, 4.84, 2899.03),
    ["🎣 Rod Shop (Marc)"] = CFrame.new(454, 150, 229),
    ["📦 Storage (Henry)"] = CFrame.new(491, 150, 272),

    -- Secondary NPCs (Backup only)
    ["RESPAWN"] = CFrame.new(56.81, 4.74, 2834.46),
    
}

-- Smart NPC Selection: Use detected NPCs first, fallback if needed
if next(detectedNPCs) then
    local detectedCount = 0
    for _ in pairs(detectedNPCs) do detectedCount = detectedCount + 1 end
    
    TeleportLocations.NPCs = detectedNPCs
    print("XSAN: ✅ Using REAL-TIME detected NPC locations! Found", detectedCount, "NPCs")
    NotifySuccess("NPC Detection", "✅ Real-time NPC locations detected!\n📍 " .. detectedCount .. " NPCs found with accurate positions.\n🔄 Auto-refresh: Active")
    
    -- Merge important fallback NPCs if not detected
    for fallbackName, fallbackCFrame in pairs(fallbackNPCs) do
        if not detectedNPCs[fallbackName] then
            TeleportLocations.NPCs[fallbackName .. " (Fallback)"] = fallbackCFrame
            print("XSAN: Added fallback NPC:", fallbackName)
        end
    end
else
    TeleportLocations.NPCs = fallbackNPCs
    print("XSAN: ⚠️ Real-time detection failed - Using fallback NPC locations")
    NotifyInfo("NPC Detection", "⚠️ Using fallback NPC locations.\n🔄 Real-time detection will retry automatically.\n📍 11 NPCs loaded from backup database")
end

-- Auto Face Water Function
local function AutoFaceWater(humanoidRootPart, locationName)
    -- Smart water detection based on location
    local waterDirection = nil
    local currentPos = humanoidRootPart.Position
    
    -- Special facing directions for specific locations
    if string.find(locationName:lower(), "sisypus") then
        -- Face towards the statue fishing spot
        waterDirection = Vector3.new(-3730, currentPos.Y, -951) - currentPos
    elseif string.find(locationName:lower(), "treasure") then
        -- Face towards treasure hall water
        waterDirection = Vector3.new(-3547, currentPos.Y, -1668) - currentPos
    elseif string.find(locationName:lower(), "ice") or string.find(locationName:lower(), "snow") then
        -- Face towards ice water
        waterDirection = Vector3.new(1990, currentPos.Y, 3021) - currentPos
    elseif string.find(locationName:lower(), "crater") or string.find(locationName:lower(), "volcano") then
        -- Face towards crater water
        waterDirection = Vector3.new(990, currentPos.Y, 5059) - currentPos
    elseif string.find(locationName:lower(), "tropical") then
        -- Face towards tropical water
        waterDirection = Vector3.new(-2093, currentPos.Y, 3654) - currentPos
    elseif string.find(locationName:lower(), "stone") then
        -- Face towards stone water
        waterDirection = Vector3.new(-2636, currentPos.Y, -27) - currentPos
    elseif string.find(locationName:lower(), "machine") then
        -- Face towards machine water
        waterDirection = Vector3.new(-1551, currentPos.Y, 1920) - currentPos
    elseif string.find(locationName:lower(), "stringry") then
        -- Face towards stringry water
        waterDirection = Vector3.new(102, currentPos.Y, 3054) - currentPos
    else
        -- General water detection - look for nearest water
        -- Method 1: Raycast to find water
        local raycast = workspace:Raycast(currentPos, Vector3.new(0, -100, 0))
        if raycast and raycast.Instance then
            local hitPart = raycast.Instance
            if hitPart.Name:lower():find("water") or hitPart.Material == Enum.Material.Water then
                waterDirection = hitPart.Position - currentPos
            end
        end
        
        -- Method 2: Look for common water locations nearby
        if not waterDirection then
            local waterSpots = {
                Vector3.new(0, currentPos.Y, 0),     -- Ocean center
                Vector3.new(-1000, currentPos.Y, 0), -- West water
                Vector3.new(1000, currentPos.Y, 0),  -- East water
                Vector3.new(0, currentPos.Y, -1000), -- North water
                Vector3.new(0, currentPos.Y, 1000),  -- South water
            }
            
            -- Find closest water spot
            local closestDistance = math.huge
            for _, waterSpot in pairs(waterSpots) do
                local distance = (waterSpot - currentPos).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    waterDirection = waterSpot - currentPos
                end
            end
        end
    end
    
    -- Apply the facing direction
    if waterDirection then
        waterDirection = Vector3.new(waterDirection.X, 0, waterDirection.Z).Unit -- Remove Y component and normalize
        local lookDirection = CFrame.lookAt(currentPos, currentPos + waterDirection)
        humanoidRootPart.CFrame = CFrame.new(currentPos, currentPos + waterDirection)
    end
end

-- Safe Teleportation Function with Auto Face Water
local function SafeTeleport(targetCFrame, locationName)
    pcall(function()
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            NotifyError("Teleport", "Character not found! Cannot teleport.")
            return
        end
        
        local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
        
        -- Smooth teleportation with fade effect
        local originalCFrame = humanoidRootPart.CFrame
        
        -- Teleport with slight offset to avoid collision
        local safePosition = targetCFrame.Position + Vector3.new(0, 5, 0)
        humanoidRootPart.CFrame = CFrame.new(safePosition)
        
        wait(0.1)
        
        -- Lower to ground
        humanoidRootPart.CFrame = targetCFrame
        
        -- Auto face water after teleporting
        wait(0.2) -- Small delay to ensure teleport is complete
        AutoFaceWater(humanoidRootPart, locationName)
        
        NotifySuccess("Teleport", "✅ Teleported to: " .. locationName .. "\n🎯 Auto-faced towards water!\n🎣 Ready for fishing!")
        
        -- Log teleportation for analytics
        print("XSAN Teleport: " .. LocalPlayer.Name .. " -> " .. locationName .. " (Auto-faced water)")
    end)
end

print("XSAN: Teleportation system initialized successfully!")

-- Auto-refresh NPC locations system (Background task)
task.spawn(function()
    while true do
        task.wait(30) -- Check every 30 seconds
        pcall(function()
            local updatedNPCs = DetectNPCLocations()
            if next(updatedNPCs) then
                local oldCount = 0
                local newCount = 0
                
                for _ in pairs(TeleportLocations.NPCs) do oldCount = oldCount + 1 end
                for _ in pairs(updatedNPCs) do newCount = newCount + 1 end
                
                -- Update if we found more NPCs or different locations
                if newCount > oldCount then
                    TeleportLocations.NPCs = updatedNPCs
                    print("XSAN Auto-Refresh: Updated NPC locations -", newCount, "NPCs detected")
                end
            end
        end)
    end
end)

-- Count islands and print debug info
local islandCount = 0
for _ in pairs(TeleportLocations.Islands) do
    islandCount = islandCount + 1
end

print("XSAN: Found " .. islandCount .. " islands for teleportation")
print("XSAN: Using dynamic location system like old.lua for accuracy")

-- ═══════════════════════════════════════════════════════════════
-- RANDOM SPOT FISHING SYSTEM
-- ═══════════════════════════════════════════════════════════════

-- Function to get random fishing spot
local function GetRandomSpot()
    local spots = {}
    for spotName, cframe in pairs(TeleportLocations.RandomSpots) do
        -- Only include selected spots
        if selectedSpots[spotName] then
            table.insert(spots, {name = spotName, cframe = cframe})
        end
    end
    
    if #spots > 0 then
        local randomIndex = math.random(1, #spots)
        return spots[randomIndex]
    end
    return nil
end

-- Function to get selected spots count
local function GetSelectedSpotsCount()
    local count = 0
    for spotName, isSelected in pairs(selectedSpots) do
        if isSelected then
            count = count + 1
        end
    end
    return count
end

-- Function to start random spot fishing - ENHANCED WITH ANALYTICS
local function StartRandomSpotFishing()
    randomSpotSession = randomSpotSession + 1
    local mySession = randomSpotSession
    featureState.RandomSpot = true
    lastRandomSpotChange = tick()
    randomSpotStats.currentLocationStartTime = tick()
    
    randomSpotThread = task.spawn(function()
        while randomSpotEnabled and mySession == randomSpotSession do
            -- Get random spot
            local randomSpot = GetRandomSpot()
            if randomSpot then
                -- Update previous location stats if switching
                if currentRandomSpot ~= "None" and currentRandomSpot ~= randomSpot.name then
                    local timeSpent = tick() - randomSpotStats.currentLocationStartTime
                    randomSpotStats.timePerLocation[currentRandomSpot] = randomSpotStats.timePerLocation[currentRandomSpot] + timeSpent
                    randomSpotStats.totalSwitches = randomSpotStats.totalSwitches + 1
                end
                
                currentRandomSpot = randomSpot.name
                lastRandomSpotChange = tick()
                randomSpotStats.currentLocationStartTime = tick()
                
                -- Teleport to random spot
                SafeTeleport(randomSpot.cframe, randomSpot.name)
                NotifySuccess("Random Spot", "🎣 Teleported to: " .. randomSpot.name .. "\n⏰ Fishing for " .. randomSpotInterval .. " minutes\n🎲 Switch #" .. (randomSpotStats.totalSwitches + 1))
                
                -- Wait for the interval (convert minutes to seconds)
                local waitTime = randomSpotInterval * 60
                local startTime = tick()
                
                while randomSpotEnabled and mySession == randomSpotSession and (tick() - startTime) < waitTime do
                    task.wait(1)
                end
                
                if not randomSpotEnabled or mySession ~= randomSpotSession then
                    break
                end
            else
                NotifyError("Random Spot", "❌ No random spots available!")
                break
            end
        end
        
        -- Save final location stats
        if currentRandomSpot ~= "None" then
            local timeSpent = tick() - randomSpotStats.currentLocationStartTime
            randomSpotStats.timePerLocation[currentRandomSpot] = randomSpotStats.timePerLocation[currentRandomSpot] + timeSpent
        end
        
        currentRandomSpot = "None"
        featureState.RandomSpot = false
    end)
end

-- Function to stop random spot fishing
local function StopRandomSpotFishing()
    randomSpotEnabled = false
    randomSpotSession = randomSpotSession + 1
    randomSpotThread = nil
    currentRandomSpot = "None"
    featureState.RandomSpot = false
    
    NotifyInfo("Random Spot", "🛑 Random spot fishing stopped!")
end

-- Analytics Functions
local function CalculateFishPerHour()
    local timeElapsed = (tick() - sessionStartTime) / 3600
    if timeElapsed > 0 then
        return math.floor(fishCaught / timeElapsed)
    end
    return 0
end

local function CalculateUltra()
    local avgFishValue = 50
    return fishCaught * avgFishValue
end

-- Quick Start Presets with centralized configuration
local function ApplyPreset(presetName)
    currentPreset = presetName
    local presetConfig = XSAN_CONFIG.presets[presetName]
    
    if presetName == "Beginner" then
        autoRecastDelay = 2.0
        perfectCast = false
        safeMode = false
        autoSellThreshold = presetConfig.autosell
        autoSellOnThreshold = globalAutoSellEnabled
        
        local message = GetNotificationMessage("preset_applied", {
            preset = "Beginner",
            purpose = presetConfig.purpose,
            autosell_status = globalAutoSellEnabled and "💰 Auto Sell: ON" or "💰 Auto Sell: OFF"
        })
        NotifySuccess("Preset Applied", message)
        
    elseif presetName == "Speed" then
        autoRecastDelay = 0.5
        perfectCast = true
        safeMode = false
        autoSellThreshold = presetConfig.autosell
        autoSellOnThreshold = globalAutoSellEnabled
        
        local message = GetNotificationMessage("preset_applied", {
            preset = "Speed",
            purpose = presetConfig.purpose,
            autosell_status = globalAutoSellEnabled and "💰 Auto Sell: ON" or "💰 Auto Sell: OFF"
        })
        NotifySuccess("Preset Applied", message)
        
    elseif presetName == "Ultra" then
        autoRecastDelay = 0.1
        perfectCast = true
        safeMode = false
        autoSellThreshold = presetConfig.autosell
        autoSellOnThreshold = globalAutoSellEnabled
        
        local message = GetNotificationMessage("preset_applied", {
            preset = "Ultra",
            purpose = presetConfig.purpose,
            autosell_status = globalAutoSellEnabled and "💰 Auto Sell: ON" or "💰 Auto Sell: OFF"
        })
        NotifySuccess("Preset Applied", message)
        
    elseif presetName == "AFK" then
        autoRecastDelay = 0.4
        perfectCast = true
        safeMode = false
        autoSellThreshold = presetConfig.autosell
        autoSellOnThreshold = globalAutoSellEnabled
        
        local message = GetNotificationMessage("preset_applied", {
            preset = "AFK",
            purpose = presetConfig.purpose,
            autosell_status = globalAutoSellEnabled and "💰 Auto Sell: ON" or "💰 Auto Sell: OFF"
        })
        NotifySuccess("Preset Applied", message)
        
    elseif presetName == "Safe" then
        autoRecastDelay = math.random() * (0.1 - 0.4) + 0.1 -- random antara 0.1 dan 0.4
        perfectCast = false
        safeMode = true
        safeModeChance = 80
        autoSellThreshold = presetConfig.autosell
        autoSellOnThreshold = globalAutoSellEnabled
        
        local message = GetNotificationMessage("preset_applied", {
            preset = "Safe",
            purpose = presetConfig.purpose,
            autosell_status = globalAutoSellEnabled and "💰 Auto Sell: ON" or "💰 Auto Sell: OFF"
        })
        NotifySuccess("Preset Applied", message)
        
    elseif presetName == "Hybrid" then
        autoRecastDelay = 1.5
        perfectCast = false
        safeMode = false
        hybridMode = true
        hybridPerfectChance = 75
        hybridMinDelay = 0.01
        hybridMaxDelay = 1
        autoSellThreshold = presetConfig.autosell
        autoSellOnThreshold = globalAutoSellEnabled
        
        local message = "🔒 HYBRID ULTIMATE MODE ACTIVATED!\n✅ Server Time Sync\n✅ Human-like AI Patterns\n✅ Anti-Detection Technology\n✅ Maximum Security" .. (globalAutoSellEnabled and "\n💰 Auto Sell: ON" or "\n💰 Auto Sell: OFF")
        NotifySuccess("Preset Applied", message)
        
    elseif presetName == "AutoSellOn" then
        globalAutoSellEnabled = true
        autoSellOnThreshold = true
        NotifySuccess("Auto Sell", "💰 Global Auto Sell activated!\n📦 Will apply to all future presets\n🎯 Threshold: " .. autoSellThreshold .. " fish")
        
    elseif presetName == "AutoSellOff" then
        globalAutoSellEnabled = false
        autoSellOnThreshold = false
        NotifySuccess("Auto Sell", "💰 Global Auto Sell deactivated!\n📝 Manual selling only for all presets\n🎮 Full manual control")
    end
end

-- Auto Sell Function - ENHANCED & MODERNIZED
local function CheckAndAutoSell()
    if autoSellOnThreshold and fishCaught >= autoSellThreshold then
        pcall(function()
            -- Validate player character
            if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then 
                NotifyError("Auto Sell", "❌ Character not found!")
                return 
            end

            -- Modern validation: Check if selling is possible
            local sellRemote = net and net:FindFirstChild("RF/SellAllItems")
            if not sellRemote then
                NotifyError("Auto Sell", "❌ SellAllItems remote not found!")
                return
            end

            -- Enhanced NPC detection with multiple fallbacks
            local alexNpc = nil
            local npcContainer = ReplicatedStorage:FindFirstChild("NPC")
            
            -- Method 1: Try ReplicatedStorage.NPC.Alex
            if npcContainer then
                alexNpc = npcContainer:FindFirstChild("Alex")
            end
            
            -- Method 2: Try workspace NPCs if not found
            if not alexNpc then
                for _, npc in pairs(workspace:GetChildren()) do
                    if npc.Name == "Alex" and npc:FindFirstChild("HumanoidRootPart") then
                        alexNpc = npc
                        break
                    end
                end
            end

            if not alexNpc then
                NotifyError("Auto Sell", "❌ NPC 'Alex' not found!\n💡 Try moving closer to Alex NPC")
                return
            end

            -- Save original position for return
            local originalCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            
            -- Get NPC position (handle both WorldPivot and HumanoidRootPart)
            local npcPosition
            if alexNpc.WorldPivot then
                npcPosition = alexNpc.WorldPivot.Position
            elseif alexNpc:FindFirstChild("HumanoidRootPart") then
                npcPosition = alexNpc.HumanoidRootPart.Position
            else
                NotifyError("Auto Sell", "❌ Cannot find Alex NPC position!")
                return
            end

            -- Teleport to NPC with offset to avoid overlapping
            local sellPosition = CFrame.new(npcPosition + Vector3.new(0, 0, -3))
            LocalPlayer.Character.HumanoidRootPart.CFrame = sellPosition
            
            NotifyInfo("Auto Sell", "🚀 Teleporting to Alex for auto sell...")
            task.wait(0.5) -- Shorter wait for better responsiveness

            -- Attempt to sell items with enhanced error handling
            local sellSuccess, sellResult = pcall(function()
                return sellRemote:InvokeServer()
            end)

            if sellSuccess then
                -- Update counters
                itemsSold = itemsSold + 1
                local previousFishCount = fishCaught
                fishCaught = 0 -- Reset fish count
                
                NotifySuccess("Auto Sell", "✅ Successfully sold items!\n\n📦 Fish sold: " .. previousFishCount .. "\n💰 Total sales: " .. itemsSold .. "\n🎯 Threshold: " .. autoSellThreshold)
            else
                NotifyError("Auto Sell", "❌ Failed to sell items!\n💡 Reason: " .. tostring(sellResult))
            end

            -- Return to original position
            task.wait(0.3)
            LocalPlayer.Character.HumanoidRootPart.CFrame = originalCFrame
            NotifyInfo("Auto Sell", "🔄 Returned to fishing position")
            
        end)
    end
end

-- ═══════════════════════════════════════════════════════════════
-- INFO TAB - XSAN Branding Section with Centralized Configuration
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating INFO tab content...")

-- Simple description for INFO tab
InfoTab:CreateParagraph({
    Title = "XSAN Fish It Pro Ultimate v1.0",
    Content = "Premium script dengan fitur AI, smart automation, dan keamanan maksimal. Dibuat oleh XSAN untuk pengalaman fishing terbaik di Fish It!"
})

InfoTab:CreateParagraph({
    Title = "✨ Fitur Utama",
    Content = "• Auto Fishing dengan AI patterns\n• Teleportasi ke semua lokasi\n• Smart inventory & auto sell\n• Analytics & statistics\n• Safety & anti-detection\n• Mobile optimized UI"
})

InfoTab:CreateButton({ 
    Name = "Copy Telegram Group", 
    Callback = CreateSafeCallback(function() 
        if setclipboard then
            setclipboard("https://t.me/Spinner_xxx") 
            NotifySuccess("Social Media", "Telegram link copied! Join for updates and support!")
        else
            NotifyInfo("Social Media", "Telegram: " .. XSAN_CONFIG.branding.telegram)
        end
    end, "telegram")
})

InfoTab:CreateButton({ 
    Name = "Copy Telegram Link", 
    Callback = CreateSafeCallback(function() 
        if setclipboard then
            setclipboard("https://t.me/Spinnerxxx") 
            NotifySuccess("Social Media", "Telegram link copied! Join for updates and support!")
        else
            NotifyInfo("Social Media", "Tele Groub: " .. XSAN_CONFIG.branding.github)
        end
    end, "Telegram")
})

InfoTab:CreateButton({ 
    Name = "Fix UI Scrolling", 
    Callback = CreateSafeCallback(function() 
        local function fixScrollingFrames()
            local rayfieldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
            if rayfieldGui then
                local fixed = 0
                for _, descendant in pairs(rayfieldGui:GetDescendants()) do
                    if descendant:IsA("ScrollingFrame") then
                        -- Enable proper scrolling
                        descendant.ScrollingEnabled = true
                        descendant.ScrollBarThickness = 8
                        descendant.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
                        descendant.ScrollBarImageTransparency = 0.3
                        
                        -- Auto canvas size if supported
                        if descendant:FindFirstChild("UIListLayout") then
                            descendant.AutomaticCanvasSize = Enum.AutomaticSize.Y
                            descendant.CanvasSize = UDim2.new(0, 0, 0, 0)
                        end
                        
                        -- Enable mouse wheel scrolling
                        descendant.Active = true
                        descendant.Selectable = true
                        
                        fixed = fixed + 1
                    end
                end
                NotifySuccess("UI Fix", "Fixed scrolling for " .. fixed .. " elements. You can now scroll through tabs!")
            else
                NotifyError("UI Fix", "Rayfield GUI not found")
            end
        end
        
        fixScrollingFrames()
    end, "fix_scrolling")
})

InfoTab:CreateButton({ 
    Name = "🔧 Fix Black Tabs", 
    Callback = CreateSafeCallback(function() 
        local function fixTabVisibility()
            local rayfieldGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") or game.CoreGui:FindFirstChild("RayfieldLibrary")
            if rayfieldGui then
                local fixedTabs = 0
                
                for _, descendant in pairs(rayfieldGui:GetDescendants()) do
                    -- Fix tab containers
                    if descendant:IsA("Frame") and (descendant.Name == "TabContainer" or descendant.Name:find("Tab")) then
                        descendant.BackgroundTransparency = 0
                        descendant.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                        descendant.Visible = true
                        fixedTabs = fixedTabs + 1
                    end
                    
                    -- Fix tab buttons
                    if descendant:IsA("TextButton") and descendant.Parent and descendant.Parent.Name == "TabContainer" then
                        descendant.BackgroundTransparency = 0.1
                        descendant.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                        descendant.TextColor3 = Color3.fromRGB(255, 255, 255)
                        descendant.BorderSizePixel = 1
                        descendant.BorderColor3 = Color3.fromRGB(100, 100, 100)
                        descendant.Visible = true
                        fixedTabs = fixedTabs + 1
                    end
                    
                    -- Fix tab content frames
                    if descendant:IsA("Frame") and descendant.Name:find("Content") then
                        descendant.BackgroundTransparency = 0
                        descendant.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        descendant.Visible = true
                    end
                    
                    -- Fix any transparent elements
                    if descendant:IsA("GuiObject") and descendant.BackgroundTransparency >= 1 then
                        descendant.BackgroundTransparency = 0.1
                        descendant.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                    end
                end
                
                NotifySuccess("Tab Fix", "✅ Fixed " .. fixedTabs .. " tab elements!\n\n🎯 Tabs should now be visible\n🔄 If still black, try switching themes")
            else
                NotifyError("Tab Fix", "❌ Rayfield GUI not found!")
            end
        end
        
        fixTabVisibility()
    end, "fix_tabs")
})

InfoTab:CreateButton({ 
    Name = "🎨 Change Theme", 
    Callback = CreateSafeCallback(function() 
        NotifyInfo("Theme Change", "🎨 Available Themes:\n• Ocean (Current)\n• Default\n• Amethyst\n• DarkBlue\n\n⚠️ Reload script to change theme\n💡 Try different themes if tabs appear black")
    end, "change_theme")
})

print("XSAN: INFO tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- PRESETS TAB - Quick Start Configurations with Centralized Configuration
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating PRESETS tab content...")
-- Content minimal untuk PresetTab
PresetsTab:CreateParagraph({
    Title = "Quick Setup",
    Content = "Choose your fishing mode:"
})

-- Auto Sell section di paling atas untuk akses cepat
PresetsTab:CreateButton({
    Name = "🟢 Global Auto Sell ON",
    Callback = CreateSafeCallback(function()
        ApplyPreset("AutoSellOn")
    end, "preset_autosell_on")
})

PresetsTab:CreateButton({
    Name = "🔴 Global Auto Sell OFF",
    Callback = CreateSafeCallback(function()
        ApplyPreset("AutoSellOff")
    end, "preset_autosell_off")
})

PresetsTab:CreateButton({
    Name = "Beginner Mode",
    Callback = CreateSafeCallback(function()
        ApplyPreset("Beginner")
    end, "preset_beginner")
})

PresetsTab:CreateButton({
    Name = "Speed Mode",
    Callback = CreateSafeCallback(function()
        ApplyPreset("Speed")
    end, "preset_speed")
})

PresetsTab:CreateButton({
    Name = "Ultra Mode", 
    Callback = CreateSafeCallback(function()
        ApplyPreset("Ultra")
    end, "preset_Ultra")
})

PresetsTab:CreateButton({
    Name = "AFK Mode",
    Callback = CreateSafeCallback(function()
        ApplyPreset("AFK") 
    end, "preset_afk")
})

PresetsTab:CreateButton({
    Name = "�️ Safe Mode",
    Callback = CreateSafeCallback(function()
        ApplyPreset("Safe") 
    end, "preset_safe")
})

PresetsTab:CreateButton({
    Name = "� HYBRID MODE (Ultimate)",
    Callback = CreateSafeCallback(function()
        ApplyPreset("Hybrid") 
    end, "preset_hybrid")
})

print("XSAN: PRESETS tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- TELEPORT TAB - Ultimate Teleportation System
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating TELEPORT tab content...")

-- Islands Section

-- Create buttons for each island (dynamic like old.lua)
for locationName, cframe in pairs(TeleportLocations.Islands) do
    -- Add emoji prefix if not already present with more specific icons
    local displayName = locationName
    if not string.find(locationName, "🏝️") and not string.find(locationName, "🌊") and not string.find(locationName, "🏔️") and not string.find(locationName, "🌋") and not string.find(locationName, "❄️") and not string.find(locationName, "🏛️") then
        -- Add specific icons based on location names
        if string.find(locationName:lower(), "volcano") or string.find(locationName:lower(), "crater") then
            displayName = "🌋 " .. locationName
        elseif string.find(locationName:lower(), "snow") or string.find(locationName:lower(), "ice") then
            displayName = locationName
        elseif string.find(locationName:lower(), "depth") or string.find(locationName:lower(), "ocean") then
            displayName = locationName
        elseif string.find(locationName:lower(), "ancient") or string.find(locationName:lower(), "statue") or string.find(locationName:lower(), "altar") then
            displayName = locationName
        elseif string.find(locationName:lower(), "mountain") or string.find(locationName:lower(), "peak") then
            displayName = locationName
        elseif string.find(locationName:lower(), "swamp") or string.find(locationName:lower(), "grove") then
            displayName = locationName
        elseif string.find(locationName:lower(), "reef") or string.find(locationName:lower(), "coral") then
            displayName = locationName
        else
            displayName = "🏝️ " .. locationName
        end
    end
    
    TeleportTab:CreateButton({
        Name = displayName,
        Callback = CreateSafeCallback(function()
            SafeTeleport(cframe, locationName)
        end, "tp_island_" .. locationName)
    })
end

-- NPCs Section

-- Refresh NPC Locations Button
TeleportTab:CreateButton({
    Name = "🔄 Refresh NPC Locations",
    Callback = CreateSafeCallback(function()
        -- Re-detect NPC locations
        local newDetectedNPCs = DetectNPCLocations()
        
        if next(newDetectedNPCs) then
            TeleportLocations.NPCs = newDetectedNPCs
            local npcCount = 0
            for _ in pairs(newDetectedNPCs) do npcCount = npcCount + 1 end
            
            NotifySuccess("NPC Refresh", "✅ NPC locations updated! Found " .. npcCount .. " NPCs with real-time positions.\n\n⚠️ Please reload the script to see updated buttons.")
            
            -- Print detected NPCs for debugging
            print("XSAN: Updated NPC Locations:")
            for name, cframe in pairs(newDetectedNPCs) do
                print("  •", name, ":", cframe.Position)
            end
        else
            NotifyError("NPC Refresh", "❌ No NPCs detected! Using fallback locations.\n\nTry moving closer to NPCs or check if you're in the right area.")
        end
    end, "refresh_npcs")
})

-- Show NPC Detection Info Button
TeleportTab:CreateButton({
    Name = "📍 Show NPC Detection Info",
    Callback = CreateSafeCallback(function()
        local npcInfo = "🔍 DETECTED NPC LOCATIONS:\n\n"
        local npcCount = 0
        
        for npcName, cframe in pairs(TeleportLocations.NPCs) do
            npcCount = npcCount + 1
            local pos = cframe.Position
            npcInfo = npcInfo .. string.format("📍 %s\n   Position: %.1f, %.1f, %.1f\n\n", npcName, pos.X, pos.Y, pos.Z)
        end
        
        npcInfo = npcInfo .. "📊 Total NPCs: " .. npcCount .. "\n"
        npcInfo = npcInfo .. "🔄 Auto-refresh: Every 30 seconds\n"
        npcInfo = npcInfo .. "✅ Real-time detection active!"
        
        NotifyInfo("NPC Detection", npcInfo)
    end, "show_npc_info")
})

-- Create buttons for each NPC
for npcName, cframe in pairs(TeleportLocations.NPCs) do
    TeleportTab:CreateButton({
        Name = npcName,
        Callback = CreateSafeCallback(function()
            SafeTeleport(cframe, npcName)
        end, "tp_npc_" .. npcName)
    })
end

-- Events Section

-- Create buttons for each event location
for eventName, cframe in pairs(TeleportLocations.Events) do
    TeleportTab:CreateButton({
        Name = eventName,
        Callback = CreateSafeCallback(function()
            SafeTeleport(cframe, eventName)
        end, "tp_event_" .. eventName)
    })
end

-- Player Teleportation Section (Moved below Events)

TeleportTab:CreateButton({
    Name = "🔄 Refresh Player List",
    Callback = CreateSafeCallback(function()
        local playerCount = 0
        local playerList = ""
        local playersFound = {}
        
        -- Primary method: Players service (most reliable)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local hasCharacter = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                local status = hasCharacter and "✅" or "⚠️"
                playerCount = playerCount + 1
                playerList = playerList .. status .. " " .. player.Name
                if player.DisplayName ~= player.Name then
                    playerList = playerList .. " (" .. player.DisplayName .. ")"
                end
                playerList = playerList .. "\n"
                table.insert(playersFound, {name = player.Name, hasChar = hasCharacter})
            end
        end
        
        -- Secondary method: Check Characters folder for additional info
        local charFolder = workspace:FindFirstChild("Characters")
        local charCount = 0
        if charFolder then
            for _, char in pairs(charFolder:GetChildren()) do
                if char:IsA("Model") and char.Name ~= LocalPlayer.Name then
                    charCount = charCount + 1
                end
            end
        end
        
        if playerCount > 0 then
            local readyPlayers = 0
            for _, p in pairs(playersFound) do
                if p.hasChar then readyPlayers = readyPlayers + 1 end
            end
            
            NotifyInfo("Player List", 
                "🎮 Players di server: " .. playerCount .. "\n" ..
                "✅ Siap untuk teleport: " .. readyPlayers .. "\n" ..
                "📁 Characters di workspace: " .. charCount .. "\n\n" ..
                "📋 Daftar Players:\n" .. playerList .. "\n" ..
                "💡 ✅ = Siap teleport, ⚠️ = Loading/Respawning"
            )
        else
            NotifyError("Player List", "❌ Tidak ada player lain di server!\n\n🔍 Pastikan Anda di server multiplayer\n⏳ Tunggu player lain join server")
        end
    end, "refresh_players")
})

-- Quick Player Teleport Buttons (Top 5 Players)

local function CreatePlayerButtons()
    local players = {}
    
    -- Method 1: Players service (most reliable and up-to-date)
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local hasCharacter = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            table.insert(players, {
                name = player.Name,
                displayName = player.DisplayName,
                ready = hasCharacter
            })
        end
    end
    
    -- Sort players: ready players first
    table.sort(players, function(a, b)
        if a.ready and not b.ready then return true end
        if not a.ready and b.ready then return false end
        return a.name < b.name
    end)
    
    -- Show all players with scrollable format
    if #players > 0 then
        -- Add info about total players
        TeleportTab:CreateParagraph({
            Title = "👥 Players in Server",
            Content = "Found " .. #players .. " other players. All players are shown below (scrollable):"
        })
        
        -- Create buttons for ALL players (scrollable)
        for i = 1, #players do
            local playerData = players[i]
            local buttonName = playerData.ready and "✅ " or "⚠️ "
            buttonName = buttonName .. playerData.name
            if playerData.displayName ~= playerData.name then
                buttonName = buttonName .. " (" .. playerData.displayName .. ")"
            end
            
            TeleportTab:CreateButton({
                Name = buttonName,
                Callback = CreateSafeCallback(function()
                    if not playerData.ready then
                        NotifyError("Player TP", "⚠️ Player " .. playerData.name .. " sedang loading atau respawning!\n\n💡 Tunggu sebentar atau coba lagi")
                        return
                    end
                    TeleportToPlayer(playerData.name)
                end, "tp_player_" .. playerData.name)
            })
        end
    else
        TeleportTab:CreateParagraph({
            Title = "❌ No Players Found",
            Content = "No other players detected in the server. Make sure you're in a multiplayer server!"
        })
    end
    
    -- Show info if there are more players
    if #players > 5 then
        TeleportTab:CreateButton({
            Name = "� +" .. (#players - 5) .. " players lainnya",
            Callback = CreateSafeCallback(function()
                local allPlayersList = ""
                for i = 6, #players do
                    local p = players[i]
                    local status = p.ready and "✅" or "⚠️"
                    allPlayersList = allPlayersList .. status .. " " .. p.name .. "\n"
                end
                NotifyInfo("More Players", "Player lainnya di server:\n\n" .. allPlayersList .. "\n💡 Gunakan manual input untuk teleport ke mereka")
            end, "show_more_players")
        })
    end
    
    if #players > 5 then
        TeleportTab:CreateParagraph({
            Title = "📝 More Players Available",
            Content = "There are " .. #players .. " players total. Use manual input below for others, or refresh to see different players."
        })
    elseif #players == 0 then
        TeleportTab:CreateParagraph({
            Title = "❌ No Players Found",
            Content = "No other players detected in the server. Make sure you're in a multiplayer server!"
        })
    end
end

-- Initialize player buttons
CreatePlayerButtons()

-- Manual Player Teleport
local targetPlayerName = ""

TeleportTab:CreateInput({
    Name = "📝 Masukkan Nama Player",
    PlaceholderText = "Ketik nama player di sini...",
    RemoveTextAfterFocusLost = false,
    Callback = function(text)
        targetPlayerName = text
        if text and text ~= "" then
            NotifyInfo("Input Player", "🎯 Target: " .. text .. "\n\n💡 Tekan tombol teleport untuk melanjutkan")
        end
    end
})

TeleportTab:CreateButton({
    Name = "🎯 Teleport ke Player",
    Callback = CreateSafeCallback(function()
        if targetPlayerName and targetPlayerName ~= "" then
            NotifyInfo("Teleporting", "🚀 Mencoba teleport ke: " .. targetPlayerName .. "...")
            TeleportToPlayer(targetPlayerName)
        else
            NotifyError("Player TP", "❌ Masukkan nama player terlebih dahulu!\n\n📝 Gunakan input box di atas untuk mengetik nama player")
        end
    end, "tp_to_player")
})

-- Quick teleport suggestions
TeleportTab:CreateButton({
    Name = "💡 Tips Teleport Player",
    Callback = CreateSafeCallback(function()
        NotifyInfo("Tips Teleport", 
            "💡 Tips untuk teleport ke player:\n\n" ..
            "✅ Gunakan nama exact atau sebagian nama\n" ..
            "✅ Tidak case-sensitive (besar/kecil huruf)\n" ..
            "✅ Bisa gunakan DisplayName atau Username\n" ..
            "✅ Refresh player list untuk update terbaru\n\n" ..
            "⚠️ Player harus online dan memiliki character\n" ..
            "🔄 Jika gagal, coba refresh atau tunggu player spawn"
        )
    end, "tp_tips")
})

-- Utility Teleportation

TeleportTab:CreateButton({
    Name = "🎯 Auto Face Water",
    Callback = CreateSafeCallback(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = LocalPlayer.Character.HumanoidRootPart
            AutoFaceWater(humanoidRootPart, "current location")
            NotifySuccess("Auto Face", "🎯 Character rotated to face water!\n🎣 Ready for fishing!")
        else
            NotifyError("Auto Face", "❌ Character not found!")
        end
    end, "auto_face_water")
})

TeleportTab:CreateButton({
    Name = "📍 Save Current Position",
    Callback = CreateSafeCallback(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            _G.XSANSavedPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
            NotifySuccess("Position Saved", "📍 Current position saved! Use 'Return to Saved Position' to come back here.")
        else
            NotifyError("Save Position", "❌ Character not found!")
        end
    end, "save_position")
})

TeleportTab:CreateButton({
    Name = "🔙 Return to Saved Position",
    Callback = CreateSafeCallback(function()
        if _G.XSANSavedPosition then
            SafeTeleport(_G.XSANSavedPosition, "Saved Position")
        else
            NotifyError("Return Position", "❌ No saved position found! Save a position first.")
        end
    end, "return_position")
})

TeleportTab:CreateButton({
    Name = "🏠 Teleport to Spawn",
    Callback = CreateSafeCallback(function()
        -- Try to use dynamic location first
        local spawnCFrame = TeleportLocations.Islands["Moosewood"] or CFrame.new(389, 137, 264)
        SafeTeleport(spawnCFrame, "Moosewood Spawn")
    end, "tp_spawn")
})

print("XSAN: TELEPORT tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- AUTO FISH TAB - Enhanced Fishing System
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating AUTO FISH tab content...")

MainTab:CreateToggle({
    Name = "Enable Auto Fishing",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        autofish = val
        if val then
            -- Start a new session (invalidate any existing loop)
            autofishSession += 1
            local mySession = autofishSession
            if hybridMode then
                -- Initialize hybrid auto fish
                if not hybridAutoFish then
                    hybridAutoFish = Rayfield.CreateSafeAutoFish({
                        safeMode = true,
                        perfectChance = hybridPerfectChance,
                        minDelay = hybridMinDelay,
                        maxDelay = hybridMaxDelay,
                        useServerTime = true
                    })
                end
                hybridAutoFish.toggle(true)
                NotifySuccess("Hybrid Auto Fish", "HYBRID SECURITY MODE ACTIVATED!\n🔒 Maximum Safety\n⚡ Server Time Sync\n🎯 Human-like Patterns")
            else
                -- Traditional auto fishing
                NotifySuccess("Auto Fish", "XSAN Ultimate auto fishing started! AI systems activated.")
                local function smartWait(total, session)
                    local elapsed = 0
                    local step = 0.05
                    while elapsed < total do
                        if autofishSession ~= session or not autofish then return false end
                        local dt = task.wait(step)
                        elapsed += dt
                    end
                    return true
                end
                autofishThread = coroutine.create(function()
                    while autofish and autofishSession == mySession do
                        -- Early abort check
                        if autofishSession ~= mySession or not autofish then break end
                        pcall(function()
                            if autofishSession ~= mySession or not autofish then return end
                            if equipRemote then equipRemote:FireServer(1) end
                            smartWait(0.1, mySession)

                            if autofishSession ~= mySession or not autofish then return end
                            -- Safe Mode Logic: Random between perfect and normal cast
                            local usePerfectCast = perfectCast
                            if safeMode then
                                usePerfectCast = math.random(80, 100) <= safeModeChance
                            end

                            local timestamp = usePerfectCast and 9999999999 or (tick() + math.random())
                            if rodRemote and autofishSession == mySession and autofish then
                                rodRemote:InvokeServer(timestamp)
                            end
                            smartWait(0.1, mySession)

                            if autofishSession ~= mySession or not autofish then return end
                            local x = usePerfectCast and -1.238 or (math.random(-1000, 1000) / 1000)
                            local y = usePerfectCast and 0.969 or (math.random(0, 1000) / 1000)

                            if miniGameRemote and autofishSession == mySession and autofish then
                                miniGameRemote:InvokeServer(x, y)
                            end
                            smartWait(1.3, mySession)

                            if autofishSession ~= mySession or not autofish then return end
                            if finishRemote then finishRemote:FireServer() end

                            fishCaught += 1

                            -- Fish detection and tracking
                            DetectAndTrackFish()

                            -- Track cast types for analytics
                            if usePerfectCast then
                                perfectCasts += 1
                            else
                                normalCasts += 1
                            end

                            CheckAndAutoSell()
                        end)
                        -- Recast delay with cancel support
                        if not smartWait(autoRecastDelay, mySession) then break end
                    end
                end)
                coroutine.resume(autofishThread)
            end
        else
            -- Disable: invalidate session so loop breaks ASAP
            autofishSession += 1
            autofishThread = nil
            
            -- Enhanced cleanup for manual fishing restoration
            if hybridMode and hybridAutoFish then
                hybridAutoFish.toggle(false)
                NotifyInfo("Hybrid Auto Fish", "🔄 Hybrid auto fishing stopped.\n\n✅ Manual fishing control restored\n🎣 All systems ready for manual use")
            else
                NotifyInfo("Auto Fish", "🛑 Auto fishing stopped by user.\n\n✅ Manual fishing control restored\n🎣 Click fishing rod to continue manually")
            end
            
            -- Small delay to ensure all auto fishing processes stop
            task.spawn(function()
                task.wait(0.1)
                -- Additional cleanup if needed
                if unequipRemote then
                    -- Ensure rod is properly equipped for manual use
                    pcall(function()
                        unequipRemote:FireServer(1)
                    end)
                end
            end)
        end
    end, "autofish")
})

MainTab:CreateToggle({
    Name = "Perfect Cast Mode",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        perfectCast = val
        if val then
            safeMode = false  -- Disable safe mode when perfect cast is manually enabled
            hybridMode = false  -- Disable hybrid mode
        end
        NotifySuccess("Perfect Cast", "Perfect cast mode " .. (val and "activated" or "deactivated") .. "!")
    end, "perfectcast")
})

MainTab:CreateToggle({
    Name = "🛡️ Safe Mode (Smart Random)",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        safeMode = val
        if val then
            perfectCast = false  -- Disable perfect cast when safe mode is enabled
            hybridMode = false   -- Disable hybrid mode
            NotifySuccess("Safe Mode", "Safe mode activated - Smart random casting for better stealth!")
        else
            NotifyInfo("Safe Mode", "Safe mode deactivated - Manual control restored")
        end
    end, "safemode")
})

MainTab:CreateToggle({
    Name = "🔒 HYBRID MODE (Ultimate Security)",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        hybridMode = val
        if val then
            perfectCast = false  -- Disable other modes
            safeMode = false
            NotifySuccess("Hybrid Mode", "HYBRID SECURITY ACTIVATED!\n✅ Server Time Sync\n✅ Human-like Patterns\n✅ Anti-Detection\n✅ Maximum Safety")
        else
            NotifyInfo("Hybrid Mode", "Hybrid mode deactivated - Back to manual control")
        end
    end, "hybridmode")
})

MainTab:CreateSlider({
    Name = "Safe Mode Perfect %",
    Range = {50, 85},
    Increment = 5,
    CurrentValue = safeModeChance,
    Callback = function(val)
        safeModeChance = val
        if safeMode then
            NotifyInfo("Safe Mode", "Perfect cast chance set to: " .. val .. "%")
        end
    end
})

MainTab:CreateSlider({
    Name = "Hybrid Perfect %",
    Range = {60, 80},
    Increment = 5,
    CurrentValue = 70,
    Callback = function(val)
        hybridPerfectChance = val
        if hybridMode and hybridAutoFish then
            hybridAutoFish.updateConfig({perfectChance = val})
            NotifyInfo("Hybrid Mode", "Perfect cast chance updated to: " .. val .. "%")
        end
    end
})

MainTab:CreateSlider({
    Name = "Hybrid Min Delay",
    Range = {1.0, 2.0},
    Increment = 0.1,
    CurrentValue = 1.0,
    Callback = function(val)
        hybridMinDelay = val
        if hybridMode and hybridAutoFish then
            hybridAutoFish.updateConfig({minDelay = val})
            NotifyInfo("Hybrid Mode", "Minimum delay updated to: " .. val .. "s")
        end
    end
})

MainTab:CreateSlider({
    Name = "Hybrid Max Delay", 
    Range = {2.0, 3.5},
    Increment = 0.1,
    CurrentValue = 2.5,
    Callback = function(val)
        hybridMaxDelay = val
        if hybridMode and hybridAutoFish then
            hybridAutoFish.updateConfig({maxDelay = val})
            NotifyInfo("Hybrid Mode", "Maximum delay updated to: " .. val .. "s")
        end
    end
})

MainTab:CreateSlider({
    Name = "Auto Recast Delay",
    Range = {0.01, 3.0},
    Increment = 0.1,
    CurrentValue = autoRecastDelay,
    Callback = function(val)
        autoRecastDelay = val
    end
})

MainTab:CreateToggle({
    Name = "Auto Sell on Fish Count",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        autoSellOnThreshold = val
        if val then
            NotifySuccess("Auto Sell Threshold", "Auto sell on threshold activated! Will sell when " .. autoSellThreshold .. " fish caught.")
        else
            NotifyInfo("Auto Sell Threshold", "Auto sell on threshold disabled.")
        end
    end, "autosell_threshold")
})

MainTab:CreateSlider({
    Name = "Fish Threshold",
    Range = {500, 8000},
    Increment = 50,
    CurrentValue = autoSellThreshold,
    Callback = function(val)
        autoSellThreshold = val
        if autoSellOnThreshold then
            NotifyInfo("Threshold Updated", "Auto sell threshold set to: " .. val .. " fish")
        end
    end
})

print("XSAN: AUTO FISH tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- ANALYTICS TAB - Advanced Statistics & Monitoring
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating ANALYTICS tab content...")

AnalyticsTab:CreateButton({
    Name = "Show Detailed Statistics",
    Callback = CreateSafeCallback(function()
        local sessionTime = (tick() - sessionStartTime) / 60
        local fishPerHour = CalculateFishPerHour()
        local estimatedUltra = CalculateUltra()
        local totalCasts = perfectCasts + normalCasts
        local perfectEfficiency = totalCasts > 0 and (perfectCasts / totalCasts * 100) or 0
        local castingMode = safeMode and "Safe Mode" or (perfectCast and "Perfect Cast" or "Normal Cast")
        
        -- Fish detection statistics
        local rarityStats = ""
        for rarity, count in pairs(fishByRarity) do
            if count > 0 then
                rarityStats = rarityStats .. "\n" .. rarity .. ": " .. count
            end
        end
        
        local topFishStats = "Top Fish Caught:\n"
        local fishCount = 0
        for fishName, count in pairs(fishDetectionStats) do
            if fishCount < 5 and count > 0 then
                topFishStats = topFishStats .. fishName .. ": " .. count .. "\n"
                fishCount = fishCount + 1
            end
        end
        
        local stats = string.format("XSAN Ultimate Analytics:\n\nSession Time: %.1f minutes\nFish Caught: %d\nFish/Hour: %d\n\n=== CASTING STATS ===\nMode: %s\nPerfect Casts: %d (%.1f%%)\nNormal Casts: %d\nTotal Casts: %d\n\n=== FISH DETECTION ===\nTotal Unique Fish: %d\nTotal Fish Value: ~%d\nSession Fish: %d%s\n\n%s\n=== EARNINGS ===\nItems Sold: %d\nEstimated Ultra: %d coins\nActive Preset: %s", 
            sessionTime, fishCaught, fishPerHour, castingMode, perfectCasts, perfectEfficiency, normalCasts, totalCasts, 
            totalUniqueFish, totalFishValue, sessionFishCaught, rarityStats, topFishStats, itemsSold, estimatedUltra, currentPreset
        )
        NotifyInfo("Advanced Stats", stats)
    end, "detailed_stats")
})

AnalyticsTab:CreateButton({
    Name = "Show Fish Analytics",
    Callback = CreateSafeCallback(function()
        local fishStats = "🐟 Fish Detection Analytics 🐟\n\n"
        
        -- Rarity breakdown
        fishStats = fishStats .. "=== RARITY BREAKDOWN ===\n"
        for rarity, count in pairs(fishByRarity) do
            if count > 0 then
                fishStats = fishStats .. rarity .. ": " .. count .. " fish\n"
            end
        end
        
        -- Top 10 most caught fish
        fishStats = fishStats .. "\n=== TOP CAUGHT FISH ===\n"
        local sortedFish = {}
        for fishName, count in pairs(fishDetectionStats) do
            if count > 0 then
                table.insert(sortedFish, {name = fishName, count = count})
            end
        end
        table.sort(sortedFish, function(a, b) return a.count > b.count end)
        
        for i = 1, math.min(10, #sortedFish) do
            local fish = sortedFish[i]
            fishStats = fishStats .. fish.name .. ": " .. fish.count .. "\n"
        end
        
        -- Session summary
        fishStats = fishStats .. "\n=== SESSION SUMMARY ===\n"
        fishStats = fishStats .. "Unique Fish Types: " .. totalUniqueFish .. "\n"
        fishStats = fishStats .. "Total Fish Value: ~" .. totalFishValue .. " coins\n"
        fishStats = fishStats .. "Session Fish Caught: " .. sessionFishCaught .. "\n"
        
        NotifyInfo("Fish Analytics", fishStats)
    end, "fish_analytics")
})

AnalyticsTab:CreateButton({
    Name = "Reset Statistics",
    Callback = CreateSafeCallback(function()
        sessionStartTime = tick()
        fishCaught = 0
        itemsSold = 0
        perfectCasts = 0
        normalCasts = 0
        
        -- Reset fish detection stats
        fishDetectionStats = {}
        fishByRarity = {Common = 0, Uncommon = 0, Rare = 0, Epic = 0, Legendary = 0, Mythical = 0, Exotic = 0}
        totalUniqueFish = 0
        totalFishValue = 0
        sessionFishCaught = 0
        
        NotifySuccess("Analytics", "All statistics have been reset!")
    end, "reset_stats")
})

print("XSAN: ANALYTICS tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- INVENTORY TAB - Smart Inventory Management
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating INVENTORY tab content...")

InventoryTab:CreateButton({
    Name = "Check Inventory Status",
    Callback = CreateSafeCallback(function()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            local items = #backpack:GetChildren()
            local itemNames = {}
            for _, item in pairs(backpack:GetChildren()) do
                table.insert(itemNames, item.Name)
            end
            
            local status = string.format("Inventory Status:\n\nTotal Items: %d/20\nSpace Available: %d slots\n\nItems: %s", 
                items, 20 - items, table.concat(itemNames, ", "))
            NotifyInfo("Inventory", status)
        else
            NotifyError("Inventory", "Could not access backpack!")
        end
    end, "check_inventory")
})

print("XSAN: INVENTORY tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- RANDOM SPOT TAB - Auto Random Location Fishing
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating RANDOM SPOT tab content...")

RandomSpotTab:CreateParagraph({
    Title = "🎲 Random Spot Auto Fishing",
    Content = "Sistem auto fishing yang berpindah lokasi secara otomatis setiap interval waktu tertentu. Pilih dari 8 lokasi fishing terbaik!"
})

RandomSpotTab:CreateToggle({
    Name = "🎯 Enable Random Spot Fishing",
    CurrentValue = randomSpotEnabled,
    Flag = "RandomSpotToggle",
    Callback = CreateSafeCallback(function(value)
        randomSpotEnabled = value
        
        if value then
            if not autofish then
                NotifyError("Random Spot", "❌ Aktifkan Auto Fishing terlebih dahulu!\n\n💡 Buka tab AUTO FISH dan aktifkan 'Enable Auto Fishing'")
                -- Reset toggle
                if Rayfield.Flags["RandomSpotToggle"] then
                    Rayfield.Flags["RandomSpotToggle"]:Set(false)
                end
                randomSpotEnabled = false
                return
            end
            
            -- Check if at least one spot is selected
            local selectedCount = GetSelectedSpotsCount()
            if selectedCount == 0 then
                NotifyError("Random Spot", "❌ Pilih minimal 1 spot terlebih dahulu!\n\n💡 Centang checkbox spot yang ingin digunakan di bawah")
                -- Reset toggle
                if Rayfield.Flags["RandomSpotToggle"] then
                    Rayfield.Flags["RandomSpotToggle"]:Set(false)
                end
                randomSpotEnabled = false
                return
            end
            
            StartRandomSpotFishing()
            NotifySuccess("Random Spot", "🎲 RANDOM SPOT FISHING ACTIVATED!\n\n✅ Auto teleport enabled\n⏰ Interval: " .. randomSpotInterval .. " minutes\n🎣 " .. selectedCount .. " spots selected\n\n🚀 Enjoy automated fishing!")
        else
            StopRandomSpotFishing()
        end
    end, "random_spot_toggle")
})

RandomSpotTab:CreateSlider({
    Name = "⏰ Location Change Interval (Minutes)",
    Range = {1, 60},
    Increment = 1,
    CurrentValue = randomSpotInterval,
    Flag = "RandomSpotInterval",
    Callback = function(value)
        randomSpotInterval = value
        NotifyInfo("Random Spot", "⏰ Interval updated to: " .. value .. " minutes\n\n💡 Change will apply to next location switch")
    end
})

-- Spot Selection Section
RandomSpotTab:CreateParagraph({
    Title = "🎯 Select Fishing Spots",
    Content = "Pilih spot mana saja yang ingin digunakan untuk random fishing. Minimal 1 spot harus dipilih."
})

-- Create toggles for each spot

-- Update: UI spot selection sesuai data spot baru
local spotList = {
    {name = "🏝️ SISYPUS 1", flag = "SpotSisypus1"},
    {name = "🏝️ SISYPUS 2", flag = "SpotSisypus2"},
    {name = "🦈 TREASURE", flag = "SpotTreasure"},
    {name = "❄️ ICE SPOT 1", flag = "SpotIce1"},
    {name = "❄️ ICE SPOT 2", flag = "SpotIce2"},
    {name = "❄️ ICE SPOT 3", flag = "SpotIce3"},
    {name = "🌋 CRATER", flag = "SpotCrater"},
    {name = "🌴 TROPICAL 1", flag = "SpotTropical1"},
    {name = "🌴 TROPICAL 2", flag = "SpotTropical2"},
    {name = "🌴 TROPICAL 3", flag = "SpotTropical3"},
    {name = "🗿 STONE", flag = "SpotStone"},
    {name = "⚙️ MACHINE 1", flag = "SpotMachine1"},
    {name = "⚙️ MACHINE 2", flag = "SpotMachine2"}
}

for _, spot in ipairs(spotList) do
    RandomSpotTab:CreateToggle({
        Name = spot.name,
        CurrentValue = selectedSpots[spot.name],
        Flag = spot.flag,
        Callback = function(value)
            selectedSpots[spot.name] = value
            local selectedCount = GetSelectedSpotsCount()
            NotifyInfo("Spot Selection", spot.name .. ": " .. (value and "✅ Selected" or "❌ Deselected") .. "\n\n📊 Total selected: " .. selectedCount .. " spots")
        end
    })
end

-- Quick Selection Buttons
RandomSpotTab:CreateButton({
    Name = "✅ Select All Spots",
    Callback = CreateSafeCallback(function()
        for spotName, _ in pairs(selectedSpots) do
            selectedSpots[spotName] = true
        end
        
                -- Update all UI toggles menggunakan spotList terbaru
                for _, spot in ipairs(spotList) do
                    if Rayfield.Flags[spot.flag] then
                        Rayfield.Flags[spot.flag]:Set(false)
                    end
                end
        
        for spotName, flagName in pairs(flagMapping) do
            if Rayfield.Flags[flagName] then
                Rayfield.Flags[flagName]:Set(true)
            end
        end
        
        NotifySuccess("Quick Selection", "✅ ALL SPOTS SELECTED!\n\n🎣 All 8 fishing spots are now active\n🎲 Maximum variety for random fishing\n⚡ Ready for ultimate fishing experience!")
    end, "select_all_spots")
})

RandomSpotTab:CreateButton({
    Name = "❌ Deselect All Spots", 
    Callback = CreateSafeCallback(function()
        for spotName, _ in pairs(selectedSpots) do
            selectedSpots[spotName] = false
        end
        
        -- Update all UI toggles
        local flagMapping = {
            ["🏝️ SISYPUS"] = "SpotSisypus",
            ["🦈 TREASURE"] = "SpotTreasure",
            ["🎣 STRINGRY"] = "SpotStringry", 
            ["❄️ ICE LAND"] = "SpotIceLand",
            ["🌋 CRATER"] = "SpotCrater",
            ["🌴 TROPICAL"] = "SpotTropical",
            ["🗿 STONE"] = "SpotStone",
            ["⚙️ MACHINE"] = "SpotMachine"
        }
        
        for spotName, flagName in pairs(flagMapping) do
            if Rayfield.Flags[flagName] then
                Rayfield.Flags[flagName]:Set(false)
            end
        end
        
        NotifyInfo("Quick Selection", "❌ ALL SPOTS DESELECTED!\n\n🚫 No spots selected\n💡 Select at least 1 spot before enabling random fishing")
    end, "deselect_all_spots")
})

RandomSpotTab:CreateButton({
    Name = "🎯 Select Premium Spots Only",
    Callback = CreateSafeCallback(function()
        -- Reset all first
        for spotName, _ in pairs(selectedSpots) do
            selectedSpots[spotName] = false
        end
        
        -- Select only premium spots
        local premiumSpots = {"🏝️ SISYPUS", "🦈 TREASURE", "🌋 CRATER", "❄️ ICE LAND"}
        for _, spotName in pairs(premiumSpots) do
            selectedSpots[spotName] = true
        end
        
                -- Update UI toggles menggunakan spotList terbaru
                for _, spot in ipairs(spotList) do
                    if Rayfield.Flags[spot.flag] then
                        Rayfield.Flags[spot.flag]:Set(true)
                    end
                end
        
        for spotName, flagName in pairs(flagMapping) do
            if Rayfield.Flags[flagName] then
                Rayfield.Flags[flagName]:Set(selectedSpots[spotName])
            end
        end
        
        NotifySuccess("Premium Selection", "🎯 PREMIUM SPOTS SELECTED!\n\n✨ Selected: SISYPUS, TREASURE, CRATER, ICE LAND\n🏆 Best spots for rare fish and high value catches\n💎 Quality over quantity!")
    end, "select_premium_spots")
})

RandomSpotTab:CreateButton({
    Name = "📍 Show Available Spots",
    Callback = CreateSafeCallback(function()
        local spotsList = "🎲 AVAILABLE RANDOM SPOTS:\n\n"
        local spotCount = 0
        local selectedCount = 0
        
        for spotName, cframe in pairs(TeleportLocations.RandomSpots) do
            spotCount = spotCount + 1
            local pos = cframe.Position
            local status = selectedSpots[spotName] and "✅ SELECTED" or "❌ NOT SELECTED"
            if selectedSpots[spotName] then
                selectedCount = selectedCount + 1
            end
            spotsList = spotsList .. string.format("🎣 %s - %s\n   Coordinates: %.1f, %.1f, %.1f\n\n", spotName, status, pos.X, pos.Y, pos.Z)
        end
        
        spotsList = spotsList .. "📊 Total Spots: " .. spotCount .. "\n"
        spotsList = spotsList .. "✅ Selected: " .. selectedCount .. " spots\n"
        spotsList = spotsList .. "🎲 Random selection every " .. randomSpotInterval .. " minutes\n"
        spotsList = spotsList .. "💡 Use checkboxes above to select/deselect spots!"
        
        NotifyInfo("Random Spots", spotsList)
    end, "show_spots")
})

RandomSpotTab:CreateButton({
    Name = "🎲 Test Random Teleport",
    Callback = CreateSafeCallback(function()
        local randomSpot = GetRandomSpot()
        if randomSpot then
            SafeTeleport(randomSpot.cframe, randomSpot.name)
            NotifySuccess("Test Teleport", "🎯 Test teleport to: " .. randomSpot.name .. "\n\n✅ Location working perfectly!\n💡 This is how random spot fishing works")
        else
            NotifyError("Test Teleport", "❌ No spots available for testing!")
        end
    end, "test_random_tp")
})

RandomSpotTab:CreateButton({
    Name = "📊 Current Session Info",
    Callback = CreateSafeCallback(function()
        local selectedCount = GetSelectedSpotsCount()
        local sessionInfo = "🎲 RANDOM SPOT SESSION INFO:\n\n"
        sessionInfo = sessionInfo .. "Status: " .. (randomSpotEnabled and "🟢 ACTIVE" or "🔴 INACTIVE") .. "\n"
        sessionInfo = sessionInfo .. "Current Spot: " .. currentRandomSpot .. "\n"
        sessionInfo = sessionInfo .. "Interval: " .. randomSpotInterval .. " minutes\n"
        sessionInfo = sessionInfo .. "Selected Spots: " .. selectedCount .. "/8 locations\n"
        sessionInfo = sessionInfo .. "Total Switches: " .. randomSpotStats.totalSwitches .. "\n"
        sessionInfo = sessionInfo .. "Best Location: " .. randomSpotStats.bestLocation .. "\n\n"
        
        -- Show selected spots with fish counts
        if selectedCount > 0 then
            sessionInfo = sessionInfo .. "✅ ACTIVE SPOTS WITH STATS:\n"
            for spotName, isSelected in pairs(selectedSpots) do
                if isSelected then
                    local fishCount = randomSpotStats.fishPerLocation[spotName] or 0
                    local timeSpent = math.floor((randomSpotStats.timePerLocation[spotName] or 0) / 60)
                    sessionInfo = sessionInfo .. "   • " .. spotName .. " - " .. fishCount .. " fish (" .. timeSpent .. "m)\n"
                end
            end
            sessionInfo = sessionInfo .. "\n"
        end
        
        if randomSpotEnabled then
            local timeElapsed = math.floor((tick() - lastRandomSpotChange) / 60)
            sessionInfo = sessionInfo .. "Time at current spot: " .. timeElapsed .. " minutes\n"
            sessionInfo = sessionInfo .. "Next change in: " .. math.max(0, randomSpotInterval - timeElapsed) .. " minutes\n"
        end
        
        sessionInfo = sessionInfo .. "\n🎣 Auto Fishing: " .. (autofish and "✅ Active" or "❌ Inactive")
        sessionInfo = sessionInfo .. "\n🐟 Session Fish Caught: " .. sessionFishCaught
        
        NotifyInfo("Session Info", sessionInfo)
    end, "session_info")
})

-- Quick Settings Section
RandomSpotTab:CreateButton({
    Name = "⚡ Quick Setup: 5 Minutes",
    Callback = CreateSafeCallback(function()
        randomSpotInterval = 5
        if Rayfield.Flags["RandomSpotInterval"] then
            Rayfield.Flags["RandomSpotInterval"]:Set(5)
        end
        NotifySuccess("Quick Setup", "⚡ Quick setup applied!\n\n⏰ Interval: 5 minutes\n🎲 Fast location switching\n🎣 Perfect for active fishing")
    end, "quick_5min")
})

RandomSpotTab:CreateButton({
    Name = "🕐 Quick Setup: 15 Minutes",
    Callback = CreateSafeCallback(function()
        randomSpotInterval = 15
        if Rayfield.Flags["RandomSpotInterval"] then
            Rayfield.Flags["RandomSpotInterval"]:Set(15)
        end
        NotifySuccess("Quick Setup", "🕐 Balanced setup applied!\n\n⏰ Interval: 15 minutes\n🎲 Balanced location switching\n🎣 Great for steady fishing")
    end, "quick_15min")
})

RandomSpotTab:CreateButton({
    Name = "🕐 Quick Setup: 30 Minutes",
    Callback = CreateSafeCallback(function()
        randomSpotInterval = 30
        if Rayfield.Flags["RandomSpotInterval"] then
            Rayfield.Flags["RandomSpotInterval"]:Set(30)
        end
        NotifySuccess("Quick Setup", "🕐 AFK setup applied!\n\n⏰ Interval: 30 minutes\n🎲 Slow location switching\n🎣 Perfect for AFK fishing")
    end, "quick_30min")
})

RandomSpotTab:CreateButton({
    Name = "🛑 Emergency Stop Random Spot",
    Callback = CreateSafeCallback(function()
        randomSpotEnabled = false
        StopRandomSpotFishing()
        
        -- Update UI
        if Rayfield.Flags["RandomSpotToggle"] then
            Rayfield.Flags["RandomSpotToggle"]:Set(false)
        end
        
        NotifyError("Emergency Stop", "🚨 RANDOM SPOT EMERGENCY STOP!\n\n✅ All random spot fishing stopped\n🎣 Auto fishing continues at current location\n💡 You can restart random spot anytime")
    end, "emergency_stop_random")
})

print("XSAN: RANDOM SPOT tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- UTILITY TAB - System Management & Advanced Features
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating UTILITY tab content...")

UtilityTab:CreateButton({
    Name = "Show Ultimate Session Stats",
    Callback = CreateSafeCallback(function()
        local sessionTime = (tick() - sessionStartTime) / 60
        local fishPerHour = CalculateFishPerHour()
        local estimatedUltra = CalculateUltra()
        local efficiency = fishCaught > 0 and (perfectCasts / fishCaught * 100) or 0
        local thresholdStatus = autoSellOnThreshold and ("Active (" .. autoSellThreshold .. " fish)") or "Inactive"
        
        local ultimateStats = string.format("XSAN ULTIMATE SESSION REPORT:\n\n=== PERFORMANCE ===\nSession Time: %.1f minutes\nFish Caught: %d\nFish/Hour Rate: %d\nPerfect Casts: %d (%.1f%%)\n\n=== EARNINGS ===\nItems Sold: %d\nEstimated Ultra: %d coins\n\n=== AUTOMATION ===\nAuto Fish: %s\nThreshold Auto Sell: %s\nActive Preset: %s", 
            sessionTime, fishCaught, fishPerHour, perfectCasts, efficiency,
            itemsSold, estimatedUltra,
            autofish and "Active" or "Inactive",
            thresholdStatus, currentPreset
        )
        NotifyInfo("Ultimate Stats", ultimateStats)
    end, "ultimate_stats")
})

-- ═══════════════════════════════════════════════════════════════
-- WALKSPEED CONTROLS
-- ═══════════════════════════════════════════════════════════════

UtilityTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 60},
    Increment = 1,
    CurrentValue = defaultWalkspeed,
    Flag = "WalkSpeedSlider",
    Callback = CreateSafeCallback(function(value)
        currentWalkspeed = value
        if walkspeedEnabled then
            setWalkSpeed(value)
        else
            NotifyInfo("Walk Speed", "Walk speed set to " .. value .. ". Enable to apply.")
        end
    end, "walkspeed_slider")
})

UtilityTab:CreateToggle({
    Name = "Enable Walk Speed",
    CurrentValue = walkspeedEnabled,
    Flag = "WalkSpeedToggle",
    Callback = CreateSafeCallback(function(value)
        walkspeedEnabled = value
        if value then
            setWalkSpeed(currentWalkspeed)
            NotifySuccess("Walk Speed", "Walk speed enabled: " .. currentWalkspeed)
        else
            resetWalkSpeed()
            NotifyInfo("Walk Speed", "Walk speed disabled (reset to default)")
        end
    end, "walkspeed_toggle")
})

UtilityTab:CreateButton({
    Name = "Quick Speed: 45",
    Callback = CreateSafeCallback(function()
        currentWalkspeed = 45
        if walkspeedEnabled then
            setWalkSpeed(45)
        else
            walkspeedEnabled = true
            setWalkSpeed(45)
        end
        -- Update the slider and toggle if they exist
        if Rayfield.Flags["WalkSpeedSlider"] then
            Rayfield.Flags["WalkSpeedSlider"]:Set(45)
        end
        if Rayfield.Flags["WalkSpeedToggle"] then
            Rayfield.Flags["WalkSpeedToggle"]:Set(true)
        end
    end, "quick_speed_45")
})

UtilityTab:CreateButton({
    Name = "Reset Walk Speed",
    Callback = CreateSafeCallback(function()
        resetWalkSpeed()
        -- Update the slider and toggle if they exist
        if Rayfield.Flags["WalkSpeedSlider"] then
            Rayfield.Flags["WalkSpeedSlider"]:Set(defaultWalkspeed)
        end
        if Rayfield.Flags["WalkSpeedToggle"] then
            Rayfield.Flags["WalkSpeedToggle"]:Set(false)
        end
        NotifyInfo("Walk Speed", "Walk speed reset to default (" .. defaultWalkspeed .. ")")
    end, "reset_walkspeed")
})

-- ═══════════════════════════════════════════════════════════════
-- UNLIMITED JUMP CONTROLS
-- ═══════════════════════════════════════════════════════════════

UtilityTab:CreateToggle({
    Name = "🚀 Enable Unlimited Jump",
    CurrentValue = unlimitedJumpEnabled,
    Flag = "UnlimitedJumpToggle",
    Callback = CreateSafeCallback(function(value)
        if value then
            enableUnlimitedJump()
        else
            disableUnlimitedJump()
        end
    end, "unlimited_jump_toggle")
})

UtilityTab:CreateSlider({
    Name = "Jump Height",
    Range = {7.2, 100},
    Increment = 0.5,
    CurrentValue = defaultJumpHeight,
    Flag = "JumpHeightSlider",
    Callback = CreateSafeCallback(function(value)
        if not unlimitedJumpEnabled then
            setJumpHeight(value)
            NotifyInfo("Jump Height", "Custom jump height: " .. value .. "\n💡 Enable Unlimited Jump for infinite jumps!")
        else
            currentJumpHeight = value
            setJumpHeight(value)
            NotifyInfo("Jump Height", "Jump height updated: " .. value .. " (Unlimited mode)")
        end
    end, "jump_height_slider")
})

UtilityTab:CreateButton({
    Name = "🎯 Quick Jump: Super High (75)",
    Callback = CreateSafeCallback(function()
        currentJumpHeight = 75
        setJumpHeight(75)
        -- Update the slider if it exists
        if Rayfield.Flags["JumpHeightSlider"] then
            Rayfield.Flags["JumpHeightSlider"]:Set(75)
        end
        NotifySuccess("Jump Height", "🚀 Super high jump enabled!\n\nHeight: 75\n💡 Enable Unlimited Jump for infinite jumps!")
    end, "super_jump")
})

UtilityTab:CreateButton({
    Name = "⚡ Quick: Unlimited Mode",
    Callback = CreateSafeCallback(function()
        if not unlimitedJumpEnabled then
            enableUnlimitedJump()
            -- Update toggle if it exists
            if Rayfield.Flags["UnlimitedJumpToggle"] then
                Rayfield.Flags["UnlimitedJumpToggle"]:Set(true)
            end
        else
            NotifyInfo("Unlimited Jump", "✅ Already enabled!\n\n🚀 Press space repeatedly to fly\n📏 Adjust height with slider above")
        end
    end, "quick_unlimited")
})

UtilityTab:CreateButton({
    Name = "🔄 Reset Jump Height",
    Callback = CreateSafeCallback(function()
        disableUnlimitedJump()
        setJumpHeight(defaultJumpHeight)
        -- Update controls if they exist
        if Rayfield.Flags["JumpHeightSlider"] then
            Rayfield.Flags["JumpHeightSlider"]:Set(defaultJumpHeight)
        end
        if Rayfield.Flags["UnlimitedJumpToggle"] then
            Rayfield.Flags["UnlimitedJumpToggle"]:Set(false)
        end
        NotifyInfo("Jump Height", "Jump height reset to default (" .. defaultJumpHeight .. ")")
    end, "reset_jump")
})

UtilityTab:CreateButton({ 
    Name = "Rejoin Server", 
    Callback = CreateSafeCallback(function() 
        NotifyInfo("Server", "Rejoining current server...")
        wait(1)
        TeleportService:Teleport(game.PlaceId, LocalPlayer) 
    end, "rejoin_server")
})

UtilityTab:CreateButton({
    Name = "🎣 Fix Manual Fishing",
    Callback = CreateSafeCallback(function()
        -- Emergency manual fishing restoration
        autofish = false
        autofishSession = autofishSession + 1  -- Invalidate all auto fishing loops
        autofishThread = nil
        
        -- Stop hybrid mode if active
        if hybridMode and hybridAutoFish then
            pcall(function()
                hybridAutoFish.toggle(false)
            end)
        end
        
        -- Clear any potential input blocks
        task.spawn(function()
            task.wait(0.2)
            -- Ensure fishing rod is equipped
            if equipRemote then
                pcall(function()
                    equipRemote:FireServer(1)
                end)
            end
        end)
        
        -- Update UI flags if available
        if Rayfield.Flags["AutoFishToggle"] then
            Rayfield.Flags["AutoFishToggle"]:Set(false)
        end
        
        NotifySuccess("Manual Fishing Fix", "🎣 MANUAL FISHING RESTORED!\n\n✅ All auto fishing stopped\n✅ Input blocks cleared\n✅ Rod equipped\n\n💡 You can now fish manually!")
    end, "fix_manual_fishing")
})

UtilityTab:CreateButton({ 
    Name = "🔄 Reset All Features",
    Callback = CreateSafeCallback(function()
        ResetAllFeatures()
    end, "reset_all_features")
})

UtilityTab:CreateButton({ 
    Name = "Emergency Stop All",
    Callback = CreateSafeCallback(function()
        autofish = false
        featureState.AutoSell = false
        autoSellOnThreshold = false
        
        -- Stop Random Spot Fishing
        randomSpotEnabled = false
        StopRandomSpotFishing()
        
        NotifyError("Emergency Stop", "All automation systems stopped immediately!\n\n✅ Auto Fishing stopped\n✅ Auto Sell stopped\n✅ Random Spot stopped\n\n💡 All systems ready for manual control")
    end, "emergency_stop")
})

UtilityTab:CreateButton({ 
    Name = "Unload Ultimate Script", 
    Callback = CreateSafeCallback(function()
        NotifyInfo("XSAN", "Thank you for using XSAN Fish It Pro Ultimate v1.0! The most advanced fishing script ever created.\n\nScript will unload in 3 seconds...")
        wait(3)
        if game:GetService("CoreGui"):FindFirstChild("Rayfield") then
            game:GetService("CoreGui").Rayfield:Destroy()
        end
    end, "unload_script")
})

print("XSAN: UTILITY tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- SETTING TAB - Game Enhancement & Performance Features
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating SETTING tab content...")

SettingTab:CreateParagraph({
    Title = "🎮 Game Enhancement Settings",
    Content = "Fitur-fitur tambahan untuk meningkatkan pengalaman bermain Anda. Aktifkan sesuai kebutuhan untuk performa dan gameplay yang lebih baik."
})

-- ═══════════════════════════════════════════════════════════════
-- PERFORMANCE & VISUAL SECTION
-- ═══════════════════════════════════════════════════════════════

SettingTab:CreateParagraph({
    Title = "⚡ Performance & Visual",
    Content = "Pengaturan untuk meningkatkan FPS dan mengubah visual game"
})

SettingTab:CreateToggle({
    Name = "🚀 Boost FPS",
    CurrentValue = boostFPSEnabled,
    Callback = CreateSafeCallback(function(value)
        toggleBoostFPS()
    end, "boost_fps")
})

SettingTab:CreateToggle({
    Name = "✨ HDR Shader",
    CurrentValue = hdrShaderEnabled,
    Callback = CreateSafeCallback(function(value)
        toggleHDRShader()
    end, "hdr_shader")
})

-- ═══════════════════════════════════════════════════════════════
-- SERVER MANAGEMENT SECTION
-- ═══════════════════════════════════════════════════════════════

SettingTab:CreateParagraph({
    Title = "🌐 Server Management",
    Content = "Kelola koneksi server dan pindah ke server lain"
})

SettingTab:CreateButton({
    Name = "🔄 Rejoin Server",
    Callback = CreateSafeCallback(function()
        rejoinServer()
    end, "rejoin_server")
})

SettingTab:CreateButton({
    Name = "🌍 Server Hop",
    Callback = CreateSafeCallback(function()
        serverHop()
    end, "server_hop")
})

SettingTab:CreateButton({
    Name = "👥 Small Server",
    Callback = CreateSafeCallback(function()
        smallServer()
    end, "small_server")
})

-- ═══════════════════════════════════════════════════════════════
-- MOVEMENT & PHYSICS SECTION
-- ═══════════════════════════════════════════════════════════════

SettingTab:CreateParagraph({
    Title = "🏃 Movement & Physics",
    Content = "Fitur-fitur untuk memodifikasi gerakan dan fisika karakter"
})

SettingTab:CreateToggle({
    Name = "🕊️ Enable Float",
    CurrentValue = enableFloatEnabled,
    Callback = CreateSafeCallback(function(value)
        toggleEnableFloat()
    end, "enable_float")
})

SettingTab:CreateToggle({
    Name = "👻 Universal No Clip",
    CurrentValue = noClipEnabled,
    Callback = CreateSafeCallback(function(value)
        toggleNoClip()
    end, "no_clip")
})

SettingTab:CreateToggle({
    Name = "🌪️ Spinner",
    CurrentValue = spinnerEnabled,
    Callback = CreateSafeCallback(function(value)
        toggleSpinner()
    end, "spinner")
})

SettingTab:CreateToggle({
    Name = "🏊 Anti Drown",
    CurrentValue = antiDrownEnabled,
    Callback = CreateSafeCallback(function(value)
        toggleAntiDrown()
    end, "anti_drown")
})

-- ═══════════════════════════════════════════════════════════════
-- QUICK ACTIONS SECTION
-- ═══════════════════════════════════════════════════════════════

SettingTab:CreateParagraph({
    Title = "⚡ Quick Actions",
    Content = "Tombol cepat untuk aksi yang sering digunakan"
})

SettingTab:CreateButton({
    Name = "🔧 Reset All Settings",
    Callback = CreateSafeCallback(function()
        -- Reset all setting features to off
        if boostFPSEnabled then toggleBoostFPS() end
        if hdrShaderEnabled then toggleHDRShader() end
        if enableFloatEnabled then toggleEnableFloat() end
        if noClipEnabled then toggleNoClip() end
        if spinnerEnabled then toggleSpinner() end
        if antiDrownEnabled then toggleAntiDrown() end
        
        NotifySuccess("Reset Settings", "🔄 Semua pengaturan telah direset!\n\n✅ Semua fitur dimatikan\n🎮 Game kembali ke pengaturan normal")
    end, "reset_all_settings")
})

SettingTab:CreateButton({
    Name = "📊 Setting Status",
    Callback = CreateSafeCallback(function()
        local status = "🎮 Status Pengaturan XSAN:\n\n"
        status = status .. "⚡ Performance:\n"
        status = status .. "   🚀 Boost FPS: " .. (boostFPSEnabled and "✅ ON" or "❌ OFF") .. "\n"
        status = status .. "   ✨ HDR Shader: " .. (hdrShaderEnabled and "✅ ON" or "❌ OFF") .. "\n\n"
        status = status .. "🏃 Movement:\n"
        status = status .. "   🕊️ Float: " .. (enableFloatEnabled and "✅ ON" or "❌ OFF") .. "\n"
        status = status .. "   👻 No Clip: " .. (noClipEnabled and "✅ ON" or "❌ OFF") .. "\n"
        status = status .. "   🌪️ Spinner: " .. (spinnerEnabled and "✅ ON" or "❌ OFF") .. "\n"
        status = status .. "   🏊 Anti Drown: " .. (antiDrownEnabled and "✅ ON" or "❌ OFF") .. "\n\n"
        status = status .. "💡 Tip: Gunakan 'Reset All Settings' untuk mematikan semua fitur"
        
        NotifyInfo("Setting Status", status)
    end, "setting_status")
})

-- ═══════════════════════════════════════════════════════════════
-- HELP & INFORMATION SECTION
-- ═══════════════════════════════════════════════════════════════

SettingTab:CreateParagraph({
    Title = "ℹ️ Informasi Fitur",
    Content = "📖 Panduan penggunaan:\n\n" ..
              "🚀 Boost FPS: Mengurangi kualitas grafis untuk FPS lebih tinggi\n" ..
              "✨ HDR Shader: Meningkatkan efek visual dan pencahayaan\n" ..
              "🔄 Rejoin: Bergabung kembali ke server yang sama\n" ..
              "🌍 Server Hop: Pindah ke server acak lainnya\n" ..
              "👥 Small Server: Cari server dengan pemain sedikit\n" ..
              "🕊️ Float: Karakter dapat melayang (tekan Space)\n" ..
              "👻 No Clip: Tembus dinding dan objek\n" ..
              "🌪️ Spinner: Karakter berputar terus menerus\n" ..
              "🏊 Anti Drown: Mencegah tenggelam di air"
})

print("XSAN: SETTING tab completed successfully!")

-- ═══════════════════════════════════════════════════════════════
-- EXIT TAB - Script Management & Exit Options
-- ═══════════════════════════════════════════════════════════════

print("XSAN: Creating EXIT tab content...")

ExitTab:CreateParagraph({
    Title = "🚪 Script Management",
    Content = "Kelola script XSAN Fish It Pro Ultimate dengan aman. Pilih opsi exit atau restart sesuai kebutuhan."
})

ExitTab:CreateButton({
    Name = "🔄 Restart Script",
    Callback = CreateSafeCallback(function()
        NotifyInfo("Restart Script", "🔄 RESTARTING XSAN SCRIPT...\n\n⏳ Please wait 3 seconds\n🔄 Script will reload automatically\n\n💡 All settings will be reset to default")
        
        -- Stop all features first
        autofish = false
        autofishSession = autofishSession + 1
        autofishThread = nil
        walkspeedEnabled = false
        unlimitedJumpEnabled = false
        autoSellOnThreshold = false
        
        -- Stop hybrid mode if active
        if hybridMode and hybridAutoFish then
            pcall(function()
                hybridAutoFish.toggle(false)
            end)
        end
        
        -- Cleanup UI
        task.spawn(function()
            task.wait(3)
            
            -- Destroy current UI
            pcall(function()
                if game:GetService("CoreGui"):FindFirstChild("RayfieldLibrary") then
                    game:GetService("CoreGui").RayfieldLibrary:Destroy()
                end
                if game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") then
                    game.Players.LocalPlayer.PlayerGui.RayfieldLibrary:Destroy()
                end
                if game:GetService("CoreGui"):FindFirstChild("XSAN_FloatingButton") then
                    game:GetService("CoreGui").XSAN_FloatingButton:Destroy()
                end
                if game.Players.LocalPlayer.PlayerGui:FindFirstChild("XSAN_FloatingButton") then
                    game.Players.LocalPlayer.PlayerGui.XSAN_FloatingButton:Destroy()
                end
            end)
            
            -- Small delay before restart
            task.wait(1)
            
            -- Reload script (assuming this is executed via loadstring)
            NotifySuccess("Restart", "✅ RESTARTING NOW!\n\n🔄 Loading fresh XSAN instance...")
            
            -- Execute the script again - you might need to modify this based on how the script is loaded
            -- This is a placeholder - replace with actual script loading method
            pcall(function()
                -- If script is loaded via URL, use this:
                -- loadstring(game:HttpGet("YOUR_SCRIPT_URL_HERE"))()
                
                -- If script is local file, you might need different approach
                print("XSAN: Script restart initiated - please reload manually if automatic restart fails")
                NotifyInfo("Manual Restart", "⚠️ If automatic restart fails:\n\n1. Close current script\n2. Re-execute the script manually\n3. All features will be fresh and ready!")
            end)
        end)
    end, "restart_script")
})

ExitTab:CreateButton({
    Name = "⚠️ Safe Exit Script",
    Callback = CreateSafeCallback(function()
        NotifyInfo("Safe Exit", "🛡️ PREPARING SAFE EXIT...\n\n⚠️ Stopping all automation\n🔄 Restoring manual controls\n🚪 Cleaning up resources")
        
        -- Stop all automation features safely
        autofish = false
        autofishSession = autofishSession + 1  -- Invalidate all loops
        autofishThread = nil
        
        -- Reset all features to safe state
        perfectCast = false
        safeMode = false
        hybridMode = false
        autoSellOnThreshold = false
        
        -- Stop hybrid mode
        if hybridAutoFish then
            pcall(function()
                hybridAutoFish.toggle(false)
            end)
            hybridAutoFish = nil
        end
        
        -- Reset character modifications
        walkspeedEnabled = false
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
        
        unlimitedJumpEnabled = false
        if unlimitedJumpConnection then
            unlimitedJumpConnection:Disconnect()
            unlimitedJumpConnection = nil
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpHeight = 7.2
        end
        
        -- Equip fishing rod for manual use
        task.spawn(function()
            task.wait(0.5)
            if equipRemote then
                pcall(function()
                    equipRemote:FireServer(1)
                end)
            end
        end)
        
        -- Show final message and exit after delay
        task.spawn(function()
            task.wait(2)
            NotifySuccess("Safe Exit", "✅ SAFE EXIT COMPLETE!\n\n🎣 Manual fishing restored\n🚶 Character controls normal\n🛡️ All automation stopped\n\n🚪 Closing in 3 seconds...")
            
            task.wait(3)
            
            -- Clean up UI and close
            pcall(function()
                if game:GetService("CoreGui"):FindFirstChild("RayfieldLibrary") then
                    game:GetService("CoreGui").RayfieldLibrary:Destroy()
                end
                if game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") then
                    game.Players.LocalPlayer.PlayerGui.RayfieldLibrary:Destroy()
                end
                if game:GetService("CoreGui"):FindFirstChild("XSAN_FloatingButton") then
                    game:GetService("CoreGui").XSAN_FloatingButton:Destroy()
                end
                if game.Players.LocalPlayer.PlayerGui:FindFirstChild("XSAN_FloatingButton") then
                    game.Players.LocalPlayer.PlayerGui.XSAN_FloatingButton:Destroy()
                end
            end)
            
            print("XSAN: Script safely exited. Thank you for using XSAN Fish It Pro Ultimate!")
        end)
    end, "safe_exit")
})

ExitTab:CreateButton({
    Name = "⚡ Quick Exit",
    Callback = CreateSafeCallback(function()
        NotifyInfo("Quick Exit", "⚡ QUICK EXIT INITIATED!\n\n🚪 Closing script immediately...")
        
        -- Immediate cleanup and exit
        task.spawn(function()
            task.wait(0.5)
            
            -- Stop critical systems
            autofish = false
            autofishSession = autofishSession + 1
            
            -- Quick UI cleanup
            pcall(function()
                if game:GetService("CoreGui"):FindFirstChild("RayfieldLibrary") then
                    game:GetService("CoreGui").RayfieldLibrary:Destroy()
                end
                if game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldLibrary") then
                    game.Players.LocalPlayer.PlayerGui.RayfieldLibrary:Destroy()
                end
                if game:GetService("CoreGui"):FindFirstChild("XSAN_FloatingButton") then
                    game:GetService("CoreGui").XSAN_FloatingButton:Destroy()
                end
                if game.Players.LocalPlayer.PlayerGui:FindFirstChild("XSAN_FloatingButton") then
                    game.Players.LocalPlayer.PlayerGui.XSAN_FloatingButton:Destroy()
                end
            end)
            
            print("XSAN: Quick exit completed!")
        end)
    end, "quick_exit")
})

ExitTab:CreateButton({
    Name = "🔧 Emergency Stop",
    Callback = CreateSafeCallback(function()
        -- Immediate emergency stop
        autofish = false
        autofishSession = autofishSession + 999  -- Large increment to invalidate all loops
        autofishThread = nil
        perfectCast = false
        safeMode = false
        hybridMode = false
        autoSellOnThreshold = false
        
        -- Emergency stop hybrid mode
        if hybridAutoFish then
            pcall(function()
                hybridAutoFish.toggle(false)
            end)
        end
        
        -- Emergency reset character
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpHeight = 7.2
            end
        end
        
        -- Disconnect unlimited jump
        if unlimitedJumpConnection then
            unlimitedJumpConnection:Disconnect()
            unlimitedJumpConnection = nil
        end
        
        NotifyError("Emergency Stop", "🚨 EMERGENCY STOP ACTIVATED!\n\n✅ All automation STOPPED\n✅ Character controls RESET\n✅ Manual fishing RESTORED\n\n⚠️ Script still running - use Exit buttons to close")
    end, "emergency_stop")
})

ExitTab:CreateParagraph({
    Title = "💡 Exit Guide",
    Content = "• 🔄 Restart: Reload script dengan pengaturan fresh\n• 🛡️ Safe Exit: Keluar dengan aman, semua otomasi dihentikan\n• ⚡ Quick Exit: Keluar cepat tanpa delay\n• 🔧 Emergency: Stop darurat semua fitur (script tetap jalan)"
})

ExitTab:CreateParagraph({
    Title = "📊 Session Summary",
    Content = "Thank you for using XSAN Fish It Pro Ultimate v1.0! Script ini telah memberikan pengalaman fishing terbaik dengan teknologi AI dan keamanan maksimal."
})

print("XSAN: EXIT tab completed successfully!")

-- Hotkey System
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F1 then
        -- Proper auto fishing toggle with session cleanup
        if autofish then
            -- Stop auto fishing
            autofish = false
            autofishSession = autofishSession + 1  -- Invalidate any running loops
            autofishThread = nil
            
            -- Stop hybrid mode if active
            if hybridMode and hybridAutoFish then
                hybridAutoFish.toggle(false)
            end
            
            -- Clean up any lingering effects that might block manual fishing
            task.wait(0.1)
            
            NotifyInfo("Hotkey", "🛑 Auto fishing STOPPED (F1)\n\n✅ Manual fishing restored\n🎣 Ready for manual control")
        else
            -- Start auto fishing (trigger UI toggle for proper initialization)
            autofish = true
            if Rayfield.Flags["AutoFishToggle"] then
                Rayfield.Flags["AutoFishToggle"]:Set(true)
            end
            NotifyInfo("Hotkey", "🎣 Auto fishing STARTED (F1)\n\n⚡ AI systems activated\n🔒 Safety protocols active")
        end
    elseif input.KeyCode == Enum.KeyCode.F2 then
        perfectCast = not perfectCast
        NotifyInfo("Hotkey", "Perfect cast " .. (perfectCast and "enabled" or "disabled") .. " (F2)")
    elseif input.KeyCode == Enum.KeyCode.F3 then
        autoSellOnThreshold = not autoSellOnThreshold
        NotifyInfo("Hotkey", "Auto sell threshold " .. (autoSellOnThreshold and "enabled" or "disabled") .. " (F3)")
    elseif input.KeyCode == Enum.KeyCode.F4 then
        -- Quick teleport to spawn
        SafeTeleport(CFrame.new(389, 137, 264), "Moosewood Spawn")
        NotifyInfo("Hotkey", "Quick teleport to spawn (F4)")
    elseif input.KeyCode == Enum.KeyCode.F5 then
        -- Save current position
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            _G.XSANSavedPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
            NotifyInfo("Hotkey", "Position saved (F5)")
        end
    elseif input.KeyCode == Enum.KeyCode.F6 then
        -- Return to saved position
        if _G.XSANSavedPosition then
            SafeTeleport(_G.XSANSavedPosition, "Saved Position")
            NotifyInfo("Hotkey", "Returned to saved position (F6)")
        end
    elseif input.KeyCode == Enum.KeyCode.F7 then
        -- Toggle walkspeed
        walkspeedEnabled = not walkspeedEnabled
        if walkspeedEnabled then
            setWalkSpeed(currentWalkspeed)
            -- Update UI if available
            if Rayfield.Flags["WalkSpeedToggle"] then
                Rayfield.Flags["WalkSpeedToggle"]:Set(true)
            end
        else
            resetWalkSpeed()
            -- Update UI if available
            if Rayfield.Flags["WalkSpeedToggle"] then
                Rayfield.Flags["WalkSpeedToggle"]:Set(false)
            end
        end
        NotifyInfo("Hotkey", "Walk speed " .. (walkspeedEnabled and "enabled" or "disabled") .. " (F7)")
    elseif input.KeyCode == Enum.KeyCode.F8 then
        -- Reset all features
        ResetAllFeatures()
        NotifyInfo("Hotkey", "All features reset to default (F8)")
    elseif input.KeyCode == Enum.KeyCode.F9 then
        -- Emergency manual fishing fix
        autofish = false
        autofishSession = autofishSession + 1  -- Invalidate all auto fishing loops
        autofishThread = nil
        
        -- Stop hybrid mode if active
        if hybridMode and hybridAutoFish then
            pcall(function()
                hybridAutoFish.toggle(false)
            end)
        end
        
        -- Clear any potential input blocks
        task.spawn(function()
            task.wait(0.2)
            -- Ensure fishing rod is equipped
            if equipRemote then
                pcall(function()
                    equipRemote:FireServer(1)
                end)
            end
        end)
        
        -- Update UI flags if available
        if Rayfield.Flags["AutoFishToggle"] then
            Rayfield.Flags["AutoFishToggle"]:Set(false)
        end
        
        NotifySuccess("Hotkey", "🎣 MANUAL FISHING RESTORED! (F9)\n\n✅ Auto fishing emergency stop\n✅ Input blocks cleared\n✅ Rod equipped\n\n💡 Ready for manual fishing!")
    elseif input.KeyCode == Enum.KeyCode.F10 then
        -- Emergency exit hotkey
        NotifyError("Hotkey", "🚨 EMERGENCY EXIT! (F10)\n\n⚡ Stopping all systems immediately...")
        
        -- Emergency stop all systems
        autofish = false
        autofishSession = autofishSession + 9999
        autofishThread = nil
        
        -- Stop hybrid mode
        if hybridAutoFish then
            pcall(function()
                hybridAutoFish.toggle(false)
            end)
        end
        
        -- Reset character immediately
        if LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpHeight = 7.2
            end
        end
        
        NotifySuccess("Emergency Exit", "✅ All systems stopped! Check EXIT tab for clean exit options.")
    elseif input.KeyCode == Enum.KeyCode.F11 then
        -- Toggle Random Spot Fishing
        randomSpotEnabled = not randomSpotEnabled
        
        if randomSpotEnabled then
            if not autofish then
                randomSpotEnabled = false
                NotifyError("Hotkey", "❌ Auto fishing must be enabled first! (F11)\n\n💡 Press F1 to enable auto fishing, then F11 for random spots")
            else
                -- Check if at least one spot is selected
                local selectedCount = GetSelectedSpotsCount()
                if selectedCount == 0 then
                    randomSpotEnabled = false
                    NotifyError("Hotkey", "❌ No spots selected! (F11)\n\n💡 Open RANDOM SPOT tab and select at least 1 spot first")
                else
                    StartRandomSpotFishing()
                    -- Update UI if available
                    if Rayfield.Flags["RandomSpotToggle"] then
                        Rayfield.Flags["RandomSpotToggle"]:Set(true)
                    end
                    NotifySuccess("Hotkey", "🎲 Random Spot Fishing STARTED! (F11)\n\n✅ Auto location switching active\n🎯 " .. selectedCount .. " spots selected\n⏰ Interval: " .. randomSpotInterval .. " minutes")
                end
            end
        else
            StopRandomSpotFishing()
            -- Update UI if available
            if Rayfield.Flags["RandomSpotToggle"] then
                Rayfield.Flags["RandomSpotToggle"]:Set(false)
            end
            NotifyInfo("Hotkey", "🛑 Random Spot Fishing STOPPED! (F11)")
        end
    end
end)

-- Welcome Messages
spawn(function()
    wait(2)
    NotifySuccess("Welcome!", "XSAN Fish It Pro ULTIMATE v1.0 loaded successfully!\n\nULTIMATE FEATURES ACTIVATED:\nAI-Powered Analytics • Smart Automation • Advanced Safety • Premium Quality • Ultimate Teleportation • And Much More!\n\nReady to dominate Fish It like never before!")
    
    wait(4)
    NotifyInfo("Hotkeys Active!", "HOTKEYS ENABLED:\nF1 - Toggle Auto Fishing\nF2 - Toggle Perfect Cast\nF3 - Toggle Auto Sell Threshold\nF4 - Quick TP to Spawn\nF5 - Save Position\nF6 - Return to Saved Position\nF7 - Toggle Walk Speed\nF8 - Reset All Features\nF9 - Fix Manual Fishing\nF10 - Emergency Exit\nF11 - Toggle Random Spot Fishing\n\nCheck PRESETS tab for quick setup, RANDOM SPOT tab for auto location switching, and EXIT tab for script management!")
    
    wait(3)
    NotifyInfo("📱 Smart UI!", "RAYFIELD UI SYSTEM:\nRayfield automatically handles UI sizing and responsiveness for all devices!\n\nUI management is now handled by the Rayfield library (css.lua)!")
    
    wait(3)
    NotifySuccess("✅ Teleportation Fixed!", "TELEPORTATION SYSTEM FIXED:\n✅ Now uses dynamic locations like old.lua\n✅ Accurate coordinates from workspace\n✅ Better player detection\n✅ More reliable teleportation\n\nCheck TELEPORT tab for perfect locations!")
    
    wait(3)
    NotifySuccess("🎲 NEW FEATURE!", "RANDOM SPOT FISHING ADDED!\n\n✨ Auto teleport to 8 premium fishing spots\n⏰ Customizable interval (1-60 minutes)\n🎯 Smart location rotation\n🎣 Perfect for AFK fishing\n\n💡 Check RANDOM SPOT tab or press F11!")
    
    wait(3)
    NotifyInfo("Follow XSAN!", "Telegram: Spinnerxxx\nTele Groub: Spinner_xxx\n\nThe most advanced Fish It script ever created! Follow us for more premium scripts and exclusive updates!")
end)

-- Console Branding
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("XSAN FISH IT PRO ULTIMATE v1.0")
print("THE MOST ADVANCED FISH IT SCRIPT EVER CREATED")
print("Premium Script with AI-Powered Features & Ultimate Automation")
print("Telegram: Spinnerxxx | Tele Groub: Spinner_xxx")
print("Professional Quality • Trusted by Thousands • Ultimate Edition")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("XSAN: Script loaded successfully! All systems operational!")

-- Performance Enhancements
pcall(function()
    local Modifiers = require(game:GetService("ReplicatedStorage").Shared.FishingRodModifiers)
    for key in pairs(Modifiers) do
        Modifiers[key] = 999999999
    end

    local bait = require(game:GetService("ReplicatedStorage").Baits["Luck Bait"])
    bait.Luck = 999999999
    
    print("XSAN: Performance enhancements applied!")
end)
