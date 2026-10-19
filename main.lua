-- Hacker Script Hub (Anti-AFK + Auto Rejoin + Auto Walk + Minimize Feature)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local IsRejoining = false
local AutoWalkActive = true
local AntiAFKActive = true

-- 1. TẠO SCREEN GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HackerHub_MinimizedEdition"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- 2. Ô ICON BẰNG NÚT NHỎ KHI THU NHỎ (MINIMIZED ICON)
local MiniIcon = Instance.new("TextButton")
MiniIcon.Name = "MiniIcon"
MiniIcon.Size = UDim2.new(0, 40, 0, 40)
MiniIcon.Position = UDim2.new(0, 15, 0.4, 0)
MiniIcon.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MiniIcon.BorderColor3 = Color3.fromRGB(0, 255, 65)
MiniIcon.BorderSizePixel = 2
MiniIcon.Text = "HUB"
MiniIcon.TextColor3 = Color3.fromRGB(0, 255, 65)
MiniIcon.TextSize = 12
MiniIcon.Font = Enum.Font.Code
MiniIcon.Visible = false -- Ban đầu ẩn, chỉ hiện khi thu nhỏ
MiniIcon.Active = true
MiniIcon.Draggable = true -- Có thể kéo thả trên màn hình
MiniIcon.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 8)
MiniCorner.Parent = MiniIcon

-- 3. KHUNG LOADING SCREEN
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Name = "LoadingFrame"
LoadingFrame.Size = UDim2.new(0, 280, 0, 130)
LoadingFrame.Position = UDim2.new(0.5, -140, 0.4, -65)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
LoadingFrame.BorderColor3 = Color3.fromRGB(0, 255, 65)
LoadingFrame.BorderSizePixel = 2
LoadingFrame.Parent = ScreenGui

local LoadTitle = Instance.new("TextLabel")
LoadTitle.Size = UDim2.new(1, 0, 0, 30)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "[ INITIATING SYSTEM... ]"
LoadTitle.TextColor3 = Color3.fromRGB(0, 255, 65)
LoadTitle.TextSize = 12
LoadTitle.Font = Enum.Font.Code
LoadTitle.Parent = LoadingFrame

local LoadStatus = Instance.new("TextLabel")
LoadStatus.Size = UDim2.new(1, 0, 0, 20)
LoadStatus.Position = UDim2.new(0, 0, 0, 35)
LoadStatus.BackgroundTransparency = 1
LoadStatus.Text = "Fixing Anti-AFK engine... 0%"
LoadStatus.TextColor3 = Color3.fromRGB(0, 200, 0)
LoadStatus.TextSize = 11
LoadStatus.Font = Enum.Font.Code
LoadStatus.Parent = LoadingFrame

local BarBackground = Instance.new("Frame")
BarBackground.Size = UDim2.new(0.8, 0, 0, 12)
BarBackground.Position = UDim2.new(0.1, 0, 0, 70)
BarBackground.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
BarBackground.BorderColor3 = Color3.fromRGB(0, 100, 0)
BarBackground.Parent = LoadingFrame

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 65)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBackground

-- 4. KHUNG GIAO DIỆN CHÍNH (MAIN HUB)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 180)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 65)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

-- Tiêu đề
local HubTitle = Instance.new("TextLabel")
HubTitle.Size = UDim2.new(1, -60, 0, 30)
HubTitle.BackgroundColor3 = Color3.fromRGB(0, 30, 0)
HubTitle.BorderColor3 = Color3.fromRGB(0, 255, 65)
HubTitle.Text = "[ HACKER UTILITY HUB ]"
HubTitle.TextColor3 = Color3.fromRGB(0, 255, 65)
HubTitle.TextSize = 12
HubTitle.Font = Enum.Font.Code
HubTitle.Parent = MainFrame

-- Nút Thu Nhỏ [-]
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -60, 0, 0)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 40, 40)
MinimizeBtn.BorderColor3 = Color3.fromRGB(0, 255, 65)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
MinimizeBtn.TextSize = 14
MinimizeBtn.Font = Enum.Font.Code
MinimizeBtn.Parent = MainFrame

-- Nút Đóng [X]
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

-- Nút Bật/Tắt Anti-AFK
local AfkBtn = Instance.new("TextButton")
AfkBtn.Size = UDim2.new(0.9, 0, 0, 35)
AfkBtn.Position = UDim2.new(0.05, 0, 0, 40)
AfkBtn.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
AfkBtn.BorderColor3 = Color3.fromRGB(0, 255, 65)
AfkBtn.Text = "> ANTI-AFK: [ACTIVE]"
AfkBtn.TextColor3 = Color3.fromRGB(0, 255, 65)
AfkBtn.TextSize = 11
AfkBtn.Font = Enum.Font.Code
AfkBtn.Parent = MainFrame

-- Nút Bật/Tắt Auto Walk
local WalkBtn = Instance.new("TextButton")
WalkBtn.Size = UDim2.new(0.9, 0, 0, 35)
WalkBtn.Position = UDim2.new(0.05, 0, 0, 85)
WalkBtn.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
WalkBtn.BorderColor3 = Color3.fromRGB(0, 255, 65)
WalkBtn.Text = "> AUTO WALK: [ON]"
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
RejoinBtn.Text = "> FORCE REJOIN NOW"
RejoinBtn.TextColor3 = Color3.fromRGB(0, 255, 65)
RejoinBtn.TextSize = 11
RejoinBtn.Font = Enum.Font.Code
RejoinBtn.Parent = MainFrame

-- 5. XỬ LÝ CHỨC NĂNG THU NHỎ / BẬT MỞ MENU
-- Bấm [-] để thu nhỏ thành ô icon "HUB"
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniIcon.Visible = true
end)

-- Bấm vào ô icon "HUB" để mở lại bảng menu chính
MiniIcon.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniIcon.Visible = false
end)

-- Bấm [X] để đóng hẳn giao diện (vẫn hiện ô nhỏ để mở lại nếu muốn)
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniIcon.Visible = true
end)

-- 6. TÍNH NĂNG CHẠY NGẦM
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

-- Chống AFK hoàn chỉnh (Cơ chế VirtualUser)
LocalPlayer.Idled:Connect(function()
    if AntiAFKActive then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(0, 0))
    end
end)

-- Bật / Tắt Anti-AFK
AfkBtn.MouseButton1Click:Connect(function()
    AntiAFKActive = not AntiAFKActive
    if AntiAFKActive then
        AfkBtn.Text = "> ANTI-AFK: [ACTIVE]"
        AfkBtn.TextColor3 = Color3.fromRGB(0, 255, 65)
    else
        AfkBtn.Text = "> ANTI-AFK: [DISABLED]"
        AfkBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

-- Auto Walk vòng lặp nhỏ
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

WalkBtn.MouseButton1Click:Connect(function()
    AutoWalkActive = not AutoWalkActive
    if AutoWalkActive then
        WalkBtn.Text = "> AUTO WALK: [ON]"
        WalkBtn.TextColor3 = Color3.fromRGB(0, 255, 65)
    else
        WalkBtn.Text = "> AUTO WALK: [OFF]"
        WalkBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
    end
end)

RejoinBtn.MouseButton1Click:Connect(function()
    AutoRejoin()
end)

-- Auto Rejoin khi mất kết nối
GuiService.ErrorMessageChanged:Connect(function()
    AutoRejoin()
end)

TeleportService.TeleportInitFailed:Connect(function()
    task.wait(1)
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

-- 7. LOADING ANIMATION
task.spawn(function()
    local steps = {
        {p = 0.4, t = "Fixing Anti-AFK... 40%"},
        {p = 0.8, t = "Loading Minimize Module... 80%"},
        {p = 1.0, t = "System Ready! Tap '-' to minimize 100%"}
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
