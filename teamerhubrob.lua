--// Variables
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

--// UI principale
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "TeamerHubFan"
ScreenGui.ResetOnSpawn = false

--// Cadre principal
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 500, 0, 300)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

-- Coin arrondi
local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 12)

-- Glow futuriste
local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 255, 200)

--// Onglets
local TabFrame = Instance.new("Frame", MainFrame)
TabFrame.Size = UDim2.new(0, 120, 1, 0)
TabFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
Instance.new("UICorner", TabFrame).CornerRadius = UDim.new(0, 12)

local TabList = Instance.new("UIListLayout", TabFrame)
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 5)

-- Contenu
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -130, 1, -10)
ContentFrame.Position = UDim2.new(0, 130, 0, 5)
ContentFrame.BackgroundTransparency = 1

--// Fonction de création d’onglets
local sections = {}
local function CreateTab(name)
    local btn = Instance.new("TextButton", TabFrame)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.AutoButtonColor = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local section = Instance.new("Frame", ContentFrame)
    section.Size = UDim2.new(1, 0, 1, 0)
    section.Visible = false
    section.BackgroundTransparency = 1

    local list = Instance.new("UIListLayout", section)
    list.Padding = UDim.new(0, 5)
    list.SortOrder = Enum.SortOrder.LayoutOrder

    sections[name] = section

    btn.MouseButton1Click:Connect(function()
        for _, sec in pairs(ContentFrame:GetChildren()) do
            if sec:IsA("Frame") then sec.Visible = false end
        end
        section.Visible = true
    end)

    return section
end

-- Onglets
local mainTab = CreateTab("Main")
local playerTab = CreateTab("Player")
local miscTab = CreateTab("Misc")
local rolesTab = CreateTab("Roles")

sections["Main"].Visible = true -- onglet par défaut

--// Fonction boutons toggle
local function CreateToggle(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Text = text .. " [OFF]"
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and " [ON]" or " [OFF]")
        callback(state)
    end)
end

--// Features
local antiFling, chams, autoGrab

-- Anti-Fling
CreateToggle(playerTab, "Anti-Fling", function(state)
    if state then
        antiFling = RunService.Heartbeat:Connect(function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = plr.Character.HumanoidRootPart
                    hrp.Velocity = Vector3.zero
                    hrp.RotVelocity = Vector3.zero
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end
            end
        end)
    else
        if antiFling then antiFling:Disconnect() end
    end
end)

-- Player Chams
CreateToggle(miscTab, "Player Chams", function(state)
    if state then
        chams = RunService.Heartbeat:Connect(function()
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local highlight = plr.Character:FindFirstChild("Cham") or Instance.new("Highlight")
                    highlight.Name = "Cham"
                    highlight.FillTransparency = 0.5
                    highlight.OutlineTransparency = 0
                    highlight.Parent = plr.Character

                    -- gris par défaut
                    local color = Color3.fromRGB(150,150,150)

                    if plr.Backpack:FindFirstChild("Knife") or plr.Character:FindFirstChild("Knife") then
                        color = Color3.fromRGB(255,0,0)
                    elseif plr.Backpack:FindFirstChild("Gun") or plr.Character:FindFirstChild("Gun") then
                        color = Color3.fromRGB(0,0,255)
                    elseif plr.Backpack:FindFirstChild("Revolver") or plr.Character:FindFirstChild("Revolver") then
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

-- Auto Grab Gun
CreateToggle(miscTab, "Auto Grab Gun", function(state)
    if state then
        autoGrab = RunService.Heartbeat:Connect(function()
            local gun = workspace:FindFirstChild("GunDrop")
            if gun and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = gun.CFrame
            end
        end)
    else
        if autoGrab then autoGrab:Disconnect() end
    end
end)

--// Toggle UI avec Ctrl
UserInputService.InputBegan:Connect(function(input, gp)
    if input.KeyCode == Enum.KeyCode.LeftControl and not gp then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)
