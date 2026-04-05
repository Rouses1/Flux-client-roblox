local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")
local StarterGui = game:GetService("StarterGui")

local S = {
	AimbotEnabled = true,
	PSilent = false,
	IgnoreSlipping = true,
	VisibleCheck = true,
	RCS = true,
	FOV = 80,
	Smooth = 0.25,
	Prediction = 0.165,
	HitboxScale = 3.3,
	TargetLostDelay = 0.12,
	RecoilComp = 0.002,
	ESPEnabled = true,
	Skeleton = true,
	Tracers = true,
	Names = true,
	FOVCircle = true,
	NightVision = true,
	TargetAnim = 1,
	AutoFarm = false,
	OreAimbot = false,
	TriggerBot = false,
}

local AC = Color3.fromRGB(110, 90, 210)
local AC2 = Color3.fromRGB(140, 120, 240)
local BG = Color3.fromRGB(15, 15, 20)
local SB = Color3.fromRGB(20, 18, 28)
local HD = Color3.fromRGB(18, 16, 26)
local BR = Color3.fromRGB(55, 48, 100)
local TX = Color3.fromRGB(210, 205, 225)
local DM = Color3.fromRGB(110, 105, 140)
local OF = Color3.fromRGB(45, 42, 65)
local WH = Color3.fromRGB(255, 255, 255)
local BK = Color3.fromRGB(0, 0, 0)
local GR = Color3.fromRGB(80, 200, 100)

local nv = Instance.new("ColorCorrectionEffect")
nv.Name = "NV_lw"
nv.Brightness = 0.08
nv.Contrast = 0.2
nv.Saturation = -0.35
nv.TintColor = Color3.fromRGB(170, 200, 230)
nv.Enabled = S.NightVision
nv.Parent = Lighting
Lighting.Brightness = 2
Lighting.Ambient = Color3.fromRGB(110, 120, 130)
Lighting.OutdoorAmbient = Color3.fromRGB(120, 130, 140)
Lighting.FogEnd = 100000

local circle = Drawing.new("Circle")
circle.Radius = S.FOV
circle.Thickness = 1
circle.Color = AC
circle.Transparency = 1
circle.Filled = false
circle.Visible = S.FOVCircle

local tLines = {}
for i = 1, 4 do
	local l = Drawing.new("Line")
	l.Thickness = 2
	l.Color = AC
	l.Visible = false
	table.insert(tLines, l)
end

local tLines2 = {}
for i = 1, 8 do
	local l = Drawing.new("Line")
	l.Thickness = 1
	l.Color = AC2
	l.Visible = false
	table.insert(tLines2, l)
end

local tLines3 = {}
for i = 1, 2 do
	local l = Drawing.new("Line")
	l.Thickness = 2
	l.Color = AC
	l.Visible = false
	table.insert(tLines3, l)
end

local gLine = Drawing.new("Line")
gLine.Thickness = 1
gLine.Color = AC
gLine.Visible = false

local cText = Drawing.new("Text")
cText.Size = 28
cText.Color = AC
cText.Center = true
cText.Outline = true
cText.OutlineColor = BK
cText.Visible = true

local ESPBoxes, TracerObjs, SkelObjs, NameObjs = {}, {}, {}, {}

local function newLine(col)
	local l = Drawing.new("Line")
	l.Color = col or AC
	l.Thickness = 1
	return l
end

local function createESP(p)
	local box = Drawing.new("Square")
	box.Color = AC
	box.Thickness = 1
	box.Filled = false
	local t1 = Drawing.new("Line")
	t1.Color = AC
	t1.Thickness = 1
	local t2 = Drawing.new("Line")
	t2.Color = AC
	t2.Thickness = 1
	local skel = {
		headTorso = newLine(AC),
		leftArm = newLine(AC),
		rightArm = newLine(AC),
		leftLeg = newLine(AC),
		rightLeg = newLine(AC),
	}
	local name = Drawing.new("Text")
	name.Size = 12
	name.Center = true
	name.Outline = true
	name.Color = AC
	ESPBoxes[p] = box
	TracerObjs[p] = {t1, t2}
	SkelObjs[p] = skel
	NameObjs[p] = name
end

for _, p in ipairs(Players:GetPlayers()) do
	if p ~= LocalPlayer then createESP(p) end
end
Players.PlayerAdded:Connect(function(p)
	if p ~= LocalPlayer then createESP(p) end
end)
Players.PlayerRemoving:Connect(function(p)
	if ESPBoxes[p] then ESPBoxes[p]:Remove() end
	if TracerObjs[p] then for _, l in ipairs(TracerObjs[p]) do l:Remove() end end
	if SkelObjs[p] then for _, l in pairs(SkelObjs[p]) do l:Remove() end end
	if NameObjs[p] then NameObjs[p]:Remove() end
end)

local function isVisible(part, character)
	if not S.VisibleCheck then return true end
	local origin = Camera.CFrame.Position
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
	params.FilterType = Enum.RaycastFilterType.Blacklist
	local hb = part.Size.Magnitude * (S.HitboxScale - 1) / 2
	for _, off in ipairs({Vector3.new(0,0,0), Vector3.new(hb,hb,0), Vector3.new(-hb,hb,0), Vector3.new(hb,-hb,0), Vector3.new(-hb,-hb,0)}) do
		local dir = (part.Position + off) - origin
		local r = workspace:Raycast(origin, dir, params)
		if not r or r.Instance:IsDescendantOf(character) then return true end
	end
	return false
end

local function w2sv(part)
	local p = Camera:WorldToViewportPoint(part.Position)
	return Vector2.new(p.X, p.Y)
end

local function enlargeHitboxes()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character then
			for _, part in ipairs(player.Character:GetChildren()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
					local orig = part.Size
					part.Size = orig * S.HitboxScale
					task.wait(0.05)
					part.Size = orig
				end
			end
		end
	end
end
task.spawn(function()
	while true do task.wait(0.5); enlargeHitboxes() end
end)

local isFarming = false
local farmWalkSpeed = 24
local farmJumpPower = 70
local origWalkSpeed = 16
local origJumpPower = 50
local farmCircleAngle = 0
local farmStuckTimer = 0
local farmLastPos = nil

local function afAutoRespawn()
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChild("Humanoid")
	if hum and hum.Health <= 0 then
		task.wait(2)
		LocalPlayer:LoadCharacter()
		task.wait(3)
		return true
	end
	return false
end

local function afSetSpeed(sp, jp)
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChild("Humanoid")
	if hum then
		hum.WalkSpeed = sp or origWalkSpeed
		hum.JumpPower = jp or origJumpPower
	end
end

local function afOreReachable(ore)
	if not ore or not ore.Parent then return false end
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return false end
	if ore.Position.Y < -10 then return false end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = {char, ore}
	local dir = ore.Position - hrp.Position
	local dist = dir.Magnitude
	if dist > 200 then return true end
	local r = workspace:Raycast(hrp.Position, dir.Unit * dist, params)
	if r then
		local h = r.Instance
		if h and h ~= ore and not h:IsDescendantOf(char) then
			if h.CanCollide and h.Transparency < 0.5 then return false end
		end
	end
	return true
end

local function afGetNearest()
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end
	local nearest, shortest = nil, math.huge
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("BasePart") and obj.Name == "IronPart" and obj.Parent then
			local d = (hrp.Position - obj.Position).Magnitude
			if d < shortest and d <= 1000000 and afOreReachable(obj) then
				shortest = d
				nearest = obj
			end
		end
	end
	return nearest
end

local function afMine(ore)
	pcall(function()
		local cd = ore:FindFirstChildWhichIsA("ClickDetector")
		if cd then cd:Click() end
		local pp = ore:FindFirstChildWhichIsA("ProximityPrompt")
		if pp then pp:Prompt() end
		local char = LocalPlayer.Character
		if char then
			local tool = char:FindFirstChildWhichIsA("Tool")
			if tool then
				local act = tool:FindFirstChild("Activate")
				if act then act:FireServer(ore) end
			end
		end
	end)
end

local function afCircle(ore, radius)
	if not ore or not ore.Parent then return end
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChild("Humanoid")
	if not hrp or not hum then return end
	radius = radius or 3.5
	farmCircleAngle = farmCircleAngle + 0.4
	local op = ore.Position
	hum:MoveTo(Vector3.new(op.X + math.cos(farmCircleAngle) * radius, op.Y + 1.5, op.Z + math.sin(farmCircleAngle) * radius))
end

local function afMoveTo(ore)
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChild("Humanoid")
	if not hrp or not hum then return false end
	local op = ore.Position
	farmStuckTimer = 0
	farmLastPos = hrp.Position
	local path = PathfindingService:CreatePath()
	local ok = pcall(function() path:ComputeAsync(hrp.Position, op) end)
	if ok and path.Status == Enum.PathStatus.Success then
		for _, wp in ipairs(path:GetWaypoints()) do
			if not isFarming or not ore.Parent then return false end
			hum:MoveTo(wp.Position)
			hum.MoveToFinished:Wait(1)
			if wp.Action == Enum.PathWaypointAction.Jump then
				hum.Jump = true
				task.wait(0.2)
			end
		end
	end
	hum:MoveTo(op)
	local timeout = tick() + 8
	while (hrp.Position - op).Magnitude > 3.5 and tick() < timeout do
		if afAutoRespawn() then return false end
		if not ore.Parent or not afOreReachable(ore) then return false end
		local cp = hrp.Position
		if (cp - farmLastPos).Magnitude < 0.5 then
			farmStuckTimer = farmStuckTimer + 0.1
			if farmStuckTimer > 1.5 then
				hum.Jump = true
				afSetSpeed(28, farmJumpPower)
				task.wait(0.3)
				afSetSpeed(farmWalkSpeed, farmJumpPower)
				farmStuckTimer = 0
				hum:MoveTo(Vector3.new(cp.X + math.random(-3, 3), op.Y + 2, cp.Z + math.random(-3, 3)))
				task.wait(0.5)
			end
		else
			farmStuckTimer = math.max(0, farmStuckTimer - 0.1)
		end
		farmLastPos = cp
		hum:MoveTo(op)
		task.wait(0.1)
	end
	return (hrp.Position - op).Magnitude <= 4
end

local function startFarming()
	while isFarming do
		if afAutoRespawn() then task.wait(2) end
		local target = afGetNearest()
		if not target then
			afSetSpeed(origWalkSpeed, origJumpPower)
			task.wait(0.5)
		else
			afSetSpeed(farmWalkSpeed, farmJumpPower)
			local reached = afMoveTo(target)
			if reached and target.Parent and afOreReachable(target) then
				local ct = tick() + 2.5
				local ma = 0
				while tick() < ct and isFarming and target.Parent and afOreReachable(target) do
					afCircle(target, 2.8)
					afMine(target)
					ma = ma + 1
					if ma >= 5 then afMine(target) end
					task.wait(0.12)
				end
				afMine(target)
			end
			task.wait(0.15)
		end
	end
	afSetSpeed(origWalkSpeed, origJumpPower)
end

local triggerCooldown = 0
local function fireTrigger()
	local now = tick()
	if now - triggerCooldown < 0.08 then return end
	triggerCooldown = now
	pcall(function()
		local char = LocalPlayer.Character
		if not char then return end
		local tool = char:FindFirstChildWhichIsA("Tool")
		if not tool then return end
		local fire = tool:FindFirstChild("Fire") or tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("ShootEvent")
		if fire then
			fire:FireServer()
		else
			local ue = tool:FindFirstChildWhichIsA("RemoteEvent")
			if ue then ue:FireServer() end
		end
		local conn = tool:FindFirstChild("Activated")
		if conn then conn:Fire() end
		tool:Activate()
	end)
end

local curTarget, lastTargetTime = nil, 0
local oreTarget2D = nil

RunService.RenderStepped:Connect(function()
	local ss = Camera.ViewportSize
	local center = Vector2.new(ss.X / 2, ss.Y / 2)
	local t = tick()
	circle.Visible = S.FOVCircle
	circle.Position = center
	circle.Radius = S.FOV
	circle.Color = AC
	cText.Position = center - Vector2.new(0, S.FOV + 30)

	local closestDist = math.huge
	local tPos2D, tPos3D, tPlayer, tDist
	local count = 0

	for player, box in pairs(ESPBoxes) do
		local char = player.Character
		local head = char and char:FindFirstChild("Head")
		local hrp = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChild("Humanoid")
		if head and hrp and hum and hum.Health > 0 then
			local pos3, onScreen = Camera:WorldToViewportPoint(head.Position)
			if onScreen then
				local sp = Vector2.new(pos3.X, pos3.Y)
				local d2 = (sp - center).Magnitude
				if S.AimbotEnabled and d2 <= S.FOV and isVisible(head, char) then
					count = count + 1
					if d2 < closestDist then
						closestDist = d2
						tDist = (Camera.CFrame.Position - hrp.Position).Magnitude
						local vel = head.Velocity or Vector3.new()
						local d3 = (head.Position - Camera.CFrame.Position).Magnitude
						local pf = S.Prediction * (1 + d3 / 500)
						local pp = head.Position + vel * (d3 / 800) * pf
						tPos3D = pp
						tPlayer = player
						local a2d = Camera:WorldToViewportPoint(pp)
						tPos2D = Vector2.new(a2d.X, a2d.Y)
					end
					if S.TriggerBot and d2 <= S.FOV * 0.3 then
						fireTrigger()
					end
				end
				if S.ESPEnabled then
					local top = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
					local bot = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
					local sy = math.abs(top.Y - bot.Y)
					box.Size = Vector2.new(sy / 2, sy)
					box.Position = Vector2.new(sp.X - box.Size.X / 2, sp.Y - box.Size.Y / 2)
					box.Color = AC
					box.Visible = true
				else
					box.Visible = false
				end
				if S.Tracers then
					TracerObjs[player][1].From = Vector2.new(ss.X / 2, 0)
					TracerObjs[player][1].To = sp
					TracerObjs[player][1].Color = AC
					TracerObjs[player][1].Visible = true
					TracerObjs[player][2].From = center
					TracerObjs[player][2].To = sp
					TracerObjs[player][2].Color = AC
					TracerObjs[player][2].Visible = true
				else
					TracerObjs[player][1].Visible = false
					TracerObjs[player][2].Visible = false
				end
				if S.Names then
					local top2 = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
					local bot2 = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
					local sy2 = math.abs(top2.Y - bot2.Y)
					local d3 = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
					NameObjs[player].Text = player.Name .. " [" .. d3 .. "m]"
					NameObjs[player].Position = Vector2.new(sp.X, sp.Y - sy2 / 2 - 12)
					NameObjs[player].Color = AC
					NameObjs[player].Visible = true
				else
					NameObjs[player].Visible = false
				end
				if S.Skeleton then
					local h2d = w2sv(head)
					local t2d = w2sv(hrp)
					SkelObjs[player].headTorso.From = h2d
					SkelObjs[player].headTorso.To = t2d
					SkelObjs[player].headTorso.Color = AC
					SkelObjs[player].headTorso.Visible = true
					local function drawLimb(key, n1, n2)
						local p = char:FindFirstChild(n1) or char:FindFirstChild(n2 or n1)
						if p then
							SkelObjs[player][key].From = t2d
							SkelObjs[player][key].To = w2sv(p)
							SkelObjs[player][key].Color = AC
							SkelObjs[player][key].Visible = true
						else
							SkelObjs[player][key].Visible = false
						end
					end
					drawLimb("leftArm", "Left Arm", "LeftUpperArm")
					drawLimb("rightArm", "Right Arm", "RightUpperArm")
					drawLimb("leftLeg", "Left Leg", "LeftLowerLeg")
					drawLimb("rightLeg", "Right Leg", "RightLowerLeg")
				else
					for _, l in pairs(SkelObjs[player]) do l.Visible = false end
				end
			else
				box.Visible = false
				TracerObjs[player][1].Visible = false
				TracerObjs[player][2].Visible = false
				NameObjs[player].Visible = false
				for _, l in pairs(SkelObjs[player]) do l.Visible = false end
			end
		else
			box.Visible = false
			TracerObjs[player][1].Visible = false
			TracerObjs[player][2].Visible = false
			NameObjs[player].Visible = false
			for _, l in pairs(SkelObjs[player]) do l.Visible = false end
		end
	end

	cText.Text = tostring(count)
	cText.Color = AC

	oreTarget2D = nil
	if S.OreAimbot then
		local nearest, shortestOre = nil, math.huge
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and obj.Name == "IronPart" and obj.Parent then
				local p3, onS = Camera:WorldToViewportPoint(obj.Position)
				if onS then
					local sp2 = Vector2.new(p3.X, p3.Y)
					local d2 = (sp2 - center).Magnitude
					if d2 < shortestOre and d2 <= S.FOV then
						shortestOre = d2
						nearest = obj
						oreTarget2D = sp2
					end
				end
			end
		end
		if nearest then
			local camPos = Camera.CFrame.Position
			local newLook = (nearest.Position - camPos).Unit
			local lerped = Camera.CFrame.LookVector:Lerp(newLook, 0.15)
			Camera.CFrame = CFrame.new(camPos, camPos + lerped)
		end
		if oreTarget2D then
			tLines3[1].From = Vector2.new(center.X, center.Y - 10)
			tLines3[1].To = Vector2.new(center.X, center.Y + 10)
			tLines3[1].Color = GR
			tLines3[1].Visible = true
			tLines3[2].From = Vector2.new(center.X - 10, center.Y)
			tLines3[2].To = Vector2.new(center.X + 10, center.Y)
			tLines3[2].Color = GR
			tLines3[2].Visible = true
		else
			for _, l in ipairs(tLines3) do l.Visible = false end
		end
	else
		for _, l in ipairs(tLines3) do l.Visible = false end
	end

	if not tPos2D and curTarget and (tick() - lastTargetTime) < S.TargetLostDelay then
		local char = curTarget.Character
		if char and char:FindFirstChild("Head") then
			local h = char.Head
			local vel = h.Velocity or Vector3.new()
			local d3 = (h.Position - Camera.CFrame.Position).Magnitude
			local pp = h.Position + vel * (d3 / 800) * S.Prediction
			tPos3D = pp
			local a = Camera:WorldToViewportPoint(pp)
			tPos2D = Vector2.new(a.X, a.Y)
			tDist = (Camera.CFrame.Position - h.Position).Magnitude
		end
	elseif tPlayer then
		curTarget = tPlayer
		lastTargetTime = tick()
	end

	if S.AimbotEnabled and tPos2D and tDist then
		local anim = S.TargetAnim

		if anim == 1 then
			local sz = math.clamp(8 * math.clamp(tDist / 100, 1, 5.5), 10, 45)
			local rot = t * 4
			local pts = {}
			for i = 1, 4 do
				local angle = math.rad((i - 1) * 90 + rot * 60)
				table.insert(pts, Vector2.new(tPos2D.X + math.cos(angle) * sz, tPos2D.Y + math.sin(angle) * sz))
			end
			for i = 1, 4 do
				tLines[i].From = pts[i]
				tLines[i].To = pts[i % 4 + 1]
				tLines[i].Color = AC
				tLines[i].Visible = true
			end
			for _, l in ipairs(tLines2) do l.Visible = false end

		elseif anim == 2 then
			local sz = 20
			local rot = t * 6
			for i = 1, 8 do
				local a1 = math.rad((i - 1) * 45 + rot * 40)
				local a2 = math.rad(i * 45 + rot * 40)
				tLines2[i].From = Vector2.new(tPos2D.X + math.cos(a1) * sz, tPos2D.Y + math.sin(a1) * sz)
				tLines2[i].To = Vector2.new(tPos2D.X + math.cos(a2) * sz, tPos2D.Y + math.sin(a2) * sz)
				tLines2[i].Color = AC2
				tLines2[i].Visible = true
			end
			for _, l in ipairs(tLines) do l.Visible = false end

		elseif anim == 3 then
			local sz = math.clamp(15 + math.sin(t * 5) * 8, 10, 30)
			local pts = {}
			for i = 1, 4 do
				local angle = math.rad((i - 1) * 90)
				table.insert(pts, Vector2.new(tPos2D.X + math.cos(angle) * sz, tPos2D.Y + math.sin(angle) * sz))
			end
			for i = 1, 4 do
				tLines[i].From = pts[i]
				tLines[i].To = pts[i % 4 + 1]
				tLines[i].Color = AC
				tLines[i].Visible = true
			end
			for _, l in ipairs(tLines2) do l.Visible = false end

		elseif anim == 4 then
			local pulse = math.abs(math.sin(t * 3)) * 20 + 10
			for i = 1, 4 do
				local a1 = math.rad((i - 1) * 90)
				local a2 = math.rad(i * 90)
				tLines[i].From = Vector2.new(tPos2D.X + math.cos(a1) * pulse, tPos2D.Y + math.sin(a1) * pulse)
				tLines[i].To = Vector2.new(tPos2D.X + math.cos(a2) * pulse, tPos2D.Y + math.sin(a2) * pulse)
				tLines[i].Color = AC2
				tLines[i].Visible = true
			end
			for _, l in ipairs(tLines2) do l.Visible = false end

		elseif anim == 5 then
			local cx, cy = tPos2D.X, tPos2D.Y
			local s = math.clamp(tDist / 8, 8, 30)
			tLines[1].From = Vector2.new(cx - s, cy - s); tLines[1].To = Vector2.new(cx + s, cy - s); tLines[1].Color = AC; tLines[1].Visible = true
			tLines[2].From = Vector2.new(cx + s, cy - s); tLines[2].To = Vector2.new(cx + s, cy + s); tLines[2].Color = AC; tLines[2].Visible = true
			tLines[3].From = Vector2.new(cx + s, cy + s); tLines[3].To = Vector2.new(cx - s, cy + s); tLines[3].Color = AC; tLines[3].Visible = true
			tLines[4].From = Vector2.new(cx - s, cy + s); tLines[4].To = Vector2.new(cx - s, cy - s); tLines[4].Color = AC; tLines[4].Visible = true
			for _, l in ipairs(tLines2) do l.Visible = false end
		end

		gLine.From = center
		gLine.To = tPos2D
		gLine.Color = AC
		gLine.Visible = true
		local camPos = Camera.CFrame.Position
		local newLook = (tPos3D - camPos).Unit
		local lerped = Camera.CFrame.LookVector:Lerp(newLook, S.Smooth)
		if S.RCS then
			local rc = Vector3.new(math.sin(t * 30) * S.RecoilComp, math.cos(t * 30) * S.RecoilComp / 2, 0)
			lerped = (lerped + rc).Unit
		end
		Camera.CFrame = CFrame.new(camPos, camPos + lerped)
	else
		for _, l in ipairs(tLines) do l.Visible = false end
		for _, l in ipairs(tLines2) do l.Visible = false end
		gLine.Visible = false
	end
end)

local gui = Instance.new("ScreenGui")
gui.Name = "lw"
gui.ResetOnSpawn = false
gui.DisplayOrder = 99999
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global

local ok, pg = pcall(function() return LocalPlayer:WaitForChild("PlayerGui", 3) end)
gui.Parent = ok and pg or game:GetService("CoreGui")

local function el(cls, parent, props)
	local o = Instance.new(cls)
	if parent then o.Parent = parent end
	if props then
		for k, v in pairs(props) do
			pcall(function() o[k] = v end)
		end
	end
	return o
end

local openBtn = el("TextButton", gui, {
	Size = UDim2.new(0, 54, 0, 54),
	Position = UDim2.new(1, -66, 1, -130),
	BackgroundColor3 = SB,
	TextColor3 = AC,
	Text = "LW",
	TextSize = 15,
	Font = Enum.Font.GothamBold,
	ZIndex = 100,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Active = true,
})
el("UICorner", openBtn, {CornerRadius = UDim.new(0, 12)})
el("UIStroke", openBtn, {Color = AC, Thickness = 2})

local win = el("Frame", gui, {
	Size = UDim2.new(0, 480, 0, 300),
	Position = UDim2.new(0.5, -240, 0.5, -150),
	BackgroundColor3 = BG,
	BorderSizePixel = 0,
	Visible = false,
	ZIndex = 10,
})
el("UICorner", win, {CornerRadius = UDim.new(0, 5)})
el("UIStroke", win, {Color = BR, Thickness = 1})

local titleBar = el("Frame", win, {
	Size = UDim2.new(1, 0, 0, 24),
	BackgroundColor3 = HD,
	BorderSizePixel = 0,
	ZIndex = 11,
})
el("UICorner", titleBar, {CornerRadius = UDim.new(0, 5)})
el("Frame", titleBar, {
	Size = UDim2.new(1, 0, 0, 10),
	Position = UDim2.new(0, 0, 1, -10),
	BackgroundColor3 = HD,
	BorderSizePixel = 0,
	ZIndex = 11,
})
el("TextLabel", titleBar, {
	Text = "losware",
	TextColor3 = AC,
	BackgroundTransparency = 1,
	Size = UDim2.new(1, -30, 1, 0),
	Position = UDim2.new(0, 10, 0, 0),
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 12,
})

local closeBtn = el("TextButton", titleBar, {
	Text = "x",
	TextColor3 = DM,
	BackgroundTransparency = 1,
	Size = UDim2.new(0, 24, 1, 0),
	Position = UDim2.new(1, -24, 0, 0),
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	ZIndex = 12,
	AutoButtonColor = false,
	Active = true,
})

local sidebar = el("Frame", win, {
	Size = UDim2.new(0, 100, 0, 276),
	Position = UDim2.new(0, 0, 0, 24),
	BackgroundColor3 = SB,
	BorderSizePixel = 0,
	ZIndex = 11,
})
el("UIStroke", sidebar, {Color = BR, Thickness = 1})

local content = el("Frame", win, {
	Size = UDim2.new(1, -100, 0, 276),
	Position = UDim2.new(0, 100, 0, 24),
	BackgroundColor3 = BG,
	BorderSizePixel = 0,
	ZIndex = 11,
})

local TABS = {"aimbot", "visuals", "misc", "autofarm", "friends"}
local tabBtns = {}
local tabFrames = {}
local activeTab = nil

local function makeSF(parent)
	local sf = el("ScrollingFrame", parent, {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = AC,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ZIndex = 12,
		ScrollingEnabled = true,
	})
	el("UIPadding", sf, {
		PaddingLeft = UDim.new(0, 8),
		PaddingRight = UDim.new(0, 8),
		PaddingTop = UDim.new(0, 6),
		PaddingBottom = UDim.new(0, 6),
	})
	el("UIListLayout", sf, {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 3),
	})
	return sf
end

local function switchTab(id)
	activeTab = id
	for tid, frame in pairs(tabFrames) do
		frame.Visible = (tid == id)
	end
	for tid, btn in pairs(tabBtns) do
		btn.TextColor3 = (tid == id) and WH or DM
		btn.BackgroundColor3 = (tid == id) and Color3.fromRGB(28, 24, 45) or SB
	end
end

for i, name in ipairs(TABS) do
	local btn = el("TextButton", sidebar, {
		Text = name,
		TextColor3 = DM,
		BackgroundColor3 = SB,
		Size = UDim2.new(1, 0, 0, 24),
		Position = UDim2.new(0, 0, 0, (i - 1) * 28 + 4),
		Font = Enum.Font.Gotham,
		TextSize = 10,
		BorderSizePixel = 0,
		ZIndex = 12,
		AutoButtonColor = false,
		Active = true,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	el("UIPadding", btn, {PaddingLeft = UDim.new(0, 10)})
	tabBtns[name] = btn

	local sf = makeSF(content)
	sf.Visible = false
	tabFrames[name] = sf

	btn.Activated:Connect(function()
		switchTab(name)
	end)
end

local accentLine = el("Frame", sidebar, {
	Size = UDim2.new(0, 2, 0, 18),
	Position = UDim2.new(0, 0, 0, 9),
	BackgroundColor3 = AC,
	BorderSizePixel = 0,
	ZIndex = 13,
})

local _origSwitch = switchTab
switchTab = function(id)
	_origSwitch(id)
	for i, name in ipairs(TABS) do
		if name == id then
			accentLine.Position = UDim2.new(0, 0, 0, (i - 1) * 28 + 7)
			break
		end
	end
end

local function addSec(parent, label, order)
	local row = el("Frame", parent, {
		Size = UDim2.new(1, 0, 0, 18),
		BackgroundTransparency = 1,
		LayoutOrder = order or 0,
	})
	el("TextLabel", row, {
		Text = label,
		TextColor3 = AC,
		BackgroundTransparency = 1,
		Size = UDim2.new(0.5, 0, 1, 0),
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 13,
	})
	el("Frame", row, {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, -1),
		BackgroundColor3 = BR,
		BorderSizePixel = 0,
		ZIndex = 13,
	})
end

local function addToggle(parent, label, key, order, cb)
	local row = el("Frame", parent, {
		Size = UDim2.new(1, 0, 0, 22),
		BackgroundTransparency = 1,
		LayoutOrder = order or 0,
	})
	local box = el("Frame", row, {
		Size = UDim2.new(0, 13, 0, 13),
		Position = UDim2.new(0, 0, 0.5, -6),
		BackgroundColor3 = S[key] and AC or OF,
		BorderSizePixel = 0,
		ZIndex = 13,
	})
	el("UICorner", box, {CornerRadius = UDim.new(0, 3)})
	el("UIStroke", box, {Color = AC, Thickness = 1})
	local tick = el("TextLabel", box, {
		Text = S[key] and "v" or "",
		TextColor3 = WH,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Font = Enum.Font.GothamBold,
		TextSize = 9,
		ZIndex = 14,
	})
	el("TextLabel", row, {
		Text = label,
		TextColor3 = TX,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -20, 1, 0),
		Position = UDim2.new(0, 20, 0, 0),
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 13,
	})
	local btn = el("TextButton", row, {
		Text = "",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 15,
		AutoButtonColor = false,
		Active = true,
	})
	btn.Activated:Connect(function()
		S[key] = not S[key]
		box.BackgroundColor3 = S[key] and AC or OF
		tick.Text = S[key] and "v" or ""
		if cb then cb(S[key]) end
	end)
end

local function addSlider(parent, label, key, mn, mx, fmt, order, cb)
	local row = el("Frame", parent, {
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundTransparency = 1,
		LayoutOrder = order or 0,
	})
	local function fv(v)
		return fmt and string.format(fmt, v) or tostring(math.round(v))
	end
	local lbl = el("TextLabel", row, {
		Text = label .. "  " .. fv(S[key]),
		TextColor3 = TX,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 15),
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 13,
	})
	local track = el("Frame", row, {
		Size = UDim2.new(1, 0, 0, 4),
		Position = UDim2.new(0, 0, 0, 22),
		BackgroundColor3 = OF,
		BorderSizePixel = 0,
		ZIndex = 13,
	})
	el("UICorner", track, {CornerRadius = UDim.new(0.5, 0)})
	local r0 = math.clamp((S[key] - mn) / (mx - mn), 0, 1)
	local fill = el("Frame", track, {
		Size = UDim2.new(r0, 0, 1, 0),
		BackgroundColor3 = AC,
		BorderSizePixel = 0,
		ZIndex = 14,
	})
	el("UICorner", fill, {CornerRadius = UDim.new(0.5, 0)})
	local knob = el("Frame", track, {
		Size = UDim2.new(0, 10, 0, 10),
		Position = UDim2.new(r0, -5, 0.5, -5),
		BackgroundColor3 = WH,
		BorderSizePixel = 0,
		ZIndex = 15,
	})
	el("UICorner", knob, {CornerRadius = UDim.new(0.5, 0)})
	local dragging = false
	local hit = el("TextButton", track, {
		Text = "",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 20),
		Position = UDim2.new(0, 0, 0.5, -10),
		ZIndex = 16,
		AutoButtonColor = false,
		Active = true,
	})
	hit.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging then
			local tp = track.AbsolutePosition
			local tw = track.AbsoluteSize.X
			local r = math.clamp((i.Position.X - tp.X) / tw, 0, 1)
			local v = mn + (mx - mn) * r
			S[key] = v
			fill.Size = UDim2.new(r, 0, 1, 0)
			knob.Position = UDim2.new(r, -5, 0.5, -5)
			lbl.Text = label .. "  " .. fv(v)
			if cb then cb(v) end
		end
	end)
end

local function addAnimPicker(parent, order)
	local anims = {
		{id=1, name="Rotating Square"},
		{id=2, name="Spinning Octagon"},
		{id=3, name="Pulsing Circle"},
		{id=4, name="Pulse Burst"},
		{id=5, name="Static Box"},
	}
	addSec(parent, "target animation", order)
	local indicators = {}
	for i, anim in ipairs(anims) do
		local row = el("Frame", parent, {
			Size = UDim2.new(1, 0, 0, 22),
			BackgroundTransparency = 1,
			LayoutOrder = order + i,
		})
		local dot = el("Frame", row, {
			Size = UDim2.new(0, 8, 0, 8),
			Position = UDim2.new(0, 2, 0.5, -4),
			BackgroundColor3 = S.TargetAnim == anim.id and AC or OF,
			BorderSizePixel = 0,
			ZIndex = 13,
		})
		el("UICorner", dot, {CornerRadius = UDim.new(0.5, 0)})
		el("TextLabel", row, {
			Text = anim.name,
			TextColor3 = TX,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, -16, 1, 0),
			Position = UDim2.new(0, 16, 0, 0),
			Font = Enum.Font.Gotham,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 13,
		})
		local btn = el("TextButton", row, {
			Text = "",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = 15,
			AutoButtonColor = false,
			Active = true,
		})
		indicators[anim.id] = dot
		local aid = anim.id
		btn.Activated:Connect(function()
			S.TargetAnim = aid
			for _, d in pairs(indicators) do
				d.BackgroundColor3 = OF
			end
			dot.BackgroundColor3 = AC
		end)
	end
end

do
	local t = tabFrames["aimbot"]
	addSec(t, "main", 1)
	addToggle(t, "Aimbot", "AimbotEnabled", 2)
	addToggle(t, "PSilent", "PSilent", 3)
	addToggle(t, "Ignore Slipping", "IgnoreSlipping", 4)
	addToggle(t, "Visible Check", "VisibleCheck", 5)
	addToggle(t, "Anti Recoil", "RCS", 6)
	addToggle(t, "Trigger Bot", "TriggerBot", 7)
	addSec(t, "settings", 8)
	addSlider(t, "FOV", "FOV", 30, 300, "%.0f", 9, function(v) circle.Radius = v end)
	addSlider(t, "Smooth", "Smooth", 0.05, 1, "%.2f", 10)
	addSlider(t, "Prediction", "Prediction", 0, 0.5, "%.3f", 11)
	addSlider(t, "Hitbox", "HitboxScale", 1, 6, "%.1f", 12)
end

do
	local t = tabFrames["visuals"]
	addSec(t, "esp", 1)
	addToggle(t, "ESP Boxes", "ESPEnabled", 2)
	addToggle(t, "Skeleton", "Skeleton", 3)
	addToggle(t, "Tracers", "Tracers", 4)
	addToggle(t, "Names", "Names", 5)
	addToggle(t, "FOV Circle", "FOVCircle", 6)
	addSec(t, "world", 7)
	addToggle(t, "Night Vision", "NightVision", 8, function(v) nv.Enabled = v end)
	addAnimPicker(t, 9)
end

do
	local t = tabFrames["misc"]
	addSec(t, "misc", 1)
	addToggle(t, "Ignore Slipping", "IgnoreSlipping", 2)
	addToggle(t, "PSilent", "PSilent", 3)
end

do
	local t = tabFrames["autofarm"]
	addSec(t, "farm", 1)
	addToggle(t, "Auto Farm", "AutoFarm", 2, function(v)
		isFarming = v
		if v then
			task.spawn(startFarming)
		else
			afSetSpeed(origWalkSpeed, origJumpPower)
		end
	end)
	addSec(t, "ore tools", 3)
	addToggle(t, "Ore Aimbot", "OreAimbot", 4)
end

do
	local t = tabFrames["friends"]
	addSec(t, "players on server", 1)

	local playerList = {}
	local listOrder = 2

	local function refreshFriendsList()
		for _, child in ipairs(t:GetChildren()) do
			if child:IsA("Frame") and child.LayoutOrder >= 2 then
				child:Destroy()
			end
		end
		listOrder = 2
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer then
				local row = el("Frame", t, {
					Size = UDim2.new(1, 0, 0, 28),
					BackgroundTransparency = 1,
					LayoutOrder = listOrder,
				})
				listOrder = listOrder + 1

				el("TextLabel", row, {
					Text = p.Name,
					TextColor3 = TX,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -80, 1, 0),
					Position = UDim2.new(0, 0, 0, 0),
					Font = Enum.Font.Gotham,
					TextSize = 11,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 13,
				})

				local addBtn = el("TextButton", row, {
					Text = "+ Add",
					TextColor3 = WH,
					BackgroundColor3 = AC,
					Size = UDim2.new(0, 70, 0, 20),
					Position = UDim2.new(1, -72, 0.5, -10),
					Font = Enum.Font.GothamBold,
					TextSize = 10,
					BorderSizePixel = 0,
					ZIndex = 14,
					AutoButtonColor = false,
					Active = true,
				})
				el("UICorner", addBtn, {CornerRadius = UDim.new(0, 4)})

				local pid = p.UserId
				local pname = p.Name
				addBtn.Activated:Connect(function()
					pcall(function()
						StarterGui:SetCore("SendNotification", {
							Title = "losware",
							Text = "Sending request to " .. pname,
							Duration = 3,
						})
						Players:GetFriendRequestUrl(pid)
						game:GetService("HttpService"):PostAsync(
							"https://friends.roblox.com/v1/users/" .. pid .. "/request-friendship",
							"",
							Enum.HttpContentType.ApplicationJson
						)
					end)
					pcall(function()
						game:GetService("HttpService"):PostAsync(
							"https://friends.roblox.com/v1/users/" .. tostring(pid) .. "/request-friendship",
							"{}", Enum.HttpContentType.ApplicationJson
						)
					end)
					addBtn.Text = "Sent!"
					addBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
					task.wait(2)
					addBtn.Text = "+ Add"
					addBtn.BackgroundColor3 = AC
				end)
			end
		end

		local refreshRow = el("Frame", t, {
			Size = UDim2.new(1, 0, 0, 28),
			BackgroundTransparency = 1,
			LayoutOrder = listOrder,
		})
		local refreshBtn = el("TextButton", refreshRow, {
			Text = "Refresh List",
			TextColor3 = WH,
			BackgroundColor3 = Color3.fromRGB(35, 30, 55),
			Size = UDim2.new(1, 0, 1, 0),
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			BorderSizePixel = 0,
			ZIndex = 14,
			AutoButtonColor = false,
			Active = true,
		})
		el("UICorner", refreshBtn, {CornerRadius = UDim.new(0, 4)})
		el("UIStroke", refreshBtn, {Color = BR, Thickness = 1})
		refreshBtn.Activated:Connect(refreshFriendsList)
	end

	refreshFriendsList()

	Players.PlayerAdded:Connect(function()
		if activeTab == "friends" then
			refreshFriendsList()
		end
	end)
	Players.PlayerRemoving:Connect(function()
		task.wait(0.1)
		if activeTab == "friends" then
			refreshFriendsList()
		end
	end)
end

local dragOn, dragStart, dragPos = false, nil, nil
titleBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragOn = true
		dragStart = i.Position
		dragPos = win.Position
	end
end)
UserInputService.InputChanged:Connect(function(i)
	if dragOn and dragStart and dragPos then
		local d = i.Position - dragStart
		win.Position = UDim2.new(dragPos.X.Scale, dragPos.X.Offset + d.X, dragPos.Y.Scale, dragPos.Y.Offset + d.Y)
	end
end)
UserInputService.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		dragOn = false
	end
end)

local guiOpen = false
local lastTap = 0

local function toggle()
	local now = tick()
	if now - lastTap < 0.4 then return end
	lastTap = now
	guiOpen = not guiOpen
	win.Visible = guiOpen
	openBtn.Text = guiOpen and "X" or "LW"
	if guiOpen and not activeTab then
		switchTab("aimbot")
	end
end

openBtn.Activated:Connect(toggle)
closeBtn.Activated:Connect(toggle)

UserInputService.InputBegan:Connect(function(inp, gpe)
	if gpe then return end
	if inp.KeyCode == Enum.KeyCode.RightShift or inp.KeyCode == Enum.KeyCode.Insert then
		toggle()
	end
end)

switchTab("aimbot")
print("losware v3 loaded")
