-- Flux Client — Минималистичный белый GUI (Mobile friendly)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

local settings = {
    espEnabled = true,
    tracersEnabled = true,
    offParticles = true,
    maxEntities = 30,
    theme = "white",
}

-- Save/load settings (simple storage)
local function getStorage()
    local s = PlayerGui:FindFirstChild("FluxSettings")
    if not s then
        s = Instance.new("StringValue")
        s.Name = "FluxSettings"
        s.Value = HttpService:JSONEncode(settings)
        s.Parent = PlayerGui
    end
    return s
end
local storage = getStorage()

local function loadSettings()
    local ok, data = pcall(function()
        return HttpService:JSONDecode(storage.Value)
    end)
    if ok and type(data)=="table" then
        for k,v in pairs(settings) do
            if data[k] ~= nil then settings[k] = data[k] end
        end
    else
        storage.Value = HttpService:JSONEncode(settings)
    end
end

local function saveSettings()
    storage.Value = HttpService:JSONEncode(settings)
end

loadSettings()

-- UI
local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.Name = "FluxClient"
screenGui.ResetOnSpawn = false

-- Helper: Rounded corners
local function roundCorner(inst, radius)
    local c = Instance.new("UICorner", inst)
    c.CornerRadius = UDim.new(0, radius or 12)
    return c
end

-- Floating button to toggle menu
local floatBtn = Instance.new("TextButton", screenGui)
floatBtn.Text = "Flux"
floatBtn.Font = Enum.Font.GothamBold
floatBtn.TextSize = 18
floatBtn.TextColor3 = Color3.new(0,0,0)
floatBtn.BackgroundColor3 = Color3.fromRGB(245,245,245)
floatBtn.Size = UDim2.new(0, 80, 0, 40)
floatBtn.Position = UDim2.new(1, -90, 0, 80)
roundCorner(floatBtn, 20)
floatBtn.ZIndex = 10

-- Main panel
local panel = Instance.new("Frame", screenGui)
panel.Size = UDim2.new(0, 260, 0, 280)
panel.Position = UDim2.new(1, -280, 0, 130)
panel.BackgroundColor3 = Color3.fromRGB(245,245,245)
roundCorner(panel, 24)
panel.Visible = false
panel.ZIndex = 10

-- Title
local title = Instance.new("TextLabel", panel)
title.Text = "Flux Client"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(30,30,30)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 36)
title.Position = UDim2.new(0, 0, 0, 12)

-- Toggle creation helper
local function createToggle(parent, text, initial)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -24, 0, 44)
    frame.Position = UDim2.new(0, 12, 0, 0)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", frame)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(40,40,40)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.65, 0, 1, 0)
    label.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.3, 0, 0.7, 0)
    btn.Position = UDim2.new(0.68, 0, 0.15, 0)
    btn.Text = initial and "ON" or "OFF"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = initial and Color3.fromRGB(0,150,0) or Color3.fromRGB(180,0,0)
    btn.BackgroundColor3 = initial and Color3.fromRGB(220,255,220) or Color3.fromRGB(255,220,220)
    roundCorner(btn, 12)

    return frame, btn
end

-- ESP toggle
local espFrame, espBtn = createToggle(panel, "ESP", settings.espEnabled)
espFrame.Position = UDim2.new(0, 12, 0, 70)

-- Tracers toggle
local trFrame, trBtn = createToggle(panel, "Tracers", settings.tracersEnabled)
trFrame.Position = UDim2.new(0, 12, 0, 120)

-- OffParticles toggle
local offFrame, offBtn = createToggle(panel, "OffParticles", settings.offParticles)
offFrame.Position = UDim2.new(0, 12, 0, 170)

-- Close button
local closeBtn = Instance.new("TextButton", panel)
closeBtn.Text = "Close"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.fromRGB(40,40,40)
closeBtn.BackgroundColor3 = Color3.fromRGB(230,230,230)
closeBtn.Size = UDim2.new(0.5, -16, 0, 36)
closeBtn.Position = UDim2.new(0, 12, 1, -50)
roundCorner(closeBtn, 18)

local applyBtn = Instance.new("TextButton", panel)
applyBtn.Text = "Apply"
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 16
applyBtn.TextColor3 = Color3.fromRGB(40,40,40)
applyBtn.BackgroundColor3 = Color3.fromRGB(230,230,230)
applyBtn.Size = UDim2.new(0.5, -16, 0, 36)
applyBtn.Position = UDim2.new(0.5, 4, 1, -50)
roundCorner(applyBtn, 18)

-- Toggle logic
espBtn.MouseButton1Click:Connect(function()
    settings.espEnabled = not settings.espEnabled
    espBtn.Text = settings.espEnabled and "ON" or "OFF"
    espBtn.TextColor3 = settings.espEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(180,0,0)
    espBtn.BackgroundColor3 = settings.espEnabled and Color3.fromRGB(220,255,220) or Color3.fromRGB(255,220,220)
end)

trBtn.MouseButton1Click:Connect(function()
    settings.tracersEnabled = not settings.tracersEnabled
    trBtn.Text = settings.tracersEnabled and "ON" or "OFF"
    trBtn.TextColor3 = settings.tracersEnabled and Color3.fromRGB(0,150,0) or Color3.fromRGB(180,0,0)
    trBtn.BackgroundColor3 = settings.tracersEnabled and Color3.fromRGB(220,255,220) or Color3.fromRGB(255,220,220)
end)

offBtn.MouseButton1Click:Connect(function()
    settings.offParticles = not settings.offParticles
    offBtn.Text = settings.offParticles and "ON" or "OFF"
    offBtn.TextColor3 = settings.offParticles and Color3.fromRGB(0,150,0) or Color3.fromRGB(180,0,0)
    offBtn.BackgroundColor3 = settings.offParticles and Color3.fromRGB(220,255,220) or Color3.fromRGB(255,220,220)
end)

-- Floating button toggle panel
floatBtn.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
    panel.Visible = false
end)

-- OffParticles toggle function (client-side only)
local savedEmitters = {}
local function toggleParticles(state)
    if state then
        savedEmitters = {}
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
                savedEmitters[v] = v.Enabled
                v.Enabled = false
            end
        end
    else
        for v, enabled in pairs(savedEmitters) do
            if v and v.Parent then v.Enabled = enabled end
        end
        savedEmitters = {}
    end
end

-- ESP visuals
local espGuis = {}

local function clearESP()
    for _, gui in pairs(espGuis) do
        if gui and gui.Parent then gui:Destroy() end
    end
    espGuis = {}
end

local function makeBillboard(part)
    if not part or not part.Parent then return nil end
    local b = Instance.new("BillboardGui", PlayerGui)
    b.Adornee = part
    b.Size = UDim2.new(0, 120, 0, 30)
    b.AlwaysOnTop = true
    local frame = Instance.new("Frame", b)
    frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    frame.BackgroundTransparency = 0.3
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BorderSizePixel = 0
    local label = Instance.new("TextLabel", frame)
    label.Text = part.Parent.Name or part.Name
    label.TextColor3 = Color3.fromRGB(30,30,30)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -10, 1, 0)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextStrokeTransparency = 1
    return b
end

local function getEntities()
    local res = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent and obj.Parent:FindFirstChild("Humanoid") then
            table.insert(res, obj)
        end
    end
    return res
end

local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
    clearESP()
    if settings.espEnabled then
        local ents = getEntities()
        local maxN = settings.maxEntities
        for i = 1, math.min(#ents, maxN) do
            local gui = makeBillboard(ents[i])
            espGuis[ents[i]] = gui
        end
    end
    toggleParticles(settings.offParticles)
end)

-- Apply button saves settings
applyBtn.MouseButton1Click:Connect(function()
    saveSettings()
end)
