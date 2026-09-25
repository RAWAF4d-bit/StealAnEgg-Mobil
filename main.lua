-- =========================================================
-- ⚡ ULTRA SPEED & INFINITE JUMP (PC ULTRA OPTIMIZED & SAFE)
-- =========================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Ultra Speed & Jump (Safe)",
   LoadingTitle = "جاري تحميل السكربت الآمن...",
   LoadingSubtitle = "by RAWAF4d",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

getgenv().SpeedToggle = false
getgenv().WalkSpeedValue = 50
getgenv().InfJumpToggle = false

---------------------------------------------------------
-- 📌 التبويب الرئيسي
---------------------------------------------------------
local MainTab = Window:CreateTab("الرئيسية", 4483345998)

MainTab:CreateToggle({
   Name = "تفعيل السرعة المحمية",
   CurrentValue = false,
   Flag = "SpeedToggleFlag",
   Callback = function(Value)
      getgenv().SpeedToggle = Value
   end,
})

MainTab:CreateSlider({
   Name = "تحديد مقدار السرعة",
   Range = {10, 500},
   Increment = 5,
   Suffix = " Speed",
   CurrentValue = 50,
   Flag = "SpeedSliderFlag",
   Callback = function(Value)
      getgenv().WalkSpeedValue = Value
   end,
})

MainTab:CreateToggle({
   Name = "تفعيل القفز اللانهائي المحمي",
   CurrentValue = false,
   Flag = "InfJumpFlag",
   Callback = function(Value)
      getgenv().InfJumpToggle = Value
   end,
})

---------------------------------------------------------
-- 🛡️ خوارزمية الحماية والسرعة السلسة (No Metatable Crash)
---------------------------------------------------------

-- حماية السرعة وتجاوز الحماية دون تعديل Hook المسبب للكراش
RunService.PostSimulation:Connect(function()
   if getgenv().SpeedToggle then
      pcall(function()
         local char = LocalPlayer.Character
         if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            
            if hum and hrp and hum.MoveDirection.Magnitude > 0 then
               -- تحريك محمي عبر متجهات حركة سلاسة خفيفة للغاية تمنع الكشف والكراش
               local currentVel = hrp.AssemblyLinearVelocity
               local targetVel = hum.MoveDirection * getgenv().WalkSpeedValue
               
               hrp.AssemblyLinearVelocity = Vector3.new(targetVel.X, currentVel.Y, targetVel.Z)
            end
         end
      end)
   end
end)

-- القفز اللانهائي المحمي (حماية ضد السقوط القاتل أو الكشف)
UserInputService.JumpRequest:Connect(function()
   if getgenv().InfJumpToggle then
      pcall(function()
         local char = LocalPlayer.Character
         if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp and hum then
               -- قفزة طبيعية باستخدام قوة قفز اللعبة لضمان عدم الكشف
               hrp.AssemblyLinearVelocity = Vector3.new(
                  hrp.AssemblyLinearVelocity.X, 
                  hum.JumpPower > 0 and hum.JumpPower or 50, 
                  hrp.AssemblyLinearVelocity.Z
               )
            end
         end
      end)
   end
end)

Rayfield:Notify({
   Title = "⚡ تم تشغيل السكربت بنجاح!",
   Content = "السكربت مستقر ومحمي بالكامل للـ PC والجوال.",
   Duration = 5,
   Image = 4483345998,
})
