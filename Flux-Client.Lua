local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

-- Utility function
local function new(className, props)
    local obj = Instance.new(className)
    if props then
        for k,v in pairs(props) do
            obj[k] = v
        end
    end
    return obj
end

-- ScreenGui
local screenGui = new("ScreenGui", {
    Name = "BloodXGUI",
    ResetOnSpawn = false,
    Parent = playerGui,
})

-- Floating button
local floatBtn = new("Frame", {
    Name = "FloatButton",
    Parent = screenGui,
    Size = UDim2.new(0, 60, 0, 60),
    Position = UDim2.new(0.02, 0, 0.5, -30),
    BackgroundColor3 = Color3.fromRGB(0,0,0),
    BackgroundTransparency = 0.25,
    ZIndex = 10,
})
new("UICorner",{Parent = floatBtn, CornerRadius = UDim.new(0,12)})

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

-- Main menu window
local window = new("Frame", {
    Name = "MainWindow",
    Parent = screenGui,
    Size = UDim2.new(0, 520, 0, 340),
    Position = UDim2.new(0.5, -260, 0.5, -170),
    Visible = false,
    BackgroundColor3 = Color3.fromRGB(20,20,20),
    BackgroundTransparency = 0.2,
    ZIndex = 9,
})
new("UICorner",{Parent = window, CornerRadius = UDim.new(0,10)})
new("UIStroke",{Parent = window, Color = Color3.fromRGB(50,50,50), Thickness = 2})

-- Header
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
    Text = "BloodX",
    Font = Enum.Font.SourceSansSemibold,
    TextSize = 18,
    TextColor3 = Color3.fromRGB(255,255,255),
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- Color pulse animation
local pulseSpeed = 2
local pulseConnection
pulseConnection = RunService.Heartbeat:Connect(function(dt)
    local time = os.clock() * pulseSpeed
    local lerpValue = (math.sin(time) + 1) / 2
    title.TextColor3 = Color3.new(lerpValue, lerpValue, lerpValue)
end)

-- Close button
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

-- Toggle buttons
btn.MouseButton1Click:Connect(function()
    window.Visible = not window.Visible
end)

btnClose.MouseButton1Click:Connect(function()
    window.Visible = false
end)

-- Cleanup
screenGui.Destroying:Connect(function()
    pulseConnection:Disconnect()
end)

-- ESP, Tracers, Aimbot and Crosshair features
local espEnabled = false
local tracersEnabled = false
local aimbotEnabled = false
local crosshairEnabled = false

local espParts = {}
local tracerLines = {}
local aimbotTarget = nil
local originalMouseIconEnabled = true

-- Custom crosshair
local crosshair = new("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 12, 0, 12),
    Position = UDim2.new(0.5, -6, 0.5, -6),
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 20,
})

local crosshairH = new("Frame", {
    Parent = crosshair,
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 0.5, -0.5),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel = 0,
})

local crosshairV = new("Frame", {
    Parent = crosshair,
    Size = UDim2.new(0, 1, 1, 0),
    Position = UDim2.new(0.5, -0.5, 0, 0),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BorderSizePixel = 0,
})

-- Function to create ESP box for a player
local function createEsp(player)
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local head = character:WaitForChild("Head")
    
    local box = new("BoxHandleAdornment", {
        Name = "ESP_"..player.Name,
        Adornee = humanoidRootPart,
        AlwaysOnTop = true,
        ZIndex = 0,
        Size = Vector3.new(4, 6, 4),
        Color3 = Color3.new(1, 1, 1),
        Transparency = 0.3,
        Parent = humanoidRootPart,
    })
    
    local tracer = new("LineHandleAdornment", {
        Name = "Tracer_"..player.Name,
        Adornee = humanoidRootPart,
        AlwaysOnTop = true,
        ZIndex = 0,
        Length = (camera.CFrame.Position - humanoidRootPart.Position).Magnitude,
        Color3 = Color3.new(1, 1, 1),
        Transparency = 0.3,
        Thickness = 1,
        Parent = humanoidRootPart,
    })
    
    espParts[player] = box
    tracerLines[player] = tracer
    
    -- Update function
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Humanoid") or character.Humanoid.Health <= 0 then
            connection:Disconnect()
            if box then box:Destroy() end
            if tracer then tracer:Destroy() end
            espParts[player] = nil
            tracerLines[player] = nil
            return
        end
        
        if espEnabled and box then
            box.Adornee = humanoidRootPart
            box.Visible = true
        elseif box then
            box.Visible = false
        end
        
        if tracersEnabled and tracer then
            tracer.Adornee = humanoidRootPart
            tracer.Length = (camera.CFrame.Position - humanoidRootPart.Position).Magnitude
            tracer.CFrame = CFrame.new(humanoidRootPart.Position, camera.CFrame.Position)
            tracer.Visible = true
        elseif tracer then
            tracer.Visible = false
        end
    end)
    
    character:WaitForChild("Humanoid").Died:Connect(function()
        if box then box:Destroy() end
        if tracer then tracer:Destroy() end
        espParts[player] = nil
        tracerLines[player] = nil
        connection:Disconnect()
    end)
end

-- Initialize ESP for existing players
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        coroutine.wrap(createEsp)(player)
    end
end

-- Handle new players
Players.PlayerAdded:Connect(function(player)
    coroutine.wrap(createEsp)(player)
end)

-- Handle player leaving
Players.PlayerRemoving:Connect(function(player)
    if espParts[player] then
        espParts[player]:Destroy()
        espParts[player] = nil
    end
    if tracerLines[player] then
        tracerLines[player]:Destroy()
        tracerLines[player] = nil
    end
end)

-- Aimbot function
local function findClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    local cameraPosition = camera.CFrame.Position
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer and player.Character then
            local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
            local humanoid = player.Character:FindFirstChild("Humanoid")
            
            if humanoidRootPart and humanoid and humanoid.Health > 0 then
                local distance = (humanoidRootPart.Position - cameraPosition).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer
end

-- Aimbot targeting
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if aimbotEnabled and input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimbotTarget = findClosestPlayer()
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if aimbotEnabled and input.UserInputType == Enum.UserInputType.MouseButton2 then
        aimbotTarget = nil
    end
end)

-- Aimbot tracking
RunService.Heartbeat:Connect(function()
    if aimbotEnabled and aimbotTarget and aimbotTarget.Character then
        local humanoidRootPart = aimbotTarget.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            local camera = Workspace.CurrentCamera
            local targetPosition = humanoidRootPart.Position + Vector3.new(0, 1.5, 0) -- Aim at head level
            
            -- Calculate direction to target
            local direction = (targetPosition - camera.CFrame.Position).Unit
            local lookAt = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + direction)
            
            -- Apply the new CFrame to the camera
            camera.CFrame = lookAt
        end
    end
end)

-- Toggle functions
local function toggleEsp()
    espEnabled = not espEnabled
    for player, part in pairs(espParts) do
        part.Visible = espEnabled and (player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0)
    end
    return espEnabled
end

local function toggleTracers()
    tracersEnabled = not tracersEnabled
    for player, line in pairs(tracerLines) do
        line.Visible = tracersEnabled and (player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0)
    end
    return tracersEnabled
end

local function toggleAimbot()
    aimbotEnabled = not aimbotEnabled
    if not aimbotEnabled then
        aimbotTarget = nil
    end
    return aimbotEnabled
end

local function toggleCrosshair()
    crosshairEnabled = not crosshairEnabled
    crosshair.Visible = crosshairEnabled
    
    -- Hide Roblox crosshair
    if crosshairEnabled then
        originalMouseIconEnabled = UserInputService.MouseIconEnabled
        UserInputService.MouseIconEnabled = false
        if player.PlayerGui:FindFirstChild("Crosshair") then
            player.PlayerGui.Crosshair.Enabled = false
        end
    else
        UserInputService.MouseIconEnabled = originalMouseIconEnabled
        if player.PlayerGui:FindFirstChild("Crosshair") then
            player.PlayerGui.Crosshair.Enabled = true
        end
    end
    
    return crosshairEnabled
end

-- Add buttons to GUI for toggling features
local buttonContainer = new("Frame", {
    Parent = window,
    Size = UDim2.new(1, -20, 1, -60),
    Position = UDim2.new(0, 10, 0, 50),
    BackgroundTransparency = 1,
})

local function createToggleButton(name, position, toggleFunction)
    local button = new("TextButton", {
        Parent = buttonContainer,
        Size = UDim2.new(0.45, 0, 0, 40),
        Position = position,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Text = name,
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(255, 255, 255),
    })
    
    new("UICorner", {Parent = button, CornerRadius = UDim.new(0, 5)})
    new("UIStroke", {Parent = button, Color = Color3.fromRGB(80, 80, 80), Thickness = 1})
    
    local state = false
    
    button.MouseButton1Click:Connect(function()
        state = toggleFunction()
        button.BackgroundColor3 = state and Color3.fromRGB(60, 60, 60) or Color3.fromRGB(30, 30, 30)
        button.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    end)
    
    return button
end

-- Create toggle buttons
createToggleButton("ESP", UDim2.new(0, 0, 0, 0), toggleEsp)
createToggleButton("Tracers", UDim2.new(0.55, 0, 0, 0), toggleTracers)
createToggleButton("Aimbot", UDim2.new(0, 0, 0, 50), toggleAimbot)
createToggleButton("Crosshair", UDim2.new(0.55, 0, 0, 50), toggleCrosshair)
