-- Hacker Script Hub (Anti-AFK + Auto Rejoin + Auto Walk + Toggle Key)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local IsRejoining = false
local AutoWalkActive = true

-- 1. TẠO SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HackerHub_Loading"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- 2. KHUNG LOADING SCREEN
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(0, 300, 0, 140)
LoadingFrame.Position = UDim2.new(0.5, -150, 0.4, -70)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
LoadingFrame.BorderColor3 = Color3.fromRGB(0, 255, 65)
LoadingFrame.BorderSizePixel = 2
LoadingFrame.Parent = ScreenGui

local LoadTitle = Instance.new("TextLabel")
LoadTitle.Size = UDim2.new(1, 0, 0, 30)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "[ INITIATING SYSTEM... ]"
LoadTitle.TextColor3 = Color3.fromRGB(0, 255, 65)
LoadTitle.TextSize = 13
LoadTitle.Font = Enum.Font.Code
LoadTitle.Parent = LoadingFrame

local LoadStatus = Instance.new("TextLabel")
LoadStatus.Size = UDim2.new(1, 0, 0, 20)
LoadStatus.Position = UDim2.new(0, 0, 0, 35)
LoadStatus.BackgroundTransparency = 1
LoadStatus.Text = "Loading modules... 0%"
LoadStatus.TextColor3 = Color3.fromRGB(0, 200, 0)
LoadStatus.TextSize = 11
LoadStatus.Font = Enum.Font.Code
LoadStatus.Parent = LoadingFrame

-- Thanh Progress Bar
local BarBackground = Instance.new("Frame")
BarBackground.Size = UDim2.new(0.8, 0, 0, 15)
BarBackground.Position = UDim2.new(0.1, 0, 0, 70)
BarBackground.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BarBackground.BorderColor3 = Color3.fromRGB(0, 100, 0)
BarBackground.Parent = LoadingFrame

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 65)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBackground

-- 3. KHUNG GIAO DIỆN CHÍNH (MAIN HUB)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 340, 0, 190)
MainFrame.Position = UDim2.new(0.5, -170, 0.4, -95)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 65)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local HubTitle = Instance.new("TextLabel")
HubTitle.Size = UDim2.new(1, -30, 0, 30)
HubTitle.BackgroundColor3 = Color3.fromRGB(0, 30, 0)
HubTitle.BorderColor3 = Color3.fromRGB(0, 255, 65)
HubTitle.Text = "[ HACKER UTILITY HUB v1.0 ]"
HubTitle.TextColor3 = Color3.fromRGB(0, 255, 65)
HubTitle.TextSize = 12
HubTitle.Font = Enum.Font.Code
HubTitle.Parent = MainFrame

-- Nút Tắt/Mở Giao Diện [X]
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
CloseBtn.BorderColor3 = Color3.fromRGB(0, 255, 65)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.TextSize = 12
CloseBtn.Font = Enum.Font.Code
CloseBtn.Parent = MainFrame

-- Nút Anti-AFK & Auto-Rejoin Status
local AfkBtn = Instance.new("TextButton")
AfkBtn.Size = UDim2.new(0.9, 0, 0, 35)
AfkBtn.Position = UDim2.new(0.05, 0, 0, 40)
AfkBtn.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
AfkBtn.BorderColor3 = Color3.fromRGB(0, 255, 65)
AfkBtn.Text = "> ANTI-AFK & AUTO-REJOIN: [ACTIVE]"
AfkBtn.TextColor3 = Color3.fromRGB(0, 255, 65)
AfkBtn.TextSize = 11
AfkBtn.Font = Enum.Font.Code
AfkBtn.Parent = MainFrame

-- Nút Bật/Tắt Auto Walk (Tự động đi lại)
local WalkBtn = Instance.new("TextButton")
WalkBtn.Size = UDim2.new(0.9, 0, 0, 35)
WalkBtn.Position = UDim2.new(0.05, 0, 0, 85)
WalkBtn.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
WalkBtn.BorderColor3 = Color3.fromRGB(0, 255, 65)
WalkBtn.Text = "> AUTO WALK (ANTI-AFK+): [ON]"
WalkBtn.TextColor3 = Color3.fromRGB(0, 255, 65)
WalkBtn.TextSize = 11
WalkBtn.Font = Enum.Font.Code
WalkBtn.Parent = MainFrame

-- Nút Rejoin Thủ Công
local RejoinBtn = Instance.new("TextButton")
RejoinBtn.Size = UDim2.new(0.9, 0, 0, 35)
RejoinBtn.Position = UDim2.new(0.05, 0, 0, 130)
RejoinBtn.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
RejoinBtn.BorderColor3 = Color3.fromRGB(0, 255, 65)
RejoinBtn.Text = "> FORCE REJOIN NOW (PRESS 'K' TO HIDE)"
RejoinBtn.TextColor3 = Color3.fromRGB(0, 255, 65)
RejoinBtn.TextSize = 10
RejoinBtn.Font = Enum.Font.Code
RejoinBtn.Parent = MainFrame

-- 4. HÀM TỰ ĐỘNG REJOIN AN TOÀN
local function AutoRejoin()
    if IsRejoining then return end
    IsRejoining = true
    task.wait(2)
    
    if #Players:GetPlayers() <= 1 then
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
end

-- 5. TÍNH NĂNG XỬ LÝ
-- Chống AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0, 0))
end)

-- Vòng lặp Auto Walk (Nhân vật di chuyển nhẹ để qua mặt Anti-Cheat)
task.spawn(function()
    while true do
        task.wait(10)
        if AutoWalkActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            humanoid:Move(Vector3.new(1, 0, 0), true)
            task.wait(0.5)
            humanoid:Move(Vector3.new(-1, 0, 0), true)
        end
    end
end)

-- Bật/Tắt Auto Walk
WalkBtn.MouseButton1Click:Connect(function()
    AutoWalkActive = not AutoWalkActive
    if AutoWalkActive then
        WalkBtn.Text = "> AUTO WALK (ANTI-AFK+): [ON]"
        WalkBtn.TextColor3 = Color3.fromRGB(0, 255, 65)
    else
        WalkBtn.Text = "> AUTO WALK (ANTI-AFK+): [OFF]"
        WalkBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

-- Rejoin Thủ Công
RejoinBtn.MouseButton1Click:Connect(function()
    AutoRejoin()
end)

-- TỰ ĐỘNG REJOIN KHI BỊ DISCONNECT (Mất mạng / Kick)
GuiService.ErrorMessageChanged:Connect(function()
    AutoRejoin()
end)

TeleportService.TeleportInitFailed:Connect(function()
    task.wait(1)
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

-- Ẩn/Hiện UI khi bấm phím K hoặc nút X
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- 6. CHẠY MÀN HÌNH LOADING ANIMATION
task.spawn(function()
    local steps = {
        {p = 0.3, t = "Connecting to Core... 30%"},
        {p = 0.7, t = "Hooking Auto-Walk & Rejoin... 70%"},
        {p = 1.0, t = "System Ready! Press 'K' to Hide 100%"}
    }
    
    for _, step in ipairs(steps) do
        LoadStatus.Text = step.t
        TweenService:Create(BarFill, TweenInfo.new(0.4), {Size = UDim2.new(step.p, 0, 1, 0)}):Play()
        task.wait(0.5)
    end
    
    task.wait(0.2)
    LoadingFrame:Destroy()
    MainFrame.Visible = true
end)
