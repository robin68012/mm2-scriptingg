--// Teamer Hub Fan - Eclipse Style
--// Tout en 1 Script

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "TeamerHubFan"
gui.Parent = game.CoreGui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn = false

-- Drag Function
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    RunService.Heartbeat:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 520, 0, 340)
main.Position = UDim2.new(0.25, 0, 0.25, 0)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
main.BorderSizePixel = 0
main.Parent = gui
makeDraggable(main)

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 12)

-- TopBar
local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1, 0, 0, 40)
topbar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
topbar.Parent = main
local topcorner = Instance.new("UICorner", topbar)
topcorner.CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Text = "Teamer Hub Fan"
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(180, 100, 255)
title.TextSize = 20
title.Parent = topbar

-- Tab Buttons
local tabs = Instance.new("Frame", main)
tabs.Position = UDim2.new(0, 0, 0, 40)
tabs.Size = UDim2.new(1, 0, 0, 30)
tabs.BackgroundTransparency = 1

local tabNames = {"Player", "Misc", "Target", "Settings"}
local pages = {}
local currentPage

for i, name in ipairs(tabNames) do
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.Size = UDim2.new(0, 120, 1, 0)
    btn.Position = UDim2.new(0, (i - 1) * 125, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.Parent = tabs

    local page = Instance.new("Frame", main)
    page.Position = UDim2.new(0, 0, 0, 70)
    page.Size = UDim2.new(1, 0, 1, -70)
    page.Visible = false
    page.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    pages[name] = page

    btn.MouseButton1Click:Connect(function()
        if currentPage then currentPage.Visible = false end
        page.Visible = true
        currentPage = page
    end)
end
pages["Player"].Visible = true
currentPage = pages["Player"]

-- Helper to make buttons
local function createButton(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.Text = text
    b.Size = UDim2.new(0, 200, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
    b.TextColor3 = Color3.fromRGB(220, 220, 220)
    b.Font = Enum.Font.Gotham
    b.TextSize = 16
    b.MouseButton1Click:Connect(callback)
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 8)
    return b
end

--// Features
local antiFlingEnabled = false
local flyEnabled = false

-- Anti-Fling
createButton(pages["Player"], "Toggle Anti-Fling", function()
    antiFlingEnabled = not antiFlingEnabled
end).Position = UDim2.new(0, 20, 0, 20)

RunService.Heartbeat:Connect(function()
    if antiFlingEnabled then
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                plr.Character.HumanoidRootPart.RotVelocity = Vector3.new(0,0,0)
            end
        end
    end
end)

-- Fly
local flyConnection
local function toggleFly()
    flyEnabled = not flyEnabled
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if flyEnabled then
        flyConnection = RunService.Heartbeat:Connect(function()
            local dir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + (workspace.CurrentCamera.CFrame.LookVector) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - (workspace.CurrentCamera.CFrame.LookVector) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - (workspace.CurrentCamera.CFrame.RightVector) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + (workspace.CurrentCamera.CFrame.RightVector) end
            hrp.Velocity = dir * 50
        end)
    else
        if flyConnection then flyConnection:Disconnect() end
    end
end

createButton(pages["Misc"], "Toggle Fly", toggleFly).Position = UDim2.new(0, 20, 0, 20)

-- Grab Gun
createButton(pages["Misc"], "Grab Gun", function()
    local gunDrop = workspace:FindFirstChild("GunDrop", true)
    if gunDrop and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = gunDrop.CFrame
    end
end).Position = UDim2.new(0, 20, 0, 70)

-- Chams
local chamsEnabled = false
local function applyChams()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local color = Color3.fromRGB(150, 150, 150) -- gris par défaut
            if plr.Backpack:FindFirstChild("Knife") or (plr.Character:FindFirstChild("Knife")) then
                color = Color3.fromRGB(255,0,0)
            elseif plr.Backpack:FindFirstChild("Gun") or (plr.Character:FindFirstChild("Gun")) then
                color = Color3.fromRGB(0,0,255)
            else
                color = Color3.fromRGB(0,255,0) -- inno vert
            end
            for _, part in pairs(plr.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    local highlight = part:FindFirstChild("Cham") or Instance.new("BoxHandleAdornment")
                    highlight.Name = "Cham"
                    highlight.AlwaysOnTop = true
                    highlight.ZIndex = 5
                    highlight.Size = part.Size + Vector3.new(0.1,0.1,0.1)
                    highlight.Adornee = part
                    highlight.Color3 = color
                    highlight.Transparency = 0.5
                    highlight.Parent = part
                end
            end
        end
    end
end

createButton(pages["Misc"], "Toggle Chams", function()
    chamsEnabled = not chamsEnabled
end).Position = UDim2.new(0, 20, 0, 120)

task.spawn(function()
    while task.wait(5) do
        if chamsEnabled then
            applyChams()
        end
    end
end)

-- Target Tab (Fling)
createButton(pages["Target"], "Fling Nearest", function()
    local nearest, dist = nil, math.huge
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local mag = (plr.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if mag < dist then
                dist = mag
                nearest = plr
            end
        end
    end
    if nearest then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        hrp.CFrame = nearest.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,1)
        hrp.Velocity = Vector3.new(9999,9999,9999)
    end
end).Position = UDim2.new(0, 20, 0, 20)

-- Settings Tab
createButton(pages["Settings"], "Toggle UI (CTRL)", function()
    gui.Enabled = not gui.Enabled
end).Position = UDim2.new(0, 20, 0, 20)

-- CTRL toggle
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.LeftControl then
        gui.Enabled = not gui.Enabled
    end
end)
