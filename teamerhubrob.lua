--// Teamer Hub Fan UI Futuriste
--// Mets ce LocalScript dans StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ScreenGui
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "TeamerHubFan"
gui.ResetOnSpawn = false

-- Frame Principal
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 400, 0, 250)
mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
mainFrame.Active = true
mainFrame.Draggable = true
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", mainFrame)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(0, 255, 200)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Gradient
local grad = Instance.new("UIGradient", mainFrame)
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 150))
}
grad.Rotation = 45

-- Liste onglets
local tabList = Instance.new("Frame", mainFrame)
tabList.Size = UDim2.new(0, 100, 1, 0)
tabList.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
Instance.new("UICorner", tabList).CornerRadius = UDim.new(0, 10)

-- Contenu onglets
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -110, 1, -10)
contentFrame.Position = UDim2.new(0, 110, 0, 5)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 30, 50)
Instance.new("UICorner", contentFrame).CornerRadius = UDim.new(0, 10)

-- Fonction création boutons onglets
local tabs = {}
local function createTab(name)
    local btn = Instance.new("TextButton", tabList)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, (#tabList:GetChildren()-1)*35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 35, 60)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(0, 255, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local frame = Instance.new("Frame", contentFrame)
    frame.Size = UDim2.new(1, -10, 1, -10)
    frame.Position = UDim2.new(0, 5, 0, 5)
    frame.BackgroundTransparency = 1
    frame.Visible = false

    tabs[name] = frame

    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(tabs) do f.Visible = false end
        frame.Visible = true
    end)
end

-- Onglets
createTab("Main")
createTab("Player")
createTab("Misc")
createTab("Roles")

--=== PLAYER TAB ===
local playerTab = tabs["Player"]

-- Anti Fling toggle
local antiFlingBtn = Instance.new("TextButton", playerTab)
antiFlingBtn.Size = UDim2.new(0, 150, 0, 30)
antiFlingBtn.Position = UDim2.new(0, 10, 0, 10)
antiFlingBtn.BackgroundColor3 = Color3.fromRGB(50, 60, 90)
antiFlingBtn.Text = "Anti Fling: OFF"
antiFlingBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", antiFlingBtn).CornerRadius = UDim.new(0, 6)

local antiFlingEnabled = false
antiFlingBtn.MouseButton1Click:Connect(function()
    antiFlingEnabled = not antiFlingEnabled
    antiFlingBtn.Text = "Anti Fling: " .. (antiFlingEnabled and "ON" or "OFF")
end)

RunService.Heartbeat:Connect(function()
    if antiFlingEnabled then
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                if hrp.Velocity.Magnitude > 200 then
                    hrp.Velocity = Vector3.zero
                    hrp.RotVelocity = Vector3.zero
                end
            end
        end
    end
end)

--=== MISC TAB ===
local miscTab = tabs["Misc"]

-- Player Chams
local chamsBtn = Instance.new("TextButton", miscTab)
chamsBtn.Size = UDim2.new(0, 150, 0, 30)
chamsBtn.Position = UDim2.new(0, 10, 0, 10)
chamsBtn.BackgroundColor3 = Color3.fromRGB(50, 60, 90)
chamsBtn.Text = "Player Chams: OFF"
chamsBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", chamsBtn).CornerRadius = UDim.new(0, 6)

local chamsEnabled = false
chamsBtn.MouseButton1Click:Connect(function()
    chamsEnabled = not chamsEnabled
    chamsBtn.Text = "Player Chams: " .. (chamsEnabled and "ON" or "OFF")
end)

-- Auto Grab Gun
local grabBtn = Instance.new("TextButton", miscTab)
grabBtn.Size = UDim2.new(0, 150, 0, 30)
grabBtn.Position = UDim2.new(0, 10, 0, 50)
grabBtn.BackgroundColor3 = Color3.fromRGB(50, 60, 90)
grabBtn.Text = "Auto Grab Gun: OFF"
grabBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", grabBtn).CornerRadius = UDim.new(0, 6)

local grabEnabled = false
grabBtn.MouseButton1Click:Connect(function()
    grabEnabled = not grabEnabled
    grabBtn.Text = "Auto Grab Gun: " .. (grabEnabled and "ON" or "OFF")
end)

-- Logic
RunService.Heartbeat:Connect(function()
    if chamsEnabled then
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                if not hrp:FindFirstChild("Cham") then
                    local b = Instance.new("BillboardGui", hrp)
                    b.Name = "Cham"
                    b.Size = UDim2.new(0, 100, 0, 20)
                    b.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", b)
                    txt.Size = UDim2.new(1,0,1,0)
                    txt.BackgroundTransparency = 1
                    txt.Text = plr.Name
                    txt.Font = Enum.Font.GothamBold
                    txt.TextSize = 14
                end
                local txt = hrp.Cham.TextLabel
                local inv = plr.Backpack
                local col = Color3.fromRGB(150,150,150)
                if inv:FindFirstChild("Knife") then col = Color3.fromRGB(255,0,0)
                elseif inv:FindFirstChild("Gun") then col = Color3.fromRGB(0,0,255)
                elseif inv:FindFirstChild("A") then col = Color3.fromRGB(0,255,0) end
                txt.TextColor3 = col
            end
        end
    else
        for _,plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                if hrp:FindFirstChild("Cham") then hrp.Cham:Destroy() end
            end
        end
    end

    if grabEnabled then
        local gun = workspace:FindFirstChild("GunDrop")
        if gun then
            -- ⚠️ Remplace "GrabGun" par le vrai RemoteEvent de ton jeu
            local remote = ReplicatedStorage:FindFirstChild("GrabGun")
            if remote then
                remote:FireServer(gun)
            end
        end
    end
end)

-- Default tab
tabs["Main"].Visible = true

-- Toggle UI avec Ctrl
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.LeftControl then
        mainFrame.Visible = not mainFrame.Visible
    end
end)
