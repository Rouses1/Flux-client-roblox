local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local Camera           = workspace.CurrentCamera
local LocalPlayer      = Players.LocalPlayer
local Lighting         = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
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
local C = {
    bg      = Color3.fromRGB(15, 15, 20),
    sidebar = Color3.fromRGB(20, 18, 28),
    panel   = Color3.fromRGB(25, 23, 35),
    header  = Color3.fromRGB(18, 16, 26),
    accent  = Color3.fromRGB(110, 90, 210),
    accent2 = Color3.fromRGB(140, 120, 240),
    border  = Color3.fromRGB(55, 48, 100),
    text    = Color3.fromRGB(210, 205, 225),
    dim     = Color3.fromRGB(110, 105, 140),
    on      = Color3.fromRGB(110, 90, 210),
    off     = Color3.fromRGB(45, 42, 65),
    white   = Color3.fromRGB(255,255,255),
    black   = Color3.fromRGB(0,0,0),
}

-- ==================== NIGHT VISION ====================
local nightVision = Instance.new("ColorCorrectionEffect")
nightVision.Name        = "NV_losware"
nightVision.Brightness  = 0.08
nightVision.Contrast    = 0.2
nightVision.Saturation  = -0.35
nightVision.TintColor   = Color3.fromRGB(170, 200, 230)
nightVision.Enabled     = S.NightVision
nightVision.Parent      = Lighting
Lighting.Brightness     = 2
Lighting.Ambient        = Color3.fromRGB(110,120,130)
Lighting.OutdoorAmbient = Color3.fromRGB(120,130,140)
Lighting.FogEnd         = 100000

-- ==================== DRAWING ====================
local circle = Drawing.new("Circle")
circle.Radius       = S.FOV
circle.Thickness    = 1
circle.Color        = C.accent
circle.Transparency = 1
circle.Filled       = false
circle.Visible      = S.FOVCircle

local targetLines = {}
for i=1,4 do
    local l=Drawing.new("Line"); l.Thickness=2; l.Color=C.accent; l.Visible=false
    table.insert(targetLines,l)
end
local targetLines2 = {}
for i=1,8 do
    local l=Drawing.new("Line"); l.Thickness=1; l.Color=C.accent2; l.Visible=false
    table.insert(targetLines2,l)
end
local guideLine=Drawing.new("Line"); guideLine.Thickness=1; guideLine.Color=C.accent; guideLine.Visible=false
local countText=Drawing.new("Text"); countText.Size=28; countText.Color=C.accent; countText.Center=true; countText.Outline=true; countText.OutlineColor=C.black; countText.Visible=true

-- ==================== ESP ====================
local ESPBoxes,TracerObjs,SkelObjs,NameObjs={},{},{},{}
local function newLine(col) local l=Drawing.new("Line"); l.Color=col or C.accent; l.Thickness=1; return l end

local function createESP(player)
    local box=Drawing.new("Square"); box.Color=C.accent; box.Thickness=1; box.Filled=false
    local t1=Drawing.new("Line"); t1.Color=C.accent; t1.Thickness=1
    local t2=Drawing.new("Line"); t2.Color=C.accent; t2.Thickness=1
    local skel={headTorso=newLine(C.accent),leftArm=newLine(C.accent),rightArm=newLine(C.accent),leftLeg=newLine(C.accent),rightLeg=newLine(C.accent)}
    local name=Drawing.new("Text"); name.Size=12; name.Center=true; name.Outline=true; name.Color=C.accent
    ESPBoxes[player]=box; TracerObjs[player]={t1,t2}; SkelObjs[player]=skel; NameObjs[player]=name
end

for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then createESP(p) end end
Players.PlayerAdded:Connect(function(p) if p~=LocalPlayer then createESP(p) end end)
Players.PlayerRemoving:Connect(function(p)
    if ESPBoxes[p] then ESPBoxes[p]:Remove() end
    if TracerObjs[p] then for _,l in ipairs(TracerObjs[p]) do l:Remove() end end
    if SkelObjs[p] then for _,l in pairs(SkelObjs[p]) do l:Remove() end end
    if NameObjs[p] then NameObjs[p]:Remove() end
end)

-- ==================== UTILS ====================
local function isVisible(part,character)
    if not S.VisibleCheck then return true end
    local origin=Camera.CFrame.Position
    local params=RaycastParams.new()
    params.FilterDescendantsInstances={LocalPlayer.Character,Camera}
    params.FilterType=Enum.RaycastFilterType.Blacklist
    local hb=part.Size.Magnitude*(S.HitboxScale-1)/2
    for _,off in ipairs({Vector3.new(0,0,0),Vector3.new(hb,hb,0),Vector3.new(-hb,hb,0),Vector3.new(hb,-hb,0),Vector3.new(-hb,-hb,0)}) do
        local dir=(part.Position+off)-origin
        local r=workspace:Raycast(origin,dir,params)
        if not r or r.Instance:IsDescendantOf(character) then return true end
    end
    return false
end
local function w2sv(part) local p=Camera:WorldToViewportPoint(part.Position); return Vector2.new(p.X,p.Y) end

-- ==================== HITBOX ====================
local function enlargeHitboxes()
    for _,player in ipairs(Players:GetPlayers()) do
        if player~=LocalPlayer and player.Character then
            for _,part in ipairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name~="HumanoidRootPart" then
                    local orig=part.Size; part.Size=orig*S.HitboxScale; task.wait(0.05); part.Size=orig
                end
            end
        end
    end
end
task.spawn(function() while true do task.wait(0.5); enlargeHitboxes() end end)

-- ==================== AUTOFARM ====================
local isFarming=false
local farmWalkSpeed=24; local farmJumpPower=70; local origWalkSpeed=16; local origJumpPower=50
local farmCircleAngle=0; local farmStuckTimer=0; local farmLastPos=nil

local function afAutoRespawn()
    local char=LocalPlayer.Character; local hum=char and char:FindFirstChild("Humanoid")
    if hum and hum.Health<=0 then task.wait(2); LocalPlayer:LoadCharacter(); task.wait(3); return true end
    return false
end
local function afSetSpeed(sp,jp)
    local char=LocalPlayer.Character; local hum=char and char:FindFirstChild("Humanoid")
    if hum then hum.WalkSpeed=sp or origWalkSpeed; hum.JumpPower=jp or origJumpPower end
end
local function afOreReachable(orePart)
    if not orePart or not orePart.Parent then return false end
    local char=LocalPlayer.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    if orePart.Position.Y<-10 then return false end
    local params=RaycastParams.new(); params.FilterType=Enum.RaycastFilterType.Blacklist; params.FilterDescendantsInstances={char,orePart}
    local dir=orePart.Position-hrp.Position; local dist=dir.Magnitude
    if dist>200 then return true end
    local r=workspace:Raycast(hrp.Position,dir.Unit*dist,params)
    if r then local h=r.Instance; if h and h~=orePart and not h:IsDescendantOf(char) then if h.CanCollide and h.Transparency<0.5 then return false end end end
    return true
end
local function afGetNearest()
    local char=LocalPlayer.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local nearest,shortest=nil,math.huge
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name=="IronPart" and obj.Parent then
            local d=(hrp.Position-obj.Position).Magnitude
            if d<shortest and d<=1000000 and afOreReachable(obj) then shortest=d; nearest=obj end
        end
    end
    return nearest
end
local function afMine(orePart)
    pcall(function()
        local cd=orePart:FindFirstChildWhichIsA("ClickDetector"); if cd then cd:Click() end
        local pp=orePart:FindFirstChildWhichIsA("ProximityPrompt"); if pp then pp:Prompt() end
        local char=LocalPlayer.Character
        if char then local tool=char:FindFirstChildWhichIsA("Tool"); if tool then local act=tool:FindFirstChild("Activate"); if act then act:FireServer(orePart) end end end
    end)
end
local function afCircle(orePart,radius)
    if not orePart or not orePart.Parent then return end
    local char=LocalPlayer.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); local hum=char and char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    radius=radius or 3.5; farmCircleAngle=farmCircleAngle+0.4
    local op=orePart.Position
    hum:MoveTo(Vector3.new(op.X+math.cos(farmCircleAngle)*radius,op.Y+1.5,op.Z+math.sin(farmCircleAngle)*radius))
end
local function afMoveTo(orePart)
    local char=LocalPlayer.Character; local hrp=char and char:FindFirstChild("HumanoidRootPart"); local hum=char and char:FindFirstChild("Humanoid")
    if not hrp or not hum then return false end
    local op=orePart.Position; farmStuckTimer=0; farmLastPos=hrp.Position
    local path=PathfindingService:CreatePath()
    local ok=pcall(function() path:ComputeAsync(hrp.Position,op) end)
    if ok and path.Status==Enum.PathStatus.Success then
        for i,wp in ipairs(path:GetWaypoints()) do
            if not isFarming or not orePart.Parent then return false end
            hum:MoveTo(wp.Position); hum.MoveToFinished:Wait(1)
            if wp.Action==Enum.PathWaypointAction.Jump then hum.Jump=true; task.wait(0.2) end
        end
    end
    hum:MoveTo(op)
    local timeout=tick()+8
    while (hrp.Position-op).Magnitude>3.5 and tick()<timeout do
        if afAutoRespawn() then return false end
        if not orePart.Parent or not afOreReachable(orePart) then return false end
        local cp=hrp.Position
        if (cp-farmLastPos).Magnitude<0.5 then
            farmStuckTimer=farmStuckTimer+0.1
            if farmStuckTimer>1.5 then
                hum.Jump=true; afSetSpeed(28,farmJumpPower); task.wait(0.3); afSetSpeed(farmWalkSpeed,farmJumpPower)
                farmStuckTimer=0
                hum:MoveTo(Vector3.new(cp.X+math.random(-3,3),op.Y+2,cp.Z+math.random(-3,3))); task.wait(0.5)
            end
        else farmStuckTimer=math.max(0,farmStuckTimer-0.1) end
        farmLastPos=cp; hum:MoveTo(op); task.wait(0.1)
    end
    return (hrp.Position-op).Magnitude<=4
end
local function startFarming()
    while isFarming do
        if afAutoRespawn() then task.wait(2) end
        local target=afGetNearest()
        if not target then afSetSpeed(origWalkSpeed,origJumpPower); task.wait(0.5)
        else
            afSetSpeed(farmWalkSpeed,farmJumpPower)
            local reached=afMoveTo(target)
            if reached and target.Parent and afOreReachable(target) then
                local ct=tick()+2.5; local ma=0
                while tick()<ct and isFarming and target.Parent and afOreReachable(target) do
                    afCircle(target,2.8); afMine(target); ma=ma+1
                    if ma>=5 then afMine(target) end
                    task.wait(0.12)
                end
                afMine(target)
            end
            task.wait(0.15)
        end
    end
    afSetSpeed(origWalkSpeed,origJumpPower)
end

-- ==================== MAIN LOOP ====================
local currentTarget,lastTargetTime=nil,0
RunService.RenderStepped:Connect(function()
    local screenSize=Camera.ViewportSize
    local center=Vector2.new(screenSize.X/2,screenSize.Y/2)
    local t=tick()
    circle.Visible=S.FOVCircle; circle.Position=center; circle.Radius=S.FOV; circle.Color=C.accent
    countText.Position=center-Vector2.new(0,S.FOV+30)
    local closestDist=math.huge
    local targetPos2D,targetPos3D,targetPlayer,targetDistance
    local count=0
    for player,box in pairs(ESPBoxes) do
        local char=player.Character
        local head=char and char:FindFirstChild("Head")
        local hrp=char and char:FindFirstChild("HumanoidRootPart")
        local hum=char and char:FindFirstChild("Humanoid")
        if head and hrp and hum and hum.Health>0 then
            local pos3,onScreen=Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local screenPos=Vector2.new(pos3.X,pos3.Y)
                local dist2D=(screenPos-center).Magnitude
                if S.AimbotEnabled and dist2D<=S.FOV and isVisible(head,char) then
                    count=count+1
                    if dist2D<closestDist then
                        closestDist=dist2D
                        targetDistance=(Camera.CFrame.Position-hrp.Position).Magnitude
                        local vel=head.Velocity or Vector3.new()
                        local dist3D=(head.Position-Camera.CFrame.Position).Magnitude
                        local pf=S.Prediction*(1+dist3D/500)
                        local accel=head.AssemblyLinearVelocity-(head.AssemblyLinearVelocity-Vector3.new())
                        local pp=head.Position+vel*(dist3D/800)*pf+accel*0.05
                        targetPos3D=pp; targetPlayer=player
                        local a2d=Camera:WorldToViewportPoint(pp)
                        targetPos2D=Vector2.new(a2d.X,a2d.Y)
                    end
                end
                if S.ESPEnabled then
                    local top=Camera:WorldToViewportPoint(hrp.Position+Vector3.new(0,3,0))
                    local bottom=Camera:WorldToViewportPoint(hrp.Position-Vector3.new(0,3,0))
                    local sizeY=math.abs(top.Y-bottom.Y)
                    box.Size=Vector2.new(sizeY/2,sizeY)
                    box.Position=Vector2.new(screenPos.X-box.Size.X/2,screenPos.Y-box.Size.Y/2)
                    box.Color=C.accent; box.Visible=true
                else box.Visible=false end
                if S.Tracers then
                    TracerObjs[player][1].From=Vector2.new(screenSize.X/2,0); TracerObjs[player][1].To=screenPos; TracerObjs[player][1].Color=C.accent; TracerObjs[player][1].Visible=true
                    TracerObjs[player][2].From=center; TracerObjs[player][2].To=screenPos; TracerObjs[player][2].Color=C.accent; TracerObjs[player][2].Visible=true
                else TracerObjs[player][1].Visible=false; TracerObjs[player][2].Visible=false end
                if S.Names then
                    local top2=Camera:WorldToViewportPoint(hrp.Position+Vector3.new(0,3,0))
                    local bot2=Camera:WorldToViewportPoint(hrp.Position-Vector3.new(0,3,0))
                    local sy2=math.abs(top2.Y-bot2.Y)
                    local d3=math.floor((Camera.CFrame.Position-hrp.Position).Magnitude)
                    NameObjs[player].Text=player.Name.." ["..d3.."m]"
                    NameObjs[player].Position=Vector2.new(screenPos.X,screenPos.Y-sy2/2-12)
                    NameObjs[player].Color=C.accent; NameObjs[player].Visible=true
                else NameObjs[player].Visible=false end
                if S.Skeleton then
                    local sc=C.accent; local h2d=w2sv(head); local t2d=w2sv(hrp)
                    SkelObjs[player].headTorso.From=h2d; SkelObjs[player].headTorso.To=t2d; SkelObjs[player].headTorso.Color=sc; SkelObjs[player].headTorso.Visible=true
                    local function drawLimb(key,n1,n2)
                        local p=char:FindFirstChild(n1) or char:FindFirstChild(n2 or n1)
                        if p then SkelObjs[player][key].From=t2d; SkelObjs[player][key].To=w2sv(p); SkelObjs[player][key].Color=sc; SkelObjs[player][key].Visible=true
                        else SkelObjs[player][key].Visible=false end
                    end
                    drawLimb("leftArm","Left Arm","LeftUpperArm"); drawLimb("rightArm","Right Arm","RightUpperArm")
                    drawLimb("leftLeg","Left Leg","LeftLowerLeg"); drawLimb("rightLeg","Right Leg","RightLowerLeg")
                else for _,l in pairs(SkelObjs[player]) do l.Visible=false end end
            else
                box.Visible=false; TracerObjs[player][1].Visible=false; TracerObjs[player][2].Visible=false
                NameObjs[player].Visible=false; for _,l in pairs(SkelObjs[player]) do l.Visible=false end
            end
        else
            box.Visible=false; TracerObjs[player][1].Visible=false; TracerObjs[player][2].Visible=false
            NameObjs[player].Visible=false; for _,l in pairs(SkelObjs[player]) do l.Visible=false end
        end
    end
    countText.Text=tostring(count); countText.Color=C.accent
    if not targetPos2D and currentTarget and (tick()-lastTargetTime)<S.TargetLostDelay then
        local char=currentTarget.Character
        if char and char:FindFirstChild("Head") then
            local h=char.Head; local vel=h.Velocity or Vector3.new()
            local d3=(h.Position-Camera.CFrame.Position).Magnitude
            local pp=h.Position+vel*(d3/800)*S.Prediction
            targetPos3D=pp; local a=Camera:WorldToViewportPoint(pp)
            targetPos2D=Vector2.new(a.X,a.Y); targetDistance=(Camera.CFrame.Position-h.Position).Magnitude
        end
    elseif targetPlayer then currentTarget=targetPlayer; lastTargetTime=tick() end
    if S.AimbotEnabled and targetPos2D and targetDistance then
        local anim=S.TargetAnim
        if anim==1 then
            local sz=math.clamp(8*math.clamp(targetDistance/100,1,5.5),10,45); local rot=t*4; local pts={}
            for i=1,4 do local angle=math.rad((i-1)*90+rot*60); table.insert(pts,Vector2.new(targetPos2D.X+math.cos(angle)*sz,targetPos2D.Y+math.sin(angle)*sz)) end
            for i=1,4 do targetLines[i].From=pts[i]; targetLines[i].To=pts[i%4+1]; targetLines[i].Color=C.accent; targetLines[i].Visible=true end
            for _,l in ipairs(targetLines2) do l.Visible=false end
        elseif anim==2 then
            local sz=20; local rot=t*6
            for i=1,8 do
                local a1=math.rad((i-1)*45+rot*40); local a2=math.rad(i*45+rot*40)
                targetLines2[i].From=Vector2.new(targetPos2D.X+math.cos(a1)*sz,targetPos2D.Y+math.sin(a1)*sz)
                targetLines2[i].To=Vector2.new(targetPos2D.X+math.cos(a2)*sz,targetPos2D.Y+math.sin(a2)*sz)
                targetLines2[i].Color=C.accent2; targetLines2[i].Visible=true
            end
            for _,l in ipairs(targetLines) do l.Visible=false end
        elseif anim==3 then
            local sz=math.clamp(15+math.sin(t*5)*8,10,30); local pts={}
            for i=1,4 do local angle=math.rad((i-1)*90); table.insert(pts,Vector2.new(targetPos2D.X+math.cos(angle)*sz,targetPos2D.Y+math.sin(angle)*sz)) end
            for i=1,4 do targetLines[i].From=pts[i]; targetLines[i].To=pts[i%4+1]; targetLines[i].Color=C.accent; targetLines[i].Visible=true end
            for _,l in ipairs(targetLines2) do l.Visible=false end
        end
        guideLine.From=center; guideLine.To=targetPos2D; guideLine.Color=C.accent; guideLine.Visible=true
        local camPos=Camera.CFrame.Position; local newLook=(targetPos3D-camPos).Unit
        local lerped=Camera.CFrame.LookVector:Lerp(newLook,S.Smooth)
        if S.RCS then local rc=Vector3.new(math.sin(t*30)*S.RecoilComp,math.cos(t*30)*S.RecoilComp/2,0); lerped=(lerped+rc).Unit end
        Camera.CFrame=CFrame.new(camPos,camPos+lerped)
    else for _,l in ipairs(targetLines) do l.Visible=false end; for _,l in ipairs(targetLines2) do l.Visible=false end; guideLine.Visible=false end
end)

-- ====================================================================================
-- ==================== GUI — CS:GO STYLE ==============================================
-- ====================================================================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name            = "losware_v2"
ScreenGui.ResetOnSpawn    = false
ScreenGui.DisplayOrder    = 99999
ScreenGui.IgnoreGuiInset  = true
ScreenGui.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling

-- Надёжный родитель для Delta
local ok2, pg = pcall(function() return LocalPlayer:WaitForChild("PlayerGui", 5) end)
ScreenGui.Parent = (ok2 and pg) or LocalPlayer:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")

-- helpers
local function N(cls, props, par)
    local o = Instance.new(cls)
    for k,v in pairs(props) do pcall(function() o[k]=v end) end
    if par then o.Parent = par end
    return o
end
local function px(n) return UDim.new(0,n) end
local function u2(x,y) return UDim2.new(0,x,0,y) end
local function u2s(xs,x,ys,y) return UDim2.new(xs,x,ys,y) end

-- ===== OPEN BUTTON — правый нижний угол =====
local OpenBtn = N("TextButton", {
    Size             = u2(72,72),
    Position         = u2s(1,-86, 1,-100),
    AnchorPoint      = Vector2.new(1,1),
    BackgroundColor3 = C.sidebar,
    TextColor3       = C.accent,
    Text             = "lw",
    TextSize         = 20,
    Font             = Enum.Font.GothamBold,
    ZIndex           = 99999,
    BorderSizePixel  = 0,
    AutoButtonColor  = false,
    Active           = true,
    Selectable       = true,
    ClipsDescendants = false,
}, ScreenGui)
N("UICorner", {CornerRadius=UDim.new(0,16)}, OpenBtn)
N("UIStroke", {Color=C.accent, Thickness=2}, OpenBtn)
-- пульсация
TweenService:Create(OpenBtn, TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true), {BackgroundColor3=Color3.fromRGB(35,30,60)}):Play()

-- ===== MAIN WINDOW =====
-- Размер под телефон: 480 x 300
local Main = N("Frame", {
    Name             = "LoswareMain",
    Size             = u2(480,300),
    Position         = u2s(0.5,-240, 0.5,-150),
    BackgroundColor3 = C.bg,
    BorderSizePixel  = 0,
    Visible          = false,
    ZIndex           = 10000,
    ClipsDescendants = true,
}, ScreenGui)
N("UICorner", {CornerRadius=UDim.new(0,6)}, Main)
N("UIStroke", {Color=C.border, Thickness=1}, Main)

-- ===== TITLE BAR =====
local TitleBar = N("Frame", {
    Size             = u2s(1,0, 0,26),
    BackgroundColor3 = C.header,
    BorderSizePixel  = 0,
    ZIndex           = 10001,
}, Main)
N("UICorner",{CornerRadius=UDim.new(0,6)}, TitleBar)
-- fix bottom corners
N("Frame",{Size=u2s(1,0,0,8),Position=u2s(0,0,1,-8),BackgroundColor3=C.header,BorderSizePixel=0,ZIndex=10001}, TitleBar)

N("TextLabel",{
    Text="losware | roblox",
    TextColor3=C.accent, BackgroundTransparency=1,
    Size=u2s(0.7,0,1,0), Position=u2(10,0),
    Font=Enum.Font.GothamBold, TextSize=12,
    TextXAlignment=Enum.TextXAlignment.Left, ZIndex=10002,
}, TitleBar)

local CloseX = N("TextButton",{
    Text="x", TextColor3=C.dim, BackgroundTransparency=1,
    Size=u2(26,26), Position=u2s(1,-26,0,0),
    Font=Enum.Font.GothamBold, TextSize=14,
    ZIndex=10002, AutoButtonColor=false, Active=true,
}, TitleBar)

-- ===== LAYOUT: SIDEBAR + CONTENT =====
local SIDEBAR_W = 110
local CONTENT_X = SIDEBAR_W

-- Sidebar
local Sidebar = N("Frame",{
    Size=u2(SIDEBAR_W, 274),
    Position=u2(0,26),
    BackgroundColor3=C.sidebar,
    BorderSizePixel=0, ZIndex=10001,
}, Main)
-- fix top corners
N("Frame",{Size=u2s(1,0,0,6),Position=u2(0,0),BackgroundColor3=C.sidebar,BorderSizePixel=0,ZIndex=10001}, Sidebar)
N("UIStroke",{Color=C.border,Thickness=1}, Sidebar)

-- Content area
local ContentArea = N("Frame",{
    Size=u2s(1,-CONTENT_X, 0, 274),
    Position=u2(CONTENT_X,26),
    BackgroundColor3=C.bg,
    BorderSizePixel=0, ZIndex=10001,
}, Main)

-- ===== TABS DEFINITION =====
local TABS = {
    {id="aimbot",   label="aimbot"},
    {id="visuals",  label="visuals"},
    {id="misc",     label="misc"},
    {id="autofarm", label="autofarm"},
}

local TabBtns   = {}
local TabFrames = {}
local activeTab = nil

-- indicator line (like CS:GO blue bar)
local TabIndicator = N("Frame",{
    Size=u2(3,20), Position=u2(0,8),
    BackgroundColor3=C.accent,
    BorderSizePixel=0, ZIndex=10003,
}, Sidebar)
N("UICorner",{CornerRadius=UDim.new(0,2)}, TabIndicator)

local function makeScrollFrame(parent)
    local sf = N("ScrollingFrame",{
        Size=u2s(1,0,1,0), BackgroundTransparency=1,
        BorderSizePixel=0, ScrollBarThickness=3,
        ScrollBarImageColor3=C.accent,
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        CanvasSize=u2s(1,0,0,0),
        ZIndex=10002, ScrollingEnabled=true,
    }, parent)
    N("UIPadding",{PaddingLeft=px(8),PaddingRight=px(8),PaddingTop=px(8),PaddingBottom=px(8)}, sf)
    N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,4)}, sf)
    return sf
end

-- ===== SECTION HEADER (like "main" in screenshot) =====
local function addSection(parent, label, order)
    local row = N("Frame",{
        Size=u2s(1,0,0,18), BackgroundTransparency=1, LayoutOrder=order or 0,
    }, parent)
    N("TextLabel",{
        Text=label, TextColor3=C.accent, BackgroundTransparency=1,
        Size=u2s(1,0,1,0),
        Font=Enum.Font.GothamBold, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=10003,
    }, row)
    -- horizontal line
    N("Frame",{
        Size=u2s(1,0,0,1), Position=u2s(0,0,1,-1),
        BackgroundColor3=C.border, BorderSizePixel=0, ZIndex=10003,
    }, row)
end

-- ===== CHECKBOX (matches screenshot style) =====
local function addCheckbox(parent, label, key, order, onChange)
    local row = N("Frame",{
        Size=u2s(1,0,0,22), BackgroundTransparency=1,
        LayoutOrder=order or 0,
    }, parent)

    -- square checkbox
    local box = N("Frame",{
        Size=u2(14,14), Position=u2(0,4),
        BackgroundColor3=S[key] and C.on or C.bg,
        BorderSizePixel=0, ZIndex=10003,
    }, row)
    N("UICorner",{CornerRadius=UDim.new(0,3)}, box)
    N("UIStroke",{Color=C.accent, Thickness=1}, box)

    -- inner tick
    local tick2 = N("TextLabel",{
        Text=S[key] and "v" or "",
        TextColor3=C.white, BackgroundTransparency=1,
        Size=u2s(1,0,1,0), Font=Enum.Font.GothamBold, TextSize=10,
        ZIndex=10004,
    }, box)

    N("TextLabel",{
        Text=label, TextColor3=C.text, BackgroundTransparency=1,
        Size=u2s(1,-22,1,0), Position=u2(22,0),
        Font=Enum.Font.Gotham, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=10003,
    }, row)

    local btn = N("TextButton",{
        Text="", BackgroundTransparency=1,
        Size=u2s(1,0,1,0), ZIndex=10005,
        AutoButtonColor=false, Active=true,
    }, row)

    local function doToggle()
        S[key] = not S[key]
        local v = S[key]
        box.BackgroundColor3 = v and C.on or C.bg
        tick2.Text = v and "v" or ""
        if onChange then onChange(v) end
    end
    btn.Activated:Connect(doToggle)
    return row
end

-- ===== SLIDER =====
local function addSlider(parent, label, key, minV, maxV, fmt, order, onChange)
    local row = N("Frame",{
        Size=u2s(1,0,0,38), BackgroundTransparency=1,
        LayoutOrder=order or 0,
    }, parent)

    local function fmtVal(v) return fmt and string.format(fmt,v) or tostring(math.round(v)) end

    local lbl = N("TextLabel",{
        Text=label.."   "..fmtVal(S[key]),
        TextColor3=C.text, BackgroundTransparency=1,
        Size=u2s(1,0,0,16), Position=u2(0,0),
        Font=Enum.Font.Gotham, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left, ZIndex=10003,
    }, row)

    -- track bg
    local track = N("Frame",{
        Size=u2s(1,0,0,4), Position=u2(0,22),
        BackgroundColor3=C.off, BorderSizePixel=0, ZIndex=10003,
    }, row)
    N("UICorner",{CornerRadius=UDim.new(0.5,0)}, track)

    local ratio0 = math.clamp((S[key]-minV)/(maxV-minV), 0, 1)
    local fill = N("Frame",{
        Size=u2s(ratio0,0,1,0),
        BackgroundColor3=C.accent, BorderSizePixel=0, ZIndex=10004,
    }, track)
    N("UICorner",{CornerRadius=UDim.new(0.5,0)}, fill)

    local knob = N("Frame",{
        Size=u2(10,10), Position=u2s(ratio0,-5,0.5,-5),
        BackgroundColor3=C.white, BorderSizePixel=0, ZIndex=10005,
    }, track)
    N("UICorner",{CornerRadius=UDim.new(0.5,0)}, knob)

    local dragging = false
    local hitBtn = N("TextButton",{
        Text="", BackgroundTransparency=1,
        Size=u2s(1,0,1,20), Position=u2(0,-8),
        ZIndex=10006, AutoButtonColor=false, Active=true,
    }, track)

    hitBtn.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging then
            local tp=track.AbsolutePosition; local tw=track.AbsoluteSize.X
            local r=math.clamp((i.Position.X-tp.X)/tw,0,1)
            local v=minV+(maxV-minV)*r
            S[key]=v
            fill.Size=u2s(r,0,1,0); knob.Position=u2s(r,-5,0.5,-5)
            lbl.Text=label.."   "..fmtVal(v)
            if onChange then onChange(v) end
        end
    end)
end

-- ===== BUILD TABS =====
local function switchTab(id)
    activeTab = id
    for tid, frame in pairs(TabFrames) do frame.Visible = (tid==id) end
    for tid, btn in pairs(TabBtns) do
        local isActive = (tid==id)
        btn.TextColor3 = isActive and C.white or C.dim
        btn.BackgroundColor3 = isActive and Color3.fromRGB(30,26,48) or C.sidebar
    end
    -- move indicator
    local idx = 0
    for i,tab in ipairs(TABS) do if tab.id==id then idx=i-1 break end end
    TabIndicator.Position = u2(0, 10+idx*36)
end

for i, tab in ipairs(TABS) do
    -- tab button
    local btn = N("TextButton",{
        Text=tab.label,
        TextColor3=C.dim,
        BackgroundColor3=C.sidebar,
        Size=u2s(1,0,0,28),
        Position=u2(0,8+(i-1)*36),
        Font=Enum.Font.Gotham,
        TextSize=12,
        BorderSizePixel=0,
        ZIndex=10002,
        AutoButtonColor=false,
        Active=true,
        TextXAlignment=Enum.TextXAlignment.Left,
    }, Sidebar)
    N("UIPadding",{PaddingLeft=px(14)}, btn)
    TabBtns[tab.id] = btn

    -- tab content frame
    local sf = makeScrollFrame(ContentArea)
    sf.Visible = false
    TabFrames[tab.id] = sf

    btn.Activated:Connect(function() switchTab(tab.id) end)
end

-- ===== AIMBOT TAB =====
do
    local t = TabFrames["aimbot"]
    addSection(t,"main",1)
    addCheckbox(t,"Aimbot Enabled",  "AimbotEnabled", 2)
    addCheckbox(t,"PSilent",         "PSilent",        3)
    addCheckbox(t,"Ignore Slipping", "IgnoreSlipping", 4)
    addCheckbox(t,"Visible Check",   "VisibleCheck",   5)
    addCheckbox(t,"Anti Recoil",     "RCS",            6)
    addSection(t,"settings",7)
    addSlider(t,"FOV",            "FOV",          30,300,"%.0f",8,  function(v) circle.Radius=v end)
    addSlider(t,"Smooth",         "Smooth",       0.05,1,"%.2f",9)
    addSlider(t,"Prediction",     "Prediction",   0,0.5,"%.3f",10)
    addSlider(t,"Hitbox Scale",   "HitboxScale",  1,6,"%.1f",  11)
    addSlider(t,"Target Delay",   "TargetLostDelay",0,1,"%.2f",12)
end

-- ===== VISUALS TAB =====
do
    local t = TabFrames["visuals"]
    addSection(t,"esp",1)
    addCheckbox(t,"ESP Boxes",    "ESPEnabled",  2)
    addCheckbox(t,"Skeleton",     "Skeleton",    3)
    addCheckbox(t,"Tracers",      "Tracers",     4)
    addCheckbox(t,"Names",        "Names",       5)
    addCheckbox(t,"FOV Circle",   "FOVCircle",   6)
    addSection(t,"environment",7)
    addCheckbox(t,"Night Vision", "NightVision", 8, function(v) nightVision.Enabled=v end)
end

-- ===== MISC TAB =====
do
    local t = TabFrames["misc"]
    addSection(t,"misc",1)
    addCheckbox(t,"Ignore Slipping","IgnoreSlipping",2)
    addCheckbox(t,"PSilent",        "PSilent",       3)
    addSection(t,"info",4)
    N("TextLabel",{
        Text="losware v2\nbuild 2025",
        TextColor3=C.dim, BackgroundTransparency=1,
        Size=u2s(1,0,0,36), LayoutOrder=5,
        Font=Enum.Font.Gotham, TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left,
        ZIndex=10003,
    }, t)
end

-- ===== AUTOFARM TAB =====
do
    local t = TabFrames["autofarm"]
    addSection(t,"autofarm",1)
    addCheckbox(t,"Auto Farm","AutoFarm",2,function(v)
        isFarming=v
        if v then task.spawn(startFarming) else afSetSpeed(origWalkSpeed,origJumpPower) end
    end)
    addSection(t,"settings",3)
    addSlider(t,"Walk Speed","AutoFarm",10,50,"%.0f",4)
end

-- ===== DRAG (заголовок) =====
local dragWin,dragStart,posStart=false,nil,nil
TitleBar.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dragWin=true; dragStart=i.Position; posStart=Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragWin and dragStart and posStart then
        local d=i.Position-dragStart
        Main.Position=UDim2.new(posStart.X.Scale,posStart.X.Offset+d.X,posStart.Y.Scale,posStart.Y.Offset+d.Y)
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragWin=false end
end)

-- ==================== TOGGLE ====================
local guiOpen    = false
local lastToggle = 0

local function toggleGui()
    local now = tick()
    if now - lastToggle < 0.4 then return end
    lastToggle = now
    guiOpen = not guiOpen
    Main.Visible = guiOpen
    OpenBtn.Text = guiOpen and "x" or "lw"
    if guiOpen and not activeTab then switchTab("aimbot") end
end

-- Только Activated — надёжно на Delta Mobile, нет дублирования
OpenBtn.Activated:Connect(toggleGui)
CloseX.Activated:Connect(toggleGui)

-- RightShift и Insert для ПК
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift or input.KeyCode == Enum.KeyCode.Insert then
        toggleGui()
    end
end)

switchTab("aimbot")
print("| losware v2 | loaded")
