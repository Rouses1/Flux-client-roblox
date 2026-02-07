local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- Ожидаем загрузку игрока
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

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
    Name = "FluxClientGUI",
    ResetOnSpawn = false,
    Parent = playerGui,
})

-- Watermark с черно-белым переливающимся эффектом
local watermark = new("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 160, 0, 30),
    Position = UDim2.new(0, 10, 0, 10),
    BackgroundColor3 = Color3.fromRGB(0,0,0),
    BackgroundTransparency = 0.3,
})
new("UICorner", {Parent = watermark, CornerRadius = UDim.new(0,8)})

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

-- Анимация переливающегося цвета для ватермарки
coroutine.wrap(function()
    while true do
        for i = 0, 1, 0.01 do
            if watermark and watermarkText then
                local colorValue = math.sin(tick() * 5) * 0.5 + 0.5
                watermarkText.TextColor3 = Color3.new(colorValue, colorValue, colorValue)
            end
            wait(0.03)
        end
    end
end)()

-- Окно логина
local loginFrame = new("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 300, 0, 160),
    Position = UDim2.new(0.5, -150, 0.5, -80),
    BackgroundColor3 = Color3.fromRGB(0,0,0),
    BackgroundTransparency = 0.5,
    ZIndex = 20,
})
new("UICorner", {Parent = loginFrame, CornerRadius = UDim.new(0,10)})
new("UIStroke", {Parent = loginFrame, Color = Color3.fromRGB(0,0,0), Transparency = 0.6})

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
new("UICorner", {Parent = passwordBox, CornerRadius = UDim.new(0,6)})

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
    BackgroundColor3 = Color3.fromRGB(0,0,0),
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
new("UICorner", {Parent = window, CornerRadius = UDim.new(0,10)})
new("UIStroke", {Parent = window, Color = Color3.fromRGB(0,0,0), Transparency = 0.6})

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
new("UICorner", {Parent = searchContainer, CornerRadius = UDim.new(0,6)})

-- Иконка лупы
local searchIcon = new("ImageLabel", {
    Parent = searchContainer,
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(0, 5, 0.5, -10),
    BackgroundTransparency = 1,
    Image = "rbxassetid://3190669181", -- Иконка лупы
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
local SwingAnimation_Enabled = false
local WalkSpeed_Value = 40
local ESP_Connections = {}
local OriginalSizes = {}
local FastBulletsConnections = {}
local SwingAnimationConnections = {}

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

-- ESP
local function createTracer()
    local tracer = Drawing.new("Line")
    tracer.Color = Color3.new(1,1,1)
    tracer.Thickness = 1
    tracer.Transparency = 1
    return tracer
end

local function createBox()
    local box = Drawing.new("Square")
    box.Color = Color3.new(1,1,1)
    box.Thickness = 1.5
    box.Transparency = 1
    box.Filled = false
    return box
end

local function createESP(plr)
    if plr == player then return end
    local box = createBox()
    local tracer = createTracer()

    local conn
    conn = RunService.RenderStepped:Connect(function()
        local visible = false
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local head = plr.Character:FindFirstChild("Head")
            local pos, vis = camera:WorldToViewportPoint(hrp.Position)

            if vis then
                local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
                local footPos = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))
                local height = footPos.Y - headPos.Y
                local width = height / 2

                if ESP_Enabled then                  
                    box.Size = Vector2.new(width, height)                  
                    box.Position = Vector2.new(headPos.X - width/2, headPos.Y)                  
                    box.Visible = true                  
                else                  
                    box.Visible = false                  
                end                  

                if Tracer_Enabled then                  
                    tracer.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)                  
                    tracer.To = Vector2.new(pos.X, pos.Y)                  
                    tracer.Visible = true                  
                else                  
                    tracer.Visible = false                  
                end                  

                visible = true                  
            end
        end

        if not visible then
            box.Visible = false
            tracer.Visible = false
        end
    end)

    plr.AncestryChanged:Connect(function()
        box:Remove()
        tracer:Remove()
        conn:Disconnect()
        ESP_Connections[plr] = nil
    end)

    ESP_Connections[plr] = conn
end

for _,plr in ipairs(Players:GetPlayers()) do
    createESP(plr)
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
end

-- Исправленная функция Fast Bullets
local function setupFastBullets()
    -- Очищаем старые соединения
    for _, conn in pairs(FastBulletsConnections) do
        conn:Disconnect()
    end
    FastBulletsConnections = {}

    if not FastBullets_Enabled then return end

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

    -- Отслеживаем новые инструменты
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

    -- Отслеживаем существующие инструменты
    for _, tool in ipairs(player.Character:GetChildren()) do
        onChildAdded(tool)
    end

    local conn = player.Character.ChildAdded:Connect(onChildAdded)
    table.insert(FastBulletsConnections, conn)
end

-- Улучшенный Hit Effect в виде светящихся орбов
local function createHitEffect(position)
    if not HitEffect_Enabled then return end
    
    local colors = {
        Color3.fromRGB(255, 50, 50),  -- Красный
        Color3.fromRGB(50, 255, 50),  -- Зеленый
        Color3.fromRGB(50, 50, 255),  -- Синий
        Color3.fromRGB(255, 255, 50), -- Желтый
        Color3.fromRGB(255, 50, 255), -- Пурпурный
        Color3.fromRGB(50, 255, 255)  -- Голубой
    }
    
    for i = 1, 12 do
        local part = Instance.new("Part")
        part.Shape = Enum.PartType.Ball  -- Сферическая форма
        part.Size = Vector3.new(0.5, 0.5, 0.5)
        part.Position = position
        part.Anchored = true
        part.CanCollide = false
        part.Material = Enum.Material.Neon
        part.BrickColor = BrickColor.new("Institutional white")
        part.Transparency = 0.2
        
        local randomColor = colors[math.random(1, #colors)]
        part.Color = randomColor
        
        local pointLight = Instance.new("PointLight")
        pointLight.Brightness = 8
        pointLight.Range = 8
        pointLight.Color = randomColor
        pointLight.Parent = part
        
        part.Parent = workspace
        
        local direction = Vector3.new(
            math.random() * 2 - 1,
            math.random() * 0.5 + 0.5,
            math.random() * 2 - 1
        ).Unit
        
        local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local goal = {}
        goal.Position = position + direction * (math.random(5, 10))
        goal.Transparency = 1
        goal.Size = Vector3.new(0.1, 0.1, 0.1)
        
        local tween = TweenService:Create(part, tweenInfo, goal)
        tween:Play()
        
        game.Debris:AddItem(part, 1)
    end
end

-- Глобальная система Hit Effect для всех игроков
local function setupGlobalHitEffect()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            if plr.Character then
                local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.HealthChanged:Connect(function(oldHealth, newHealth)
                        if newHealth < oldHealth and HitEffect_Enabled then
                            local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                createHitEffect(rootPart.Position)
                            end
                        end
                    end)
                end
            end
            
            plr.CharacterAdded:Connect(function(character)
                task.wait(1) -- Ждем загрузки персонажа
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.HealthChanged:Connect(function(oldHealth, newHealth)
                        if newHealth < oldHealth and HitEffect_Enabled then
                            local rootPart = character:FindFirstChild("HumanoidRootPart")
                            if rootPart then
                                createHitEffect(rootPart.Position)
                            end
                        end
                    end)
                end
            end)
        end
    end
end

-- Swing Animation (плавная анимация удара как в майнкрафт)
local function setupSwingAnimation()
    -- Очищаем старые соединения
    for _, conn in pairs(SwingAnimationConnections) do
        conn:Disconnect()
    end
    SwingAnimationConnections = {}
    
    if not SwingAnimation_Enabled or not player.Character then return end
    
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    -- Функция для создания анимации удара
    local function playSwingAnimation(tool)
        if not tool:IsA("Tool") then return end
        
        local handle = tool:FindFirstChild("Handle")
        if not handle then return end
        
        -- Сохраняем оригинальную позицию
        local originalPosition = handle.Position
        local originalOrientation = handle.Orientation
        
        -- Анимация удара
        local swingTween = TweenService:Create(handle, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CFrame = handle.CFrame * CFrame.Angles(0, math.rad(90), 0) * CFrame.new(0, 0, -1)
        })
        
        local returnTween = TweenService:Create(handle, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CFrame = CFrame.new(originalPosition) * CFrame.Angles(
                math.rad(originalOrientation.X),
                math.rad(originalOrientation.Y),
                math.rad(originalOrientation.Z)
            )
        })
        
        swingTween:Play()
        swingTween.Completed:Connect(function()
            returnTween:Play()
        end)
    end
    
    -- Отслеживаем использование инструментов
    local function onToolActivated(tool)
        if SwingAnimation_Enabled then
            playSwingAnimation(tool)
        end
    end
    
    -- Подключаемся к существующим инструментам
    for _, tool in ipairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") then
            local conn = tool.Activated:Connect(function()
                onToolActivated(tool)
            end)
            table.insert(SwingAnimationConnections, conn)
        end
    end
    
    -- Отслеживаем новые инструменты
    local conn = player.Character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then
            local toolConn = child.Activated:Connect(function()
                onToolActivated(child)
            end)
            table.insert(SwingAnimationConnections, toolConn)
        end
    end)
    table.insert(SwingAnimationConnections, conn)
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


btnClose.MouseButton1Click:Connect(function()
    window.Visible = false
end)

Players.PlayerAdded:Connect(function(plr)
    createESP(plr)
    if HitEffect_Enabled then
        if plr.Character then
            local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.HealthChanged:Connect(function(oldHealth, newHealth)
                    if newHealth < oldHealth and HitEffect_Enabled then
                        local rootPart = plr.Character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            createHitEffect(rootPart.Position)
                        end
                    end
                end)
            end
        end
        
        plr.CharacterAdded:Connect(function(character)
            task.wait(1)
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.HealthChanged:Connect(function(oldHealth, newHealth)
                    if newHealth < oldHealth and HitEffect_Enabled then
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            createHitEffect(rootPart.Position)
                        end
                    end
                end)
            end
        end)
    end
    
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

-- Инициализация функций при загрузке
if player.Character then
    setupGlobalHitEffect()
    setupSwingAnimation()
else
    player.CharacterAdded:Connect(function()
        setupGlobalHitEffect()
        setupSwingAnimation()
    end)
end

-- Инициализация для существующих игроков
setupGlobalHitEffect()
