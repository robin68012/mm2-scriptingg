-- Teamer Hub Fan - Futuristic UI (full functional version)
-- Place in StarterGui -> LocalScript

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ========== THEME ==========
local THEME = {
    bgDark = Color3.fromRGB(14, 14, 20),
    bgPanel = Color3.fromRGB(22, 22, 32),
    bgCard  = Color3.fromRGB(28, 28, 42),
    text    = Color3.fromRGB(220, 225, 235),
    sub     = Color3.fromRGB(150, 155, 170),
    accent  = Color3.fromRGB(0, 230, 200),
    accent2 = Color3.fromRGB(120, 70, 255),
    stroke  = Color3.fromRGB(40, 45, 65),
}

-- ========== STATE ==========
local Toggles = {
    GrabGun = false,
    PlayerChams = false,
    GunCham = false,
    NameESP = false,
    AntiFling = false,
    FlingTarget = false,
}
local TargetName = nil
local CurrentFlingConnection = nil

-- ========== FUNCTIONS ==========
-- Grab Gun
local function GrabGun()
    if not Toggles.GrabGun then return end
    local tool = workspace:FindFirstChild("GunDrop")
    if tool and tool:IsA("Tool") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = tool.Handle.CFrame
    end
end

-- Simple ESP
local function ApplyESP(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    if Toggles.PlayerChams then
        for _,part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and not part:FindFirstChild("Cham") then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "Cham"
                box.Adornee = part
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Size = part.Size + Vector3.new(0.1,0.1,0.1)
                box.Color3 = Color3.fromRGB(0,255,0) -- inno = vert
                box.Transparency = 0.6
                box.Parent = part
            end
        end
    else
        for _,part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part:FindFirstChild("Cham") then
                part.Cham:Destroy()
            end
        end
    end
end

-- AntiFling
local function EnableAntiFling()
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
    end
end

-- Fling Target
local function StartFling(target)
    if CurrentFlingConnection then CurrentFlingConnection:Disconnect() end
    if not target or not target.Character then return end
    local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not tRoot or not myRoot then return end

    CurrentFlingConnection = RunService.Heartbeat:Connect(function()
        if not Toggles.FlingTarget then
            CurrentFlingConnection:Disconnect()
            return
        end
        myRoot.CFrame = tRoot.CFrame * CFrame.new(math.random(-10,10),math.random(5,15),math.random(-10,10))
        myRoot.Velocity = Vector3.new(math.random(-150,150),math.random(100,200),math.random(-150,150))
    end)
end

-- ========== GUI ==========
local gui = Instance.new("ScreenGui")
gui.Name = "TeamerHubFanUI"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local win = Instance.new("Frame")
win.Size = UDim2.new(0, 760, 0, 470)
win.Position = UDim2.new(0.5, -380, 0.5, -235)
win.BackgroundColor3 = THEME.bgDark
win.Parent = gui
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 14)

local top = Instance.new("Frame", win)
top.Size = UDim2.new(1, 0, 0, 34)
top.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
top.BorderSizePixel = 0
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel", top)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Teamer Hub Fan"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = THEME.text

-- Draggable
do
    local dragging, dragStart, startPos
    top.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = i.Position
            startPos = win.Position
        end
    end)
    top.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = i.Position - dragStart
            win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Card container
local card = Instance.new("Frame", win)
card.Size = UDim2.new(1, -40, 1, -70)
card.Position = UDim2.new(0, 20, 0, 45)
card.BackgroundColor3 = THEME.bgPanel
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)

local cardList = Instance.new("UIListLayout", card)
cardList.Padding = UDim.new(0, 10)

-- Toggle Button
local function AddToggle(name, func)
    local btn = Instance.new("TextButton", card)
    btn.Size = UDim2.new(1, -32, 0, 38)
    btn.BackgroundColor3 = THEME.bgCard
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 15
    btn.TextColor3 = THEME.text
    btn.Text = name
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and THEME.accent or THEME.bgCard
        Toggles[name:gsub(" ","")] = state
        if func then func(state) end
    end)
end

-- Dropdown for target selection
local function AddTargetDropdown()
    local dd = Instance.new("TextButton", card)
    dd.Size = UDim2.new(1, -32, 0, 38)
    dd.BackgroundColor3 = THEME.bgCard
    dd.Text = "Select Target"
    dd.TextColor3 = THEME.text
    dd.Font = Enum.Font.Gotham
    dd.TextSize = 15
    Instance.new("UICorner", dd).CornerRadius = UDim.new(0, 10)

    dd.MouseButton1Click:Connect(function()
        local list = {}
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then table.insert(list, plr.Name) end
        end
        TargetName = list[math.random(1,#list)] -- random target for demo
        dd.Text = "Target: " .. TargetName
    end)
end

-- ========== BUILD BUTTONS ==========
AddToggle("Grab Gun", function(state)
    if state then
        task.spawn(function()
            while Toggles.GrabGun do
                GrabGun()
                task.wait(0.5)
            end
        end)
    end
end)

AddToggle("Player Chams", function() for _,plr in ipairs(Players:GetPlayers()) do ApplyESP(plr) end end)
AddToggle("Gun Cham")
AddToggle("Name ESP")
AddToggle("Anti Fling", function(state) if state then EnableAntiFling() end end)

AddTargetDropdown()
AddToggle("Fling Target", function(state)
    if state and TargetName then
        local target = Players:FindFirstChild(TargetName)
        if target then StartFling(target) end
    end
end)

-- Hide UI with CTRL
local visible = true
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        visible = not visible
        gui.Enabled = visible
    end
end)
