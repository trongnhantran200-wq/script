-- Hacker Script Hub with Loading Screen (No FPS Boost)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

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
MainFrame.Size = UDim2.new(0, 340, 0, 150)
MainFrame.Position = UDim2.new(0.5, -170, 0.4, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 65)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local HubTitle = Instance.new("TextLabel")
HubTitle.Size = UDim2.new(1, 0, 0, 30)
HubTitle.BackgroundColor3 = Color3.fromRGB(0, 30, 0)
HubTitle.BorderColor3 = Color3.fromRGB(0, 255, 65)
HubTitle.Text = "[ HACKER UTILITY HUB v1.0 ]"
HubTitle.TextColor3 = Color3.fromRGB(0, 255, 65)
HubTitle.TextSize = 12
HubTitle.Font = Enum.Font.Code
HubTitle.Parent = MainFrame

-- Nút Anti-AFK
local AfkBtn = Instance.new("TextButton")
AfkBtn.Size = UDim2.new(0.9, 0, 0, 35)
AfkBtn.Position = UDim2.new(0.05, 0, 0, 50)
AfkBtn.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
AfkBtn.BorderColor3 = Color3.fromRGB(0, 255, 65)
AfkBtn.Text = "> EXECUTE ANTI-AFK [ACTIVE]"
AfkBtn.TextColor3 = Color3.fromRGB(0, 255, 65)
AfkBtn.TextSize = 11
AfkBtn.Font = Enum.Font.Code
AfkBtn.Parent = MainFrame

-- Nút Rejoin Server
local RejoinBtn = Instance.new("TextButton")
RejoinBtn.Size = UDim2.new(0.9, 0, 0, 35)
RejoinBtn.Position = UDim2.new(0.05, 0, 0, 95)
RejoinBtn.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
RejoinBtn.BorderColor3 = Color3.fromRGB(0, 255, 65)
RejoinBtn.Text = "> REJOIN CURRENT SERVER"
RejoinBtn.TextColor3 = Color3.fromRGB(0, 255, 65)
RejoinBtn.TextSize = 11
RejoinBtn.Font = Enum.Font.Code
RejoinBtn.Parent = MainFrame

-- 4. TÍNH NĂNG XỬ LÝ
-- Chống AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0, 0))
end)

-- Rejoin
RejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

-- 5. CHẠY MÀN HÌNH LOADING ANIMATION
task.spawn(function()
    local steps = {
        {p = 0.3, t = "Connecting to Core... 30%"},
        {p = 0.7, t = "Loading Anti-AFK module... 70%"},
        {p = 1.0, t = "System Ready! 100%"}
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
