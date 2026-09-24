-- =========================================================
-- 🔥 STEAL AN EGG | ADVANCED ULTIMATE HUB
-- =========================================================

-- 1. تحميل مكتبة Fluent UI المتقدمة
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "🥚 Steal An Egg | Ultimate Hub",
    SubTitle = "by RAWAF4d",
    TabWidth = 160,
    Size = UDim2.fromOffset(530, 360),
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- الخدمات واللاعب المحلي
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- المتغيرات العامة
getgenv().SelectedEgg = "Devian"
getgenv().AutoTargetSteal = false
getgenv().AutoTreadmill = false
getgenv().PausedForTrade = false

local EggTypes = {"Devian", "Secret", "Eternal", "Mythic", "Legendary", "Rare", "Common"}

---------------------------------------------------------
-- 1️⃣ التبويب الأول: السرقة والتداريب (Auto Farm)
---------------------------------------------------------
local Tabs = {
    Farm = Window:AddTab({ Title = "السرقة والتدريب", Icon = "rbxassetid://4483345998" }),
    Settings = Window:AddTab({ Title = "الإعدادات", Icon = "settings" })
}

-- خيار تحديد نوع البيض
local EggDropdown = Tabs.Farm:AddDropdown("EggSelect", {
    Title = "اختر نوع البيض للسرقة:",
    Values = EggTypes,
    Default = "Devian",
    Callback = function(Value)
        getgenv().SelectedEgg = Value
    end
})

-- تفعيل السرقة التلقائية
local StealToggle = Tabs.Farm:AddToggle("AutoSteal", {
    Title = "تفعيل السرقة التلقائية السريعة",
    Default = false,
    Callback = function(Value)
        getgenv().AutoTargetSteal = Value
    end
})

-- تفعيل التردميل عند الانتظار
local TreadmillToggle = Tabs.Farm:AddToggle("AutoTread", {
    Title = "الذهاب للـ Treadmill عند عدم وجود بيض",
    Default = false,
    Callback = function(Value)
        getgenv().AutoTreadmill = Value
    end
})

-- إيقاف مؤقت لنقل البيض
local PauseToggle = Tabs.Farm:AddToggle("PauseTrade", {
    Title = "🛑 إيقاف مؤقت (لنقل البيض لخويك)",
    Default = false,
    Callback = function(Value)
        getgenv().PausedForTrade = Value
        if Value then
            Fluent:Notify({
                Title = "تم الإيقاف المؤقت",
                Content = "السكربت متوقف حالياً لتتمكن من إعطاء البيض.",
                Duration = 3
            })
        end
    end
})

---------------------------------------------------------
-- 🔄 خوارزمية التشغيل التلقائي السريعة
---------------------------------------------------------

task.spawn(function()
    while task.wait(0.1) do
        if not getgenv().PausedForTrade and getgenv().AutoTargetSteal then
            local eggFound = false
            
            -- البحث السريع عن البيض المحدد
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj.Name:lower():find(getgenv().SelectedEgg:lower()) then
                    local targetPart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                    if targetPart and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        eggFound = true
                        
                        -- انتقال فوري للبيضة
                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)
                        
                        -- تفعيل أخذ البيضة فوراً
                        local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                        local detector = obj:FindFirstChildOfClass("ClickDetector") or obj:FindFirstChildWhichIsA("ClickDetector", true)
                        
                        if prompt and fireproximityprompt then
                            fireproximityprompt(prompt)
                        elseif detector and fireclickdetector then
                            fireclickdetector(detector)
                        end
                        break
                    end
                end
            end
            
            -- الذهاب للـ Treadmill في حال عدم وجود البيض
            if not eggFound and getgenv().AutoTreadmill then
                for _, machine in pairs(Workspace:GetDescendants()) do
                    if machine.Name:lower():find("treadmill") or machine.Name:lower():find("tread") then
                        local part = machine:IsA("BasePart") and machine or machine:FindFirstChildWhichIsA("BasePart")
                        if part and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 2, 0)
                            break
                        end
                    end
                end
            end
        end
    end
end)

---------------------------------------------------------
-- 🔘 زر عائم للشاشة (خاص بالجوال)
---------------------------------------------------------
local parentGui = gethui and gethui() or (game:GetService("CoreGui"):FindFirstChild("RobloxGui") or LocalPlayer:WaitForChild("PlayerGui"))
local ScreenGui = Instance.new("ScreenGui", parentGui)
local ToggleBtn = Instance.new("TextButton", ScreenGui)
local UICorner = Instance.new("UICorner", ToggleBtn)

ScreenGui.Name = "StealEggFluentGui"
ToggleBtn.Size = UDim2.fromOffset(60, 60)
ToggleBtn.Position = UDim2.new(0, 15, 0.3, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.Text = "🥚"
ToggleBtn.TextSize = 30
ToggleBtn.Active = true
ToggleBtn.Draggable = true

UICorner.CornerRadius = UDim.new(1, 0) -- زر دائري فخم

ToggleBtn.MouseButton1Click:Connect(function()
    Fluent:Toggle()
end)

Fluent:SelectTab(1)
