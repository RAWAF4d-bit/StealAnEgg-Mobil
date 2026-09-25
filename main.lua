-- =========================================================
-- ⚡ SPEED & INFINITE JUMP HUB (PC & MOBILE SUPPORT)
-- =========================================================

-- تحميل مكتبة Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "⚡ Speed & Jump Hub",
    SubTitle = "PC Compatible",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 340),
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl -- زر إخفاء وإظهار الواجهة في الـ PC
})

-- الخدمات واللاعب المحلي
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- المتغيرات العامة
getgenv().SpeedToggle = false
getgenv().WalkSpeedValue = 16
getgenv().InfJumpToggle = false

---------------------------------------------------------
-- 📌 التبويب الرئيسي (Main Tab)
---------------------------------------------------------
local Tabs = {
    Main = Window:AddTab({ Title = "السرعة والقفز", Icon = "run" }),
    Settings = Window:AddTab({ Title = "الإعدادات", Icon = "settings" })
}

-- 1️⃣ مفتاح تشغيل/إيقاف السرعة
local SpeedToggleBtn = Tabs.Main:AddToggle("SpeedToggle", {
    Title = "تفعيل السرعة المخصصة",
    Default = false,
    Callback = function(Value)
        getgenv().SpeedToggle = Value
        if not Value then
            -- إعادة السرعة الافتراضية عند الإيقاف
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    end
})

-- 2️⃣ شريط تحديد السرعة
local SpeedSlider = Tabs.Main:AddSlider("SpeedSlider", {
    Title = "تحديد مقدار السرعة",
    Description = "اختر السرعة المناسبة لك",
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        getgenv().WalkSpeedValue = Value
    end
})

Tabs.Main:AddParagraph({
    Title = "💡 ملاحظة للسرعة",
    Content = "إذا كانت السرعة تتستر (Reset) في بعض الألعاب، جرب عدم رفع السرعة لرقم عالي جداً."
})

-- 3️⃣ مفتاح تشغيل/إيقاف القفز اللانهائي
local InfJumpToggleBtn = Tabs.Main:AddToggle("InfJumpToggle", {
    Title = "تفعيل القفز اللانهائي (Infinite Jump)",
    Default = false,
    Callback = function(Value)
        getgenv().InfJumpToggle = Value
    end
})

---------------------------------------------------------
-- 🔄 خوارزمية التطبيق (Loop & Mechanics)
---------------------------------------------------------

-- حلقة تطبيق السرعة باستمرار
task.spawn(function()
    while task.wait(0.1) do
        if getgenv().SpeedToggle then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue
            end
        end
    end
end)

-- خوارزمية القفز اللانهائي (Infinite Jump)
UserInputService.JumpRequest:Connect(function()
    if getgenv().InfJumpToggle then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

---------------------------------------------------------
-- ⚙️ تبويب الإعدادات (Settings)
---------------------------------------------------------
Tabs.Settings:AddButton({
    Title = "إغلاق السكربت نهائياً",
    Callback = function()
        Fluent:Destroy()
    end
})

Fluent:SelectTab(1)

-- إشعار عند التشغيل
Fluent:Notify({
    Title = "⚡ تم تشغيل السكربت بنجاح!",
    Content = "اضغط على Left Control في الكيبورد لإخفاء أو إظهار القائمة.",
    Duration = 5
})
