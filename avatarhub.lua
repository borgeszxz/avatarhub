local Library = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Library:CreateWindow({
    Title = "AvatarHub 2.0",
    SubTitle = "by borges",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Darker",
    AccentColor = Color3.fromRGB(255, 165, 0),
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Welcome!", Icon = "home" }),
    SlowWalk = Window:AddTab({ Title = "Slow Walk", Icon = "watch" }),
    SpeedControl = Window:AddTab({ Title = "Speed Control", Icon = "activity" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local playerName = game.Players.LocalPlayer.Name 

Tabs.Main:AddParagraph({
    Title = "Welcome, " .. playerName .. "!", 
    Content = "This is the main hub for controlling your character.\nUse the tabs on the left to access features like Slow Walk, Speed Control, and more."
})


-- SlowWalk Tab
local slowWalkEnabled = false
local toggleInitialized = false 

Tabs.SlowWalk:AddToggle("SlowWalkToggle", {
    Title = "Enable Slow Walk",
    Description = "Reduces your walking speed for a slower pace.",
    Default = false,
    Callback = function(Value)
        if not toggleInitialized then
            toggleInitialized = true
            return
        end

        slowWalkEnabled = Value
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        
        if slowWalkEnabled then
            humanoid.WalkSpeed = 8
            Library:Notify({
                Title = "Slow Walk",
                Content = "Slow Walk successfully enabled!",
                Duration = 2,
                Type = "Success"
            })
        else
            humanoid.WalkSpeed = 16
            Library:Notify({
                Title = "Slow Walk",
                Content = "Slow Walk disabled.",
                Duration = 2,
                Type = "Warning"
            })
        end
    end
})

-- Speed Control Tab
Tabs.SpeedControl:AddSlider("SpeedSlider", {
    Title = "Walking Speed",
    Description = "Adjust your walking speed to a custom value.",
    Default = 16, 
    Min = 2, 
    Max = 200, 
    Rounding = 1, 
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = Value 
    end
})



SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()
