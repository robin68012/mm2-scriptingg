--// Teamer Hub Fan - UI System (StarterGui) \\--

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "TeamerHubFan"
gui.ResetOnSpawn = false
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 500, 0, 300)
main.Position = UDim2.new(0.3, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0
main.Visible = true
main.Active = true
main.Draggable = true
main.Parent = gui

-- UI Corner
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0,15)
mainCorner.Parent = main

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Teamer Hub Fan"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = main

-- Title Glow effect
task.spawn(function()
	while task.wait(1) do
		TweenService:Create(title, TweenInfo.new(1), {TextColor3 = Color3.fromRGB(0,200,255)}):Play()
		wait(1)
		TweenService:Create(title, TweenInfo.new(1), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
	end
end)

-- Tab buttons
local tabs = Instance.new("Frame")
tabs.Size = UDim2.new(1,0,0,30)
tabs.Position = UDim2.new(0,0,0,40)
tabs.BackgroundTransparency = 1
tabs.Parent = main

local tabNames = {"Player","Misc","Target","Settings"}
local tabButtons = {}
local pages = {}

-- Create pages
for _,name in ipairs(tabNames) do
	local page = Instance.new("Frame")
	page.Size = UDim2.new(1,0,1,-70)
	page.Position = UDim2.new(0,0,0,70)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = main
	pages[name] = page
end
pages["Player"].Visible = true -- default

-- Create tab buttons
for i,name in ipairs(tabNames) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0.25,0,1,0)
	btn.Position = UDim2.new((i-1)*0.25,0,0,0)
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.Parent = tabs

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,10)
	corner.Parent = btn

	btn.MouseButton1Click:Connect(function()
		for _,p in pairs(pages) do p.Visible=false end
		pages[name].Visible = true
	end)
end

-- Function to create toggle buttons
local function createToggle(parent,text,pos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0,150,0,40)
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(150,0,0)
	btn.Text = text.." : OFF"
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	btn.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,10)
	corner.Parent = btn

	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		if state then
			btn.Text = text.." : ON"
			TweenService:Create(btn,TweenInfo.new(0.3),{BackgroundColor3=Color3.fromRGB(0,150,0)}):Play()
		else
			btn.Text = text.." : OFF"
			TweenService:Create(btn,TweenInfo.new(0.3),{BackgroundColor3=Color3.fromRGB(150,0,0)}):Play()
		end
	end)

	return btn,state
end

-- PLAYER tab
createToggle(pages["Player"],"Anti-Fling",UDim2.new(0,20,0,20))

-- MISC tab
createToggle(pages["Misc"],"Fly",UDim2.new(0,20,0,20))
createToggle(pages["Misc"],"Chams",UDim2.new(0,20,0,80))

local grabBtn = Instance.new("TextButton")
grabBtn.Size = UDim2.new(0,150,0,40)
grabBtn.Position = UDim2.new(0,20,0,140)
grabBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
grabBtn.Text = "Grab Gun"
grabBtn.TextColor3 = Color3.fromRGB(255,255,255)
grabBtn.Font = Enum.Font.GothamBold
grabBtn.TextScaled = true
grabBtn.Parent = pages["Misc"]
Instance.new("UICorner",grabBtn).CornerRadius = UDim.new(0,10)

-- TARGET tab
local box = Instance.new("TextBox")
box.Size = UDim2.new(0,200,0,40)
box.Position = UDim2.new(0,20,0,20)
box.PlaceholderText = "Enter Player Name"
box.BackgroundColor3 = Color3.fromRGB(40,40,40)
box.TextColor3 = Color3.fromRGB(255,255,255)
box.Font = Enum.Font.Gotham
box.TextScaled = true
box.Parent = pages["Target"]
Instance.new("UICorner",box).CornerRadius = UDim.new(0,10)

local flingBtn = Instance.new("TextButton")
flingBtn.Size = UDim2.new(0,150,0,40)
flingBtn.Position = UDim2.new(0,20,0,80)
flingBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
flingBtn.Text = "Fling Target"
flingBtn.TextColor3 = Color3.fromRGB(255,255,255)
flingBtn.Font = Enum.Font.GothamBold
flingBtn.TextScaled = true
flingBtn.Parent = pages["Target"]
Instance.new("UICorner",flingBtn).CornerRadius = UDim.new(0,10)

-- SETTINGS tab
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1,0,0,40)
info.Position = UDim2.new(0,0,0,20)
info.BackgroundTransparency = 1
info.Text = "Press CTRL to toggle UI"
info.TextColor3 = Color3.fromRGB(200,200,200)
info.Font = Enum.Font.Gotham
info.TextScaled = true
info.Parent = pages["Settings"]

-- Fade In/Out on CTRL
local visible = true
UserInputService.InputBegan:Connect(function(input,gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
		visible = not visible
		if visible then
			main.Visible = true
			main.BackgroundTransparency = 1
			TweenService:Create(main,TweenInfo.new(0.4),{BackgroundTransparency=0}):Play()
		else
			TweenService:Create(main,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
			wait(0.4)
			main.Visible = false
		end
	end
end)
