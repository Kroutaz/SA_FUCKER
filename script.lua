local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local Window = Library.CreateLib("SA-FUCKER", "BloodTheme")

-- Player Tabs
local PlrTab = Window:NewTab("Scripts")
local PlrSection = PlrTab:NewSection("Most Used")

PlrSection:NewKeybind("Toggle the GUI", "Press Right_Alt", Enum.KeyCode.RightAlt, function()
    Library:ToggleUI()
end)

PlrSection:NewToggle("15S TS", "Time Stop for 15s [Left_Control]", function(state)
    local function onInputBegan(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
            local args = {15, "jotaroova"}
            game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
        end
    end

    if state then
        game:GetService("UserInputService").InputBegan:Connect(onInputBegan)
    else
        print("off")
    end
end)

local toggleConnection

PlrSection:NewToggle("TS MOVEMENT", "Move in timestops", function(state)
    local function collectParts(parent)
        local parts = {}
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("BasePart") then
                table.insert(parts, child)
            end
            for _, grandChild in ipairs(child:GetChildren()) do
                if grandChild:IsA("BasePart") then
                    table.insert(parts, grandChild)
                end
            end
        end
        return parts
    end

    local function anchorParts(parts, anchor)
        for _, part in ipairs(parts) do
            game:GetService("ReplicatedStorage"):WaitForChild("Anchor"):FireServer(part, anchor)
        end
    end

    local function toggleMovementLoop()
        while state do
            local player = game:GetService("Players").LocalPlayer
            if player and player.Character then
                local character = player.Character
                local partsToToggle = collectParts(character)
                anchorParts(partsToToggle, false)

                local stand = character:FindFirstChild("Stand")
                if stand then
                    local standPartsToToggle = collectParts(stand)
                    anchorParts(standPartsToToggle, false)
                else
                    warn("Stand object not found in character")
                end
            else
                warn("Character not found for LocalPlayer")
            end
            wait(1)
        end
    end

    if state then
        if toggleConnection then
            toggleConnection:Disconnect()
        end
        toggleConnection = coroutine.wrap(toggleMovementLoop)
        toggleConnection()
        print("Movement enabled in timestops")
    else
        if toggleConnection then
            toggleConnection:Disconnect()
        end
        local player = game:GetService("Players").LocalPlayer
        if player and player.Character then
            local character = player.Character
            local partsToToggle = collectParts(character)
            anchorParts(partsToToggle, true)

            local stand = character:FindFirstChild("Stand")
            if stand then
                local standPartsToToggle = collectParts(stand)
                anchorParts(standPartsToToggle, true)
            else
                warn("Stand object not found in character")
            end
        else
            warn("Character not found for LocalPlayer")
        end
        print("Movement disabled in timestops")
    end
end)

local toggleConnection2

PlrSection:NewToggle("STW H", "Get the stw H attack enabled forever", function(state)
    local function attackLoop()
        while state do
            local args = {"Alternate", "STWRTZ", true}
            game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
            wait(1)
        end
    end

    if state then
        if toggleConnection2 then
            toggleConnection2:Disconnect()
        end
        toggleConnection2 = coroutine.wrap(attackLoop)
        toggleConnection2()
        print("Attack enabled")
    else
        state = false
        print("off")
    end
end)

local d4cToggleActive = false
local f2Connection
local f3Connection

-- Services
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Main = ReplicatedStorage:WaitForChild("Main")
local DeathInput = Main:WaitForChild("Death")
local CloneInput = Main:WaitForChild("Input")

-- Flag variables to control holding states for each key
local isHoldingF3 = false
local isHoldingF2 = false

-- Script to be triggered for F3 (Death)
local function triggerDeathScript()
    local args = {
        [1] = "Alternate",
        [2] = "Death"
    }
    DeathInput:FireServer(unpack(args)) -- Trigger the server event
end

-- Script to be triggered for F2 (Clone)
local function triggerCloneScript()
    local args = {
        [1] = "Alternate",
        [2] = "Clone"
    }
    CloneInput:FireServer(unpack(args)) -- Trigger the server event
end

-- Keybind functions to handle both F2 and F3
local function bindKeys()
    -- F3 keybind handling
    f3Connection = UserInputService.InputBegan:Connect(function(input, isProcessed)
        if not isProcessed and input.KeyCode == Enum.KeyCode.F3 then
            if not isHoldingF3 then
                isHoldingF3 = true
                -- Start a loop to continuously trigger the F3 script while holding the key
                while isHoldingF3 do
                    triggerDeathScript()
                    wait(0) -- Adjust delay as necessary
                end
            end
        end
    end)

    -- F2 keybind handling
    f2Connection = UserInputService.InputBegan:Connect(function(input, isProcessed)
        if not isProcessed and input.KeyCode == Enum.KeyCode.F2 then
            if not isHoldingF2 then
                isHoldingF2 = true
                -- Start a loop to continuously trigger the F2 script while holding the key
                while isHoldingF2 do
                    triggerCloneScript()
                    wait(0.1) -- Adjust delay as necessary
                end
            end
        end
    end)

    -- Stop triggering when the keys are released
    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F3 then
            isHoldingF3 = false
        elseif input.KeyCode == Enum.KeyCode.F2 then
            isHoldingF2 = false
        end
    end)
end

-- Unbind keys when the D4C toggle is turned off
local function unbindKeys()
    if f3Connection then f3Connection:Disconnect() end
    if f2Connection then f2Connection:Disconnect() end
    isHoldingF3 = false
    isHoldingF2 = false
end

-- D4C Toggle
PlrSection:NewToggle("D4C CLONES", "Summon D4C Clones with F2 and Death with F3", function(state)
    d4cToggleActive = state
    if d4cToggleActive then
        bindKeys() -- Activate keybinds
        print("D4C clones and death activated")
    else
        unbindKeys() -- Deactivate keybinds
        print("D4C clones and death deactivated")
    end
end)


PlrSection:NewToggle("BLOCK GLITCH", "Toggle blocking", function(state)
    local args = {"Alternate", "Block"}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
    print(state and "Blocking enabled" or "Blocking disabled")
end)

local emeraldSplashConnection

PlrSection:NewToggle("HG EMERALD SPLASH", "Toggle Emerald Splash with [Left_Control]", function(state)
    local function onInputBegan(input, gameProcessedEvent)
        if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.LeftControl then
            for i = 1, 50 do
                local args = {"Alternate", "EmeraldProjectile2", false, game.Players.LocalPlayer:GetMouse().Hit}
                game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
            end
        end
    end

    if state then
        emeraldSplashConnection = game:GetService("UserInputService").InputBegan:Connect(onInputBegan)
        print("Emerald Splash enabled")
    else
        if emeraldSplashConnection then
            emeraldSplashConnection:Disconnect()
            emeraldSplashConnection = nil
        end
        print("Emerald Splash disabled")
    end
end)

local toggleConnectionsans

PlrSection:NewToggle("SANS STAMINA VIEWER", "See sans stamina", function(state)
    if state then
        -- Function to create and update a BillboardGui for displaying stamina
function createOrUpdateStaminaGui(player, staminaValue)
    local character = player.Character
    if not character then return end

    -- Check if the player already has a BillboardGui
    local existingGui = character:FindFirstChild("StaminaGui")
    if existingGui then
        -- Update the existing GUI
        local textLabel = existingGui:FindFirstChild("TextLabel")
        if textLabel then
            textLabel.Text = "Stamina: " .. staminaValue
        end
    else
        -- Create a new BillboardGui
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "StaminaGui"
        billboardGui.Adornee = character:FindFirstChild("Head")
        billboardGui.Size = UDim2.new(0, 150, 0, 50) -- Adjusted size: width of 200 pixels, height of 100 pixels
        billboardGui.StudsOffset = Vector3.new(0, 8, 0)
        billboardGui.MaxDistance = 150 -- Set a reasonable maximum distance for visibility
        billboardGui.AlwaysOnTop = true
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0) -- Using offset for consistent size
        textLabel.BackgroundTransparency = 0 -- Making the background opaque
        textLabel.BackgroundColor3 = Color3.new(0, 0, 1) -- Setting the background color to blue
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.TextScaled = true
        textLabel.Text = "Stamina: " .. staminaValue
        textLabel.Font = Enum.Font.SourceSansBold -- Making the text bold
        textLabel.Parent = billboardGui
        
        billboardGui.Parent = character
    end
end

-- Function to get a player's stamina
function getPlayerStamina(player)
    -- Find the part named after the player in the Workspace
    local playerPart = game.Workspace:FindFirstChild(player.Name)
    
    if playerPart then
        -- If the part is found, find the MaxStamina group in that part
        local maxStamina = playerPart:FindFirstChild("MaxStamina")
        
        if maxStamina then
            -- If MaxStamina is found, find the Stamina value in MaxStamina
            local stamina = maxStamina:FindFirstChild("Stamina")
            
            if stamina then
                -- If Stamina is found, create or update the GUI
                createOrUpdateStaminaGui(player, stamina.Value)
            else

            end
        else

        end
    else

    end
end

-- Function to update all players' stamina GUI
function updateStaminaGuis()
    for _, player in pairs(game.Players:GetPlayers()) do
        getPlayerStamina(player)
    end
end

-- Connect to the PlayerAdded event to ensure new players get their stamina GUI
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        getPlayerStamina(player)
    end)
end)

-- Continuously update stamina GUI every second
while true do
    updateStaminaGuis()
    wait(0.6)
end

        if toggleConnectionsans then
            toggleConnectionsans:Disconnect()
        end
        toggleConnectionsans = coroutine.wrap(attackLoop)
        toggleConnectionsans()
        print("Attack enabled")
    else
        state = false  -- Ensure state is set to false to stop the loop
        print("off")
    end
end)

local riftSliceConnection
local riftSliceActive = false -- Track the state of Rift Slice

PlrSection:NewToggle("REAVER RIFT SLICE", "Toggle Rift Slice with [F]", function(state)
    -- Function to handle F key input
    local function onInputBegan(input, gameProcessedEvent)
        if not gameProcessedEvent and input.KeyCode == Enum.KeyCode.F and not riftSliceActive then
            riftSliceActive = true
            while riftSliceActive do
                local args = {"Alternate", "RiftSlice"}
                game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
                wait(0.05) -- Adjust this delay as needed
            end
        end
    end

    local function onInputEnded(input)
        if input.KeyCode == Enum.KeyCode.F then
            riftSliceActive = false -- Stop firing Rift Slice
        end
    end

    -- If the toggle is on, connect the input handler
    if state then
        riftSliceConnection = game:GetService("UserInputService").InputBegan:Connect(onInputBegan)
        game:GetService("UserInputService").InputEnded:Connect(onInputEnded) -- Stop when F is released
        print("Rift Slice enabled")
    else
        -- If the toggle is off, disconnect the input handler
        if riftSliceConnection then
            riftSliceConnection:Disconnect()
            riftSliceConnection = nil
        end
        print("Rift Slice disabled")
    end
end)


local PlrSection2 = PlrTab:NewSection("Less Used")

local godModeCoroutine
local isGodModeActive = false

PlrSection2:NewToggle("ONI GODMODE", "Give you a lot of immunity frames by spamming C", function(state)
    if state then
        isGodModeActive = true

        local function godModeLoop()
            while isGodModeActive do
                local args = {"Alternate", "Dodge"}
                game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
                wait(0.5)
            end
        end

        if not godModeCoroutine or coroutine.status(godModeCoroutine) == "dead" then
            godModeCoroutine = coroutine.create(godModeLoop)
            coroutine.resume(godModeCoroutine)
        end

        print("Godmode enabled")
    else
        isGodModeActive = false
        print("Godmode disabled")
    end
end)

local knifeConnection
local holdingKnifeConnection

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")

local isHolding = false -- Flag to track if the key is being held down

-- Function to throw the knife
local function throwKnife()
    local targetPosition = mouse.Hit.p
    local args = {
        [1] = "Alternate",
        [2] = "Knife",
        [3] = targetPosition
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
end

-- Toggle function for enabling and disabling the knife throw
PlrSection2:NewToggle("VTW KNIFE", "Toggle knife throw with [1]", function(state)
    if state then
        -- Input began connection
        knifeConnection = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.One and not isHolding then
                isHolding = true
                -- Continuous knife throwing while holding the key "1"
                holdingKnifeConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if isHolding then
                        throwKnife()
                    end
                end)
            end
        end)
        
        -- Input ended connection to stop when key "1" is released
        knifeConnection = UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.One then
                isHolding = false
                if holdingKnifeConnection then
                    holdingKnifeConnection:Disconnect()
                    holdingKnifeConnection = nil
                end
            end
        end)

        print("Knife throw enabled")
    else
        -- Disable knife throwing and clean up connections
        if knifeConnection then
            knifeConnection:Disconnect()
            knifeConnection = nil
        end
        if holdingKnifeConnection then
            holdingKnifeConnection:Disconnect()
            holdingKnifeConnection = nil
        end
        isHolding = false
        print("Knife throw disabled")
    end
end)

local standInvisible = false

PlrSection2:NewToggle("INVISIBLE STAND", "Toggle stand invisibility", function(state)
    local args = {"Alternate", "Appear", tostring(state)}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
    print(state and "Stand made invisible" or "Stand made visible")
end)

local counterCoroutine

PlrSection2:NewToggle("COUNTER STANDLESS", "Toggle automatic counter attack of Standless", function(state)
    local args = {"Alternate", "Counter"}

    local replicatedStorage = game:GetService("ReplicatedStorage")
    local main = replicatedStorage:WaitForChild("Main")
    local input = main:WaitForChild("Input")

    local function counterLoop()
        while state do
            input:FireServer(unpack(args))
            wait(0.5)
        end
    end

    if state then
        counterCoroutine = coroutine.create(counterLoop)
        coroutine.resume(counterCoroutine)
        print("Counter attack of Standless enabled")
    else
        if counterCoroutine then
            coroutine.cancel(counterCoroutine)
            counterCoroutine = nil
        end
        print("Counter attack of Standless disabled")
    end
end)

local triggerConnection

-- Ensure Main and Input are properly defined
local Main = game:GetService("ReplicatedStorage"):WaitForChild("Main")
local Input = Main:WaitForChild("Input")
local UserInputService = game:GetService("UserInputService")

-- Function to trigger server event with specified arguments
local function triggerServerEvent()
    local args = {
        [1] = "Alternate",
        [2] = "RTZ",
        [3] = true
    }

    Input:FireServer(unpack(args)) -- Trigger the server event with the provided args
end

-- Toggle for enabling and disabling the event trigger
PlrSection2:NewToggle("GER RTZ", "Toggle RTZ with [B]", function(state)
    if state then
        -- Input began connection
        triggerConnection = UserInputService.InputBegan:Connect(function(input, isProcessed)
            if not isProcessed then -- Check if the input was not processed by other input handlers
                if input.KeyCode == Enum.KeyCode.B then
                    triggerServerEvent() -- Call the function when B is pressed
                end
            end
        end)
        print("RTZ event trigger enabled")
    else
        -- Disable event triggering
        if triggerConnection then
            triggerConnection:Disconnect()
            triggerConnection = nil
        end
        print("RTZ event trigger disabled")
    end
end)

PlrSection2:NewButton("REAPER SPAM SCYTHE", "Work until you die..", function()
repeat
local args = {
    [1] = "Alternate",
    [2] = "Throw2"
}

game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))
local args = {
    [1] = "Alternate",
    [2] = "Throw"
}

game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Input"):FireServer(unpack(args))

wait(0.4)
until game.Players.LocalPlayer.Character.Humanoid.Health <= 0
end)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local healthGui = nil -- Store the health GUI here
local toggleConnection = nil -- To manage the connection

-- Function to create the health bar GUI
local function createHealthBar()
    local character = player.Character or player.CharacterAdded:Wait()

    healthGui = Instance.new("BillboardGui")
    healthGui.Adornee = character:WaitForChild("Head")
    healthGui.Size = UDim2.new(0, 200, 0, 40)
    healthGui.StudsOffset = Vector3.new(0, 3, 0)

    local healthFrame = Instance.new("Frame")
    healthFrame.Size = UDim2.new(1, 0, 0.5, 0)
    healthFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    healthFrame.BorderSizePixel = 0
    healthFrame.Parent = healthGui

    local healthFill = Instance.new("Frame")
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthFrame

    local healthText = Instance.new("TextLabel")
    healthText.Size = UDim2.new(1, 0, 0.5, 0)
    healthText.BackgroundTransparency = 1
    healthText.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthText.Font = Enum.Font.SourceSansBold
    healthText.TextScaled = true
    healthText.TextStrokeTransparency = 0.5
    healthText.Parent = healthGui

    healthGui.Parent = character

    -- Update health bar color and text
    local function updateHealthColorAndText(healthPercent)
        local redValue = math.clamp(255 * (1 - healthPercent), 0, 255)
        local greenValue = math.clamp(255 * healthPercent, 0, 255)
        
        healthFill.BackgroundColor3 = Color3.fromRGB(redValue, greenValue, 0)

        local percentHealth = math.floor(healthPercent * 100)
        healthText.Text = percentHealth .. "%"
    end

    -- Update health bar size and color based on health percentage
    local function updateHealth()
        while healthGui do
            wait(0.1)
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                local healthPercent = humanoid.Health / humanoid.MaxHealth

                healthFill.Size = UDim2.new(healthPercent, 0, 1, 0)
                updateHealthColorAndText(healthPercent)
            end
            wait(0.5)
        end
    end

    spawn(updateHealth) -- Run updateHealth in a separate thread
end

-- Toggle functionality for the health bar GUI
PlrSection2:NewToggle("HEALTH BAR", "Toggle player health bar", function(state)
    if state then
        -- Create health bar when the toggle is on
        toggleConnection = player.CharacterAdded:Connect(createHealthBar)
        
        if player.Character then
            createHealthBar() -- Create health bar immediately if character exists
        end
        print("Health bar enabled")
    else
        -- Destroy health bar and disconnect event when the toggle is off
        if healthGui then
            healthGui:Destroy()
            healthGui = nil
        end

        if toggleConnection then
            toggleConnection:Disconnect()
            toggleConnection = nil
        end
        print("Health bar disabled")
    end
end)

local TsSoundsTab = Window:NewTab("Ts Sounds")
local TsSoundsSection = TsSoundsTab:NewSection("Scripts")

TsSoundsSection:NewButton("(OLD) TW OVA TS", "15s TS", function()
    local args = {15, "dioova"}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
end)

TsSoundsSection:NewButton("(OLD) JOTARO OVA TS", "15s TS", function()
    local args = {15, "jotaroova"}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
end)

TsSoundsSection:NewButton("JSP TS", "15s TS", function()
    local args = {15, "jotaro"}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
end)

TsSoundsSection:NewButton("SPTW TS", "15s TS", function()
    local args = {15, "P4"}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
end)

TsSoundsSection:NewButton("TWOH TS", "15s TS", function()
    local args = {15, "diooh"}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
end)

TsSoundsSection:NewButton("SHADOW DIO TS", "15s TS", function()
    local args = {15, "shadowdio"}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
end)

TsSoundsSection:NewButton("TW TS", "15s TS", function()
    local args = {15, "theworldnew"}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
end)

TsSoundsSection:NewButton("TWAU TS", "15s TS", function()
    local args = {15, "diego"}
    game:GetService("ReplicatedStorage"):WaitForChild("Main"):WaitForChild("Timestop"):FireServer(unpack(args))
end)

local MainTab = Window:NewTab("Sound")
local MainSection = MainTab:NewSection("Sound Control")

local sounds = {}
local lastPlayedSound
local soundLoopActive = false
local soundCount = 1

function getSounds(loc)
    if loc:IsA("Sound") then
        table.insert(sounds, loc)
    end
    for _, obj in pairs(loc:GetChildren()) do
        getSounds(obj)
    end
end

getSounds(game)

game.DescendantAdded:Connect(function(obj)
    if obj:IsA("Sound") then
        table.insert(sounds, obj)
    end
end)

function getRandomSound()
    if #sounds == 0 then return nil end

    local randomSound
    local attempt = 0
    repeat
        local randomIndex = math.random(1, #sounds)
        randomSound = sounds[randomIndex]
        attempt = attempt + 1
    until randomSound ~= lastPlayedSound or attempt > 10

    if attempt > 10 then return nil end
    lastPlayedSound = randomSound
    return randomSound
end

MainSection:NewToggle("Toggle Sounds", "Turn sound playback on/off", function(state)
    soundLoopActive = state
end)

MainSection:NewSlider("Number of Sounds", "Set how many sounds to play at once", 10, 1, function(value)
    soundCount = value
end)

coroutine.wrap(function()
    while wait(0.1) do
        if soundLoopActive and #sounds > 0 then
            for i = 1, soundCount do
                local soundToPlay = getRandomSound()
                if soundToPlay then
                    pcall(function()
                        soundToPlay:Stop()
                        soundToPlay:Play()
                    end)
                end
            end
        end
    end
end)()

-- Map Tps
local MapTab = Window:NewTab("Map")
local MapSection = MapTab:NewSection("TP")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local DropdownOptions = {}

-- Function to update dropdown with player names
local function UpdateDropdown()
    DropdownOptions = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(DropdownOptions, player.Name)
        end
    end
    -- Recreate the dropdown with updated player list
    MapSection:NewDropdown("Players", "Select a player to teleport", DropdownOptions, function(selectedPlayerName)
        local selectedPlayer = Players:FindFirstChild(selectedPlayerName)
        if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Teleport LocalPlayer to the selected player's HumanoidRootPart position
            LocalPlayer.Character:SetPrimaryPartCFrame(selectedPlayer.Character.HumanoidRootPart.CFrame)
        end
    end)
end

-- Initialize the dropdown
UpdateDropdown()

-- Connect to player join and leave events to update dropdown
Players.PlayerAdded:Connect(UpdateDropdown)
Players.PlayerRemoving:Connect(UpdateDropdown)

MapSection:NewButton("Middle", "ButtonInfo", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(1345, 623, -506)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)

MapSection:NewButton("Farm Zone", "ButtonInfo", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(-285, 511, -1486)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)

MapSection:NewButton("Base Plate", "ButtonInfo", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(-96, 25, -580)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)

MapSection:NewButton("Zelda Moon", "ButtonInfo", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(1346, 2208, 746)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)


MapSection:NewButton("Loading Screen", "ButtonInfo", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(2116, 670, -519)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)

MapSection:NewButton("Stand Changer Npc", "ButtonInfo", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(1397, 590, -218)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)

MapSection:NewButton("Arena Left", "ButtonInfo", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(1316, 633, -280)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)

MapSection:NewButton("Arena Right", "ButtonInfo", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(1178, 633, -280)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)


MapSection:NewButton("Rachael House", "ButtonInfo", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(1037, 633, -183)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)

MapSection:NewButton("Waterfall", "ButtonInfo", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(1628, 623, -747)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)

MapSection:NewButton("Boss Entrace", "ButtonInfo", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(1124, 624, -741)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)

MapSection:NewButton("D4C", "ButtonInfo", function() 
    -- Coordinates to teleport to (replace with your desired coordinates)
    local teleportCoords = Vector3.new(-3092, 500, -440)

    -- Get the player's character and its HumanoidRootPart
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

    -- Teleport the character to the specified coordinates
    humanoidRootPart.CFrame = CFrame.new(teleportCoords)
end)

-- Cosmetics
local CosTab = Window:NewTab("Cosmetics")
local CosSection = CosTab:NewSection("Cosmetics")

-- Place this script in StarterGui

local player = game.Players.LocalPlayer

-- Function to create the GUI
local function createGUI()
    -- Load Kavo UI Library
    local success, Library = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    end)

    if not success or not Library then
        warn("Failed to load Kavo UI Library.")
        return
    end

    -- Initialize variables for modelId, yOffset, and loadedModel
    local modelId = nil
    local yOffset = 2
    local loadedModel = nil -- Variable to store the currently loaded model

    -- Function to notify the player
    local function notify(message)
        game.StarterGui:SetCore("SendNotification", {
            Title = "Model Loader",
            Text = message,
            Duration = 5,
        })
    end

    -- Add a TextBox for the Model ID input
    CosSection:NewTextBox("Model ID", "Enter the model ID here", function(txt)
        modelId = tonumber(txt) -- Store the model ID from input
        print("Model ID entered: ", modelId) -- Debugging print
    end)

    -- Add a TextBox for Y-coordinate offset input
    CosSection:NewTextBox("Y Offset", "Enter Y offset here", function(txt)
        yOffset = tonumber(txt) or 2 -- Store the Y offset from input, default to 2 if not provided
        print("Y Offset entered: ", yOffset) -- Debugging print
    end)

    -- Function to run the model loading script
    local function runModelLoader()
        if not modelId then
            notify("Please enter a valid model ID.")
            return
        end

        local success, err = pcall(function()
            -- Delete the previously loaded model if it exists
            if loadedModel then
                loadedModel:Destroy()
                loadedModel = nil
            end

            local character = player.Character or player.CharacterAdded:Wait()
            local stand = character:WaitForChild("Stand")
            local standTorso = stand:WaitForChild("Stand Torso")

            -- Create a central part to act as the anchor
            local centralPart = Instance.new("Part")
            centralPart.Size = Vector3.new(1, 1, 1)
            centralPart.Color = Color3.fromRGB(169, 169, 169)
            centralPart.Material = Enum.Material.SmoothPlastic
            centralPart.Anchored = true
            centralPart.CanCollide = false
            centralPart.Transparency = 1
            centralPart.Parent = character

            -- Position the central part at the torso's position
            centralPart.CFrame = standTorso.CFrame

            -- Load the model directly using its asset ID
            loadedModel = game:GetObjects("rbxassetid://" .. modelId)[1]

            if not loadedModel then
                error("Model could not be loaded.")
            end

            -- Check if the model has a PrimaryPart
            if loadedModel:IsA("Model") then
                loadedModel.PrimaryPart = loadedModel:FindFirstChild("PrimaryPart") or loadedModel:FindFirstChildOfClass("BasePart")
                if not loadedModel.PrimaryPart then
                    for _, part in ipairs(loadedModel:GetDescendants()) do
                        if part:IsA("BasePart") then
                            loadedModel.PrimaryPart = part
                            break
                        end
                    end
                end
            end

            loadedModel.Parent = workspace

            for _, part in pairs(loadedModel:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.Anchored = true
                end
            end

            if loadedModel.PrimaryPart then
                loadedModel:SetPrimaryPartCFrame(centralPart.CFrame * CFrame.new(0, yOffset, 0))
            else
                warn("Model does not have a valid PrimaryPart.")
            end

            centralPart.Transparency = 1
            centralPart.CanCollide = false

            local heartbeatConnection
            heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if not (loadedModel and loadedModel.Parent) then
                    heartbeatConnection:Disconnect() -- Disconnect if model is no longer valid
                    return
                end

                centralPart.CFrame = standTorso.CFrame
                if loadedModel.PrimaryPart then
                    loadedModel:SetPrimaryPartCFrame(centralPart.CFrame * CFrame.new(0, yOffset, 0))
                end

                for _, part in pairs(stand:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        part.Transparency = 1
                    end
                end
                for _, part in pairs(loadedModel:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Anchored = true
                        part.CanCollide = false
                    end
                end
            end)

            player.CharacterRemoving:Connect(function()
                if loadedModel then
                    loadedModel:Destroy() -- Clean up the model when the character is removed
                    loadedModel = nil
                end
                centralPart:Destroy()
            end)
        end)

        if success then
            notify("The model loaded successfully. Enjoy!")
        else
            notify("Failed to load the model: " .. err)
            warn("Error loading model: " .. err)
        end
    end

    -- Add a "Run" button
    CosSection:NewButton("Run", "Load the model", runModelLoader)
end

-- Create the GUI when the player spawns
player.CharacterAdded:Connect(function()
    wait(1) -- Wait a moment for character to load
    print("nvm")
end)

-- Create the GUI for the first time
createGUI()

-- Others
local OthersTab = Window:NewTab("Others")
local OthersSection = OthersTab:NewSection("Scripts")

OthersSection:NewButton("Infinite yield", "ButtonInfo", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

OthersSection:NewButton("FE HUB", "ButtonInfo", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/yofriendfromschool1/Sky-Hub/main/FE%20Trolling%20GUI.luau"))()
end)

OthersSection:NewButton("MOOVE CHECKER", "ButtonInfo", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Kroutaz/Move/refs/heads/main/codelearner.lua"))()
end)

local CreditsTab = Window:NewTab("Credits")
local CreditsSection = CreditsTab:NewSection("Credits")

CreditsSection:NewButton("Kroutaz", "Made the guis, found some of the scripts.", function(txt)
    print(txt)
end)

CreditsSection:NewButton("KashmirMommy", "Found most of the scripts with rspy, helped a lot.", function(txt)
    print(txt)
end)
