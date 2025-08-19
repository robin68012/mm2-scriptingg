local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- === UI SETUP ===
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TeamerHubFanUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 280)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

-- Glow futuriste
local uiStroke = Instance.new("UIStroke", frame)
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(0, 255, 200)
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Dégradé
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,200,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,150))
}
gradient.Rotation = 90

-- Ombre légère
local shadow = Instance.new("ImageLabel", frame)
shadow.ZIndex = -1
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.new(-0.05, 0, -0.05, 0)
shadow.Size = UDim2.new(1.1, 0, 1.1, 0)
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.6
shadow.ImageColor3 = Color3.fromRGB(0, 255, 200)

-- Titre
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "🌌 Teamer Hub Fan 🌌"
title.TextColor3 = Color3.fromRGB(0,255,200)
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- === Draggable system ===
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

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- === Fonction bouton stylé ===
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

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(0, 100, 80)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(20,30,45)
    end)

    return btn
end

-- === Boutons Exemple ===
local chamsBtn = createButton("Player Chams: OFF", 60)
local gunDropBtn = createButton("Auto Grab GunDrop: OFF", 110)

-- (ici tu colles la logique des chams / gunDrop comme avant)
