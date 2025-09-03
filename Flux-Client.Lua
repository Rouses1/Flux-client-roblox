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
    Size = UDim2.new(0, 520, 0, 340),
    Position = UDim2.new(0.5, -260, 0.5, -170),
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

-- Player List
local playerListFrame = new("Frame", {
    Parent = screenGui,
    Size = UDim2.new(0, 150, 0, 180),
    Position = UDim2.new(1, -160, 0, 10),
    BackgroundColor3 = MAIN_COLOR,
    BackgroundTransparency = 0.4,
})
new("UICorner", {Parent = playerListFrame, CornerRadius = UDim.new(0,6)})

local titleLabel = new("TextLabel", {
    Parent = playerListFrame,
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "Players",
    Font = Enum.Font.SourceSansBold,
    TextSize = 16,
    TextColor3 = TEXT_COLOR,
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
                TextColor3 = TEXT_COLOR,
                TextXAlignment = Enum.TextXAlignment.Center,
            })
            totalHeight = totalHeight + 18
        end
    end
    
    playerListScrolling.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- UI Кнопки
local btnWidth = 0.4
local btnHeight = 28
local btnSpacingY = 30
local buttons = {}

local function createToggleButton(name, positionX, positionY)
    local button = new("TextButton", {
        Parent = window,
        Size = UDim2.new(btnWidth, 0, 0, btnHeight),
        Position = UDim2.new(positionX, 0, 0, positionY),
        BackgroundColor3 = BUTTON_COLOR,
        BackgroundTransparency = 0,
        Text = name,
        Font = Enum.Font.SourceSans,
        TextSize = 16,
        TextColor3 = TEXT_COLOR,
        Name = name,
    })
    new("UICorner", {Parent = button, CornerRadius = UDim.new(0,6)})
    table.insert(buttons, button)
    return button
end

-- Создаем кнопки в алфавитном порядке
local currentY = 85

-- Aimbot
createToggleButton("Aimbot", 0.05, currentY)

-- Anti Knockback
createToggleButton("Anti Knockback", 0.55, currentY)

currentY = currentY + btnSpacingY

-- ESP
createToggleButton("ESP", 0.05, currentY)

-- ESP Objects
createToggleButton("ESP Objects", 0.55, currentY)

currentY = currentY + btnSpacingY

-- Hitbox
createToggleButton("Hitbox", 0.05, currentY)

-- Infinity Jump
createToggleButton("Infinity Jump", 0.55, currentY)

currentY = currentY + btnSpacingY

-- Night Vision
createToggleButton("Night Vision", 0.05, currentY)

-- No Fall
createToggleButton("No Fall", 0.55, currentY)

currentY = currentY + btnSpacingY

-- Silent Aim
createToggleButton("Silent Aim", 0.05, currentY)

-- Speed
createToggleButton("Speed", 0.55, currentY)

currentY = currentY + btnSpacingY

-- Spider
createToggleButton("Spider", 0.05, currentY)

-- Tracer
createToggleButton("Tracer", 0.55, currentY)

currentY = currentY + btnSpacingY

-- Trigger Bot
createToggleButton("Trigger Bot", 0.05, currentY)

-- Wallhack
createToggleButton("Wallhack", 0.55, currentY)

-- Поиск по функциям
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local searchText = string.lower(searchBox.Text)
    
    for _, button in ipairs(buttons) do
        local buttonText = string.lower(button.Text)
        if string.find(buttonText, searchText) then
            button.Visible = true
        else
            button.Visible = searchText == ""
        end
    end
end)

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
