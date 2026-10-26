
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "lightninghax Break in (Story)",
    LoadingTitle = "Loading Break In ...",
    LoadingSubtitle = "by @ikonned",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ExampleHubaea2",
        FileName = "Settingsaea2"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false,
})

Rayfield:Notify({
   Title = "Break In UI Successfully Loaded",
   Content = "By @ikonned",
   Duration = 11.5,
   Image = 98381986793772,
})

-- TABS
local LobbyTab = Window:CreateTab("Lobby", 98381986793772)
local HomeTab = Window:CreateTab("Home", 14380950090)
local ESPTab = Window:CreateTab("ESP", 10448639430)
local ExploitsTab = Window:CreateTab("Exploits", 16587986504)
local ItemsTab = Window:CreateTab("Items", 12771178448)
local ExtraTab = Window:CreateTab("Extra", 11782229944)

---------------------------------------------------
-- LOBBY BUTTONS
---------------------------------------------------

-- PARAGRAPH
LobbyTab:CreateParagraph({
    Title = "Note:",
    Content = "Only for Lobby"
})

LobbyTab:CreateButton({
    Name = "Police Officer",
    Callback = function()
        local A_1 = "Gun"
        local A_2 = true
        local Event = game:GetService("ReplicatedStorage").RemoteEvents.OutsideRole
        Event:FireServer(A_1, A_2)
    end
})

LobbyTab:CreateButton({
    Name = "SWAT",
    Callback = function()
            local A_1 = "Gun"
    local A_1 = "SwatGun"
local A_2 = true
local Event = game:GetService("ReplicatedStorage").RemoteEvents.OutsideRole
Event:FireServer(A_1, A_2)
         
    end,
})

---------------------------------------------------
-- HOME BUTTONS
---------------------------------------------------

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local flying = false
local flyConn
local bodyGyro
local bodyVelocity

HomeTab:CreateToggle({
	Name = "Float",
	CurrentValue = false,
	Callback = function(Value)

		flying = Value

		local char = player.Character or player.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")
		local humanoid = char:WaitForChild("Humanoid")

		if Value then
			humanoid.PlatformStand = true

			bodyGyro = Instance.new("BodyGyro")
			bodyGyro.MaxTorque = Vector3.new(1e9,1e9,1e9)
			bodyGyro.P = 1e5
			bodyGyro.CFrame = hrp.CFrame
			bodyGyro.Parent = hrp

			bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.MaxForce = Vector3.new(1e9,1e9,1e9)
			bodyVelocity.Velocity = Vector3.zero
			bodyVelocity.Parent = hrp

			flyConn = RunService.RenderStepped:Connect(function()

				local cam = workspace.CurrentCamera
				local move = Vector3.zero

				if UserInputService:IsKeyDown(Enum.KeyCode.W) then
					move += cam.CFrame.LookVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then
					move -= cam.CFrame.LookVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then
					move -= cam.CFrame.RightVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then
					move += cam.CFrame.RightVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
					move += Vector3.new(0,1,0)
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
					move -= Vector3.new(0,1,0)
				end

				bodyVelocity.Velocity = move * 60
				bodyGyro.CFrame = cam.CFrame
			end)

		else
			if flyConn then flyConn:Disconnect() end
			if bodyGyro then bodyGyro:Destroy() end
			if bodyVelocity then bodyVelocity:Destroy() end

			humanoid.PlatformStand = false
		end
	end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local noclip = false
local noclipConnection

HomeTab:CreateToggle({
	Name = "Noclip",
	CurrentValue = false,
	Callback = function(Value)

		noclip = Value

		if Value then
			noclipConnection = RunService.Stepped:Connect(function()
				local char = player.Character
				if not char then return end

				for _, part in pairs(char:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end)

		else
			if noclipConnection then
				noclipConnection:Disconnect()
				noclipConnection = nil
			end

			local char = player.Character
			if char then
				for _, part in pairs(char:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = true
					end
				end
			end
		end

	end
})

HomeTab:CreateSlider({
	Name = "Walk Speed",
	Range = {16, 100},
	Increment = 1,
	CurrentValue = 16,
	Callback = function(Value)

		local char = player.Character or player.CharacterAdded:Wait()
		local humanoid = char:WaitForChild("Humanoid")

		humanoid.WalkSpeed = Value

		-- keep speed after respawn (still inside slider system)
		player.CharacterAdded:Connect(function(newChar)
			task.wait(0.5)
			local hum = newChar:WaitForChild("Humanoid")
			hum.WalkSpeed = Value
		end)

	end
})

HomeTab:CreateSlider({
    Name = "FOV Changer",
    Range = {70, 120},
    Increment = 1,
    Suffix = "FOV",
    CurrentValue = 70,
    Flag = "FOVSlider",
    Callback = function(Value)
        game.Workspace.CurrentCamera.FieldOfView = Value
    end,
})

HomeTab:CreateButton({
    Name = "Body Glow",
    Callback = function()
        local LocalPlayer = game.Players.LocalPlayer
        local pointLight = Instance.new("PointLight")
        local surfaceLight = Instance.new("SurfaceLight")
        
        pointLight.Brightness = 0.75
        surfaceLight.Brightness = 0.25
        pointLight.Range = 20
        surfaceLight.Range = 90
        
        lights = {pointLight, surfaceLight}
        
        if LocalPlayer.Character then
            pointLight.Parent = LocalPlayer.Character.HumanoidRootPart
            surfaceLight.Parent = LocalPlayer.Character.Head
        end


    end,
})

---------------------------------------------------
-- ESP
---------------------------------------------------

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LOCAL_PLAYER = Players.LocalPlayer

local PLAYER_COLOR = Color3.fromRGB(255, 255, 255) -- White
local CAT_COLOR = Color3.fromRGB(255, 255, 0)      -- Yellow
local DISH_COLOR = Color3.fromRGB(255, 170, 0)     -- Orange
local VAULT_COLOR = Color3.fromRGB(0, 120, 255)    -- Blue

---------------------------------------------------
-- BOX ESP CORE
-- No names or BillboardGuis
---------------------------------------------------

local espObjects = {}

local function getAnchor(object)
    if not object then
        return nil
    end

    if object:IsA("BasePart") then
        return object
    end

    if object:IsA("Model") then
        return object.PrimaryPart
            or object:FindFirstChild("HumanoidRootPart", true)
            or object:FindFirstChildWhichIsA("BasePart", true)
    end

    return object:FindFirstChildWhichIsA("BasePart", true)
end

local function getBounds(object, anchor)
    if object:IsA("Model") then
        return object:GetBoundingBox()
    end

    if object:IsA("BasePart") then
        return object.CFrame, object.Size
    end

    return anchor.CFrame, anchor.Size
end

local function removeESP(object)
    if not object then
        return
    end

    local data = espObjects[object]
    if not data then
        return
    end

    espObjects[object] = nil

    if data.box then
        data.box:Destroy()
    end
end

local function createESP(object, color)
    if not object or not object.Parent then
        return
    end

    local existing = espObjects[object]

    if existing then
        existing.color = color
        if existing.box then
            existing.box.Color3 = color
        end
        return
    end

    local anchor = getAnchor(object)
    if not anchor then
        return
    end

    local box = Instance.new("BoxHandleAdornment")
    box.Name = "ESP_BOX"
    box.Adornee = anchor
    box.Color3 = color
    box.Transparency = 0.48
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = Vector3.new(1, 1, 1)
    box.Parent = anchor

    espObjects[object] = {
        box = box,
        anchor = anchor,
        color = color,
    }
end

---------------------------------------------------
-- UPDATE BOX POSITIONS AND SIZES
---------------------------------------------------

RunService.Heartbeat:Connect(function()
    for object, data in pairs(espObjects) do
        if not object.Parent then
            removeESP(object)
            continue
        end

        local anchor = getAnchor(object)

        if not anchor then
            removeESP(object)
            continue
        end

        -- Recreate the box if its previous adornee was removed.
        if not data.box or not data.box.Parent then
            local box = Instance.new("BoxHandleAdornment")
            box.Name = "ESP_BOX"
            box.Adornee = anchor
            box.Color3 = data.color
            box.Transparency = 0.2
            box.AlwaysOnTop = true
            box.ZIndex = 10
            box.Size = Vector3.new(1, 1, 1)
            box.Parent = anchor

            data.box = box
            data.anchor = anchor
        elseif data.anchor ~= anchor then
            data.box.Parent = anchor
            data.box.Adornee = anchor
            data.anchor = anchor
        end

        local success, boundsCFrame, boundsSize = pcall(function()
            return getBounds(object, anchor)
        end)

        if success and data.box and data.box.Parent then
            data.box.CFrame = anchor.CFrame:ToObjectSpace(boundsCFrame)
            data.box.Size = boundsSize
            data.box.Color3 = data.color
        end
    end
end)

---------------------------------------------------
-- PLAYER ESP: WHITE BOX, NO NAMES
---------------------------------------------------

local playerESPEnabled = false
local playerCharacterConnections = {}

local function updatePlayerESP(player, character)
    if player == LOCAL_PLAYER or not character then
        return
    end

    if not playerESPEnabled then
        removeESP(character)
        return
    end

    task.spawn(function()
        character:WaitForChild("HumanoidRootPart", 10)

        if playerESPEnabled
            and player.Character == character
            and character.Parent then

            createESP(character, PLAYER_COLOR)
        end
    end)
end

local function trackPlayer(player)
    if player == LOCAL_PLAYER or playerCharacterConnections[player] then
        return
    end

    playerCharacterConnections[player] =
        player.CharacterAdded:Connect(function(character)
            updatePlayerESP(player, character)
        end)

    if player.Character then
        updatePlayerESP(player, player.Character)
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    trackPlayer(player)
end

Players.PlayerAdded:Connect(trackPlayer)

Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        removeESP(player.Character)
    end

    local connection = playerCharacterConnections[player]

    if connection then
        connection:Disconnect()
        playerCharacterConnections[player] = nil
    end
end)

ESPTab:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,

    Callback = function(value)
        playerESPEnabled = value

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LOCAL_PLAYER and player.Character then
                if value then
                    updatePlayerESP(player, player.Character)
                else
                    removeESP(player.Character)
                end
            end
        end
    end
})

---------------------------------------------------
-- HELPER: FIND TARGETS INSIDE THE HOUSE
---------------------------------------------------

local function getHouse()
    return workspace:FindFirstChild("TheHouse")
end

---------------------------------------------------
-- CAT ESP: YELLOW BOX
---------------------------------------------------

local catESPEnabled = false
local catESPGeneration = 0
local currentCatTarget = nil

ESPTab:CreateToggle({
    Name = "Cat ESP",
    CurrentValue = false,

    Callback = function(value)
        catESPEnabled = value
        catESPGeneration += 1

        local generation = catESPGeneration

        if not value then
            if currentCatTarget then
                removeESP(currentCatTarget)
                currentCatTarget = nil
            end

            return
        end

        task.spawn(function()
            while catESPEnabled
                and generation == catESPGeneration do

                local house = getHouse()
                local cat = house
                    and house:FindFirstChild("SmallCat", true)

                if cat ~= currentCatTarget then
                    if currentCatTarget then
                        removeESP(currentCatTarget)
                    end

                    currentCatTarget = cat
                end

                if cat then
                    createESP(cat, CAT_COLOR)
                end

                task.wait(0.5)
            end
        end)
    end
})

---------------------------------------------------
-- VAULT ESP: BLUE BOX
---------------------------------------------------

local vaultESPEnabled = false
local vaultESPGeneration = 0
local currentVaultTarget = nil

ESPTab:CreateToggle({
    Name = "Vault ESP",
    CurrentValue = false,

    Callback = function(value)
        vaultESPEnabled = value
        vaultESPGeneration += 1

        local generation = vaultESPGeneration

        if not value then
            if currentVaultTarget then
                removeESP(currentVaultTarget)
                currentVaultTarget = nil
            end

            return
        end

        task.spawn(function()
            while vaultESPEnabled
                and generation == vaultESPGeneration do

                local vault = workspace:FindFirstChild("OpenVault", true)

                if vault ~= currentVaultTarget then
                    if currentVaultTarget then
                        removeESP(currentVaultTarget)
                    end

                    currentVaultTarget = vault
                end

                if vault then
                    createESP(vault, VAULT_COLOR)
                end

                task.wait(0.5)
            end
        end)
    end
})

---------------------------------------------------
-- DISH ESP
-- Checks Pan1, Pan2, Pan3 ... Pan7 and beyond.
-- Uses EmptyDish inside a pan when present.
-- Otherwise, boxes the pan itself.
---------------------------------------------------

local dishESPEnabled = false
local dishESPGeneration = 0
local trackedDishTargets = {}

local function getDishTargets()
    local targets = {}

    local house = getHouse()
    local kitchenSink = house
        and house:FindFirstChild("Kitchen Sink", true)

    if not kitchenSink then
        return targets
    end

    for _, object in ipairs(kitchenSink:GetDescendants()) do
        local panNumber = object.Name:lower()

        if panNumber:match("^pan%d+$")
            and (object:IsA("Model") or object:IsA("BasePart")) then

            local dish = object:FindFirstChild("EmptyDish", true)

            if dish and (
                dish:IsA("Model")
                or dish:IsA("BasePart")
                or dish:FindFirstChildWhichIsA("BasePart", true)
            ) then
                targets[dish] = true
            else
                targets[object] = true
            end
        end
    end

    return targets
end

ESPTab:CreateToggle({
    Name = "Dish ESP",
    CurrentValue = false,

    Callback = function(value)
        dishESPEnabled = value
        dishESPGeneration += 1

        local generation = dishESPGeneration

        if not value then
            for target in pairs(trackedDishTargets) do
                removeESP(target)
                trackedDishTargets[target] = nil
            end

            return
        end

        task.spawn(function()
            while dishESPEnabled
                and generation == dishESPGeneration do

                local foundTargets = getDishTargets()

                -- Remove boxes for pans or dishes that disappeared.
                for target in pairs(trackedDishTargets) do
                    if not foundTargets[target] then
                        removeESP(target)
                        trackedDishTargets[target] = nil
                    end
                end

                -- Add boxes for newly detected pans or dishes.
                for target in pairs(foundTargets) do
                    if not trackedDishTargets[target] then
                        createESP(target, DISH_COLOR)
                        trackedDishTargets[target] = true
                    end
                end

                task.wait(0.5)
            end
        end)
    end
})

---------------------------------------------------
-- EXISTING FRIDGE / OVEN COLOUR-CYCLING HELPERS
---------------------------------------------------

local function getColorTargets(root)
    local targets = {}

    if not root then
        return targets
    end

    if root:IsA("BasePart") then
        table.insert(targets, root)
    else
        for _, obj in ipairs(root:GetDescendants()) do
            if obj:IsA("BasePart") then
                table.insert(targets, obj)
            end
        end
    end

    return targets
end

local fridgeCycling = false
local ovenCycling = false

local function smoothCycle(root, runningCheck, onFinish)
    local objects = getColorTargets(root)

    task.spawn(function()
        while runningCheck() and root and root.Parent do
            for i = 0, 1, 0.01 do
                if not runningCheck() or not root or not root.Parent then
                    if onFinish then
                        onFinish()
                    end

                    return
                end

                local color

                if i < 0.33 then
                    color = Color3.new(1, 1, 1):Lerp(
                        Color3.new(1, 0, 0),
                        i / 0.33
                    )
                elseif i < 0.66 then
                    color = Color3.new(1, 0, 0):Lerp(
                        Color3.new(1, 1, 1),
                        (i - 0.33) / 0.33
                    )
                else
                    color = Color3.new(1, 1, 1):Lerp(
                        Color3.fromRGB(60, 30, 10),
                        (i - 0.66) / 0.34
                    )
                end

                for _, part in ipairs(objects) do
                    if part and part.Parent then
                        part.Color = color
                    end
                end

                task.wait(0.05)
            end
        end

        if onFinish then
            onFinish()
        end
    end)
end

ESPTab:CreateButton({
	Name = "Fridge Chams",
	Callback = function()
		if fridgeCycling then return end

		local house = workspace:FindFirstChild("TheHouse")
		local fridge = house and house:FindFirstChild("Fridge")
		if not fridge then return end

		fridgeCycling = true
		smoothCycle(fridge, function()
			return fridgeCycling
		end, function()
			fridgeCycling = false
		end)
	end
})

ESPTab:CreateButton({
	Name = "Oven Chams",
	Callback = function()
		if ovenCycling then return end

		local house = workspace:FindFirstChild("TheHouse")
		local oven = house and house:FindFirstChild("Oven")
		if not oven then return end

		ovenCycling = true
		smoothCycle(oven, function()
			return ovenCycling
		end, function()
			ovenCycling = false
		end)
	end
})

---------------------------------------------------
-- EXPLOITS
---------------------------------------------------

-- PARAGRAPH
ExploitsTab:CreateParagraph({
    Title = "Note:",
    Content = "Find the Vault before Opening the Vault"
})

ExploitsTab:CreateButton({
    Name = "Befriend Cat",
    Callback = function()

        local Target = game:GetService("ReplicatedStorage").RemoteEvents.Cattery
        Target:FireServer()

        Rayfield:Notify({
            Title = "Cat Befriended",
            Content = "Execute Successful",
            Duration = 9.5,
            Image = 10448639430,
        })

    end,
})

ExploitsTab:CreateButton({
    Name = "Inf Loop + Befriend Cat [ CRASHES SERVER ]",
    Callback = function()

    local Target = game:GetService("ReplicatedStorage").RemoteEvents.Cattery

    while task.wait(0) do
    Target:FireServer()
end

    end,
})

ExploitsTab:CreateButton({
    Name = "Regenerate Health",
    Callback = function()

        for i = 1, 200 do
            wait(0.005)

            local A_1 = "Cat"
            local Event = game:GetService("ReplicatedStorage").RemoteEvents.Energy

            Event:FireServer(A_1)
        end

        Rayfield:Notify({
            Title = "Health Regenerated",
            Content = "Execute Successful",
            Duration = 4.5,
            Image = 128170076314731,
        })

    end,
})

ExploitsTab:CreateButton({
    Name = "Bloxy Cola Pack/Pie Dish",
    Callback = function()

        game.ReplicatedStorage.RemoteEvents.BloxyPack:FireServer(1)

        Rayfield:Notify({
            Title = "Bloxy Cola Pack/Pie Dish Spawned",
            Content = "Executed Successful",
            Duration = 5,
            Image = 14380950090,
        })

    end
})

ExploitsTab:CreateButton({
    Name = "Open Vault",
    Callback = function()

        game.ReplicatedStorage.RemoteEvents.Safe:FireServer(
            game:GetService("Workspace").CodeNote.SurfaceGui.TextLabel.Text
        )

        Rayfield:Notify({
            Title = "Vault Opened",
            Content = "Execute Successful",
            Duration = 5,
            Image = 14380950090,
        })

    end,
})

ExploitsTab:CreateButton({
    Name = "Kill Enemies",
    Callback = function()

        for i,v in pairs(game.Workspace.BadGuys:GetChildren()) do
            for i = 1, 50 do
                game:GetService("ReplicatedStorage").RemoteEvents.HitBadguy:FireServer(v,10)
                game:GetService("ReplicatedStorage").RemoteEvents.HitBadguy:FireServer(v,996)
                game:GetService("ReplicatedStorage").RemoteEvents.HitBadguy:FireServer(v,9)
                game:GetService("ReplicatedStorage").RemoteEvents.HitBadguy:FireServer(v,8)
                game:GetService("ReplicatedStorage").RemoteEvents.HitBadguy:FireServer(v,996)
            end
        end

        Rayfield:Notify({
            Title = "Enemies Killed",
            Content = "Execute Successful",
            Duration = 5,
            Image = 11924266902,
        })

    end,
})

---------------------------------------------------
-- ITEMS
---------------------------------------------------

ItemsTab:CreateButton({
    Name = "Chips",
    Callback = function()
game.ReplicatedStorage.RemoteEvents.GiveTool:FireServer("Chips")


    end
})

ItemsTab:CreateButton({
    Name = "Lollipop",
    Callback = function()
game.ReplicatedStorage.RemoteEvents.GiveTool:FireServer("Lollipop")

    end
})

ItemsTab:CreateButton({
    Name = "Apple",
    Callback = function()
game.ReplicatedStorage.RemoteEvents.GiveTool:FireServer("Apple")

    end
})

ItemsTab:CreateButton({
    Name = "Cookie",
    Callback = function()
 game.ReplicatedStorage.RemoteEvents.GiveTool:FireServer("Cookie")


    end
})

ItemsTab:CreateButton({
    Name = "Small Pizza",
    Callback = function()
game.ReplicatedStorage.RemoteEvents.GiveTool:FireServer("Pizza1")

    end
})

ItemsTab:CreateButton({
    Name = "Normal Pizza",
    Callback = function()
game.ReplicatedStorage.RemoteEvents.GiveTool:FireServer("Pizza2")

    end
})

ItemsTab:CreateButton({
    Name = "Large Pizza",
    Callback = function()
game.ReplicatedStorage.RemoteEvents.GiveTool:FireServer("Pizza3")

    end
})

ItemsTab:CreateButton({
    Name = "Expired Bloxy Cola",
    Callback = function()
 game.ReplicatedStorage.RemoteEvents.GiveTool:FireServer("ExpiredBloxyCola")


    end
})

ItemsTab:CreateButton({
    Name = "Bloxy Cola",
    Callback = function()
 game.ReplicatedStorage.RemoteEvents.GiveTool:FireServer("BloxyCola")


    end
})

ItemsTab:CreateButton({
    Name = "Medkit",
    Callback = function()
game.ReplicatedStorage.RemoteEvents.GiveTool:FireServer("MedKit")

    end
})

ItemsTab:CreateButton({
    Name = "Cure",
    Callback = function()
game.ReplicatedStorage.RemoteEvents.GiveTool:FireServer("Cure")

    end
})

ItemsTab:CreateButton({
    Name = "Teddy",
    Callback = function()
game.ReplicatedStorage.RemoteEvents.GiveTool:FireServer("TeddyBloxpin")


    end
})

ItemsTab:CreateButton({
    Name = "Bat",
    Callback = function()
game.ReplicatedStorage.RemoteEvents.GiveTool:FireServer("Bat")

    end
})

ItemsTab:CreateButton({
    Name = "Hammer",
    Callback = function()
local A_1 = true
local A_2 = "Hammer"
local Event = game:GetService("ReplicatedStorage").RemoteEvents.BasementWeapon
Event:FireServer(A_1, A_2)

    end
})

ItemsTab:CreateButton({
    Name = "Sword",
    Callback = function()
  game.ReplicatedStorage.RemoteEvents.GiveTool:FireServer("LinkedSword")

    end
})

ItemsTab:CreateButton({
    Name = "Planks",
    Callback = function()
    game.ReplicatedStorage.RemoteEvents.GiveTool:FireServer("Plank")

    end
})

ItemsTab:CreateButton({
    Name = "Key",
    Callback = function()
  game.ReplicatedStorage.RemoteEvents.GiveTool:FireServer("Key")

    end
})

---------------------------------------------------
-- EXTRA
---------------------------------------------------

-- PARAGRAPH
ExtraTab:CreateParagraph({
    Title = "Credits:",
    Content = "Created by Ikonned"
})

-- PARAGRAPH
ExtraTab:CreateParagraph({
    Title = "Credits:",
    Content = "Tested by Rosalia and Crocs"
})

ExtraTab:CreateButton({
    Name = "WARNING [ IMPORTANT ]",
    Callback = function()

        local TweenService = game:GetService("TweenService")
        local playerGui = game:GetService("Players").LocalPlayer
            :WaitForChild("PlayerGui")

        -- Remove an existing popup before creating another.
        local existing = playerGui:FindFirstChild("MoreInfoWarningGui")
        if existing then
            existing:Destroy()
        end

        ---------------------------------------------------
        -- WARNING GUI
        ---------------------------------------------------

        local warningGui = Instance.new("ScreenGui")
        warningGui.Name = "MoreInfoWarningGui"
        warningGui.ResetOnSpawn = false
        warningGui.DisplayOrder = 1000
        warningGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        warningGui.Parent = playerGui

        local overlay = Instance.new("TextButton")
        overlay.Name = "WarningOverlay"
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.Position = UDim2.fromScale(0, 0)
        overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        overlay.BackgroundTransparency = 0.35
        overlay.BorderSizePixel = 0
        overlay.Text = ""
        overlay.AutoButtonColor = false
        overlay.ZIndex = 100
        overlay.Parent = warningGui

        local panel = Instance.new("Frame")
        panel.Name = "WarningPanel"
        panel.AnchorPoint = Vector2.new(0.5, 0.5)
        panel.Position = UDim2.fromScale(0.5, 0.5)
        panel.Size = UDim2.new(0.88, 0, 0, 320)
        panel.BackgroundColor3 = Color3.fromRGB(38, 25, 25)
        panel.BackgroundTransparency = 0.05
        panel.BorderSizePixel = 0
        panel.Active = true
        panel.ZIndex = 101
        panel.Parent = warningGui

        local sizeConstraint = Instance.new("UISizeConstraint")
        sizeConstraint.MinSize = Vector2.new(260, 300)
        sizeConstraint.MaxSize = Vector2.new(440, 340)
        sizeConstraint.Parent = panel

        local panelCorner = Instance.new("UICorner")
        panelCorner.CornerRadius = UDim.new(0, 18)
        panelCorner.Parent = panel

        local panelStroke = Instance.new("UIStroke")
        panelStroke.Color = Color3.fromRGB(255, 222, 189)
        panelStroke.Thickness = 3
        panelStroke.Parent = panel

        ---------------------------------------------------
        -- WARNING ICON
        ---------------------------------------------------

        local icon = Instance.new("TextLabel")
        icon.Name = "WarningIcon"
        icon.AnchorPoint = Vector2.new(0.5, 0)
        icon.Position = UDim2.new(0.5, 0, 0, 14)
        icon.Size = UDim2.new(0, 62, 0, 62)
        icon.BackgroundColor3 = Color3.fromRGB(171, 0, 0)
        icon.BorderSizePixel = 0
        icon.Text = "!"
        icon.TextColor3 = Color3.fromRGB(255, 222, 189)
        icon.TextSize = 48
        icon.Font = Enum.Font.GothamBlack
        icon.ZIndex = 102
        icon.Parent = panel

        local iconCorner = Instance.new("UICorner")
        iconCorner.CornerRadius = UDim.new(0, 14)
        iconCorner.Parent = icon

        ---------------------------------------------------
        -- WARNING TITLE
        ---------------------------------------------------

        local title = Instance.new("TextLabel")
        title.Name = "WarningTitle"
        title.Position = UDim2.new(0, 12, 0, 88)
        title.Size = UDim2.new(1, -24, 0, 42)
        title.BackgroundTransparency = 1
        title.Text = "WARNING"
        title.TextColor3 = Color3.fromRGB(255, 222, 189)
        title.TextSize = 29
        title.Font = Enum.Font.GothamBold
        title.ZIndex = 102
        title.Parent = panel

        ---------------------------------------------------
        -- WARNING MESSAGE
        ---------------------------------------------------

        local message = Instance.new("TextLabel")
        message.Name = "WarningMessage"
        message.Position = UDim2.new(0, 20, 0, 137)
        message.Size = UDim2.new(1, -40, 0, 100)
        message.BackgroundTransparency = 1
        message.TextWrapped = true
        message.RichText = true
        message.Text = 'Please respect the original creators and provide <font color="#FF3030">proper credit</font>. Use this script only in experiences you own or are <font color="#FF3030">authorised to test</font>.'
        message.TextColor3 = Color3.fromRGB(255, 222, 189)
        message.TextSize = 15
        message.Font = Enum.Font.Gotham
        message.TextXAlignment = Enum.TextXAlignment.Center
        message.TextYAlignment = Enum.TextYAlignment.Center
        message.ZIndex = 102
        message.Parent = panel

        ---------------------------------------------------
        -- DISMISS PROMPT
        ---------------------------------------------------

        local prompt = Instance.new("TextLabel")
        prompt.Name = "WarningPrompt"
        prompt.Position = UDim2.new(0, 10, 1, -47)
        prompt.Size = UDim2.new(1, -20, 0, 30)
        prompt.BackgroundTransparency = 1
        prompt.Text = "TAP / CLICK TO CONTINUE"
        prompt.TextColor3 = Color3.fromRGB(190, 165, 145)
        prompt.TextSize = 11
        prompt.Font = Enum.Font.GothamBold
        prompt.ZIndex = 102
        prompt.Parent = panel

        ---------------------------------------------------
        -- CLOSE WITH A FADE ANIMATION
        ---------------------------------------------------

        local dismissed = false
        local inputConnection

        local function dismissWarning()
            if dismissed then
                return
            end

            dismissed = true

            if inputConnection then
                inputConnection:Disconnect()
                inputConnection = nil
            end

            local fadeInfo = TweenInfo.new(
                0.22,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            )

            TweenService:Create(panel, fadeInfo, {
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5, 0.46),
            }):Play()

            TweenService:Create(overlay, fadeInfo, {
                BackgroundTransparency = 1,
            }):Play()

            for _, object in ipairs(panel:GetDescendants()) do
                if object:IsA("TextLabel") then
                    TweenService:Create(object, fadeInfo, {
                        TextTransparency = 1,
                        BackgroundTransparency = 1,
                    }):Play()
                end
            end

            task.delay(0.25, function()
                if warningGui.Parent then
                    warningGui:Destroy()
                end
            end)
        end

        overlay.Activated:Connect(dismissWarning)

        inputConnection = UserInputService.InputBegan:Connect(
            function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                    dismissWarning()
                end
            end
        )

    end,
})

ExtraTab:CreateButton({
    Name = "A-60 Plushy",
    Callback = function()
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Plr = Players.LocalPlayer
local Char = Plr.Character or Plr.CharacterAdded:Wait()

local shadow = game:GetObjects("rbxassetid://85674900664881")[1]
shadow.Parent = game.Players.LocalPlayer.Backpack

UIS.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.Space then
		local plushie = Char:FindFirstChild("A60")

		if plushie then
			plushie.Handle.Sound:Stop()
		end
	end
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.K then
		local plushie = Char:FindFirstChild("A60")

		if plushie then
			plushie.Handle.Sound:Play()
		end
	end
end)


    end,
})

ExtraTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet(('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source')))()
    end,
})
