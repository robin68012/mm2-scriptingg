--// Teamer Hub Fan (UI + Functional Toggles) \\--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- UI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "TeamerHubFan"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 500, 0, 300)
main.Position = UDim2.new(0.3, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Visible = true
main.Active = true
main.Draggable = true
main.Parent = gui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Teamer Hub Fan"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = main

-- Tabs
local tabs = Instance.new("Frame")
tabs.Size = UDim2.new(1,0,0,30)
tabs.Position = UDim2.new(0,0,0,40)
tabs.BackgroundTransparency = 1
tabs.Parent = main

local tabNames = {"Player","Misc"}
local pages, tabButtons = {}, {}

for _,name in ipairs(tabNames) do
	local page = Instance.new("Frame")
	page.Size = UDim2.new(1,0,1,-70)
	page.Position = UDim2.new(0,0,0,70)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = main
	pages[name] = page
end
pages["Player"].Visible = true

for i,name in ipairs(tabNames) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.5,0,1,0)
	btn.Position = UDim2.new((i-1)*0.5,0,0,0)
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.Parent = tabs
	Instance.new("UICorner",btn).CornerRadius = UDim.new(0,10)

	btn.MouseButton1Click:Connect(function()
		for _,p in pairs(pages) do p.Visible = false end
		pages[name].Visible = true
	end)
end

-- State system
local States = {
	AntiFling = false,
	Fly = false,
	Chams = false
}

-- Functions
local function toggleAntiFling(on)
	if on then
		print("✅ Anti-Fling ACTIVÉ")
		RunService.Heartbeat:Connect(function()
			if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
				LocalPlayer.Character.HumanoidRootPart.RotVelocity = Vector3.new(0,0,0)
			end
		end)
	else
		print("❌ Anti-Fling désactivé")
	end
end

local flying, flyConn
local function toggleFly(on)
	if on then
		print("✅ Fly ACTIVÉ")
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end
		flying = true
		flyConn = RunService.RenderStepped:Connect(function()
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				hrp.CFrame = hrp.CFrame + Vector3.new(0,1,0)
			elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				hrp.CFrame = hrp.CFrame + Vector3.new(0,-1,0)
			end
		end)
	else
		print("❌ Fly désactivé")
		flying = false
		if flyConn then flyConn:Disconnect() end
	end
end

local function toggleChams(on)
	if on then
		print("✅ Chams ACTIVÉ")
		for _,plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character then
				for _,part in pairs(plr.Character:GetChildren()) do
					if part:IsA("BasePart") then
						part.Material = Enum.Material.Neon
						part.Color = Color3.fromRGB(0,255,0)
					end
				end
			end
		end
	else
		print("❌ Chams désactivé")
		for _,plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and plr.Character then
				for _,part in pairs(plr.Character:GetChildren()) do
					if part:IsA("BasePart") then
						part.Material = Enum.Material.Plastic
					end
				end
			end
		end
	end
end

-- Create Toggle Buttons
local function createToggle(parent,text,stateKey,pos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0,150,0,40)
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
	btn.Text = text.." : OFF"
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.Parent = parent
	Instance.new("UICorner",btn).CornerRadius = UDim.new(0,10)

	btn.MouseButton1Click:Connect(function()
		States[stateKey] = not States[stateKey]
		if States[stateKey] then
			btn.Text = text.." : ON"
			TweenService:Create(btn,TweenInfo.new(0.3),{BackgroundColor3=Color3.fromRGB(0,150,0)}):Play()
		else
			btn.Text = text.." : OFF"
			TweenService:Create(btn,TweenInfo.new(0.3),{BackgroundColor3=Color3.fromRGB(150,0,0)}):Play()
		end

		if stateKey=="AntiFling" then toggleAntiFling(States[stateKey]) end
		if stateKey=="Fly" then toggleFly(States[stateKey]) end
		if stateKey=="Chams" then toggleChams(States[stateKey]) end
	end)
end

-- Buttons
createToggle(pages["Player"],"Anti-Fling","AntiFling",UDim2.new(0,20,0,20))
createToggle(pages["Misc"],"Fly","Fly",UDim2.new(0,20,0,20))
createToggle(pages["Misc"],"Chams","Chams",UDim2.new(0,20,0,80))

-- CTRL to hide UI
local visible = true
UserInputService.InputBegan:Connect(function(input,gp)
	if not gp and input.KeyCode == Enum.KeyCode.LeftControl then
		visible = not visible
		main.Visible = visible
	end
end)
