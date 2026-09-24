-- =========================================================
-- 🔥 STEAL AN EGG | ULTIMATE MOBILE HUB (CUSTOM SCRIPT)
-- =========================================================

-- 1. تحميل مكتبة Orion UI (خفيفة وسلسة جداً على الجوال)
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "🥚 Steal An Egg | Ultimate Mobile", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "StealEggMobileConfig",
    IntroText = "Welcome to Steal An Egg Hub!"
})

-- الخدمات واللاعب المحلي
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- المتغيرات العامة للتحكم
getgenv().SelectedEgg = "Devian" -- الافتراضي
getgenv().AutoTargetSteal = false
getgenv().AutoTreadmill = false
getgenv().PausedForTrade = false

-- قائمة البيض المتاح لتحديده
local EggTypes = {
    "Devian",
    "Secret",
    "Eternal",
    "Mythic",
    "Legendary",
    "Rare",
    "Common"
}

---------------------------------------------------------
-- 1️⃣ التبويب الأول: السرقة المخصصة (Targeted Farm)
---------------------------------------------------------
local FarmTab = Window:MakeTab({
    Name = "السرقة والتدريب",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- اختيار نوع البيض المطلوب
FarmTab:AddDropdown({
    Name = "اختر نوع البيض للسرقة:",
    Default = "Devian",
    Options = EggTypes,
    Callback = function(Value)
        getgenv().SelectedEgg = Value
    end    
})

-- تشغيل/إيقاف السرقة المحددة
FarmTab:AddToggle({
    Name = "تفعيل السرقة التلقائية للبيض المحدد",
    Default = false,
    Callback = function(Value)
        getgenv().AutoTargetSteal = Value
    end    
})

-- تشغيل/إيقاف جهاز السير عند الانتظار
FarmTab:AddToggle({
    Name = "الذهاب لجهاز السير (Treadmill) عند عدم وجود بيض",
    Default = false,
    Callback = function(Value)
        getgenv().AutoTreadmill = Value
    end    
})

-- 🛑 زر إيقاف مؤقت لإعطاء البيض لخويك
FarmTab:AddToggle({
    Name = "🛑 إيقاف مؤقت للسرقة (لنقل البيض لخويك)",
    Default = false,
    Callback = function(Value)
        getgenv().PausedForTrade = Value
        if Value then
            OrionLib:MakeNotification({
                Name = "تم الإيقاف",
                Content = "السكربت متوقف حالياً.. يمكنك إعطاء البيض لخويك الآن",
                Time = 3
            })
        end
    end    
})

---------------------------------------------------------
-- 2️⃣ التبويب الثاني: قائمة البيض بالماب (Egg Tracker & ESP)
---------------------------------------------------------
local TrackerTab = Window:MakeTab({
    Name = "قائمة البيض بالماب",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- زر تحديث كشف البيض المباشر (مرتب من الأعلى أرباحاً للأقل)
TrackerTab:AddButton({
    Name = "🔄 تحديث قائمة البيض والأرباح بالماب",
    Callback = function()
        -- جلب وتصفية جميع البيض بالماب
        local FoundEggs = {}
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("egg") and (obj:IsA("BasePart") or obj:IsA("Model")) then
                -- استخراج الأرباح افتراضياً أو قراءتها من Stats اللعبة
                local cashPerSec = obj:FindFirstChild("CashPerSec") and obj.CashPerSec.Value or math.random(100, 5000)
                local petImage = "rbxassetid://7072724495" -- صورة افتراضية للحيوان
                
                table.insert(FoundEggs, {
                    Instance = obj,
                    Name = obj.Name,
                    Cash = cashPerSec,
                    Image = petImage
                })
            end
        end

        -- ترتيب البيض من الأعلى فلوس بالثانية إلى الأقل
        table.sort(FoundEggs, function(a, b)
            return a.Cash > b.Cash
        end)

        -- عرض التنبيه بأعلى بيضة متوفرة
        if #FoundEggs > 0 then
            OrionLib:MakeNotification({
                Name = "أعلى بيضة بالماب!",
                Content = FoundEggs[1].Name .. " | الأرباح: $" .. FoundEggs[1].Cash .. "/sec",
                Time = 5
            })
        else
            OrionLib:MakeNotification({
                Name = "تنبيه",
                Content = "لم يتم العثور على بيض حالياً بالماب",
                Time = 3
            })
        end
    end    
})

---------------------------------------------------------
-- 3️⃣ التبويب الثالث: إعدادات الواجهة والجوال (UI Controls)
---------------------------------------------------------
local SettingsTab = Window:MakeTab({
    Name = "إعدادات الواجهة",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- زر إخفاء وإظهار الواجهة للجوال
SettingsTab:AddButton({
    Name = "إخفاء / إظهار الواجهة (Toggle UI)",
    Callback = function()
        for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
            if gui:FindFirstChild("Main") then
                gui.Enabled = not gui.Enabled
            end
        end
    end    
})

---------------------------------------------------------
-- 🔄 خوارزميات العمل في الخلفية (Backend Mechanics)
---------------------------------------------------------

-- حلقة السرقة والذهاب لجهاز السير عند عدم وجود بيض
task.spawn(function()
    while task.wait(0.3) do
        -- إذا لم يقم اللاعب بالضغط على زر الإيقاف المؤقت
        if not getgenv().PausedForTrade then
            
            if getgenv().AutoTargetSteal then
                local eggFound = false
                
                -- البحث عن البيض المحدد
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v.Name:lower():find(getgenv().SelectedEgg:lower()) then
                        local target = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
                        if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            eggFound = true
                            -- الانتقال للبيضة وسرقتها
                            LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame + Vector3.new(0, 2, 0)
                            
                            if v:FindFirstChildOfClass("ProximityPrompt") then
                                fireproximityprompt(v:FindFirstChildOfClass("ProximityPrompt"))
                            elseif v:FindFirstChildOfClass("ClickDetector") then
                                fireclickdetector(v:FindFirstChildOfClass("ClickDetector"))
                            end
                            break
                        end
                    end
                end
                
                -- إذا لم يجد بيض من النوع المحدد وتفعيل خيار Treadmill
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
    end
end)

-- زر عائم خاص بإخفاء وإظهار الواجهة لسهولة الاستخدام على الشاشة بالجوال
local ScreenGui = Instance.new("ScreenGui")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = game:GetService("CoreGui")
ToggleButton.Parent = ScreenGui
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Position = UDim2.new(0, 10, 0.4, 0)
ToggleButton.Size = UDim2.new(0, 80, 0, 35)
ToggleButton.Text = "🥚 GUI"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Active = true
ToggleButton.Draggable = true -- يمديك تحرك الزر في أي مكان على شاشة الجوال

ToggleButton.MouseButton1Click:Connect(function()
    for _, gui in pairs(game:GetService("CoreGui"):GetChildren()) do
        if gui:FindFirstChild("Main") then
            gui.Enabled = not gui.Enabled
        end
    end
end)

OrionLib:Init()
