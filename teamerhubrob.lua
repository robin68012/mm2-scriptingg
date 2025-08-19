--// Teamer Hub Fan - Exemple d'UI type Eclipse Hub
--// UI avec toggles et dropdown. Remplace les "print" par tes vraies fonctions.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- // ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TeamerHubFan"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- // Main Frame
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 400, 0, 300)
Main.Position = UDim2.new(0.3, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

-- // Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,40)
Title.BackgroundColor3 = Color3.fromRGB(30,30,30)
Title.Text = "Teamer Hub Fan"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(0,255,140)
Title.Parent = Main

-- // Tabs buttons
local TabsFrame = Instance.new("Frame")
TabsFrame.Size = UDim2.new(0,100,1,-40)
TabsFrame.Position = UDim2.new(0,0,0,40)
TabsFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
TabsFrame.Parent = Main

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1,-100,1,-40)
ContentFrame.Position = UDim2.new(0,100,0,40)
ContentFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
ContentFrame.Parent = Main

-- function to switch tab
local function CreateTabButton(name, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,30)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.fromRGB(200,200,200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = TabsFrame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Clear Content
local function ClearContent()
    for _,v in pairs(ContentFrame:GetChildren()) do
        v:Destroy()
    end
end

-- // Toggle Button function
local function CreateToggle(name, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,200,0,30)
    btn.Position = UDim2.new(0,10,0,#parent:GetChildren()*35)
    btn.Text = name.." [OFF]"
    btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = parent

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Color3.fromRGB(0,150,0)
            btn.Text = name.." [ON]"
        else
            btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
            btn.Text = name.." [OFF]"
        end
        callback(state)
    end)
end

-- // Misc Tab
local function OpenMisc()
    ClearContent()
    CreateToggle("Fly", ContentFrame, function(state)
        print("Fly:",state)
    end)
    CreateToggle("Anti-Fling", ContentFrame, function(state)
        print("Anti-Fling:",state)
    end)
    CreateToggle("Chams", ContentFrame, function(state)
        print("Chams:",state)
    end)
    CreateToggle("Grab Gun", ContentFrame, function(state)
        print("Grab Gun:",state)
    end)
end

-- // Player Tab with dropdown
local function OpenPlayer()
    ClearContent()

    local Dropdown = Instance.new("Frame")
    Dropdown.Size = UDim2.new(0,200,0,150)
    Dropdown.Position = UDim2.new(0,10,0,10)
    Dropdown.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Dropdown.Parent = ContentFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = Dropdown

    local selectedPlayer = nil

    for _,plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,0,30)
            btn.Text = plr.Name
            btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
            btn.TextColor3 = Color3.fromRGB(200,200,200)
            btn.Parent = Dropdown
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = plr
                print("Sélectionné:", plr.Name)
            end)
        end
    end

    local FlingBtn = Instance.new("TextButton")
    FlingBtn.Size = UDim2.new(0,200,0,30)
    FlingBtn.Position = UDim2.new(0,10,0,170)
    FlingBtn.Text = "Fling"
    FlingBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
    FlingBtn.TextColor3 = Color3.fromRGB(255,255,255)
    FlingBtn.Font = Enum.Font.GothamBold
    FlingBtn.TextSize = 14
    FlingBtn.Parent = ContentFrame

    FlingBtn.MouseButton1Click:Connect(function()
        if selectedPlayer then
            print("Fling sur:",selectedPlayer.Name)
        else
            print("Aucun joueur sélectionné.")
        end
    end)
end

-- // Tabs
local miscTab = CreateTabButton("Misc", OpenMisc)
local playerTab = CreateTabButton("Player", OpenPlayer)

-- default open misc
OpenMisc()

-- // Toggle GUI with CTRL
UserInputService.InputBegan:Connect(function(input,gp)
    if not gp and input.KeyCode == Enum.KeyCode.LeftControl then
        Main.Visible = not Main.Visible
    end
end)
