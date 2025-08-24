-- RandomLocationFeature.lua
-- Fitur: Random Location untuk Tab Fitur

local RandomLocationFeature = {
    enabled = false,
    interval = 60, -- detik
    locations = {}, -- [nama] = true/false
    running = false,
    thread = nil
}


-- Daftar lokasi dari random spot selection.txt
local DefaultLocations = {
    ["🏝️ SISYPUS 1"] = CFrame.new(-3658.34009, -134.152679, -958.42688, -0.0781492665, -2.86104935e-08, 0.996941686, -2.78758208e-08, 1, 2.65131046e-08, -0.996941686, -2.57185864e-08, -0.0781492665),
    ["🏝️ SISYPUS 2"] = CFrame.new(-3653.30981, -134.907089, -926.160889, 0.220326096, 4.83849014e-08, 0.975426257, 6.62771313e-08, 1, -6.45743157e-08, -0.975426257, 7.88758641e-08, 0.220326096),
    ["🏝️ SISYPUS 3"] = CFrame.new(-3751.85229, -135.073914, -893.084534, 0.943822026, -5.59691182e-09, -0.330454141, 2.94163782e-09, 1, -8.53531201e-09, 0.330454141, 7.08373937e-09, 0.943822026),
    ["🏝️ SISYPUS 4"] = CFrame.new(-3785.75586, -135.074417, -951.562134, -0.0280405674, 4.49322677e-08, -0.999606788, -6.43362197e-10, 1, 4.49679902e-08, 0.999606788, 1.90403715e-09, -0.0280405674),
    ["🏝️ SISYPUS 5"] = CFrame.new(-3713.19263, -135.073914, -1014.65045, -0.976679265, 1.3943791e-08, 0.21470347, 8.76151063e-09, 1, -2.50885819e-08, -0.21470347, -2.26223715e-08, -0.976679265),
    ["🦈 TREASURE"] = CFrame.new(-3628.79614, -283.172729, -1640.40698, 0.999939501, -1.50053463e-08, 0.0110019622, 1.52731534e-08, 1, -2.42576892e-08, -0.0110019622, 2.44242546e-08, 0.999939501),
    ["❄️ ICE SPOT 1"] = CFrame.new(1990.55005, 3.09498453, 3021.90991, 1, 6.4053431e-08, -7.11609591e-14, -6.4053431e-08, 1, -6.03803088e-08, 6.72933931e-14, 6.03803088e-08, 1),
    ["❄️ ICE SPOT 2"] = CFrame.new(2158.37769, 6.54998732, 3292.3479, 0.958013594, 1.84155073e-08, 0.286722839, 5.12075538e-09, 1, -8.13372978e-08, -0.286722839, 7.93904746e-08, 0.958013594),
    ["❄️ ICE SPOT 3"] = CFrame.new(1821.93396, 5.7885952, 3307.88354, -0.275288999, -1.52393014e-08, -0.961361527, 9.61536006e-09, 1, -1.86051814e-08, 0.961361527, -1.43656385e-08, -0.275288999),
    ["❄️ ICE SPOT 4"] = CFrame.new(1757.5542, 2.29998755, 3354.91016, 0.251961768, -1.30407338e-08, -0.967737198, -2.79213608e-09, 1, -1.4202457e-08, 0.967737198, 6.28052987e-09, 0.251961768),
    ["🌋 CRATER 1"] = CFrame.new(990.450012, 21.0654697, 5059.8501, 1, -5.1943907e-09, 1.16218545e-13, 5.1943907e-09, 1, -7.90943986e-08, -1.158077e-13, 7.90943986e-08, 1),
    ["🌋 CRATER 2"] = CFrame.new(1024.99792, 21.0788174, 5073.79395, 0.434030503, 1.20942669e-08, -0.900898159, 7.03851821e-09, 1, 1.68156618e-08, 0.900898159, -1.36394984e-08, 0.434030503),
    ["🌴 TROPICAL 1"] = CFrame.new(-2094.37012, 6.26734686, 3655.16553, -0.486001462, -8.67692052e-09, 0.873957992, 3.07231107e-09, 1, 1.16367938e-08, -0.873957992, 8.34056912e-09, -0.486001462),
    ["🌴 TROPICAL 2"] = CFrame.new(-2142.11548, 56.8139801, 3586.90649, 0.999958813, -8.09950436e-08, 0.00907468796, 8.12141465e-08, 1, -2.37761686e-08, -0.00907468796, 2.45121825e-08, 0.999958813),
    ["🌴 TROPICAL 3"] = CFrame.new(-2172.46704, 53.4864883, 3632.33105, -0.383019805, -1.82884214e-08, -0.923740149, -4.49973463e-08, 1, -1.14052334e-09, 0.923740149, 4.11290131e-08, -0.383019805),
    ["🗿 STONE"] = CFrame.new(-2747.64673, 45.9780655, 16.6840172, -0.00579433842, 4.90790253e-09, 0.999983191, 3.36297923e-08, 1, -4.71311923e-09, -0.999983191, 3.36019177e-08, -0.00579433842),
    ["⚙️ MACHINE 1"] = CFrame.new(-1574.53406, 20.1230869, 1904.87927, -0.610550761, -4.70706922e-08, -0.791977108, -2.75718932e-08, 1, -3.81786904e-08, 0.791977108, -1.47372015e-09, -0.610550761),
    ["⚙️ MACHINE 2"] = CFrame.new(-1551.46045, 2.87499976, 1920.12659, -0.981727481, -3.0459212e-08, -0.190292269, -1.58499756e-08, 1, -7.82945833e-08, 0.190292269, -7.3847815e-08, -0.981727481)
}

for loc, cframe in pairs(DefaultLocations) do
    RandomLocationFeature.locations[loc] = true -- default ON
end
RandomLocationFeature.cframes = DefaultLocations

-- UI builder (parent = Tab Fitur frame)
function RandomLocationFeature.CreateUI(parent)
    local numLocations = 0
    for _ in pairs(RandomLocationFeature.locations) do
        numLocations = numLocations + 1
    end
    local calculatedHeight = 95 + (numLocations * 24)

    local section = Instance.new("Frame", parent)
    section.Size = UDim2.new(1, -10, 0, calculatedHeight)
    section.Position = UDim2.new(0, 5, 0, 30) 
    section.BackgroundColor3 = Color3.fromRGB(45,45,52)
    section.BorderSizePixel = 0
    Instance.new("UICorner", section)

    local title = Instance.new("TextLabel", section)
    title.Size = UDim2.new(1, -20, 0, 25)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.Text = "🗺️ Random Location Teleport"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextColor3 = Color3.fromRGB(100,200,255)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- Interval input
    local intervalLabel = Instance.new("TextLabel", section)
    intervalLabel.Size = UDim2.new(0.5, -10, 0, 20)
    intervalLabel.Position = UDim2.new(0, 10, 0, 35)
    intervalLabel.Text = "Interval (detik):"
    intervalLabel.Font = Enum.Font.Gotham
    intervalLabel.TextSize = 12
    intervalLabel.TextColor3 = Color3.fromRGB(200,200,200)
    intervalLabel.BackgroundTransparency = 1
    intervalLabel.TextXAlignment = Enum.TextXAlignment.Left

    local intervalBox = Instance.new("TextBox", section)
    intervalBox.Size = UDim2.new(0.2, 0, 0, 20)
    intervalBox.Position = UDim2.new(0.5, 0, 0, 35)
    intervalBox.Text = tostring(RandomLocationFeature.interval)
    intervalBox.Font = Enum.Font.Gotham
    intervalBox.TextSize = 12
    intervalBox.TextColor3 = Color3.fromRGB(255,255,255)
    intervalBox.BackgroundColor3 = Color3.fromRGB(35,35,42)
    intervalBox.ClearTextOnFocus = false
    Instance.new("UICorner", intervalBox)
    intervalBox.FocusLost:Connect(function()
        local val = tonumber(intervalBox.Text)
        if val and val > 0 then
            RandomLocationFeature.interval = val
        else
            intervalBox.Text = tostring(RandomLocationFeature.interval)
        end
    end)

    -- Daftar lokasi dengan toggle (Checkbox style)
    local y = 95
    local locationNames = {}
    for loc in pairs(RandomLocationFeature.locations) do
        table.insert(locationNames, loc)
    end
    table.sort(locationNames)
    for _, loc in ipairs(locationNames) do
        local on = RandomLocationFeature.locations[loc]
        local cb = Instance.new("TextButton", section)
        cb.Size = UDim2.new(0.8, 0, 0, 20)
        cb.Position = UDim2.new(0, 10, 0, y)
        cb.Text = (on and "[✓] " or "[ ] ") .. loc
        cb.Font = Enum.Font.Gotham
        cb.TextSize = 12
        cb.TextColor3 = on and Color3.fromRGB(100,255,100) or Color3.fromRGB(200,200,200)
        cb.BackgroundColor3 = Color3.fromRGB(35,35,42)
        cb.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", cb)
        cb.MouseButton1Click:Connect(function()
            RandomLocationFeature.locations[loc] = not RandomLocationFeature.locations[loc]
            local state = RandomLocationFeature.locations[loc]
            cb.Text = (state and "[✓] " or "[ ] ") .. loc
            cb.TextColor3 = state and Color3.fromRGB(100,255,100) or Color3.fromRGB(200,200,200)
        end)
        y = y + 24
    end

    -- Tombol utama ON/OFF
    local toggleBtn = Instance.new("TextButton", section)
    toggleBtn.Size = UDim2.new(0.4, 0, 0, 30)
    toggleBtn.Position = UDim2.new(0.55, 0, 0, 60)
    toggleBtn.Text = RandomLocationFeature.enabled and "Matikan" or "Aktifkan"
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 13
    toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
    toggleBtn.BackgroundColor3 = RandomLocationFeature.enabled and Color3.fromRGB(255,100,100) or Color3.fromRGB(100,255,100)
    Instance.new("UICorner", toggleBtn)
    toggleBtn.MouseButton1Click:Connect(function()
        RandomLocationFeature.enabled = not RandomLocationFeature.enabled
        toggleBtn.Text = RandomLocationFeature.enabled and "Matikan" or "Aktifkan"
        toggleBtn.BackgroundColor3 = RandomLocationFeature.enabled and Color3.fromRGB(255,100,100) or Color3.fromRGB(100,255,100)
        if RandomLocationFeature.enabled then
            RandomLocationFeature.Start()
        else
            RandomLocationFeature.Stop()
        end
    end)

    return section
end

function RandomLocationFeature.Start()
    if RandomLocationFeature.running then return end
    RandomLocationFeature.running = true
    RandomLocationFeature.thread = task.spawn(function()
        while RandomLocationFeature.enabled do
            local available = {}
            for loc, on in pairs(RandomLocationFeature.locations) do
                if on then table.insert(available, loc) end
            end
            if #available > 0 then
                local idx = math.random(1, #available)
                local loc = available[idx]
                -- Teleport logic: gunakan CFrame dari data
                local cframe = RandomLocationFeature.cframes[loc]
                if _G.TeleportTo then
                    _G.TeleportTo(cframe)
                elseif game.Players and game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    if cframe and typeof(cframe) == "CFrame" then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
                    end
                end
            end
            task.wait(RandomLocationFeature.interval)
        end
        RandomLocationFeature.running = false
    end)
end

function RandomLocationFeature.Stop()
    RandomLocationFeature.enabled = false
    RandomLocationFeature.running = false
    if RandomLocationFeature.thread then
        task.cancel(RandomLocationFeature.thread)
        RandomLocationFeature.thread = nil
    end
end

return RandomLocationFeature
