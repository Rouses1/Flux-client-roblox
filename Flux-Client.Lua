local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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

local loginTitle = new("TextLabel", {
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
    PlaceholderText = "Введите пароль",
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
    TextColor3 = Color3.fromRGB(0,0,0),
    TextXAlignment = Enum.TextXAlignment.Center,
})

-- === Главное окно и элементы ===
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

local header = new("Frame", {
    Parent = window,
    Size = UDim2.new(1,0,0,36),
    BackgroundTransparency = 1,
})

local title = new("TextLabel", {
    Parent = header,
    Position = UDim2.new(0,12,0,0),
    Size = UDim2.new(1,-120,1,0),
    BackgroundTransparency = 1,
    Text = "Flux Client",
    Font = Enum.Font.SourceSansSemibold,
    TextSize = 18,
    TextColor3 = Color3.fromRGB(255,255,255),
    TextXAlignment = Enum.TextXAlignment.Left,
})

local btnClose = new("TextButton", {
    Parent = header,
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

-- === Переменные функций ESP/Aimbot ===
local ESP_Enabled = false
local Tracer_Enabled = false
local Aimbot_Enabled = false
local Hitbox_Enabled = false
local ESP_Connections = {}
local OriginalSizes = {}

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
    end)    

    ESP_Connections[plr] = conn
end

for _,plr in ipairs(Players:GetPlayers()) do
    createESP(plr)
end

local function getClosestTarget()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local centerScreen = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Head") then
            local headPos, onScreen = camera:WorldToViewportPoint(plr.Character.Head.Position)
            if onScreen then
                local head2d = Vector2.new(headPos.X, headPos.Y)
                local dist = (centerScreen - head2d).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestPlayer = plr
                end
            end
        end
    end
    return closestPlayer
end

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

local btnWidth = 0.4
local btnHeight = 28
local btnSpacingY = 40

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

createToggleButton("ESP", 0.05, 85, function()
    ESP_Enabled = not ESP_Enabled
    return ESP_Enabled
end)

createToggleButton("Hitbox", 0.05, 85 + btnSpacingY, function()
    Hitbox_Enabled = not Hitbox_Enabled
    if Hitbox_Enabled then
        expandHitboxes()
    else
        resetHitboxes()
    end
    return Hitbox_Enabled
end)

createToggleButton("Tracer", 0.55, 85, function()
    Tracer_Enabled = not Tracer_Enabled
    return Tracer_Enabled
end)

createToggleButton("Aimbot", 0.55, 85 + btnSpacingY, function()
    Aimbot_Enabled = not Aimbot_Enabled
    return Aimbot_Enabled
end)

Players.PlayerAdded:Connect(function(plr)
    createESP(plr)
    plr.CharacterAdded:Connect(function()
        if Hitbox_Enabled then
            task.wait(1)
            expandHitboxes()
        end
    end)
end)

RunService.RenderStepped:Connect(function()
    if Aimbot_Enabled then
        local target = getClosestTarget()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local headPos = target.Character.Head.Position
            local cameraPos = camera.CFrame.Position
            local direction = (headPos - cameraPos).Unit
            camera.CFrame = CFrame.new(cameraPos, cameraPos + direction)
        end
    end
end)

-- === Функция для перетаскивания GUI ===
local function makeDraggable(gui)
    local dragging, dragInput, mousePos, framePos

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            gui.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- === HUD ===
local function createHUD()
    local HUD_Frame = new("Frame", {
        Name = "HUD",
        Parent = screenGui,
        Size = UDim2.new(0, 150, 0, 70),
        Position = UDim2.new(0.8, 0, 0.05, 0),
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0.3,
        ZIndex = 50,
    })
    new("UICorner", {Parent = HUD_Frame, CornerRadius = UDim.new(0,8)})
    new("UIStroke", {Parent = HUD_Frame, Color = Color3.fromRGB(255,255,255), Transparency = 0.6})

    local fpsLabel = new("TextLabel", {
        Parent = HUD_Frame,
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        Text = "FPS: 0",
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255,255,255),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local pingLabel = new("TextLabel", {
        Parent = HUD_Frame,
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 25),
        BackgroundTransparency = 1,
        Text = "Ping: 0 ms",
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255,255,255),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local speedLabel = new("TextLabel", {
        Parent = HUD_Frame,
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 45),
        BackgroundTransparency = 1,
        Text = "Speed: 0",
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255,255,255),
        TextXAlignment = Enum.TextXAlignment.Left,
    })

    local lastFrameTime = tick()
    local frameCount = 0
    local fps = 0

    RunService.RenderStepped:Connect(function()
        -- Считаем FPS
        frameCount += 1
        local now = tick()
        if now - lastFrameTime >= 1 then
            fps = frameCount
            frameCount = 0
            lastFrameTime = now
            fpsLabel.Text = "FPS: "..fps
        end

        -- Пинг (пример, обновляется раз в секунду)
        -- В Roblox нет прямого метода узнать пинг клиента, но можно примерно использовать NetworkStats
        local stats = stats or game:GetService("Stats")
        local pingMs = math.floor(stats.Network.ServerStatsItem["Data Ping"]:GetValue() * 1000)
        pingLabel.Text = "Ping: "..pingMs.." ms"

        -- Скорость игрока
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local vel = char.HumanoidRootPart.Velocity
            local speed = math.floor(Vector3.new(vel.X, 0, vel.Z).Magnitude)
            speedLabel.Text = "Speed: "..speed
        else
            speedLabel.Text = "Speed: 0"
        end
    end)

    makeDraggable(HUD_Frame)
    HUD_Frame.Active = true

    return HUD_Frame
end

local HUD = createHUD()

makeDraggable(floatBtn)
floatBtn.Active = true

btn.MouseButton1Click:Connect(function()
    window.Visible = not window.Visible
    floatBtn.Visible = not window.Visible
end)

btnClose.MouseButton1Click:Connect(function()
    window.Visible = false
    floatBtn.Visible = true
end)
