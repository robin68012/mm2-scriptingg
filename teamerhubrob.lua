-- MM2 Premium UI Only
-- This is just a UI with no functionality
-- For educational purposes only

-- Create UI container
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2PremiumUI"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- UI Variables
local GUI = {}
GUI.MouseOffset = nil
GUI.Dragging = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 350)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- Apply Rounded Corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Apply Glow Effect
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(128, 0, 255)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.2
UIStroke.Parent = MainFrame

-- Create Background Gradient
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 0, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 0, 30))
})
UIGradient.Rotation = 135
UIGradient.Parent = MainFrame

-- Header Frame
local HeaderFrame = Instance.new("Frame")
HeaderFrame.Name = "HeaderFrame"
HeaderFrame.Size = UDim2.new(1, 0, 0, 40)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(15, 5, 25)
HeaderFrame.BackgroundTransparency = 0.3
HeaderFrame.BorderSizePixel = 0
HeaderFrame.Parent = MainFrame

-- Header Corner Rounding
local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = HeaderFrame

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.Size = UDim2.new(0, 160, 0, 30)
TitleText.Position = UDim2.new(0, 15, 0, 5)
TitleText.BackgroundTransparency = 1
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "MM2 Premium"
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = HeaderFrame

-- Title Text Gradient
local TitleGradient = Instance.new("UIGradient")
TitleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 255))
})
TitleGradient.Parent = TitleText

-- Version Label
local VersionLabel = Instance.new("TextLabel")
VersionLabel.Name = "VersionLabel"
VersionLabel.Size = UDim2.new(0, 50, 0, 20)
VersionLabel.Position = UDim2.new(1, -60, 0, 10)
VersionLabel.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
VersionLabel.Font = Enum.Font.GothamBold
VersionLabel.Text = "v3.5"
VersionLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
VersionLabel.TextSize = 12
VersionLabel.Parent = HeaderFrame

-- Version Label Rounding
local VersionCorner = Instance.new("UICorner")
VersionCorner.CornerRadius = UDim.new(0, 8)
VersionCorner.Parent = VersionLabel

-- Version Label Gradient
local VersionGradient = Instance.new("UIGradient")
VersionGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 140, 0))
})
VersionGradient.Rotation = 45
VersionGradient.Parent = VersionLabel

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 22, 0, 22)
CloseButton.Position = UDim2.new(1, -25, 0, 9)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.Text = "×"  -- Close symbol
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 16
CloseButton.Parent = HeaderFrame

-- Close Button Rounding
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- Content Container
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -30, 1, -55)
ContentFrame.Position = UDim2.new(0, 15, 0, 45)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Divider Line
local Divider = Instance.new("Frame")
Divider.Name = "Divider"
Divider.Size = UDim2.new(1, 0, 0, 1)
Divider.Position = UDim2.new(0, 0, 0, 0)
Divider.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
Divider.BackgroundTransparency = 0.7
Divider.BorderSizePixel = 0
Divider.Parent = ContentFrame

-- Feature Functions - Create toggle UI only
local function CreateToggle(name, position, startEnabled)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = name .. "Toggle"
    ToggleFrame.Size = UDim2.new(1, 0, 0, 36)
    ToggleFrame.Position = position
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 10, 40)
    ToggleFrame.BackgroundTransparency = 0.6
    ToggleFrame.Parent = ContentFrame
    
    -- Toggle Frame Rounding
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    -- Toggle Label
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Size = UDim2.new(0, 200, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = name
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    -- Toggle Switch
    local SwitchFrame = Instance.new("Frame")
    SwitchFrame.Name = "SwitchFrame"
    SwitchFrame.Size = UDim2.new(0, 44, 0, 22)
    SwitchFrame.Position = UDim2.new(1, -55, 0.5, -11)
    SwitchFrame.BackgroundColor3 = startEnabled and Color3.fromRGB(128, 0, 255) or Color3.fromRGB(40, 40, 60)
    SwitchFrame.Parent = ToggleFrame
    
    -- Switch Rounding
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = SwitchFrame
    
    -- Toggle Knob
    local ToggleKnob = Instance.new("Frame")
    ToggleKnob.Name = "Knob"
    ToggleKnob.Size = UDim2.new(0, 18, 0, 18)
    ToggleKnob.Position = startEnabled and UDim2.new(0, 23, 0, 2) or UDim2.new(0, 3, 0, 2)
    ToggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleKnob.Parent = SwitchFrame
    
    -- Knob Rounding
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = ToggleKnob
    
    -- If enabled, add the active gradient
    if startEnabled then
        local SwitchGradient = Instance.new("UIGradient")
        SwitchGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(128, 0, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
        })
        SwitchGradient.Parent = SwitchFrame
    end
    
    -- Make the toggle interactive
    ToggleFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            
            local enabled = ToggleKnob.Position.X.Offset > 10
                
            if enabled then
                -- Turn off
                ToggleKnob:TweenPosition(UDim2.new(0, 3, 0, 2), "Out", "Sine", 0.15, true)
                SwitchFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
                
                if SwitchFrame:FindFirstChild("UIGradient") then
                    SwitchFrame:FindFirstChild("UIGradient"):Destroy()
                end
            else
                -- Turn on
                ToggleKnob:TweenPosition(UDim2.new(0, 23, 0, 2), "Out", "Sine", 0.15, true)
                SwitchFrame.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
                
                local SwitchGradient = Instance.new("UIGradient")
                SwitchGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(128, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
                })
                SwitchGradient.Parent = SwitchFrame
            end
        end
    end)
    
    return ToggleFrame
end

-- Create Feature Toggles
local Toggle1 = CreateToggle("AUTO ACCEPT", UDim2.new(0, 0, 0, 10), true)
local Toggle2 = CreateToggle("FREEZE VICTIM'S SCREEN", UDim2.new(0, 0, 0, 56), false)
local Toggle3 = CreateToggle("DUPE ALL", UDim2.new(0, 0, 0, 102), false)

-- Divider Line 2
local Divider2 = Instance.new("Frame")
Divider2.Name = "Divider2"
Divider2.Size = UDim2.new(1, 0, 0, 1)
Divider2.Position = UDim2.new(0, 0, 0, 148)
Divider2.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
Divider2.BackgroundTransparency = 0.7
Divider2.BorderSizePixel = 0
Divider2.Parent = ContentFrame

-- Weapon Spawner Section
local SpawnerTitle = Instance.new("TextLabel")
SpawnerTitle.Name = "SpawnerTitle"
SpawnerTitle.Size = UDim2.new(1, 0, 0, 30)
SpawnerTitle.Position = UDim2.new(0, 0, 0, 158)
SpawnerTitle.BackgroundTransparency = 1
SpawnerTitle.Font = Enum.Font.GothamBold
SpawnerTitle.Text = "KNIFE/GUN SPAWNER"
SpawnerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnerTitle.TextSize = 14
SpawnerTitle.Parent = ContentFrame

-- Weapon Selection - UI Only
local function CreateWeaponButton(name, position)
    local WeaponButton = Instance.new("TextButton")
    WeaponButton.Name = name .. "Button"
    WeaponButton.Size = UDim2.new(0.48, 0, 0, 30)
    WeaponButton.Position = position
    WeaponButton.BackgroundColor3 = Color3.fromRGB(40, 15, 60)
    WeaponButton.Font = Enum.Font.Gotham
    WeaponButton.Text = name
    WeaponButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    WeaponButton.TextSize = 12
    WeaponButton.Parent = ContentFrame
    
    -- Button Rounding
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = WeaponButton
    
    -- Button Stroke
    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(128, 0, 255)
    ButtonStroke.Transparency = 0.7
    ButtonStroke.Thickness = 1
    ButtonStroke.Parent = WeaponButton
    
    -- Button hover effects
    WeaponButton.MouseEnter:Connect(function()
        WeaponButton.BackgroundColor3 = Color3.fromRGB(60, 25, 90)
    end)
    
    WeaponButton.MouseLeave:Connect(function()
        WeaponButton.BackgroundColor3 = Color3.fromRGB(40, 15, 60)
    end)
    
    -- Button click visual effect
    WeaponButton.MouseButton1Click:Connect(function()
        WeaponButton.BackgroundColor3 = Color3.fromRGB(80, 30, 120)
        WeaponButton.Text = "SPAWNED!"
        
        -- Reset after a moment
        task.wait(1)
        WeaponButton.Text = name
        WeaponButton.BackgroundColor3 = Color3.fromRGB(40, 15, 60)
    end)
    
    return WeaponButton
end

-- Create weapon buttons in a grid
local weapons = {
    {name = "Godly Knife", row = 0, col = 0},
    {name = "Godly Gun", row = 0, col = 1},
    {name = "Chroma Knife", row = 1, col = 0},
    {name = "Chroma Gun", row = 1, col = 1},
    {name = "Ancient", row = 2, col = 0},
    {name = "Vintage", row = 2, col = 1}
}

for _, weapon in ipairs(weapons) do
    local posX = weapon.col * 0.52
    local posY = 195 + (weapon.row * 35)
    CreateWeaponButton(weapon.name, UDim2.new(posX, 0, 0, posY))
end

-- Premium Badge
local PremiumBadge = Instance.new("Frame")
PremiumBadge.Name = "PremiumBadge"
PremiumBadge.Size = UDim2.new(0, 12, 0, 12)
PremiumBadge.Position = UDim2.new(0, 2, 0, 2)
PremiumBadge.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
PremiumBadge.Parent = HeaderFrame

-- Badge Corner
local BadgeCorner = Instance.new("UICorner")
BadgeCorner.CornerRadius = UDim.new(1, 0)
BadgeCorner.Parent = PremiumBadge

-- Activate Button
local ActivateButton = Instance.new("TextButton")
ActivateButton.Name = "ActivateButton"
ActivateButton.Size = UDim2.new(1, 0, 0, 36)
ActivateButton.Position = UDim2.new(0, 0, 0, 298)
ActivateButton.BackgroundColor3 = Color3.fromRGB(128, 0, 255)
ActivateButton.Font = Enum.Font.GothamBold
ActivateButton.Text = "ACTIVATE PREMIUM"
ActivateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ActivateButton.TextSize = 16
ActivateButton.Parent = ContentFrame

-- Button Corner
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = ActivateButton

-- Button Gradient
local ButtonGradient = Instance.new("UIGradient")
ButtonGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(128, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 255))
})
ButtonGradient.Rotation = 45
ButtonGradient.Parent = ActivateButton

-- Button effects
ActivateButton.MouseEnter:Connect(function()
    ActivateButton.Size = UDim2.new(1, 4, 0, 38)
    ActivateButton.Position = UDim2.new(0, -2, 0, 297)
end)

ActivateButton.MouseLeave:Connect(function()
    ActivateButton.Size = UDim2.new(1, 0, 0, 36)
    ActivateButton.Position = UDim2.new(0, 0, 0, 298)
end)

ActivateButton.MouseButton1Click:Connect(function()
    ActivateButton.Text = "ACTIVATING..."
    
    -- Simulate activation (visual only)
    task.wait(1.5)
    ActivateButton.Text = "PREMIUM ACTIVATED"
end)

-- Make UI draggable for both PC and Mobile
local UserInputService = game:GetService("UserInputService")

HeaderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        GUI.Dragging = true
        
        -- Calculate the offset from the input position to the frame position
        local absolutePosition = HeaderFrame.AbsolutePosition
        local inputPosition = input.Position
        GUI.MouseOffset = UDim2.new(0, inputPosition.X - absolutePosition.X, 0, inputPosition.Y - absolutePosition.Y)
        
        -- Connect to the move event
        local inputChanged
        inputChanged = UserInputService.InputChanged:Connect(function(moveInput)
            if moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch then
                if GUI.Dragging then
                    -- Move the frame based on the mouse/touch position and the offset
                    local framePosition = UDim2.new(0, moveInput.Position.X - GUI.MouseOffset.X.Offset, 0, moveInput.Position.Y - GUI.MouseOffset.Y.Offset)
                    MainFrame.Position = framePosition
                end
            end
        end)
        
        -- Connect to the end event
        local inputEnded
        inputEnded = UserInputService.InputEnded:Connect(function(endInput)
            if (endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch) then
                GUI.Dragging = false
                inputChanged:Disconnect()
                inputEnded:Disconnect()
            end
        end)
    end
end)

-- Close button functionality
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Simple notification system
local function CreateNotification(title, message, duration)
    local NotificationFrame = Instance.new("Frame")
    NotificationFrame.Name = "Notification"
    NotificationFrame.Size = UDim2.new(0, 200, 0, 60)
    NotificationFrame.Position = UDim2.new(1, -220, 0, 20)
    NotificationFrame.BackgroundColor3 = Color3.fromRGB(30, 10, 40)
    NotificationFrame.BorderSizePixel = 0
    NotificationFrame.Parent = ScreenGui
    
    -- Notification Corner
    local NotifCorner = Instance.new("UICorner")
    NotifCorner.CornerRadius = UDim.new(0, 8)
    NotifCorner.Parent = NotificationFrame
    
    -- Notification Stroke
    local NotifStroke = Instance.new("UIStroke")
    NotifStroke.Color = Color3.fromRGB(128, 0, 255)
    NotifStroke.Thickness = 1
    NotifStroke.Parent = NotificationFrame
    
    -- Notification Title
    local NotifTitle = Instance.new("TextLabel")
    NotifTitle.Name = "Title"
    NotifTitle.Size = UDim2.new(1, -20, 0, 20)
    NotifTitle.Position = UDim2.new(0, 10, 0, 5)
    NotifTitle.BackgroundTransparency = 1
    NotifTitle.Font = Enum.Font.GothamBold
    NotifTitle.Text = title
    NotifTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NotifTitle.TextSize = 14
    NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
    NotifTitle.Parent = NotificationFrame
    
    -- Notification Message
    local NotifMessage = Instance.new("TextLabel")
    NotifMessage.Name = "Message"
    NotifMessage.Size = UDim2.new(1, -20, 0, 30)
    NotifMessage.Position = UDim2.new(0, 10, 0, 25)
    NotifMessage.BackgroundTransparency = 1
    NotifMessage.Font = Enum.Font.Gotham
    NotifMessage.Text = message
    NotifMessage.TextColor3 = Color3.fromRGB(200, 200, 200)
    NotifMessage.TextSize = 12
    NotifMessage.TextXAlignment = Enum.TextXAlignment.Left
    NotifMessage.TextWrapped = true
    NotifMessage.Parent = NotificationFrame
    
    -- Animate notification
    NotificationFrame:TweenPosition(UDim2.new(1, -220, 0, 20), "Out", "Quad", 0.5, true)
    
    -- Auto remove
    task.delay(duration or 3, function()
        NotificationFrame:TweenPosition(UDim2.new(1, 20, 0, 20), "Out", "Quad", 0.5, true)
        task.wait(0.5)
        NotificationFrame:Destroy()
    end)
end

-- Show welcome notification
CreateNotification("MM2 Premium", "UI loaded successfully!", 3)

-- Return the GUI instance
return ScreenGui
