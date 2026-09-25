-- =========================================================
-- ⚡ ULTRA SPEED & INFINITE JUMP (ULTIMATE BYPASS)
-- =========================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Ultra Speed & Jump Hub",
   LoadingTitle = "جاري تحميل السكربت...",
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
-- 📌 التبويب الرئيسي (Speed & Jump)
---------------------------------------------------------
local MainTab = Window:CreateTab("الرئيسية", 4483345998)

-- 1️⃣ زر تفعيل/إيقاف السرعة
MainTab:CreateToggle({
   Name = "تفعيل السرعة القوية جداً",
   CurrentValue = false,
   Flag = "SpeedToggleFlag",
   Callback = function(Value)
      getgenv().SpeedToggle = Value
   end,
})

-- 2️⃣ شريط التحكم بالسرعة
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
-- 🔄 خوارزمية السرعة الخارقة (Physics Velocity Bypass)
---------------------------------------------------------

RunService.Heartbeat:Connect(function()
   if getgenv().SpeedToggle then
      pcall(function()
         local char = LocalPlayer.Character
         if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
            local hum = char.Humanoid
            local hrp = char.HumanoidRootPart
            
            -- تغيير WalkSpeed الكلاسيكي لضمان الشغل
            hum.WalkSpeed = getgenv().WalkSpeedValue
            
            -- تدعيم الحركة عن طريق الفيزياء الحقيقية في حال كان الماب يحظر WalkSpeed
            if hum.MoveDirection.Magnitude > 0 then
               local moveDir = hum.MoveDirection
               hrp.AssemblyLinearVelocity = Vector3.new(
                  moveDir.X * getgenv().WalkSpeedValue, 
                  hrp.AssemblyLinearVelocity.Y, 
                  moveDir.Z * getgenv().WalkSpeedValue
               )
            end
         end
      end)
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
   Title = "⚡ تم التفعيل!",
   Content = "السرعة الآن مدعومة بالفيزياء المباشرة وسوف تعمل معك فوراً.",
   Duration = 5,
   Image = 4483345998,
})
