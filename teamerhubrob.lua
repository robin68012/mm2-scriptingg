--[[========================================================
 Teamer Hub Fan • Eclipse-like Futuristic UI
 Features:
   - Player Tab: Anti-Fling (toggle)
   - Misc Tab  : Player Chams (colors) + Murder Power label
                  Auto Grab Gun (GunDrop pickup)
   - Ctrl hides/shows UI
   - Drag window, animated, neon strokes
   - Refresh chams every 5s + live updates
 Place: StarterGui -> LocalScript
==========================================================]]

--// Services
local Players            = game:GetService("Players")
local RunService         = game:GetService("RunService")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local StarterGui         = game:GetService("StarterGui")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local Workspace          = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

--// THEME
local THEME = {
	bg0   = Color3.fromRGB(15,15,20),
	bg1   = Color3.fromRGB(20,22,30),
	card  = Color3.fromRGB(26,28,40),
	deep  = Color3.fromRGB(10,12,16),
	txt   = Color3.fromRGB(232,235,245),
	sub   = Color3.fromRGB(160,168,186),
	accent= Color3.fromRGB(0,255,200),   -- cyan/vert
	ac2   = Color3.fromRGB(120,70,255),  -- violet
	stk   = Color3.fromRGB(40,48,70),
	green = Color3.fromRGB(70,255,120),  -- Innocent
	red   = Color3.fromRGB(255,80,90),   -- Murder (knife out)
	blue  = Color3.fromRGB(80,150,255),  -- Sheriff (gun out)
	gray  = Color3.fromRGB(140,145,160), -- default/holstered
}

--// ROOT GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TeamerHubFanUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Window
local win = Instance.new("Frame")
win.Size = UDim2.new(0, 760, 0, 470)
win.Position = UDim2.new(0.5, -380, 0.5, -235)
win.BackgroundColor3 = THEME.bg0
win.Parent = gui
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 14)

local winStroke = Instance.new("UIStroke")
winStroke.Parent = win
winStroke.Thickness = 2
winStroke.Color = THEME.stk
winStroke.Transparency = 0.35

-- subtle gradient + entry animation
local grad = Instance.new("UIGradient", win)
grad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0.0, THEME.deep),
	ColorSequenceKeypoint.new(0.5, THEME.bg0),
	ColorSequenceKeypoint.new(1.0, THEME.bg1)
}
grad.Rotation = 35

win.Size = UDim2.new(0, 680, 0, 430)
win.BackgroundTransparency = 1
win.Visible = true
TweenService:Create(win, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 760, 0, 470),
	BackgroundTransparency = 0
}):Play()

-- Top bar (drag)
local top = Instance.new("Frame", win)
top.Size = UDim2.new(1, 0, 0, 38)
top.BackgroundColor3 = THEME.bg1
top.BorderSizePixel = 0
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 14)
local topStroke = Instance.new("UIStroke", top)
topStroke.Color = THEME.stk
topStroke.Transparency = 0.5

local title = Instance.new("TextLabel", top)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = "Teamer Hub Fan"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = THEME.txt

-- Dragging
do
	local dragging, dragStart, startPos = false, nil, nil
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
local side = Instance.new("Frame", win)
side.Size = UDim2.new(0, 200, 1, -38)
side.Position = UDim2.new(0, 0, 0, 38)
side.BackgroundColor3 = THEME.bg1
side.BorderSizePixel = 0
local sideGrad = Instance.new("UIGradient", side)
sideGrad.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, THEME.bg1),
	ColorSequenceKeypoint.new(1, THEME.card)
}
sideGrad.Rotation = 90

local navList = Instance.new("UIListLayout", side)
navList.Padding = UDim.new(0, 10)
navList.HorizontalAlignment = Enum.HorizontalAlignment.Center
navList.VerticalAlignment = Enum.VerticalAlignment.Top

local content = Instance.new("Frame", win)
content.Size = UDim2.new(1, -200, 1, -38)
content.Position = UDim2.new(0, 200, 0, 38)
content.BackgroundTransparency = 1

local header = Instance.new("TextLabel", content)
header.BackgroundTransparency = 1
header.Size = UDim2.new(1, -24, 0, 30)
header.Position = UDim2.new(0, 12, 0, 6)
header.TextXAlignment = Enum.TextXAlignment.Left
header.Font = Enum.Font.GothamBold
header.TextSize = 18
header.TextColor3 = THEME.txt
header.Text = "Player"

local card = Instance.new("Frame", content)
card.Size = UDim2.new(1, -36, 1, -60)
card.Position = UDim2.new(0, 18, 0, 40)
card.BackgroundColor3 = THEME.card
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)
local cardStroke = Instance.new("UIStroke", card)
cardStroke.Color = THEME.stk
cardStroke.Transparency = 0.35
local cardList = Instance.new("UIListLayout", card)
cardList.Padding = UDim.new(0, 10)
cardList.HorizontalAlignment = Enum.HorizontalAlignment.Center
cardList.VerticalAlignment = Enum.VerticalAlignment.Top

local function hr(parent)
	local line = Instance.new("Frame", parent)
	line.Size = UDim2.new(1, -28, 0, 1)
	line.Position = UDim2.new(0, 14, 0, 0)
	line.BackgroundColor3 = THEME.stk
	line.BackgroundTransparency = 0.3
end

-- Component builders
local function makeToggle(parent, labelText)
	local row = Instance.new("Frame", parent)
	row.Size = UDim2.new(1, -28, 0, 44)
	row.BackgroundColor3 = THEME.bg1
	row.BorderSizePixel = 0
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
	local st = Instance.new("UIStroke", row); st.Color = THEME.stk; st.Transparency = 0.5

	local label = Instance.new("TextLabel", row)
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -92, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = labelText
	label.Font = Enum.Font.Gotham
	label.TextSize = 15
	label.TextColor3 = THEME.txt

	local switch = Instance.new("TextButton", row)
	switch.Size = UDim2.new(0, 58, 0, 26)
	switch.Position = UDim2.new(1, -70, 0.5, -13)
	switch.BackgroundColor3 = Color3.fromRGB(70,80,110)
	switch.AutoButtonColor = false
	switch.Text = ""
	Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
	local glow = Instance.new("UIStroke", switch)
	glow.Color = THEME.accent
	glow.Transparency = 0.6

	local knob = Instance.new("Frame", switch)
	knob.Size = UDim2.new(0, 22, 0, 22)
	knob.Position = UDim2.new(0, 2, 0.5, -11)
	knob.BackgroundColor3 = Color3.fromRGB(220,225,235)
	Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

	local enabled = false
	local function set(on)
		enabled = on
		TweenService:Create(switch, TweenInfo.new(0.18), {
			BackgroundColor3 = on and THEME.accent or Color3.fromRGB(70,80,110)
		}):Play()
		TweenService:Create(knob, TweenInfo.new(0.18), {
			Position = on and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
		}):Play()
	end
	set(false)

	switch.MouseButton1Click:Connect(function()
		set(not enabled)
	end)

	return set, function() return enabled end, row
end

local function makeHeader(text)
	header.Text = text
	for _,c in ipairs(card:GetChildren()) do
		if c:IsA("GuiObject") then c:Destroy() end
	end
	cardList = Instance.new("UIListLayout", card)
	cardList.Padding = UDim.new(0, 10)
	cardList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	cardList.VerticalAlignment = Enum.VerticalAlignment.Top
end

local function makeTabButton(txt, selected)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -20, 0, 38)
	b.BackgroundColor3 = THEME.card
	b.Text = txt
	b.TextColor3 = selected and THEME.accent or THEME.txt
	b.Font = Enum.Font.GothamSemibold
	b.TextSize = 15
	b.AutoButtonColor = false
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	local s = Instance.new("UIStroke", b)
	s.Color = THEME.stk
	s.Transparency = 0.5
	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(36,38,56)}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = THEME.card}):Play()
	end)
	return b
end

-- Navigation
local tabs = {"Player","Misc","Roles"}
local buttons = {}
local currentTab = "Player"

for _,name in ipairs(tabs) do
	local btn = makeTabButton(name, name==currentTab)
	btn.Parent = side
	buttons[name] = btn
	btn.MouseButton1Click:Connect(function()
		for n,b in pairs(buttons) do b.TextColor3 = THEME.txt end
		btn.TextColor3 = THEME.accent
		currentTab = name
		if name == "Player" then
			makeHeader("Player")
			_G._ANTI_FLING_SET, _G._ANTI_FLING_GET = makeToggle(card, "Anti Fling")
		elseif name == "Misc" then
			makeHeader("Misc")
			_G._CHAMS_SET, _G._CHAMS_GET = makeToggle(card, "Player Chams (Inno Vert / Murder Rouge / Sheriff Bleu)")
			_G._AUTOGUN_SET, _G._AUTOGUN_GET = makeToggle(card, "Auto Grab Gun (GunDrop)")
			hr(card)
			local info = Instance.new("TextLabel", card)
			info.BackgroundTransparency = 1
			info.Size = UDim2.new(1, -28, 0, 40)
			info.TextWrapped = true
			info.TextXAlignment = Enum.TextXAlignment.Left
			info.Text = "Le power du Murder s’affiche en violet à côté du pseudo."
			info.Font = Enum.Font.Gotham
			info.TextSize = 14
			info.TextColor3 = THEME.sub
		elseif name == "Roles" then
			makeHeader("Roles")
			local t = Instance.new("TextLabel", card)
			t.BackgroundTransparency = 1
			t.Size = UDim2.new(1, -28, 0, 40)
			t.TextXAlignment = Enum.TextXAlignment.Left
			t.Text = "Aucun réglage ici pour l’instant."
			t.Font = Enum.Font.Gotham
			t.TextSize = 14
			t.TextColor3 = THEME.sub
		end
	end)
end

-- Build initial
buttons[currentTab]:Invoke("MouseButton1Click") -- fake click to build
buttons[currentTab].TextColor3 = THEME.accent

-- Hide/Show on CTRL
local visible = true
UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
		visible = not visible
		gui.Enabled = visible
	end
end)

---------------------------------------------------------------------
--                     GAME LOGIC (Client-side)
---------------------------------------------------------------------

--== Utility: fetch character safely
local function getChar(plr)
	return plr and plr.Character or nil
end

--== Detect tool presence
local function hasTool(model, namesSet)
	if not model then return false end
	for _,obj in ipairs(model:GetChildren()) do
		if obj:IsA("Tool") and namesSet[obj.Name] then
			return true
		end
	end
	return false
end

local KNIFE_NAMES = {Knife=true, Sword=true, Blade=true}
local GUN_NAMES   = {Gun=true, Revolver=true, Pistol=true}
local POWER_LIST  = { "Sleight","Ninja","Sprint","Trap","Fake Gun","Haste","Ghost","X-Ray" }
local POWER_SET   = {}
for _,n in ipairs(POWER_LIST) do POWER_SET[n]=true end

-- Try to determine player role + equipped state + power
local function readRoleState(plr)
	local char = getChar(plr)
	local backpack = plr:FindFirstChildOfClass("Backpack")
	local role = "Innocent"
	local armed = "None" -- "Knife" / "Gun" / "None"

	-- Equipped states
	if hasTool(char, KNIFE_NAMES) then
		role = "Murderer"; armed = "Knife"
	elseif hasTool(char, GUN_NAMES) then
		role = "Sheriff";  armed = "Gun"
	else
		-- no tool out → try infer role by backpack contents (still show gray)
		if hasTool(backpack, KNIFE_NAMES) then role = "Murderer" end
		if hasTool(backpack, GUN_NAMES)   then role = "Sheriff"  end
	end

	-- Detect power:
	local powerName = nil
	-- 1) tool named like a power
	for _,obj in ipairs((char and char:GetChildren()) or {}) do
		if obj:IsA("Tool") and POWER_SET[obj.Name] then powerName = obj.Name break end
	end
	if not powerName and backpack then
		for _,obj in ipairs(backpack:GetChildren()) do
			if obj:IsA("Tool") and POWER_SET[obj.Name] then powerName = obj.Name break end
		end
	end
	-- 2) Attributes
	if not powerName then
		powerName = plr:GetAttribute("Power") or plr:GetAttribute("PowerName")
	end
	-- 3) StringValue fallback
	if not powerName then
		local sv = plr:FindFirstChild("Power") or plr:FindFirstChild("PowerName")
		if sv and sv:IsA("StringValue") and sv.Value ~= "" then powerName = sv.Value end
	end

	return role, armed, powerName
end

--== Chams / ESP using Highlight + Billboard
local ESP_FOLDER = Instance.new("Folder")
ESP_FOLDER.Name = "THF_ESP"
ESP_FOLDER.Parent = gui

local ACTIVE_HL = {}    -- [player] = Highlight
local ACTIVE_TAG = {}   -- [player] = BillboardGui

local function colorFor(role, armed)
	if role == "Murderer" and armed == "Knife" then
		return THEME.red
	elseif role == "Sheriff" and armed == "Gun" then
		return THEME.blue
	elseif role == "Innocent" then
		return THEME.green
	else
		return THEME.gray
	end
end

local function ensureESP(plr)
	if plr == LocalPlayer then return end
	local char = getChar(plr)
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	-- Highlight
	local hl = ACTIVE_HL[plr]
	if not hl or not hl.Parent then
		hl = Instance.new("Highlight")
		hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		hl.FillTransparency = 0.7
		hl.OutlineTransparency = 0.1
		hl.Parent = ESP_FOLDER
		ACTIVE_HL[plr] = hl
	end
	hl.Adornee = char

	-- Name tag
	local tag = ACTIVE_TAG[plr]
	if not tag or not tag.Parent then
		tag = Instance.new("BillboardGui")
		tag.Name = "THF_Tag"
		tag.AlwaysOnTop = true
		tag.Size = UDim2.new(0, 200, 0, 50)
		tag.StudsOffsetWorldSpace = Vector3.new(0, 3.2, 0)
		tag.Parent = ESP_FOLDER

		local txt = Instance.new("TextLabel", tag)
		txt.Name = "Text"
		txt.BackgroundTransparency = 1
		txt.Size = UDim2.new(1, 0, 1, 0)
		txt.Font = Enum.Font.GothamBold
		txt.TextSize = 14
		txt.TextColor3 = THEME.txt
		txt.TextStrokeTransparency = 0.6
		txt.Text = ""
	end
	tag.Adornee = hrp

	-- Update text + colors
	local role, armed, power = readRoleState(plr)
	local c = colorFor(role, armed)

	hl.FillColor = c
	hl.OutlineColor = c

	local text = tag:FindFirstChild("Text")
	if text then
		local pow = power and ("  [".. tostring(power) .."]") or ""
		text.Text = string.format("%s  •  %s%s", plr.Name, role, pow)
		if power then text.TextColor3 = THEME.ac2 else text.TextColor3 = THEME.txt end
	end
end

local function clearESP(plr)
	local hl = ACTIVE_HL[plr]; if hl then hl:Destroy() end; ACTIVE_HL[plr] = nil
	local tag = ACTIVE_TAG[plr]; if tag then tag:Destroy() end; ACTIVE_TAG[plr] = nil
end

local function updateAllESP()
	if not _G._CHAMS_GET or not _G._CHAMS_GET() then
		for plr,_ in pairs(ACTIVE_HL) do clearESP(plr) end
		return
	end
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then ensureESP(plr) end
	end
end

-- live hooks
Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		if _G._CHAMS_GET and _G._CHAMS_GET() then
			task.wait(0.2)
			ensureESP(plr)
		end
	end)
end)
Players.PlayerRemoving:Connect(clearESP)

-- refresh every 5s
task.spawn(function()
	while true do
		task.wait(5)
		updateAllESP()
	end
end)

-- also refresh on tool equip/unequip
local function connectToolSignals(plr)
	local function hook(container)
		if not container then return end
		container.ChildAdded:Connect(function(obj)
			if obj:IsA("Tool") and (_G._CHAMS_GET and _G._CHAMS_GET()) then
				task.wait(0.05); ensureESP(plr)
			end
		end)
		container.ChildRemoved:Connect(function(obj)
			if obj:IsA("Tool") and (_G._CHAMS_GET and _G._CHAMS_GET()) then
				task.wait(0.05); ensureESP(plr)
			end
		end)
	end
	hook(plr:FindFirstChildOfClass("Backpack"))
	plr.CharacterAdded:Connect(function(char)
		task.wait(0.2)
		hook(char)
	end)
	if plr.Character then hook(plr.Character) end
end

for _,p in ipairs(Players:GetPlayers()) do
	if p ~= LocalPlayer then connectToolSignals(p) end
end
Players.PlayerAdded:Connect(connectToolSignals)

---------------------------------------------------------------------
-- Anti-Fling (local protection)
---------------------------------------------------------------------
local antiFlingConn = nil
local lastSafeCFrame = nil

local function enableAntiFling(on)
	if antiFlingConn then antiFlingConn:Disconnect() antiFlingConn = nil end
	if not on then return end

	antiFlingConn = RunService.Heartbeat:Connect(function()
		local char = getChar(LocalPlayer)
		if not char then return end
		local hrp = char:FindFirstChild("HumanoidRootPart")
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum then return end

		-- remember last safe pos
		if hum.Health > 0 then
			lastSafeCFrame = hrp.CFrame
		end

		-- clamp velocities (works against body mover flings)
		local lin = hrp.AssemblyLinearVelocity
		local ang = hrp.AssemblyAngularVelocity
		local maxLin, maxAng = 70, 70
		if lin.Magnitude > maxLin then
			hrp.AssemblyLinearVelocity = lin.Unit * maxLin
		end
		if ang.Magnitude > maxAng then
			hrp.AssemblyAngularVelocity = ang.Unit * maxAng
		end

		-- kill sudden huge forces by resetting to safe spot
		if lin.Magnitude > 1500 or (hrp.Position.Y > 1e4 or hrp.Position.Y < -1e4) then
			if lastSafeCFrame then
				hrp.CFrame = lastSafeCFrame + Vector3.new(0,0,0)
				hrp.AssemblyLinearVelocity = Vector3.zero
				hrp.AssemblyAngularVelocity = Vector3.zero
				hum:ChangeState(Enum.HumanoidStateType.GettingUp)
			end
		end
	end)
end

-- bind toggle object
task.spawn(function()
	while not _G._ANTI_FLING_SET do task.wait() end
	-- default off
	_G._ANTI_FLING_SET(false)
	-- watch state
	RunService.RenderStepped:Connect(function()
		if _G._ANTI_FLING_GET then
			enableAntiFling(_G._ANTI_FLING_GET())
		end
	end)
end)

---------------------------------------------------------------------
-- Auto Grab Gun (GunDrop)
---------------------------------------------------------------------
local autoGunConnA, autoGunConnB

local function tryPickGun(part)
	if not part or not part:IsDescendantOf(Workspace) then return end
	if part.Name ~= "GunDrop" then return end
	if not (_G._AUTOGUN_GET and _G._AUTOGUN_GET()) then return end

	local char = getChar(LocalPlayer)
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then return end

	-- Move to the GunDrop and try to claim it
	local oldCF = hrp.CFrame
	hrp.CFrame = part.CFrame + Vector3.new(0, 2.2, 0)
	task.wait(0.1)

	-- Activate prompt if present
	local prompt = part:FindFirstChildWhichIsA("ProximityPrompt", true)
	if prompt then
		pcall(function() fireproximityprompt(prompt) end)
	end

	-- Touch (fallback)
	for _,p in ipairs(part:GetDescendants()) do
		if p:IsA("BasePart") then
			pcall(function()
				firetouchinterest(hrp, p, 0)
				firetouchinterest(hrp, p, 1)
			end)
		end
	end

	-- return to original place smoothly
	TweenService:Create(hrp, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = oldCF}):Play()
end

local function hookGunDropSignals(enable)
	-- disconnect previous
	if autoGunConnA then autoGunConnA:Disconnect() autoGunConnA = nil end
	if autoGunConnB then autoGunConnB:Disconnect() autoGunConnB = nil end
	if not enable then return end

	autoGunConnA = Workspace.ChildAdded:Connect(function(c)
		if c.Name == "GunDrop" then
			task.wait(0.05)
			tryPickGun(c)
		end
	end)
	autoGunConnB = Workspace.DescendantAdded:Connect(function(c)
		if c.Name == "GunDrop" then
			task.wait(0.05)
			tryPickGun(c)
		end
	end)
	-- also check existing
	for _,c in ipairs(Workspace:GetDescendants()) do
		if c.Name == "GunDrop" then tryPickGun(c) end
	end
end

-- bind toggle
task.spawn(function()
	while not _G._AUTOGUN_SET do task.wait() end
	_G._AUTOGUN_SET(false)
	RunService.RenderStepped:Connect(function()
		if _G._AUTOGUN_GET then
			hookGunDropSignals(_G._AUTOGUN_GET())
		end
	end)
end)

---------------------------------------------------------------------
-- Chams controller
---------------------------------------------------------------------
task.spawn(function()
	while not _G._CHAMS_SET do task.wait() end
	_G._CHAMS_SET(false)
	RunService.RenderStepped:Connect(function()
		if _G._CHAMS_GET and _G._CHAMS_GET() then
			updateAllESP()
		else
			for plr,_ in pairs(ACTIVE_HL) do clearESP(plr) end
		end
	end)
end)
