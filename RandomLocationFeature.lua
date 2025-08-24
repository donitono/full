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
    ["🌴 TROPICAL 3"] = CFrame.new(-2141.51, 54.65, 3583.64),
    ["🗿 STONE"] = CFrame.new(-2636.19, 124.87, -27.49),
    ["⚙️ MACHINE 1"] = CFrame.new(-1480.98, 3.49, 1923.66),
    ["⚙️ MACHINE 2"] = CFrame.new(-1613.32, 8.13, 1903.20)
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
    for loc, on in pairs(RandomLocationFeature.locations) do
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
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
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
