-- // Teamer Hub Fan UI //
-- Mets ce script dans StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- UI LIB //
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "TeamerHubFan"
ScreenGui.ResetOnSpawn = false

-- MAIN FRAME //
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

-- Glow border
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Color = Color3.fromRGB(0, 255, 170)

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

-- TOGGLE WITH CTRL //
local UIS = game:GetService("UserInputService")
local uiVisible = true
UIS.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.LeftControl then
        uiVisible = not uiVisible
        MainFrame.Visible = uiVisible
    end
end)

-- LEFT MENU (Tabs)
local TabFrame = Instance.new("Frame", MainFrame)
TabFrame.Size = UDim2.new(0, 120, 1, 0)
TabFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
TabFrame.BorderSizePixel = 0

local UIListLayout = Instance.new("UIListLayout", TabFrame)
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- RIGHT CONTENT
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -120, 1, 0)
ContentFrame.Position = UDim2.new(0, 120, 0, 0)
ContentFrame.BackgroundTransparency = 1

-- Function to make a Tab Button
local function CreateTab(name)
    local btn = Instance.new("TextButton", TabFrame)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    btn.TextColor3 = Color3.fromRGB(0, 255, 170)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.AutoButtonColor = true

    local UIC = Instance.new("UICorner", btn)
    UIC.CornerRadius = UDim.new(0, 8)

    return btn
end

-- Function to create a section
local function CreateSection(name)
    local frame = Instance.new("Frame", ContentFrame)
    frame.Size = UDim2.new(1, -10, 1, -10)
    frame.Position = UDim2.new(0, 5, 0, 5)
    frame.Visible = false

    local layout = Instance.new("UIListLayout", frame)
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    return frame
end

-- Function to make toggle buttons
local function CreateToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Text = text .. " [OFF]"
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14

    local UIC = Instance.new("UICorner", btn)
    UIC.CornerRadius = UDim.new(0, 6)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

-- Create tabs
local tabs = {
    Main = CreateTab("Main"),
    Player = CreateTab("Player"),
    Misc = CreateTab("Misc"),
    Roles = CreateTab("Roles"),
}

local sections = {
    Main = CreateSection("Main"),
    Player = CreateSection("Player"),
    Misc = CreateSection("Misc"),
    Roles = CreateSection("Roles"),
}

-- Switch tab function
for name, tab in pairs(tabs) do
    tab.MouseButton1Click:Connect(function()
        for _, sec in pairs(sections) do
            sec.Visible = false
        end
        sections[name].Visible = true
    end)
end
sections.Main.Visible = true

-- // FEATURES // --

-- Anti-Fling
local antiFling
CreateToggle(sections.Player, "Anti-Fling", function(state)
    if state then
        antiFling = RunService.Heartbeat:Connect(function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                end
            end
        end)
    else
        if antiFling then antiFling:Disconnect() end
    end
end)

-- Player Chams
local chams
CreateToggle(sections.Misc, "Player Chams", function(state)
    if state then
        chams = RunService.Heartbeat:Connect(function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local highlight = plr.Character:FindFirstChild("Cham") or Instance.new("Highlight")
                    highlight.Name = "Cham"
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = plr.Character

                    -- check inventory
                    local color = Color3.fromRGB(150,150,150)
                    if plr.Backpack:FindFirstChild("Knife") then
                        color = Color3.fromRGB(255,0,0)
                    elseif plr.Backpack:FindFirstChild("Gun") then
                        color = Color3.fromRGB(0,0,255)
                    elseif plr.Backpack:FindFirstChild("Sheriff") then
                        color = Color3.fromRGB(0,255,0)
                    end
                    highlight.FillColor = color
                    highlight.OutlineColor = color
                end
            end
        end)
    else
        if chams then chams:Disconnect() end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("Cham") then
                plr.Character.Cham:Destroy()
            end
        end
    end
end)

-- Auto Grab GunDrop
local grabGun
CreateToggle(sections.Misc, "Auto Grab Gun", function(state)
    if state then
        grabGun = RunService.Heartbeat:Connect(function()
            local gun = workspace:FindFirstChild("GunDrop")
            if gun then
                gun.Parent = LocalPlayer.Backpack
            end
        end)
    else
        if grabGun then grabGun:Disconnect() end
    end
end)
