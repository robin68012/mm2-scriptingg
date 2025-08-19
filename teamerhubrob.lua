-- Teamer Hub Fan - Futuristic UI (visual-only)
-- Place: StarterGui -> LocalScript

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local pgui = player:WaitForChild("PlayerGui")

-- ============= THEME =============
-- ========= SERVICES =========
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ========= TOGGLES =========
local Toggles = {
	GrabGun = false,
	GunCham = false,
	PlayerChams = false,
	NameESP = false,
	AntiFling = false,
	FlingTarget = false,
}
local TargetName = nil
local CurrentFlingConnection = nil

-- ========= GRAB GUN =========
local function GrabGun()
	local tool = workspace:FindFirstChild("GunDrop")
	if tool and tool:IsA("Tool") and LocalPlayer.Character then
		LocalPlayer.Character:PivotTo(tool.Handle.CFrame)
	end
end

-- ========= PLAYER CHAMS =========
local function GetRoleColor(plr)
	if not plr.Character then return Color3.fromRGB(150,150,150) end
	local backpack = plr:FindFirstChild("Backpack")
	local char = plr.Character
	if char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")) then
		return Color3.fromRGB(255,0,0) -- Murder
	elseif char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")) then
		return Color3.fromRGB(0,0,255) -- Sheriff
	else
		return Color3.fromRGB(0,255,0) -- Inno
	end
end

local function ApplyESP(plr)
	if plr == LocalPlayer then return end
	local char = plr.Character
	if not char then return end

	for _,part in ipairs(char:GetChildren()) do
		if part:IsA("BasePart") then
			local cham = part:FindFirstChild("Cham")
			if Toggles.PlayerChams then
				if not cham then
					cham = Instance.new("BoxHandleAdornment")
					cham.Name = "Cham"
					cham.Adornee = part
					cham.AlwaysOnTop = true
					cham.ZIndex = 10
					cham.Size = part.Size + Vector3.new(0.05,0.05,0.05)
					cham.Transparency = 0.6
					cham.Parent = part
				end
				cham.Color3 = GetRoleColor(plr)
			elseif cham then
				cham:Destroy()
			end
		end
	end

	if Toggles.NameESP then
		if not char:FindFirstChild("NameBillboard") then
			local bb = Instance.new("BillboardGui")
			bb.Name = "NameBillboard"
			bb.Adornee = char:FindFirstChild("Head")
			bb.Size = UDim2.new(0,200,0,30)
			bb.StudsOffset = Vector3.new(0,2,0)
			bb.AlwaysOnTop = true
			local text = Instance.new("TextLabel", bb)
			text.Size = UDim2.new(1,0,1,0)
			text.BackgroundTransparency = 1
			text.TextColor3 = Color3.fromRGB(255,255,255)
			text.TextStrokeTransparency = 0.5
			text.TextScaled = true
			text.Text = plr.Name
			bb.Parent = char
		end
	else
		if char:FindFirstChild("NameBillboard") then
			char.NameBillboard:Destroy()
		end
	end
end

-- ========= ANTI FLING =========
local function EnableAntiFling()
	if not LocalPlayer.Character then return end
	local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.AssemblyAngularVelocity = Vector3.zero
		hrp.AssemblyLinearVelocity = Vector3.zero
		hrp.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
	end
end

-- ========= FLING TARGET =========
local function StartFling(target)
	if CurrentFlingConnection then CurrentFlingConnection:Disconnect() end
	if not target or not target.Character then return end
	local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
	local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not tRoot or not myRoot then return end

	CurrentFlingConnection = RunService.Heartbeat:Connect(function()
		if not Toggles.FlingTarget then
			CurrentFlingConnection:Disconnect()
			return
		end
		myRoot.CFrame = tRoot.CFrame * CFrame.new(math.random(-10,10), math.random(5,15), math.random(-10,10))
		myRoot.Velocity = Vector3.new(math.random(-150,150), math.random(100,200), math.random(-150,150))
	end)
end

-- ========= MAIN LOOP =========
RunService.Heartbeat:Connect(function()
	if Toggles.GrabGun then GrabGun() end
	if Toggles.AntiFling then EnableAntiFling() end
	if Toggles.PlayerChams or Toggles.NameESP then
		for _,plr in ipairs(Players:GetPlayers()) do
			ApplyESP(plr)
		end
	end
end)
-- ========= PUBLIC API =========
local API = {   -- (à la place de: return { )
	Toggle = Toggles,
	SetTarget = function(name)
		TargetName = name
	end,
	StartFling = function()
		if TargetName then
			local target = Players:FindFirstChild(TargetName)
			if target then
				Toggles.FlingTarget = true
				StartFling(target)
			end
		end
	end,
	StopFling = function()
		Toggles.FlingTarget = false
		if CurrentFlingConnection then CurrentFlingConnection:Disconnect() end
	end
}
 local THEME = {
	bgDark = Color3.fromRGB(14, 14, 20),
	bgPanel = Color3.fromRGB(22, 22, 32),
	bgCard  = Color3.fromRGB(28, 28, 42),
	text    = Color3.fromRGB(220, 225, 235),
	sub     = Color3.fromRGB(150, 155, 170),
	accent  = Color3.fromRGB(0, 230, 200),
	accent2 = Color3.fromRGB(120, 70, 255),
	stroke  = Color3.fromRGB(40, 45, 65),
}

-- ============= ROOT GUI =============
local gui = Instance.new("ScreenGui")
gui.Name = "TeamerHubFanUI"
gui.ResetOnSpawn = false
gui.Parent = pgui

-- Window (not full screen)
local win = Instance.new("Frame")
win.Size = UDim2.new(0, 760, 0, 470)
win.Position = UDim2.new(0.5, -380, 0.5, -235)
win.BackgroundColor3 = THEME.bgDark
win.Parent = gui
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 14)

local winStroke = Instance.new("UIStroke")
winStroke.Color = THEME.stroke
winStroke.Thickness = 2
winStroke.Transparency = 0.4
winStroke.Parent = win

-- Subtle neon gradient
local g = Instance.new("UIGradient", win)
g.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 14, 26)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 20, 30)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 24))
}
g.Rotation = 45

-- Top bar (drag handle)
local top = Instance.new("Frame", win)
top.Size = UDim2.new(1, 0, 0, 34)
top.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
top.BorderSizePixel = 0
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 14)

local topStroke = Instance.new("UIStroke", top)
topStroke.Color = THEME.stroke
topStroke.Thickness = 1
topStroke.Transparency = 0.6

local title = Instance.new("TextLabel", top)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Teamer Hub Fan"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = THEME.text

-- Dragging
do
	local dragging = false
	local dragStart, startPos
	top.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = i.Position
			startPos = win.Position
		end
	end)
	top.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = i.Position - dragStart
			win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

-- Layout: sidebar + content
local bar = Instance.new("Frame", win)
bar.Size = UDim2.new(0, 190, 1, -34)
bar.Position = UDim2.new(0, 0, 0, 34)
bar.BackgroundColor3 = THEME.bgPanel
bar.BorderSizePixel = 0

local barGrad = Instance.new("UIGradient", bar)
barGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(18, 24, 36)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 28, 40))
}
barGrad.Rotation = 90

local barList = Instance.new("UIListLayout", bar)
barList.Padding = UDim.new(0, 10)
barList.HorizontalAlignment = Enum.HorizontalAlignment.Center
barList.VerticalAlignment = Enum.VerticalAlignment.Top

-- Profile card bottom
local profileCard = Instance.new("Frame", bar)
profileCard.Size = UDim2.new(1, -20, 0, 60)
profileCard.Position = UDim2.new(0, 10, 1, -70)
profileCard.BackgroundColor3 = THEME.bgCard
profileCard.AnchorPoint = Vector2.new(0,1)
Instance.new("UICorner", profileCard).CornerRadius = UDim.new(0, 10)
local pcStroke = Instance.new("UIStroke", profileCard)
pcStroke.Color = THEME.stroke
pcStroke.Transparency = 0.5

local avatar = Instance.new("ImageLabel", profileCard)
avatar.BackgroundTransparency = 1
avatar.Size = UDim2.new(0, 36, 0, 36)
avatar.Position = UDim2.new(0, 10, 0.5, -18)
avatar.Image = "rbxassetid://4031889928" -- placeholder circle
local avCorner = Instance.new("UICorner", avatar); avCorner.CornerRadius = UDim.new(1,0)

local uname = Instance.new("TextLabel", profileCard)
uname.BackgroundTransparency = 1
uname.Size = UDim2.new(1, -60, 1, 0)
uname.Position = UDim2.new(0, 56, 0, 0)
uname.TextXAlignment = Enum.TextXAlignment.Left
uname.Text = "@"..player.Name
uname.Font = Enum.Font.GothamSemibold
uname.TextSize = 14
uname.TextColor3 = THEME.sub

-- Menu buttons
local sections = {"Main","Target","Misc","Roles","Webhook","Player","Settings"}

local function makeMenuButton(text, selected)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -20, 0, 36)
	b.BackgroundColor3 = THEME.bgCard
	b.Text = text
	b.TextColor3 = selected and THEME.accent or THEME.text
	b.Font = Enum.Font.GothamSemibold
	b.TextSize = 15
	b.AutoButtonColor = false
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	local s = Instance.new("UIStroke", b)
	s.Color = THEME.stroke
	s.Transparency = 0.5
	-- hover
	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(34, 34, 52)}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = THEME.bgCard}):Play()
	end)
	return b
end

-- Right content
local content = Instance.new("Frame", win)
content.Size = UDim2.new(1, -190, 1, -34)
content.Position = UDim2.new(0, 190, 0, 34)
content.BackgroundTransparency = 1

-- Section header
local header = Instance.new("TextLabel", content)
header.BackgroundTransparency = 1
header.Size = UDim2.new(1, -20, 0, 30)
header.Position = UDim2.new(0, 10, 0, 8)
header.TextXAlignment = Enum.TextXAlignment.Left
header.Font = Enum.Font.GothamBold
header.TextSize = 18
header.TextColor3 = THEME.text
header.Text = "Main"

-- Card container (like your screenshots)
local card = Instance.new("Frame", content)
card.Size = UDim2.new(1, -40, 1, -70)
card.Position = UDim2.new(0, 20, 0, 45)
card.BackgroundColor3 = THEME.bgPanel
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)
local cardStroke = Instance.new("UIStroke", card)
cardStroke.Color = THEME.stroke
cardStroke.Transparency = 0.35

-- List layout inside card
local cardList = Instance.new("UIListLayout", card)
cardList.Padding = UDim.new(0, 10)
cardList.HorizontalAlignment = Enum.HorizontalAlignment.Center
cardList.VerticalAlignment = Enum.VerticalAlignment.Top

local function hr(parent)
	local line = Instance.new("Frame", parent)
	line.Size = UDim2.new(1, -32, 0, 1)
	line.Position = UDim2.new(0, 16, 0, 0)
	line.BackgroundColor3 = THEME.stroke
	line.BackgroundTransparency = 0.2
end

-- ========== UI Components (visual only) ==========
local function ToggleRow(parent, labelText, locked)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, -32, 0, 38)
	row.BackgroundColor3 = THEME.bgCard
	row.BorderSizePixel = 0
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
	local st = Instance.new("UIStroke", row); st.Color = THEME.stroke; st.Transparency = 0.55

	local label = Instance.new("TextLabel", row)
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -80, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = labelText .. (locked and "  🔒" or "")
	label.Font = Enum.Font.Gotham
	label.TextSize = 15
	label.TextColor3 = THEME.text

	-- switch
	local switch = Instance.new("TextButton", row)
	switch.Size = UDim2.new(0, 54, 0, 24)
	switch.Position = UDim2.new(1, -66, 0.5, -12)
	switch.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
	switch.AutoButtonColor = false
	switch.Text = ""
	Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)

	local knob = Instance.new("Frame", switch)
	knob.Size = UDim2.new(0, 20, 0, 20)
	knob.Position = UDim2.new(0, 2, 0.5, -10)
	knob.BackgroundColor3 = Color3.fromRGB(210, 210, 230)
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local enabled = false
	local function setState(on)
		enabled = on
		TweenService:Create(switch, TweenInfo.new(0.18), {
			BackgroundColor3 = on and THEME.accent or Color3.fromRGB(60,60,80)
		}):Play()
		TweenService:Create(knob, TweenInfo.new(0.18), {
			Position = on and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
		}):Play()
	end
	setState(false)
	switch.MouseButton1Click:Connect(function()
		if locked then return end -- locked visual
		setState(not enabled)
	end)

	return row
end

local function SliderRow(parent, labelText, defaultValue)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, -32, 0, 60)
	row.BackgroundColor3 = THEME.bgCard
	row.BorderSizePixel = 0
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
	local st = Instance.new("UIStroke", row); st.Color = THEME.stroke; st.Transparency = 0.55

	local label = Instance.new("TextLabel", row)
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -70, 0, 20)
	label.Position = UDim2.new(0, 12, 0, 6)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = labelText
	label.Font = Enum.Font.Gotham
	label.TextSize = 15
	label.TextColor3 = THEME.text

	local value = Instance.new("TextLabel", row)
	value.BackgroundTransparency = 1
	value.Size = UDim2.new(0, 40, 0, 20)
	value.Position = UDim2.new(1, -50, 0, 6)
	value.Text = tostring(defaultValue or 0)
	value.Font = Enum.Font.GothamSemibold
	value.TextSize = 14
	value.TextColor3 = THEME.sub

	local bar = Instance.new("Frame", row)
	bar.Size = UDim2.new(1, -24, 0, 6)
	bar.Position = UDim2.new(0, 12, 0, 36)
	bar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
	bar.BorderSizePixel = 0
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

	local fill = Instance.new("Frame", bar)
	fill.Size = UDim2.new((defaultValue or 0)/100, 0, 1, 0)
	fill.BackgroundColor3 = THEME.accent2
	Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

	local dragging = false
	bar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
	end)
	bar.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
	bar.InputChanged:Connect(function(i)
		if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
			local rel = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
			fill.Size = UDim2.new(rel, 0, 1, 0)
			value.Text = tostring(math.floor(rel*100))
		end
	end)

	return row
end

local function DropdownRow(parent, labelText, placeholder)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, -32, 0, 38)
	row.BackgroundColor3 = THEME.bgCard
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
	local st = Instance.new("UIStroke", row); st.Color = THEME.stroke; st.Transparency = 0.55

	local label = Instance.new("TextLabel", row)
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -60, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = (placeholder and (labelText.." • "..placeholder)) or labelText
	label.Font = Enum.Font.Gotham
	label.TextSize = 15
	label.TextColor3 = THEME.text

	local grid = Instance.new("TextLabel", row)
	grid.BackgroundTransparency = 1
	grid.Size = UDim2.new(0, 28, 0, 28)
	grid.Position = UDim2.new(1, -38, 0.5, -14)
	grid.Text = "▦"
	grid.TextSize = 18
	grid.TextColor3 = THEME.sub
	grid.Font = Enum.Font.GothamBold

	return row
end

-- ========== BUILD SECTIONS ==========
local panels = {} -- [name] = function to (re)build rows

local function clearCard()
	for _,c in ipairs(card:GetChildren()) do
		if c:IsA("GuiObject") then c:Destroy() end
	end
	-- re-add layout
	cardList = Instance.new("UIListLayout", card)
	cardList.Padding = UDim.new(0, 10)
end

panels.Main = function()
	header.Text = "Main"
	clearCard()
	ToggleRow(card, "Auto Farm", false)
	DropdownRow(card, "Farm Mode", "Nearest")
	ToggleRow(card, "Automatically Grab Gun", false)
	ToggleRow(card, "Dodge Thrown Knife", true) -- locked visuel
	ToggleRow(card, "Auto End Round", false)
	hr(card)
	DropdownRow(card, "Teleport To Lobby", nil)
	DropdownRow(card, "Teleport To Map", nil)
end

panels.Target = function()
	header.Text = "Target"
	clearCard()
	DropdownRow(card, "Target", "username")
	ToggleRow(card, "Fling Target", false)
	ToggleRow(card, "Spectate Target", false)
	ToggleRow(card, "Loop Go To Target", false)
	DropdownRow(card, "Teleport To Target", nil)
end

panels.Misc = function()
	header.Text = "Misc"
	clearCard()
	ToggleRow(card, "Player Chams", false)
	ToggleRow(card, "Gun Cham", false)
	ToggleRow(card, "3DRendering", false)
	ToggleRow(card, "Name ESP", false)
	hr(card)
	DropdownRow(card, "Emote", "ninja")
	ToggleRow(card, "Auto Emote", false)
end

panels.Roles = function()
	header.Text = "Roles"
	clearCard()
	ToggleRow(card, "Kill Aura", false)
	SliderRow(card, "Aura Distance", 5)
	ToggleRow(card, "Auto Kill All", false)
	ToggleRow(card, "Silent Aim", false)
	ToggleRow(card, "Kill Murderer [Locked]", true)
	ToggleRow(card, "Auto Shoot Murderer", false)
	DropdownRow(card, "Shoot Murderer", nil)
end

panels.Webhook = function()
	header.Text = "Webhook"
	clearCard()
	DropdownRow(card, "Webhook", "Webhook")
	hr(card)
	ToggleRow(card, "Coin Tracker", false)
	DropdownRow(card, "Minutes To Send Webhook", "minutes")
	ToggleRow(card, "Unbox Notification [Locked]", true)
end

panels.Player = function()
	header.Text = "Player"
	clearCard()
	ToggleRow(card, "Walk Speed", false)
	SliderRow(card, "Walk Speed", 16)
	ToggleRow(card, "Jump Power", false)
	SliderRow(card, "Jump Power", 50)
	hr(card)
	ToggleRow(card, "Invisible [FE] [Locked]", true)
	ToggleRow(card, "Anti Fling", false)
end

panels.Settings = function()
	header.Text = "Settings"
	clearCard()
	ToggleRow(card, "Auto Save Settings", false)
	ToggleRow(card, "Auto ReExecute", false)
	ToggleRow(card, "Auto Rejoin", false)
	DropdownRow(card, "Rejoin Server", nil)
	DropdownRow(card, "Server Hop", nil)
	DropdownRow(card, "Donate", nil)
end

-- Create menu and navigation
local current = "Main"
for i,sec in ipairs(sections) do
	local b = makeMenuButton(sec, sec == current)
	b.Parent = bar
	b.MouseButton1Click:Connect(function()
		-- recolor all
		for _,btn in ipairs(bar:GetChildren()) do
			if btn:IsA("TextButton") then
				btn.TextColor3 = THEME.text
			end
		end
		b.TextColor3 = THEME.accent
		current = sec
		panels[sec]()
	end)
end

-- initial panel
panels[current]()

-- CTRL to hide/show UI (others scripts unaffected)
local visible = true
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
		visible = not visible
		gui.Enabled = visible
	end
end)
