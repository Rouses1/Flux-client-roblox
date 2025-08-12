local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

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

-- === Основной GUI ===
local screenGui = new("ScreenGui", {
    Name = "FluxClient",
    ResetOnSpawn = false,
    Parent = playerGui
})

-- === Водяной знак ===
local watermark = new("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 160, 0, 30),
    Position = UDim2.new(0, 10, 0, 10),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.3,
    ZIndex = 10
})
new("UICorner", {Parent = watermark, CornerRadius = UDim.new(0, 8)})

new("TextLabel", {
    Parent = watermark,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "Flux Client v2.0",
    Font = Enum.Font.SourceSansSemibold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextXAlignment = Enum.TextXAlignment.Center,
    TextYAlignment = Enum.TextYAlignment.Center,
    ZIndex = 11
})

-- === Окно входа ===
local loginFrame = new("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 300, 0, 160),
    Position = UDim2.new(0.5, -150, 0.5, -80),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.5,
    ZIndex = 20
})
new("UICorner", {Parent = loginFrame, CornerRadius = UDim.new(0, 10)})
new("UIStroke", {Parent = loginFrame, Color = Color3.fromRGB(100, 100, 100)})

new("TextLabel", {
    Parent = loginFrame,
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 0, 10),
    BackgroundTransparency = 1,
    Text = "FLUX CLIENT",
    Font = Enum.Font.SourceSansBold,
    TextSize = 20,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 21
})

local passwordBox = new("TextBox", {
    Parent = loginFrame,
    Size = UDim2.new(0.85, 0, 0, 28),
    Position = UDim2.new(0.075, 0, 0.4, 0),
    PlaceholderText = "Введите пароль...",
    Text = "",
    Font = Enum.Font.SourceSans,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    BackgroundTransparency = 0.2,
    ClearTextOnFocus = false,
    ZIndex = 21
})
new("UICorner", {Parent = passwordBox, CornerRadius = UDim.new(0, 6)})

local loginButton = new("TextButton", {
    Parent = loginFrame,
    Size = UDim2.new(0.5, 0, 0, 28),
    Position = UDim2.new(0.25, 0, 0.7, 0),
    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
    Text = "АКТИВИРОВАТЬ",
    Font = Enum.Font.SourceSansBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    ZIndex = 21
})
new("UICorner", {Parent = loginButton, CornerRadius = UDim.new(0, 6)})

-- === Главное меню ===
local floatBtn = new("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 50, 0, 50),
    Position = UDim2.new(0.02, 0, 0.5, -25),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
    BackgroundTransparency = 0.3,
    ZIndex = 15,
    Visible = false
})
new("UICorner", {Parent = floatBtn, CornerRadius = UDim.new(0, 12)})
new("UIStroke", {Parent = floatBtn, Color = Color3.fromRGB(100, 100, 100)})

local btn = new("TextButton", {
    Parent = floatBtn,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "≡",
    Font = Enum.Font.SourceSansBold,
    TextSize = 24,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    ZIndex = 16
})

local window = new("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 400, 0, 350),
    Position = UDim2.new(0.5, -200, 0.5, -175),
    BackgroundColor3 = Color3.fromRGB(20, 20, 20),
    BackgroundTransparency = 0.2,
    ZIndex = 14,
    Visible = false
})
new("UICorner", {Parent = window, CornerRadius = UDim.new(0, 12)})
new("UIStroke", {Parent = window, Color = Color3.fromRGB(100, 100, 100)})

local title = new("TextLabel", {
    Parent = window,
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 0, 10),
    BackgroundTransparency = 1,
    Text = "FLUX CLIENT MENU",
    Font = Enum.Font.SourceSansBold,
    TextSize = 20,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 15
})

local btnClose = new("TextButton", {
    Parent = window,
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(1, -40, 0, 10),
    BackgroundTransparency = 1,
    Text = "×",
    Font = Enum.Font.SourceSansBold,
    TextSize = 24,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    ZIndex = 16
})

-- === Переменные функций ===
local ESP_Enabled = false
local Tracer_Enabled = false
local Hitbox_Enabled = false
local InfinityJump_Enabled = false
local Speed_Enabled = false
local SpeedPlus_Enabled = false
local SpeedPlus_Active = false
local Wallhack_Enabled = false
local NightVision_Enabled = false
local NoFall_Enabled = false
local AntiKnockback_Enabled = false
local WalkSpeed_Value = 32
local JumpPower_Value = 50
local SpeedToolName = "Катушка"
local ESP_Connections = {}
local OriginalSizes = {}

-- === Вспомогательные функции ===
local function createToggleButton(name, position, callback)
    local button = new("TextButton", {
        Parent = window,
        Size = UDim2.new(0.45, 0, 0, 30),
        Position = position,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Text = name,
        Font = Enum.Font.SourceSansSemibold,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 15
    })
    new("UICorner", {Parent = button, CornerRadius = UDim.new(0, 6)})
    
    button.MouseButton1Click:Connect(function()
        local state = callback()
        button.BackgroundColor3 = state and Color3.fromRGB(80, 160, 80) or Color3.fromRGB(40, 40, 40)
    end)
    
    return button
end

-- === Speed+ System ===
local function hasSpeedTool()
    if not player.Character then return false end
    local tool = player.Character:FindFirstChildOfClass("Tool")
    return tool and (tool.Name:lower():find(SpeedToolName:lower()) ~= nil)
end

-- === Основные функции ===
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
        Lighting.Brightness = 0.5
        Lighting.ClockTime = 14
    end
end

local function noFall()
    if NoFall_Enabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            humanoid:ChangeState("Running")
        end
    end
end

local function antiKnockback()
    if AntiKnockback_Enabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end
    end
end

-- === ESP System ===
local function createESP(plr)
    if plr == player then return end
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.new(1, 1, 0)
    box.Thickness = 1
    box.Filled = false
    box.ZIndex = 10
    
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local pos, vis = camera:WorldToViewportPoint(hrp.Position)
            
            if vis then
                local head = plr.Character:FindFirstChild("Head")
                if head then
                    local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local feetPos = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    local height = (feetPos.Y - headPos.Y)
                    local width = height * 0.5
                    
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(headPos.X - width/2, headPos.Y)
                    box.Visible = ESP_Enabled
                end
            else
                box.Visible = false
            end
        else
            box.Visible = false
        end
    end)
    
    plr.AncestryChanged:Connect(function()
        box:Remove()
        conn:Disconnect()
    end)
end

-- === Hitbox System ===
local function expandHitboxes()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local head = plr.Character:FindFirstChild("Head")
            if hrp and head then
                if not OriginalSizes[plr] then
                    OriginalSizes[plr] = {
                        HRP_Size = hrp.Size,
                        Head_Size = head.Size
                    }
                end
                hrp.Size = Vector3.new(6, 6, 6)
                head.Size = Vector3.new(3, 3, 3)
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
                head.Size = sizes.Head_Size
            end
        end
    end
    OriginalSizes = {}
end

-- === Wallhack System ===
local function setWallhack(state)
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and not part:IsDescendantOf(player.Character) then
            part.LocalTransparencyModifier = state and 0.5 or 0
        end
    end
end

-- === Main Loop ===
RunService.Heartbeat:Connect(function()
    -- Speed+ System
    if SpeedPlus_Enabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if SpeedPlus_Active or hasSpeedTool() then
                humanoid.WalkSpeed = WalkSpeed_Value
                SpeedPlus_Active = true
            else
                humanoid.WalkSpeed = 16
            end
        end
    end
    
    -- Other systems
    noFall()
    antiKnockback()
end)

-- === Player Added Handlers ===
player.CharacterAdded:Connect(function(character)
    character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and SpeedPlus_Enabled then
            if child.Name:lower():find(SpeedToolName:lower()) then
                SpeedPlus_Active = true
            end
        end
    end)
end)

-- === Initialize ESP ===
for _, plr in ipairs(Players:GetPlayers()) do
    createESP(plr)
end

Players.PlayerAdded:Connect(createESP)

-- === Create Buttons ===
local btnY = 50
local btnSpacing = 35

createToggleButton("ESP", UDim2.new(0.025, 0, 0, btnY), function()
    ESP_Enabled = not ESP_Enabled
    return ESP_Enabled
end)

createToggleButton("Tracers", UDim2.new(0.525, 0, 0, btnY), function()
    Tracer_Enabled = not Tracer_Enabled
    return Tracer_Enabled
end)

createToggleButton("Hitbox", UDim2.new(0.025, 0, 0, btnY + btnSpacing), function()
    Hitbox_Enabled = not Hitbox_Enabled
    if Hitbox_Enabled then
        expandHitboxes()
    else
        resetHitboxes()
    end
    return Hitbox_Enabled
end)

createToggleButton("Wallhack", UDim2.new(0.525, 0, 0, btnY + btnSpacing), function()
    Wallhack_Enabled = not Wallhack_Enabled
    setWallhack(Wallhack_Enabled)
    return Wallhack_Enabled
end)

createToggleButton("Inf Jump", UDim2.new(0.025, 0, 0, btnY + btnSpacing*2), function()
    InfinityJump_Enabled = not InfinityJump_Enabled
    return InfinityJump_Enabled
end)

createToggleButton("Speed+", UDim2.new(0.525, 0, 0, btnY + btnSpacing*2), function()
    SpeedPlus_Enabled = not SpeedPlus_Enabled
    if not SpeedPlus_Enabled then
        SpeedPlus_Active = false
    end
    return SpeedPlus_Enabled
end)

createToggleButton("Night Vision", UDim2.new(0.025, 0, 0, btnY + btnSpacing*3), function()
    NightVision_Enabled = not NightVision_Enabled
    setNightVision(NightVision_Enabled)
    return NightVision_Enabled
end)

createToggleButton("No Fall", UDim2.new(0.525, 0, 0, btnY + btnSpacing*3), function()
    NoFall_Enabled = not NoFall_Enabled
    return NoFall_Enabled
end)

createToggleButton("Anti KB", UDim2.new(0.025, 0, 0, btnY + btnSpacing*4), function()
    AntiKnockback_Enabled = not AntiKnockback_Enabled
    return AntiKnockback_Enabled
end)

-- === Login System ===
local CORRECT_PASSWORD = "FLUX123"
loginButton.MouseButton1Click:Connect(function()
    if passwordBox.Text == CORRECT_PASSWORD then
        floatBtn.Visible = true
        loginFrame.Visible = false
    else
        -- Неверный пароль
    end
end)

-- === Menu Controls ===
btn.MouseButton1Click:Connect(function()
    window.Visible = not window.Visible
end)

btnClose.MouseButton1Click:Connect(function()
    window.Visible = false
end)

-- === Infinity Jump ===
UserInputService.JumpRequest:Connect(function()
    if InfinityJump_Enabled and player.Character then
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
