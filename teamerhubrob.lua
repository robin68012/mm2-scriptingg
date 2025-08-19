local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- === UI SETUP ===
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TeamerHubFanUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 160)
frame.Position = UDim2.new(0, 20, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(15,15,25)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Teamer Hub Fan"
title.TextColor3 = Color3.fromRGB(0,255,200)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- === Bouton Player Chams ===
local chamsBtn = Instance.new("TextButton", frame)
chamsBtn.Size = UDim2.new(1, -20, 0, 40)
chamsBtn.Position = UDim2.new(0, 10, 0, 50)
chamsBtn.BackgroundColor3 = Color3.fromRGB(30,30,45)
chamsBtn.Text = "Player Chams: OFF"
chamsBtn.TextColor3 = Color3.fromRGB(255,255,255)
chamsBtn.Font = Enum.Font.GothamSemibold
chamsBtn.TextSize = 16
Instance.new("UICorner", chamsBtn).CornerRadius = UDim.new(0, 8)

-- === Bouton Auto Grab GunDrop ===
local gunDropBtn = Instance.new("TextButton", frame)
gunDropBtn.Size = UDim2.new(1, -20, 0, 40)
gunDropBtn.Position = UDim2.new(0, 10, 0, 100)
gunDropBtn.BackgroundColor3 = Color3.fromRGB(30,30,45)
gunDropBtn.Text = "Auto Grab GunDrop: OFF"
gunDropBtn.TextColor3 = Color3.fromRGB(255,255,255)
gunDropBtn.Font = Enum.Font.GothamSemibold
gunDropBtn.TextSize = 16
Instance.new("UICorner", gunDropBtn).CornerRadius = UDim.new(0, 8)

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
        chamsBtn.BackgroundColor3 = Color3.fromRGB(30,30,45)
        refreshHighlights()
    end
end)

-- === AUTO-GRAB GUNDROP ===
local humanoidRootPart = player.Character or player.CharacterAdded:Wait()
humanoidRootPart = humanoidRootPart:WaitForChild("HumanoidRootPart")

local autoGrabGun = false

local function pickUp(tool)
    if tool:IsA("Tool") then
        tool.Parent = player.Backpack
        print("Pris :", tool.Name)
    end
end

local function checkForGunDrop()
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Tool") and obj.Name == "GunDrop" then
            local distance = (humanoidRootPart.Position - obj.Position).Magnitude
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
        gunDropBtn.BackgroundColor3 = Color3.fromRGB(30,30,45)
    end
end)

-- === AUTO REFRESH LOOP ===
while true do
    if chamsEnabled then
        refreshHighlights()
    end
    if autoGrabGun then
        checkForGunDrop()
    end
    task.wait(2)
end
