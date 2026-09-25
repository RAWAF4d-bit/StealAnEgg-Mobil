-- =========================================================
-- ⚡ REAL SPEED & INFINITE JUMP HUB (CFrame Speed Fix)
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

-- 1️⃣ زر تفعيل/إيقاف السرعة الحقيقية
MainTab:CreateToggle({
   Name = "تفعيل السرعة المخصصة الحقيقية",
   CurrentValue = false,
   Flag = "SpeedToggleFlag",
   Callback = function(Value)
      getgenv().SpeedToggle = Value
   end,
})

-- 2️⃣ شريط التحكم بالسرعة
MainTab:CreateSlider({
   Name = "تحديد مقدار السرعة",
   Range = {16, 500},
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
-- 🔄 خوارزمية السرعة المباشرة (CFrame Physics)
---------------------------------------------------------

RunService.RenderStepped:Connect(function(delta)
   if getgenv().SpeedToggle then
      pcall(function()
         local character = LocalPlayer.Character
         if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
            local humanoid = character.Humanoid
            local hrp = character.HumanoidRootPart
            
            -- التأكد من أن اللاعب يحرك شخصيته
            if humanoid.MoveDirection.Magnitude > 0 then
               -- تحريك الشخصية للأمام بناءً على الاتجاه والسرعة المحددة
               hrp.CFrame = hrp.CFrame + (humanoid.MoveDirection * (getgenv().WalkSpeedValue / 10) * (delta * 60))
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
   Title = "⚡ تم التحديث بنجاح!",
   Content = "السرعة الآن تعمل بنظام CFrame وسوف تتحرك شخصيتك فوراً.",
   Duration = 5,
   Image = 4483345998,
})
