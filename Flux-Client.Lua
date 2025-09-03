local FluxClient = {}

-- Сервисы
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Основной GUI объект
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FluxClientUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Функция для создания переливающегося текста
local function createShimmeringText(label)
    local shimmer = 0
    local increasing = true
    
    local connection
    connection = RunService.RenderStepped:Connect(function(delta)
        if not label or not label.Parent then
            connection:Disconnect()
            return
        end
        
        if increasing then
            shimmer = shimmer + delta * 0.5
            if shimmer >= 1 then
                shimmer = 1
                increasing = false
            end
        else
            shimmer = shimmer - delta * 0.5
            if shimmer <= 0 then
                shimmer = 0
                increasing = true
            end
        end
        
        label.TextColor3 = Color3.new(shimmer, shimmer, shimmer)
    end)
end

-- Окно ввода ключа
function FluxClient:CreateKeyWindow()
    local keyWindow = Instance.new("Frame")
    keyWindow.Name = "KeyWindow"
    keyWindow.Size = UDim2.new(0, 300, 0, 180)
    keyWindow.Position = UDim2.new(0.5, -150, 0.5, -90)
    keyWindow.BackgroundColor3 = Color3.new(0, 0, 0)
    keyWindow.BorderSizePixel = 2
    keyWindow.BorderColor3 = Color3.new(1, 1, 1)
    keyWindow.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Flux Client"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Parent = keyWindow
    
    -- Создаем переливающийся эффект для заголовка
    createShimmeringText(title)

    local inputField = Instance.new("TextBox")
    inputField.Name = "KeyInput"
    inputField.Size = UDim2.new(0, 260, 0, 40)
    inputField.Position = UDim2.new(0, 20, 0, 70)
    inputField.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    inputField.BorderSizePixel = 1
    inputField.BorderColor3 = Color3.new(1, 1, 1)
    inputField.Text = ""
    inputField.PlaceholderText = "Enter key"
    inputField.Font = Enum.Font.Gotham
    inputField.TextSize = 18
    inputField.TextColor3 = Color3.new(1, 1, 1)
    inputField.Parent = keyWindow

    local submitButton = Instance.new("TextButton")
    submitButton.Name = "SubmitButton"
    submitButton.Size = UDim2.new(0, 120, 0, 35)
    submitButton.Position = UDim2.new(0.5, -60, 0, 125)
    submitButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    submitButton.BorderSizePixel = 1
    submitButton.BorderColor3 = Color3.new(1, 1, 1)
    submitButton.Text = "Submit"
    submitButton.Font = Enum.Font.Gotham
    submitButton.TextSize = 18
    submitButton.TextColor3 = Color3.new(1, 1, 1)
    submitButton.Parent = keyWindow

    submitButton.MouseButton1Click:Connect(function()
        -- Здесь будет проверка ключа
        if inputField.Text == "SECRET_KEY" then -- Замените на свою проверку ключа
            keyWindow.Visible = false
            self:CreateMenuButton()
        else
            -- Эффект неправильного ключа
            local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 5, true)
            local tween = TweenService:Create(inputField, tweenInfo, {BackgroundColor3 = Color3.new(0.5, 0, 0)})
            tween:Play()
        end
    end)
end

-- Кнопка открытия меню
function FluxClient:CreateMenuButton()
    local menuButton = Instance.new("TextButton")
    menuButton.Name = "MenuButton"
    menuButton.Size = UDim2.new(0, 100, 0, 40)
    menuButton.Position = UDim2.new(0, 20, 0, 20)
    menuButton.BackgroundColor3 = Color3.new(0, 0, 0)
    menuButton.BorderSizePixel = 2
    menuButton.BorderColor3 = Color3.new(1, 1, 1)
    menuButton.Text = "Open Menu"
    menuButton.Font = Enum.Font.Gotham
    menuButton.TextSize = 16
    menuButton.TextColor3 = Color3.new(1, 1, 1)
    menuButton.Parent = screenGui

    -- Перетаскивание кнопки
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        menuButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    menuButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = menuButton.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    menuButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Меню
    local menuOpen = false
    local menuFrame

    menuButton.MouseButton1Click:Connect(function()
        if menuOpen then
            menuFrame:Destroy()
            menuOpen = false
        else
            menuFrame = Instance.new("Frame")
            menuFrame.Name = "MenuFrame"
            menuFrame.Size = UDim2.new(0, 300, 0, 400)
            menuFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
            menuFrame.BackgroundColor3 = Color3.new(0, 0, 0)
            menuFrame.BackgroundTransparency = 0.2
            menuFrame.BorderSizePixel = 2
            menuFrame.BorderColor3 = Color3.new(1, 1, 1)
            menuFrame.Parent = screenGui

            local menuTitle = Instance.new("TextLabel")
            menuTitle.Name = "MenuTitle"
            menuTitle.Size = UDim2.new(0, 200, 0, 30)
            menuTitle.Position = UDim2.new(0, 10, 0, 10)
            menuTitle.BackgroundTransparency = 1
            menuTitle.Text = "Flux Client"
            menuTitle.Font = Enum.Font.GothamBold
            menuTitle.TextSize = 20
            menuTitle.TextXAlignment = Enum.TextXAlignment.Left
            menuTitle.TextColor3 = Color3.new(1, 1, 1)
            menuTitle.Parent = menuFrame
            
            -- Переливающийся эффект для заголовка меню
            createShimmeringText(menuTitle)

            -- Здесь можно добавить элементы меню (кнопки, переключатели и т.д.)
            
            menuOpen = true
        end
    end)
end

-- Инициализация
function FluxClient:Init()
    self:CreateKeyWindow()
end

return FluxClient
