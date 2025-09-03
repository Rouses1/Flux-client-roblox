local FluxClient = {}

-- Сервисы
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Основной GUI объект
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FluxClientUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Переменные для управления состоянием
local menuOpen = false
local menuFrame = nil
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil

-- Функция для создания переливающегося текста
local function createShimmeringText(label)
    local shimmer = 0
    local increasing = true
    
    coroutine.wrap(function()
        while label and label.Parent do
            wait(0.05)
            
            if increasing then
                shimmer = shimmer + 0.05
                if shimmer >= 1 then
                    shimmer = 1
                    increasing = false
                end
            else
                shimmer = shimmer - 0.05
                if shimmer <= 0 then
                    shimmer = 0
                    increasing = true
                end
            end
            
            label.TextColor3 = Color3.new(shimmer, shimmer, shimmer)
        end
    end)()
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
    keyWindow.ZIndex = 2

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
    title.ZIndex = 3
    
    -- Создаем переливающийся эффект для заголовка
    createShimmeringText(title)

    local inputLabel = Instance.new("TextLabel")
    inputLabel.Name = "InputLabel"
    inputLabel.Size = UDim2.new(1, 0, 0, 20)
    inputLabel.Position = UDim2.new(0, 0, 0, 50)
    inputLabel.BackgroundTransparency = 1
    inputLabel.Text = "Enter key:"
    inputLabel.Font = Enum.Font.Gotham
    inputLabel.TextSize = 16
    inputLabel.TextColor3 = Color3.new(1, 1, 1)
    inputLabel.Parent = keyWindow
    inputLabel.ZIndex = 3

    local inputField = Instance.new("TextBox")
    inputField.Name = "KeyInput"
    inputField.Size = UDim2.new(0, 260, 0, 40)
    inputField.Position = UDim2.new(0, 20, 0, 70)
    inputField.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    inputField.BorderSizePixel = 1
    inputField.BorderColor3 = Color3.new(1, 1, 1)
    inputField.Text = ""
    inputField.PlaceholderText = "Enter your key here"
    inputField.Font = Enum.Font.Gotham
    inputField.TextSize = 18
    inputField.TextColor3 = Color3.new(1, 1, 1)
    inputField.Parent = keyWindow
    inputField.ZIndex = 3

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
    submitButton.ZIndex = 3

    submitButton.MouseButton1Click:Connect(function()
        -- Здесь будет проверка ключа
        if inputField.Text == "SECRET_KEY" then -- Замените на свою проверку ключа
            keyWindow.Visible = false
            self:CreateMenuButton()
        else
            -- Эффект неправильного ключа
            local originalColor = inputField.BackgroundColor3
            for i = 1, 3 do
                inputField.BackgroundColor3 = Color3.new(0.5, 0, 0)
                wait(0.1)
                inputField.BackgroundColor3 = originalColor
                wait(0.1)
            end
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
    menuButton.ZIndex = 2

    -- Функция для обновления позиции при перетаскивании
    local function update(input)
        local delta = input.Position - dragStart
        menuButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    -- Обработка начала перетаскивания
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

    -- Обработка изменения ввода (для перетаскивания)
    menuButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    -- Обработка перемещения мыши/тача
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Функция для открытия/закрытия меню
    local function toggleMenu()
        if menuOpen then
            if menuFrame then
                menuFrame:Destroy()
                menuFrame = nil
            end
            menuOpen = false
            menuButton.Text = "Open Menu"
        else
            -- Создаем меню
            menuFrame = Instance.new("Frame")
            menuFrame.Name = "MenuFrame"
            menuFrame.Size = UDim2.new(0, 300, 0, 400)
            menuFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
            menuFrame.BackgroundColor3 = Color3.new(0, 0, 0)
            menuFrame.BackgroundTransparency = 0.2
            menuFrame.BorderSizePixel = 2
            menuFrame.BorderColor3 = Color3.new(1, 1, 1)
            menuFrame.Parent = screenGui
            menuFrame.ZIndex = 2

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
            menuTitle.ZIndex = 3
            
            -- Переливающийся эффект для заголовка меню
            createShimmeringText(menuTitle)
            
            -- Пример элемента меню
            local testButton = Instance.new("TextButton")
            testButton.Name = "TestButton"
            testButton.Size = UDim2.new(0, 280, 0, 40)
            testButton.Position = UDim2.new(0, 10, 0, 50)
            testButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            testButton.BorderSizePixel = 1
            testButton.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
            testButton.Text = "Test Feature"
            testButton.Font = Enum.Font.Gotham
            testButton.TextSize = 16
            testButton.TextColor3 = Color3.new(1, 1, 1)
            testButton.Parent = menuFrame
            testButton.ZIndex = 3
            
            testButton.MouseButton1Click:Connect(function()
                print("Test feature activated!")
            end)
            
            menuOpen = true
            menuButton.Text = "Close Menu"
        end
    end

    -- Обработка клика по кнопке меню
    menuButton.MouseButton1Click:Connect(toggleMenu)
end

-- Инициализация
function FluxClient:Init()
    self:CreateKeyWindow()
end

-- Запуск клиента
FluxClient:Init()

return FluxClientfunction FluxClient:CreateMenuButton()
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
