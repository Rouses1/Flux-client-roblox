-- ClientOnly Visual Cheat Menu (safe, client-side)
-- Помести в StarterPlayer > StarterPlayerScripts
-- Автор: ChatGPT (пример). Пароль для входа: JAPJ-FLZM-61JS

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ========== CONFIG ==========
local ACCESS_PASSWORD = "JAPJ-FLZM-61JS"
local GUI_NAME = "VisualCheatGUI"
local TRACK_TAG = "VisualTrack" -- можно помечать сущности CollectionService:AddTag(inst, TRACK_TAG)
-- ============================

-- helper
local function create(className, props)
	local obj = Instance.new(className)
	if props then
		for k,v in pairs(props) do obj[k] = v end
	end
	return obj
end

-- Remove existing (for fast re-deploy)
if player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild(GUI_NAME) then
	player.PlayerGui[GUI_NAME]:Destroy()
end

-- ---------- ScreenGui ----------
local screenGui = create("ScreenGui", {
	Name = GUI_NAME,
	ResetOnSpawn = false,
	Parent = player:WaitForChild("PlayerGui")
})

-- modern draggable main window
local main = create("Frame", {
	Name = "Main",
	Parent = screenGui,
	AnchorPoint = Vector2.new(0.5,0.5),
	Position = UDim2.new(0.5,0.5),
	Size = UDim2.new(0,420,0,520),
	BackgroundColor3 = Color3.fromRGB(18,18,18),
	BorderSizePixel = 0,
	ZIndex = 2,
})
main.BackgroundTransparency = 0.02
main.ClipsDescendants = true
main.RoundCorner = nil

-- subtle white border
local border = create("UIStroke", {Parent = main, Color = Color3.new(1,1,1), Thickness = 1})
border.Transparency = 0.85

-- draggable
local drag = Instance.new("LocalScript")
drag.Name = "DragScript"
drag.Source = [[
local frame = script.Parent
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
]]
drag.Parent = main

-- header + title
local header = create("Frame", {
	Parent = main,
	Size = UDim2.new(1,0,0,44),
	BackgroundTransparency = 1,
})
local title = create("TextLabel", {
	Parent = header,
	Size = UDim2.new(1,0,1,0),
	Text = "Visual Menu",
	Font = Enum.Font.GothamBold,
	TextSize = 20,
	TextColor3 = Color3.new(1,1,1),
	BackgroundTransparency = 1,
})

-- content holder
local content = create("Frame", {
	Parent = main,
	Position = UDim2.new(0,12,0,56),
	Size = UDim2.new(1,-24,1,-68),
	BackgroundTransparency = 1,
})

-- simple function to create toggle rows
local function addToggle(parent, name, default, onToggle)
	local row = create("Frame", {Parent = parent, Size = UDim2.new(1,0,0,34), BackgroundTransparency = 1})
	local label = create("TextLabel", {
		Parent = row, Position = UDim2.new(0,6,0,4), Size = UDim2.new(0.66,-6,1,0),
		Text = name, Font = Enum.Font.Gotham, TextSize = 16, TextColor3 = Color3.new(1,1,1), BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left
	})
	local btn = create("TextButton", {
		Parent = row, Position = UDim2.new(1,-70,0,4), Size = UDim2.new(0,64,0,26),
		Text = default and "ON" or "OFF", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Color3.new(0,0,0),
		BackgroundColor3 = default and Color3.fromRGB(255,255,255) or Color3.fromRGB(80,80,80), AutoButtonColor = true, BorderSizePixel = 0
	})
	btn.MouseButton1Click:Connect(function()
		local new = not (btn:GetAttribute("state") == true)
		btn:SetAttribute("state", new)
		btn.Text = new and "ON" or "OFF"
		btn.BackgroundColor3 = new and Color3.fromRGB(255,255,255) or Color3.fromRGB(80,80,80)
		if onToggle then pcall(onToggle, new) end
	end)
	btn:SetAttribute("state", default)
	return row, btn
end

-- visual list container
local listFrame = create("Frame", {
	Parent = content, Position = UDim2.new(0,0,0,0), Size = UDim2.new(1,0,0,260), BackgroundTransparency = 1
})
local uiList = create("UIListLayout", {Parent = listFrame, Padding = UDim.new(0,6)})
uiList.VerticalAlignment = Enum.VerticalAlignment.Top

-- state tables
local state = {
	esp = false,
	tracers = false,
	offparticles = false,
	tracked = {}, -- list of instances
}

-- LOG (bottom)
local logFrame = create("Frame", {Parent = main, Position = UDim2.new(0,12,1,-90), Size = UDim2.new(1,-24,0,78), BackgroundTransparency = 0.03})
local logTitle = create("TextLabel", {Parent = logFrame, Text = "Log", Size = UDim2.new(1,0,0,20), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(1,1,1), Font = Enum.Font.GothamBold, TextSize = 14})
local logBody = create("TextLabel", {Parent = logFrame, Position = UDim2.new(0,6,0,22), Size = UDim2.new(1,-12,1,-26), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(1,1,1), Font = Enum.Font.Gotham, TextSize = 12, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top})
local logLines = {}
local function log(msg)
	table.insert(logLines, 1, os.date("%H:%M:%S") .. " — " .. tostring(msg))
	if #logLines > 6 then table.remove(logLines, 7) end
	logBody.Text = table.concat(logLines, "\n")
end

-- ---------- AUTH UI ----------
local authFrame = create("Frame", {Parent = screenGui, AnchorPoint = Vector2.new(0.5,0.5), Position = UDim2.new(0.5,0.5), Size = UDim2.new(0,360,0,160), BackgroundColor3 = Color3.fromRGB(18,18,18)})
create("UIStroke", {Parent = authFrame, Color = Color3.new(1,1,1), Transparency = 0.85})
local authLabel = create("TextLabel", {Parent = authFrame, Text = "Enter password to open menu", Size = UDim2.new(1,0,0,36), BackgroundTransparency = 1, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.Gotham, TextSize = 16})
local authBox = create("TextBox", {Parent = authFrame, Position = UDim2.new(0,18,0,50), Size = UDim2.new(1,-36,0,34), Text = "", PlaceholderText = "Password", Font = Enum.Font.Gotham, TextSize = 16})
local authBtn = create("TextButton", {Parent = authFrame, Position = UDim2.new(0.5,-64,0,100), Size = UDim2.new(0,128,0,32), Text = "Unlock", Font = Enum.Font.Gotham, TextSize = 16, BackgroundColor3 = Color3.fromRGB(255,255,255)})
authBtn.MouseButton1Click:Connect(function()
	local text = authBox.Text or ""
	if text == ACCESS_PASSWORD then
		authFrame:Destroy()
		screenGui.Enabled = true
		log("Авторизация успешна.")
	else
		log("Неверный пароль.")
	end
end)
-- hide main until auth
screenGui.Enabled = false

-- ---------- ESP Implementation ----------
local espFolder = Instance.new("Folder", script)
espFolder.Name = "ESP_Folder"

local espBillboards = {} -- map character -> billboard

local function makeBillboardForCharacter(char)
	if not char or not char.Parent then return end
	local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
	if not hrp then return end
	-- create BillboardGui
	local bb = create("BillboardGui", {Adornee = hrp, Size = UDim2.new(0,120,0,40), AlwaysOnTop = true, MaxDistance = 1000})
	local frame = create("Frame", {Parent = bb, Size = UDim2.new(1,1,1,1), BackgroundTransparency = 0.15, BorderSizePixel = 0})
	local name = create("TextLabel", {Parent = frame, Size = UDim2.new(1,1,0,20), Position = UDim2.new(0,0,0,0), BackgroundTransparency = 1, Text = char.Name, TextColor3 = Color3.new(1,1,1), Font=Enum.Font.Gotham, TextSize=14})
	local hp = create("Frame", {Parent = frame, Position = UDim2.new(0,6,1,-18), Size = UDim2.new(1,-12,0,8), BackgroundColor3 = Color3.fromRGB(30,30,30)})
	local hpFill = create("Frame", {Parent = hp, Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.new(0,1,0)})
	bb.Parent = espFolder
	return bb, hpFill
end

local function removeBillboard(char)
	if espBillboards[char] and espBillboards[char].gui then
		espBillboards[char].gui:Destroy()
		espBillboards[char] = nil
	end
end

local function updateESP()
	for char, data in pairs(espBillboards) do
		if not char or not char.Parent then
			removeBillboard(char)
		else
			local humanoid = char:FindFirstChildOfClass("Humanoid")
			if humanoid and data.hp then
				local health = humanoid.Health / math.max(humanoid.MaxHealth, 1)
				data.hp.Size = UDim2.new(math.clamp(health,0,1),0,1,0)
				data.gui.Adornee = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
			end
		end
	end
end

-- ---------- Tracers Implementation ----------
-- Tracer = thin Frame drawn from bottom center to target screen position
local tracerFolder = create("Folder", {Parent = screenGui, Name = "Tracers"})
local tracerPool = {} -- character -> frame

local function createTracerForChar(char)
	local t = create("Frame", {Parent = screenGui, Size = UDim2.new(0,2,0,0), AnchorPoint = Vector2.new(0.5,1), BackgroundTransparency = 0.2})
	t.ZIndex = 1
	t.LayoutOrder = 1
	return t
end

local function updateTracers()
	local vw, vh = camera.ViewportSize.X, camera.ViewportSize.Y
	local bottom = Vector2.new(vw/2, vh)
	for char, frame in pairs(tracerPool) do
		if not char or not char.Parent then
			frame:Destroy(); tracerPool[char] = nil
		else
			local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
			if hrp then
				local pos, onScreen = camera:WorldToViewportPoint(hrp.Position + Vector3.new(0,2,0))
				if onScreen then
					local target = Vector2.new(pos.X, pos.Y)
					local dir = target - bottom
					local mag = dir.Magnitude
					frame.Size = UDim2.new(0, 2, 0, mag)
					frame.Position = UDim2.new(0, bottom.X - 1, 0, bottom.Y)
					local angle = math.deg(math.atan2(dir.Y, dir.X)) + 90
					frame.Rotation = angle
					frame.Visible = true
				else
					frame.Visible = false
				end
			end
		end
	end
end

-- ---------- Particle disabling (client-only) ----------
local function setParticlesEnabled(enabled)
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("ParticleEmitter") then
			pcall(function() obj.Enabled = enabled end)
		end
		if obj:IsA("Trail") then
			pcall(function() obj.Enabled = enabled end)
		end
	end
	log("Particles " .. (enabled and "ON" or "OFF") .. " (локально)")
end

-- ---------- UI Toggles ----------
addToggle(listFrame, "ESP (визуально)", false, function(val)
	state.esp = val
	if val then
		-- create billboards for all characters except local
		for _, pl in pairs(Players:GetPlayers()) do
			if pl ~= player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
				if not espBillboards[pl.Character] then
					local gui, hp = makeBillboardForCharacter(pl.Character)
					espBillboards[pl.Character] = {gui = gui, hp = hp}
				end
			end
		end
		log("ESP включен")
	else
		-- remove all
		for char,_ in pairs(espBillboards) do removeBillboard(char) end
		log("ESP выключен")
	end
end)

addToggle(listFrame, "Tracers", false, function(val)
	state.tracers = val
	if val then
		-- create tracer frames for all players
		for _, pl in pairs(Players:GetPlayers()) do
			if pl ~= player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
				if not tracerPool[pl.Character] then
					tracerPool[pl.Character] = createTracerForChar(pl.Character)
				end
			end
		end
		log("Tracers включены")
	else
		for _, f in pairs(tracerPool) do if f and f.Destroy then f:Destroy() end end
		tracerPool = {}
		log("Tracers выключены")
	end
end)

addToggle(listFrame, "OffParticles (локально)", false, function(val)
	state.offparticles = val
	setParticlesEnabled(not val)
end)

-- ---------- Tracked entities UI ----------
local trackTitle = create("TextLabel", {Parent = content, Position = UDim2.new(0,0,0,268), Size = UDim2.new(1,0,0,20), Text = "Tracked Entities (добавь через список)", BackgroundTransparency = 1, TextColor3 = Color3.new(1,1,1), Font = Enum.Font.Gotham, TextSize = 14})
local addTrackRow = create("Frame", {Parent = content, Position = UDim2.new(0,0,0,293), Size = UDim2.new(1,0,0,36), BackgroundTransparency = 1})
local trackBox = create("TextBox", {Parent = addTrackRow, Position = UDim2.new(0,6,0,4), Size = UDim2.new(0.66,-6,1, -8), PlaceholderText = "Имя модели (пример: Zombie)", Text = "", Font = Enum.Font.Gotham, TextSize = 14})
local trackBtn = create("TextButton", {Parent = addTrackRow, Position = UDim2.new(1,-86,0,4), Size = UDim2.new(0,80,0,28), Text = "Добавить", Font = Enum.Font.Gotham, TextSize = 14})
trackBtn.MouseButton1Click:Connect(function()
	local name = trackBox.Text:match("%S+")
	if not name or name == "" then return end
	table.insert(state.tracked, name)
	log("Добавлено в трек: "..name)
	trackBox.Text = ""
end)

-- ---------- Maintain lists when players join/leave ----------
Players.PlayerAdded:Connect(function(pl)
	pl.CharacterAdded:Connect(function(ch)
		-- ESP
		if state.esp and pl ~= player then
			if not espBillboards[ch] then
				local gui, hp = makeBillboardForCharacter(ch)
				espBillboards[ch] = {gui = gui, hp = hp}
			end
		end
		-- tracer
		if state.tracers and pl ~= player then
			if not tracerPool[ch] then
				tracerPool[ch] = createTracerForChar(ch)
			end
		end
	end)
end)
Players.PlayerRemoving:Connect(function(pl)
	if pl.Character then
		removeBillboard(pl.Character)
		if tracerPool[pl.Character] then
			tracerPool[pl.Character]:Destroy()
			tracerPool[pl.Character] = nil
		end
	end
end)

-- ---------- Auto-detect tracked entities in workspace ----------
local function scanForTrackedEntities()
	for _, name in ipairs(state.tracked) do
		for _, inst in ipairs(workspace:GetDescendants()) do
			if inst.Name == name and inst:IsA("Model") and inst:FindFirstChildWhichIsA("BasePart") then
				if not CollectionService:HasTag(inst, TRACK_TAG) then
					CollectionService:AddTag(inst, TRACK_TAG)
					log("Найдена сущность и помечена: "..inst:GetFullName())
				end
			end
		end
	end
end

-- run loop
RunService.RenderStepped:Connect(function()
	-- update ESP hp bars and billboards
	if state.esp then updateESP() end
	if state.tracers then updateTracers() end
	-- scan tracked entities occasionally
end)

-- periodic scan (every 6 sec)
spawn(function()
	while true do
		pcall(scanForTrackedEntities)
		wait(6)
	end
end)

-- Finish init
screenGui.Enabled = false -- remain hidden until auth is correct
log("GUI готово. Введи пароль чтобы открыть.")