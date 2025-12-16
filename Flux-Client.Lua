-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
local OpenButton = Instance.new("TextButton")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")

-- Родитель GUI
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "BloodX_Menu"

-- Кнопка Open
OpenButton.Parent = ScreenGui
OpenButton.Text = "Open"
OpenButton.Size = UDim2.new(0, 100, 0, 40)
OpenButton.Position = UDim2.new(0, 20, 0, 20)
OpenButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OpenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenButton.Font = Enum.Font.GothamBold
OpenButton.TextSize = 20
UICorner:Clone().Parent = OpenButton

-- Главное меню
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0.6, 0, 0.6, 0)
MainFrame.Position = UDim2.new(0.2, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Visible = false
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 15)
frameCorner.Parent = MainFrame

-- Заголовок
Title.Parent = MainFrame
Title.Text = "BloodX"
Title.Size = UDim2.new(0, 200, 0, 50)
Title.Position = UDim2.new(0, 20, 0, 10)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 36
Title.BackgroundTransparency = 1

-- Перелив текста
task.spawn(function()
	local t = 0
	while task.wait(0.03) do
		t += 0.03
		local c = math.abs(math.sin(t))
		Title.TextColor3 = Color3.fromRGB(255*c, 255*c, 255*c) -- черно-белый перелив
	end
end)

-- Анимация открытия
local TweenService = game:GetService("TweenService")
OpenButton.MouseButton1Click:Connect(function()
	if MainFrame.Visible == false then
		MainFrame.Visible = true
		MainFrame.BackgroundTransparency = 1
		local tween = TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
		tween:Play()
	else
		local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
		tween:Play()
		tween.Completed:Wait()
		MainFrame.Visible = false
	end
end)
