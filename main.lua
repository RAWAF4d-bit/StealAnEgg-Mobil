-- =========================================================
-- ⚡ SPEED & INFINITE JUMP HUB (MAX SPEED 1000)
-- =========================================================

-- تحميل مكتبة Rayfield UI المضمونة والخفيفة
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Ultra Speed & Jump Hub",
   LoadingTitle = "جاري تحميل السكربت...",
   LoadingSubtitle = "by RAWAF4d",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false
})

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

getgenv().SpeedToggle = false
getgenv().WalkSpeedValue = 16
getgenv().InfJumpToggle = false

---------------------------------------------------------
-- 📌 التبويب الرئيسي (Speed & Jump)
---------------------------------------------------------
local MainTab = Window:CreateTab("الرئيسية", 4483345998)

-- 1️⃣ زر تفعيل/إيقاف السرعة
MainTab:CreateToggle({
   Name = "تفعيل السرعة المخصصة",
   CurrentValue = false,
   Flag = "SpeedToggleFlag",
   Callback = function(Value)
      getgenv().SpeedToggle = Value
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         if Value then
            LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue
         else
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
         end
      end
   end,
})

-- 2️⃣ شريط التحكم بالسرعة (تم رفعه إلى 1000)
MainTab:CreateSlider({
   Name = "تحديد مقدار السرعة (سرعة جنونية)",
   Range = {16, 1000},
   Increment = 5,
   Suffix = " Speed",
   CurrentValue = 16,
   Flag = "SpeedSliderFlag",
   Callback = function(Value)
      getgenv().WalkSpeedValue = Value
      if getgenv().SpeedToggle and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- 3️⃣ زر تفعيل/إيقاف القفز اللانهائي
MainTab:CreateToggle({
   Name = "تفعيل القفز اللانهائي (Infinite Jump)",
   CurrentValue = false,
   Flag = "InfJumpFlag",
   Callback = function(Value)
      getgenv().InfJumpToggle = Value
   end,
})

---------------------------------------------------------
-- 🔄 خوارزمية التشغيل الآمنة بدون كراش
---------------------------------------------------------

-- حلقة خفيفة جداً للسرعة مع حماية من الكراش
task.spawn(function()
   while task.wait(0.1) do
      if getgenv().SpeedToggle then
         pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
               LocalPlayer.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue
            end
         end)
      end
   end
end)

-- القفز اللانهائي
UserInputService.JumpRequest:Connect(function()
   if getgenv().InfJumpToggle then
      pcall(function()
         if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
         end
      end)
   end
end)

Rayfield:Notify({
   Title = "⚡ تم تفعيل السرعة الفائقة!",
   Content = "يمكنك الآن رفع السرعة حتى 1000.",
   Duration = 5,
   Image = 4483345998,
})
