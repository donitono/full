-- SettingTabFeature.lua
-- Tab Setting: Boost FPS, HDR Shader, Server Hop, Small Server

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

local SettingTabFeature = {
    boostFPS = false,
    hdrShader = false
}

-- Boost FPS: turunkan kualitas grafis
local function setBoostFPS(enable)
    SettingTabFeature.boostFPS = enable
    if enable then
        -- Matikan efek visual berat
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("BloomEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("BlurEffect") then
                v.Enabled = false
            end
        end
        Lighting.FogEnd = 1000
        Lighting.Brightness = 1
        -- Turunkan kualitas texture terrain
        if workspace:FindFirstChildOfClass("Terrain") then
            workspace.Terrain.WaterWaveSize = 0
            workspace.Terrain.WaterWaveSpeed = 0
            workspace.Terrain.WaterReflectance = 0
            workspace.Terrain.WaterTransparency = 1
        end
        -- Matikan Shadows
        Lighting.GlobalShadows = false
    else
        -- Kembalikan efek visual
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("BloomEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("BlurEffect") then
                v.Enabled = true
            end
        end
        Lighting.FogEnd = 10000
        Lighting.Brightness = 2
        if workspace:FindFirstChildOfClass("Terrain") then
            workspace.Terrain.WaterWaveSize = 2
            workspace.Terrain.WaterWaveSpeed = 22
            workspace.Terrain.WaterReflectance = 1
            workspace.Terrain.WaterTransparency = 0.7
        end
        Lighting.GlobalShadows = true
    end
end

-- HDR Shader: efek visual
local function setHDRShader(enable)
    SettingTabFeature.hdrShader = enable
    if enable then
        -- Tambahkan efek HDR
        if not Lighting:FindFirstChild("_AutoHDR") then
            local cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "_AutoHDR"
            cc.Contrast = 0.2
            cc.Brightness = 0.1
            cc.Saturation = 0.2
            cc.Parent = Lighting
            local bloom = Instance.new("BloomEffect")
            bloom.Name = "_AutoHDRBloom"
            bloom.Intensity = 0.2
            bloom.Size = 56
            bloom.Threshold = 1.5
            bloom.Parent = Lighting
        end
    else
        -- Hapus efek HDR
        if Lighting:FindFirstChild("_AutoHDR") then Lighting._AutoHDR:Destroy() end
        if Lighting:FindFirstChild("_AutoHDRBloom") then Lighting._AutoHDRBloom:Destroy() end
    end
end

-- Server Hop: pindah ke server acak
local function serverHop()
    local placeId = game.PlaceId
    local servers = {}
    local req = syn and syn.request or http_request or request
    if req then
        local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", placeId)
        local res = req({Url = url, Method = "GET"})
        if res and res.Body then
            local data = game:GetService("HttpService"):JSONDecode(res.Body)
            for _, server in ipairs(data.data) do
                if server.playing < server.maxPlayers and server.id ~= game.JobId then
                    table.insert(servers, server.id)
                end
            end
        end
    end
    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(placeId, servers[math.random(1, #servers)], LocalPlayer)
    end
end

-- Small Server: cari server dengan player sedikit
local function smallServerHop()
    local placeId = game.PlaceId
    local servers = {}
    local minPlayers = math.huge
    local bestServer = nil
    local req = syn and syn.request or http_request or request
    if req then
        local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", placeId)
        local res = req({Url = url, Method = "GET"})
        if res and res.Body then
            local data = game:GetService("HttpService"):JSONDecode(res.Body)
            for _, server in ipairs(data.data) do
                if server.playing < minPlayers and server.id ~= game.JobId then
                    minPlayers = server.playing
                    bestServer = server.id
                end
            end
        end
    end
    if bestServer then
        TeleportService:TeleportToPlaceInstance(placeId, bestServer, LocalPlayer)
    end
end

-- UI builder
function SettingTabFeature.CreateUI(parent)
    local section = Instance.new("Frame", parent)
    section.Size = UDim2.new(1, -10, 0, 180)
    section.Position = UDim2.new(0, 5, 0, 10)
    section.BackgroundColor3 = Color3.fromRGB(45,45,52)
    section.BorderSizePixel = 0
    Instance.new("UICorner", section)

    local title = Instance.new("TextLabel", section)
    title.Size = UDim2.new(1, -20, 0, 25)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.Text = "⚙️ Setting"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- Boost FPS
    local boostBtn = Instance.new("TextButton", section)
    boostBtn.Size = UDim2.new(0.45, 0, 0, 28)
    boostBtn.Position = UDim2.new(0, 10, 0, 40)
    boostBtn.Text = "Boost FPS: OFF"
    boostBtn.Font = Enum.Font.Gotham
    boostBtn.TextSize = 12
    boostBtn.TextColor3 = Color3.fromRGB(255,255,255)
    boostBtn.BackgroundColor3 = Color3.fromRGB(80,180,100)
    Instance.new("UICorner", boostBtn)
    boostBtn.MouseButton1Click:Connect(function()
        SettingTabFeature.boostFPS = not SettingTabFeature.boostFPS
        setBoostFPS(SettingTabFeature.boostFPS)
        boostBtn.Text = "Boost FPS: " .. (SettingTabFeature.boostFPS and "ON" or "OFF")
        boostBtn.BackgroundColor3 = SettingTabFeature.boostFPS and Color3.fromRGB(100,255,100) or Color3.fromRGB(80,180,100)
    end)

    -- HDR Shader
    local hdrBtn = Instance.new("TextButton", section)
    hdrBtn.Size = UDim2.new(0.45, 0, 0, 28)
    hdrBtn.Position = UDim2.new(0.5, 10, 0, 40)
    hdrBtn.Text = "HDR Shader: OFF"
    hdrBtn.Font = Enum.Font.Gotham
    hdrBtn.TextSize = 12
    hdrBtn.TextColor3 = Color3.fromRGB(255,255,255)
    hdrBtn.BackgroundColor3 = Color3.fromRGB(80,120,180)
    Instance.new("UICorner", hdrBtn)
    hdrBtn.MouseButton1Click:Connect(function()
        SettingTabFeature.hdrShader = not SettingTabFeature.hdrShader
        setHDRShader(SettingTabFeature.hdrShader)
        hdrBtn.Text = "HDR Shader: " .. (SettingTabFeature.hdrShader and "ON" or "OFF")
        hdrBtn.BackgroundColor3 = SettingTabFeature.hdrShader and Color3.fromRGB(100,200,255) or Color3.fromRGB(80,120,180)
    end)

    -- Server Hop
    local hopBtn = Instance.new("TextButton", section)
    hopBtn.Size = UDim2.new(0.45, 0, 0, 28)
    hopBtn.Position = UDim2.new(0, 10, 0, 80)
    hopBtn.Text = "Server Hop"
    hopBtn.Font = Enum.Font.Gotham
    hopBtn.TextSize = 12
    hopBtn.TextColor3 = Color3.fromRGB(255,255,255)
    hopBtn.BackgroundColor3 = Color3.fromRGB(180,120,80)
    Instance.new("UICorner", hopBtn)
    hopBtn.MouseButton1Click:Connect(function()
        hopBtn.Text = "Hopping..."
        serverHop()
    end)

    -- Small Server
    local smallBtn = Instance.new("TextButton", section)
    smallBtn.Size = UDim2.new(0.45, 0, 0, 28)
    smallBtn.Position = UDim2.new(0.5, 10, 0, 80)
    smallBtn.Text = "Small Server"
    smallBtn.Font = Enum.Font.Gotham
    smallBtn.TextSize = 12
    smallBtn.TextColor3 = Color3.fromRGB(255,255,255)
    smallBtn.BackgroundColor3 = Color3.fromRGB(180,180,80)
    Instance.new("UICorner", smallBtn)
    smallBtn.MouseButton1Click:Connect(function()
        smallBtn.Text = "Finding..."
        smallServerHop()
    end)

    return section
end

return SettingTabFeature
