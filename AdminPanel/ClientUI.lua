local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Config = require(script.Parent.Config)

local player = Players.LocalPlayer
local AdminEvent = ReplicatedStorage:WaitForChild("AdminPanelEvent")

local ui = Instance.new("ScreenGui")
ui.Name = "AdminPanel"
ui.ResetOnSpawn = false
ui.IgnoreGuiInset = true
ui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 520, 0, 340)
frame.Position = UDim2.new(1, -540, 1, -360)
frame.BackgroundColor3 = Config.Theme.Panel
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.05
frame.Parent = ui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 10)
title.BackgroundTransparency = 1
title.Text = "Xyverm Admin"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Config.Theme.Text
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -20, 0, 32)
searchBox.Position = UDim2.new(0, 10, 0, 60)
searchBox.BackgroundColor3 = Config.Theme.Background
searchBox.BorderColor3 = Config.Theme.AccentDark
searchBox.PlaceholderText = "Type a command (prefix optional)"
searchBox.PlaceholderColor3 = Config.Theme.Muted
searchBox.TextColor3 = Config.Theme.Text
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 16
searchBox.ClearTextOnFocus = false
searchBox.Parent = frame

local runButton = Instance.new("TextButton")
runButton.Size = UDim2.new(0, 80, 0, 32)
runButton.Position = UDim2.new(1, -90, 0, 60)
runButton.BackgroundColor3 = Config.Theme.Accent
runButton.BorderSizePixel = 0
runButton.TextColor3 = Config.Theme.Text
runButton.Font = Enum.Font.GothamBold
runButton.TextSize = 16
runButton.Text = "Run"
runButton.Parent = frame

local log = Instance.new("ScrollingFrame")
log.Size = UDim2.new(1, -20, 1, -110)
log.Position = UDim2.new(0, 10, 0, 100)
log.BackgroundColor3 = Config.Theme.Background
log.BorderSizePixel = 0
log.CanvasSize = UDim2.new(0, 0, 0, 0)
log.ScrollBarThickness = 6
log.TopImage = "rbxassetid://7445543667"
log.BottomImage = "rbxassetid://7445543667"
log.Parent = frame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = log

local function addLog(text)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -10, 0, 20)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextColor3 = Config.Theme.Text
    label.Text = text
    label.Parent = log
    task.wait()
    log.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end

local function runCommand()
    local text = searchBox.Text
    if text == "" then return end
    if string.sub(text, 1, 1) == Config.CommandPrefix then
        text = string.sub(text, 2)
    end
    AdminEvent:FireServer({type = "run", command = text})
    addLog("» " .. text)
    searchBox.Text = ""
end

runButton.MouseButton1Click:Connect(runCommand)
searchBox.FocusLost:Connect(function(enter)
    if enter then
        runCommand()
    end
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Slash then
        task.wait()
        searchBox:CaptureFocus()
    end
end)

-- Theme rounding
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = runButton
