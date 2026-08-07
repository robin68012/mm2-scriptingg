local p = game.Players.LocalPlayer
local c = p.Character

local _data = {
    ["Trainer"] = "Chasing",
    ["Role"] = "Sheriff",
    ["Movement"] = "None",
    ["Perk"] = "None",
    ["Knife"] = "Knife",
    ["Gun"] = "Gun",
    ["Effect"] = "None",
    ["MorphType"] = "Custom",
    ["Morph"] = 1,
    ["NPCs"] = 0,
    ["CustomNPCs"] = nil,
    ["MurdererSettings"] = nil,
    ["SheriffSettings"] = nil,
    ["TrainerSettings"] = nil,
    ["CustomNPCs"] = {
        {
            ["Morph"] = 1,
            ["Default"] = "Roblox",
            ["Knife"] = "Knife",
            ["Gun"] = "Gun",
            ["Effect"] = "None"
        },
        {
            ["Morph"] = 2,
            ["Default"] = "Roblox",
            ["Knife"] = "Knife",
            ["Gun"] = "Gun",
            ["Effect"] = "None"
        },
        {
            ["Morph"] = 3,
            ["Default"] = "Roblox",
            ["Knife"] = "Knife",
            ["Gun"] = "Gun",
            ["Effect"] = "None"
        },
        {
            ["Morph"] = 4,
            ["Default"] = "Roblox",
            ["Knife"] = "Knife",
            ["Gun"] = "Gun",
            ["Effect"] = "None"
        },
        {
            ["Morph"] = 5,
            ["Default"] = "Roblox",
            ["Knife"] = "Knife",
            ["Gun"] = "Gun",
            ["Effect"] = "None"
        },
        {
            ["Morph"] = 6,
            ["Default"] = "Roblox",
            ["Knife"] = "Knife",
            ["Gun"] = "Gun",
            ["Effect"] = "None"
        },
        {
            ["Morph"] = 7,
            ["Default"] = "Roblox",
            ["Knife"] = "Knife",
            ["Gun"] = "Gun",
            ["Effect"] = "None"
        },
        {
            ["Morph"] = 8,
            ["Default"] = "Roblox",
            ["Knife"] = "Knife",
            ["Gun"] = "Gun",
            ["Effect"] = "None"
        },
        {
            ["Morph"] = 9,
            ["Default"] = "Roblox",
            ["Knife"] = "Knife",
            ["Gun"] = "Gun",
            ["Effect"] = "None"
        },
        {
            ["Morph"] = 10,
            ["Default"] = "Roblox",
            ["Knife"] = "Knife",
            ["Gun"] = "Gun",
            ["Effect"] = "None"
        },
        {
            ["Morph"] = 11,
            ["Default"] = "Roblox",
            ["Knife"] = "Knife",
            ["Gun"] = "Gun",
            ["Effect"] = "None"
        }
    },
    ["MurdererSettings"] = {
        ["DualWield"] = false,
        ["Stabbing"] = true,
        ["ThrowAccuracy"] = "OFF"
    },
    ["SheriffSettings"] = {
        ["AutoShoot"] = false,
        ["ShotAccuracy"] = "Straight"
    },
    ["TrainerSettings"] = {
        ["Mini"] = false,
        ["SpawnWithGun"] = true
    }
}

local function a()
    p.PlayerGui.HUD.Visible = false
    game.ReplicatedStorage.Events.RemoteEvents.StartTraining:FireServer(_data)
    while wait(1) do
        for _, r in game.Workspace.Rigs:GetChildren() do
            if r:FindFirstChild("HumanoidRootPart") then
                if c:FindFirstChild("Knife") then
                    r.HumanoidRootPart.Position = c.Knife.Handle.Position
                    c.Knife.KnifeServer.SlashStart:FireServer()
                end
            end
            wait(math.random(2, 4))
        end
    end
end

-- Gestion des personnages
local function onCharacterAdded(newCharacter)
	c = newCharacter
    wait(2)
    a()
end

p.CharacterAdded:Connect(onCharacterAdded)
a()
