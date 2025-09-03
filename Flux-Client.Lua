-- Flux Client Чит-меню для Roblox
-- Вставь этот код в исполнитель (Executor)

local Flux = {}

-- Сервисы
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

-- Локальный игрок
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Создаем интерфейс
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FluxClient"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Окно ввода ключа
local KeyWindow = Instance.new("Frame")
KeyWindow.Name = "KeyWindow"
KeyWindow.Size = UDim2.new(0, 300, 0, 180)
KeyWindow.Position = UDim2.new(0.5, -150, 0.5, -90)
KeyWindow.BackgroundColor3 = Color3.new(0, 0, 0)
KeyWindow.BorderSizePixel = 2
KeyWindow.BorderColor3 = Color3.new(1, 1, 1)
KeyWindow.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 10)
Title.BackgroundTransparency = 1
Title.Text = "Flux Client"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Parent = KeyWindow

-- Анимация переливания текста
spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            Title.TextColor3 = Color3.new(i, i, i)
            wait(0.01)
        end
        for i = 1, 0, -0.01 do
            Title.TextColor3 = Color3.new(i, i, i)
            wait(0.01)
        end
    end
end)

local InputLabel = Instance.new("TextLabel")
InputLabel.Name = "InputLabel"
InputLabel.Size = UDim2.new(1, 0, 0, 20)
InputLabel.Position = UDim2.new(0, 0, 0, 50)
InputLabel.BackgroundTransparency = 1
InputLabel.Text = "Enter key:"
InputLabel.Font = Enum.Font.Gotham
InputLabel.TextSize = 16
InputLabel.TextColor3 = Color3.new(1, 1, 1)
InputLabel.Parent = KeyWindow

local KeyInput = Instance.new("TextBox")
KeyInput.Name = "KeyInput"
KeyInput.Size = UDim2.new(0, 260, 0, 40)
KeyInput.Position = UDim2.new(0, 20, 0, 70)
KeyInput.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
KeyInput.BorderSizePixel = 1
KeyInput.BorderColor3 = Color3.new(1, 1, 1)
KeyInput.Text = ""
KeyInput.PlaceholderText = "Enter FLUX-ACCESS-KEY"
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextSize = 18
KeyInput.TextColor3 = Color3.new(1, 1, 1)
KeyInput.Parent = KeyWindow

local SubmitButton = Instance.new("TextButton")
SubmitButton.Name = "SubmitButton"
SubmitButton.Size = UDim2.new(0, 120, 0, 35)
SubmitButton.Position = UDim2.new(0.5, -60, 0, 125)
SubmitButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
SubmitButton.BorderSizePixel = 1
SubmitButton.BorderColor3 = Color3.new(1, 1, 1)
SubmitButton.Text = "Submit"
SubmitButton.Font = Enum.Font.Gotham
SubmitButton.TextSize = 18
SubmitButton.TextColor3 = Color3.new(1, 1, 1)
SubmitButton.Parent = KeyWindow

-- Кнопка меню
local MenuButton = Instance.new("TextButton")
MenuButton.Name = "MenuButton"
MenuButton.Size = UDim2.new(0, 100, 0, 40)
MenuButton.Position = UDim2.new(0, 20, 0, 20)
MenuButton.BackgroundColor3 = Color3.new(0, 0, 0)
MenuButton.BorderSizePixel = 2
MenuButton.BorderColor3 = Color3.new(1, 1, 1)
MenuButton.Text = "Open Menu"
MenuButton.Font = Enum.Font.Gotham
MenuButton.TextSize = 16
MenuButton.TextColor3 = Color3.new(1, 1, 1)
MenuButton.Visible = false
MenuButton.Parent = ScreenGui

-- Функции чита
Flux.Noclip = false
Flux.Speed = false
Flux.Jump = false
Flux.Fly = false
Flux.Wallhack = false
Flux.XRay = false

-- Включение NoClip
function Flux:ToggleNoclip()
    self.Noclip = not self.Noclip
    if self.Noclip then
        LocalPlayer.Character.Humanoid:ChangeState(11)
    end
    return self.Noclip
end

-- Включение скорости
function Flux:ToggleSpeed()
    self.Speed = not self.Speed
    if self.Speed then
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
    else
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
    return self.Speed
end

-- Включение высокого прыжка
function Flux:ToggleJump()
    self.Jump = not self.Jump
    if self.Jump then
        LocalPlayer.Character.Humanoid.JumpPower = 100
    else
        LocalPlayer.Character.Humanoid.JumpPower = 50
    end
    return self.Jump
end

-- Включение полета
function Flux:ToggleFly()
    self.Fly = not self.Fly
    if self.Fly then
        local BodyGyro = Instance.new("BodyGyro")
        local BodyVelocity = Instance.new("BodyVelocity")
        
        BodyGyro.Parent = LocalPlayer.Character.HumanoidRootPart
        BodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
        
        BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        BodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
        
        spawn(function()
            while self.Fly do
                BodyGyro.CFrame = Workspace.CurrentCamera.CFrame
                BodyVelocity.Velocity = Workspace.CurrentCamera.CFrame.LookVector * 50
                wait()
            end
            BodyGyro:Destroy()
            BodyVelocity:Destroy()
        end)
    end
    return self.Fly
end

-- Включение Wallhack
function Flux:ToggleWallhack()
    self.Wallhack = not self.Wallhack
    if self.Wallhack then
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") and part.Transparency < 0.5 then
                part.LocalTransparencyModifier = 0.5
            end
        end
    else
        for _, part in pairs(Workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                part.LocalTransparencyModifier = 0
            end
        end
    end
    return self.Wallhack
end

-- Включение XRay
function Flux:ToggleXRay()
    self.XRay = not self.XRay
    if self.XRay then
        Lighting.GlobalShadows = false
    else
        Lighting.GlobalShadows = true
    end
    return self.XRay
end

-- Бессмертие
function Flux:GodMode()
    LocalPlayer.Character.Humanoid.MaxHealth = math.huge
    LocalPlayer.Character.Humanoid.Health = math.huge
end

-- Телепорт к игроку
function Flux:TeleportToPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:MoveTo(targetPlayer.Character.HumanoidRootPart.Position)
    end
end

-- Бесконечные деньги (работает не во всех играх)
function Flux:InfiniteMoney()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in pairs(leaderstats:GetChildren()) do
            if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                stat.Changed:Connect(function()
                    if stat.Value < 1000000 then
                        stat.Value = 1000000
                    end
                end)
            end
        end
    end
end

-- Анти-афк
function Flux:AntiAFK()
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

-- Открытие меню
function Flux:ToggleMenu()
    if not self.Menu then
        self.Menu = Instance.new("Frame")
        self.Menu.Name = "Menu"
        self.Menu.Size = UDim2.new(0, 300, 0, 400)
        self.Menu.Position = UDim2.new(0.1, 0, 0.1, 0)
        self.Menu.BackgroundColor3 = Color3.new(0, 0, 0)
        self.Menu.BackgroundTransparency = 0.2
        self.Menu.BorderSizePixel = 2
        self.Menu.BorderColor3 = Color3.new(1, 1, 1)
        self.Menu.Parent = ScreenGui
        
        local MenuTitle = Instance.new("TextLabel")
        MenuTitle.Name = "MenuTitle"
        MenuTitle.Size = UDim2.new(0, 200, 0, 30)
        MenuTitle.Position = UDim2.new(0, 10, 0, 10)
        MenuTitle.BackgroundTransparency = 1
        MenuTitle.Text = "Flux Client"
        MenuTitle.Font = Enum.Font.GothamBold
        MenuTitle.TextSize = 20
        MenuTitle.TextXAlignment = Enum.TextXAlignment.Left
        MenuTitle.TextColor3 = Color3.new(1, 1, 1)
        MenuTitle.Parent = self.Menu
        
        -- Анимация переливания текста меню
        spawn(function()
            while MenuTitle do
                for i = 0, 1, 0.01 do
                    if not MenuTitle then break end
                    MenuTitle.TextColor3 = Color3.new(i, i, i)
                    wait(0.01)
                end
                for i = 1, 0, -0.01 do
                    if not MenuTitle then break end
                    MenuTitle.TextColor3 = Color3.new(i, i, i)
                    wait(0.01)
                end
            end
        end)
        
        -- Кнопки функций
        local buttons = {
            {"Noclip", function() Flux:ToggleNoclip() end},
            {"Speed Hack", function() Flux:ToggleSpeed() end},
            {"High Jump", function() Flux:ToggleJump() end},
            {"Fly", function() Flux:ToggleFly() end},
            {"Wallhack", function() Flux:ToggleWallhack() end},
            {"XRay Vision", function() Flux:ToggleXRay() end},
            {"God Mode", function() Flux:GodMode() end},
            {"Anti-AFK", function() Flux:AntiAFK() end},
            {"Infinite Money", function() Flux:InfiniteMoney() end}
        }
        
        for i, btn in ipairs(buttons) do
            local button = Instance.new("TextButton")
            button.Name = btn[1]
            button.Size = UDim2.new(0, 280, 0, 30)
            button.Position = UDim2.new(0, 10, 0, 50 + (i-1)*35)
            button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            button.BorderSizePixel = 1
            button.BorderColor3 = Color3.new(0.8, 0.8, 0.8)
            button.Text = btn[1]
            button.Font = Enum.Font.Gotham
            button.TextSize = 16
            button.TextColor3 = Color3.new(1, 1, 1)
            button.Parent = self.Menu
            
            button.MouseButton1Click:Connect(btn[2])
        end
    else
        self.Menu.Visible = not self.Menu.Visible
    end
    MenuButton.Text = self.Menu and self.Menu.Visible and "Close Menu" or "Open Menu"
end

-- Перетаскивание кнопки меню
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MenuButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MenuButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MenuButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MenuButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Обработка ввода ключа
SubmitButton.MouseButton1Click:Connect(function()
    local key = KeyInput.Text:gsub("%s+", "")
    
    -- Проверка ключа (простая версия)
    if key == "FLUX-ACCESS-KEY" or key == "FLUX-7294-8816-3456" or key == "12345" then
        KeyWindow.Visible = false
        MenuButton.Visible = true
        Flux:ToggleMenu()
    else
        -- Анимация ошибки
        for i = 1, 3 do
            KeyInput.BackgroundColor3 = Color3.new(0.5, 0, 0)
            wait(0.1)
            KeyInput.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
            wait(0.1)
        end
    end
end)

-- NoClip цикл
spawn(function()
    while true do
        wait(0.1)
        if Flux.Noclip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end)

print("Flux Client loaded! Use key: FLUX-ACCESS-KEY")
