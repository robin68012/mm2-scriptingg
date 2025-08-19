--// Teamer Hub Fan - Eclipse Hub Style
--// UI + Onglets + Boutons visibles

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "TeamerHubFan"
gui.Parent = game.CoreGui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 520, 0, 340)
main.Position = UDim2.new(0.25, 0, 0.25, 0)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 12)

-- TitleBar
local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1, 0, 0, 40)
topbar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
topbar.Parent = main

local topcorner = Instance.new("UICorner", topbar)
topcorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Text = "Teamer Hub Fan"
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(180, 0, 255)
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topbar

-- Tabs Holder
local tabHolder = Instance.new("Frame")
tabHolder.Size = UDim2.new(1, 0, 0, 35)
tabHolder.Position = UDim2.new(0, 0, 0, 40)
tabHolder.BackgroundTransparency = 1
tabHolder.Parent = main

-- Tab buttons
local tabs = {"Player", "Misc", "Target", "Settings"}
local tabFrames = {}
local selectedTab = nil

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 0, 30)
    btn.Position = UDim2.new(0, (i-1)*125 + 10, 0, 0)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.TextColor3 = Color3.fromRGB(200,200,200)
    btn.AutoButtonColor = false
    btn.Parent = tabHolder

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)

    -- Create Tab Frame
    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, -20, 1, -90)
    tabFrame.Position = UDim2.new(0, 10, 0, 80)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false
    tabFrame.Parent = main
    tabFrames[name] = tabFrame

    -- Button select effect
    btn.MouseEnter:Connect(function()
        if selectedTab ~= btn then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60,60,90)}):Play()
        end
    end)

    btn.MouseLeave:Connect(function()
        if selectedTab ~= btn then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,60)}):Play()
        end
    end)

    btn.MouseButton1Click:Connect(function()
        if selectedTab then
            TweenService:Create(selectedTab, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,60)}):Play()
        end
        selectedTab = btn
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120,0,255)}):Play()

        for _, frame in pairs(tabFrames) do
            frame.Visible = false
        end
        tabFrame.Visible = true
    end)
end

-- Function to create styled buttons
local function createButton(parent, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 180, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    btn.TextColor3 = Color3.fromRGB(220,220,220)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 15
    btn.Text = text
    btn.Parent = parent

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(65,65,95)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45,45,65)}):Play()
    end)

    return btn
end

-- Player Tab
local playerFrame = tabFrames["Player"]
createButton(playerFrame, "Anti-Fling").Position = UDim2.new(0, 10, 0, 10)

-- Misc Tab
local miscFrame = tabFrames["Misc"]
createButton(miscFrame, "Chams").Position = UDim2.new(0, 10, 0, 10)
createButton(miscFrame, "Fly").Position = UDim2.new(0, 10, 0, 55)
createButton(miscFrame, "Grab Gun").Position = UDim2.new(0, 10, 0, 100)

-- Target Tab
local targetFrame = tabFrames["Target"]
createButton(targetFrame, "Fling").Position = UDim2.new(0, 10, 0, 10)

-- Settings Tab
local settingsFrame = tabFrames["Settings"]
local label = Instance.new("TextLabel")
label.Text = "UI Toggle: CTRL"
label.Font = Enum.Font.Gotham
label.TextSize = 16
label.TextColor3 = Color3.fromRGB(200,200,200)
label.BackgroundTransparency = 1
label.Size = UDim2.new(0,200,0,30)
label.Position = UDim2.new(0,10,0,10)
label.Parent = settingsFrame

-- Default tab
tabFrames["Player"].Visible = true

-- Toggle avec CTRL
local visible = true
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.LeftControl then
        visible = not visible
        main.Visible = visible
    end
end)
