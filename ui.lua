    --[[
        XSAN Modern UI Suite - Enhanced Fixed Version
        Tab-based interface optimized for mobile landscape
        Based on Rayfield with modern enhancements and fixes
        
        Original: Rayfield Interface Suite by Sirius
        Enhanced by: XSAN for Fish It Pro Ultimate
        
        Features:
        • Mobile landscape optimization
        • Enhanced scrolling fixes
        • Compact interface design
        • Touch-friendly controls
        • Modern tab navigation ready

        shlex  | Designing + Programming
        iRay   | Programming
        Max    | Programming
        Damian | Programming
        XSAN   | Mobile Optimization + Modern Enhancements

    ]]

    if debugX then
        warn('Initialising Rayfield')
    end

    local function getService(name)
        local service = game:GetService(name)
        return cloneref and cloneref(service) or service
    end

    -- Services
    local TweenService = getService("TweenService")
    local UserInputService = getService("UserInputService")
    local GuiService = getService("GuiService")
    local RunService = getService("RunService")
    local Players = getService("Players")
    local CoreGui = getService("CoreGui")

    -- Variables
    local Player = Players.LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")

    -- Typography: keep font sizes uniform across the UI (esp. Auto Fish tab) - OPTIMIZED SMALLER
    local UIStyle = {
        TabButtonTextSize = 11,     -- Left tab items (INFO, PRESETS, AUTO FISH, ...) - reduced from 14
        SectionTitleTextSize = 12,  -- Title inside a section - reduced from 14  
        ContentTextSize = 11        -- Labels/buttons inside content (e.g., Enable Auto Fishing) - reduced from 14
    }

    local function applyTextStyle(obj, size)
        if not obj then return end
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            obj.TextScaled = false
            obj.TextWrapped = true
            obj.TextSize = size
        end
    end

    -- Remove unsupported emoji characters and optionally add a small leading icon
    local function sanitizeLabelAndMaybeAddIcon(button, text, iconId)
        -- Clean leading replacement chars "�" and extra spaces
        local hadBroken = false
        if string.find(text, "�") then
            hadBroken = true
            text = text:gsub("^[%s�]+", "")
        end

        -- Apply cleaned text
        button.Text = text

        -- If an explicit icon is provided or we stripped a broken emoji, add a small circle placeholder icon
        if iconId or hadBroken then
            -- Adjust padding for text so it doesn't overlap the icon
            local pad = button:FindFirstChildOfClass("UIPadding")
            if not pad then
                pad = Instance.new("UIPadding")
                pad.Parent = button
            end
            pad.PaddingLeft = UDim.new(0, 28)

            -- Create a simple circular indicator as default
            local icon
            if iconId then
                local img = Instance.new("ImageLabel")
                img.Name = "Icon"
                img.BackgroundTransparency = 1
                img.Size = UDim2.new(0, 16, 0, 16)
                img.Position = UDim2.new(0, 8, 0.5, -8)
                img.Image = iconId
                img.Parent = button
                icon = img
            else
                local dot = Instance.new("Frame")
                dot.Name = "IconDot"
                dot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                dot.Size = UDim2.new(0, 8, 0, 8)
                dot.Position = UDim2.new(0, 12, 0.5, -4)
                local corner = Instance.new("UICorner")
                corner.CornerRadius = UDim.new(1, 0)
                corner.Parent = dot
                dot.Parent = button
                icon = dot
            end
            icon.ZIndex = button.ZIndex + 1
        end
    end

    -- Create main ScreenGui
    local RayfieldLibrary = Instance.new("ScreenGui")
    RayfieldLibrary.Name = "RayfieldLibrary"
    RayfieldLibrary.ResetOnSpawn = false
    RayfieldLibrary.IgnoreGuiInset = true
    RayfieldLibrary.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Try to parent to CoreGui first, then fallback to PlayerGui
    local success = pcall(function()
        RayfieldLibrary.Parent = CoreGui
    end)

    if not success then
        RayfieldLibrary.Parent = PlayerGui
    end

    -- Rayfield Object
    local Rayfield = {}

    -- Functions
    function Rayfield:CreateWindow(Settings)
        local WindowSettings = {
            Name = Settings.Name or "Rayfield Interface Suite",
            LoadingTitle = Settings.LoadingTitle or "Rayfield Interface Suite",
            LoadingSubtitle = Settings.LoadingSubtitle or "by Sirius",
            ConfigurationSaving = {
                Enabled = Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled or false,
                FolderName = Settings.ConfigurationSaving and Settings.ConfigurationSaving.FolderName or "Rayfield",
                FileName = Settings.ConfigurationSaving and Settings.ConfigurationSaving.FileName or "Big Hub"
            },
            Discord = {
                Enabled = Settings.Discord and Settings.Discord.Enabled or false,
                Invite = Settings.Discord and Settings.Discord.Invite or "noinvitelink",
                RememberJoins = Settings.Discord and Settings.Discord.RememberJoins or true
            },
            KeySystem = Settings.KeySystem or false,
            KeySettings = {
                Title = Settings.KeySettings and Settings.KeySettings.Title or "Rayfield",
                Subtitle = Settings.KeySettings and Settings.KeySettings.Subtitle or "Key System",
                Note = Settings.KeySettings and Settings.KeySettings.Note or "No method of obtaining the key is provided",
                FileName = Settings.KeySettings and Settings.KeySettings.FileName or "Key",
                SaveKey = Settings.KeySettings and Settings.KeySettings.SaveKey or false,
                GrabKeyFromSite = Settings.KeySettings and Settings.KeySettings.GrabKeyFromSite or false,
                Key = Settings.KeySettings and Settings.KeySettings.Key or {"Hello"}
            }
        }

        -- Create Main Frame - REDUCED SIZE
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10) -- Lebih gelap
    Main.BackgroundTransparency = 0.15 -- Sedikit transparan
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, -280, 0.5, -180)
    Main.Size = UDim2.new(0, 560, 0, 360)
        
        -- Mobile optimization - SMALLER containers
        if UserInputService.TouchEnabled then
            local screenSize = workspace.CurrentCamera.ViewportSize
            local isLandscape = screenSize.X > screenSize.Y
            
            if isLandscape then
                -- Smaller landscape size but still readable
                local width = math.min(screenSize.X * 0.55, 460)  -- Reduced from 0.60, 500
                local height = math.min(screenSize.Y * 0.70, 280) -- Reduced from 0.75, 300
                Main.Size = UDim2.new(0, width, 0, height)
                Main.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
            else
                -- Smaller portrait size
                local width = math.min(screenSize.X * 0.80, 320)  -- Reduced from 0.85, 350
                local height = math.min(screenSize.Y * 0.65, 380) -- Reduced from 0.70, 420
                Main.Size = UDim2.new(0, width, 0, height)
                Main.Position = UDim2.new(0.5, -width/2, 0.5, -height/2)
            end
        end
        
        Main.Parent = RayfieldLibrary

        -- Add UICorner
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 10)
        UICorner.Parent = Main

        -- Add UIStroke (garis border utama)
        local UIStroke = Instance.new("UIStroke")
        UIStroke.Color = Color3.fromRGB(40, 40, 80) -- Biru gelap
        UIStroke.Thickness = 2
        UIStroke.Transparency = 0.2
        UIStroke.Parent = Main

        -- Hover effect biru pada Main
        Main.MouseEnter:Connect(function()
            UIStroke.Color = Color3.fromRGB(0, 120, 255)
            UIStroke.Thickness = 3
        end)
        Main.MouseLeave:Connect(function()
            UIStroke.Color = Color3.fromRGB(40, 40, 80)
            UIStroke.Thickness = 2
        end)

        -- Create Topbar - FURTHER REDUCED
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.BackgroundColor3 = Color3.fromRGB(15, 15, 15) -- Lebih gelap
    Topbar.BackgroundTransparency = 0.18
    Topbar.BorderSizePixel = 0
    Topbar.Position = UDim2.new(0, 0, 0, 0)
    Topbar.Size = UDim2.new(1, 0, 0, 22)
    Topbar.Parent = Main

        -- Add UICorner to Topbar
        local TopbarCorner = Instance.new("UICorner")
        TopbarCorner.CornerRadius = UDim.new(0, 10)
        TopbarCorner.Parent = Topbar

        -- Create Title
        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.BackgroundTransparency = 1
        Title.Position = UDim2.new(0, 15, 0, 0)
        Title.Size = UDim2.new(1, -80, 1, 0)  -- Reduced size to make space for buttons
        Title.Font = Enum.Font.SourceSans  -- Changed from SourceSansBold for smaller appearance
        Title.Text = WindowSettings.Name
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.TextScaled = false  -- Disable scaling for consistent size
        Title.TextSize = 13       -- Fixed smaller size instead of scaling
        Title.TextWrapped = true
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Topbar

        -- Create Floating Button (minimize to floating mode)
        local FloatingButton = Instance.new("TextButton")
        FloatingButton.Name = "FloatingButton"
        FloatingButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        FloatingButton.BorderSizePixel = 0
        FloatingButton.Position = UDim2.new(1, -65, 0, 2)
        FloatingButton.Size = UDim2.new(0, 20, 0, 21)
        FloatingButton.Font = Enum.Font.SourceSansBold
        FloatingButton.Text = "−"  -- Using proper minus symbol for minimize
        FloatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        FloatingButton.TextScaled = true
        FloatingButton.Parent = Topbar

        -- Add UICorner to FloatingButton
        local FloatingButtonCorner = Instance.new("UICorner")
        FloatingButtonCorner.CornerRadius = UDim.new(0, 3)
        FloatingButtonCorner.Parent = FloatingButton

        -- Create Close Button
        local CloseButton = Instance.new("TextButton")
        CloseButton.Name = "CloseButton"
        CloseButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
        CloseButton.BorderSizePixel = 0
        CloseButton.Position = UDim2.new(1, -40, 0, 2)
        CloseButton.Size = UDim2.new(0, 20, 0, 21)
        CloseButton.Font = Enum.Font.SourceSansBold
        CloseButton.Text = "X"
        CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseButton.TextScaled = true
        CloseButton.Parent = Topbar

        -- Add UICorner to CloseButton
        local CloseButtonCorner = Instance.new("UICorner")
        CloseButtonCorner.CornerRadius = UDim.new(0, 3)
        CloseButtonCorner.Parent = CloseButton

        -- Button hover effects
        FloatingButton.MouseEnter:Connect(function()
            TweenService:Create(FloatingButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 120, 120)}):Play()
        end)

        FloatingButton.MouseLeave:Connect(function()
            TweenService:Create(FloatingButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
        end)

        CloseButton.MouseEnter:Connect(function()
            TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 120, 120)}):Play()
        end)

        CloseButton.MouseLeave:Connect(function()
            TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 100, 100)}):Play()
        end)

        -- Button functionality
        local isFloatingMode = false
        
        -- Clean up any existing floating buttons from previous sessions
        local existingFloatingGUI = Player.PlayerGui:FindFirstChild("XSAN_FloatingButton") or game.CoreGui:FindFirstChild("XSAN_FloatingButton")
        if existingFloatingGUI then
            existingFloatingGUI:Destroy()
        end
        
        -- Floating Button Click - Minimize to floating mode
        FloatingButton.MouseButton1Click:Connect(function()
            -- Always minimize when clicked
            isFloatingMode = true
            Main.Visible = false
            
            -- Remove existing floating button if any
            local existingFloatingGUI = Player.PlayerGui:FindFirstChild("XSAN_FloatingButton") or game.CoreGui:FindFirstChild("XSAN_FloatingButton")
            if existingFloatingGUI then
                existingFloatingGUI:Destroy()
            end
            
            -- Create new floating button
            local FloatingButtonGui = Instance.new("ScreenGui")
            FloatingButtonGui.Name = "XSAN_FloatingButton"
            FloatingButtonGui.ResetOnSpawn = false
            FloatingButtonGui.IgnoreGuiInset = true
            
            -- Try to parent to CoreGui first, then fallback to PlayerGui
            local success = pcall(function()
                FloatingButtonGui.Parent = game.CoreGui
            end)
            if not success then
                FloatingButtonGui.Parent = Player.PlayerGui
            end
            
            local FloatingBtn = Instance.new("TextButton")
            FloatingBtn.Size = UDim2.new(0, 50, 0, 50)
            FloatingBtn.Position = UDim2.new(0, 15, 0.5, -25)
            FloatingBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
            FloatingBtn.Text = "XSAN"
            FloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            FloatingBtn.TextScaled = true
            FloatingBtn.Font = Enum.Font.SourceSansBold
            FloatingBtn.BorderSizePixel = 0
            FloatingBtn.Parent = FloatingButtonGui
            
            local Corner = Instance.new("UICorner")
            Corner.CornerRadius = UDim.new(0, 25)
            Corner.Parent = FloatingBtn
            
            -- Make floating button draggable
            local dragging = false
            local dragInput, dragStart, startPos
            
            FloatingBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    dragStart = input.Position
                    startPos = FloatingBtn.Position
                    
                    input.Changed:Connect(function()
                        if input.UserInputState == Enum.UserInputState.End then
                            dragging = false
                        end
                    end)
                end
            end)
            
            FloatingBtn.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    dragInput = input
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if input == dragInput and dragging then
                    local delta = input.Position - dragStart
                    FloatingBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)
            
            -- Click to restore main UI
            FloatingBtn.MouseButton1Click:Connect(function()
                -- Destroy floating button
                FloatingButtonGui:Destroy()
                -- Show main UI
                Main.Visible = true
                -- Reset floating mode state
                isFloatingMode = false
            end)
        end)
        
        -- Close Button Click - Close script completely
        CloseButton.MouseButton1Click:Connect(function()
            -- Show confirmation dialog first
            local ConfirmFrame = Instance.new("Frame")
            ConfirmFrame.Name = "ConfirmDialog"
            ConfirmFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ConfirmFrame.BorderSizePixel = 0
            ConfirmFrame.Position = UDim2.new(0.5, -100, 0.5, -50)
            ConfirmFrame.Size = UDim2.new(0, 200, 0, 100)
            ConfirmFrame.ZIndex = 1000
            ConfirmFrame.Parent = Main
            
            local ConfirmCorner = Instance.new("UICorner")
            ConfirmCorner.CornerRadius = UDim.new(0, 8)
            ConfirmCorner.Parent = ConfirmFrame
            
            local ConfirmTitle = Instance.new("TextLabel")
            ConfirmTitle.BackgroundTransparency = 1
            ConfirmTitle.Position = UDim2.new(0, 0, 0, 5)
            ConfirmTitle.Size = UDim2.new(1, 0, 0, 25)
            ConfirmTitle.Font = Enum.Font.SourceSansBold
            ConfirmTitle.Text = "Close Script?"
            ConfirmTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            ConfirmTitle.TextSize = 14
            ConfirmTitle.Parent = ConfirmFrame
            
            local ConfirmText = Instance.new("TextLabel")
            ConfirmText.BackgroundTransparency = 1
            ConfirmText.Position = UDim2.new(0, 10, 0, 30)
            ConfirmText.Size = UDim2.new(1, -20, 0, 30)
            ConfirmText.Font = Enum.Font.SourceSans
            ConfirmText.Text = "Are you sure you want to close XSAN Script?"
            ConfirmText.TextColor3 = Color3.fromRGB(200, 200, 200)
            ConfirmText.TextSize = 11
            ConfirmText.TextWrapped = true
            ConfirmText.Parent = ConfirmFrame
            
            local YesButton = Instance.new("TextButton")
            YesButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
            YesButton.BorderSizePixel = 0
            YesButton.Position = UDim2.new(0, 10, 1, -30)
            YesButton.Size = UDim2.new(0, 80, 0, 25)
            YesButton.Font = Enum.Font.SourceSansBold
            YesButton.Text = "Yes"
            YesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            YesButton.TextSize = 12
            YesButton.Parent = ConfirmFrame
            
            local YesCorner = Instance.new("UICorner")
            YesCorner.CornerRadius = UDim.new(0, 4)
            YesCorner.Parent = YesButton
            
            local NoButton = Instance.new("TextButton")
            NoButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            NoButton.BorderSizePixel = 0
            NoButton.Position = UDim2.new(1, -90, 1, -30)
            NoButton.Size = UDim2.new(0, 80, 0, 25)
            NoButton.Font = Enum.Font.SourceSansBold
            NoButton.Text = "No"
            NoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            NoButton.TextSize = 12
            NoButton.Parent = ConfirmFrame
            
            local NoCorner = Instance.new("UICorner")
            NoCorner.CornerRadius = UDim.new(0, 4)
            NoCorner.Parent = NoButton
            
            -- Button functionality
            YesButton.MouseButton1Click:Connect(function()
                -- Close script completely
                pcall(function()
                    -- Clean up any global variables
                    if _G.XSANReset then
                        _G.XSANReset()
                    end
                    
                    -- Destroy all XSAN related GUIs
                    local GUIs = {
                        game.CoreGui:FindFirstChild("RayfieldLibrary"),
                        game.CoreGui:FindFirstChild("XSAN_FloatingButton"),
                        Player.PlayerGui:FindFirstChild("RayfieldLibrary"),
                        Player.PlayerGui:FindFirstChild("XSAN_FloatingButton")
                    }
                    
                    for _, gui in pairs(GUIs) do
                        if gui then gui:Destroy() end
                    end
                    
                    -- Send notification
                    game.StarterGui:SetCore("SendNotification", {
                        Title = "XSAN Script";
                        Text = "Script closed successfully!";
                        Duration = 2;
                    })
                end)
            end)
            
            NoButton.MouseButton1Click:Connect(function()
                ConfirmFrame:Destroy()
            end)
        end)

        -- Create Tabs Container - ADJUSTED FOR SMALLER TOPBAR
        local TabContainer = Instance.new("Frame")
        TabContainer.Name = "TabContainer"
        TabContainer.BackgroundTransparency = 1
        TabContainer.Position = UDim2.new(0, 0, 0, 22)   -- Adjusted for smaller topbar (22)
        TabContainer.Size = UDim2.new(0, 120, 1, -22)    -- Reduced width from 130 to 120
        TabContainer.Parent = Main

        -- Create Tab List with scrolling
    local TabList = Instance.new("ScrollingFrame")
    TabList.Name = "TabList"
    TabList.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    TabList.BackgroundTransparency = 0.18
    TabList.BorderSizePixel = 0
    TabList.Position = UDim2.new(0, 0, 0, 0)
    TabList.Size = UDim2.new(1, 0, 1, 0)
    TabList.ScrollBarThickness = 3
    TabList.ScrollBarImageColor3 = Color3.fromRGB(0, 120, 255) -- Scrollbar biru
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabList.ScrollingDirection = Enum.ScrollingDirection.Y
    TabList.Parent = TabContainer

        -- Add UIListLayout to TabList
        local TabListLayout = Instance.new("UIListLayout")
        TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        TabListLayout.Padding = UDim.new(0, 0)  -- No padding for maximum compactness
        TabListLayout.Parent = TabList
        
        -- Mobile touch scrolling for TabList
        if UserInputService.TouchEnabled then
            TabList.ScrollingEnabled = true
            TabList.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
            
            local dragStart = nil
            local startPos = nil
            
            TabList.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    dragStart = input.Position
                    startPos = TabList.CanvasPosition
                end
            end)
            
            TabList.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch and dragStart then
                    local delta = input.Position - dragStart
                    local newY = math.max(0, startPos.Y - delta.Y * 1.5) -- 1.5x scroll speed
                    TabList.CanvasPosition = Vector2.new(0, newY)
                end
            end)
            
            TabList.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch then
                    dragStart = nil
                    startPos = nil
                end
            end)
        end

        -- Create Content Container - ADJUSTED SIZE AND POSITION
        local ContentContainer = Instance.new("Frame")
        ContentContainer.Name = "ContentContainer"
        ContentContainer.BackgroundTransparency = 1
        ContentContainer.Position = UDim2.new(0, 120, 0, 22)  -- Adjusted for smaller tab width (120) and topbar (22)
        ContentContainer.Size = UDim2.new(1, -125, 1, -22)   -- Increased space by reducing offset from -120 to -125
        ContentContainer.Parent = Main

        -- Create Content with scrolling
        local Content = Instance.new("ScrollingFrame")
        Content.Name = "Content"
        Content.BackgroundTransparency = 1
        Content.Position = UDim2.new(0, 0, 0, 0)
        Content.Size = UDim2.new(1, 0, 1, 0)
        Content.ScrollBarThickness = 5  -- Thinner scrollbar
        Content.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
        Content.CanvasSize = UDim2.new(0, 0, 0, 0)
        Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
        Content.ScrollingDirection = Enum.ScrollingDirection.Y
        Content.Parent = ContentContainer

        -- Add UIListLayout to Content - MINIMAL PADDING
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 1)  -- Further reduced from 2 to 1 for maximum compactness
        ContentLayout.Parent = Content

        -- Add UIPadding to Content - IMPROVED PADDING FOR RIGHT SIDE
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingTop = UDim.new(0, 2)     -- Further reduced from 4 to 2
        ContentPadding.PaddingBottom = UDim.new(0, 2)  -- Further reduced from 4 to 2
        ContentPadding.PaddingLeft = UDim.new(0, 8)    -- Increased from 4 to 8 to fix margin kiri terpotong
        ContentPadding.PaddingRight = UDim.new(0, 18)  -- Increased from 12 to 18 to account for scrollbar (5px) + safe margin
        ContentPadding.Parent = Content

        -- Mobile landscape scroll optimization
        if UserInputService.TouchEnabled then
            local function setupMobileScrolling()
                local screenSize = workspace.CurrentCamera.ViewportSize
                local isLandscape = screenSize.X > screenSize.Y
                
                -- Always enable scrolling for mobile
                Content.ScrollingEnabled = true
                Content.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
                
                if isLandscape then
                    -- Enhanced mobile landscape scrolling
                    Content.ScrollBarThickness = 12
                    
                    -- Reduce padding for more content space in landscape
                    ContentPadding.PaddingTop = UDim.new(0, 2)     -- Reduced to 2px
                    ContentPadding.PaddingBottom = UDim.new(0, 2)  -- Reduced to 2px  
                    ContentPadding.PaddingLeft = UDim.new(0, 2)    -- Reduced to 2px
                    ContentPadding.PaddingRight = UDim.new(0, 2)   -- Reduced to 2px
                    
                    -- Custom touch scrolling for better responsiveness
                    local dragStart = nil
                    local startPos = nil
                    
                    Content.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Touch then
                            dragStart = input.Position
                            startPos = Content.CanvasPosition
                        end
                    end)
                    
                    Content.InputChanged:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Touch and dragStart then
                            local delta = input.Position - dragStart
                            local newY = math.max(0, startPos.Y - delta.Y * 2) -- 2x scroll speed
                            Content.CanvasPosition = Vector2.new(0, newY)
                        end
                    end)
                    
                    Content.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Touch then
                            dragStart = nil
                            startPos = nil
                        end
                    end)
                    
                    print("XSAN: Mobile landscape scroll optimization enabled")
                else
                    -- Portrait mode scrolling
                    Content.ScrollBarThickness = 8
                    print("XSAN: Mobile portrait scroll enabled")
                end
            end
            
            setupMobileScrolling()
            
            -- Re-setup when screen orientation changes
            workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(setupMobileScrolling)
            
            -- Force update canvas size for scrolling to work
            spawn(function()
                wait(2) -- Wait for all content to load
                local function updateCanvasSize()
                    local totalHeight = 0
                    for _, child in pairs(Content:GetChildren()) do
                        if child:IsA("GuiObject") and child.Visible and child ~= ContentLayout and child ~= ContentPadding then
                            totalHeight = totalHeight + child.AbsoluteSize.Y + ContentLayout.Padding.Offset
                        end
                    end
                    -- Add extra space to ensure scrolling works
                    Content.CanvasSize = UDim2.new(0, 0, 0, math.max(totalHeight + 100, Content.AbsoluteSize.Y + 200))
                    print("XSAN: Canvas size updated to:", totalHeight + 100)
                end
                
                updateCanvasSize()
                
                -- Update canvas size when content changes
                Content.ChildAdded:Connect(function()
                    wait(0.1)
                    updateCanvasSize()
                end)
            end)
        end

        -- Make window draggable
        local dragging = false
        local dragInput
        local dragStart
        local startPos

        local function update(input)
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        Topbar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = Main.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        dragging = false
                    end
                end)
            end
        end)

        Topbar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)

        -- Window Object
        local Window = {}
        local Tabs = {}
        local currentTab = nil

        -- Create Tab function
        function Window:CreateTab(Name, Image)
            local Tab = {}
            Tab.Name = Name

            -- Create Tab Button
            local TabButton = Instance.new("TextButton")
            TabButton.Name = Name
            TabButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
            TabButton.BackgroundTransparency = 0.22
            TabButton.BorderSizePixel = 0
            TabButton.Size = UDim2.new(1, 0, 0, 24)
            TabButton.Font = Enum.Font.SourceSans
            TabButton.Text = Name
            TabButton.TextColor3 = Color3.fromRGB(220, 220, 220)
            TabButton.TextScaled = false
            TabButton.TextSize = UIStyle.TabButtonTextSize
            TabButton.TextWrapped = true
            TabButton.Parent = TabList

            -- Hover effect biru pada TabButton
            local tabStroke = Instance.new("UIStroke")
            tabStroke.Color = Color3.fromRGB(40, 40, 80)
            tabStroke.Thickness = 1
            tabStroke.Parent = TabButton
            TabButton.MouseEnter:Connect(function()
                tabStroke.Color = Color3.fromRGB(0, 120, 255)
                tabStroke.Thickness = 2
            end)
            TabButton.MouseLeave:Connect(function()
                tabStroke.Color = Color3.fromRGB(40, 40, 80)
                tabStroke.Thickness = 1
            end)

            -- Add UICorner to TabButton
            local TabButtonCorner = Instance.new("UICorner")
            TabButtonCorner.CornerRadius = UDim.new(0, 3)  -- Smaller corner radius
            TabButtonCorner.Parent = TabButton

            -- Create Tab Content as ScrollingFrame for better mobile scrolling
            local TabContent = Instance.new("ScrollingFrame")
            TabContent.Name = Name .. "_Content"
            TabContent.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
            TabContent.BackgroundTransparency = 0.12
            TabContent.Size = UDim2.new(1, 0, 1, 0)
            TabContent.Visible = false
            TabContent.ScrollBarThickness = 6
            TabContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
            TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
            TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
            TabContent.ScrollingDirection = Enum.ScrollingDirection.Y
            TabContent.ScrollingEnabled = true
            TabContent.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
            TabContent.Parent = Content

            -- Apply consistent font sizes for this tab's content
            for _, d in ipairs(TabContent:GetDescendants()) do
                applyTextStyle(d, UIStyle.ContentTextSize)
            end
            TabContent.DescendantAdded:Connect(function(d)
                applyTextStyle(d, UIStyle.ContentTextSize)
            end)

            -- Add UIListLayout to TabContent - MINIMAL SPACING
            local TabContentLayout = Instance.new("UIListLayout")
            TabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            TabContentLayout.Padding = UDim.new(0, 1)  -- Further reduced from 2 to 1
            TabContentLayout.Parent = TabContent
            
            -- Add padding for mobile - OPTIMIZED FOR READABILITY
            local TabContentPadding = Instance.new("UIPadding")
            TabContentPadding.PaddingTop = UDim.new(0, 1)     -- Reduced from 2 to 1
            TabContentPadding.PaddingBottom = UDim.new(0, 1)  -- Reduced from 2 to 1
            TabContentPadding.PaddingLeft = UDim.new(0, 6)    -- Increased from 2 to 6 to prevent left margin cut-off
            TabContentPadding.PaddingRight = UDim.new(0, 18)  -- Increased from 2 to 18 to fix right side cut-off
            TabContentPadding.Parent = TabContent
            
            -- Mobile touch scrolling for tab content
            if UserInputService.TouchEnabled then
                local dragStart = nil
                local startPos = nil
                
                TabContent.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch then
                        dragStart = input.Position
                        startPos = TabContent.CanvasPosition
                    end
                end)
                
                TabContent.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch and dragStart then
                        local delta = input.Position - dragStart
                        local newY = math.max(0, startPos.Y - delta.Y * 1.5) -- 1.5x scroll speed
                        TabContent.CanvasPosition = Vector2.new(0, newY)
                    end
                end)
                
                TabContent.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Touch then
                        dragStart = nil
                        startPos = nil
                    end
                end)
            end

            -- Tab switching logic
            TabButton.MouseButton1Click:Connect(function()
                -- Hide all other tabs
                for _, tabContent in pairs(Content:GetChildren()) do
                    if tabContent:IsA("ScrollingFrame") and tabContent.Name:find("_Content") then
                        tabContent.Visible = false
                    end
                end

                -- Reset all tab button colors
                for _, tabButton in pairs(TabList:GetChildren()) do
                    if tabButton:IsA("TextButton") then
                        tabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                        tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
                    end
                end

                -- Show selected tab and highlight button
                TabContent.Visible = true
                TabButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
                TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                currentTab = Tab
                
                -- Reset scroll position for clean view
                TabContent.CanvasPosition = Vector2.new(0, 0)
            end)

            -- If this is the first tab, select it
            if #Tabs == 0 then
                TabContent.Visible = true
                TabButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
                TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                currentTab = Tab
            end

            -- Store tab reference
            table.insert(Tabs, Tab)
            Tab.Content = TabContent

            -- Tab functions
            function Tab:CreateSection(Name)
                local Section = {}

                -- Create Section Frame
                local SectionFrame = Instance.new("Frame")
                SectionFrame.Name = Name
                SectionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                SectionFrame.BorderSizePixel = 0
                SectionFrame.Size = UDim2.new(1, 0, 0, 0)
                SectionFrame.AutomaticSize = Enum.AutomaticSize.Y
                SectionFrame.Parent = TabContent

                -- Add UICorner
                local SectionCorner = Instance.new("UICorner")
                SectionCorner.CornerRadius = UDim.new(0, 8)
                SectionCorner.Parent = SectionFrame

                -- Add UIPadding
                local SectionPadding = Instance.new("UIPadding")
                SectionPadding.PaddingTop = UDim.new(0, 10)
                SectionPadding.PaddingBottom = UDim.new(0, 10)
                SectionPadding.PaddingLeft = UDim.new(0, 10)
                SectionPadding.PaddingRight = UDim.new(0, 10)
                SectionPadding.Parent = SectionFrame

                -- Create Section Title
                local SectionTitle = Instance.new("TextLabel")
                SectionTitle.Name = "Title"
                SectionTitle.BackgroundTransparency = 1
                SectionTitle.Size = UDim2.new(1, 0, 0, 22)  -- Reduced height from 25 to 22
                SectionTitle.Font = Enum.Font.SourceSans    -- Changed from SourceSansBold
                SectionTitle.Text = Name
                SectionTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                SectionTitle.TextScaled = false
                SectionTitle.TextSize = UIStyle.SectionTitleTextSize
                SectionTitle.TextWrapped = true
                SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
                SectionTitle.Parent = SectionFrame

                -- Create Section Content
                local SectionContent = Instance.new("Frame")
                SectionContent.Name = "Content"
                SectionContent.BackgroundTransparency = 1
                SectionContent.Position = UDim2.new(0, 0, 0, 30)
                SectionContent.Size = UDim2.new(1, 0, 0, 0)
                SectionContent.AutomaticSize = Enum.AutomaticSize.Y
                SectionContent.Parent = SectionFrame

                -- Add UIListLayout to SectionContent
                local SectionContentLayout = Instance.new("UIListLayout")
                SectionContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
                SectionContentLayout.Padding = UDim.new(0, 5)
                SectionContentLayout.Parent = SectionContent

                -- Section functions
                function Section:CreateButton(Settings)
                    local ButtonSettings = {
                        Name = Settings.Name or "Button",
                        Callback = Settings.Callback or function() end
                    }

                    -- Create Button
                    local Button = Instance.new("TextButton")
                    Button.Name = ButtonSettings.Name
                    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    Button.BorderSizePixel = 0
                    -- Smaller height for compact look
                    Button.Size = UDim2.new(1, 0, 0, 30)
                    Button.Font = Enum.Font.SourceSans
                    Button.Text = ButtonSettings.Name
                    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                    -- Use fixed text size instead of scaled
                    Button.TextScaled = false
                    Button.TextSize = UIStyle.ContentTextSize
                    Button.TextWrapped = true
                    Button.Parent = SectionContent

                    -- Add UICorner with smaller radius
                    local ButtonCorner = Instance.new("UICorner")
                    ButtonCorner.CornerRadius = UDim.new(0, 4)
                    ButtonCorner.Parent = Button

                    -- Add subtle border
                    local ButtonStroke = Instance.new("UIStroke")
                    ButtonStroke.Color = Color3.fromRGB(80, 80, 80)
                    ButtonStroke.Thickness = 1
                    ButtonStroke.Transparency = 0.5
                    ButtonStroke.Parent = Button

                    -- Add padding for better text spacing
                    local ButtonPadding = Instance.new("UIPadding")
                    ButtonPadding.PaddingLeft = UDim.new(0, 6)
                    ButtonPadding.PaddingRight = UDim.new(0, 6)
                    ButtonPadding.PaddingTop = UDim.new(0, 2)
                    ButtonPadding.PaddingBottom = UDim.new(0, 2)
                    ButtonPadding.Parent = Button

                    -- Clean unsupported emoji and add a small placeholder icon if needed
                    sanitizeLabelAndMaybeAddIcon(Button, ButtonSettings.Name)

                    -- Button hover effects
                    Button.MouseEnter:Connect(function()
                        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
                        TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Transparency = 0.2}):Play()
                    end)

                    Button.MouseLeave:Connect(function()
                        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                        TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
                    end)

                    -- Button click
                    Button.MouseButton1Click:Connect(function()
                        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
                        task.wait(0.1)
                        TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
                        ButtonSettings.Callback()
                    end)

                    return Button
                end

                function Section:CreateParagraph(Settings)
                    local ParagraphSettings = {
                        Title = Settings.Title or "Paragraph",
                        Content = Settings.Content or "Content"
                    }

                    -- Create Paragraph Frame
                    local ParagraphFrame = Instance.new("Frame")
                    ParagraphFrame.Name = ParagraphSettings.Title
                    ParagraphFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    ParagraphFrame.BorderSizePixel = 0
                    ParagraphFrame.Size = UDim2.new(1, 0, 0, 0)
                    ParagraphFrame.AutomaticSize = Enum.AutomaticSize.Y
                    ParagraphFrame.Parent = SectionContent

                    -- Add UICorner
                    local ParagraphCorner = Instance.new("UICorner")
                    ParagraphCorner.CornerRadius = UDim.new(0, 5)
                    ParagraphCorner.Parent = ParagraphFrame

                    -- Add UIPadding
                    local ParagraphPadding = Instance.new("UIPadding")
                    ParagraphPadding.PaddingTop = UDim.new(0, 8)
                    ParagraphPadding.PaddingBottom = UDim.new(0, 8)
                    ParagraphPadding.PaddingLeft = UDim.new(0, 10)
                    ParagraphPadding.PaddingRight = UDim.new(0, 10)
                    ParagraphPadding.Parent = ParagraphFrame

                    -- Create Title
                    local ParagraphTitle = Instance.new("TextLabel")
                    ParagraphTitle.Name = "Title"
                    ParagraphTitle.BackgroundTransparency = 1
                    ParagraphTitle.Size = UDim2.new(1, 0, 0, 20)
                    ParagraphTitle.Font = Enum.Font.SourceSansBold
                    ParagraphTitle.Text = ParagraphSettings.Title
                    ParagraphTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ParagraphTitle.TextScaled = false
                    ParagraphTitle.TextSize = UIStyle.SectionTitleTextSize
                    ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
                    ParagraphTitle.Parent = ParagraphFrame

                    -- Create Content
                    local ParagraphContent = Instance.new("TextLabel")
                    ParagraphContent.Name = "Content"
                    ParagraphContent.BackgroundTransparency = 1
                    ParagraphContent.Position = UDim2.new(0, 0, 0, 25)
                    ParagraphContent.Size = UDim2.new(1, 0, 0, 0)
                    ParagraphContent.AutomaticSize = Enum.AutomaticSize.Y
                    ParagraphContent.Font = Enum.Font.SourceSans
                    ParagraphContent.Text = ParagraphSettings.Content
                    ParagraphContent.TextColor3 = Color3.fromRGB(200, 200, 200)
                    ParagraphContent.TextScaled = false
                    ParagraphContent.TextSize = UIStyle.ContentTextSize
                    ParagraphContent.TextWrapped = true
                    ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
                    ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
                    ParagraphContent.Parent = ParagraphFrame

                    return ParagraphFrame
                end

                function Section:CreateToggle(Settings)
                    local ToggleSettings = {
                        Name = Settings.Name or "Toggle",
                        CurrentValue = Settings.CurrentValue or false,
                        Flag = Settings.Flag or nil,
                        Callback = Settings.Callback or function() end
                    }

                    -- Create Toggle Frame
                    local ToggleFrame = Instance.new("Frame")
                    ToggleFrame.Name = ToggleSettings.Name
                    ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    ToggleFrame.BorderSizePixel = 0
                    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
                    ToggleFrame.Parent = SectionContent

                    -- Add UICorner
                    local ToggleFrameCorner = Instance.new("UICorner")
                    ToggleFrameCorner.CornerRadius = UDim.new(0, 5)
                    ToggleFrameCorner.Parent = ToggleFrame

                    -- Create Toggle Label
                    local ToggleLabel = Instance.new("TextLabel")
                    ToggleLabel.BackgroundTransparency = 1
                    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
                    ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
                    ToggleLabel.Font = Enum.Font.SourceSans
                    ToggleLabel.Text = ToggleSettings.Name
                    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ToggleLabel.TextScaled = false
                    ToggleLabel.TextSize = UIStyle.ContentTextSize
                    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                    ToggleLabel.Parent = ToggleFrame

                    -- Create Toggle Button
                    local ToggleButton = Instance.new("TextButton")
                    ToggleButton.BackgroundColor3 = ToggleSettings.CurrentValue and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
                    ToggleButton.BorderSizePixel = 0
                    ToggleButton.Position = UDim2.new(1, -35, 0.5, -10)
                    ToggleButton.Size = UDim2.new(0, 30, 0, 20)
                    ToggleButton.Text = ToggleSettings.CurrentValue and "ON" or "OFF"
                    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ToggleButton.TextScaled = true
                    ToggleButton.Font = Enum.Font.SourceSansBold
                    ToggleButton.Parent = ToggleFrame

                    -- Add UICorner to Toggle Button
                    local ToggleButtonCorner = Instance.new("UICorner")
                    ToggleButtonCorner.CornerRadius = UDim.new(0, 3)
                    ToggleButtonCorner.Parent = ToggleButton

                    -- Toggle function
                    local function Toggle()
                        ToggleSettings.CurrentValue = not ToggleSettings.CurrentValue
                        ToggleButton.Text = ToggleSettings.CurrentValue and "ON" or "OFF"
                        TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                            BackgroundColor3 = ToggleSettings.CurrentValue and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
                        }):Play()
                        ToggleSettings.Callback(ToggleSettings.CurrentValue)
                    end

                    ToggleButton.MouseButton1Click:Connect(Toggle)
                    ToggleFrame.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Toggle()
                        end
                    end)

                    local ToggleObject = {}
                    function ToggleObject:Set(Value)
                        ToggleSettings.CurrentValue = Value
                        ToggleButton.Text = Value and "ON" or "OFF"
                        ToggleButton.BackgroundColor3 = Value and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
                        ToggleSettings.Callback(Value)
                    end

                    return ToggleObject
                end

                function Section:CreateDropdown(Settings)
                    local DropdownSettings = {
                        Name = Settings.Name or "Dropdown",
                        Options = Settings.Options or {},
                        CurrentOption = Settings.CurrentOption or (Settings.Options and Settings.Options[1]) or "",
                        MultipleOptions = Settings.MultipleOptions or false,
                        Flag = Settings.Flag or nil,
                        Callback = Settings.Callback or function() end
                    }

                    -- Create Dropdown Frame
                    local DropdownFrame = Instance.new("Frame")
                    DropdownFrame.Name = DropdownSettings.Name
                    DropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                    DropdownFrame.BorderSizePixel = 0
                    DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
                    DropdownFrame.Parent = SectionContent

                    -- Add UICorner
                    local DropdownCorner = Instance.new("UICorner")
                    DropdownCorner.CornerRadius = UDim.new(0, 5)
                    DropdownCorner.Parent = DropdownFrame

                    -- Create Dropdown Button
                    local DropdownButton = Instance.new("TextButton")
                    DropdownButton.BackgroundTransparency = 1
                    DropdownButton.Size = UDim2.new(1, 0, 1, 0)
                    DropdownButton.Font = Enum.Font.SourceSans
                    DropdownButton.Text = DropdownSettings.Name .. ": " .. tostring(DropdownSettings.CurrentOption)
                    DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    DropdownButton.TextScaled = false
                    DropdownButton.TextSize = UIStyle.ContentTextSize
                    DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                    DropdownButton.Parent = DropdownFrame

                    -- Add padding to dropdown text
                    local DropdownPadding = Instance.new("UIPadding")
                    DropdownPadding.PaddingLeft = UDim.new(0, 10)
                    DropdownPadding.PaddingRight = UDim.new(0, 10)
                    DropdownPadding.Parent = DropdownButton

                    -- Create Options Frame
                    local OptionsFrame = Instance.new("ScrollingFrame")
                    OptionsFrame.Name = "Options"
                    OptionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    OptionsFrame.BorderSizePixel = 0
                    OptionsFrame.Position = UDim2.new(0, 0, 1, 2)
                    OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
                    OptionsFrame.Visible = false
                    OptionsFrame.ZIndex = 10
                    OptionsFrame.ScrollBarThickness = 5
                    OptionsFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
                    OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
                    OptionsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
                    OptionsFrame.ScrollingDirection = Enum.ScrollingDirection.Y
                    OptionsFrame.Parent = DropdownFrame

                    -- Add UICorner to Options
                    local OptionsCorner = Instance.new("UICorner")
                    OptionsCorner.CornerRadius = UDim.new(0, 5)
                    OptionsCorner.Parent = OptionsFrame

                    -- Add UIListLayout to Options
                    local OptionsLayout = Instance.new("UIListLayout")
                    OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    OptionsLayout.Padding = UDim.new(0, 1)
                    OptionsLayout.Parent = OptionsFrame

                    -- Variables
                    local isOpen = false

                    -- Function to update options
                    local function UpdateOptions()
                        for _, child in pairs(OptionsFrame:GetChildren()) do
                            if child:IsA("TextButton") then
                                child:Destroy()
                            end
                        end

                        local maxHeight = math.min(#DropdownSettings.Options * 25, 150)
                        OptionsFrame.Size = UDim2.new(1, 0, 0, maxHeight)

                        for i, option in ipairs(DropdownSettings.Options) do
                            local OptionButton = Instance.new("TextButton")
                            OptionButton.Name = option
                            OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                            OptionButton.BorderSizePixel = 0
                            OptionButton.Size = UDim2.new(1, 0, 0, 25)
                            OptionButton.Font = Enum.Font.SourceSans
                            OptionButton.Text = option
                            OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                            OptionButton.TextScaled = false
                            OptionButton.TextSize = UIStyle.ContentTextSize
                            OptionButton.Parent = OptionsFrame

                            OptionButton.MouseEnter:Connect(function()
                                OptionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                            end)

                            OptionButton.MouseLeave:Connect(function()
                                OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                            end)

                            OptionButton.MouseButton1Click:Connect(function()
                                DropdownSettings.CurrentOption = option
                                DropdownButton.Text = DropdownSettings.Name .. ": " .. option
                                OptionsFrame.Visible = false
                                isOpen = false
                                DropdownSettings.Callback(option)
                            end)
                        end
                    end

                    -- Toggle dropdown
                    DropdownButton.MouseButton1Click:Connect(function()
                        isOpen = not isOpen
                        OptionsFrame.Visible = isOpen
                        if isOpen then
                            UpdateOptions()
                        end
                    end)

                    -- Close dropdown when clicking outside
                    UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 and isOpen then
                            local mousePos = UserInputService:GetMouseLocation()
                            local dropdownPos = DropdownFrame.AbsolutePosition
                            local dropdownSize = DropdownFrame.AbsoluteSize
                            local optionsSize = OptionsFrame.AbsoluteSize

                            if mousePos.X < dropdownPos.X or mousePos.X > dropdownPos.X + dropdownSize.X or
                            mousePos.Y < dropdownPos.Y or mousePos.Y > dropdownPos.Y + dropdownSize.Y + optionsSize.Y then
                                OptionsFrame.Visible = false
                                isOpen = false
                            end
                        end
                    end)

                    -- Initialize options
                    UpdateOptions()

                    local DropdownObject = {}
                    function DropdownObject:Set(Option)
                        DropdownSettings.CurrentOption = Option
                        DropdownButton.Text = DropdownSettings.Name .. ": " .. Option
                        DropdownSettings.Callback(Option)
                    end

                    function DropdownObject:Refresh(Options, CurrentOption)
                        DropdownSettings.Options = Options
                        if CurrentOption then
                            DropdownSettings.CurrentOption = CurrentOption
                            DropdownButton.Text = DropdownSettings.Name .. ": " .. CurrentOption
                        end
                        UpdateOptions()
                    end

                    return DropdownObject
                end

                return Section
            end

            -- Tab-level functions (for direct use without sections)
            function Tab:CreateParagraph(Settings)
                local ParagraphSettings = {
                    Title = Settings.Title or "Paragraph",
                    Content = Settings.Content or "Content"
                }

                -- Create Paragraph Frame directly in tab content
                local ParagraphFrame = Instance.new("Frame")
                ParagraphFrame.Name = ParagraphSettings.Title
                ParagraphFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                ParagraphFrame.BorderSizePixel = 0
                ParagraphFrame.Size = UDim2.new(1, 0, 0, 0)
                ParagraphFrame.AutomaticSize = Enum.AutomaticSize.Y
                ParagraphFrame.Parent = TabContent

                -- Add UICorner with smaller radius
                local ParagraphCorner = Instance.new("UICorner")
                ParagraphCorner.CornerRadius = UDim.new(0, 5)
                ParagraphCorner.Parent = ParagraphFrame

                -- Add UIPadding with smaller padding
                local ParagraphPadding = Instance.new("UIPadding")
                ParagraphPadding.PaddingTop = UDim.new(0, 8)
                ParagraphPadding.PaddingBottom = UDim.new(0, 8)
                ParagraphPadding.PaddingLeft = UDim.new(0, 10)
                ParagraphPadding.PaddingRight = UDim.new(0, 10)
                ParagraphPadding.Parent = ParagraphFrame

                -- Create Content Layout
                local ContentLayout = Instance.new("UIListLayout")
                ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
                ContentLayout.Padding = UDim.new(0, 4)
                ContentLayout.Parent = ParagraphFrame

                -- Create Title
                local ParagraphTitle = Instance.new("TextLabel")
                ParagraphTitle.Name = "Title"
                ParagraphTitle.BackgroundTransparency = 1
                ParagraphTitle.Size = UDim2.new(1, 0, 0, 18)  -- Reduced from 20 to 18
                ParagraphTitle.Font = Enum.Font.SourceSans     -- Changed from Bold for smaller appearance
                ParagraphTitle.Text = ParagraphSettings.Title
                ParagraphTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
                ParagraphTitle.TextScaled = false
                ParagraphTitle.TextSize = 11  -- Smaller size instead of UIStyle
                ParagraphTitle.TextWrapped = true
                ParagraphTitle.TextXAlignment = Enum.TextXAlignment.Left
                ParagraphTitle.LayoutOrder = 1
                ParagraphTitle.Parent = ParagraphFrame

                -- Create Content
                local ParagraphContent = Instance.new("TextLabel")
                ParagraphContent.Name = "Content"
                ParagraphContent.BackgroundTransparency = 1
                ParagraphContent.Size = UDim2.new(1, 0, 0, 0)
                ParagraphContent.AutomaticSize = Enum.AutomaticSize.Y
                ParagraphContent.Font = Enum.Font.SourceSans
                ParagraphContent.Text = ParagraphSettings.Content
                ParagraphContent.TextColor3 = Color3.fromRGB(200, 200, 200)
                ParagraphContent.TextScaled = false
                ParagraphContent.TextSize = UIStyle.ContentTextSize
                ParagraphContent.TextWrapped = true
                ParagraphContent.TextXAlignment = Enum.TextXAlignment.Left
                ParagraphContent.TextYAlignment = Enum.TextYAlignment.Top
                ParagraphContent.LayoutOrder = 2
                ParagraphContent.Parent = ParagraphFrame

                return ParagraphFrame
            end

            function Tab:CreateButton(Settings)
                local ButtonSettings = {
                    Name = Settings.Name or "Button",
                    Callback = Settings.Callback or function() end
                }

                -- Create Button directly in tab content
                local Button = Instance.new("TextButton")
                Button.Name = ButtonSettings.Name
                Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                Button.BorderSizePixel = 0
                -- Smaller height for compact look, especially for teleport buttons
                Button.Size = UDim2.new(1, 0, 0, 28)  -- Reduced from 32 to 28 for smaller font
                Button.Font = Enum.Font.SourceSans
                Button.Text = ButtonSettings.Name
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                -- Use fixed text size instead of scaled for better control
                Button.TextScaled = false
                Button.TextSize = 10  -- Even smaller for buttons
                Button.TextWrapped = true
                Button.Parent = TabContent

                -- Add UICorner with smaller radius
                local ButtonCorner = Instance.new("UICorner")
                ButtonCorner.CornerRadius = UDim.new(0, 5)
                ButtonCorner.Parent = Button

                -- Add subtle border
                local ButtonStroke = Instance.new("UIStroke")
                ButtonStroke.Color = Color3.fromRGB(80, 80, 80)
                ButtonStroke.Thickness = 1
                ButtonStroke.Transparency = 0.5
                ButtonStroke.Parent = Button

                -- Add padding for better text spacing
                local ButtonPadding = Instance.new("UIPadding")
                ButtonPadding.PaddingLeft = UDim.new(0, 8)
                ButtonPadding.PaddingRight = UDim.new(0, 8)
                ButtonPadding.PaddingTop = UDim.new(0, 2)
                ButtonPadding.PaddingBottom = UDim.new(0, 2)
                ButtonPadding.Parent = Button

                -- Clean unsupported emoji and add a small placeholder icon if needed
                sanitizeLabelAndMaybeAddIcon(Button, ButtonSettings.Name)

                -- Button hover effects
                Button.MouseEnter:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
                    TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Transparency = 0.2}):Play()
                end)

                Button.MouseLeave:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                    TweenService:Create(ButtonStroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
                end)

                -- Button click
                Button.MouseButton1Click:Connect(function()
                    TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
                    task.wait(0.1)
                    TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
                    ButtonSettings.Callback()
                end)

                return Button
            end

            function Tab:CreateToggle(Settings)
                local ToggleSettings = {
                    Name = Settings.Name or "Toggle",
                    CurrentValue = Settings.CurrentValue or false,
                    Flag = Settings.Flag or nil,
                    Callback = Settings.Callback or function() end
                }

                -- Create Toggle Frame directly in tab content
                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = ToggleSettings.Name
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Size = UDim2.new(1, 0, 0, 35)  -- Reduced from 40 to 35
                ToggleFrame.Parent = TabContent

                -- Add UICorner
                local ToggleFrameCorner = Instance.new("UICorner")
                ToggleFrameCorner.CornerRadius = UDim.new(0, 8)
                ToggleFrameCorner.Parent = ToggleFrame

                -- Add UIPadding
                local TogglePadding = Instance.new("UIPadding")
                TogglePadding.PaddingLeft = UDim.new(0, 15)
                TogglePadding.PaddingRight = UDim.new(0, 15)
                TogglePadding.Parent = ToggleFrame

                -- Create Toggle Label
                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Position = UDim2.new(0, 0, 0, 0)
                ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
                ToggleLabel.Font = Enum.Font.SourceSans
                ToggleLabel.Text = ToggleSettings.Name
                ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleLabel.TextScaled = false
                ToggleLabel.TextSize = 10  -- Reduced from UIStyle.ContentTextSize
                ToggleLabel.TextWrapped = true
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame

                -- Create Toggle Button
                local ToggleButton = Instance.new("TextButton")
                ToggleButton.BackgroundColor3 = ToggleSettings.CurrentValue and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Position = UDim2.new(1, -35, 0.5, -10)  -- Adjusted position
                ToggleButton.Size = UDim2.new(0, 30, 0, 20)         -- Smaller toggle button
                ToggleButton.Text = ToggleSettings.CurrentValue and "ON" or "OFF"
                ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToggleButton.TextScaled = false  -- Use fixed size
                ToggleButton.TextSize = 8        -- Smaller text for toggle
                ToggleButton.Font = Enum.Font.SourceSans  -- Changed from Bold
                ToggleButton.Parent = ToggleFrame

                -- Add UICorner to Toggle Button
                local ToggleButtonCorner = Instance.new("UICorner")
                ToggleButtonCorner.CornerRadius = UDim.new(0, 5)
                ToggleButtonCorner.Parent = ToggleButton

                -- Toggle function
                local function Toggle()
                    ToggleSettings.CurrentValue = not ToggleSettings.CurrentValue
                    ToggleButton.Text = ToggleSettings.CurrentValue and "ON" or "OFF"
                    TweenService:Create(ToggleButton, TweenInfo.new(0.2), {
                        BackgroundColor3 = ToggleSettings.CurrentValue and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
                    }):Play()
                    ToggleSettings.Callback(ToggleSettings.CurrentValue)
                end

                ToggleButton.MouseButton1Click:Connect(Toggle)
                ToggleFrame.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Toggle()
                    end
                end)

                local ToggleObject = {}
                function ToggleObject:Set(Value)
                    ToggleSettings.CurrentValue = Value
                    ToggleButton.Text = Value and "ON" or "OFF"
                    ToggleButton.BackgroundColor3 = Value and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
                    ToggleSettings.Callback(Value)
                end

                return ToggleObject
            end

            function Tab:CreateSlider(Settings)
                local SliderSettings = {
                    Name = Settings.Name or "Slider",
                    Range = Settings.Range or {0, 100},
                    Increment = Settings.Increment or 1,
                    Suffix = Settings.Suffix or "",
                    CurrentValue = Settings.CurrentValue or Settings.Range[1],
                    Flag = Settings.Flag or nil,
                    Callback = Settings.Callback or function() end
                }

                -- Create Slider Frame directly in tab content
                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = SliderSettings.Name
                SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Size = UDim2.new(1, 0, 0, 50)
                SliderFrame.Parent = TabContent

                -- Add UICorner
                local SliderFrameCorner = Instance.new("UICorner")
                SliderFrameCorner.CornerRadius = UDim.new(0, 8)
                SliderFrameCorner.Parent = SliderFrame

                -- Add UIPadding
                local SliderPadding = Instance.new("UIPadding")
                SliderPadding.PaddingLeft = UDim.new(0, 15)
                SliderPadding.PaddingRight = UDim.new(0, 15)
                SliderPadding.PaddingTop = UDim.new(0, 8)
                SliderPadding.PaddingBottom = UDim.new(0, 8)
                SliderPadding.Parent = SliderFrame

                -- Create Slider Label
                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Position = UDim2.new(0, 0, 0, 0)
                SliderLabel.Size = UDim2.new(1, -60, 0, 20)
                SliderLabel.Font = Enum.Font.SourceSans
                SliderLabel.Text = SliderSettings.Name
                SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderLabel.TextScaled = false
                SliderLabel.TextSize = UIStyle.ContentTextSize
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame

                -- Create Value Label
                local ValueLabel = Instance.new("TextLabel")
                ValueLabel.BackgroundTransparency = 1
                ValueLabel.Position = UDim2.new(1, -60, 0, 0)
                ValueLabel.Size = UDim2.new(0, 60, 0, 20)
                ValueLabel.Font = Enum.Font.SourceSansBold
                ValueLabel.Text = tostring(SliderSettings.CurrentValue) .. SliderSettings.Suffix
                ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                ValueLabel.TextScaled = false
                ValueLabel.TextSize = UIStyle.ContentTextSize
                ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
                ValueLabel.Parent = SliderFrame

                -- Create Slider Track
                local SliderTrack = Instance.new("Frame")
                SliderTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                SliderTrack.BorderSizePixel = 0
                SliderTrack.Position = UDim2.new(0, 0, 1, -15)
                SliderTrack.Size = UDim2.new(1, 0, 0, 6)
                SliderTrack.Parent = SliderFrame

                -- Add UICorner to Track
                local TrackCorner = Instance.new("UICorner")
                TrackCorner.CornerRadius = UDim.new(0, 3)
                TrackCorner.Parent = SliderTrack

                -- Create Slider Fill
                local SliderFill = Instance.new("Frame")
                SliderFill.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
                SliderFill.BorderSizePixel = 0
                SliderFill.Position = UDim2.new(0, 0, 0, 0)
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                SliderFill.Parent = SliderTrack

                -- Add UICorner to Fill
                local FillCorner = Instance.new("UICorner")
                FillCorner.CornerRadius = UDim.new(0, 3)
                FillCorner.Parent = SliderFill

                -- Create Slider Handle
                local SliderHandle = Instance.new("TextButton")
                SliderHandle.BackgroundColor3 = Color3.fromRGB(100, 160, 230)
                SliderHandle.BorderSizePixel = 0
                SliderHandle.Position = UDim2.new(0, -8, 0.5, -8)
                SliderHandle.Size = UDim2.new(0, 16, 0, 16)
                SliderHandle.Text = ""
                SliderHandle.Parent = SliderTrack

                -- Add UICorner to Handle
                local HandleCorner = Instance.new("UICorner")
                HandleCorner.CornerRadius = UDim.new(0.5, 0) -- Circular
                HandleCorner.Parent = SliderHandle

                -- Variables
                local dragging = false

                -- Function to update slider
                local function UpdateSlider(value)
                    value = math.clamp(value, SliderSettings.Range[1], SliderSettings.Range[2])
                    value = math.floor(value / SliderSettings.Increment + 0.5) * SliderSettings.Increment
                    SliderSettings.CurrentValue = value

                    -- Update visuals
                    local percentage = (value - SliderSettings.Range[1]) / (SliderSettings.Range[2] - SliderSettings.Range[1])
                    SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
                    SliderHandle.Position = UDim2.new(percentage, -8, 0.5, -8)
                    ValueLabel.Text = tostring(value) .. SliderSettings.Suffix

                    -- Callback
                    SliderSettings.Callback(value)
                end

                -- Mouse/Touch input handling
                SliderTrack.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        local percentage = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                        local value = SliderSettings.Range[1] + percentage * (SliderSettings.Range[2] - SliderSettings.Range[1])
                        UpdateSlider(value)
                    end
                end)

                SliderTrack.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local percentage = math.clamp((input.Position.X - SliderTrack.AbsolutePosition.X) / SliderTrack.AbsoluteSize.X, 0, 1)
                        local value = SliderSettings.Range[1] + percentage * (SliderSettings.Range[2] - SliderSettings.Range[1])
                        UpdateSlider(value)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)

                -- Handle dragging
                SliderHandle.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                    end
                end)

                -- Initialize slider
                UpdateSlider(SliderSettings.CurrentValue)

                local SliderObject = {}
                function SliderObject:Set(Value)
                    UpdateSlider(Value)
                end

                return SliderObject
            end

            function Tab:CreateDropdown(Settings)
                local DropdownSettings = {
                    Name = Settings.Name or "Dropdown",
                    Options = Settings.Options or {},
                    CurrentOption = Settings.CurrentOption or (Settings.Options and Settings.Options[1]) or "",
                    MultipleOptions = Settings.MultipleOptions or false,
                    Flag = Settings.Flag or nil,
                    Callback = Settings.Callback or function() end
                }

                -- Create Dropdown Frame directly in tab content
                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = DropdownSettings.Name
                DropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.Size = UDim2.new(1, 0, 0, 40)
                DropdownFrame.ZIndex = 998  -- High Z-index for dropdown frame
                DropdownFrame.Parent = TabContent

                -- Add UICorner
                local DropdownCorner = Instance.new("UICorner")
                DropdownCorner.CornerRadius = UDim.new(0, 8)
                DropdownCorner.Parent = DropdownFrame

                -- Create Dropdown Button
                local DropdownButton = Instance.new("TextButton")
                DropdownButton.BackgroundTransparency = 1
                DropdownButton.Size = UDim2.new(1, 0, 1, 0)
                DropdownButton.Font = Enum.Font.SourceSans
                DropdownButton.Text = DropdownSettings.Name .. ": " .. tostring(DropdownSettings.CurrentOption)
                DropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                DropdownButton.TextScaled = false
                DropdownButton.TextSize = UIStyle.ContentTextSize
                DropdownButton.TextXAlignment = Enum.TextXAlignment.Left
                DropdownButton.ZIndex = 999  -- High Z-index for dropdown button
                DropdownButton.Parent = DropdownFrame

                -- Add padding to dropdown text
                local DropdownPadding = Instance.new("UIPadding")
                DropdownPadding.PaddingLeft = UDim.new(0, 15)
                DropdownPadding.PaddingRight = UDim.new(0, 15)
                DropdownPadding.Parent = DropdownButton

                -- Create Options Frame - HIGH Z-INDEX for proper layering
                local OptionsFrame = Instance.new("ScrollingFrame")
                OptionsFrame.Name = "Options"
                OptionsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                OptionsFrame.BorderSizePixel = 0
                OptionsFrame.Position = UDim2.new(0, 0, 1, 2)
                OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
                OptionsFrame.Visible = false
                OptionsFrame.ZIndex = 1000  -- MUCH higher Z-index to appear above all other content
                OptionsFrame.ScrollBarThickness = 8
                OptionsFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
                OptionsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
                OptionsFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
                OptionsFrame.ScrollingDirection = Enum.ScrollingDirection.Y
                OptionsFrame.Parent = DropdownFrame

                -- Add UIStroke for better visibility
                local OptionsStroke = Instance.new("UIStroke")
                OptionsStroke.Color = Color3.fromRGB(80, 80, 80)
                OptionsStroke.Thickness = 1
                OptionsStroke.Parent = OptionsFrame

                -- Add UICorner to Options
                local OptionsCorner = Instance.new("UICorner")
                OptionsCorner.CornerRadius = UDim.new(0, 8)
                OptionsCorner.Parent = OptionsFrame

                -- Add UIListLayout to Options
                local OptionsLayout = Instance.new("UIListLayout")
                OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
                OptionsLayout.Padding = UDim.new(0, 2)
                OptionsLayout.Parent = OptionsFrame

                -- Variables
                local isOpen = false

                -- Function to update options
                local function UpdateOptions()
                    for _, child in pairs(OptionsFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end

                    local maxHeight = math.min(#DropdownSettings.Options * 30, 150)
                    OptionsFrame.Size = UDim2.new(1, 0, 0, maxHeight)

                    for i, option in ipairs(DropdownSettings.Options) do
                        local OptionButton = Instance.new("TextButton")
                        OptionButton.Name = option
                        OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                        OptionButton.BorderSizePixel = 0
                        OptionButton.Size = UDim2.new(1, 0, 0, 30)
                        OptionButton.Font = Enum.Font.SourceSans
                        OptionButton.Text = option
                        OptionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                        OptionButton.TextScaled = false
                        OptionButton.TextSize = UIStyle.ContentTextSize
                        OptionButton.ZIndex = 1001  -- Higher than OptionsFrame
                        OptionButton.Parent = OptionsFrame

                        -- Add UICorner
                        local OptionCorner = Instance.new("UICorner")
                        OptionCorner.CornerRadius = UDim.new(0, 5)
                        OptionCorner.Parent = OptionButton

                        OptionButton.MouseEnter:Connect(function()
                            OptionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                        end)

                        OptionButton.MouseLeave:Connect(function()
                            OptionButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                        end)

                        OptionButton.MouseButton1Click:Connect(function()
                            DropdownSettings.CurrentOption = option
                            DropdownButton.Text = DropdownSettings.Name .. ": " .. option
                            OptionsFrame.Visible = false
                            isOpen = false
                            DropdownSettings.Callback(option)
                        end)
                    end
                end

                -- Close dropdown when clicking outside - IMPROVED
                local clickOutsideConnection
                
                -- Toggle dropdown
                DropdownButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    OptionsFrame.Visible = isOpen
                    if isOpen then
                        UpdateOptions()
                        
                        -- Create connection to detect outside clicks
                        if clickOutsideConnection then
                            clickOutsideConnection:Disconnect()
                        end
                        
                        clickOutsideConnection = UserInputService.InputBegan:Connect(function(input)
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                -- Wait a frame to ensure the dropdown button click is processed first
                                task.wait()
                                
                                local mousePos = UserInputService:GetMouseLocation()
                                local dropdownPos = DropdownFrame.AbsolutePosition
                                local dropdownSize = DropdownFrame.AbsoluteSize
                                local optionsPos = OptionsFrame.AbsolutePosition
                                local optionsSize = OptionsFrame.AbsoluteSize
                                
                                -- Check if click is outside both dropdown button and options frame
                                local clickInDropdown = mousePos.X >= dropdownPos.X and mousePos.X <= dropdownPos.X + dropdownSize.X and
                                                        mousePos.Y >= dropdownPos.Y and mousePos.Y <= dropdownPos.Y + dropdownSize.Y
                                                        
                                local clickInOptions = mousePos.X >= optionsPos.X and mousePos.X <= optionsPos.X + optionsSize.X and
                                                    mousePos.Y >= optionsPos.Y and mousePos.Y <= optionsPos.Y + optionsSize.Y
                                
                                if not clickInDropdown and not clickInOptions then
                                    OptionsFrame.Visible = false
                                    isOpen = false
                                    if clickOutsideConnection then
                                        clickOutsideConnection:Disconnect()
                                        clickOutsideConnection = nil
                                    end
                                end
                            end
                        end)
                    else
                        -- Disconnect the outside click detection when dropdown is closed
                        if clickOutsideConnection then
                            clickOutsideConnection:Disconnect()
                            clickOutsideConnection = nil
                        end
                    end
                end)

                -- Initialize options
                if #DropdownSettings.Options > 0 then
                    UpdateOptions()
                end

                local DropdownObject = {}
                function DropdownObject:Set(Option)
                    DropdownSettings.CurrentOption = Option
                    DropdownButton.Text = DropdownSettings.Name .. ": " .. Option
                    DropdownSettings.Callback(Option)
                end

                function DropdownObject:Refresh(Options, CurrentOption)
                    DropdownSettings.Options = Options
                    if CurrentOption then
                        DropdownSettings.CurrentOption = CurrentOption
                        DropdownButton.Text = DropdownSettings.Name .. ": " .. CurrentOption
                    end
                    UpdateOptions()
                end

                return DropdownObject
            end

            function Tab:CreateInput(Settings)
                local InputSettings = {
                    Name = Settings.Name or "Input",
                    PlaceholderText = Settings.PlaceholderText or "Enter text...",
                    RemoveTextAfterFocusLost = Settings.RemoveTextAfterFocusLost or false,
                    Flag = Settings.Flag or nil,
                    Callback = Settings.Callback or function() end
                }

                -- Create Input Frame directly in tab content
                local InputFrame = Instance.new("Frame")
                InputFrame.Name = InputSettings.Name
                InputFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                InputFrame.BorderSizePixel = 0
                InputFrame.Size = UDim2.new(1, 0, 0, 45)
                InputFrame.Parent = TabContent

                -- Add UICorner
                local InputFrameCorner = Instance.new("UICorner")
                InputFrameCorner.CornerRadius = UDim.new(0, 8)
                InputFrameCorner.Parent = InputFrame

                -- Add UIPadding
                local InputPadding = Instance.new("UIPadding")
                InputPadding.PaddingLeft = UDim.new(0, 15)
                InputPadding.PaddingRight = UDim.new(0, 15)
                InputPadding.PaddingTop = UDim.new(0, 8)
                InputPadding.PaddingBottom = UDim.new(0, 8)
                InputPadding.Parent = InputFrame

                -- Create Input Label
                local InputLabel = Instance.new("TextLabel")
                InputLabel.BackgroundTransparency = 1
                InputLabel.Position = UDim2.new(0, 0, 0, 0)
                InputLabel.Size = UDim2.new(1, 0, 0, 15)
                InputLabel.Font = Enum.Font.SourceSans
                InputLabel.Text = InputSettings.Name
                InputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputLabel.TextScaled = false
                InputLabel.TextSize = UIStyle.ContentTextSize
                InputLabel.TextXAlignment = Enum.TextXAlignment.Left
                InputLabel.Parent = InputFrame

                -- Create Input Box
                local InputBox = Instance.new("TextBox")
                InputBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                InputBox.BorderSizePixel = 0
                InputBox.Position = UDim2.new(0, 0, 0, 20)
                InputBox.Size = UDim2.new(1, 0, 0, 25)
                InputBox.Font = Enum.Font.SourceSans
                InputBox.PlaceholderText = InputSettings.PlaceholderText
                InputBox.Text = ""
                InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputBox.TextScaled = false
                InputBox.TextSize = UIStyle.ContentTextSize
                InputBox.TextXAlignment = Enum.TextXAlignment.Left
                InputBox.Parent = InputFrame

                -- Add UICorner to Input Box
                local InputBoxCorner = Instance.new("UICorner")
                InputBoxCorner.CornerRadius = UDim.new(0, 5)
                InputBoxCorner.Parent = InputBox

                -- Add UIPadding to Input Box
                local InputBoxPadding = Instance.new("UIPadding")
                InputBoxPadding.PaddingLeft = UDim.new(0, 8)
                InputBoxPadding.PaddingRight = UDim.new(0, 8)
                InputBoxPadding.Parent = InputBox

                -- Focus events
                InputBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        InputSettings.Callback(InputBox.Text)
                    end
                    
                    if InputSettings.RemoveTextAfterFocusLost then
                        InputBox.Text = ""
                    end
                end)

                -- Visual feedback
                InputBox.Focused:Connect(function()
                    TweenService:Create(InputBox, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                    }):Play()
                end)

                InputBox.FocusLost:Connect(function()
                    TweenService:Create(InputBox, TweenInfo.new(0.2), {
                        BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    }):Play()
                end)

                local InputObject = {}
                function InputObject:Set(Text)
                    InputBox.Text = Text
                    InputSettings.Callback(Text)
                end

                return InputObject
            end

            function Tab:CreateInput(Settings)
                local InputSettings = {
                    Name = Settings.Name or "Input",
                    PlaceholderText = Settings.PlaceholderText or "Enter text...",
                    RemoveTextAfterFocusLost = Settings.RemoveTextAfterFocusLost or false,
                    CurrentValue = Settings.CurrentValue or "",
                    Flag = Settings.Flag or nil,
                    Callback = Settings.Callback or function() end
                }

                -- Create Input Frame directly in tab content
                local InputFrame = Instance.new("Frame")
                InputFrame.Name = InputSettings.Name
                InputFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                InputFrame.BorderSizePixel = 0
                InputFrame.Size = UDim2.new(1, 0, 0, 42)  -- Slightly smaller
                InputFrame.Parent = TabContent

                -- Add UICorner with smaller radius
                local InputFrameCorner = Instance.new("UICorner")
                InputFrameCorner.CornerRadius = UDim.new(0, 5)
                InputFrameCorner.Parent = InputFrame

                -- Add UIPadding with smaller padding
                local InputPadding = Instance.new("UIPadding")
                InputPadding.PaddingLeft = UDim.new(0, 10)
                InputPadding.PaddingRight = UDim.new(0, 10)
                InputPadding.PaddingTop = UDim.new(0, 6)
                InputPadding.PaddingBottom = UDim.new(0, 6)
                InputPadding.Parent = InputFrame

                -- Create Input Label
                local InputLabel = Instance.new("TextLabel")
                InputLabel.BackgroundTransparency = 1
                InputLabel.Position = UDim2.new(0, 0, 0, 0)
                InputLabel.Size = UDim2.new(1, 0, 0, 16)
                InputLabel.Font = Enum.Font.SourceSans
                InputLabel.Text = InputSettings.Name
                InputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                InputLabel.TextScaled = false
                InputLabel.TextSize = UIStyle.ContentTextSize
                InputLabel.TextXAlignment = Enum.TextXAlignment.Left
                InputLabel.Parent = InputFrame

                -- Create Text Input
                local TextInput = Instance.new("TextBox")
                TextInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                TextInput.BorderSizePixel = 0
                TextInput.Position = UDim2.new(0, 0, 1, -18)
                TextInput.Size = UDim2.new(1, 0, 0, 18)
                TextInput.Font = Enum.Font.SourceSans
                TextInput.Text = InputSettings.CurrentValue
                TextInput.PlaceholderText = InputSettings.PlaceholderText
                TextInput.TextColor3 = Color3.fromRGB(255, 255, 255)
                TextInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
                TextInput.TextScaled = false
                TextInput.TextSize = UIStyle.ContentTextSize
                TextInput.ClearTextOnFocus = false
                TextInput.Parent = InputFrame

                -- Add UICorner to TextInput
                local TextInputCorner = Instance.new("UICorner")
                TextInputCorner.CornerRadius = UDim.new(0, 4)
                TextInputCorner.Parent = TextInput

                -- Add UIPadding to TextInput
                local TextInputPadding = Instance.new("UIPadding")
                TextInputPadding.PaddingLeft = UDim.new(0, 6)
                TextInputPadding.PaddingRight = UDim.new(0, 6)
                TextInputPadding.Parent = TextInput

                -- Input events
                TextInput.FocusLost:Connect(function(enterPressed)
                    if InputSettings.RemoveTextAfterFocusLost and not enterPressed then
                        TextInput.Text = ""
                    end
                    InputSettings.CurrentValue = TextInput.Text
                    InputSettings.Callback(TextInput.Text)
                end)

                TextInput.Changed:Connect(function(property)
                    if property == "Text" then
                        InputSettings.CurrentValue = TextInput.Text
                    end
                end)

                local InputObject = {}
                function InputObject:Set(Value)
                    TextInput.Text = Value
                    InputSettings.CurrentValue = Value
                    InputSettings.Callback(Value)
                end

                return InputObject
            end

            return Tab
        end

        return Window
    end

    return Rayfield
