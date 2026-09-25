-- =========================================================
-- ⚡ SPEED & INFINITE JUMP HUB (PC FIX - NO CRASH)
-- =========================================================

-- تحميل مكتبة Fluent UI من سورس مستقر وداعم للـ PC
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "⚡ Speed & Jump Hub",
    SubTitle = "PC Fixed Version",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 340),
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

getgenv().SpeedToggle = false
getgenv().WalkSpeedValue = 16
getgenv().InfJumpToggle = false

---------------------------------------------------------
-- 📌 التبويب الرئيسي
---------------------------------------------------------
local Tabs = {
    Main = Window:AddTab({ Title = "السرعة والقفز", Icon = "run" }),
    Settings = Window:AddTab({ Title = "الإعدادات", Icon = "settings" })
}

-- 1️⃣ زر تفعيل السرعة
Tabs.Main:AddToggle("SpeedToggle", {
    Title = "تفعيل السرعة المخصصة",
    Default = false,
    Callback = function(Value)
        getgenv().SpeedToggle = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            if Value then
                LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue
            else
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    end
})

-- 2️⃣ شريط التحكم بالسرعة
Tabs.Main:AddSlider("SpeedSlider", {
    Title = "تحديد مقدار السرعة",
    Default = 16,
    Min = 16,
    Max = 300,
    Rounding = 0,
    Callback = function(Value)
        getgenv().WalkSpeedValue = Value
        if getgenv().SpeedToggle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

-- 3️⃣ زر القفز اللانهائي
Tabs.Main:AddToggle("InfJumpToggle", {
    Title = "تفعيل القفز اللانهائي (Infinite Jump)",
    Default = false,
    Callback = function(Value)
        getgenv().InfJumpToggle = Value
    end
})

---------------------------------------------------------
-- 🔄 خوارزمية آمنة للسرعة (بدون كراش)
---------------------------------------------------------

-- تطبيق السرعة عند محاولة اللعبة ترجيعها للافتراضي
local function ApplySpeed(char)
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then
        hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if getgenv().SpeedToggle and hum.WalkSpeed ~= getgenv().WalkSpeedValue then
                hum.WalkSpeed = getgenv().WalkSpeedValue
            end
        end)
    end
end

if LocalPlayer.Character then
    ApplySpeed(LocalPlayer.Character)
end

LocalPlayer.CharacterAdded:Connect(ApplySpeed)

-- القفز اللانهائي
UserInputService.JumpRequest:Connect(function()
    if getgenv().InfJumpToggle then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

---------------------------------------------------------
-- ⚙️ تبويب الإعدادات
---------------------------------------------------------
Tabs.Settings:AddButton({
    Title = "إغلاق السكربت",
    Callback = function()
        Fluent:Destroy()
    end
})

Fluent:SelectTab(1)
