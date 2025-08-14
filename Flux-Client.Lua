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
local CATEGORY_COLOR = Color3.fromRGB(30, 30, 30)

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
    Size = UDim2.new(0, 520, 0, 400),
    Position = UDim2.new(0.5, -260, 0.5, -200),
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

-- Категории
local categories = {
    ["Combat"] = {
        "Aimbot", "Silent Aim", "Trigger Bot", "Hitbox"
    },
    ["Movement"] = {
        "Speed", "Infinity Jump", "Spider", "No Fall", "Anti Knockback", "Levitation", "Strafe"
    },
    ["Visual"] = {
        "ESP", "ESP Objects", "ESP Moving Only", "Tracer", "Wallhack", "Night Vision"
    },
    ["Other"] = {
        "Anti-Slow"
    }
}

local categoryFrames = {}
local currentCategory = "Combat"

-- Создаем фреймы категорий
for categoryName, _ in pairs(categories) do
    local frame = new("ScrollingFrame", {
        Parent = window,
        Size = UDim2.new(1, -20, 1, -100),
        Position = UDim2.new(0, 10, 0, 80),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Visible = false,
    })
    
    new("UIListLayout", {
        Parent = frame,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5),
    })
    
    categoryFrames[categoryName] = frame
end

-- Создаем кнопки категорий
local categoryButtons = {}
local categoryX = 0.05
for categoryName, _ in pairs(categories) do
    local button = new("TextButton", {
        Parent = window,
        Size = UDim2.new(0.2, 0, 0, 25),
        Position = UDim2.new(categoryX, 0, 0, 80),
        BackgroundColor3 = CATEGORY_COLOR,
        Text = categoryName,
        Font = Enum.Font.SourceSans,
        TextSize = 14,
        TextColor3 = TEXT_COLOR,
    })
    new("UICorner", {Parent = button, CornerRadius = UDim.new(0,6)})
    
    button.MouseButton1Click:Connect(function()
        currentCategory = categoryName
        for name, frame in pairs(categoryFrames) do
            frame.Visible = (name == categoryName)
        end
        for _, btn in pairs(categoryButtons) do
            btn.BackgroundColor3 = CATEGORY_COLOR
        end
        button.BackgroundColor3 = BUTTON_COLOR
    end)
    
    categoryButtons[categoryName] = button
    categoryX = categoryX + 0.22
end

-- Переменные функций
local ESP_Enabled = false
local ESP_MovingOnly = false
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
local AntiSlow_Enabled = false
local Strafe_Enabled = false
local Levitation_Enabled = false
local LastVelocity = Vector3.new(0,0,0)

-- Улучшенные функции
local function isPlayerAlive(plr)
    if not plr or not plr.Character then return false end
    local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health > 0 and not humanoid:GetState() == Enum.HumanoidStateType.Dead
end

local function isCharacterValid(char)
    return char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and char:FindFirstChildOfClass("Humanoid")
end

-- Улучшенный ESP для объектов
local function isObjectMoving(obj)
    if not obj or not obj:IsA("BasePart") then return false end
    local velocity = obj.AssemblyLinearVelocity
    return velocity and velocity.Magnitude > 0.1
end

local function createESPObject(obj)
    if not obj or not obj:IsA("BasePart") or obj:IsDescendantOf(player.Character) then return end
    if ESP_MovingOnly and not isObjectMoving(obj) then return end
    
    if ESP_Objects_Connections[obj] then return end
    
    local box = Drawing.new("Square")
    box.Color = Color3.new(0, 0, 0)
    box.Thickness = 2
    box.Transparency = 1
    box.Filled = false
    box.Visible = false
    
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not obj or not obj.Parent then
            box:Remove()
            if conn then conn:Disconnect() end
            ESP_Objects_Connections[obj] = nil
            return
        end
        
        if ESP_MovingOnly and not isObjectMoving(obj) then
            box.Visible = false
            return
        end
        
        local pos, vis = camera:WorldToViewportPoint(obj.Position)
        if vis and ESP_Objects_Enabled then
            box.Size = Vector2.new(20, 20)
            box.Position = Vector2.new(pos.X - 10, pos.Y - 10)
            box.Visible = true
        else
            box.Visible = false
        end
    end)
    
    ESP_Objects_Connections[obj] = conn
    
    local ancestryConn
    ancestryConn = obj.AncestryChanged:Connect(function()
        box:Remove()
        if conn then conn:Disconnect() end
        if ancestryConn then ancestryConn:Disconnect() end
        ESP_Objects_Connections[obj] = nil
    end)
end

-- Улучшенный ESP для игроков
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
    
    local healthBar = Drawing.new("Line")
    healthBar.Color = Color3.new(0,0,0)
    healthBar.Thickness = 2
    healthBar.Transparency = 1
    
    local nameTag = Drawing.new("Text")
    nameTag.Text = plr.Name
    nameTag.Color = Color3.new(1,1,1)
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
            if conn then conn:Disconnect() end
            ESP_Connections[plr] = nil
            return
        end
        
        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        local head = plr.Character:FindFirstChild("Head")
        local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
        
        if hrp and head and humanoid and humanoid.Health > 0 then
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
                    
                    if Tracer_Enabled then
                        tracer.From = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y)
                        tracer.To = Vector2.new(pos.X, pos.Y)
                        tracer.Visible = true
                    else
                        tracer.Visible = false
                    end
                    
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local barHeight = height * healthPercent
                    healthBar.From = Vector2.new(headPos.X - width/2 - 5, headPos.Y + height - barHeight)
                    healthBar.To = Vector2.new(headPos.X - width/2 - 5, headPos.Y + height)
                    healthBar.Visible = true
                    
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
    
    ESP_Connections[plr] = conn
    
    local function cleanUp()
        box:Remove()
        tracer:Remove()
        healthBar:Remove()
        nameTag:Remove()
        if conn then conn:Disconnect() end
        ESP_Connections[plr] = nil
    end
    
    plr.AncestryChanged:Connect(cleanUp)
    plr.CharacterRemoving:Connect(cleanUp)
end

-- Улучшенный Hitbox
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
        if plr and plr.Character then
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

-- Улучшенный Wallhack
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

-- Улучшенный Anti-Slow
local function antiSlow()
    if not AntiSlow_Enabled or not player.Character then return end
    
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if humanoid.WalkSpeed < WalkSpeed_Value then
            humanoid.WalkSpeed = WalkSpeed_Value
        end
        
        if humanoid.JumpPower < JumpPower_Value then
            humanoid.JumpPower = JumpPower_Value
        end
        
        -- Защита от эффектов замедления
        for _, effect in ipairs(humanoid:GetChildren()) do
            if effect:IsA("NumberValue") and (effect.Name:find("Slow") or effect.Name:find("Debuff")) then
                effect:Destroy()
            end
        end
    end
end

-- Улучшенный Strafe
local function strafe()
    if not Strafe_Enabled or not player.Character then return end
    
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if humanoid:GetState() == Enum.HumanoidStateType.Jumping then
            LastVelocity = humanoid.MoveDirection * humanoid.WalkSpeed
            
            if LastVelocity.Magnitude > 0 then
                humanoid:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
                task.wait(0.05)
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end
end

-- Улучшенная Levitation
local function levitation()
    if not Levitation_Enabled or not player.Character then return end
    
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    local hrp = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {player.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local rayOrigin = hrp.Position
    local rayDirection = Vector3.new(0, -10, 0)
    local raycastResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if raycastResult then
        local distanceToGround = (raycastResult.Position - hrp.Position).Magnitude
        
        if distanceToGround > 1.5 then
            local targetYVelocity = (1.5 - distanceToGround) * 5
            hrp.Velocity = Vector3.new(
                hrp.Velocity.X,
                math.clamp(targetYVelocity, -50, 50),
                hrp.Velocity.Z
            )
        end
    end
end

-- Улучшенный Night Vision
local function setNightVision(state)
    if state then
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
        Lighting.ColorShift_Top = Color3.new(1, 1, 1)
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
    else
        Lighting.Ambient = Color3.new(0, 0, 0)
        Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
        Lighting.ColorShift_Top = Color3.new(0, 0, 0)
        Lighting.Brightness = 1
    end
end

-- Улучшенный No Fall
local function noFall()
    if NoFall_Enabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {player.Character}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            
            local rayOrigin = player.Character:FindFirstChild("HumanoidRootPart").Position
            local rayDirection = Vector3.new(0, -50, 0)
            local raycastResult = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
            
            if raycastResult and raycastResult.Position.Y < rayOrigin.Y - 10 then
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end
end

-- Улучшенный Anti Knockback
local function antiKnockback()
    if AntiKnockback_Enabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
            
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Velocity = Vector3.new(hrp.Velocity.X * 0.5, math.min(hrp.Velocity.Y, 0), hrp.Velocity.Z * 0.5)
            end
        end
    end
end

-- Улучшенный Spider
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

-- Улучшенный Trigger Bot
local function triggerBot()
    if TriggerBot_Enabled and player.Character and isPlayerAlive(player) then
        local closestPlayer, closestDistance = nil, math.huge
        
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and isPlayerAlive(plr) and isCharacterValid(plr.Character) then
                local targetRoot = plr.Character.HumanoidRootPart
                local targetHead = plr.Character.Head
                
                local screenPoint = camera:WorldToViewportPoint(targetHead.Position)
                if screenPoint.Z > 0 then
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

-- Улучшенный Aimbot
local function aimAt(target)
    if not target or not target:IsDescendantOf(Workspace) then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local targetPosition = target.Position
    local camera = Workspace.CurrentCamera
    local lookAt = (targetPosition - camera.CFrame.Position).Unit
    
    local current = camera.CFrame.LookVector
    local smooth = 0.5
    local new = current:Lerp(lookAt, smooth)
    
    camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + new)
end

-- Улучшенный Silent Aim
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
            return targetHead.Position + Vector3.new(0, 0.5, 0) -- Aim slightly above head
        end
    end
    
    return nil
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

-- Основной цикл
RunService.Heartbeat:Connect(function()
    if player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if Speed_Enabled then
                humanoid.WalkSpeed = WalkSpeed_Value
            elseif humanoid.WalkSpeed ~= 16 then
                humanoid.WalkSpeed = 16
            end
            
            antiSlow()
            strafe()
        end
    end
    
    noFall()
    antiKnockback()
    spider()
    triggerBot()
    levitation()
    
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

-- Создаем кнопки функций
local function createToggleButton(category, name, callback)
    local button = new("TextButton", {
        Parent = categoryFrames[category],
        Size = UDim2.new(1, -10, 0, 28),
        BackgroundColor3 = BUTTON_COLOR,
        BackgroundTransparency = 0,
        Text = name,
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = TEXT_COLOR,
        Name = name,
        LayoutOrder = #categoryFrames[category]:GetChildren()
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
    
    categoryFrames[category].CanvasSize = UDim2.new(0, 0, 0, #categoryFrames[category]:GetChildren() * 33)
end

-- Создаем кнопки для каждой категории
for category, functions in pairs(categories) do
    for _, funcName in ipairs(functions) do
        if funcName == "Aimbot" then
            createToggleButton(category, funcName, function()
                Aimbot_Enabled = not Aimbot_Enabled
                return Aimbot_Enabled
            end)
        elseif funcName == "Silent Aim" then
            createToggleButton(category, funcName, function()
                SilentAim_Enabled = not SilentAim_Enabled
                return SilentAim_Enabled
            end)
        elseif funcName == "Trigger Bot" then
            createToggleButton(category, funcName, function()
                TriggerBot_Enabled = not TriggerBot_Enabled
                return TriggerBot_Enabled
            end)
        elseif funcName == "Hitbox" then
            createToggleButton(category, funcName, function()
                Hitbox_Enabled = not Hitbox_Enabled
                if Hitbox_Enabled then
                    expandHitboxes()
                else
                    resetHitboxes()
                end
                return Hitbox_Enabled
            end)
        elseif funcName == "Speed" then
            createToggleButton(category, funcName, function()
                Speed_Enabled = not Speed_Enabled
                return Speed_Enabled
            end)
        elseif funcName == "Infinity Jump" then
            createToggleButton(category, funcName, function()
                InfinityJump_Enabled = not InfinityJump_Enabled
                return InfinityJump_Enabled
            end)
        elseif funcName == "Spider" then
            createToggleButton(category, funcName, function()
                Spider_Enabled = not Spider_Enabled
                return Spider_Enabled
            end)
        elseif funcName == "No Fall" then
            createToggleButton(category, funcName, function()
                NoFall_Enabled = not NoFall_Enabled
                return NoFall_Enabled
            end)
        elseif funcName == "Anti Knockback" then
            createToggleButton(category, funcName, function()
                AntiKnockback_Enabled = not AntiKnockback_Enabled
                return AntiKnockback_Enabled
            end)
        elseif funcName == "Levitation" then
            createToggleButton(category, funcName, function()
                Levitation_Enabled = not Levitation_Enabled
                return Levitation_Enabled
            end)
        elseif funcName == "Strafe" then
            createToggleButton(category, funcName, function()
                Strafe_Enabled = not Strafe_Enabled
                return Strafe_Enabled
            end)
        elseif funcName == "ESP" then
            createToggleButton(category, funcName, function()
                ESP_Enabled = not ESP_Enabled
                return ESP_Enabled
            end)
        elseif funcName == "ESP Objects" then
            createToggleButton(category, funcName, function()
                ESP_Objects_Enabled = not ESP_Objects_Enabled
                if ESP_Objects_Enabled then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character) then
                            createESPObject(obj)
                        end
                    end
                else
                    for obj, conn in pairs(ESP_Objects_Connections) do
                        if conn then conn:Disconnect() end
                        ESP_Objects_Connections[obj] = nil
                    end
                end
                return ESP_Objects_Enabled
            end)
        elseif funcName == "ESP Moving Only" then
            createToggleButton(category, funcName, function()
                ESP_MovingOnly = not ESP_MovingOnly
                if ESP_Objects_Enabled then
                    for obj, conn in pairs(ESP_Objects_Connections) do
                        if conn then conn:Disconnect() end
                        ESP_Objects_Connections[obj] = nil
                    end
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character) then
                            createESPObject(obj)
                        end
                    end
                end
                return ESP_MovingOnly
            end)
        elseif funcName == "Tracer" then
            createToggleButton(category, funcName, function()
                Tracer_Enabled = not Tracer_Enabled
                return Tracer_Enabled
            end)
        elseif funcName == "Wallhack" then
            createToggleButton(category, funcName, function()
                Wallhack_Enabled = not Wallhack_Enabled
                setWallhack(Wallhack_Enabled)
                return Wallhack_Enabled
            end)
        elseif funcName == "Night Vision" then
            createToggleButton(category, funcName, function()
                NightVision_Enabled = not NightVision_Enabled
                setNightVision(NightVision_Enabled)
                return NightVision_Enabled
            end)
        elseif funcName == "Anti-Slow" then
            createToggleButton(category, funcName, function()
                AntiSlow_Enabled = not AntiSlow_Enabled
                return AntiSlow_Enabled
            end)
        end
    end
end

-- Поиск по функциям
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local searchText = string.lower(searchBox.Text)
    
    for category, frame in pairs(categoryFrames) do
        for _, child in ipairs(frame:GetChildren()) do
            if child:IsA("TextButton") then
                local buttonText = string.lower(child.Text)
                if string.find(buttonText, searchText) then
                    child.Visible = true
                else
                    child.Visible = searchText == ""
                end
            end
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
                    local newRay = Ray.new(ray.Origin, (targetPos - ray.Origin).Unit * ray.Direction.Magnitude)
                    args[1] = newRay
                    return oldNamecall(self, unpack(args))
                end
            end
        end
    end
    
    return oldNamecall(self, ...)
end)

-- Защита от античита
local function protectCall(f)
    return function(...)
        local s,r = pcall(f, ...)
        if not s then
            warn("Protected call failed:", r)
            return nil
        end
        return r
    end
end

-- Активируем первую категорию по умолчанию
categoryFrames["Combat"].Visible = true
categoryButtons["Combat"].BackgroundColor3 = BUTTON_COLOR

-- Логика входа
local CORRECT_PASSWORD = "FJAL-IIAL-10LL"

loginButton.MouseButton1Click:Connect(protectCall(function()
    if passwordBox.Text == CORRECT_PASSWORD then
        floatBtn.Visible = true
        loginFrame.Visible = false
        loginError.Text = ""
    else
        loginError.Text = "Неверный пароль!"
    end
end))

btn.MouseButton1Click:Connect(protectCall(function()
    window.Visible = not window.Visible
end))

btnClose.MouseButton1Click:Connect(protectCall(function()
    window.Visible = false
end))

-- Обработка новых игроков
Players.PlayerAdded:Connect(protectCall(function(plr)
    createESP(plr)
    plr.CharacterAdded:Connect(protectCall(function()
        if Hitbox_Enabled then
            task.wait(1)
            expandHitboxes()
        end
        if Wallhack_Enabled then
            task.wait(1)
            setWallhack(true)
        end
    end))
end))

Players.PlayerRemoving:Connect(protectCall(function(plr)
    if ESP_Connections[plr] then
        ESP_Connections[plr]:Disconnect()
        ESP_Connections[plr] = nil
    end
end))

-- Обработка новых объектов
Workspace.DescendantAdded:Connect(protectCall(function(obj)
    if ESP_Objects_Enabled and obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character) then
        createESPObject(obj)
    end
end))

-- Инициализация ESP для всех игроков
for _,plr in ipairs(Players:GetPlayers()) do
    createESP(plr)
end

-- Инициализация ESP объектов если включено
if ESP_Objects_Enabled then
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(player.Character) then
            createESPObject(obj)
        end
    end
end
