local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua'))()
local Window = Rayfield:CreateWindow({
   Name = ":P",
   Icon = 0,
   LoadingTitle = ":P",
   LoadingSubtitle = "by low",
   ShowText = "S",
   Theme = "DarkBlue", -- (https://docs.sirius.menu/rayfield/configuration/themes)

   ToggleUIKeybind = "K", -- (Enum.KeyCode)

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Basic hub/low"
   },

   KeySystem = true,
   KeySettings = {
      Title = "Key",
      Subtitle = "Key needed, Sorry!",
      Note = "Someones username",
      FileName = "Key",
      SaveKey = true,
      Key = {"sabahalraisfy"}
   }
})
local Tab = Window:CreateTab("Main", "home")
local Section = Tab:CreateSection("Player Movement")

-- WALKSPEED
local p = game.Players.LocalPlayer

local function setWS(v)
	local h = p.Character and p.Character:FindFirstChild("Humanoid")
	if h then h.WalkSpeed = v end
end

Tab:CreateInput({
	Name = "Set Walkspeed",
	PlaceholderText = "16",
	Value = "16",
	RemoveTextAfterFocusLost = false,
	Flag = "Input1",
	Callback = function(t)
		local v = tonumber(t)
		if v then setWS(v) else warn("Invalid") end
	end
})

Tab:CreateSlider({
	Name = "Change Walkspeed",
	Range = {0, 500},
	Increment = 5,
	Suffix = "Speed",
	CurrentValue = 0,
	Flag = "Slider1",
	Callback = setWS
})

local Divider = Tab:CreateDivider()

--JUMPPOWER
local p = game.Players.LocalPlayer

local function setJP(v)
	local h = p.Character and p.Character:FindFirstChild("Humanoid")
	if h then h.JumpPower = v end
end

Tab:CreateInput({
	Name = "Set JumpPower",
	PlaceholderText = "50",
	Value = "50",
	RemoveTextAfterFocusLost = false,
	Flag = "Input1",
	Callback = function(t)
		local v = tonumber(t)
		if v then setJP(v) else warn("Invalid") end
	end
})

Tab:CreateSlider({
	Name = "Change JumpPower",
	Range = {0, 500},
	Increment = 5,
	Suffix = "Power",
	CurrentValue = 0,
	Flag = "Slider1",
	Callback = setJP
})

local Divider = Tab:CreateDivider()
local Divider = Tab:CreateDivider()

-- INF JUMP
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local infJump, key = false, nil

local toggle = Tab:CreateToggle({
	Name = "Infinity Jump",
	CurrentValue = false,
	Flag = "Toggle1",
	Callback = function(v) infJump = v end
})

Tab:CreateInput({
	Name = "Keybind",
	PlaceholderText = "Leave blank for no keybind",
	Value = "",
	RemoveTextAfterFocusLost = false,
	Flag = "Input1",
	Callback = function(t)
		key = t ~= "" and Enum.KeyCode[t:upper()] or nil
	end
})

UIS.InputBegan:Connect(function(i, g)
	if not g and key and i.KeyCode == key then
		infJump = not infJump
		toggle:Set(infJump)
	end
end)

UIS.JumpRequest:Connect(function()
	local c = player.Character
	if infJump and c and c:FindFirstChild("Humanoid") then
		c.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)


local Tab = Window:CreateTab("Server", "server")
local Section = Tab:CreateSection("Joining")

-- Rejoin
local TP = game:GetService("TeleportService")
local plr = game.Players.LocalPlayer
local payload = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/LUND-M/Hub/refs/heads/main/.luau"))()'

Tab:CreateButton({
	Name = "Rejoin Server",
	Callback = function()
		if queue_on_teleport then queue_on_teleport(payload) end
		TP:TeleportToPlaceInstance(game.PlaceId, game.JobId, plr)
	end
})

local TP = game:GetService("TeleportService")
local plr = game.Players.LocalPlayer
local PlaceId = game.PlaceId

local Divider = Tab:CreateDivider()

-- Join Small Server
local HttpService = game:GetService("HttpService")
local TP = game:GetService("TeleportService")
local plr = game.Players.LocalPlayer
local PlaceId = game.PlaceId

local payload = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/LUND-M/Hub/refs/heads/main/.luau"))()'

Tab:CreateButton({
	Name = "Join small server",
	Callback = function()
		if queue_on_teleport then
			queue_on_teleport(payload)
		elseif syn and syn.queue_on_teleport then
			syn.queue_on_teleport(payload)
		elseif fluxus and fluxus.queue_on_teleport then
			fluxus.queue_on_teleport(payload)
		elseif setclipboard then
			setclipboard(payload)
			warn("Error.")
		else
			warn("Error.")
		end

		-- Hent serverliste
		local success, servers = pcall(function()
			local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
			local res = game:HttpGet(url)
			return HttpService:JSONDecode(res).data
		end)

		if not success or not servers then
			warn("Error.")
			return
		end

		local targetServer = nil
		local minPlayers = math.huge

		for _, server in pairs(servers) do
			if server.id ~= game.JobId and server.playing < server.maxPlayers then
				if server.playing == 0 then
					targetServer = server.id
					break
				end
				if server.playing < minPlayers then
					minPlayers = server.playing
					targetServer = server.id
				end
			end
		end

		if targetServer then
			TP:TeleportToPlaceInstance(PlaceId, targetServer, plr)
		else
			warn("No server found.")
		end
	end
})
