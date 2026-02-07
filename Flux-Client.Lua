-- Universal Roblox Exploit Script
-- Только для образовательных целей

-- Глобальные переменные
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Настройки по умолчанию
local Settings = {
    Aimbot = {
        Enabled = false,
        Key = "RightControl",
        Smoothness = 0.5,
        FOV = 100,
        VisibleCheck = true,
        TeamCheck = true,
        Priority = "Closest" -- "Closest", "Head", "Torso"
    },
    ESP = {
        Enabled = false,
        Box = true,
        Tracer = true,
        Name = true,
        Health = true,
        Distance = true,
        TeamColor = true,
        MaxDistance = 1000
    },
    Visuals = {
        Crosshair = false,
        FOVCircle = false,
        NoRecoil = false,
        NoSpread = false
    },
    Misc = {
    Speed = false,
        SpeedMultiplier = 2,
        JumpPower = false,
        JumpMultiplier = 1.5
    }
}

-- Переменные для работы
local Connections = {}
local ESPObjects = {}
local Target = nil
local MenuOpen = false
local ToggleKey = "RightShift"

-- Создание интерфейса меню
local ScreenGui = Instance.new("ScreenGui")
if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game:GetService("CoreGui")
else
    ScreenGui.Parent = game:GetService("CoreGui")
end

-- Главный фрейм меню
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Заголовок меню
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
Title.BorderSizePixel = 0
Title.Text = "ROBLOX EXPLOIT MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Вкладки
local TabButtons = {}
local TabFrames = {}

local function createTab(name, index)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0.25, 0, 0, 30)
    tabButton.Position = UDim2.new(0.25 * (index - 1), 0, 0, 40)
    tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    tabButton.BorderSizePixel = 0
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 14
    tabButton.Parent = MainFrame
    
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Size = UDim2.new(1, -20, 1, -80)
    tabFrame.Position = UDim2.new(0, 10, 0, 75)
    tabFrame.BackgroundTransparency = 1
    tabFrame.BorderSizePixel = 0
    tabFrame.ScrollBarThickness = 4
    tabFrame.Visible = index == 1
    tabFrame.Parent = MainFrame
    
    TabButtons[name] = tabButton
    TabFrames[name] = tabFrame
    
    tabButton.MouseButton1Click:Connect(function()
        for _, frame in pairs(TabFrames) do
            frame.Visible = false
        end
        for _, button in pairs(TabButtons) do
            button.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        end
        tabFrame.Visible = true
        tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    end)
end

-- Создание вкладок
createTab("Aimbot", 1)
createTab("ESP", 2)
createTab("Visuals", 3)
createTab("Misc", 4)

-- Функция для создания переключателя
local function createToggle(parent, text, settingTable, settingKey, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 30)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = parent
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = text
    toggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextSize = 14
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 50, 0, 25)
    toggleButton.Position = UDim2.new(0.7, 0, 0.5, -12.5)
    toggleButton.BackgroundColor3 = settingTable[settingKey] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = settingTable[settingKey] and "ON" or "OFF"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 12
    toggleButton.Parent = toggleFrame
    
    toggleButton.MouseButton1Click:Connect(function()
        settingTable[settingKey] = not settingTable[settingKey]
        toggleButton.BackgroundColor3 = settingTable[settingKey] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        toggleButton.Text = settingTable[settingKey] and "ON" or "OFF"
        if callback then callback() end
    end)
    
    return toggleFrame
end

-- Функция для создания слайдера
local function createSlider(parent, text, settingTable, settingKey, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, 0, 0, 50)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.Parent = parent
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, 0, 0, 20)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Text = text .. ": " .. tostring(settingTable[settingKey])
    sliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.TextSize = 14
    sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    sliderLabel.Parent = sliderFrame
    
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(1, 0, 0, 10)
    slider.Position = UDim2.new(0, 0, 0, 25)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    slider.BorderSizePixel = 0
    slider.Parent = sliderFrame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((settingTable[settingKey] - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    local dragging = false
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
            local value = min + (max - min) * relativeX
            settingTable[settingKey] = math.floor(value * 100) / 100
            fill.Size = UDim2.new(relativeX, 0, 1, 0)
            sliderLabel.Text = text .. ": " .. tostring(settingTable[settingKey])
            if callback then callback() end
        end
    end)
    
    return sliderFrame
end

-- Заполнение вкладки Aimbot
local aimbotTab = TabFrames["Aimbot"]
createToggle(aimbotTab, "Enable Aimbot", Settings.Aimbot, "Enabled")
createToggle(aimbotTab, "Visible Check", Settings.Aimbot, "VisibleCheck")
createToggle(aimbotTab, "Team Check", Settings.Aimbot, "TeamCheck")
createSlider(aimbotTab, "Smoothness", Settings.Aimbot, "Smoothness", 0.1, 1, 0.5)
createSlider(aimbotTab, "FOV", Settings.Aimbot, "FOV", 10, 500, 100)

-- Заполнение вкладки ESP
local espTab = TabFrames["ESP"]
createToggle(espTab, "Enable ESP", Settings.ESP, "Enabled")
createToggle(espTab, "Box ESP", Settings.ESP, "Box")
createToggle(espTab, "Tracer", Settings.ESP, "Tracer")
createToggle(espTab, "Show Name", Settings.ESP, "Name")
createToggle(espTab, "Show Health", Settings.ESP, "Health")
createToggle(espTab, "Show Distance", Settings.ESP, "Distance")
createToggle(espTab, "Team Color", Settings.ESP, "TeamColor")
createSlider(espTab, "Max Distance", Settings.ESP, "MaxDistance", 100, 5000, 1000)

-- Заполнение вкладки Visuals
local visualsTab = TabFrames["Visuals"]
createToggle(visualsTab, "Crosshair", Settings.Visuals, "Crosshair")
createToggle(visualsTab, "FOV Circle", Settings.Visuals, "FOVCircle")
createToggle(visualsTab, "No Recoil", Settings.Visuals, "NoRecoil")
createToggle(visualsTab, "No Spread", Settings.Visuals, "NoSpread")

-- Заполнение вкладки Misc
local miscTab = TabFrames["Misc"]
createToggle(miscTab, "Speed Hack", Settings.Misc, "Speed")
createSlider(miscTab, "Speed Multiplier", Settings.Misc, "SpeedMultiplier", 1, 5, 2)
createToggle(miscTab, "High Jump", Settings.Misc, "JumpPower")
createSlider(miscTab, "Jump Multiplier", Settings.Misc, "JumpMultiplier", 1, 5, 1.5)

-- Утилитарные функции
local function isPlayerVisible(player)
    if not Settings.Aimbot.VisibleCheck then return true end
    
    local character = player.Character
    local localChar = LocalPlayer.Character
    
    if not character or not localChar then return false end
    
    local head = character:FindFirstChild("Head")
    local localHead = localChar:FindFirstChild("Head")
    
    if not head or not localHead then return false end
    
    local origin = localHead.Position
    local target = head.Position
    
    local direction = (target - origin).Unit
    local ray = Ray.new(origin, direction * (target - origin).Magnitude)
    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, {localChar, character})
    
    return not hit or hit:IsDescendantOf(character)
end

local function getClosestPlayer()
    local closestPlayer = nil
    local closestDistance = Settings.Aimbot.FOV
    
    local mousePos = UserInputService:GetMouseLocation()
    local cameraPos = Camera.CFrame.Position
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if Settings.Aimbot.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local character = player.Character
            local humanoidRootPart = character.HumanoidRootPart
            local head = character:FindFirstChild("Head")
            
            if not humanoidRootPart then continue end
            
            local screenPoint, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
            
            if onScreen then
                local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                
                if distance < closestDistance then
                    if isPlayerVisible(player) then
                        closestPlayer = player
                        closestDistance = distance
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

-- Функция ESP
local function createESP(player)
    if ESPObjects[player] then return end
    
    local esp = {
        Box = nil,
        Tracer = nil,
        Name = nil,
        Health = nil,
        Distance = nil
    }
    
    ESPObjects[player] = esp
    
    local function updateESP()
        if not Settings.ESP.Enabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            for _, obj in pairs(esp) do
                if obj then obj.Visible = false end
            end
            return
        end
        
        local character = player.Character
        local humanoidRootPart = character.HumanoidRootPart
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if not humanoidRootPart then return end
        
        local screenPoint, onScreen = Camera:WorldToViewportPoint(humanoidRootPart.Position)
        
        if not onScreen or (humanoidRootPart.Position - Camera.CFrame.Position).Magnitude > Settings.ESP.MaxDistance then
            for _, obj in pairs(esp) do
                if obj then obj.Visible = false end
            end
            return
        end
        
        local color = Settings.ESP.TeamColor and player.TeamColor.Color or Color3.fromRGB(255, 0, 0)
        
        -- Box ESP
        if Settings.ESP.Box then
            if not esp.Box then
                esp.Box = Instance.new("Frame")
                esp.Box.BackgroundTransparency = 1
                esp.Box.BorderColor3 = color
                esp.Box.BorderSizePixel = 2
                esp.Box.ZIndex = 10
                esp.Box.Parent = ScreenGui
            end
            
            local head = character:FindFirstChild("Head")
            local root = humanoidRootPart
            
            if head and root then
                local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position)
                local rootPos = screenPoint
                
                if headOnScreen then
                    local height = math.abs(headPos.Y - rootPos.Y) * 1.5
                    local width = height / 2
                    
                    esp.Box.Size = UDim2.new(0, width, 0, height)
                    esp.Box.Position = UDim2.new(0, rootPos.X - width/2, 0, rootPos.Y - height/2)
                    esp.Box.Visible = true
                end
            end
        elseif esp.Box then
            esp.Box.Visible = false
        end
        
        -- Tracer
        if Settings.ESP.Tracer then
            if not esp.Tracer then
                esp.Tracer = Instance.new("Frame")
                esp.Tracer.BackgroundColor3 = color
                esp.Tracer.BorderSizePixel = 0
                esp.Tracer.ZIndex = 10
                esp.Tracer.Parent = ScreenGui
            end
            
            esp.Tracer.Size = UDim2.new(0, 1, 0, (screenPoint.Y - Camera.ViewportSize.Y/2))
            esp.Tracer.Position = UDim2.new(0, screenPoint.X, 0, Camera.ViewportSize.Y/2)
            esp.Tracer.Rotation = 180
            esp.Tracer.Visible = true
        elseif esp.Tracer then
            esp.Tracer.Visible = false
        end
        
        -- Name
        if Settings.ESP.Name then
            if not esp.Name then
                esp.Name = Instance.new("TextLabel")
                esp.Name.BackgroundTransparency = 1
                esp.Name.TextColor3 = color
                esp.Name.Font = Enum.Font.GothamBold
                esp.Name.TextSize = 14
                esp.Name.ZIndex = 10
                esp.Name.Parent = ScreenGui
            end
            
            esp.Name.Text = player.Name
            esp.Name.Position = UDim2.new(0, screenPoint.X, 0, screenPoint.Y - 50)
            esp.Name.Visible = true
        elseif esp.Name then
            esp.Name.Visible = false
        end
        
        -- Health
        if Settings.ESP.Health and humanoid then
            if not esp.Health then
                esp.Health = Instance.new("TextLabel")
                esp.Health.BackgroundTransparency = 1
                esp.Health.TextColor3 = Color3.fromRGB(0, 255, 0)
                esp.Health.Font = Enum.Font.Gotham
                esp.Health.TextSize = 12
                esp.Health.ZIndex = 10
                esp.Health.Parent = ScreenGui
            end
            
            esp.Health.Text = "HP: " .. math.floor(humanoid.Health) .. "/" .. humanoid.MaxHealth
            esp.Health.Position = UDim2.new(0, screenPoint.X, 0, screenPoint.Y - 35)
            esp.Health.Visible = true
        elseif esp.Health then
            esp.Health.Visible = false
        end
        
        -- Distance
        if Settings.ESP.Distance then
            if not esp.Distance then
                esp.Distance = Instance.new("TextLabel")
                esp.Distance.BackgroundTransparency = 1
                esp.Distance.TextColor3 = Color3.fromRGB(255, 255, 255)
                esp.Distance.Font = Enum.Font.Gotham
                esp.Distance.TextSize = 12
                esp.Distance.ZIndex = 10
                esp.Distance.Parent = ScreenGui
            end
            
            local distance = (humanoidRootPart.Position - Camera.CFrame.Position).Magnitude
            esp.Distance.Text = math.floor(distance) .. " studs"
            esp.Distance.Position = UDim2.new(0, screenPoint.X, 0, screenPoint.Y - 20)
            esp.Distance.Visible = true
        elseif esp.Distance then
            esp.Distance.Visible = false
        end
    end
    
    Connections[player] = RunService.RenderStepped:Connect(updateESP)
end

-- Функция удаления ESP
local function removeESP(player)
    if Connections[player] then
        Connections[player]:Disconnect()
        Connections[player] = nil
    end
    
    if ESPObjects[player] then
        for _, obj in pairs(ESPObjects[player]) do
            if obj then obj:Destroy() end
        end
        ESPObjects[player] = nil
    end
end

-- Инициализация ESP для всех игроков
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    createESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- Aimbot логика
local aimbotConnection = RunService.RenderStepped:Connect(function()
    if Settings.Aimbot.Enabled and UserInputService:IsKeyDown(Enum.KeyCode[Settings.Aimbot.Key]) then
        Target = getClosestPlayer()
        
        if Target and Target.Character then
            local character = Target.Character
            local targetPart = nil
            
            if Settings.Aimbot.Priority == "Head" then
                targetPart = character:FindFirstChild("Head")
            elseif Settings.Aimbot.Priority == "Torso" then
                targetPart = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
            else
                targetPart = character:FindFirstChild("HumanoidRootPart")
            end
            
            if targetPart then
                local camera = Camera
                local currentCFrame = camera.CFrame
                local targetPosition = targetPart.Position
                
                local smoothness = Settings.Aimbot.Smoothness
                local newCFrame = CFrame.new(
                    currentCFrame.Position:Lerp(targetPosition, smoothness),
                    targetPosition
                )
                
                camera.CFrame = newCFrame
            end
        end
    else
        Target = nil
    end
end)

-- Визуальные эффекты
local crosshair = Instance.new("Frame")
crosshair.Size = UDim2.new(0, 10, 0, 10)
crosshair.Position = UDim2.new(0.5, -5, 0.5, -5)
crosshair.BackgroundTransparency = 1
crosshair.BorderSizePixel = 0
crosshair.ZIndex = 20
crosshair.Visible = false
crosshair.Parent = ScreenGui

local crosshairLine1 = Instance.new("Frame")
crosshairLine1.Size = UDim2.new(0, 1, 0, 10)
crosshairLine1.Position = UDim2.new(0.5, 0, 0.5, -5)
crosshairLine1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
crosshairLine1.BorderSizePixel = 0
crosshairLine1.Parent = crosshair

local crosshairLine2 = Instance.new("Frame")
crosshairLine2.Size = UDim2.new(0, 10, 0, 1)
crosshairLine2.Position = UDim2.new(0.5, -5, 0.5, 0)
crosshairLine2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
crosshairLine2.BorderSizePixel = 0
crosshairLine2.Parent = crosshair

local fovCircle = Instance.new("Frame")
fovCircle.Size = UDim2.new(0, Settings.Aimbot.FOV * 2, 0, Settings.Aimbot.FOV * 2)
fovCircle.Position = UDim2.new(0.5, -Settings.Aimbot.FOV, 0.5, -Settings.Aimbot.FOV)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderColor3 = Color3.fromRGB(255, 255, 255)
fovCircle.BorderSizePixel = 1
fovCircle.ZIndex = 5
fovCircle.Visible = false
fovCircle.Parent = ScreenGui

-- Обновление визуальных элементов
RunService.RenderStepped:Connect(function()
    crosshair.Visible = Settings.Visuals.Crosshair
    fovCircle.Visible = Settings.Visuals.FOVCircle and Settings.Aimbot.Enabled
    fovCircle.Size = UDim2.new(0, Settings.Aimbot.FOV * 2, 0, Settings.Aimbot.FOV * 2)
    fovCircle.Position = UDim2.new(0.5, -Settings.Aimbot.FOV, 0.5, -Settings.Aimbot.FOV)
end)

-- Misc функции
local originalWalkSpeed = 16
local originalJumpPower = 50

local function updateMisc()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if Settings.Misc.Speed then
                humanoid.WalkSpeed = originalWalkSpeed * Settings.Misc.SpeedMultiplier
            else
                humanoid.WalkSpeed = originalWalkSpeed
            end
            
            if Settings.Misc.JumpPower then
                humanoid.JumpPower = originalJumpPower * Settings.Misc.JumpMultiplier
            else
                humanoid.JumpPower = originalJumpPower
            end
        end
    end
end

-- Управление меню
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed then
        if input.KeyCode == Enum.KeyCode[ToggleKey] then
            MenuOpen = not MenuOpen
            MainFrame.Visible = MenuOpen
        end
    end
end)

-- Основной цикл
RunService.RenderStepped:Connect(updateMisc)

-- Информация об использовании
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0, 300, 0, 40)
infoLabel.Position = UDim2.new(1, -310, 0, 10)
infoLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 40, 0.7)
infoLabel.BackgroundTransparency = 0.3
infoLabel.Text = "Menu: " .. ToggleKey .. "\nAimbot: " .. Settings.Aimbot.Key
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 12
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = ScreenGui

-- Уведомление о загрузке
print("Roblox Exploit Script loaded successfully!")
print("Press " .. ToggleKey .. " to open menu")
print("Hold " .. Settings.Aimbot.Key .. " to use aimbot")
print("This script is for educational purposes only!")

-- Очистка при выходе
game:GetService("CoreGui").ChildRemoved:Connect(function(child)
    if child == ScreenGui then
        for _, connection in pairs(Connections) do
            connection:Disconnect()
        end
        aimbotConnection:Disconnect()
    end
end)
