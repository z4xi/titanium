-- neon initialization

if not NEON then
    if not isfile('neon/init.lua')then
        makefolder('neon')
        local raw = 'https://raw.githubusercontent.com/%s/%s/master/init.lua'
        writefile('neon/init.lua',game:HttpGet(raw:format('belkworks','neon')))
    end
    pcall(loadfile('neon/init.lua'))
end

-- dependencies

loadstring(game:HttpGet('https://github.com/Exunys/Aimbot-V2/raw/main/Resources/Scripts/Main.lua'))();

getgenv().Aimbot.Settings = {
    SendNotifications = true,
    SaveSettings = true, -- Re-execute upon changing
    ReloadOnTeleport = true,
    Enabled = false,
    TeamCheck = false,
    AliveCheck = true,
    WallCheck = false, -- Laggy
    Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
    TriggerKey = "MouseButton2",
    Toggle = false,
    LockPart = "Head" -- Body part to lock on (Character part's name)
}

getgenv().Aimbot.FOVSettings = {
    Enabled = false,
    Visible = true,
    Amount = 90,
    Color = "255, 255, 255",
    LockedColor = "255, 70, 70",
    Transparency = 0.5,
    Sides = 60,
    Thickness = 1,
    Filled = false
}

local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

synlog = NEON:github('belkworks', 'synlog')
synlog:setDefaultTime(4)

log = NEON:github('belkworks', 'logfile')

-----------------------------------------------------------------------------------------------------------------------

-- functions

file = log.logfile('events.log')
levels = {
    system = "WARN",
    other = "INFO",
    hush = "OFF"
}

combined = log.combine(file, synlog:logger())
log.init(levels, combined)

-- main script

synlog:print('initializing variables...')
local ver = 'v0.0.2beta'
local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'

local function getTime()
	while true do
		local TimeInUnix = os.time()
		local stringToFormat = "%I:%M %p"
		local result = os.date(stringToFormat, TimeInUnix)

		wait(1)
		return result
	end
end

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character
local Humanoid = Character.Humanoid
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

synlog:print('creating window...')
local Window = Library:CreateWindow({
    -- Set Center to true if you want the menu to appear in the center
    -- Set AutoShow to true if you want the menu to appear when it is created
    -- Position and Size are also valid options here
    -- but you do not need to define them unless you are changing them :)

    Title = 'Titanium B | ' .. ver .. ' | ' .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
    Center = true, 
    AutoShow = true,
})

synlog:print('initializing tabs...')
local Tabs = {
    -- Creates a new tab titled Main
    Player = Window:AddTab('Player'),
    Visuals = Window:AddTab('Visuals'),
    Legit = Window:AddTab('Legit'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

synlog:print('creating items...')

local Movement = Tabs.Player:AddLeftGroupbox('Movement')

Movement:AddSlider('WalkSpeed', {
	Text = 'WalkSpeed',
	Default = 16,
	Min = 16,
	Max = 500,
	Rounding = 1,
	Compact = false,
})

local WalkSpeedVar = Options.WalkSpeed.Value
Options.WalkSpeed:OnChanged(function()
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Options.WalkSpeed.Value
end)

Movement:AddInput('TPText', {
	Text = 'Move to Player',
	Numeric = false,
	Finished = true,
	Tooltip = 'Moves to player entered in text box',
	Placeholder = 'Enter player name...',
})

Options.TPText:OnChanged(function()
	local plr1 = Character
	local plr2 = workspace:FindFirstChild(Options.TPText.Value)
		
	if not plr2 then 
		return
		synlog:error('player not found!')
	end
	plr1:MoveTo(plr2.PrimaryPart.Position + Vector3.new(0,2,0))
		
	synlog:success('teleported to ' .. Options.TPText.Value)
end)

local Body = Tabs.Player:AddLeftGroupbox('Body')

Body:AddButton('No Arms', function()
	if Humanoid.RigType == Enum.HumanoidRigType.R15 then
		for i,v in pairs(Character:GetChildren()) do
			if v:IsA("BasePart") and
				v.Name == "RightUpperArm" or
				v.Name == "LeftUpperArm" then
				v:Destroy()
				synlog:success('removed arms')
			end
		end
	else
		for i,v in pairs(Character:GetChildren()) do
			if v:IsA("BasePart") and
				v.Name == "Right Arm" or
				v.Name == "Left Arm" then
				v:Destroy()
				synlog:success('removed arms')
			end
		end
	end
end)

Body:AddButton('No Legs', function()
	if Humanoid.RigType == Enum.HumanoidRigType.R15 then
		for i,v in pairs(Character:GetChildren()) do
			if v:IsA("BasePart") and
				v.Name == "RightUpperLeg" or
				v.Name == "LeftUpperLeg" then
				v:Destroy()
				synlog:success('removed legs')
			end
		end
	else
		for i,v in pairs(Character:GetChildren()) do
			if v:IsA("BasePart") and
				v.Name == "Right Leg" or
				v.Name == "Left Leg" then
				v:Destroy()
				synlog:success('removed legs')
			end
		end
	end
end)



Body:AddButton('No Limbs', function()
	if Humanoid.RigType == Enum.HumanoidRigType.R15 then
		for i,v in pairs(Character:GetChildren()) do
			if v:IsA("BasePart") and
				v.Name == "RightUpperLeg" or
				v.Name == "LeftUpperLeg" or
				v.Name == "RightUpperArm" or
				v.Name == "LeftUpperArm" then
				v:Destroy()
				synlog:success('removed limbs')
			end
		end
	else
		for i,v in pairs(Character:GetChildren()) do
			if v:IsA("BasePart") and
				v.Name == "Right Leg" or
				v.Name == "Left Leg" or
				v.Name == "Right Arm" or
				v.Name == "Left Arm" then
				v:Destroy()
				synlog:success('removed limbs')
			end
		end
	end
end)

Body:AddButton('Remove Accessories', function()
	for i,v in next, Character:GetDescendants() do
		if v:IsA("Accessory") then
			for i,p in next, v:GetDescendants() do
				if p:IsA("Weld") then
					p:Destroy()
					synlog:success('removed accessories')
				end
			end
		end
	end
end)

local Server = Tabs.Player:AddLeftGroupbox('Server')

Server:AddButton('Rejoin', function()
	synlog:print('rejoining...')
	local ts = game:GetService("TeleportService")
	ts:Teleport(game.PlaceId, Player)
	synlog:success('rejoined! goodbye!')
end)

local LocalPlayer = Tabs.Player:AddLeftGroupbox('LocalPlayer')

LocalPlayer:AddButton('Respawn', function()
	synlog:print('respawning...')
	local char = Player.Character

	if char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid"):ChangeState(15) end

	char:ClearAllChildren()

	local newChar = Instance.new("Model")
	
	newChar.Parent = workspace
	plr.Character = newChar

	wait()

	plr.Character = char
	newChar:Destroy()

	synlog:success('respawned!')
end)

local ESPTab = Tabs.Visuals:AddLeftGroupbox('ESP')

ESPTab:AddToggle('ESPMaster', {
    Text = "Enabled",
    Default = false,
    Tooltip = "Toggles all ESP features"
})

Toggles.ESPMaster:OnChanged(function()
    ESP:Toggle(Toggles.ESPMaster.Value)
end)

local Aim = Tabs.Legit:AddRightGroupbox('Aim')

Aim:AddToggle('AimMaster', {
	Text = 'Master Toggle',
	Default = false,
	Tooltip = 'Toggles aimbot'
})

Aim:AddButton('FactoryResetAim', function()
	getgenv().Aimbot.Settings = {
		SendNotifications = true,
		SaveSettings = true, -- Re-execute upon changing
		ReloadOnTeleport = true,
		Enabled = true,
		TeamCheck = false,
		AliveCheck = true,
		WallCheck = false, -- Laggy
		Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
		TriggerKey = "MouseButton2",
		Toggle = false,
		LockPart = "Head" -- Body part to lock on
	}

	getgenv().Aimbot.FOVSettings = {
		Enabled = true,
		Visible = true,
		Amount = 90,
		Color = "255, 255, 255",
		LockedColor = "255, 70, 70",
		Transparency = 0.5,
		Sides = 60,
		Thickness = 1,
		Filled = false
	}
end)

Toggles.AimMaster:OnChanged(function()
	getgenv().Aimbot.Settings.Enabled = Toggles.AimMaster.Value
end)

local AimSettings = Tabs.Legit:AddLeftGroupbox('Aim Settings')

AimSettings:AddToggle('TeamCheck', {
	Text = 'Team Check',
	Default = false,
	Tooltip = 'Toggles Team Check for Aimbot'
})

Toggles.TeamCheck:OnChanged(function()
	getgenv().Aimbot.Settings.TeamCheck = Toggles.TeamCheck.Value
end)

AimSettings:AddToggle('AliveCheck', {
	Text = 'Alive Check',
	Default = false,
	Tooltip = 'Toggles Alive Check for Aimbot'
})

Toggles.AliveCheck:OnChanged(function()
	getgenv().Aimbot.Settings.AliveCheck = Toggles.AliveCheck.Value
end)

AimSettings:AddToggle('WallCheck', {
	Text = 'Wall Check',
	Default = false,
	Tooltip = 'Toggles Wall Check for Aimbot'
})

Toggles.WallCheck:OnChanged(function()
	getgenv().Aimbot.Settings.WallCheck = Toggles.WallCheck.Value
end)

AimSettings:AddSlider('AimSensitivity', {
	Text = 'Sensitivity',
    Default = 0,
    Min = 0,
    Max = 50,
    Rounding = 1,
    Compact = false,
	Tooltip = 'Animation length of the aim lock'
})

Options.AimSensitivity:OnChanged(function()
	getgenv().Aimbot.Settings.Sensitivity = Options.AimSensitivity.Value
end)

AimSettings:AddLabel('ToggleBind'):AddKeyPicker('AimBindPicker', {
	Default = 'MB2',
	SyncToggleState = true,
	Mode = 'Toggle',
	Text = 'Toggle Bind',
	NoUI = false,
})

Options.AimBindPicker:OnClick(function()
	getgenv().Aimbot.Settings.TriggerKey = Options.AimBindPicker.Value
end)

synlog:print('initializing settings...')

Library:SetWatermarkVisibility(true)

-------------------------------
-- TODO: clock for watermark --
-------------------------------

-- os.date("%x") .. ' ' ..  os.date("%I") .. ':' .. os.date("%M") .. os.date("%p")
-- Sets the watermark text
Library:SetWatermark('Titanium | ' .. 'Welcome, ' .. Player.DisplayName .. '! | ' .. ver)

Library.KeybindFrame.Visible = true; -- todo: add a function for this

Library:OnUnload(function()
	synlog:print('unloading...')
	ESPLib:Toggle()
	synlog:print('unloaded! goodbye!')
    Library.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

-- I set NoUI so it does not show up in the keybinds menu
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' }) 
MenuGroup:AddToggle('Debug', {Text = 'Debug', Default = false, function()
	debug = Toggles.Debug.Value
end})

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager. 
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings() 

-- Adds our MenuKeybind to the ignore list 
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' }) 

-- use case for doing it this way: 
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder('titanium')
SaveManager:SetFolder('titanium/')

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs['UI Settings']) 

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs['UI Settings'])

synlog:success('titanium loaded successfully!')
synlog:print('go to .gg/GSdA9bEqgz for support and suggestions')
