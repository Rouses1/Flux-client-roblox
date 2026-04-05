local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")

-- ==================== SETTINGS ====================
local S = {
    AimbotEnabled   = true,
    PSilent         = false,
    IgnoreSlipping  = true,
    VisibleCheck    = true,
    RCS             = true,
    FOV             = 80,
    Smooth          = 0.25,
    Prediction      = 0.165,
    HitboxScale     = 3.3,
    TargetLostDelay = 0.12,
    RecoilComp      = 0.002,

    ESPEnabled      = true,
    Skeleton        = true,
    Tracers         = true,
    Names           = true,
    FOVCircle       = true,
    NightVision     = true,
    TargetAnim      = 1,

    AutoFarm        = false,
}

-- ==================== COLORS ====================
local ACCENT   = Color3.fromRGB(110, 100, 200)
local ACCENT2  = Color3.fromRGB(140, 130, 230)
local BG       = Color3.fromRGB(22, 22, 28)
local PANEL    = Color3.fromRGB(28, 28, 36)
local SIDE     = Color3.fromRGB(18, 18, 24)
local BORDER   = Color3.fromRGB(60, 55, 100)
local TEXT     = Color3.fromRGB(200, 200, 215)
local TEXTDIM  = Color3.fromRGB(120, 115, 150)
local TOGON    = Color3.fromRGB(110, 100, 200)
local TOGOFF   = Color3.fromRGB(50, 48, 70)

-- ==================== NIGHT VISION ====================
local nightVision = Instance.new("ColorCorrectionEffect")
nightVision.Name = "NV_losware"
nightVision.Parent = Lighting
nightVision.Brightness  = 0.08
nightVision.Contrast    = 0.2
nightVision.Saturation  = -0.35
nightVision.TintColor   = Color3.fromRGB(170, 200, 230)
nightVision.Enabled     = S.NightVision
Lighting.Brightness     = 2
Lighting.Ambient        = Color3.fromRGB(110,120,130)
Lighting.OutdoorAmbient = Color3.fromRGB(120,130,140)
Lighting.FogEnd         = 100000

-- ==================== DRAWING ====================
local circle = Drawing.new("Circle")
circle.Radius      = S.FOV
circle.Thickness   = 1
circle.Color       = ACCENT
circle.Transparency= 1
circle.Filled      = false
circle.Visible     = S.FOVCircle

local targetLines = {}
for i = 1,4 do
    local l = Drawing.new("Line")
    l.Thickness = 2
    l.Color     = ACCENT
    l.Visible   = false
    table.insert(targetLines, l)
end

local targetLines2 = {}
for i = 1,8 do
    local l = Drawing.new("Line")
    l.Thickness = 1
    l.Color     = ACCENT2
    l.Visible   = false
    table.insert(targetLines2, l)
end

local guideLine = Drawing.new("Line")
guideLine.Thickness = 1
guideLine.Color     = ACCENT
guideLine.Visible   = false

local countText = Drawing.new("Text")
countText.Size    = 28
countText.Color   = ACCENT
countText.Center  = true
countText.Outline = true
countText.OutlineColor = Color3.fromRGB(0,0,0)
countText.Visible = true

-- ==================== ESP ====================
local ESPBoxes   = {}
local TracerObjs = {}
local SkelObjs   = {}
local NameObjs   = {}

local function newLine(col)
    local l = Drawing.new("Line")
    l.Color     = col or ACCENT
    l.Thickness = 1
    return l
end

local function createESP(player)
    local box = Drawing.new("Square")
    box.Color    = ACCENT
    box.Thickness= 1
    box.Filled   = false

    local t1 = Drawing.new("Line"); t1.Color = ACCENT; t1.Thickness = 1
    local t2 = Drawing.new("Line"); t2.Color = ACCENT; t2.Thickness = 1

    local skel = {
        headTorso = newLine(ACCENT),
        leftArm   = newLine(ACCENT),
        rightArm  = newLine(ACCENT),
        leftLeg   = newLine(ACCENT),
        rightLeg  = newLine(ACCENT),
    }

    local name = Drawing.new("Text")
    name.Size   = 12
    name.Center = true
    name.Outline= true
    name.Color  = ACCENT

    ESPBoxes[player]  = box
    TracerObjs[player]= {t1, t2}
    SkelObjs[player]  = skel
    NameObjs[player]  = name
end

for _,p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then createESP(p) end
end
Players.PlayerAdded:Connect(function(p)
    if p ~= LocalPlayer then createESP(p) end
end)
Players.PlayerRemoving:Connect(function(p)
    if ESPBoxes[p]   then ESPBoxes[p]:Remove() end
    if TracerObjs[p] then for _,l in ipairs(TracerObjs[p]) do l:Remove() end end
    if SkelObjs[p]   then for _,l in pairs(SkelObjs[p]) do l:Remove() end end
    if NameObjs[p]   then NameObjs[p]:Remove() end
end)

-- ==================== VISIBILITY ====================
local function isVisible(part, character)
    if not S.VisibleCheck then return true end
    local origin = Camera.CFrame.Position
    local params  = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    params.FilterType = Enum.RaycastFilterType.Blacklist
    local hb = part.Size.Magnitude * (S.HitboxScale - 1) / 2
    for _, off in ipairs({
        Vector3.new(0,0,0), Vector3.new(hb,hb,0),
        Vector3.new(-hb,hb,0), Vector3.new(hb,-hb,0), Vector3.new(-hb,-hb,0)
    }) do
        local dir = (part.Position + off) - origin
        local r   = workspace:Raycast(origin, dir, params)
        if not r or r.Instance:IsDescendantOf(character) then return true end
    end
    return false
end

local function w2sv(part)
    local p = Camera:WorldToViewportPoint(part.Position)
    return Vector2.new(p.X, p.Y)
end

-- ==================== HITBOX ====================
local function enlargeHitboxes()
    for _,player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            for _,part in ipairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    local orig = part.Size
                    part.Size  = orig * S.HitboxScale
                    task.wait(0.05)
                    part.Size  = orig
                end
            end
        end
    end
end

task.spawn(function()
    while true do task.wait(0.5); enlargeHitboxes() end
end)

Players.PlayerAdded:Connect(function(pl)
    pl.CharacterAdded:Connect(function(char)
        task.wait(0.2)
        for _,part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local orig = part.Size
                part.Size  = orig * S.HitboxScale
                task.wait(0.05)
                part.Size  = orig
            end
        end
    end)
end)

-- ==================== AUTOFARM ====================
local isFarming = false
local farmWalkSpeed  = 24
local farmJumpPower  = 70
local origWalkSpeed  = 16
local origJumpPower  = 50
local farmCircleAngle= 0
local farmStuckTimer = 0
local farmLastPos    = nil
local farmTarget     = nil

local function afAutoRespawn()
    local char = LocalPlayer.Character
    local hum  = char and char:FindFirstChild("Humanoid")
    if hum and hum.Health <= 0 then
        task.wait(2); LocalPlayer:LoadCharacter(); task.wait(3); return true
    end
    return false
end

local function afSetSpeed(sp, jp)
    local char = LocalPlayer.Character
    local hum  = char and char:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed = sp or origWalkSpeed; hum.JumpPower = jp or origJumpPower end
end

local function afOreReachable(orePart)
    if not orePart or not orePart.Parent then return false end
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    if orePart.Position.Y < -10 then return false end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Blacklist
    params.FilterDescendantsInstances = {char, orePart}
    local dir  = orePart.Position - hrp.Position
    local dist = dir.Magnitude
    if dist > 200 then return true end
    local r = workspace:Raycast(hrp.Position, dir.Unit * dist, params)
    if r then
        local h = r.Instance
        if h and h ~= orePart and not h:IsDescendantOf(char) then
            if h.CanCollide and h.Transparency < 0.5 then return false end
        end
    end
    return true
end

local function afGetNearest()
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearest, shortest = nil, math.huge
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "IronPart" and obj.Parent then
            local d = (hrp.Position - obj.Position).Magnitude
            if d < shortest and d <= 1000000 and afOreReachable(obj) then
                shortest = d; nearest = obj
            end
        end
    end
    return nearest
end

local function afMine(orePart)
    pcall(function()
        local cd = orePart:FindFirstChildWhichIsA("ClickDetector")
        if cd then cd:Click() end
        local pp = orePart:FindFirstChildWhichIsA("ProximityPrompt")
        if pp then pp:Prompt() end
        local char = LocalPlayer.Character
        if char then
            local tool = char:FindFirstChildWhichIsA("Tool")
            if tool then
                local act = tool:FindFirstChild("Activate")
                if act then act:FireServer(orePart) end
            end
        end
    end)
end

local function afCircle(orePart, radius)
    if not orePart or not orePart.Parent then return end
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    radius = radius or 3.5
    farmCircleAngle = farmCircleAngle + 0.4
    local op = orePart.Position
    hum:MoveTo(Vector3.new(op.X + math.cos(farmCircleAngle)*radius, op.Y+1.5, op.Z + math.sin(farmCircleAngle)*radius))
end

local function afMoveTo(orePart)
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChild("Humanoid")
    if not hrp or not hum then return false end
    local op   = orePart.Position
    farmStuckTimer = 0; farmLastPos = hrp.Position

    local path = PathfindingService:CreatePath()
    local ok   = pcall(function() path:ComputeAsync(hrp.Position, op) end)
    if ok and path.Status == Enum.PathStatus.Success then
        for i, wp in ipairs(path:GetWaypoints()) do
            if not isFarming or not orePart.Parent then return false end
            hum:MoveTo(wp.Position)
            hum.MoveToFinished:Wait(1)
            if wp.Action == Enum.PathWaypointAction.Jump then
                hum.Jump = true; task.wait(0.2)
            end
        end
    end

    hum:MoveTo(op)
    local timeout = tick() + 8
    while (hrp.Position - op).Magnitude > 3.5 and tick() < timeout do
        if afAutoRespawn() then return false end
        if not orePart.Parent or not afOreReachable(orePart) then return false end
        local cp = hrp.Position
        if (cp - farmLastPos).Magnitude < 0.5 then
            farmStuckTimer += 0.1
            if farmStuckTimer > 1.5 then
                hum.Jump = true; afSetSpeed(28, farmJumpPower); task.wait(0.3); afSetSpeed(farmWalkSpeed, farmJumpPower)
                farmStuckTimer = 0
                hum:MoveTo(Vector3.new(cp.X + math.random(-3,3), op.Y+2, cp.Z + math.random(-3,3)))
                task.wait(0.5)
            end
        else farmStuckTimer = math.max(0, farmStuckTimer - 0.1) end
        farmLastPos = cp
        hum:MoveTo(op); task.wait(0.1)
    end
    return (hrp.Position - op).Magnitude <= 4
end

local function startFarming()
    while isFarming do
        if afAutoRespawn() then task.wait(2) end
        local target = afGetNearest()
        if not target then
            afSetSpeed(origWalkSpeed, origJumpPower); task.wait(0.5)
        else
            afSetSpeed(farmWalkSpeed, farmJumpPower)
            local reached = afMoveTo(target)
            if reached and target.Parent and afOreReachable(target) then
                local ct = tick() + 2.5
                local ma = 0
                while tick() < ct and isFarming and target.Parent and afOreReachable(target) do
                    afCircle(target, 2.8); afMine(target); ma += 1
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

-- ==================== MAIN LOOP ====================
local currentTarget, lastTargetTime = nil, 0

RunService.RenderStepped:Connect(function()
    local screenSize = Camera.ViewportSize
    local center     = Vector2.new(screenSize.X/2, screenSize.Y/2)
    local t          = tick()

    circle.Visible  = S.FOVCircle
    circle.Position = center
    circle.Radius   = S.FOV
    circle.Color    = ACCENT

    countText.Position = center - Vector2.new(0, S.FOV + 30)

    local closestDist = math.huge
    local targetPos2D, targetPos3D, targetPlayer, targetDistance
    local count = 0

    for player, box in pairs(ESPBoxes) do
        local char = player.Character
        local head = char and char:FindFirstChild("Head")
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChild("Humanoid")

        if head and hrp and hum and hum.Health > 0 then
            local pos3, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local screenPos = Vector2.new(pos3.X, pos3.Y)
                local dist2D    = (screenPos - center).Magnitude

                if S.AimbotEnabled and dist2D <= S.FOV and isVisible(head, char) then
                    count += 1
                    if dist2D < closestDist then
                        closestDist    = dist2D
                        targetDistance = (Camera.CFrame.Position - hrp.Position).Magnitude
                        local vel    = head.Velocity or Vector3.new()
                        local dist3D = (head.Position - Camera.CFrame.Position).Magnitude
                        local pf     = S.Prediction * (1 + dist3D/500)
                        local accel  = head.AssemblyLinearVelocity - (head.AssemblyLinearVelocity - Vector3.new())
                        local pp     = head.Position + vel*(dist3D/800)*pf + accel*0.05
                        targetPos3D  = pp
                        targetPlayer = player
                        local a2d    = Camera:WorldToViewportPoint(pp)
                        targetPos2D  = Vector2.new(a2d.X, a2d.Y)
                    end
                end

                if S.ESPEnabled then
                    local top    = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0,3,0))
                    local bottom = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))
                    local sizeY  = math.abs(top.Y - bottom.Y)
                    box.Size     = Vector2.new(sizeY/2, sizeY)
                    box.Position = Vector2.new(screenPos.X - box.Size.X/2, screenPos.Y - box.Size.Y/2)
                    box.Color    = ACCENT
                    box.Visible  = true
                else box.Visible = false end

                if S.Tracers then
                    TracerObjs[player][1].From = Vector2.new(screenSize.X/2, 0)
                    TracerObjs[player][1].To   = screenPos
                    TracerObjs[player][1].Color = ACCENT
                    TracerObjs[player][1].Visible = true
                    TracerObjs[player][2].From = center
                    TracerObjs[player][2].To   = screenPos
                    TracerObjs[player][2].Color = ACCENT
                    TracerObjs[player][2].Visible = true
                else
                    TracerObjs[player][1].Visible = false
                    TracerObjs[player][2].Visible = false
                end

                if S.Names then
                    local top2   = Camera:WorldToViewportPoint(hrp.Position+Vector3.new(0,3,0))
                    local bot2   = Camera:WorldToViewportPoint(hrp.Position-Vector3.new(0,3,0))
                    local sy2    = math.abs(top2.Y - bot2.Y)
                    local d3     = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
                    NameObjs[player].Text     = player.Name.." ["..d3.."m]"
                    NameObjs[player].Position = Vector2.new(screenPos.X, screenPos.Y - sy2/2 - 12)
                    NameObjs[player].Color    = ACCENT
                    NameObjs[player].Visible  = true
                else NameObjs[player].Visible = false end

                if S.Skeleton then
                    local sc    = ACCENT
                    local h2d   = w2sv(head)
                    local t2d   = w2sv(hrp)
                    SkelObjs[player].headTorso.From = h2d
                    SkelObjs[player].headTorso.To   = t2d
                    SkelObjs[player].headTorso.Color = sc
                    SkelObjs[player].headTorso.Visible = true

                    local function drawLimb(key, n1, n2)
                        local p = char:FindFirstChild(n1) or char:FindFirstChild(n2 or n1)
                        if p then
                            SkelObjs[player][key].From    = t2d
                            SkelObjs[player][key].To      = w2sv(p)
                            SkelObjs[player][key].Color   = sc
                            SkelObjs[player][key].Visible = true
                        else SkelObjs[player][key].Visible = false end
                    end

                    drawLimb("leftArm",  "Left Arm",  "LeftUpperArm")
                    drawLimb("rightArm", "Right Arm", "RightUpperArm")
                    drawLimb("leftLeg",  "Left Leg",  "LeftLowerLeg")
                    drawLimb("rightLeg", "Right Leg", "RightLowerLeg")
                else
                    for _,l in pairs(SkelObjs[player]) do l.Visible = false end
                end
            else
                box.Visible = false
                TracerObjs[player][1].Visible = false
                TracerObjs[player][2].Visible = false
                NameObjs[player].Visible = false
                for _,l in pairs(SkelObjs[player]) do l.Visible = false end
            end
        else
            box.Visible = false
            TracerObjs[player][1].Visible = false
            TracerObjs[player][2].Visible = false
            NameObjs[player].Visible = false
            for _,l in pairs(SkelObjs[player]) do l.Visible = false end
        end
    end

    countText.Text  = tostring(count)
    countText.Color = ACCENT

    if not targetPos2D and currentTarget and (tick()-lastTargetTime) < S.TargetLostDelay then
        local char = currentTarget.Character
        if char and char:FindFirstChild("Head") then
            local h   = char.Head
            local vel = h.Velocity or Vector3.new()
            local d3  = (h.Position - Camera.CFrame.Position).Magnitude
            local pp  = h.Position + vel*(d3/800)*S.Prediction
            targetPos3D = pp
            local a   = Camera:WorldToViewportPoint(pp)
            targetPos2D = Vector2.new(a.X, a.Y)
            targetDistance = (Camera.CFrame.Position - h.Position).Magnitude
        end
    elseif targetPlayer then
        currentTarget  = targetPlayer
        lastTargetTime = tick()
    end

    if S.AimbotEnabled and targetPos2D and targetDistance then
        local anim = S.TargetAnim
        if anim == 1 then
            local baseSize = 8
            local sz  = math.clamp(baseSize * math.clamp(targetDistance/100,1,5.5), 10, 45)
            local rot = t * 4
            local pts = {}
            for i = 1,4 do
                local angle = math.rad((i-1)*90 + rot*60)
                table.insert(pts, Vector2.new(targetPos2D.X + math.cos(angle)*sz, targetPos2D.Y + math.sin(angle)*sz))
            end
            for i = 1,4 do
                targetLines[i].From = pts[i]; targetLines[i].To = pts[i%4+1]
                targetLines[i].Color = ACCENT; targetLines[i].Visible = true
            end
            for _,l in ipairs(targetLines2) do l.Visible = false end

        elseif anim == 2 then
            local sz  = 20
            local rot = t * 6
            for i = 1,8 do
                local a1 = math.rad((i-1)*45 + rot*40)
                local a2 = math.rad(i*45 + rot*40)
                targetLines2[i].From = Vector2.new(targetPos2D.X + math.cos(a1)*sz, targetPos2D.Y + math.sin(a1)*sz)
                targetLines2[i].To   = Vector2.new(targetPos2D.X + math.cos(a2)*sz, targetPos2D.Y + math.sin(a2)*sz)
                targetLines2[i].Color = ACCENT2; targetLines2[i].Visible = true
            end
            for _,l in ipairs(targetLines) do l.Visible = false end

        elseif anim == 3 then
            local sz  = math.clamp(15 + math.sin(t*5)*8, 10, 30)
            local pts = {}
            for i = 1,4 do
                local angle = math.rad((i-1)*90)
                table.insert(pts, Vector2.new(targetPos2D.X + math.cos(angle)*sz, targetPos2D.Y + math.sin(angle)*sz))
            end
            for i = 1,4 do
                targetLines[i].From = pts[i]; targetLines[i].To = pts[i%4+1]
                targetLines[i].Color = ACCENT; targetLines[i].Visible = true
            end
            for _,l in ipairs(targetLines2) do l.Visible = false end
        end

        guideLine.From = center; guideLine.To = targetPos2D; guideLine.Color = ACCENT; guideLine.Visible = true

        local camPos   = Camera.CFrame.Position
        local newLook  = (targetPos3D - camPos).Unit
        local lerped   = Camera.CFrame.LookVector:Lerp(newLook, S.Smooth)
        if S.RCS then
            local rc  = Vector3.new(math.sin(t*30)*S.RecoilComp, math.cos(t*30)*S.RecoilComp/2, 0)
            lerped    = (lerped + rc).Unit
        end
        Camera.CFrame = CFrame.new(camPos, camPos + lerped)
    else
        for _,l in ipairs(targetLines)  do l.Visible = false end
        for _,l in ipairs(targetLines2) do l.Visible = false end
        guideLine.Visible = false
    end
end)

-- ==================== GUI ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "losware_gui"
ScreenGui.ResetOnSpawn   = false
ScreenGui.DisplayOrder   = 9999
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Delta: используем PlayerGui напрямую — самый надёжный способ
local _guiParent = LocalPlayer:WaitForChild("PlayerGui")
pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        _guiParent = game:GetService("CoreGui")
    elseif typeof(gethui) == "function" then
        _guiParent = gethui()
    end
end)
ScreenGui.Parent = _guiParent

local function make(cls, props, parent)
    local o = Instance.new(cls)
    for k,v in pairs(props) do o[k] = v end
    if parent then o.Parent = parent end
    return o
end

local function px(n)  return UDim.new(0,n) end
local function ud2(x,y)    return UDim2.new(0,x,0,y) end
local function ud2s(xs,x,ys,y) return UDim2.new(xs,x,ys,y) end

-- Open button — правый нижний угол, большой для пальца
local OpenBtn = make("TextButton", {
    Size             = ud2(72, 72),
    Position         = ud2s(1, -86, 1, -100),
    AnchorPoint      = Vector2.new(1, 1),
    BackgroundColor3 = Color3.fromRGB(28, 28, 38),
    TextColor3       = ACCENT,
    Text             = "lw",
    TextSize          = 20,
    Font             = Enum.Font.GothamBold,
    ZIndex           = 99999,
    BorderSizePixel  = 0,
    AutoButtonColor  = false,
    Active           = true,
    Selectable       = true,
}, ScreenGui)
make("UICorner", {CornerRadius = UDim.new(0, 18)}, OpenBtn)
make("UIStroke", {Color = ACCENT, Thickness = 2}, OpenBtn)

TweenService:Create(OpenBtn, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {BackgroundColor3 = Color3.fromRGB(40, 36, 70)}):Play()

-- Main window
local Main = make("Frame", {
    Name             = "Main",
    Size             = ud2s(0,420,0,310),
    Position         = ud2s(0.5,-210,0.5,-155),
    BackgroundColor3 = BG,
    BorderSizePixel  = 0,
    Visible          = false,
    ZIndex           = 1000,
    ClipsDescendants = true,
}, ScreenGui)
make("UICorner", {CornerRadius = UDim.new(0,8)}, Main)
make("UIStroke", {Color = BORDER, Thickness = 1}, Main)

-- Title bar
local TitleBar = make("Frame", {
    Size             = ud2s(1,0,0,32),
    BackgroundColor3 = Color3.fromRGB(16,16,22),
    BorderSizePixel  = 0,
    ZIndex           = 1001,
}, Main)
make("UICorner", {CornerRadius = UDim.new(0,8)}, TitleBar)

make("TextLabel", {
    Text      = "| losware |",
    TextColor3= ACCENT,
    BackgroundTransparency = 1,
    Size      = ud2s(0.7,0,1,0),
    Position  = ud2(10,0),
    Font      = Enum.Font.GothamBold,
    TextSize  = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex    = 12,
}, TitleBar)

local CloseBtn = make("TextButton", {
    Text      = "✕",
    TextColor3= TEXTDIM,
    BackgroundTransparency = 1,
    Size      = ud2(32,32),
    Position  = ud2s(1,-32,0,0),
    Font      = Enum.Font.GothamBold,
    TextSize  = 13,
    ZIndex    = 12,
}, TitleBar)

-- Sidebar
local Sidebar = make("Frame", {
    Size             = ud2(100, 278),
    Position         = ud2(0,32),
    BackgroundColor3 = SIDE,
    BorderSizePixel  = 0,
    ZIndex           = 1001,
}, Main)
make("UICorner", {CornerRadius = UDim.new(0,6)}, Sidebar)

-- Content
local Content = make("Frame", {
    Size             = ud2(320, 278),
    Position         = ud2(100,32),
    BackgroundColor3 = BG,
    BorderSizePixel  = 0,
    ZIndex           = 1001,
}, Main)
make("UICorner", {CornerRadius = UDim.new(0,6)}, Content)

-- Tabs config
local TABS = {
    {name="Aimbot",  icon="◎"},
    {name="World",   icon="◈"},
    {name="Weapons", icon="◆"},
    {name="Misc",    icon="◇"},
    {name="AutoFarm",icon="⚙"},
    {name="Exit",    icon="✕"},
}

local TabBtns   = {}
local TabFrames = {}
local activeTab = "Aimbot"

local function makeScrollFrame(parent)
    local sf = make("ScrollingFrame", {
        Size          = ud2s(1,0,1,0),
        BackgroundTransparency = 1,
        BorderSizePixel= 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = ACCENT,
        AutomaticCanvasSize  = Enum.AutomaticSize.Y,
        CanvasSize    = ud2s(1,0,0,0),
        ZIndex        = 1002,
        ScrollingEnabled = true,
    }, parent)
    make("UIPadding", {PaddingLeft=px(8), PaddingRight=px(8), PaddingTop=px(6)}, sf)
    make("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,4)}, sf)
    return sf
end

local function addSection(parent, label, order)
    local f = make("Frame", {
        Size = ud2s(1,0,0,20),
        BackgroundTransparency = 1,
        LayoutOrder = order or 0,
    }, parent)
    make("TextLabel", {
        Text  = label:upper(),
        TextColor3 = ACCENT,
        BackgroundTransparency = 1,
        Size  = ud2s(1,0,1,0),
        Font  = Enum.Font.GothamBold,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 13,
    }, f)
    make("Frame", {
        Size = ud2s(1,-55,0,1),
        Position = ud2(52,9),
        BackgroundColor3 = BORDER,
        BorderSizePixel = 0,
        ZIndex = 13,
    }, f)
end

local function addToggle(parent, label, key, order, onChange)
    local row = make("Frame", {
        Size = ud2s(1,0,0,26),
        BackgroundColor3 = PANEL,
        BorderSizePixel = 0,
        LayoutOrder = order or 0,
    }, parent)
    make("UICorner", {CornerRadius = UDim.new(0,5)}, row)

    local ind = make("Frame", {
        Size = ud2(8,8),
        Position = ud2(8,9),
        BackgroundColor3 = S[key] and TOGON or TOGOFF,
        BorderSizePixel = 0,
        ZIndex = 14,
    }, row)
    make("UICorner", {CornerRadius = UDim.new(0,2)}, ind)

    make("TextLabel", {
        Text  = label,
        TextColor3 = TEXT,
        BackgroundTransparency = 1,
        Size  = ud2s(1,-70,1,0),
        Position = ud2(22,0),
        Font  = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14,
    }, row)

    local pill = make("Frame", {
        Size = ud2(32,14),
        Position = ud2s(1,-40,0.5,-7),
        BackgroundColor3 = S[key] and TOGON or TOGOFF,
        BorderSizePixel = 0,
        ZIndex = 14,
    }, row)
    make("UICorner", {CornerRadius = UDim.new(0.5,0)}, pill)
    local knob = make("Frame", {
        Size = ud2(10,10),
        Position = S[key] and ud2(20,2) or ud2(2,2),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        BorderSizePixel = 0,
        ZIndex = 15,
    }, pill)
    make("UICorner", {CornerRadius = UDim.new(0.5,0)}, knob)

    local btn = make("TextButton", {
        Text = "",
        BackgroundTransparency = 1,
        Size = ud2s(1,0,1,0),
        ZIndex = 16,
    }, row)

    local function doToggle()
        S[key] = not S[key]
        local v = S[key]
        local ti = TweenInfo.new(0.15)
        TweenService:Create(pill,  ti, {BackgroundColor3 = v and TOGON or TOGOFF}):Play()
        TweenService:Create(knob,  ti, {Position = v and ud2(20,2) or ud2(2,2)}):Play()
        TweenService:Create(ind,   ti, {BackgroundColor3 = v and TOGON or TOGOFF}):Play()
        if onChange then onChange(v) end
    end
    btn.MouseButton1Click:Connect(doToggle)
    btn.Activated:Connect(doToggle)
    btn.TouchTap:Connect(doToggle)
end

local function addSlider(parent, label, key, minV, maxV, fmt, order, onChange)
    local row = make("Frame", {
        Size = ud2s(1,0,0,42),
        BackgroundColor3 = PANEL,
        BorderSizePixel = 0,
        LayoutOrder = order or 0,
    }, parent)
    make("UICorner", {CornerRadius = UDim.new(0,5)}, row)

    local function fmtVal(v) return fmt and string.format(fmt, v) or tostring(math.round(v)) end

    local lbl = make("TextLabel", {
        Text  = label.." : "..fmtVal(S[key]),
        TextColor3 = TEXT,
        BackgroundTransparency = 1,
        Size  = ud2s(1,-8,0,18),
        Position = ud2(8,4),
        Font  = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 14,
    }, row)

    local track = make("Frame", {
        Size = ud2s(1,-20,0,4),
        Position = ud2(10,28),
        BackgroundColor3 = TOGOFF,
        BorderSizePixel = 0,
        ZIndex = 14,
    }, row)
    make("UICorner", {CornerRadius = UDim.new(0.5,0)}, track)

    local ratio0 = (S[key]-minV)/(maxV-minV)
    local fill = make("Frame", {
        Size = ud2s(ratio0,0,1,0),
        BackgroundColor3 = ACCENT,
        BorderSizePixel = 0,
        ZIndex = 15,
    }, track)
    make("UICorner", {CornerRadius = UDim.new(0.5,0)}, fill)

    local knob = make("Frame", {
        Size = ud2(10,10),
        Position = ud2s(ratio0,-5,0.5,-5),
        BackgroundColor3 = Color3.fromRGB(255,255,255),
        BorderSizePixel = 0,
        ZIndex = 16,
    }, track)
    make("UICorner", {CornerRadius = UDim.new(0.5,0)}, knob)

    local dragging = false
    local hitBtn = make("TextButton", {
        Text = "",
        BackgroundTransparency = 1,
        Size = ud2s(1,0,1,0),
        ZIndex = 17,
    }, track)

    hitBtn.MouseButton1Down:Connect(function() dragging = true end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging then
            local tp = track.AbsolutePosition
            local tw = track.AbsoluteSize.X
            local r  = math.clamp((i.Position.X - tp.X)/tw, 0, 1)
            local v  = minV + (maxV-minV)*r
            S[key]   = v
            fill.Size     = ud2s(r,0,1,0)
            knob.Position = ud2s(r,-5,0.5,-5)
            lbl.Text      = label.." : "..fmtVal(v)
            if onChange then onChange(v) end
        end
    end)
end

-- Build tab sidebar buttons + frames
local function switchTab(name)
    activeTab = name
    for n, f in pairs(TabFrames) do f.Visible = (n == name) end
    for n, b in pairs(TabBtns) do
        b.BackgroundColor3 = (n == name) and Color3.fromRGB(36,34,58) or SIDE
        b.TextColor3       = (n == name) and ACCENT or TEXTDIM
    end
end

for i, tab in ipairs(TABS) do
    local btn = make("TextButton", {
        Text = tab.icon.." "..tab.name,
        TextColor3 = TEXTDIM,
        BackgroundColor3 = SIDE,
        Size = ud2s(1,-6,0,30),
        Position = ud2(3, 6+(i-1)*36),
        Font = Enum.Font.Gotham,
        TextSize = 10,
        BorderSizePixel = 0,
        ZIndex = 1002,
        AutoButtonColor = false,
    }, Sidebar)
    make("UICorner", {CornerRadius = UDim.new(0,5)}, btn)
    TabBtns[tab.name] = btn

    if tab.name ~= "Exit" then
        local sf = makeScrollFrame(Content)
        sf.Visible = false
        TabFrames[tab.name] = sf

        local function doSwitch() switchTab(tab.name) end
        btn.MouseButton1Click:Connect(doSwitch)
        btn.Activated:Connect(doSwitch)
        btn.TouchTap:Connect(doSwitch)
    else
        local function doExit()
            Main.Visible = false
            guiOpen = false
            OpenBtn.Text = "lw"
        end
        btn.MouseButton1Click:Connect(doExit)
        btn.Activated:Connect(doExit)
        btn.TouchTap:Connect(doExit)
    end
end

-- ======= AIMBOT TAB =======
local ab = TabFrames["Aimbot"]
addSection(ab, "main", 1)
addToggle(ab, "AimBot",       "AimbotEnabled", 2)
addToggle(ab, "PSilent",      "PSilent",        3)
addToggle(ab, "IgnoreSlipping","IgnoreSlipping", 4)
addToggle(ab, "VisibleCheck", "VisibleCheck",   5)
addToggle(ab, "RCS",          "RCS",            6)
addSection(ab, "settings", 7)
addSlider(ab, "FOV",          "FOV",        30,300,"%.0f",8, function(v) circle.Radius = v end)
addSlider(ab, "Smooth",       "Smooth",     0.05,1,"%.2f",9)
addSlider(ab, "Prediction",   "Prediction", 0,0.5,"%.3f",10)
addSlider(ab, "HitboxScale",  "HitboxScale",1,6,  "%.1f",11)
addSlider(ab, "TargetLostDelay","TargetLostDelay",0,1,"%.2f",12)
addSlider(ab, "RecoilComp",   "RecoilComp", 0,0.02,"%.3f",13)
addSection(ab, "target animation", 14)
local animNames = {"Rotating Square","Spinning Octagon","Pulsing Square"}
for ai, aname in ipairs(animNames) do
    local arow = make("Frame", {
        Size = ud2s(1,0,0,26),
        BackgroundColor3 = PANEL,
        BorderSizePixel = 0,
        LayoutOrder = 14+ai,
    }, ab)
    make("UICorner", {CornerRadius = UDim.new(0,5)}, arow)
    local ind2 = make("Frame", {
        Size = ud2(8,8), Position = ud2(8,9),
        BackgroundColor3 = S.TargetAnim == ai and TOGON or TOGOFF,
        BorderSizePixel = 0, ZIndex = 14,
    }, arow)
    make("UICorner", {CornerRadius = UDim.new(0,2)}, ind2)
    make("TextLabel", {
        Text = aname, TextColor3 = TEXT,
        BackgroundTransparency = 1,
        Size = ud2s(1,-20,1,0), Position = ud2(22,0),
        Font = Enum.Font.Gotham, TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 14,
    }, arow)
    local abtn2 = make("TextButton", {
        Text = "", BackgroundTransparency = 1,
        Size = ud2s(1,0,1,0), ZIndex = 16,
    }, arow)
    abtn2.MouseButton1Click:Connect(function()
        S.TargetAnim = ai
        for _, ch in ipairs(ab:GetChildren()) do
            if ch:IsA("Frame") and ch.LayoutOrder >= 15 and ch.LayoutOrder <= 17 then
                local indInner = ch:FindFirstChildWhichIsA("Frame")
                if indInner then
                    indInner.BackgroundColor3 = TOGOFF
                end
            end
        end
        ind2.BackgroundColor3 = TOGON
    end)
end

-- ======= WORLD TAB =======
local wo = TabFrames["World"]
addSection(wo, "visuals", 1)
addToggle(wo, "ESP Boxes",    "ESPEnabled", 2)
addToggle(wo, "Skeleton",     "Skeleton",   3)
addToggle(wo, "Tracers",      "Tracers",    4)
addToggle(wo, "Names",        "Names",      5)
addToggle(wo, "FOV Circle",   "FOVCircle",  6)
addSection(wo, "environment", 7)
addToggle(wo, "Night Vision", "NightVision",8, function(v) nightVision.Enabled = v end)

-- ======= WEAPONS TAB =======
local wp = TabFrames["Weapons"]
addSection(wp, "combat", 1)
addToggle(wp, "Anti Recoil",  "RCS",        2)
addSlider(wp, "Recoil Comp",  "RecoilComp", 0,0.02,"%.3f",3)
addSlider(wp, "HitboxScale",  "HitboxScale",1,6,   "%.1f",4)
addSection(wp, "aimbot", 5)
addSlider(wp, "Smooth",       "Smooth",     0.05,1,"%.2f",6)
addSlider(wp, "Prediction",   "Prediction", 0,0.5,"%.3f",7)

-- ======= MISC TAB =======
local ms = TabFrames["Misc"]
addSection(ms, "misc", 1)
addToggle(ms, "IgnoreSlipping","IgnoreSlipping",2)
addToggle(ms, "PSilent",       "PSilent",       3)
addSection(ms, "info", 4)
local infoLbl = make("TextLabel", {
    Text = "| losware |\nbuild: 2025\nuse ☰ to toggle",
    TextColor3 = TEXTDIM,
    BackgroundTransparency = 1,
    Size = ud2s(1,0,0,52),
    Font = Enum.Font.Gotham, TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    LayoutOrder = 5,
}, ms)

-- ======= AUTOFARM TAB =======
local af = TabFrames["AutoFarm"]
addSection(af, "autofarm", 1)
addToggle(af, "AutoFarm", "AutoFarm", 2, function(v)
    isFarming = v
    if v then
        task.spawn(startFarming)
    else
        afSetSpeed(origWalkSpeed, origJumpPower)
    end
end)
addSection(af, "settings", 3)
addSlider(af, "Walk Speed",  "AutoFarm", 10, 50, "%.0f", 4)

-- ==================== WINDOW TOGGLE ====================
local guiOpen = false
local lastToggle = 0

local function toggleGui()
    local now = tick()
    if now - lastToggle < 0.5 then return end
    lastToggle = now
    guiOpen = not guiOpen
    Main.Visible = guiOpen
    OpenBtn.Text = guiOpen and "X" or "lw"
end

-- Только Activated — срабатывает на Delta без дублирования
OpenBtn.Activated:Connect(toggleGui)
CloseBtn.Activated:Connect(toggleGui)

-- Клавиатура (ПК)
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then toggleGui() end
    if input.KeyCode == Enum.KeyCode.Insert then toggleGui() end
end)

-- Drag
local dragWin, dragStart, posStart = false, nil, nil
TitleBar.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        dragWin   = true
        dragStart = i.Position
        posStart  = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragWin and dragStart and posStart then
        local d = i.Position - dragStart
        Main.Position = UDim2.new(posStart.X.Scale, posStart.X.Offset + d.X, posStart.Y.Scale, posStart.Y.Offset + d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
        dragWin = false
    end
end)

switchTab("Aimbot")
print("| losware | loaded")
