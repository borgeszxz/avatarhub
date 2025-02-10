local Library = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Library:CreateWindow({
    Title = "AvatarHub 1.0",
    SubTitle = "by borges",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Darker",
    AccentColor = Color3.fromRGB(255, 165, 0),
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Welcome!", Icon = "home" }),
    SlowWalk = Window:AddTab({ Title = "Slow Walk", Icon = "watch" }),
    SpeedControl = Window:AddTab({ Title = "Speed Control", Icon = "activity" }),
    NoClip = Window:AddTab({ Title = "NoClip", Icon = "box" }),
    Invisibility = Window:AddTab({ Title = "Invisibility", Icon = "eye-off" }),
    MouseTeleport = Window:AddTab({ Title = "Mouse Teleport", Icon = "map" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
local noClipInitialized = false
local invisibilityInitialized = false
local teleportInitialized = false

Tabs.Main:AddParagraph({
    Title = "Welcome to AvatarHub!",
    Content = "This is the main hub for controlling your character.\nUse the tabs on the left to access features like Slow Walk, Speed Control, and more."
})

-- SlowWalk Tab
local slowWalkEnabled = false
local toggleInitialized = false 

Tabs.SlowWalk:AddToggle("SlowWalkToggle", {
    Title = "Enable Slow Walk",
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

Tabs.SpeedControl:AddButton({
    Title = "Normal Speed",
    Description = "Reset to default walking speed (16).",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = 16 

        Library:Notify({
            Title = "Speed Control",
            Content = "Walking speed reset to normal (16).",
            Duration = 2,
            Type = "Success"
        })
    end
})

-- Noclip Tab
Tabs.NoClip:AddToggle("NoClipToggle", {
    Title = "Enable NoClip",
    Default = false,
    Callback = function(Value)
        if not noClipInitialized then
            noClipInitialized = true
            return 
        end

        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not Value
            end
        end

        Library:Notify({
            Title = "NoClip",
            Content = Value and "NoClip enabled!" or "NoClip disabled.",
            Duration = 2,
            Type = Value and "Success" or "Warning"
        })
    end
})

--Invisibility Tab
Tabs.Invisibility:AddToggle("InvisibilityToggle", {
    Title = "Enable Invisibility",
    Default = false,
    Callback = function(Value)
        if not invisibilityInitialized then
            invisibilityInitialized = true
            return
        end

        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = Value and 1 or 0
                if part.Name == "HumanoidRootPart" then
                    part.Transparency = 1
                end
            elseif part:IsA("Accessory") and part:FindFirstChild("Handle") then
                part.Handle.Transparency = Value and 1 or 0
            elseif part:IsA("Decal") then
                part.Transparency = Value and 1 or 0
            end
        end

        Library:Notify({
            Title = "Invisibility",
            Content = Value and "You are now invisible!" or "You are visible again.",
            Duration = 2,
            Type = Value and "Success" or "Warning"
        })
    end
})

-- MouseTeleport Tab
local teleportEnabled = false
local teleportKey = Enum.KeyCode.T 

Tabs.MouseTeleport:AddToggle("TeleportToggle", {
    Title = "Enable Mouse Teleport",
    Default = false,
    Callback = function(Value)
        if not teleportInitialized then
            teleportInitialized = true
            return
        end

        teleportEnabled = Value
        Library:Notify({
            Title = "Mouse Teleport",
            Content = Value and "Mouse Teleport enabled! (Press T)" or "Mouse Teleport disabled.",
            Duration = 2,
            Type = Value and "Success" or "Warning"
        })
    end
})
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not teleportEnabled then return end

    if input.KeyCode == teleportKey then
        local player = game.Players.LocalPlayer
        local mouse = player:GetMouse()
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        if mouse.Hit then
            humanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 3, 0)) 
        else
            Library:Notify({
                Title = "Mouse Teleport",
                Content = "No valid position under the mouse!",
                Duration = 2,
                Type = "Warning"
            })
        end
    end
end)

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
