local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

-- === Вспомогательные функции ===
local function new(className, props)
    local obj = Instance.new(className)
    if props then
        for k,v in pairs(props) do
            obj[k] = v
        end
    end
    return obj
end

-- === GUI ===
local screenGui = new("ScreenGui", {
    Name = "FluxClientGUI",
    ResetOnSpawn = false,
    Parent = playerGui,
})

-- Watermark
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

-- Login Window
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

-- Main Menu
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

-- === Функционал ===
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
local OriginalWalkSpeed = 16
local ESP_Connections = {}
local OriginalSizes = {}

-- Night Vision
local function setNightVision(state)
    Lighting.Ambient = state and Color3.new(1,1,1) or Color3.new(0,0,0)
    Lighting.ColorShift_Bottom = state and Color3.new(1,1,1) or Color3.new(0,0,0)
    Lighting.ColorShift_Top = state and Color3.new(1,1,1) or Color3.new(0,0,0)
    Lighting.Brightness = state and 1 or 1
    Lighting.ClockTime = state and 14 or 14
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
local function createESP(plr)
    if plr == player then return end
    local box = Drawing.new("Square")
    box.Color = Color3.new(1,1,1)
    box.Thickness = 1.5
    box.Transparency = 1
    box.Filled = false

    local tracer = Drawing.new("Line")
    tracer.Color = Color3.new(1,1,1)
    tracer.Thickness = 1
    tracer.Transparency = 1

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

                box.Size = Vector2.new(width, height)
                box.Position = Vector2.new(headPos.X - width/2, headPos.Y)
                box.Visible = ESP_Enabled

                tracer.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                tracer.To = Vector2.new(pos.X, pos.Y)
                tracer.Visible = Tracer_Enabled

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

-- Hitbox
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
            obj.LocalTransparencyModifier = state and 0.5 or 0
            obj.CanCollide = not state
        end
    end
end

-- Speed Hacks
local function updateSpeed()
    if not player.Character then return end
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    -- Сохраняем оригинальную скорость
    if not humanoid:GetAttribute("OriginalWalkSpeed") then
        humanoid:SetAttribute("OriginalWalkSpeed", humanoid.WalkSpeed)
    end

    -- Проверяем наличие катушки скорости
    local hasCoil = false
    for _, tool in ipairs(player.Character:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("speed") or tool.Name:lower():find("катушка")) then
            hasCoil = true
            break
        end
    end

    -- Применяем эффекты
    if SpeedPlus_Enabled and hasCoil then
        -- СПИД+: сохраняем текущую скорость (эффект катушки)
        humanoid.WalkSpeed = humanoid.WalkSpeed
    elseif Speed_Enabled then
        -- Обычный СПИД: ускоряем в 2 раза
        humanoid.WalkSpeed = OriginalWalkSpeed * 2
    else
        -- Выключаем все: возвращаем оригинальную скорость
        humanoid.WalkSpeed = humanoid:GetAttribute("OriginalWalkSpeed") or OriginalWalkSpeed
    end
end

-- Infinity Jump
UserInputService.JumpRequest:Connect(function()
    if InfinityJump_Enabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState("Jumping")
        end
    end
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
        Text = name,
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255,255,255),
        ZIndex = 15,
    })
    new("UICorner", {Parent = button, CornerRadius = UDim.new(0,6)})
    
    button.MouseButton1Click:Connect(function()
        local state = callback()
        button.BackgroundColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(40,40,40)
        button.BackgroundTransparency = state and 0.7 or 0
    end)
    
    return button
end

-- Создаем кнопки
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

createToggleButton("Wallhack", 0.05, 85 + btnSpacingY, function()
    Wallhack_Enabled = not Wallhack_Enabled
    setWallhack(Wallhack_Enabled)
    return Wallhack_Enabled
end)

createToggleButton("Tracer", 0.55, 85 + btnSpacingY, function()
    Tracer_Enabled = not Tracer_Enabled
    return Tracer_Enabled
end)

createToggleButton("Infinity Jump", 0.05, 85 + btnSpacingY*2, function()
    InfinityJump_Enabled = not InfinityJump_Enabled
    return InfinityJump_Enabled
end)

-- Кнопка СПИД (x2 ускорение)
createToggleButton("СПИД", 0.05, 85 + btnSpacingY*3, function()
    Speed_Enabled = not Speed_Enabled
    SpeedPlus_Enabled = false -- Отключаем СПИД+ при активации СПИД
    updateSpeed()
    return Speed_Enabled
end)

-- Кнопка СПИД+ (сохранение катушки)
createToggleButton("СПИД+", 0.55, 85 + btnSpacingY*3, function()
    SpeedPlus_Enabled = not SpeedPlus_Enabled
    Speed_Enabled = false -- Отключаем СПИД при активации СПИД+
    updateSpeed()
    return SpeedPlus_Enabled
end)

createToggleButton("Night Vision", 0.05, 85 + btnSpacingY*4, function()
    NightVision_Enabled = not NightVision_Enabled
    setNightVision(NightVision_Enabled)
    return NightVision_Enabled
end)

createToggleButton("No Fall", 0.55, 85 + btnSpacingY*4, function()
    NoFall_Enabled = not NoFall_Enabled
    return NoFall_Enabled
end)

createToggleButton("Anti Knockback", 0.05, 85 + btnSpacingY*5, function()
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
    ZIndex = 10,
})
new("UICorner", {Parent = playerListFrame, CornerRadius = UDim.new(0,6)})

local playerListScrolling = new("ScrollingFrame", {
    Parent = playerListFrame,
    Size = UDim2.new(1, -10, 1, -30),
    Position = UDim2.new(0, 5, 0, 25),
    BackgroundTransparency = 1,
    ScrollBarThickness = 4,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ZIndex = 11,
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
                TextColor3 = Color3.fromRGB(255,255,255),
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = 12,
            })
            totalHeight = totalHeight + 18
        end
    end
    playerListScrolling.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- === Обработчики событий ===
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

-- Инициализация ESP для существующих игроков
for _, plr in ipairs(Players:GetPlayers()) do
    createESP(plr)
end

-- Обновление скорости и списка игроков
RunService.Heartbeat:Connect(function()
    updateSpeed()
    noFall()
    antiKnockback()
    updatePlayerList()
end)
