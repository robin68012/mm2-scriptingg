--// TEAMER HUB FAN v1
-- Draggable UI + Features (MM2-Like)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Création UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeamerHubFan"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 500, 0, 320)
Frame.Position = UDim2.new(0.25, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Name = "MainFrame"

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 12)

-- Titre
local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "TEAMER HUB FAN"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Toggle avec Ctrl
local visible = true
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.LeftControl then
        visible = not visible
        ScreenGui.Enabled = visible
    end
end)

-- Création Tabs
local Tabs = Instance.new("Frame", Frame)
Tabs.Size = UDim2.new(0, 100, 1, -40)
Tabs.Position = UDim2.new(0, 0, 0, 40)
Tabs.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
local UIListLayout = Instance.new("UIListLayout", Tabs)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createTabButton(name)
    local btn = Instance.new("TextButton", Tabs)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)
    return btn
end

local Pages = Instance.new("Frame", Frame)
Pages.Size = UDim2.new(1, -100, 1, -40)
Pages.Position = UDim2.new(0, 100, 0, 40)
Pages.BackgroundTransparency = 1

local function createPage(name)
    local page = Instance.new("Frame", Pages)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Name = name
    return page
end

-- Pages
local mainPage = createPage("Main")
local targetPage = createPage("Target")
local miscPage = createPage("Misc")
local playerPage = createPage("Player")
local settingsPage = createPage("Settings")

-- Buttons Tabs
local mainBtn = createTabButton("Main")
local targetBtn = createTabButton("Target")
local miscBtn = createTabButton("Misc")
local playerBtn = createTabButton("Player")
local settingsBtn = createTabButton("Settings")

local currentPage = mainPage
currentPage.Visible = true

local function switchPage(page)
    currentPage.Visible = false
    currentPage = page
    currentPage.Visible = true
end

mainBtn.MouseButton1Click:Connect(function() switchPage(mainPage) end)
targetBtn.MouseButton1Click:Connect(function() switchPage(targetPage) end)
miscBtn.MouseButton1Click:Connect(function() switchPage(miscPage) end)
playerBtn.MouseButton1Click:Connect(function() switchPage(playerPage) end)
settingsBtn.MouseButton1Click:Connect(function() switchPage(settingsPage) end)

-- Fonction utilitaire pour créer des toggles
local function createToggle(parent, name, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Text = name .. ": OFF"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.AutoButtonColor = true
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        btn.Text = name .. (enabled and ": ON" or ": OFF")
        callback(enabled)
    end)
end

-- Highlight system
local highlightFolder = Instance.new("Folder", workspace)
highlightFolder.Name = "ChamsFolder"

local function clearChams()
    for _,c in pairs(highlightFolder:GetChildren()) do c:Destroy() end
end

local function applyCham(player, roleColor, textTag)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hl = Instance.new("Highlight")
        hl.FillColor = roleColor
        hl.OutlineColor = Color3.fromRGB(255,255,255)
        hl.Adornee = player.Character
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = highlightFolder

        local billboard = Instance.new("BillboardGui")
        billboard.Size = UDim2.new(0,100,0,20)
        billboard.StudsOffset = Vector3.new(0,3,0)
        billboard.AlwaysOnTop = true
        billboard.Parent = player.Character.HumanoidRootPart

        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextSize = 14
        label.TextColor3 = roleColor
        label.Text = player.Name .. " | " .. textTag
    end
end

local function detectRoles()
    clearChams()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr.Character then
            local tag = "Innocent"
            local color = Color3.fromRGB(0,255,0) -- vert

            local knife = plr.Backpack:FindFirstChild("Knife") or plr.Character:FindFirstChild("Knife")
            if knife then
                tag = "Murder"
                color = Color3.fromRGB(255,0,0)
            end

            local gun = plr.Backpack:FindFirstChild("Gun") or plr.Character:FindFirstChild("Gun")
            if gun then
                tag = "Sheriff"
                color = Color3.fromRGB(0,150,255)
            end

            if plr:FindFirstChild("Power") then
                tag = tag .. " | Power: " .. plr.Power.Value
                color = Color3.fromRGB(150,0,255)
            end

            applyCham(plr, color, tag)
        end
    end
end

-- Grab Gun
local grabGunEnabled = false
RunService.Heartbeat:Connect(function()
    if grabGunEnabled then
        local gundrop = workspace:FindFirstChild("GunDrop")
        if gundrop and gundrop:IsA("Tool") then
            gundrop.Parent = LocalPlayer.Backpack
        end
    end
end)

-- Anti-Fling
local antiFlingEnabled = false
RunService.Heartbeat:Connect(function()
    if antiFlingEnabled then
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                end
            end
        end
    end
end)

-- Toggles dans Misc
createToggle(miscPage, "Chams", function(state)
    if state then
        task.spawn(function()
            while state do
                detectRoles()
                task.wait(5)
            end
        end)
    else
        clearChams()
    end
end)

createToggle(miscPage, "Grab Gun", function(state)
    grabGunEnabled = state
end)

-- Toggles dans Player
createToggle(playerPage, "Anti-Fling", function(state)
    antiFlingEnabled = state
end)
