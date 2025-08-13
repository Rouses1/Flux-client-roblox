local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local function new(className, props)
    local obj = Instance.new(className)
    if props then
        for k,v in pairs(props) do
            obj[k] = v
        end
    end
    return obj
end

-- === Главное GUI ===
local screenGui = new("ScreenGui", {
    Name = "FluxClientGUI",
    ResetOnSpawn = false,
    Parent = playerGui,
})

-- === Watermark ===
local watermark = new("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 160, 0, 30),
    Position = UDim2.new(0, 10, 0, 10),
    BackgroundColor3 = Color3.fromRGB(0,0,0),
    BackgroundTransparency = 0.3,
    ZIndex = 10,
})
new("UICorner", {Parent = watermark, CornerRadius = UDim.new(0,8)})

new("TextLabel", {
    Parent = watermark,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "Flux Client",
    Font = Enum.Font.SourceSansSemibold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(255,255,255),
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center,
    ZIndex = 11,
})

-- === Окно логина ===
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
    ZIndex = 21,
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
    ZIndex = 21,
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
    ZIndex = 21,
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
    ZIndex = 21,
})

-- === Главное меню ===
local floatBtn = new("Frame", {
    Name = "FloatButton",
    Parent = screenGui,
    Size = UDim2.new(0, 60, 0, 60),
    Position = UDim2.new(0.02, 0, 0.5, -30),
    BackgroundColor3 = Color3.fromRGB(0,0,0),
    BackgroundTransparency = 0.25,
    ZIndex = 15,
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
    ZIndex = 16,
})

local window = new("Frame", {
    Name = "MainWindow",
    Parent = screenGui,
    Size = UDim2.new(0, 520, 0, 340),
    Position = UDim2.new(0.5, -260, 0.5, -170),
    Visible = false,
    BackgroundColor3 = Color3.fromRGB(0,0,0),
    BackgroundTransparency = 0.5,
    ZIndex = 14,
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
    ZIndex = 17,
})

local searchBox = new("TextBox", {
    Parent = window,
    Size = UDim2.new(0.8, 0, 0, 28),
    Position = UDim2.new(0.1, 0, 0, 45),
    PlaceholderText = "Search...",
    Text = "",
    Font = Enum.Font.SourceSans,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(255,255,255),
    BackgroundColor3 = Color3.fromRGB(40,40,40),
    BackgroundTransparency = 0.1,
    ZIndex = 15,
})
new("UICorner", {Parent = searchBox, CornerRadius = UDim.new(0,6)})

-- === Переменные функций ===
local ESP_Enabled = false
local Tracer_Enabled = false
local Hitbox_Enabled = false
local InfinityJump_Enabled = false
local Speed_Enabled = false
local SpeedPlus_Enabled = false
local Wallhack_Enabled = false
local NightVision_Enabled = false
local NoFall_Enabled = false
local AntiKnockback_Enabled = false
local LongJump_Enabled = false
local ESP_Connections = {}
local OriginalSizes = {}
local BrainrotESP = {}
local HasSpeedCoilBuff = false
local OriginalWalkSpeed = 16
local LongJump_Force = 50
local LongJump_Cooldown = false

-- Цвета для редкостей Brainrot
local RARITY_COLORS = {
    Common = Color3.fromRGB(200, 200, 200),
    Uncommon = Color3.fromRGB(100, 255, 100),
    Rare = Color3.fromRGB(100, 100, 255),
    Epic = Color3.fromRGB(200, 100, 255),
    Legendary = Color3.fromRGB(255, 200, 100)
}

-- === Night Vision ===
local function setNightVision(state)
    if state then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(1, 1, 1)
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
    else
        Lighting.Ambient = Color3.new(0, 0, 0)
        Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
        Lighting.ColorShift_Top = Color3.new(0, 0, 0)
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
    end
end

-- === No Fall ===
local function noFall()
    if NoFall_Enabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            humanoid:ChangeState("Running")
        end
    end
end

-- === Anti Knockback ===
local function antiKnockback()
    if AntiKnockback_Enabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
    end
end

-- === ESP для игроков ===
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

local function createPlayerESP(plr)
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
    end)

    ESP_Connections[plr] = conn
end

-- === ESP для Brainrots ===
local function createBrainrotESP(brainrot)
    if BrainrotESP[brainrot] then return end
    
    local esp = {
        Box = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        Name = Drawing.new("Text"),
        Distance = Drawing.new("Text"),
    }
    
    -- Настройка элементов ESP
    esp.Box.Visible = false
    esp.Box.Thickness = 2
    esp.Box.Filled = false
    
    esp.Tracer.Visible = false
    esp.Tracer.Thickness = 1
    
    esp.Name.Visible = false
    esp.Name.Size = 14
    esp.Name.Outline = true
    esp.Name.Font = Enum.Font.SourceSansBold
    
    esp.Distance.Visible = false
    esp.Distance.Size = 14
    esp.Distance.Outline = true
    esp.Distance.Font = Enum.Font.SourceSans
    
    BrainrotESP[brainrot] = esp
    
    -- Определяем редкость Brainrot
    local rarity = "Common"
    if brainrot:FindFirstChild("Rarity") then
        rarity = brainrot.Rarity.Value
    end
    
    -- Устанавливаем цвет в зависимости от редкости
    local color = RARITY_COLORS[rarity] or Color3.new(1,1,1)
    esp.Box.Color = color
    esp.Tracer.Color = color
    esp.Name.Color = color
    esp.Distance.Color = color
    
    -- Обновление ESP
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if brainrot.Parent and brainrot:FindFirstChild("HumanoidRootPart") then
            local hrp = brainrot.HumanoidRootPart
            local head = brainrot:FindFirstChild("Head")
            local pos, vis = camera:WorldToViewportPoint(hrp.Position)
            
            if vis then
                local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0,0.5,0))
                local footPos = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))
                local height = footPos.Y - headPos.Y
                local width = height * 0.65
                
                -- Обновляем бокс
                esp.Box.Size = Vector2.new(width, height)
                esp.Box.Position = Vector2.new(headPos.X - width/2, headPos.Y - height/2)
                esp.Box.Visible = ESP_Enabled
                
                -- Обновляем трассер
                esp.Tracer.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                esp.Tracer.To = Vector2.new(pos.X, pos.Y)
                esp.Tracer.Visible = Tracer_Enabled and ESP_Enabled
                
                -- Обновляем имя и редкость
                esp.Name.Text = brainrot.Name .. " ("..rarity..")"
                esp.Name.Position = Vector2.new(pos.X, headPos.Y - height/2 - 20)
                esp.Name.Visible = ESP_Enabled
                
                -- Обновляем расстояние
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    esp.Distance.Text = string.format("[%d]", distance)
                    esp.Distance.Position = Vector2.new(pos.X, footPos.Y + 5)
                    esp.Distance.Visible = ESP_Enabled
                end
            else
                esp.Box.Visible = false
                esp.Tracer.Visible = false
                esp.Name.Visible = false
                esp.Distance.Visible = false
            end
        else
            -- Удаляем ESP если Brainrot больше не существует
            for _, drawing in pairs(esp) do
                drawing:Remove()
            end
            BrainrotESP[brainrot] = nil
            conn:Disconnect()
        end
    end)
end

-- Поиск Brainrots в игре
local function findBrainrots()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Brainrot" and obj:FindFirstChild("HumanoidRootPart") then
            createBrainrotESP(obj)
        end
    end
end

-- Обработчик новых Brainrots
workspace.DescendantAdded:Connect(function(obj)
    if obj.Name == "Brainrot" and obj:FindFirstChild("HumanoidRootPart") then
        createBrainrotESP(obj)
    end
end)

-- === Hitbox Expand ===
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

-- === Wallhack ===
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

-- === Infinity Jump ===
local function infinityJump()
    if InfinityJump_Enabled then
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState("Jumping")
        end
    end
end

-- === Long Jump ===
local function longJump()
    if LongJump_Enabled and player.Character and not LongJump_Cooldown then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart and humanoid:GetState() == Enum.HumanoidStateType.Jumping then
            LongJump_Cooldown = true
            
            -- Получаем направление движения
            local moveDirection = humanoid.MoveDirection
            if moveDirection.Magnitude == 0 then
                moveDirection = rootPart.CFrame.LookVector
            end
            
            -- Применяем силу для длинного прыжка
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            rootPart.Velocity = rootPart.Velocity + moveDirection * LongJump_Force + Vector3.new(0, LongJump_Force/2, 0)
            
            -- КД чтобы избежать спама
            task.wait(0.5)
            LongJump_Cooldown = false
        end
    end
end

-- === Speed Hack (обычная скорость) ===
local function updateSpeed()
    if Speed_Enabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 25
            
            if humanoid.MoveDirection.Magnitude > 0 then
                local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CFrame = rootPart.CFrame + humanoid.MoveDirection * 0.2
                end
            end
        end
    elseif player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.WalkSpeed ~= 16 then
            humanoid.WalkSpeed = 16
        end
    end
end

-- === Speed+ (работает только с катушкой скорости, но сохраняет эффект) ===
local function hasSpeedCoil()
    if not player.Character then return false end
    
    -- Проверяем инвентарь на наличие катушки скорости
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item.Name:lower():find("speed") or item.Name:lower():find("coil") then
            return true
        end
    end
    
    -- Проверяем инструменты в руках
    for _, tool in pairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("speed") or tool.Name:lower():find("coil")) then
            return true
        end
    end
    
    return false
end

local function updateSpeedPlus()
    if SpeedPlus_Enabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            -- Если у нас есть катушка - активируем буст
            if hasSpeedCoil() then
                HasSpeedCoilBuff = true
                humanoid.WalkSpeed = 35
                
                if humanoid.MoveDirection.Magnitude > 0 then
                    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        rootPart.CFrame = rootPart.CFrame + humanoid.MoveDirection * 0.3
                    end
                end
            -- Если буст уже был активирован - сохраняем скорость
            elseif HasSpeedCoilBuff then
                humanoid.WalkSpeed = 35
            else
                humanoid.WalkSpeed = OriginalWalkSpeed
            end
        end
    elseif player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = OriginalWalkSpeed
            HasSpeedCoilBuff = false
        end
    end
end

-- Обработчик прыжков
UserInputService.JumpRequest:Connect(function()
    infinityJump()
    longJump()
end)

-- Основной цикл
RunService.Heartbeat:Connect(function()
    updateSpeed()
    updateSpeedPlus()
    noFall()
    antiKnockback()
end)

-- === UI Кнопки ===
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
        ZIndex = 15,
    })
    new("UICorner", {Parent = button, CornerRadius = UDim.new(0,6)})
    button.MouseButton1Click:Connect(function()
        local state = callback()
        if state then
            button.BackgroundColor3 = Color3.fromRGB(255,255,255)
            button.BackgroundTransparency = 0.7
        else
            button.BackgroundColor3 = Color3.fromRGB(40,40,40)
            button.BackgroundTransparency = 0
        end
    end)
    return button
end

-- Создаем кнопки
createToggleButton("ESP", 0.05, 85, function()
    ESP_Enabled = not ESP_Enabled
    return ESP_Enabled
end)

createToggleButton("Tracers", 0.55, 85, function()
    Tracer_Enabled = not Tracer_Enabled
    return Tracer_Enabled
end)

createToggleButton("Hitbox Expand", 0.05, 85 + btnSpacingY, function()
    Hitbox_Enabled = not Hitbox_Enabled
    if Hitbox_Enabled then
        expandHitboxes()
    else
        resetHitboxes()
    end
    return Hitbox_Enabled
end)

createToggleButton("Infinity Jump", 0.55, 85 + btnSpacingY, function()
    InfinityJump_Enabled = not InfinityJump_Enabled
    return InfinityJump_Enabled
end)

createToggleButton("Speed", 0.05, 85 + btnSpacingY*2, function()
    Speed_Enabled = not Speed_Enabled
    return Speed_Enabled
end)

createToggleButton("Speed+", 0.55, 85 + btnSpacingY*2, function()
    SpeedPlus_Enabled = not SpeedPlus_Enabled
    return SpeedPlus_Enabled
end)

createToggleButton("Wallhack", 0.05, 85 + btnSpacingY*3, function()
    Wallhack_Enabled = not Wallhack_Enabled
    setWallhack(Wallhack_Enabled)
    return Wallhack_Enabled
end)

createToggleButton("Night Vision", 0.55, 85 + btnSpacingY*3, function()
    NightVision_Enabled = not NightVision_Enabled
    setNightVision(NightVision_Enabled)
    return NightVision_Enabled
end)

createToggleButton("No Fall", 0.05, 85 + btnSpacingY*4, function()
    NoFall_Enabled = not NoFall_Enabled
    return NoFall_Enabled
end)

createToggleButton("Anti Knockback", 0.55, 85 + btnSpacingY*4, function()
    AntiKnockback_Enabled = not AntiKnockback_Enabled
    return AntiKnockback_Enabled
end)

createToggleButton("Long Jump", 0.05, 85 + btnSpacingY*5, function()
    LongJump_Enabled = not LongJump_Enabled
    return LongJump_Enabled
end)

-- === Логика интерфейса ===
btn.MouseButton1Click:Connect(function()
    window.Visible = not window.Visible
end)

btnClose.MouseButton1Click:Connect(function()
    window.Visible = false
end)

-- Инициализация ESP для существующих игроков
for _, plr in pairs(Players:GetPlayers()) do
    createPlayerESP(plr)
end

Players.PlayerAdded:Connect(createPlayerESP)

-- Инициализация Brainrot ESP
findBrainrots()

-- Логика входа
loginButton.MouseButton1Click:Connect(function()
    local key = passwordBox.Text
    if key == "ваш_ключ" then -- Замените на реальный ключ
        loginFrame.Visible = false
        floatBtn.Visible = true
        watermark.Visible = true
    else
        loginError.Text = "Неверный ключ!"
        task.wait(2)
        loginError.Text = ""
    end
end)
