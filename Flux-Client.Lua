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
local Aimbot_Enabled = false
local WalkSpeed_Value = 40
local ESP_Connections = {}
local OriginalSizes = {}

-- Aimbot переменные
local Aimbot_Target = nil
local Aimbot_FOV = 90 -- Field of View в градусах
local Aimbot_Smoothness = 0.1 -- Плавность наведения

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

-- Aimbot функция
local function updateAimbot()
    if not Aimbot_Enabled or not player.Character then 
        Aimbot_Target = nil
        return 
    end
    
    local playerPos = camera.CFrame.Position
    local closestTarget = nil
    local closestDistance = math.huge
    local fovRad = math.rad(Aimbot_FOV)
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            local headPos = head.Position
            
            -- Проверка прямой видимости
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            raycastParams.FilterDescendantsInstances = {player.Character}
            raycastParams.IgnoreWater = true
            
            local raycastResult = workspace:Raycast(playerPos, (headPos - playerPos).Unit * 500, raycastParams)
            
            -- Проверяем, попал ли луч в цель и нет ли стен между нами
            if raycastResult and raycastResult.Instance:IsDescendantOf(plr.Character) then
                -- Рассчитываем угол между направлением камеры и целью
                local cameraDirection = camera.CFrame.LookVector
                local toTarget = (headPos - playerPos).Unit
                local angle = math.acos(cameraDirection:Dot(toTarget))
                
                -- Проверяем, находится ли цель в FOV
                if angle <= fovRad then
                    local distance = (headPos - playerPos).Magnitude
                    if distance < closestDistance then
                        closestDistance = distance
                        closestTarget = plr
                    end
                end
            end
        end
    end
    
    Aimbot_Target = closestTarget
    
    -- Если есть цель и мы нажали правую кнопку мыши, наводимся
    if Aimbot_Target and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local targetHead = Aimbot_Target.Character:FindFirstChild("Head")
        if targetHead then
            local currentCFrame = camera.CFrame
            local targetPosition = targetHead.Position + Vector3.new(0, 0, 0) -- Фиксированное положение головы
            local direction = (targetPosition - currentCFrame.Position).Unit
            
            -- Плавный поворот камеры
            local newLookVector = currentCFrame.LookVector:Lerp(direction, Aimbot_Smoothness)
            local newCFrame = CFrame.lookAt(currentCFrame.Position, currentCFrame.Position + newLookVector)
            camera.CFrame = newCFrame
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

-- Соединения для кнопок GUI
btn.MouseButton1Click:Connect(function()
    window.Visible = not window.Visible
end)

btnClose.MouseButton1Click:Connect(function()
    window.Visible = false
end)

loginButton.MouseButton1Click:Connect(function()
    if passwordBox.Text == "FluxKey123" then
        loginFrame.Visible = false
        floatBtn.Visible = true
        watermark.Visible = true
    else
        loginError.Text = "Неверный ключ!"
        task.wait(2)
        loginError.Text = ""
    end
end)

passwordBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        loginButton:MouseButton1Click()
    end
end)

-- Контейнер для модулей
local modulesFrame = new("ScrollingFrame", {
    Parent = window,
    Size = UDim2.new(1, -20, 1, -80),
    Position = UDim2.new(0, 10, 0, 80),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
})

local function createModule(name, defaultValue, callback)
    local moduleFrame = new("Frame", {
        Parent = modulesFrame,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundTransparency = 1,
    })
    
    local label = new("TextLabel", {
        Parent = moduleFrame,
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = name,
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255,255,255),
        TextXAlignment = Enum.TextXAlignment.Left,
    })
    
    local toggle = new("TextButton", {
        Parent = moduleFrame,
        Size = UDim2.new(0.25, 0, 0.7, 0),
        Position = UDim2.new(0.7, 0, 0.15, 0),
        BackgroundColor3 = defaultValue and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0),
        Text = defaultValue and "ON" or "OFF",
        Font = Enum.Font.SourceSans,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(255,255,255),
    })
    new("UICorner", {Parent = toggle, CornerRadius = UDim.new(0,6)})
    
    toggle.MouseButton1Click:Connect(function()
        local newValue = not defaultValue
        defaultValue = newValue
        toggle.BackgroundColor3 = newValue and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
        toggle.Text = newValue and "ON" or "OFF"
        callback(newValue)
    end)
    
    return moduleFrame
end

-- Создаем модули
local modules = {}
modules.ESP = createModule("ESP", ESP_Enabled, function(state)
    ESP_Enabled = state
    for plr, conn in pairs(ESP_Connections) do
        if not state then
            -- Отключаем видимость ESP
            for _, drawing in pairs(getconnections(conn)) do
                if drawing and drawing.ClassName == "Line" or drawing.ClassName == "Square" then
                    drawing.Visible = false
                end
            end
        end
    end
end)

modules.Tracer = createModule("Tracer", Tracer_Enabled, function(state)
    Tracer_Enabled = state
end)

modules.Hitbox = createModule("Hitbox Expand", Hitbox_Enabled, function(state)
    Hitbox_Enabled = state
    if state then
        expandHitboxes()
    else
        resetHitboxes()
    end
end)

modules.InfinityJump = createModule("Infinity Jump", InfinityJump_Enabled, function(state)
    InfinityJump_Enabled = state
end)

modules.Speed = createModule("Speed Hack", Speed_Enabled, function(state)
    Speed_Enabled = state
    if state then
        player.Character.Humanoid.WalkSpeed = WalkSpeed_Value
    else
        player.Character.Humanoid.WalkSpeed = 16
    end
end)

modules.Wallhack = createModule("Wallhack", Wallhack_Enabled, function(state)
    Wallhack_Enabled = state
    setWallhack(state)
end)

modules.NightVision = createModule("Night Vision", NightVision_Enabled, function(state)
    NightVision_Enabled = state
    setNightVision(state)
end)

modules.NoFall = createModule("No Fall", NoFall_Enabled, function(state)
    NoFall_Enabled = state
end)

modules.AntiKnockback = createModule("Anti Knockback", AntiKnockback_Enabled, function(state)
    AntiKnockback_Enabled = state
    antiKnockback()
end)

modules.Aimbot = createModule("Aimbot", Aimbot_Enabled, function(state)
    Aimbot_Enabled = state
end)

-- Располагаем модули
local yOffset = 0
for _, module in pairs(modules) do
    module.Position = UDim2.new(0, 0, 0, yOffset)
    yOffset = yOffset + 45
end
modulesFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)

-- Системные подключения
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

-- Основной цикл
RunService.RenderStepped:Connect(function()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        if NoFall_Enabled then
            noFall()
        end
        
        if Speed_Enabled then
            player.Character.Humanoid.WalkSpeed = WalkSpeed_Value
        end
        
        -- Обновляем Aimbot
        updateAimbot()
    end
end)

-- Функция для обновления видимости при переключении ESP
local function updateESPVisibility()
    for plr, conn in pairs(ESP_Connections) do
        if ESP_Enabled then
            -- Включаем видимость ESP
            for _, drawing in pairs(getconnections(conn)) do
                if drawing and drawing.ClassName == "Line" or drawing.ClassName == "Square" then
                    drawing.Visible = true
                end
            end
        else
            -- Отключаем видимость ESP
            for _, drawing in pairs(getconnections(conn)) do
                if drawing and drawing.ClassName == "Line" or drawing.ClassName == "Square" then
                    drawing.Visible = false
                end
            end
        end
    end
end

-- Обновляем ESP при изменении настроек
modules.ESP:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
    updateESPVisibility()
end)

print("Flux Client loaded successfully!")
