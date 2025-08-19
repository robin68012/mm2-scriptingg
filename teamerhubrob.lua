-- LocalScript (StarterPlayerScripts)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- RemoteEvent pour fling (créé si pas déjà existant)
local flingEvent = ReplicatedStorage:FindFirstChild("FlingEvent") or Instance.new("RemoteEvent")
flingEvent.Name = "FlingEvent"
flingEvent.Parent = ReplicatedStorage

-- UI principale
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 250)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 2

-- Onglets
local Tabs = Instance.new("Frame", MainFrame)
Tabs.Size = UDim2.new(1, 0, 0, 30)
Tabs.BackgroundTransparency = 1

local MiscBtn = Instance.new("TextButton", Tabs)
MiscBtn.Size = UDim2.new(0, 100, 1, 0)
MiscBtn.Text = "Misc"
MiscBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

local PlayerBtn = Instance.new("TextButton", Tabs)
PlayerBtn.Size = UDim2.new(0, 100, 1, 0)
PlayerBtn.Position = UDim2.new(0, 100, 0, 0)
PlayerBtn.Text = "Player"
PlayerBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

-- Pages
local MiscPage = Instance.new("Frame", MainFrame)
MiscPage.Size = UDim2.new(1, -20, 1, -40)
MiscPage.Position = UDim2.new(0, 10, 0, 40)
MiscPage.BackgroundTransparency = 1

local PlayerPage = Instance.new("Frame", MainFrame)
PlayerPage.Size = UDim2.new(1, -20, 1, -40)
PlayerPage.Position = UDim2.new(0, 10, 0, 40)
PlayerPage.BackgroundTransparency = 1
PlayerPage.Visible = false

MiscBtn.MouseButton1Click:Connect(function()
    MiscPage.Visible = true
    PlayerPage.Visible = false
end)
PlayerBtn.MouseButton1Click:Connect(function()
    MiscPage.Visible = false
    PlayerPage.Visible = true
end)

-- Fonction pour faire un bouton toggle
local function createToggle(name, parent)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 150, 0, 40)
    btn.Text = name.." [OFF]"
    btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and " [ON]" or " [OFF]")
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
        print(name.." activé:", state)
    end)

    return btn
end

-- Boutons Misc
local AntiFlingBtn = createToggle("Anti-Fling", MiscPage)
AntiFlingBtn.Position = UDim2.new(0, 10, 0, 10)

local GrabGunBtn = createToggle("Grab Gun", MiscPage)
GrabGunBtn.Position = UDim2.new(0, 10, 0, 60)

local ChamsBtn = createToggle("Chams", MiscPage)
ChamsBtn.Position = UDim2.new(0, 10, 0, 110)

-- Onglet Player
local Dropdown = Instance.new("TextButton", PlayerPage)
Dropdown.Size = UDim2.new(0, 200, 0, 40)
Dropdown.Text = "Sélectionner un joueur"
Dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

local PlayerList = Instance.new("Frame", PlayerPage)
PlayerList.Size = UDim2.new(0, 200, 0, 120)
PlayerList.Position = UDim2.new(0, 0, 0, 50)
PlayerList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PlayerList.Visible = false

Dropdown.MouseButton1Click:Connect(function()
    PlayerList.Visible = not PlayerList.Visible
end)

local selectedPlayer = nil
local function refreshPlayers()
    PlayerList:ClearAllChildren()
    local y = 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton", PlayerList)
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Position = UDim2.new(0, 0, 0, y)
            btn.Text = plr.Name
            btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

            btn.MouseButton1Click:Connect(function()
                selectedPlayer = plr
                Dropdown.Text = "Cible: "..plr.Name
                PlayerList.Visible = false
            end)
            y = y + 30
        end
    end
end

Players.PlayerAdded:Connect(refreshPlayers)
Players.PlayerRemoving:Connect(refreshPlayers)
refreshPlayers()

local FlingBtn = Instance.new("TextButton", PlayerPage)
FlingBtn.Size = UDim2.new(0, 150, 0, 40)
FlingBtn.Position = UDim2.new(0, 0, 0, 180)
FlingBtn.Text = "Fling"
FlingBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)

FlingBtn.MouseButton1Click:Connect(function()
    if selectedPlayer then
        flingEvent:FireServer(selectedPlayer.Name)
    end
end)

-- Côté serveur via LocalScript (crée un script serveur "virtuel")
flingEvent.OnServerEvent:Connect(function(player, targetName)
    local target = Players:FindFirstChild(targetName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = target.Character.HumanoidRootPart
        hrp.Velocity = Vector3.new(0,300,0)
    end
end)

-- Toggle UI avec CTRL
local UIS = game:GetService("UserInputService")
local uiVisible = true
UIS.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.LeftControl then
        uiVisible = not uiVisible
        MainFrame.Visible = uiVisible
    end
end)
