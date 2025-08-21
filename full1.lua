-- XSAN Simple UI Test v1.0
print("Starting simple UI test...")

-- Basic services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Simple notification
local function SimpleNotify(title, message)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = message,
        Duration = 3
    })
end

-- Simple UI loading function
local function LoadUI()
    print("Loading UI...")
    
    local success, result = pcall(function()
        local rayfield = game:HttpGet("https://sirius.menu/rayfield", true)
        local uiFunc = loadstring(rayfield)
        return uiFunc()
    end)
    
    if success and result then
        print("UI loaded successfully!")
        return result
    else
        warn("UI loading failed: " .. tostring(result))
        return nil
    end
end

-- Test the UI loading
local Rayfield = LoadUI()

if not Rayfield then
    SimpleNotify("Error", "Failed to load UI library")
    return
end

-- Create simple window
local Window = Rayfield:CreateWindow({
    Name = "XSAN Test UI",
    LoadingTitle = "Testing...",
    LoadingSubtitle = "Simple test",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = false
    },
    KeySystem = false
})

-- Create test tab
local TestTab = Window:CreateTab("Test", 4483362458)

TestTab:CreateParagraph({
    Title = "✅ Success!",
    Content = "UI loaded successfully without errors!"
})

TestTab:CreateButton({
    Name = "Test Button",
    Callback = function()
        SimpleNotify("Success", "Button works!")
    end
})

print("Simple UI test completed successfully!")
