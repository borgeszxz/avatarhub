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
    NoClip = Window:AddTab({ Title = "NoClip", Icon = "box" }),
    Invisibility = Window:AddTab({ Title = "Invisibility", Icon = "eye-off" }),
    MouseTeleport = Window:AddTab({ Title = "Mouse Teleport", Icon = "map" }),
    Jokes = Window:AddTab({ Title = "Jokes", Icon = "smile" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}
local noClipInitialized = false
local invisibilityInitialized = false
local teleportInitialized = false
local sttingInitialized = false
local spinningInitialized = false
local orbitingInitialized = false
local followingInitialized = false

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
    Description = "Allows you to move through walls and obstacles.",
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
    Description = "Toggle to make your character invisible to others.",
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
    Description = "Toggle to teleport to the position of your mouse cursor. Use the T key to teleport.",
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

-- Jokes tab
local function getPlayerNames()
    local players = game.Players:GetPlayers()
    local playerNames = {}

    for _, player in ipairs(players) do
        table.insert(playerNames, player.Name)
    end

    return playerNames
end

local selectedPlayer = nil

local dropdown = Tabs.Jokes:AddDropdown("PlayerSelection", {
    Title = "Select a Player",
    Values = getPlayerNames(), 
    Multi = false,
    Callback = function(Value)
        selectedPlayer = game.Players:FindFirstChild(Value)

        if selectedPlayer then
            Library:Notify({
                Title = "Player Selected",
                Content = "You selected: " .. Value,
                Duration = 2,
                Type = "Info"
            })
        else
            Library:Notify({
                Title = "Error",
                Content = "Player not found!",
                Duration = 2,
                Type = "Error"
            })
        end
    end
})

game.Players.PlayerAdded:Connect(function()
    dropdown:SetValues(getPlayerNames()) 
end)

game.Players.PlayerRemoving:Connect(function()
    dropdown:SetValues(getPlayerNames()) 
end)


Tabs.Jokes:AddButton({
    Title = "Teleport to Player",
    Description = "Click to teleport to the selected player.",
    Callback = function()
        
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

        if selectedPlayer and selectedPlayer.Character then
            local targetRootPart = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRootPart then
                humanoidRootPart.CFrame = targetRootPart.CFrame + Vector3.new(0, 3, 0)
                Library:Notify({
                    Title = "Teleported!",
                    Content = "You have been teleported to " .. selectedPlayer.Name,
                    Duration = 2,
                    Type = "Success"
                })
            else
                Library:Notify({
                    Title = "Error",
                    Content = "The player does not have a HumanoidRootPart!",
                    Duration = 2,
                    Type = "Error"
                })
            end
        else
            Library:Notify({
                Title = "Error",
                Content = "No valid player selected!",
                Duration = 2,
                Type = "Error"
            })
        end
    end
})

Tabs.Jokes:AddToggle("ObservePlayerToggle", {
    Title = "Observe Player",
    Description = "Toggle to observe the selected player's perspective.",
    Default = false,
    Callback = function(Value)
        
        local player = game.Players.LocalPlayer
        local camera = game.Workspace.CurrentCamera

        if Value then
            if not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Library:Notify({
                    Title = "Error",
                    Content = "No valid player selected!",
                    Duration = 2,
                    Type = "Error"
                })
                return
            end

            _G.OBSERVING = true

            local originalCameraSubject = camera.CameraSubject
            local originalCameraType = camera.CameraType

            camera.CameraType = Enum.CameraType.Follow
            camera.CameraSubject = selectedPlayer.Character:FindFirstChild("Humanoid")

            Library:Notify({
                Title = "Observing Player",
                Content = "You are now observing " .. selectedPlayer.Name .. ".",
                Duration = 2,
                Type = "Success"
            })

            spawn(function()
                while _G.OBSERVING do
                    task.wait()
                    if not selectedPlayer or not selectedPlayer.Character then
                        _G.OBSERVING = false
                        Library:Notify({
                            Title = "Error",
                            Content = "The player is no longer valid. Stopping observation.",
                            Duration = 2,
                            Type = "Error"
                        })
                        break
                    end
                end

                camera.CameraType = originalCameraType
                camera.CameraSubject = originalCameraSubject

                Library:Notify({
                    Title = "Stopped Observing",
                    Content = "You have returned to your original camera view.",
                    Duration = 2,
                    Type = "Info"
                })
            end)
        else
            _G.OBSERVING = false
        end
    end
})

Tabs.Jokes:AddToggle("FollowPlayerToggle", {
    Title = "Sit on Player's Head",
    Description = "Toggle to sit on the selected player's head.",
    Default = false,
    Callback = function(Value)
        if not sttingInitialized then
            sttingInitialized = true
            return
        end

        if Value then
            if not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Library:Notify({
                    Title = "Error",
                    Content = "No valid player selected!",
                    Duration = 2,
                    Type = "Error"
                })
                return
            end

            local me = game.Players.LocalPlayer.Character.HumanoidRootPart
            local hum = game.Players.LocalPlayer.Character.Humanoid
            local other = selectedPlayer.Character.HumanoidRootPart

            _G.LOOP = true

            spawn(function()
                while _G.LOOP do
                    task.wait()
                    if not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        _G.LOOP = false
                        Library:Notify({
                            Title = "Error",
                            Content = "Player is no longer valid!",
                            Duration = 2,
                            Type = "Error"
                        })
                        return
                    end

                    local headPosition = other.CFrame * CFrame.new(0, 2.5, 0) 
                    me.CFrame = headPosition
                    hum.Sit = true 
                end
            end)

            Library:Notify({
                Title = "Sitting on Head",
                Content = "You are now sitting on " .. selectedPlayer.Name .. "'s head.",
                Duration = 2,
                Type = "Success"
            })
        else
            _G.LOOP = false
            Library:Notify({
                Title = "Stopped Sitting",
                Content = "You stopped sitting on the player's head.",
                Duration = 2,
                Type = "Info"
            })
        end
    end
})

Tabs.Jokes:AddToggle("SpinnerModeToggle", {
    Title = "Spinner Mode",
    Description = "Toggle to spin around the selected player!",
    Default = false,
    Callback = function(Value)
        if not spinningInitialized then
            spinningInitialized = true
            return
        end
        if Value then
            if not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Library:Notify({
                    Title = "Error",
                    Content = "No valid player selected!",
                    Duration = 2,
                    Type = "Error"
                })
                return
            end

            local me = game.Players.LocalPlayer.Character.HumanoidRootPart
            local other = selectedPlayer.Character.HumanoidRootPart

            _G.SPIN = true

            spawn(function()
                while _G.SPIN do
                    task.wait(0.01) 
                    if not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        _G.SPIN = false
                        Library:Notify({
                            Title = "Error",
                            Content = "The selected player is no longer valid.",
                            Duration = 2,
                            Type = "Error"
                        })
                        break
                    end

                    local angle = tick() * math.pi 
                    local distance = 5 
                    local newPos = other.Position + Vector3.new(math.cos(angle) * distance, 0, math.sin(angle) * distance)
                    me.CFrame = CFrame.new(newPos, other.Position) 
                end
            end)

            Library:Notify({
                Title = "Spinner Mode",
                Content = "You are spinning around " .. selectedPlayer.Name .. "!",
                Duration = 2,
                Type = "Success"
            })
        else
            _G.SPIN = false
            Library:Notify({
                Title = "Stopped Spinning",
                Content = "You have stopped spinning around the player.",
                Duration = 2,
                Type = "Info"
            })
        end
    end
})

Tabs.Jokes:AddToggle("OrbitModeToggle", {
    Title = "Orbit Mode",
    Description = "Toggle to orbit above the selected player.",
    Default = false,
    Callback = function(Value)
        if not orbitingInitialized then
            orbitingInitialized = true
            return
        end
        if Value then
            if not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Library:Notify({
                    Title = "Error",
                    Content = "No valid player selected!",
                    Duration = 2,
                    Type = "Error"
                })
                return
            end

            local me = game.Players.LocalPlayer.Character.HumanoidRootPart
            local other = selectedPlayer.Character.HumanoidRootPart

            _G.ORBIT = true

            spawn(function()
                while _G.ORBIT do
                    task.wait(0.01)
                    if not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        _G.ORBIT = false
                        Library:Notify({
                            Title = "Error",
                            Content = "The selected player is no longer valid.",
                            Duration = 2,
                            Type = "Error"
                        })
                        break
                    end
                    local angle = tick() * math.pi
                    local distance = 5
                    local height = 10
                    local newPos = other.Position + Vector3.new(math.cos(angle) * distance, height, math.sin(angle) * distance)
                    me.CFrame = CFrame.new(newPos, other.Position)
                end
            end)

            Library:Notify({
                Title = "Orbit Mode",
                Content = "You are orbiting above " .. selectedPlayer.Name .. "!",
                Duration = 2,
                Type = "Success"
            })
        else
            _G.ORBIT = false
            Library:Notify({
                Title = "Stopped Orbiting",
                Content = "You have stopped orbiting the player.",
                Duration = 2,
                Type = "Info"
            })
        end
    end
})
Tabs.Jokes:AddToggle("FollowWithTrailToggle", {
    Title = "Follow with Trail",
    Description = "Toggle to follow the selected player with a trail effect.",
    Default = false,
    Callback = function(Value)
        if not followingInitialized then
            followingInitialized = true
            return
        end
        if Value then
            if not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                Library:Notify({
                    Title = "Error",
                    Content = "No valid player selected!",
                    Duration = 2,
                    Type = "Error"
                })
                return
            end

            local me = game.Players.LocalPlayer.Character.HumanoidRootPart
            local other = selectedPlayer.Character.HumanoidRootPart

            local trail = Instance.new("Trail")
            trail.Parent = me
            trail.Lifetime = 1
            trail.WidthScale = NumberSequence.new(1, 0)
            trail.Attachment0 = Instance.new("Attachment", me)
            trail.Attachment1 = Instance.new("Attachment", other)

            _G.TRAIL_FOLLOW = true

            spawn(function()
                while _G.TRAIL_FOLLOW do
                    task.wait(0.01)
                    if not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        _G.TRAIL_FOLLOW = false
                        trail:Destroy()
                        Library:Notify({
                            Title = "Error",
                            Content = "The selected player is no longer valid.",
                            Duration = 2,
                            Type = "Error"
                        })
                        break
                    end

                    me.CFrame = other.CFrame * CFrame.new(0, 0, 3)
                end
                trail:Destroy()
            end)

            Library:Notify({
                Title = "Follow with Trail",
                Content = "You are following " .. selectedPlayer.Name .. " with a trail!",
                Duration = 2,
                Type = "Success"
            })
        else
            _G.TRAIL_FOLLOW = false
            Library:Notify({
                Title = "Stopped Following",
                Content = "You stopped following with a trail.",
                Duration = 2,
                Type = "Info"
            })
        end
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
