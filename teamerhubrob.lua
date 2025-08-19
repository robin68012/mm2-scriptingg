-- Teamer Hub Fan (Eclipse Style)
-- LocalScript dans StarterGui

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "TeamerHubFan"
gui.ResetOnSpawn = false

-- THEME
local THEME = {
    bg = Color3.fromRGB(20,20,28),
    panel = Color3.fromRGB(28,28,38),
    card = Color3.fromRGB(36,36,50),
    text = Color3.fromRGB(230,230,240),
    sub = Color3.fromRGB(160,160,180),
    accent = Color3.fromRGB(0,230,200),
    accentOn = Color3.fromRGB(0,200,100),
    stroke = Color3.fromRGB(45,50,70)
}

-- Window
local win = Instance.new("Frame", gui)
win.Size = UDim2.new(0, 700, 0, 420)
win.Position = UDim2.new(0.5,-350,0.5,-210)
win.BackgroundColor3 = THEME.bg
win.Active = true
win.Draggable = true
Instance.new("UICorner", win).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke", win)
stroke.Color = THEME.stroke
stroke.Thickness = 2

-- Title
local title = Instance.new("TextLabel", win)
title.Size = UDim2.new(1,0,0,32)
title.BackgroundTransparency = 1
title.Text = "Teamer Hub Fan"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = THEME.text

-- Tabs
local tabs = Instance.new("Frame", win)
tabs.Size = UDim2.new(0,140,1,-32)
tabs.Position = UDim2.new(0,0,0,32)
tabs.BackgroundColor3 = THEME.panel
Instance.new("UICorner", tabs).CornerRadius = UDim.new(0,12)

local content = Instance.new("Frame", win)
content.Size = UDim2.new(1,-150,1,-42)
content.Position = UDim2.new(0,150,0,38)
content.BackgroundTransparency = 1

local card = Instance.new("Frame", content)
card.Size = UDim2.new(1,-20,1,-20)
card.Position = UDim2.new(0,10,0,10)
card.BackgroundColor3 = THEME.card
Instance.new("UICorner", card).CornerRadius = UDim.new(0,12)

local cardList = Instance.new("UIListLayout", card)
cardList.Padding = UDim.new(0,8)

-- Tab Buttons
local panels = {}
local current

local function makeTab(name)
    local b = Instance.new("TextButton", tabs)
    b.Size = UDim2.new(1,-20,0,32)
    b.Position = UDim2.new(0,10,0, (#tabs:GetChildren()-1)*36)
    b.BackgroundColor3 = THEME.card
    b.Text = name
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 15
    b.TextColor3 = THEME.text
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

    b.MouseButton1Click:Connect(function()
        for _,btn in ipairs(tabs:GetChildren()) do
            if btn:IsA("TextButton") then
                btn.TextColor3 = THEME.text
            end
        end
        b.TextColor3 = THEME.accent
        current = name
        panels[name]()
    end)
    return b
end

-- Helpers
local function clearCard()
    for _,c in ipairs(card:GetChildren()) do
        if c:IsA("GuiObject") then c:Destroy() end
    end
    cardList = Instance.new("UIListLayout", card)
    cardList.Padding = UDim.new(0,8)
end

local function ToggleRow(parent, labelText, callback)
    local row = Instance.new("TextButton", parent)
    row.Size = UDim2.new(1,-20,0,34)
    row.BackgroundColor3 = THEME.panel
    row.Text = labelText
    row.TextColor3 = THEME.text
    row.Font = Enum.Font.Gotham
    row.TextSize = 15
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)

    local enabled = false
    row.MouseButton1Click:Connect(function()
        enabled = not enabled
        row.BackgroundColor3 = enabled and THEME.accentOn or THEME.panel
        callback(enabled)
    end)
end

local function DropdownRow(parent, labelText, list, callback)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,-20,0,34)
    row.BackgroundColor3 = THEME.panel
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)

    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0.5,0,1,0)
    label.Text = labelText
    label.BackgroundTransparency = 1
    label.TextColor3 = THEME.text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14

    local drop = Instance.new("TextButton", row)
    drop.Size = UDim2.new(0.5,-10,1,0)
    drop.Position = UDim2.new(0.5,10,0,0)
    drop.Text = "Select"
    drop.TextColor3 = THEME.sub
    drop.Font = Enum.Font.Gotham
    drop.TextSize = 14
    drop.BackgroundTransparency = 1

    drop.MouseButton1Click:Connect(function()
        local options = list()
        local pick = options[math.random(1,#options)]
        drop.Text = pick
        callback(pick)
    end)
end

-- Features
local activeChams = false
local function updateChams()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local highlight = plr.Character:FindFirstChild("THF_Highlight") or Instance.new("Highlight")
            highlight.Name = "THF_Highlight"
            highlight.FillTransparency = 0.7
            highlight.OutlineTransparency = 0
            highlight.Parent = plr.Character
            if not activeChams then
                highlight.Enabled = false
            else
                highlight.Enabled = true
                if plr.Backpack:FindFirstChild("Knife") or (plr.Character:FindFirstChild("Knife")) then
                    highlight.FillColor = Color3.fromRGB(255,0,0) -- Murder
                elseif plr.Backpack:FindFirstChild("Gun") or (plr.Character:FindFirstChild("Gun")) then
                    highlight.FillColor = Color3.fromRGB(0,0,255) -- Sheriff
                else
                    highlight.FillColor = Color3.fromRGB(0,255,0) -- Innocent
                end
            end
        end
    end
end
RunService.Heartbeat:Connect(updateChams)

-- Grab Gun
local grabGun = false
RunService.Heartbeat:Connect(function()
    if grabGun then
        local gundrop = workspace:FindFirstChild("GunDrop")
        if gundrop and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = gundrop.CFrame
        end
    end
end)

-- Anti Fling
local antiFling = false
RunService.Heartbeat:Connect(function()
    if antiFling and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(0,hrp.Velocity.Y,0)
        hrp.RotVelocity = Vector3.zero
    end
end)

-- Fling
local flingTarget = nil
local flingActive = false
RunService.Heartbeat:Connect(function()
    if flingActive and flingTarget and flingTarget.Character and flingTarget.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local myHRP = player.Character.HumanoidRootPart
        local targetHRP = flingTarget.Character.HumanoidRootPart
        myHRP.CFrame = targetHRP.CFrame
        myHRP.Velocity = Vector3.new(9999,9999,9999)
    end
end)

-- Panels
panels.Misc = function()
    clearCard()
    ToggleRow(card,"Player Chams",function(on) activeChams = on end)
    ToggleRow(card,"Grab Gun",function(on) grabGun = on end)
    DropdownRow(card,"Fling Target",function()
        local list = {}
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then table.insert(list,plr.Name) end
        end
        return list
    end,function(pick)
        flingTarget = Players:FindFirstChild(pick)
    end)
    ToggleRow(card,"Fling Active",function(on) flingActive = on end)
end

panels.Player = function()
    clearCard()
    ToggleRow(card,"Anti Fling",function(on) antiFling = on end)
end

-- Init
makeTab("Misc")
makeTab("Player")
panels.Misc()
