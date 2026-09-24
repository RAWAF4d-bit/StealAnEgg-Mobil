-- =========================================================
-- 🔥 STEAL AN EGG | ULTIMATE MOBILE HUB
-- =========================================================

local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/jensonhirst/Orion/main/source'))()

local Window = OrionLib:MakeWindow({
    Name = "🥚 Steal An Egg | Ultimate Mobile", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "StealEggMobileConfig",
    IntroText = "Welcome to Steal An Egg Hub!"
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

getgenv().SelectedEgg = "Devian"
getgenv().AutoTargetSteal = false
getgenv().AutoTreadmill = false
getgenv().PausedForTrade = false

local EggTypes = {"Devian", "Secret", "Eternal", "Mythic", "Legendary", "Rare", "Common"}

local FarmTab = Window:MakeTab({ Name = "السرقة والتدريب", Icon = "rbxassetid://4483345998", PremiumOnly = false })

FarmTab:AddDropdown({ Name = "اختر نوع البيض للسرقة:", Default = "Devian", Options = EggTypes, Callback = function(Value) getgenv().SelectedEgg = Value end })
FarmTab:AddToggle({ Name = "تفعيل السرقة التلقائية للبيض المحدد", Default = false, Callback = function(Value) getgenv().AutoTargetSteal = Value end })
FarmTab:AddToggle({ Name = "الذهاب لجهاز السير (Treadmill) عند عدم وجود بيض", Default = false, Callback = function(Value) getgenv().AutoTreadmill = Value end })
FarmTab:AddToggle({ 
    Name = "🛑 إيقاف مؤقت للسرقة (لنقل البيض لخويك)", 
    Default = false, 
    Callback = function(Value) 
        getgenv().PausedForTrade = Value 
        if Value then
            OrionLib:MakeNotification({ Name = "تم الإيقاف", Content = "السكربت متوقف حالياً.. يمكنك إعطاء البيض لخويك الآن", Time = 3 })
        end
    end 
})

local TrackerTab = Window:MakeTab({ Name = "قائمة البيض بالماب", Icon = "rbxassetid://4483345998", PremiumOnly = false })
TrackerTab:AddButton({
    Name = "🔄 تحديث قائمة البيض والأرباح بالماب",
    Callback = function()
        local FoundEggs = {}
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj.Name:lower():find("egg") and (obj:IsA("BasePart") or obj:IsA("Model")) then
                local cashPerSec = obj:FindFirstChild("CashPerSec") and obj.CashPerSec.Value or 100
                table.insert(FoundEggs, { Instance = obj, Name = obj.Name, Cash = cashPerSec })
            end
        end
        table.sort(FoundEggs, function(a, b) return a.Cash > b.Cash end)
        if #FoundEggs > 0 then
            OrionLib:MakeNotification({ Name = "أعلى بيضة بالماب!", Content = FoundEggs[1].Name .. " | الأرباح: $" .. FoundEggs[1].Cash .. "/sec", Time = 5 })
        else
            OrionLib:MakeNotification({ Name = "تنبيه", Content = "لم يتم العثور على بيض حالياً بالماب", Time = 3 })
        end
    end
})

task.spawn(function()
    while task.wait(0.5) do
        if not getgenv().PausedForTrade and getgenv().AutoTargetSteal then
            local eggFound = false
            for _, v in pairs(Workspace:GetDescendants()) do
                if v.Name:lower():find(getgenv().SelectedEgg:lower()) then
                    local target = v:IsA("BasePart") and v or v:FindFirstChildWhichIsA("BasePart")
                    if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        eggFound = true
                        LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame + Vector3.new(0, 3, 0)
                        local prompt = v:FindFirstChildOfClass("ProximityPrompt") or v:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt and fireproximityprompt then fireproximityprompt(prompt) end
                        break
                    end
                end
            end
            if not eggFound and getgenv().AutoTreadmill then
                for _, machine in pairs(Workspace:GetDescendants()) do
                    if machine.Name:lower():find("treadmill") or machine.Name:lower():find("tread") then
                        local part = machine:IsA("BasePart") and machine or machine:FindFirstChildWhichIsA("BasePart")
                        if part and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
                            break
                        end
                    end
                end
            end
        end
    end
end)

OrionLib:Init()
