local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

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
})
new("UICorner", {Parent = searchBox, CornerRadius = UDim.new(0,6)})

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
local AimBot_Enabled = false
local FastBullets_Enabled = false
local WalkSpeed_Value = 40
local ESP_Connections = {}
local OriginalSizes = {}

-- AimBot переменные
local AimCircle = Drawing.new("Circle")
AimCircle.Visible = false
AimCircle.Radius = 50
AimCircle.Thickness = 1
AimCircle.Color = Color3.new(1, 1, 1)
AimCircle.Transparency = 1
AimCircle.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

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

-- AimBot функция
local function aimAtClosestPlayer()
    if not AimBot_Enabled or not player.Character then return end
    
    local closestPlayer = nil
    local closestDistance = 400 -- Максимальная дистанция
    local myHead = player.Character:FindFirstChild("Head")
    local myRoot = player.Character:FindFirstChild("HumanoidRootPart")
    
    if not myHead or not myRoot then return end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local targetHead = plr.Character:FindFirstChild("Head")
            local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            
            if targetHead and targetRoot then
                local distance = (targetRoot.Position - myRoot.Position).Magnitude
                if distance <= 400 then
                    local screenPos, onScreen = camera:WorldToViewportPoint(targetHead.Position)
                    if onScreen then
                        local mousePos = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
                        local targetPos = Vector2.new(screenPos.X, screenPos.Y)
                        local distanceToCenter = (targetPos - mousePos).Magnitude
                        
                        if distanceToCenter <= AimCircle.Radius and distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = plr
                        end
                    end
                end
            end
        end
    end
    
    if closestPlayer and closestPlayer.Character then
        local targetHead = closestPlayer.Character:FindFirstChild("Head")
        if targetHead then
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetHead.Position)
        end
    end
end

-- Fast Bullets функция
local function enableFastBullets()
    if FastBullets_Enabled then
        for _, tool in ipairs(player.Character:GetChildren()) do
            if tool:IsA("Tool") then
                for _, part in ipairs(tool:GetDescendants()) do
                    if part:IsA("BasePart") and part.Velocity.Magnitude > 0 then
                        part.Velocity = part.Velocity * 2
                    end
                end
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
    
    -- Run No Fall and Anti Knockback checks
    noFall()
    antiKnockback()
    aimAtClosestPlayer()
    enableFastBullets()
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

-- Кнопки
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

-- AimBot кнопка
createToggleButton("AimBot", 0.55, 85 + btnSpacingY*2, function()
    AimBot_Enabled = not AimBot_Enabled
    AimCircle.Visible = AimBot_Enabled
    return AimBot_Enabled
end)

-- Fast Bullets кнопка
createToggleButton("Fast Bullets", 0.05, 85 + btnSpacingY*3, function()
    FastBullets_Enabled = not FastBullets_Enabled
    return FastBullets_Enabled
end)

-- Слайдер скорости
local speedSlider = new("Frame", {
    Parent = window,
    Size = UDim2.new(btnWidth, 0, 0, 20),
    Position = UDim2.new(0.55, 0, 0.55, 0),
    BackgroundColor3 = Color3.fromRGB(60,60,60),
    Visible = false,
})
new("UICorner", {Parent = speedSlider, CornerRadius = UDim.new(0,6)})

local speedSliderFill = new("Frame", {
    Parent = speedSlider,
    Size = UDim2.new(0.5, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(255,255,255),
    BackgroundTransparency = 0.7,
})
new("UICorner", {Parent = speedSliderFill, CornerRadius = UDim.new(0,6)})

local speedValueLabel = new("TextLabel", {
    Parent = speedSlider,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "Speed: "..WalkSpeed_Value,
    Font = Enum.Font.SourceSans,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(255,255,255),
})

speedSlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local connection
        connection = RunService.Heartbeat:Connect(function()
            local mouse = UserInputService:GetMouseLocation()
            local sliderPos = speedSlider.AbsolutePosition
            local sliderSize = speedSlider.AbsoluteSize
            local relativeX = math.clamp(mouse.X - sliderPos.X, 0, sliderSize.X)
            local percent = relativeX / sliderSize.X
            
            WalkSpeed_Value = math.floor(16 + (100 - 16) * percent)
            speedValueLabel.Text = "Speed: "..WalkSpeed_Value
            speedSliderFill.Size = UDim2.new(percent, 0, 1, 0)
        end)
        
        local function disconnect()
            connection:Disconnect()
        end
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                disconnect()
            end
        end)
    end
end)

-- Кнопка Speed
local speedButton = createToggleButton("Speed", 0.55, 85 + btnSpacingY*3, function()
    Speed_Enabled = not Speed_Enabled
    speedSlider.Visible = Speed_Enabled
    return Speed_Enabled
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

-- Player List с возможностью перемещения
local playerListFrame = new("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 150, 0, 180),
    Position = UDim2.new(1, -160, 0, 10),
    BackgroundColor3 = Color3.fromRGB(0,0,0),
    BackgroundTransparency = 0.4,
    Active = true,
    Draggable = true,
})
new("UICorner", {Parent = playerListFrame, CornerRadius = UDim.new(0,6)})

local titleLabel = new("TextLabel", {
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
                TextColor3 = Color3.fromRGB(255,255,255),
                TextXAlignment = Enum.TextXAlignment.Center,
            })
            totalHeight = totalHeight + 18
        end
    end
    
    playerListScrolling.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

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
