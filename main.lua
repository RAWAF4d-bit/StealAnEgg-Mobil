-- =========================================================
-- ⚡ ULTRA SPEED & INFINITE JUMP (WITH ANTI-CHEAT BYPASS)
-- =========================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "⚡ Ultra Speed & Jump (Protected)",
   LoadingTitle = "جاري تحميل السكربت مع الحماية...",
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
-- 🛡️ خوارزمية حماية البيباس (Anti-Cheat Bypass)
---------------------------------------------------------

-- 1. حماية ضد الطرد والتصفير (Anti-Kick & Index Hook)
local RawMetatable = getrawmetatable(game)
local OldIndex = RawMetatable.__index
local OldNewIndex = RawMetatable.__newindex
setreadonly(RawMetatable, false)

RawMetatable.__index = newcclosure(function(self, Key)
    if not checkcaller() and getgenv().SpeedToggle then
        if Key == "WalkSpeed" then
            return 16 -- إرجاع القيمة الطبيعية للعبة عند محاولتها الفحص
        end
    end
    return OldIndex(self, Key)
end)

RawMetatable.__newindex = newcclosure(function(self, Key, Value)
    if not checkcaller() and self:IsA("Humanoid") and Key == "WalkSpeed" and getgenv().SpeedToggle then
        return -- منع اللعبة من تعديل السرعة أو إرجاعها إلى 16
    end
    return OldNewIndex(self, Key, Value)
end)

setreadonly(RawMetatable, true)

-- 2. إبطال عمل دوال الطرد المباشرة (Anti-Kick)
if hookmetamethod then
    local OldNamecall
    OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local Method = getnamecallmethod()
        if not checkcaller() and (Method == "Kick" or Method == "kick") then
            return nil -- منع حظر أو طرد اللاعب عند الكشف
        end
        return OldNamecall(self, ...)
    end))
end

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
-- 🔄 تطبيق الفيزياء المحمية للسرعة والقفز
---------------------------------------------------------

-- تطبيق السرعة المحمية بدون طرد
RunService.Stepped:Connect(function()
   if getgenv().SpeedToggle then
      pcall(function()
         local char = LocalPlayer.Character
         if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
            local hum = char.Humanoid
            local hrp = char.HumanoidRootPart
            
            if hum.MoveDirection.Magnitude > 0 then
               local targetVel = hum.MoveDirection * getgenv().WalkSpeedValue
               hrp.AssemblyLinearVelocity = Vector3.new(targetVel.X, hrp.AssemblyLinearVelocity.Y, targetVel.Z)
            end
         end
      end)
   end
end)

-- القفز اللانهائي بفيزياء طبيعية (Bypass Jump)
UserInputService.JumpRequest:Connect(function()
   if getgenv().InfJumpToggle then
      pcall(function()
         local char = LocalPlayer.Character
         if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 50, hrp.AssemblyLinearVelocity.Z)
         end
      end)
   end
end)

Rayfield:Notify({
   Title = "🛡️ تم تفعيل الحماية والسكربت!",
   Content = "السكربت الآن محمي ضد أنظمة الكشف والطرد.",
   Duration = 5,
   Image = 4483345998,
})
