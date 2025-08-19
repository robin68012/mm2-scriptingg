local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- === UI SETUP ===
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TeamerHubFanUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 170)
frame.Position = UDim2.new(0, 20, 0.5, -85)
frame.BackgroundColor3 = Color3.fromRGB(10, 15, 25)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

-- Glow futuriste
local uiStroke = Instance.new("UIStroke", frame)
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(0, 255, 200)

-- Dégradé néon
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,200,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,150))
}
gradient.Rotation = 45

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "🌌 Teamer Hub Fan 🌌"
title.TextColor3 = Color3.fromRGB(0,255,200)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Fonction bouton design futuriste
local function createButton(text, yPos)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -30, 0, 40)
    btn.Position = UDim2.new(0, 15, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(20,30,45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(0,255,200)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 100, 80)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(20,30,45)
    end)

    return btn
end

-- Boutons
local chamsBtn = createButton("Player Chams: OFF", 50)
local gunDropBtn = createButton("Auto Grab GunDrop: OFF", 100)

-- === INVENTAIRE → COULEUR ===
local function getPlayerColor(plr)
    local backpack = plr:FindFirstChild("Backpack")
    local starterGear = plr:FindFirstChild("StarterGear")

    local items = {}
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            table.insert(items, tool.Name)
        end
    end
    if starterGear then
        for _, tool in ipairs(starterGear:GetChildren()) do
            table.insert(items, tool.Name)
        end
    end

    for _, item in ipairs(items) do
        local name = string.lower(item)
        if name == "knife" then
            return Color3.fromRGB(255,0,0) -- Rouge
        elseif name == "gun" then
            return Color3.fromRGB(0,0,255) -- Bleu
        elseif string.sub(name,1,1) == "a" then
            return Color3.fromRGB(0,255,0) -- Vert
        end
    end
    return Color3.fromRGB(180,180,180) -- Gris
end

-- === AJOUTER / ENLEVER HIGHLIGHT ===
local function applyHighlight(plr)
    if not plr.Character then return end
    if plr.Character:FindFirstChild("RoleHighlight") then
        plr.Character.RoleHighlight:Destroy()
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "RoleHighlight"
    highlight.Parent = plr.Character
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0

    local color = getPlayerColor(plr)
    highlight.FillColor = color
    highlight.OutlineColor = color
end

local function removeHighlight(plr)
    if plr.Character and plr.Character:FindFirstChild("RoleHighlight") then
        plr.Character.RoleHighlight:Destroy()
    end
end

-- === TOGGLE PLAYER CHAMS ===
local chamsEnabled = false
local function refreshHighlights()
    for _, plr in ipairs(Players:GetPlayers()) do
        if chamsEnabled then
            applyHighlight(plr)
        else
            removeHighlight(plr)
        end
    end
end

chamsBtn.MouseButton1Click:Connect(function()
    chamsEnabled = not chamsEnabled
    if chamsEnabled then
        chamsBtn.Text = "Player Chams: ON"
        chamsBtn.BackgroundColor3 = Color3.fromRGB(0,150,100)
    else
        chamsBtn.Text = "Player Chams: OFF"
        chamsBtn.BackgroundColor3 = Color3.fromRGB(20,30,45)
        refreshHighlights()
    end
end)

-- === AUTO-GRAB GUNDROP ===
local autoGrabGun = false
local function pickUp(tool)
    if tool:IsA("Tool") then
        tool.Parent = player.Backpack
        print("Pris :", tool.Name)
    end
end

local function checkForGunDrop()
    if not player.Character then return end
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Tool") and obj.Name == "GunDrop" then
            local distance = (hrp.Position - obj.Position).Magnitude
            if distance < 15 then
                pickUp(obj)
            end
        end
    end
end

gunDropBtn.MouseButton1Click:Connect(function()
    autoGrabGun = not autoGrabGun
    if autoGrabGun then
        gunDropBtn.Text = "Auto Grab GunDrop: ON"
        gunDropBtn.BackgroundColor3 = Color3.fromRGB(0,150,100)
    else
        gunDropBtn.Text = "Auto Grab GunDrop: OFF"
        gunDropBtn.BackgroundColor3 = Color3.fromRGB(20,30,45)
    end
end)

-- === AUTO REFRESH LOOP ===
task.spawn(function()
    while true do
        if chamsEnabled then
            refreshHighlights()
        end
        if autoGrabGun then
            checkForGunDrop()
        end
        task.wait(2)
    end
end)

-- === TOGGLE UI AVEC CTRL ===
local UserInputService = game:GetService("UserInputService")
local uiVisible = true
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.LeftControl then
        uiVisible = not uiVisible
        frame.Visible = uiVisible
    end
end)
