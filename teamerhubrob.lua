--// Teamer Hub Rework (Eclipse-like) //--
-- Place in StarterGui > LocalScript

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- THEME (Eclipse style)
local THEME = {
    bg = Color3.fromRGB(20,20,20),
    card = Color3.fromRGB(30,30,35),
    stroke = Color3.fromRGB(50,50,60),
    accent = Color3.fromRGB(0, 200, 255),
    text = Color3.fromRGB(230,230,230),
    sub = Color3.fromRGB(160,160,160),
    green = Color3.fromRGB(0,255,100),
    red = Color3.fromRGB(255,50,50),
    blue = Color3.fromRGB(50,120,255),
    gray = Color3.fromRGB(180,180,180)
}

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "TeamerHubUI"
gui.ResetOnSpawn = false
gui.Parent = pgui

-- Window
local win = Instance.new("Frame")
win.Size = UDim2.new(0, 500, 0, 350)
win.Position = UDim2.new(0.5,-250,0.5,-175)
win.BackgroundColor3 = THEME.bg
win.Parent = gui
Instance.new("UICorner", win).CornerRadius = UDim.new(0,12)

local winStroke = Instance.new("UIStroke", win)
winStroke.Color = THEME.stroke
winStroke.Thickness = 2

-- Dragging
do
    local dragging, dragStart, startPos
    win.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = win.Position
        end
    end)
    win.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end)
end

-- Title
local title = Instance.new("TextLabel", win)
title.Text = "Teamer Hub - Eclipse Style"
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.TextColor3 = THEME.text
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Container
local container = Instance.new("Frame", win)
container.Size = UDim2.new(1,-20,1,-50)
container.Position = UDim2.new(0,10,0,40)
container.BackgroundTransparency = 1

local list = Instance.new("UIListLayout", container)
list.Padding = UDim.new(0,10)
list.HorizontalAlignment = Enum.HorizontalAlignment.Center
list.VerticalAlignment = Enum.VerticalAlignment.Top

-- Utility: make toggle row
local function makeToggle(name, callback)
    local row = Instance.new("TextButton")
    row.Size = UDim2.new(1,-20,0,40)
    row.BackgroundColor3 = THEME.card
    row.Text = ""
    row.AutoButtonColor = false
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)
    local stroke = Instance.new("UIStroke", row); stroke.Color = THEME.stroke; stroke.Thickness = 1

    local label = Instance.new("TextLabel", row)
    label.Text = name
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0,10,0,0)
    label.Size = UDim2.new(1,-60,1,0)
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextColor3 = THEME.text
    label.TextXAlignment = Enum.TextXAlignment.Left

    local indicator = Instance.new("Frame", row)
    indicator.Size = UDim2.new(0,24,0,24)
    indicator.Position = UDim2.new(1,-34,0.5,-12)
    indicator.BackgroundColor3 = THEME.red
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1,0)

    local enabled = false
    row.MouseButton1Click:Connect(function()
        enabled = not enabled
        indicator.BackgroundColor3 = enabled and THEME.green or THEME.red
        callback(enabled)
    end)

    return row
end

-- Features states
local espEnabled = false
local grabGun = false
local antiFling = false
local flingTarget = nil
local flingActive = false

-- ESP
local function updateESP()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local char = plr.Character
            if char and char:FindFirstChild("Head") then
                local tag = char.Head:FindFirstChild("ESPTag")
                if not tag then
                    tag = Instance.new("BillboardGui", char.Head)
                    tag.Name = "ESPTag"
                    tag.Size = UDim2.new(0,200,0,50)
                    tag.AlwaysOnTop = true
                    local tl = Instance.new("TextLabel", tag)
                    tl.Size = UDim2.new(1,0,1,0)
                    tl.BackgroundTransparency = 1
                    tl.Font = Enum.Font.GothamBold
                    tl.TextScaled = true
                    tl.TextColor3 = THEME.gray
                    tl.Text = plr.Name
                end
                local tl = tag:FindFirstChildOfClass("TextLabel")
                if espEnabled then
                    -- role check
                    local col = THEME.green
                    local inv = plr:FindFirstChild("Backpack")
                    if inv then
                        if inv:FindFirstChild("Knife") then col = THEME.red end
                        if inv:FindFirstChild("Gun") then col = THEME.blue end
                    end
                    tl.TextColor3 = col
                    tl.Visible = true
                else
                    tl.Visible = false
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(updateESP)

-- Grab Gun
RunService.Heartbeat:Connect(function()
    if grabGun then
        local gd = Workspace:FindFirstChild("GunDrop")
        if gd and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character:MoveTo(gd.Position)
        end
    end
end)

-- AntiFling
RunService.Stepped:Connect(function()
    if antiFling and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new()
        hrp.RotVelocity = Vector3.new()
    end
end)

-- Fling system
local function flingPlayer(target)
    if not target or not target.Character then return end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local thrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp or not thrp then return end
    spawn(function()
        while flingActive and target and target.Character and thrp.Parent do
            hrp.CFrame = thrp.CFrame * CFrame.new(0,0,1)
            hrp.Velocity = Vector3.new(9999,9999,9999)
            task.wait()
        end
    end)
end

-- UI setup
makeToggle("Player ESP", function(on) espEnabled = on end).Parent = container
makeToggle("Grab Gun", function(on) grabGun = on end).Parent = container
makeToggle("Anti Fling", function(on) antiFling = on end).Parent = container

-- Dropdown fling
local dd = Instance.new("TextButton", container)
dd.Size = UDim2.new(1,-20,0,40)
dd.BackgroundColor3 = THEME.card
dd.Text = "Select target"
dd.Font = Enum.Font.Gotham
dd.TextSize = 15
dd.TextColor3 = THEME.text
Instance.new("UICorner", dd).CornerRadius = UDim.new(0,8)

local menu = Instance.new("Frame", container)
menu.Size = UDim2.new(1,-20,0,120)
menu.BackgroundColor3 = THEME.card
menu.Visible = false
Instance.new("UICorner", menu).CornerRadius = UDim.new(0,8)

local list2 = Instance.new("UIListLayout", menu)
list2.Padding = UDim.new(0,5)

dd.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
    menu:ClearAllChildren()
    local l = Instance.new("UIListLayout", menu); l.Padding = UDim.new(0,5)
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local b = Instance.new("TextButton", menu)
            b.Size = UDim2.new(1,-10,0,30)
            b.Text = plr.Name
            b.BackgroundColor3 = THEME.bg
            b.TextColor3 = THEME.text
            b.Font = Enum.Font.Gotham
            b.TextSize = 14
            b.MouseButton1Click:Connect(function()
                flingTarget = plr
                dd.Text = "Target: "..plr.Name
                menu.Visible = false
            end)
        end
    end
end)

makeToggle("Fling Target", function(on)
    flingActive = on
    if on and flingTarget then
        flingPlayer(flingTarget)
    end
end).Parent = container
