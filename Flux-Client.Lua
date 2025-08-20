local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- Безопасная загрузка
local success, player = pcall(function()
    return Players.LocalPlayer
end)
if not success then return end

local success, playerGui = pcall(function()
    return player:WaitForChild("PlayerGui")
end)
if not success then return end

local camera = workspace.CurrentCamera

-- Безопасная функция создания объектов
local function new(className, props)
    local success, obj = pcall(function()
        local instance = Instance.new(className)
        if props then
            for k, v in pairs(props) do
                pcall(function() instance[k] = v end)
            end
        end
        return instance
    end)
    return success and obj or nil
end

-- Создаем основное GUI
local screenGui = new("ScreenGui", {
    Name = "FluxClientGUI",
    ResetOnSpawn = false,
    Parent = playerGui,
})

if not screenGui then return end

-- Notification System
local notificationQueue = {}
local isShowingNotification = false

local function showNotification(message, duration)
    table.insert(notificationQueue, {
        Message = message,
        Duration = duration or 3
    })
    
    if not isShowingNotification then
        processNextNotification()
    end
end

local function processNextNotification()
    if #notificationQueue == 0 then
        isShowingNotification = false
        return
    end
    
    isShowingNotification = true
    local notification = table.remove(notificationQueue, 1)
    
    -- Создаем контейнер для уведомления
    local notificationFrame = new("Frame", {
        Parent = screenGui,
        Size = UDim2.new(0, 300, 0, 40),
        Position = UDim2.new(0.5, -150, 1, -60),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ZIndex = 50
    })
    
    if not notificationFrame then
        isShowingNotification = false
        return processNextNotification()
    end
    
    new("UICorner", {Parent = notificationFrame, CornerRadius = UDim.new(0, 8)})
    new("UIStroke", {
        Parent = notificationFrame,
        Color = Color3.fromRGB(100, 100, 100),
        Thickness = 1
    })
    
    -- Текст уведомления
    local textLabel = new("TextLabel", {
        Parent = notificationFrame,
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = message,
        Font = Enum.Font.SourceSansSemibold,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 51
    })
    
    -- Прогресс бар
    local progressBar = new("Frame", {
        Parent = notificationFrame,
        Size = UDim2.new(0, 0, 0, 3),
        Position = UDim2.new(0, 0, 1, -3),
        BackgroundColor3 = Color3.fromRGB(0, 170, 255),
        BorderSizePixel = 0,
        ZIndex = 52
    })
    
    -- Анимация появления
    local appearTween = TweenService:Create(
        notificationFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -150, 1, -100)}
    )
    appearTween:Play()
    
    -- Анимация прогресс бара
    local progressTween = TweenService:Create(
        progressBar,
        TweenInfo.new(notification.Duration, Enum.EasingStyle.Linear),
        {Size = UDim2.new(1, 0, 0, 3)}
    )
    
    progressTween:Play()
    
    -- Таймер для скрытия
    delay(notification.Duration, function()
        local disappearTween = TweenService:Create(
            notificationFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Position = UDim2.new(0.5, -150, 1, -60), BackgroundTransparency = 1}
        )
        
        disappearTween:Play()
        disappearTween.Completed:Connect(function()
            pcall(function()
                notificationFrame:Destroy()
            end)
            isShowingNotification = false
            processNextNotification()
        end)
    end)
end

-- Watermark
local watermark = new("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 160, 0, 30),
    Position = UDim2.new(0, 10, 0, 10),
    BackgroundColor3 = Color3.fromRGB(0,0,0),
    BackgroundTransparency = 0.3,
})
if watermark then
    new("UICorner", {Parent = watermark, CornerRadius = UDim.new(0,8)})
end

local watermarkText = new("TextLabel", {
    Parent = watermark,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "Flux Client",
    Font = Enum.Font.SourceSansSemibold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(255,255,255),
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center,
})

-- Анимация ватермарки
if watermarkText then
    coroutine.wrap(function()
        while task.wait(0.03) and watermarkText do
            local colorValue = math.sin(tick() * 5) * 0.5 + 0.5
            watermarkText.TextColor3 = Color3.new(colorValue, colorValue, colorValue)
        end
    end)()
end

-- Окно логина
local loginFrame = new("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 300, 0, 160),
    Position = UDim2.new(0.5, -150, 0.5, -80),
    BackgroundColor3 = Color3.fromRGB(0,0,0),
    BackgroundTransparency = 0.5,
    ZIndex = 20,
})
if loginFrame then
    new("UICorner", {Parent = loginFrame, CornerRadius = UDim.new(0,10)})
end

new("TextLabel", {
    Parent = loginFrame,
    Position = UDim2.new(0, 12, 0, 8),
    Size = UDim2.new(1, -24, 0, 24),
    BackgroundTransparency = 1,
    Text = "Flux Client",
    Font = Enum.Font.SourceSansSemibold,
    TextSize = 18,
    TextColor3 = Color3.fromRGB(255,255,255),
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
    TextColor3 = Color3.fromRGB(255,255,255),
    BackgroundColor3 = Color3.fromRGB(40,40,40),
    BackgroundTransparency = 0.1,
    ClearTextOnFocus = false,
})
if passwordBox then
    new("UICorner", {Parent = passwordBox, CornerRadius = UDim.new(0,6)})
end

local loginButton = new("TextButton", {
    Parent = loginFrame,
    Size = UDim2.new(0.5, 0, 0, 28),
    Position = UDim2.new(0.25, 0, 0.7, 0),
    BackgroundColor3 = Color3.fromRGB(40,40,40),
    Text = "Войти",
    Font = Enum.Font.SourceSans,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(255,255,255),
})
if loginButton then
    new("UICorner", {Parent = loginButton, CornerRadius = UDim.new(0,6)})
end

new("TextLabel", {
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
    BackgroundColor3 = Color3.fromRGB(0,0,0),
    BackgroundTransparency = 0.25,
    ZIndex = 10,
    Visible = false,
})
if floatBtn then
    new("UICorner", {Parent = floatBtn, CornerRadius = UDim.new(0,12)})
end

local btn = new("TextButton", {
    Parent = floatBtn,
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1,
    Text = "≡",
    Font = Enum.Font.SourceSansBold,
    TextSize = 28,
    TextColor3 = Color3.fromRGB(255,255,255),
    AutoButtonColor = false,
    ZIndex = 11,
})

local window = new("Frame", {
    Name = "MainWindow",
    Parent = screenGui,
    Size = UDim2.new(0, 520, 0, 340),
    Position = UDim2.new(0.5, -260, 0.5, -170),
    Visible = false,
    BackgroundColor3 = Color3.fromRGB(0,0,0),
    BackgroundTransparency = 0.5,
    ZIndex = 9,
})
if window then
    new("UICorner", {Parent = window, CornerRadius = UDim.new(0,10)})
end

local btnClose = new("TextButton", {
    Parent = window,
    Size = UDim2.new(0,28,0,28),
    Position = UDim2.new(1,-36,0,4),
    BackgroundTransparency = 1,
    Text = "×",
    Font = Enum.Font.SourceSansBold,
    TextSize = 18,
    TextColor3 = Color3.fromRGB(255,255,255),
    ZIndex = 12,
})

-- Поисковая строка с иконкой лупы
local searchContainer = new("Frame", {
    Parent = window,
    Size = UDim2.new(0.8, 0, 0, 28),
    Position = UDim2.new(0.1, 0, 0, 45),
    BackgroundColor3 = Color3.fromRGB(40,40,40),
    BackgroundTransparency = 0.1,
})
if searchContainer then
    new("UICorner", {Parent = searchContainer, CornerRadius = UDim.new(0,6)})
end

-- Иконка лупы (безопасная загрузка)
local searchIcon = new("ImageLabel", {
    Parent = searchContainer,
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(0, 5, 0.5, -10),
    BackgroundTransparency = 1,
    Image = "rbxassetid://3190669181",
    ImageColor3 = Color3.fromRGB(200,200,200),
})

local searchBox = new("TextBox", {
    Parent = searchContainer,
    Size = UDim2.new(1, -30, 1, 0),
    Position = UDim2.new(0, 30, 0, 0),
    PlaceholderText = "Search...",
    Text = "",
    Font = Enum.Font.SourceSans,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(255,255,255),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
})

-- Переменные функций
local ESP_Enabled = false
local Tracer_Enabled = false
local Hitbox_Enabled = false
local InfinityJump_Enabled = false
local Speed_Enabled = false
local Wallhack_Enabled = false
local NightVision_Enabled = false
local NoFall_Enabled = false
local AntiKnockback_Enabled = false
local FastBullets_Enabled = false
local HitEffect_Enabled = false
local WalkSpeed_Value = 40
local ESP_Connections = {}
local OriginalSizes = {}
local FastBulletsConnections = {}

-- Night Vision
local function setNightVision(state)
    pcall(function()
        if state then
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
            Lighting.ColorShift_Top = Color3.new(1, 1, 1)
            showNotification("Night Vision: ON", 2)
        else
            Lighting.Ambient = Color3.new(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
            showNotification("Night Vision: OFF", 2)
        end
    end)
end

-- No Fall
local function noFall()
    if NoFall_Enabled and player.Character then
        pcall(function()
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end
end

-- Anti Knockback
local function antiKnockback()
    if AntiKnockback_Enabled and player.Character then
        pcall(function()
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            end
        end)
    end
end

-- Hitbox Expand
local function expandHitboxes()
    pcall(function()
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
    end)
end

local function resetHitboxes()
    pcall(function()
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
    end)
end

-- Wallhack
local function setWallhack(state)
    pcall(function()
        for _, obj in ipairs(workspace:GetDescendants()) do
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
        if state then
            showNotification("Wallhack: ON", 2)
        else
            showNotification("Wallhack: OFF", 2)
        end
    end)
end

-- Fast Bullets (безопасная версия)
local function setupFastBullets()
    pcall(function()
        for _, conn in pairs(FastBulletsConnections) do
            pcall(function() conn:Disconnect() end)
        end
        FastBulletsConnections = {}

        if not FastBullets_Enabled or not player.Character then return end

        local function modifyProjectile(projectile)
            if projectile:IsA("BasePart") then
                local bodyVelocity = projectile:FindFirstChildOfClass("BodyVelocity")
                if bodyVelocity then
                    bodyVelocity.Velocity = bodyVelocity.Velocity * 2
                else
                    projectile.Velocity = projectile.Velocity * 2
                end
            end
        end

        local function onChildAdded(child)
            if child:IsA("Tool") then
                local conn = child.ChildAdded:Connect(function(projectile)
                    if FastBullets_Enabled then
                        modifyProjectile(projectile)
                    end
                end)
                table.insert(FastBulletsConnections, conn)
            end
        end

        for _, tool in ipairs(player.Character:GetChildren()) do
            onChildAdded(tool)
        end

        local conn = player.Character.ChildAdded:Connect(onChildAdded)
        table.insert(FastBulletsConnections, conn)
    end)
end

-- Hit Effect функция
local function createHitEffect(position)
    if not HitEffect_Enabled then return end
    
    pcall(function()
        for i = 1, 8 do
            local part = Instance.new("Part")
            part.Size = Vector3.new(0.2, 0.2, 0.2)
            part.Position = position
            part.Anchored = true
            part.CanCollide = false
            part.Material = Enum.Material.Neon
            part.BrickColor = BrickColor.new("Institutional white")
            part.Transparency = 0.3
            
            local pointLight = Instance.new("PointLight")
            pointLight.Brightness = 5
            pointLight.Range = 5
            pointLight.Color = Color3.new(1, 1, 1)
            pointLight.Parent = part
            
            part.Parent = workspace
            
            local direction = Vector3.new(
                math.random() * 2 - 1,
                math.random() * 0.5 + 0.5,
                math.random() * 2 - 1
            ).Unit
            
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local goal = {}
            goal.Position = position + direction * 5
            goal.Transparency = 1
            
            local tween = TweenService:Create(part, tweenInfo, goal)
            tween:Play()
            
            game.Debris:AddItem(part, 0.6)
        end
    end)
end

-- Обработка получения урона
local function setupHitEffect()
    pcall(function()
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.HealthChanged:Connect(function()
                    if humanoid.Health < humanoid.MaxHealth then
                        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            createHitEffect(rootPart.Position)
                        end
                    end
                end)
            end
        end
    end)
end

-- Infinity Jump (безопасная версия)
local lastJumpTime = 0
UserInputService.JumpRequest:Connect(function()
    pcall(function()
        if InfinityJump_Enabled and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
                if tick() - lastJumpTime > 0.1 then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    lastJumpTime = tick()
                end
            end
        end
    end)
end)

-- Speed Hack
RunService.Heartbeat:Connect(function()
    pcall(function()
        if Speed_Enabled and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = WalkSpeed_Value
            end
        elseif player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.WalkSpeed ~= 16 then
                humanoid.WalkSpeed = 16
            end
        end
        
        noFall()
        antiKnockback()
    end)
end)

-- UI Кнопки
local btnWidth = 0.4
local btnHeight = 28
local btnSpacingY = 30

local function createToggleButton(name, positionX, positionY, callback)
    local button = new("TextButton", {
        Parent = window,
        Size = UDim2.new(btnWidth, 0, 0, btnHeight),
        Position = UDim2.new(positionX, 0, 0, positionY),
        BackgroundColor3 = Color3.fromRGB(40,40,40),
        BackgroundTransparency = 0,
        Text = name,
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255,255,255),
    })
    if button then
        new("UICorner", {Parent = button, CornerRadius = UDim.new(0,6)})
        button.MouseButton1Click:Connect(function()
            pcall(function()
                local state = callback()
                if state then
                    button.BackgroundColor3 = Color3.fromRGB(255,255,255)
                    button.BackgroundTransparency = 0.7
                    showNotification(name .. ": ON", 2)
                else
                    button.BackgroundColor3 = Color3.fromRGB(40,40,40)
                    button.BackgroundTransparency = 0
                    showNotification(name .. ": OFF", 2)
                end
            end)
        end)
    end
    return button
end

-- Создание кнопок
createToggleButton("ESP", 0.05, 85, function()
    ESP_Enabled = not ESP_Enabled
    return ESP_Enabled
end)

createToggleButton("Hitbox", 0.55, 85, function()
    Hitbox_Enabled = not Hitbox_Enabled
    if Hitbox_Enabled then
        expandHitboxes()
    else
        resetHitboxes()
    end
    return Hitbox_Enabled
end)

createToggleButton("Wallhack", 0.05, 115, function()
    Wallhack_Enabled = not Wallhack_Enabled
    setWallhack(Wallhack_Enabled)
    return Wallhack_Enabled
end)

createToggleButton("Tracer", 0.55, 115, function()
    Tracer_Enabled = not Tracer_Enabled
    return Tracer_Enabled
end)

createToggleButton("Infinity Jump", 0.05, 145, function()
    InfinityJump_Enabled = not InfinityJump_Enabled
    return InfinityJump_Enabled
end)

createToggleButton("Fast Bullets", 0.55, 145, function()
    FastBullets_Enabled = not FastBullets_Enabled
    if FastBullets_Enabled and player.Character then
        setupFastBullets()
    else
        for _, conn in pairs(FastBulletsConnections) do
            pcall(function() conn:Disconnect() end)
        end
        FastBulletsConnections = {}
    end
    return FastBullets_Enabled
end)

createToggleButton("Hit Effect", 0.05, 175, function()
    HitEffect_Enabled = not HitEffect_Enabled
    if HitEffect_Enabled and player.Character then
        setupHitEffect()
        showNotification("Hit Effect: ON", 2)
    else
        showNotification("Hit Effect: OFF", 2)
    end
    return HitEffect_Enabled
end)

-- Слайдер скорости
local speedSlider = new("Frame", {
    Parent = window,
    Size = UDim2.new(btnWidth, 0, 0, 20),
    Position = UDim2.new(0.55, 0, 0.55, 0),
    BackgroundColor3 = Color3.fromRGB(60,60,60),
    Visible = false,
})
if speedSlider then
    new("UICorner", {Parent = speedSlider, CornerRadius = UDim.new(0,6)})
end

local speedSliderFill = new("Frame", {
    Parent = speedSlider,
    Size = UDim2.new(0.5, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(255,255,255),
    BackgroundTransparency = 0.7,
})
if speedSliderFill then
    new("UICorner", {Parent = speedSliderFill, CornerRadius = UDim.new(0,6)})
end

local speedValueLabel = new("TextLabel", {
    Parent = speedSlider,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "Speed: "..WalkSpeed_Value,
    Font = Enum.Font.SourceSans,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255,255,255),
})

if speedSlider then
    speedSlider.InputBegan:Connect(function(input)
        pcall(function()
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local connection
                connection = RunService.Heartbeat:Connect(function()
                    local mouse = UserInputService:GetMouseLocation()
                    local sliderPos = speedSlider.AbsolutePosition
                    local sliderSize = speedSlider.AbsoluteSize
                    local relativeX = math.clamp(mouse.X - sliderPos.X, 0, sliderSize.X)
                    local percent = relativeX / sliderSize.X
                    
                    WalkSpeed_Value = math.floor(16 + (100 - 16) * percent)
                    if speedValueLabel then
                        speedValueLabel.Text = "Speed: "..WalkSpeed_Value
                    end
                    if speedSliderFill then
                        speedSliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    end
                end)
                
                local function disconnect()
                    pcall(function() connection:Disconnect() end)
                end
                
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        disconnect()
                    end
                end)
            end
        end)
    end)
end

-- Кнопка Speed
createToggleButton("Speed", 0.55, 175, function()
    Speed_Enabled = not Speed_Enabled
    if speedSlider then
        speedSlider.Visible = Speed_Enabled
    end
    if Speed_Enabled then
        showNotification("Speed: " .. WalkSpeed_Value, 2)
    else
        showNotification("Speed: OFF", 2)
    end
    return Speed_Enabled
end)

createToggleButton("Night Vision", 0.05, 205, function()
    NightVision_Enabled = not NightVision_Enabled
    setNightVision(NightVision_Enabled)
    return NightVision_Enabled
end)

createToggleButton("No Fall", 0.55, 205, function()
    NoFall_Enabled = not NoFall_Enabled
    return NoFall_Enabled
end)

createToggleButton("Anti Knockback", 0.05, 235, function()
    AntiKnockback_Enabled = not AntiKnockback_Enabled
    return AntiKnockback_Enabled
end)

-- Player List
local playerListFrame = new("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 150, 0, 180),
    Position = UDim2.new(1, -160, 0, 10),
    BackgroundColor3 = Color3.fromRGB(0,0,0),
    BackgroundTransparency = 0.4,
    Active = true,
    Draggable = true,
})
if playerListFrame then
    new("UICorner", {Parent = playerListFrame, CornerRadius = UDim.new(0,6)})
end

new("TextLabel", {
    Parent = playerListFrame,
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "Players",
    Font = Enum.Font.SourceSansBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(255,255,255),
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

new("UIListLayout", {
    Parent = playerListScrolling,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 2),
})

local function updatePlayerList()
    pcall(function()
        if not playerListScrolling then return end
        
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
                new("TextLabel", {
                    Parent = playerListScrolling,
                    Size = UDim2.new(1, 0, 0, 16),
                    BackgroundTransparency = 1,
                    Text = plr.Name .. string.format(" [%.0f]", dist),
                    Font = Enum.Font.SourceSans,
                    TextSize = 12,
                    TextColor3 = Color3.fromRGB(255,255,255),
                    TextXAlignment = Enum.TextXAlignment.Center,
                })
                totalHeight = totalHeight + 18
            end
        end
        
        playerListScrolling.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
    end)
end

RunService.Heartbeat:Connect(function()
    pcall(updatePlayerList)
end)

-- Логика входа
local CORRECT_PASSWORD = "FJAL-IIAL-10LL"

if loginButton then
    loginButton.MouseButton1Click:Connect(function()
        pcall(function()
            if passwordBox.Text == CORRECT_PASSWORD then
                if floatBtn then floatBtn.Visible = true end
                if loginFrame then loginFrame.Visible = false end
                showNotification("Успешный вход!", 3)
            else
                if loginError then loginError.Text = "Неверный пароль!" end
                showNotification("Неверный пароль!", 2)
            end
        end)
    end)
end

if btn then
    btn.MouseButton1Click:Connect(function()
        pcall(function()
            if window then window.Visible = not window.Visible end
        end)
    end)
end

if btnClose then
    btnClose.MouseButton1Click:Connect(function()
        pcall(function()
            if window then window.Visible = false end
        end)
    end)
end

-- Задержка для безопасной загрузки
task.wait(2)

-- Инициализация после загрузки
if player.Character then
    pcall(setupHitEffect)
else
    player.CharacterAdded:Connect(function()
        task.wait(1)
        pcall(setupHitEffect)
    end)
end

-- Тестовое уведомление при загрузке
showNotification("Flux Client загружен!", 3)

print("Flux Client успешно загружен!")
