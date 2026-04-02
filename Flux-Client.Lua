local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")

-- ================== НАСТРОЙКИ АИМА ==================
local FOV = 80
local Smooth = 0.25         -- Плавность наводки
local Prediction = 0.165    -- Упреждение (учитывает пинг и скорость цели)
local HeadChance = 100       -- 100% в голову

-- НОВЫЕ НАСТРОЙКИ ДЛЯ УЛУЧШЕННОГО АИМА
local HitboxScale = 3.3            -- Увеличение хитбокса в 2 раза (было 1.65)
local TargetLostDelay = 0.12       -- Задержка потери цели
local RecoilCompensation = 0.002   -- Компенсация отдачи

-- ================== NIGHT VISION (СБАЛАНСИРОВАННЫЙ) ==================
local nightVision = Instance.new("ColorCorrectionEffect")
nightVision.Name = "NV"
nightVision.Parent = Lighting

nightVision.Brightness = 0.08
nightVision.Contrast = 0.2
nightVision.Saturation = -0.35
nightVision.TintColor = Color3.fromRGB(170, 200, 230)

Lighting.Brightness = 2
Lighting.Ambient = Color3.fromRGB(110, 120, 130)
Lighting.OutdoorAmbient = Color3.fromRGB(120, 130, 140)
Lighting.FogEnd = 100000

local nvEnabled = true

UserInputService.InputBegan:Connect(function(input, gpe)
if gpe then return end
if input.KeyCode == Enum.KeyCode.N then
nvEnabled = not nvEnabled
nightVision.Enabled = nvEnabled
end
end)

-- ================== ОТРИСОВКА UI ==================
local circle = Drawing.new("Circle")
circle.Radius = FOV
circle.Thickness = 2
circle.Color = Color3.fromRGB(255,255,255)
circle.Transparency = 1
circle.Filled = false
circle.Visible = true

local glowCircles = {}
for i = 1,8 do
local g = Drawing.new("Circle")
g.Radius = FOV
g.Thickness = 1
g.Color = Color3.fromRGB(255,255,255)
g.Transparency = 0.12
g.Filled = false
g.Visible = true
table.insert(glowCircles, g)
end

local countText = Drawing.new("Text")
countText.Size = 36
countText.Color = Color3.fromRGB(255,0,0)
countText.Center = true
countText.Outline = true
countText.OutlineColor = Color3.fromRGB(0,0,0)
countText.Visible = true

-- НОВЫЙ ТАРГЕТ ИЗ ПЕРВОГО КОДА (ВРАЩАЮЩИЙСЯ КВАДРАТ - БЕЛЫЙ)
local targetLines = {}
for i = 1, 4 do
    local l = Drawing.new("Line")
    l.Thickness = 2
    l.Color = Color3.fromRGB(255, 255, 255)  -- Белый цвет
    l.Visible = false
    table.insert(targetLines, l)
end

local guideLine = Drawing.new("Line")
guideLine.Thickness = 1
guideLine.Color = Color3.fromRGB(255,255,255)
guideLine.Visible = false

-- ================== ESP & SKELETON ==================
local ESP = {}
local TracersTop = {}
local TracersCenter = {}
local Skeleton = {}
local Names = {}

local function newLine()
local l = Drawing.new("Line")
l.Color = Color3.fromRGB(255,255,255)
l.Thickness = 1
return l
end

local function createPlayer(player)
local box = Drawing.new("Square")
box.Color = Color3.fromRGB(255,255,255)
box.Thickness = 1
box.Filled = false

local t1 = Drawing.new("Line")  
t1.Color = Color3.fromRGB(255,0,0)  
t1.Thickness = 1  

local t2 = Drawing.new("Line")  
t2.Color = Color3.fromRGB(255,0,0)  
t2.Thickness = 1  

Skeleton[player] = {  
    headTorso = newLine(),  
    leftArm = newLine(),  
    rightArm = newLine(),  
    leftLeg = newLine(),  
    rightLeg = newLine()  
}  

local name = Drawing.new("Text")  
name.Size = 13  
name.Center = true  
name.Outline = true  
name.Color = Color3.fromRGB(255,255,255)  

Names[player] = name  
ESP[player] = box  
TracersTop[player] = t1  
TracersCenter[player] = t2

end

-- Инициализация
for _,p in pairs(Players:GetPlayers()) do
if p ~= LocalPlayer then createPlayer(p) end
end

Players.PlayerAdded:Connect(function(p)
if p ~= LocalPlayer then createPlayer(p) end
end)

Players.PlayerRemoving:Connect(function(p)
if ESP[p] then ESP[p]:Remove() end
if TracersTop[p] then TracersTop[p]:Remove() end
if TracersCenter[p] then TracersCenter[p]:Remove() end
if Names[p] then Names[p]:Remove() end
if Skeleton[p] then
for _,l in pairs(Skeleton[p]) do l:Remove() end
end
end)

-- УЛУЧШЕННАЯ ПРОВЕРКА ВИДИМОСТИ С УВЕЛИЧЕННЫМ ХИТБОКСОМ
local function isVisibleWithBigHitbox(part, character)
local origin = Camera.CFrame.Position
local direction = part.Position - origin
local params = RaycastParams.new()
params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
params.FilterType = Enum.RaycastFilterType.Blacklist

-- Проверяем несколько точек для увеличенной зоны попадания
local hitboxOffset = part.Size.Magnitude * (HitboxScale - 1) / 2
local checkPoints = {
    part.Position,
    part.Position + Vector3.new(hitboxOffset, hitboxOffset, 0),
    part.Position + Vector3.new(-hitboxOffset, hitboxOffset, 0),
    part.Position + Vector3.new(hitboxOffset, -hitboxOffset, 0),
    part.Position + Vector3.new(-hitboxOffset, -hitboxOffset, 0)
}

for _, checkPos in pairs(checkPoints) do
    direction = checkPos - origin
    local result = workspace:Raycast(origin, direction, params)
    if result then
        if result.Instance:IsDescendantOf(character) then
            return true
        end
    else
        return true
    end
end
return false
end

local function w2s(part)
local p = Camera:WorldToViewportPoint(part.Position)
return Vector2.new(p.X,p.Y)
end

-- ПЕРЕМЕННЫЕ ДЛЯ УДЕРЖАНИЯ ЦЕЛИ
local currentTarget = nil
local lastTargetTime = 0

-- ФУНКЦИЯ УВЕЛИЧЕНИЯ ХИТБОКСА (визуально не меняется)
local function enlargeHitboxes()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    local originalSize = part.Size
                    part.Size = originalSize * HitboxScale
                    task.wait(0.05)
                    part.Size = originalSize
                end
            end
        end
    end
end

-- ================== ГЛАВНЫЙ ЦИКЛ ==================
RunService.RenderStepped:Connect(function()
local screenSize = Camera.ViewportSize
local center = Vector2.new(screenSize.X/2, screenSize.Y/2)
local t = tick()

circle.Position = center  
for i, g in pairs(glowCircles) do  
    local noise = math.random(-2, 3)  
    g.Radius = FOV + i * 0.8 + noise  
    g.Position = center  
    g.Transparency = 0.06 * i + math.random() * 0.03  
end  

countText.Position = center - Vector2.new(0, FOV + 45)  

local closestDist = math.huge  
local targetPos2D, targetPos3D, targetPlayer, targetDistance
local count = 0  

-- ПОИСК ЦЕЛИ
for player, box in pairs(ESP) do  
    local char = player.Character  
    local head = char and char:FindFirstChild("Head")  
    local hrp = char and char:FindFirstChild("HumanoidRootPart")  
    local hum = char and char:FindFirstChild("Humanoid")  

    if head and hrp and hum and hum.Health > 0 then      
        local pos3, onScreen = Camera:WorldToViewportPoint(head.Position)      

        if onScreen then      
            local screenPos = Vector2.new(pos3.X,pos3.Y)      
            local dist = (screenPos - center).Magnitude      

            if dist <= FOV and isVisibleWithBigHitbox(head, char) then              
                count += 1              
                
                if dist < closestDist then              
                    closestDist = dist  
                    
                    -- Сохраняем дистанцию до цели
                    targetDistance = (Camera.CFrame.Position - hrp.Position).Magnitude
                    
                    -- ВСЕГДА ЦЕЛИМСЯ В ГОЛОВУ (100%)
                    local chosenPart = head
                    
                    -- УЛУЧШЕННЫЙ ПРЕДИКШН (упреждение движения)
                    local velocity = chosenPart.Velocity or Vector3.new(0,0,0)
                    local acceleration = chosenPart.AssemblyLinearVelocity - (chosenPart.AssemblyLinearVelocity - Vector3.new(0,0,0))
                    local dist3D = (chosenPart.Position - Camera.CFrame.Position).Magnitude
                    
                    -- Динамический предикшн в зависимости от дистанции
                    local predFactor = Prediction * (1 + dist3D / 500)
                    local predPos = chosenPart.Position + (velocity * (dist3D / 800) * predFactor) + (acceleration * 0.05)
                    
                    targetPos3D = predPos
                    targetPlayer = player
                    local aim2D = Camera:WorldToViewportPoint(predPos)
                    targetPos2D = Vector2.new(aim2D.X, aim2D.Y)
                end
            end      
            
            -- Отрисовка Бокса  
            local top = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0,3,0))              
            local bottom = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))              
            local sizeY = math.abs(top.Y - bottom.Y)              
            box.Size = Vector2.new(sizeY/2, sizeY)              
            box.Position = Vector2.new(screenPos.X - box.Size.X/2, screenPos.Y - box.Size.Y/2)              
            box.Visible = true              

            -- Трейсеры сверху  
            TracersTop[player].From = Vector2.new(screenSize.X/2, 0)              
            TracersTop[player].To = screenPos              
            TracersTop[player].Visible = true              

            -- Трейсеры от центра  
            TracersCenter[player].From = center              
            TracersCenter[player].To = screenPos              
            TracersCenter[player].Visible = true              

            -- Дистанция и Имя  
            local distance = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)      
            Names[player].Text = player.Name.." ["..distance.."m]"      
            Names[player].Position = Vector2.new(screenPos.X, screenPos.Y - sizeY/2 - 10)      
            Names[player].Visible = true      

            -- Скелет (голова-торс)  
            local head2D = w2s(head)      
            local torso2D = w2s(hrp)      
            Skeleton[player].headTorso.From = head2D      
            Skeleton[player].headTorso.To = torso2D      
            Skeleton[player].headTorso.Visible = true      

            -- Дополнительные части скелета (руки/ноги)  
            local leftArm = char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm")  
            local rightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm")  
            local leftLeg = char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftLowerLeg")  
            local rightLeg = char:FindFirstChild("Right Leg") or char:FindFirstChild("RightLowerLeg")  
              
            if leftArm and rightArm then  
                local leftArm2D = w2s(leftArm)  
                local rightArm2D = w2s(rightArm)  
                Skeleton[player].leftArm.From = torso2D  
                Skeleton[player].leftArm.To = leftArm2D  
                Skeleton[player].rightArm.From = torso2D  
                Skeleton[player].rightArm.To = rightArm2D  
                Skeleton[player].leftArm.Visible = true  
                Skeleton[player].rightArm.Visible = true  
            end  
              
            if leftLeg and rightLeg then  
                local leftLeg2D = w2s(leftLeg)  
                local rightLeg2D = w2s(rightLeg)  
                Skeleton[player].leftLeg.From = torso2D  
                Skeleton[player].leftLeg.To = leftLeg2D  
                Skeleton[player].rightLeg.From = torso2D  
                Skeleton[player].rightLeg.To = rightLeg2D  
                Skeleton[player].leftLeg.Visible = true  
                Skeleton[player].rightLeg.Visible = true  
            end  
        else      
            box.Visible = false      
            TracersTop[player].Visible = false      
            TracersCenter[player].Visible = false      
            Names[player].Visible = false      
            for _,l in pairs(Skeleton[player]) do l.Visible = false end      
        end      
    else      
        box.Visible = false      
        TracersTop[player].Visible = false      
        TracersCenter[player].Visible = false      
        Names[player].Visible = false      
        for _,l in pairs(Skeleton[player]) do l.Visible = false end      
    end  
end  

countText.Text = tostring(count)  

-- УДЕРЖАНИЕ ЦЕЛИ ПРИ ПОТЕРЕ
if not targetPos2D and currentTarget and (tick() - lastTargetTime) < TargetLostDelay then
    local char = currentTarget.Character
    if char and char:FindFirstChild("Head") then
        local head = char.Head
        local velocity = head.Velocity or Vector3.new(0,0,0)
        local dist3D = (head.Position - Camera.CFrame.Position).Magnitude
        local predPos = head.Position + (velocity * (dist3D / 800) * Prediction)
        targetPos3D = predPos
        targetPos2D = Camera:WorldToViewportPoint(predPos)
        targetPos2D = Vector2.new(targetPos2D.X, targetPos2D.Y)
        targetDistance = (Camera.CFrame.Position - head.Position).Magnitude
    end
elseif targetPlayer then
    currentTarget = targetPlayer
    lastTargetTime = tick()
end

-- РИСОВАНИЕ КВАДРАТА (ВРАЩАЮЩИЙСЯ, БЕЛЫЙ, ДИНАМИЧЕСКИЙ РАЗМЕР) И НАВОДКА
if targetPos2D and targetDistance then
    -- Динамический размер квадрата: чем дальше цель, тем больше квадрат
    -- База 8px на 100 метров, максимальный размер 45px, минимальный 10px
    local baseSize = 8
    local sizeMultiplier = math.clamp(targetDistance / 100, 1, 5.5)
    local squareSize = math.clamp(baseSize * sizeMultiplier, 10, 45)
    
    local rot = t * 4
    local pts = {}
    for i = 1, 4 do
        local angle = math.rad((i-1)*90 + rot*60)
        table.insert(pts, Vector2.new(targetPos2D.X + math.cos(angle)*squareSize, targetPos2D.Y + math.sin(angle)*squareSize))
    end
    for i = 1, 4 do
        targetLines[i].From = pts[i]
        targetLines[i].To = pts[i%4+1]
        targetLines[i].Visible = true
    end
    guideLine.From = center
    guideLine.To = targetPos2D
    guideLine.Visible = true

    local camPos = Camera.CFrame.Position      
    local newLook = (targetPos3D - camPos).Unit      
    local currentLook = Camera.CFrame.LookVector      
    local lerped = currentLook:Lerp(newLook, Smooth)      

    -- Компенсация отдачи/спрея
    local recoilComp = Vector3.new(
        math.sin(tick() * 30) * RecoilCompensation,
        math.cos(tick() * 30) * RecoilCompensation / 2,
        0
    )
    
    local finalLook = (lerped + recoilComp).Unit
    Camera.CFrame = CFrame.new(camPos, camPos + finalLook)  
else
    for _,l in pairs(targetLines) do l.Visible = false end
    guideLine.Visible = false
end

end)

-- ЗАПУСК УВЕЛИЧЕНИЯ ХИТБОКСОВ
spawn(function()
    while true do
        wait(0.5)
        enlargeHitboxes()
    end
end)

-- УВЕЛИЧЕНИЕ ХИТБОКСОВ ПРИ ПОЯВЛЕНИИ ПЕРСОНАЖА
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        wait(0.2)
        for _, part in pairs(char:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local originalSize = part.Size
                part.Size = originalSize * HitboxScale
                task.wait(0.05)
                part.Size = originalSize
            end
        end
    end)
end)
