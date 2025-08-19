-- ======================
-- 🛰️ Teamer Hub Fan (All in one)
-- ======================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- === Setup Remote (coté serveur direct via LocalScript) ===
local GrabGunRemote = ReplicatedStorage:FindFirstChild("GrabGun")
if not GrabGunRemote then
    GrabGunRemote = Instance.new("RemoteEvent")
    GrabGunRemote.Name = "GrabGun"
    GrabGunRemote.Parent = ReplicatedStorage

    -- Script serveur dynamique
    GrabGunRemote.OnServerEvent:Connect(function(plr, gun)
        if gun and gun:IsDescendantOf(workspace) and gun.Name == "GunDrop" then
            local tool = Instance.new("Tool")
            tool.Name = "Gun"
            tool.RequiresHandle = false
            tool.Parent = plr.Backpack
            gun:Destroy()
        end
    end)
end

-- === UI futuriste ===
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TeamerHubFanUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 230, 0, 180)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
frame.BackgroundTransparency = 0.2
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0,255,200)

-- === Drag UI ===
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- === Helper pour boutons ===
local function createButton(text, yPos)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(20,30,45)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Thickness = 1.5
    stroke.Color = Color3.fromRGB(0,255,200)
    return btn
end

-- === Boutons ===
local chamsBtn = createButton("Player Chams: OFF", 20)
local gunDropBtn = createButton("Auto Grab Gun: OFF", 70)

local chamsEnabled = false
local gunGrabEnabled = false

chamsBtn.MouseButton1Click:Connect(function()
    chamsEnabled = not chamsEnabled
    chamsBtn.Text = "Player Chams: " .. (chamsEnabled and "ON" or "OFF")
end)

gunDropBtn.MouseButton1Click:Connect(function()
    gunGrabEnabled = not gunGrabEnabled
    gunDropBtn.Text = "Auto Grab Gun: " .. (gunGrabEnabled and "ON" or "OFF")
end)

-- === Player Chams ===
RunService.Heartbeat:Connect(function()
    if chamsEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local highlight = plr.Character:FindFirstChild("Highlight") or Instance.new("Highlight", plr.Character)
                highlight.Adornee = plr.Character
                highlight.OutlineTransparency = 0
                highlight.FillTransparency = 0.5
                
                local hasKnife, hasGun = false, false
                for _, tool in ipairs(plr.Backpack:GetChildren()) do
                    if tool.Name:lower():find("knife") then hasKnife = true end
                    if tool.Name:lower():find("gun") then hasGun = true end
                end
                for _, tool in ipairs(plr.Character:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name:lower():find("knife") then hasKnife = true end
                    if tool:IsA("Tool") and tool.Name:lower():find("gun") then hasGun = true end
                end

                if hasKnife then
                    highlight.FillColor = Color3.fromRGB(255,0,0) -- rouge
                elseif hasGun then
                    highlight.FillColor = Color3.fromRGB(0,0,255) -- bleu
                else
                    highlight.FillColor = Color3.fromRGB(150,150,150) -- gris
                end
            end
        end
    else
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Highlight") then
                plr.Character.Highlight:Destroy()
            end
        end
    end
end)

-- === Auto Grab GunDrop ===
RunService.Heartbeat:Connect(function()
    if gunGrabEnabled then
        local gun = workspace:FindFirstChild("GunDrop")
        if gun then
            GrabGunRemote:FireServer(gun)
        end
    end
end)

-- === Toggle UI avec Ctrl ===
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.LeftControl then
        frame.Visible = not frame.Visible
    end
end)
