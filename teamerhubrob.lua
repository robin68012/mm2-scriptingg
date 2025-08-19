--// TEAMER HUB FAN - Futuristic UI
-- Tout en 1 code

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "TeamerHubFan"

-- Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 500, 0, 320)
Main.Position = UDim2.new(0.3, 0, 0.2, 0)
Main.BackgroundColor3 = Color3.fromRGB(20,20,30)

-- Design futuriste
local corner = Instance.new("UICorner", Main)
corner.CornerRadius = UDim.new(0,15)

local stroke = Instance.new("UIStroke", Main)
stroke.Thickness = 2
stroke.Color = Color3.fromRGB(120,0,255)

-- Draggable
Main.Active = true
Main.Draggable = true

-- Toggle avec CTRL
local visible = true
UserInputService.InputBegan:Connect(function(input, gp)
	if not gp and input.KeyCode == Enum.KeyCode.LeftControl then
		visible = not visible
		ScreenGui.Enabled = visible
	end
end)

-- Onglets
local Tabs = Instance.new("Frame", Main)
Tabs.Size = UDim2.new(0,120,1,0)
Tabs.BackgroundColor3 = Color3.fromRGB(25,25,40)
Instance.new("UICorner", Tabs).CornerRadius = UDim.new(0,15)

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1,-120,1,0)
Content.Position = UDim2.new(0,120,0,0)
Content.BackgroundColor3 = Color3.fromRGB(15,15,25)
Instance.new("UICorner", Content).CornerRadius = UDim.new(0,15)

-- Créateur de boutons d’onglets
local function createTab(name)
	local btn = Instance.new("TextButton", Tabs)
	btn.Size = UDim2.new(1,0,0,40)
	btn.BackgroundTransparency = 1
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(200,200,200)

	local frame = Instance.new("Frame", Content)
	frame.Size = UDim2.new(1,0,1,0)
	frame.BackgroundTransparency = 1
	frame.Visible = false

	btn.MouseEnter:Connect(function()
		btn.TextColor3 = Color3.fromRGB(120,0,255)
	end)
	btn.MouseLeave:Connect(function()
		btn.TextColor3 = Color3.fromRGB(200,200,200)
	end)

	btn.MouseButton1Click:Connect(function()
		for _,child in pairs(Content:GetChildren()) do
			child.Visible = false
		end
		frame.Visible = true
	end)

	return frame
end

-- Crée onglets
local playerTab = createTab("Player")
local miscTab = createTab("Misc")
local targetTab = createTab("Target")

-- Active onglet par défaut
Content:GetChildren()[1].Visible = true

-- Créateur de boutons dans contenu
local function createButton(parent, text, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0,200,0,35)
	btn.Position = UDim2.new(0,20,0,#parent:GetChildren()*40)
	btn.BackgroundColor3 = Color3.fromRGB(40,40,60)
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
	btn.Text = text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(255,255,255)

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(80,0,150)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(40,40,60)
	end)

	btn.MouseButton1Click:Connect(callback)
end

--------------------------------------------------------------------
-- FEATURES

-- Anti Fling
local function enableAntiFling()
	for _,plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = plr.Character.HumanoidRootPart
			hrp.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
			hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
			hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
		end
	end
end

-- Chams
local highlightFolder = Instance.new("Folder", ScreenGui)
highlightFolder.Name = "Highlights"

local function clearChams()
	for _,c in pairs(highlightFolder:GetChildren()) do c:Destroy() end
end

local function applyCham(player, color, tag)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local hl = Instance.new("Highlight")
		hl.FillColor = color
		hl.OutlineColor = Color3.fromRGB(255,255,255)
		hl.Adornee = player.Character
		hl.Parent = highlightFolder

		local billboard = Instance.new("BillboardGui")
		billboard.Size = UDim2.new(0,120,0,20)
		billboard.StudsOffset = Vector3.new(0,3,0)
		billboard.AlwaysOnTop = true
		billboard.Parent = player.Character.HumanoidRootPart

		local label = Instance.new("TextLabel", billboard)
		label.Size = UDim2.new(1,0,1,0)
		label.BackgroundTransparency = 1
		label.TextStrokeTransparency = 0.3
		label.Font = Enum.Font.GothamBold
		label.TextSize = 14
		label.TextColor3 = color
		label.Text = player.Name.." | "..tag
	end
end

local function detectRoles()
	clearChams()
	for _,plr in pairs(Players:GetPlayers()) do
		if plr.Character then
			local tag = "Innocent"
			local color = Color3.fromRGB(0,255,0)

			local knife = plr.Backpack:FindFirstChild("Knife") or plr.Character:FindFirstChild("Knife")
			if knife then tag = "Murder"; color = Color3.fromRGB(255,0,0) end

			local gun = plr.Backpack:FindFirstChild("Gun") or plr.Character:FindFirstChild("Gun")
			if gun then tag = "Sheriff"; color = Color3.fromRGB(0,150,255) end

			if plr:FindFirstChild("Power") then
				tag = tag.." | Power: "..plr.Power.Value
				color = Color3.fromRGB(150,0,255)
			end

			applyCham(plr,color,tag)
		end
	end
end

-- Grab Gun
local function grabGun()
	local gundrop = workspace:FindFirstChild("GunDrop")
	if gundrop and gundrop:IsA("Tool") then
		gundrop.Parent = LocalPlayer.Backpack
	end
end

-- Fly
local flying = false
local function fly()
	flying = not flying
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if flying and hrp then
		task.spawn(function()
			while flying and task.wait() do
				local dir = Vector3.zero
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += hrp.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= hrp.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= hrp.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += hrp.CFrame.RightVector end
				hrp.Velocity = dir*50
			end
		end)
	else
		if hrp then hrp.Velocity = Vector3.zero end
	end
end

-- Vertex Fling
local function flingTarget(target)
	if not target.Character or not LocalPlayer.Character then return end
	local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	local thrp = target.Character:FindFirstChild("HumanoidRootPart")
	if hrp and thrp then
		task.spawn(function()
			for i=1,100 do
				hrp.CFrame = thrp.CFrame * CFrame.new(0,0,0)
				hrp.AssemblyAngularVelocity = Vector3.new(9999,9999,9999)
				task.wait()
			end
		end)
	end
end

--------------------------------------------------------------------
-- Boutons

-- Player tab
createButton(playerTab,"Anti Fling", function()
	RunService.Heartbeat:Connect(enableAntiFling)
end)

createButton(playerTab,"Fly (toggle)", fly)

-- Misc tab
createButton(miscTab,"Chams", function()
	task.spawn(function()
		while task.wait(5) do detectRoles() end
	end)
end)

createButton(miscTab,"Grab Gun", function()
	RunService.Heartbeat:Connect(grabGun)
end)

-- Target tab
createButton(targetTab,"Fling Nearest", function()
	local closest,dist=nil,math.huge
	for _,plr in pairs(Players:GetPlayers()) do
		if plr~=LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local d = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
			if d<dist then closest=plr;dist=d end
		end
	end
	if closest then flingTarget(closest) end
end)
