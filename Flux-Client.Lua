local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")

-- Ожидаем загрузку игрока
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera
local mouse = player:GetMouse()

-- Цветовая схема
local MAIN_COLOR = Color3.fromRGB(0, 0, 0)
local MAIN_TRANSPARENCY = 0.5
local BUTTON_COLOR = Color3.fromRGB(40, 40, 40)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)

-- Функция для создания объектов
local function new(className, props)
    local obj = Instance.new(className)
    if props then
        for k,v in pairs(props) do
            obj[k] = v
        end
    end
    return obj
end

-- Создаем основное GUI
local screenGui = new("ScreenGui", {
    Name = "FluxClientGUI_"..HttpService:GenerateGUID(false),
    ResetOnSpawn = false,
    Parent = playerGui,
})

-- Watermark
local watermark = new("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 160, 0, 30),
    Position = UDim2.new(0, 10, 0, 10),
    BackgroundColor3 = MAIN_COLOR,
    BackgroundTransparency = 0.3,
})
new("UICorner", {Parent = watermark, CornerRadius = UDim.new(0,8)})

new("TextLabel", {
    Parent = watermark,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "Flux Client",
    Font = Enum.Font.SourceSansSemibold,
    TextSize = 16,
    TextColor3 = TEXT_COLOR,
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center,
})

-- Окно логина
local loginFrame = new("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 300, 0, 160),
    Position = UDim2.new(0.5, -150, 0.5, -80),
    BackgroundColor3 = MAIN_COLOR,
    BackgroundTransparency = MAIN_TRANSPARENCY,
    ZIndex = 20,
})
new("UICorner", {Parent = loginFrame, CornerRadius = UDim.new(0,10)})
new("UIStroke", {Parent = loginFrame, Color = MAIN_COLOR, Transparency = 0.6})

new("TextLabel", {
    Parent = loginFrame,
    Position = UDim2.new(0, 12, 0, 8),
    Size = UDim2.new(1, -24, 0, 24),
    BackgroundTransparency = 1,
    Text = "Flux Client",
    Font = Enum.Font.SourceSansSemibold,
    TextSize = 18,
    TextColor3 = TEXT_COLOR,
    TextXAlignment = Enum.TextXAlignment.Center,
})

local passwordBox = new("TextBox", {
    Parent = loginFrame,
    Size = UDim2.new(0.85, 0, 0, 28),
    Position = UDim2.new(0.075, 0, 0.4, 0),
    PlaceholderText = "Введите ключ...",
    Text = "",
    Font = Enum.Font.SourceSans,
    TextSize = 16,
    TextColor3 = TEXT_COLOR,
    BackgroundColor3 = BUTTON_COLOR,
    BackgroundTransparency = 0.1,
    ClearTextOnFocus = false,
})
new("UICorner", {Parent = passwordBox, CornerRadius = UDim.new(0,6)})

local loginButton = new("TextButton", {
    Parent = loginFrame,
    Size = UDim2.new(0.5, 0, 0, 28),
    Position = UDim2.new(0.25, 0, 0.7, 0),
    BackgroundColor3 = BUTTON_COLOR,
    Text = "Войти",
    Font = Enum.Font.SourceSans,
    TextSize = 16,
    TextColor3 = TEXT_COLOR,
})
new("UICorner", {Parent = loginButton, CornerRadius = UDim.new(0,6)})

local loginError = new("TextLabel", {
    Parent = loginFrame,
    Size = UDim2.new(1, 0, 0, 20),
    Position = UDim2.new(0, 0, 0.9, 0),
    BackgroundTransparency = 1,
    Text = "",
    Font = Enum.Font.SourceSans,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255,0,0),
    TextXAlignment = Enum.TextXAlignment.Center,
})

-- Главное меню
local floatBtn = new("Frame", {
    Name = "FloatButton",
    Parent = screenGui,
    Size = UDim2.new(0, 60, 0, 60),
    Position = UDim2.new(0.02, 0, 0.5, -30),
    BackgroundColor3 = MAIN_COLOR,
    BackgroundTransparency = 0.25,
    ZIndex = 10,
    Visible = false,
})
new("UICorner", {Parent = floatBtn, CornerRadius = UDim.new(0,12)})

local btn = new("TextButton", {
    Parent = floatBtn,
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Text = "≡",
    Font = Enum.Font.SourceSansBold,
    TextSize = 28,
    TextColor3 = TEXT_COLOR,
    AutoButtonColor = false,
    ZIndex = 11,
})

local window = new("Frame", {
    Name = "MainWindow",
    Parent = screenGui,
    Size = UDim2.new(0, 520, 0, 340),
    Position = UDim2.new(0.5, -260, 0.5, -170),
    Visible = false,
    BackgroundColor3 = MAIN_COLOR,
    BackgroundTransparency = MAIN_TRANSPARENCY,
    ZIndex = 9,
})
new("UICorner", {Parent = window, CornerRadius = UDim.new(0,10)})
new("UIStroke", {Parent = window, Color = MAIN_COLOR, Transparency = 0.6})

local btnClose = new("TextButton", {
    Parent = window,
    Size = UDim2.new(0,28,0,28),
    Position = UDim2.new(1,-36,0,4),
    BackgroundTransparency = 1,
    Text = "×",
    Font = Enum.Font.SourceSansBold,
    TextSize = 18,
    TextColor3 = TEXT_COLOR,
    ZIndex = 12,
})

local searchBox = new("TextBox", {
    Parent = window,
    Size = UDim2.new(0.8, 0, 0, 28),
    Position = UDim2.new(0.1, 0, 0, 45),
    PlaceholderText = "Search...",
    Text = "",
    Font = Enum.Font.SourceSans,
    TextSize = 16,
    TextColor3 = TEXT_COLOR,
    BackgroundColor3 = BUTTON_COLOR,
    BackgroundTransparency = 0.1,
})
new("UICorner", {Parent = searchBox, CornerRadius = UDim.new(0,6)})

-- Переменные функций
local ESP_Enabled = false
local ESP_Objects_Enabled = false
local Tracer_Enabled = false
local Hitbox_Enabled = false
local InfinityJump_Enabled = false
local Speed_Enabled = false
local Wallhack_Enabled = false
local NightVision_Enabled = false
local NoFall_Enabled = false
local AntiKnockback_Enabled = false
local Spider_Enabled = false
local TriggerBot_Enabled = false
local Aimbot_Enabled = false
local SilentAim_Enabled = false
local WalkSpeed_Value = 40
local JumpPower_Value = 50
local ESP_Connections = {}
local ESP_Objects_Connections = {}
local OriginalSizes = {}

-- Функции защиты от античита
local function isPlayerAlive(plr)
    if not plr.Character then return false end
    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0
end

local function isCharacterValid(char)
    return char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head")
end

-- Night Vision
local function setNightVision(state)
    if state then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(1, 1, 1)
    else
        Lighting.Ambient = Color3.new(0, 0, 0)
        Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
        Lighting.ColorShift_Top = Color3.new(0, 0, 0)
    end
end

-- No Fall
local function noFall()
    if NoFall_Enabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            humanoid:ChangeState("Running")
        end
    end
end

-- Anti Knockback
local function antiKnockback()
    if AntiKnockback_Enabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
    end
end

-- Spider
local function spider()
    if Spider_Enabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {player.Character}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            
            local rayOrigin = player.Character.HumanoidRootPart.Position
            local rayDirection = Vector3.new(0, -5, 0)
            local raycastResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
            
            if raycastResult then
                humanoid.JumpPower = JumpPower_Value
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end

-- Trigger Bot
local function triggerBot()
    if TriggerBot_Enabled and player.Character and isPlayerAlive(player) then
        local closestPlayer, closestDistance = nil, math.huge
        
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and isPlayerAlive(plr) and isCharacterValid(plr.Character) then
                local targetRoot = plr.Character.HumanoidRootPart
                local targetHead = plr.Character.Head
                
                -- Проверяем, находится ли игрок в поле зрения
                local screenPoint = camera:WorldToViewportPoint(targetHead.Position)
                if screenPoint.Z > 0 then -- Z > 0 значит перед камерой
                    local mousePos = Vector2.new(mouse.X, mouse.Y)
                    local targetPos = Vector2.new(screenPoint.X, screenPoint.Y)
                    local distance = (mousePos - targetPos).Magnitude
                    
                    if distance < 50 and distance < closestDistance then
                        closestDistance = distance
                        closestPlayer = plr
                    end
                end
            end
        end
        
        if closestPlayer then
            mouse1click()
        end
    end
end

-- Aimbot
local function aimAt(target)
    if not target or not target:IsDescendantOf(Workspace) then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Плавное наведение
    local targetPosition = target.Position
    local camera = Workspace.CurrentCamera
    local lookAt = (targetPosition - camera.CFrame.Position).Unit
    
    -- Плавное изменение угла камеры
    local current = camera.CFrame.LookVector
    local smooth = 0.5 -- Коэффициент плавности (0-1)
    local new = current:Lerp(lookAt, smooth)
    
    -- Устанавливаем новое направление камеры
    camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + new)
end

-- Silent Aim (перенаправление пуль)
local function silentAimHook()
    if not SilentAim_Enabled or not player.Character then return end
    
    local closestPlayer, closestDistance = nil, math.huge
    local myHead = player.Character:FindFirstChild("Head")
    if not myHead then return end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and isPlayerAlive(plr) and isCharacterValid(plr.Character) then
            local targetHead = plr.Character:FindFirstChild("Head")
            if targetHead then
                local distance = (targetHead.Position - myHead.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = plr
                end
            end
        end
    end
    
    if closestPlayer and closestPlayer.Character then
        local targetHead = closestPlayer.Character:FindFirstChild("Head")
        if targetHead then
            -- Возвращаем позицию головы ближайшего игрока
            return targetHead.Position
        end
    end
    
    -- Если никого нет, возвращаем исходную позицию
    return nil
end

-- ESP для всех объектов
local function createESPObject(obj)
    if not obj:IsA("BasePart") then return end
    
    local box = Drawing.new("Square")
    box.Color = Color3.new(0, 0, 0) -- Черный цвет
    box.Thickness = 2
    box.Transparency = 1
    box.Filled = false
    box.Visible = false
    
    -- Трассировка для объектов
    local tracer = Drawing.new("Line")
    tracer.Color = Color3.new(0, 0, 0) -- Черный цвет
    tracer.Thickness = 1
    tracer.Transparency = 1
    tracer.Visible = false
    
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not obj or not obj.Parent then
            box:Remove()
            tracer:Remove()
            conn:Disconnect()
            ESP_Objects_Connections[obj] = nil
            return
        end
        
        local pos, vis = camera:WorldToViewportPoint(obj.Position)
        if vis and ESP_Objects_Enabled then
            -- Box
            box.Size = Vector2.new(20, 20)
            box.Position = Vector2.new(pos.X - 10, pos.Y - 10)
            box.Visible = true
            
            -- Tracer
            tracer.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
            tracer.To = Vector2.new(pos.X, pos.Y)
            tracer.Visible = true
        else
            box.Visible = false
            tracer.Visible = false
        end
    end)
    
    ESP_Objects_Connections[obj] = conn
    
    obj.AncestryChanged:Connect(function()
        box:Remove()
        tracer:Remove()
        conn:Disconnect()
        ESP_Objects_Connections[obj] = nil
    end)
end

-- ESP для игроков
local function createESP(plr)
    if plr == player then return end
    
    local box = Drawing.new("Square")
    box.Color = Color3.new(1,1,1) -- Белая рамка
    box.Thickness = 1.5
    box.Transparency = 1
    box.Filled = false
    
    local tracer = Drawing.new("Line")
    tracer.Color = Color3.new(1,1,1) -- Белая трассировка
    tracer.Thickness = 1
    tracer.Transparency = 1
    
    local healthBar = Drawing.new("Line")
    healthBar.Color = Color3.new(0,0,0) -- Черная полоса здоровья
    healthBar.Thickness = 2
    healthBar.Transparency = 1
    
    local nameTag = Drawing.new("Text")
    nameTag.Text = plr.Name
    nameTag.Color = Color3.new(1,1,1) -- Белый текст
    nameTag.Size = 14
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.Transparency = 1

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not plr or not plr.Parent or not plr.Character then
            box:Remove()
            tracer:Remove()
            healthBar:Remove()
            nameTag:Remove()
            conn:Disconnect()
            ESP_Connections[plr] = nil
            return
        end
        
        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        local head = plr.Character:FindFirstChild("Head")
        local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
        
        if hrp and head and humanoid then
            local pos, vis = camera:WorldToViewportPoint(hrp.Position)
            
            if vis then
                local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
                local footPos = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))
                local height = footPos.Y - headPos.Y
                local width = height / 2
                
                if ESP_Enabled then
                    -- Box
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(headPos.X - width/2, headPos.Y)
                    box.Visible = true
                    
                    -- Tracer
                    if Tracer_Enabled then
                        tracer.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                        tracer.To = Vector2.new(pos.X, pos.Y)
                        tracer.Visible = true
                    else
                        tracer.Visible = false
                    end
                    
                    -- Health bar (черная)
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local barHeight = height * healthPercent
                    healthBar.From = Vector2.new(headPos.X - width/2 - 5, headPos.Y + height - barHeight)
                    healthBar.To = Vector2.new(headPos.X - width/2 - 5, headPos.Y + height)
                    healthBar.Visible = true
                    
                    -- Name tag (белый)
                    nameTag.Position = Vector2.new(headPos.X, headPos.Y - 20)
                    nameTag.Visible = true
                else
                    box.Visible = false
                    tracer.Visible = false
                    healthBar.Visible = false
                    nameTag.Visible = false
                end
            else
                box.Visible = false
                tracer.Visible = false
                healthBar.Visible = false
                nameTag.Visible = false
            end
        else
            box.Visible = false
            tracer.Visible = false
            healthBar.Visible = false
            nameTag.Visible = false
        end
    end)
    
    plr.AncestryChanged:Connect(function()
        box:Remove()
        tracer:Remove()
        healthBar:Remove()
        nameTag:Remove()
        conn:Disconnect()
        ESP_Connections[plr] = nil
    end)
    
    ESP_Connections[plr] = conn
end

-- Инициализация ESP для всех игроков
for _,plr in ipairs(Players:GetPlayers()) do
    createESP(plr)
end

-- Инициализация ESP для всех объектов
if ESP_Objects_Enabled then
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character) then
            createESPObject(obj)
        end
    end
end

-- Hitbox Expand
local function expandHitboxes()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local head = plr.Character:FindFirstChild("Head")
            if hrp and head then
                if not OriginalSizes[plr] then
                    OriginalSizes[plr] = {
                        HRP_Size = hrp.Size,
                        HRP_CanCollide = hrp.CanCollide,
                        Head_Size = head.Size,
                        Head_CanCollide = head.CanCollide
                    }
                end
                hrp.Size = OriginalSizes[plr].HRP_Size * 3
                hrp.CanCollide = false
                head.Size = OriginalSizes[plr].Head_Size * 10
                head.CanCollide = false
            end
        end
    end
end

local function resetHitboxes()
    for plr, sizes in pairs(OriginalSizes) do
        if plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local head = plr.Character:FindFirstChild("Head")
            if hrp and head then
                hrp.Size = sizes.HRP_Size
                hrp.CanCollide = sizes.HRP_CanCollide
                head.Size = sizes.Head_Size
                head.CanCollide = sizes.Head_CanCollide
            end
        end
    end
    OriginalSizes = {}
end

-- Wallhack
local function setWallhack(state)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character) then
            if state then
                obj.LocalTransparencyModifier = 0.5
                obj.CanCollide = false
            else
                obj.LocalTransparencyModifier = 0
                obj.CanCollide = true
            end
        end
    end
end

-- Infinity Jump
UserInputService.JumpRequest:Connect(function()
    if InfinityJump_Enabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            task.wait(0.1)
        end
    end
end)

-- Speed Hack
RunService.Heartbeat:Connect(function()
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if Speed_Enabled then
                humanoid.WalkSpeed = WalkSpeed_Value
            elseif humanoid.WalkSpeed ~= 16 then
                humanoid.WalkSpeed = 16
            end
        end
    end
    
    -- Run other checks
    noFall()
    antiKnockback()
    spider()
    triggerBot()
    
    -- Aimbot
    if Aimbot_Enabled and player.Character and isPlayerAlive(player) then
        local closestPlayer, closestDistance = nil, math.huge
        local myHead = player.Character:FindFirstChild("Head")
        
        if myHead then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and isPlayerAlive(plr) and isCharacterValid(plr.Character) then
                    local targetHead = plr.Character:FindFirstChild("Head")
                    if targetHead then
                        local distance = (targetHead.Position - myHead.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = plr
                        end
                    end
                end
            end
            
            if closestPlayer and closestPlayer.Character then
                local targetHead = closestPlayer.Character:FindFirstChild("Head")
                if targetHead then
                    aimAt(targetHead)
                end
            end
        end
    end
end)

-- UI Кнопки
local btnWidth = 0.4
local btnHeight = 28
local btnSpacingY = 30
local buttons = {}

local function createToggleButton(name, positionX, positionY, callback)
    local button = new("TextButton", {
        Parent = window,
        Size = UDim2.new(btnWidth, 0, 0, btnHeight),
        Position = UDim2.new(positionX, 0, 0, positionY),
        BackgroundColor3 = BUTTON_COLOR,
        BackgroundTransparency = 0,
        Text = name,
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = TEXT_COLOR,
        Name = name,
    })
    new("UICorner", {Parent = button, CornerRadius = UDim.new(0,6)})
    button.MouseButton1Click:Connect(function()
        local state = callback()
        if state then
            button.BackgroundColor3 = Color3.fromRGB(255,255,255)
            button.BackgroundTransparency = 0.7
        else
            button.BackgroundColor3 = BUTTON_COLOR
            button.BackgroundTransparency = 0
        end
    end)
    table.insert(buttons, button)
    return button
end

-- Создаем кнопки в алфавитном порядке
local currentY = 85

-- Aimbot
createToggleButton("Aimbot", 0.05, currentY, function()
    Aimbot_Enabled = not Aimbot_Enabled
    return Aimbot_Enabled
end)

-- Anti Knockback
createToggleButton("Anti Knockback", 0.55, currentY, function()
    AntiKnockback_Enabled = not AntiKnockback_Enabled
    return AntiKnockback_Enabled
end)

currentY = currentY + btnSpacingY

-- ESP
createToggleButton("ESP", 0.05, currentY, function()
    ESP_Enabled = not ESP_Enabled
    return ESP_Enabled
end)

-- ESP Objects
createToggleButton("ESP Objects", 0.55, currentY, function()
    ESP_Objects_Enabled = not ESP_Objects_Enabled
    if ESP_Objects_Enabled then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character) then
                createESPObject(obj)
            end
        end
    else
        for obj, conn in pairs(ESP_Objects_Connections) do
            conn:Disconnect()
            ESP_Objects_Connections[obj] = nil
        end
    end
    return ESP_Objects_Enabled
end)

currentY = currentY + btnSpacingY

-- Hitbox
createToggleButton("Hitbox", 0.05, currentY, function()
    Hitbox_Enabled = not Hitbox_Enabled
    if Hitbox_Enabled then
        expandHitboxes()
    else
        resetHitboxes()
    end
    return Hitbox_Enabled
end)

-- Infinity Jump
createToggleButton("Infinity Jump", 0.55, currentY, function()
    InfinityJump_Enabled = not InfinityJump_Enabled
    return InfinityJump_Enabled
end)

currentY = currentY + btnSpacingY

-- Night Vision
createToggleButton("Night Vision", 0.05, currentY, function()
    NightVision_Enabled = not NightVision_Enabled
    setNightVision(NightVision_Enabled)
    return NightVision_Enabled
end)

-- No Fall
createToggleButton("No Fall", 0.55, currentY, function()
    NoFall_Enabled = not NoFall_Enabled
    return NoFall_Enabled
end)

currentY = currentY + btnSpacingY

-- Silent Aim
createToggleButton("Silent Aim", 0.05, currentY, function()
    SilentAim_Enabled = not SilentAim_Enabled
    return SilentAim_Enabled
end)

-- Speed
createToggleButton("Speed", 0.55, currentY, function()
    Speed_Enabled = not Speed_Enabled
    return Speed_Enabled
end)

currentY = currentY + btnSpacingY

-- Spider
createToggleButton("Spider", 0.05, currentY, function()
    Spider_Enabled = not Spider_Enabled
    return Spider_Enabled
end)

-- Tracer
createToggleButton("Tracer", 0.55, currentY, function()
    Tracer_Enabled = not Tracer_Enabled
    return Tracer_Enabled
end)

currentY = currentY + btnSpacingY

-- Trigger Bot
createToggleButton("Trigger Bot", 0.05, currentY, function()
    TriggerBot_Enabled = not TriggerBot_Enabled
    return TriggerBot_Enabled
end)

-- Wallhack
createToggleButton("Wallhack", 0.55, currentY, function()
    Wallhack_Enabled = not Wallhack_Enabled
    setWallhack(Wallhack_Enabled)
    return Wallhack_Enabled
end)

-- Player List
local playerListFrame = new("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 150, 0, 180),
    Position = UDim2.new(1, -160, 0, 10),
    BackgroundColor3 = MAIN_COLOR,
    BackgroundTransparency = 0.4,
})
new("UICorner", {Parent = playerListFrame, CornerRadius = UDim.new(0,6)})

local titleLabel = new("TextLabel", {
    Parent = playerListFrame,
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "Players",
    Font = Enum.Font.SourceSansBold,
    TextSize = 16,
    TextColor3 = TEXT_COLOR,
    TextXAlignment = Enum.TextXAlignment.Center,
})

local playerListScrolling = new("ScrollingFrame", {
    Parent = playerListFrame,
    Size = UDim2.new(1, -10, 1, -30),
    Position = UDim2.new(0, 5, 0, 25),
    BackgroundTransparency = 1,
    ScrollBarThickness = 4,
    CanvasSize = UDim2.new(0, 0, 0, 0),
})

local playerListLayout = new("UIListLayout", {
    Parent = playerListScrolling,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 2),
})

local function updatePlayerList()
    for _, child in ipairs(playerListScrolling:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    local totalHeight = 0
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and 
           player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            local playerEntry = new("TextLabel", {
                Parent = playerListScrolling,
                Size = UDim2.new(1, 0, 0, 16),
                BackgroundTransparency = 1,
                Text = plr.Name .. string.format(" [%.0f]", dist),
                Font = Enum.Font.SourceSans,
                TextSize = 12,
                TextColor3 = TEXT_COLOR,
                TextXAlignment = Enum.TextXAlignment.Center,
            })
            totalHeight = totalHeight + 18
        end
    end
    
    playerListScrolling.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Поиск по функциям
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local searchText = string.lower(searchBox.Text)
    
    for _, button in ipairs(buttons) do
        local buttonText = string.lower(button.Text)
        if string.find(buttonText, searchText) then
            button.Visible = true
        else
            button.Visible = searchText == ""
        end
    end
end)

-- Hook для Silent Aim
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    
    if SilentAim_Enabled and not checkcaller() then
        if method == "FindPartOnRayWithIgnoreList" or method == "FindPartOnRay" then
            local targetPos = silentAimHook()
            if targetPos then
                local args = {...}
                local ray = args[1]
                
                if typeof(ray) == "Ray" then
                    -- Меняем направление луча на голову ближайшего игрока
                    local newRay = Ray.new(ray.Origin, (targetPos - ray.Origin).Unit * ray.Direction.Magnitude)
                    args[1] = newRay
                    return oldNamecall(self, unpack(args))
                end
            end
        end
    end
    
    return oldNamecall(self, ...)
end)

RunService.Heartbeat:Connect(function()
    updatePlayerList()
end)

-- Логика входа
local CORRECT_PASSWORD = "FJAL-IIAL-10LL"

loginButton.MouseButton1Click:Connect(function()
    if passwordBox.Text == CORRECT_PASSWORD then
        floatBtn.Visible = true
        loginFrame.Visible = false
        loginError.Text = ""
    else
        loginError.Text = "Неверный пароль!"
    end
end)

btn.MouseButton1Click:Connect(function()
    window.Visible = not window.Visible
end)

btnClose.MouseButton1Click:Connect(function()
    window.Visible = false
end)

Players.PlayerAdded:Connect(function(plr)
    createESP(plr)
    plr.CharacterAdded:Connect(function()
        if Hitbox_Enabled then
            task.wait(1)
            expandHitboxes()
        end
        if Wallhack_Enabled then
            task.wait(1)
            setWallhack(true)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(plr)
    if ESP_Connections[plr] then
        ESP_Connections[plr]:Disconnect()
        ESP_Connections[plr] = nil
    end
end)

Workspace.DescendantAdded:Connect(function(obj)
    if ESP_Objects_Enabled and obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character) then
        createESPObject(obj)
    end
end)
