-- todo list
-- optimize locals, variables, globals, newvector3 = NewVector3 type shit
-- paste stormy.cc



Fondra.Functions.ClearConnection("Input Started", Fondra.Connections)
Fondra.Functions.ClearConnection("Input Ended", Fondra.Connections)

Fondra.Functions.ClearConnection("Debris Added", Fondra.Connections)
Fondra.Functions.ClearConnection("VPart Added", Fondra.Connections)

Fondra.Functions.ClearConnection("Character Added", Fondra.Connections)
Fondra.Functions.ClearConnection("Mouse Move", Fondra.Connections)
Fondra.Functions.ClearConnection("Main", Fondra.Connections)

local IsA                                                       = game.IsA
local GetChildren                                               = game.GetChildren
local WaitForChild                                              = game.WaitForChild
local FindFirstChild                                            = game.FindFirstChild
local FindFirstChildWhichIsA                                    = game.FindFirstChildWhichIsA

local NewVector2                                                = Vector2.new
local NewVector3                                                = Vector3.new

local NextInteger                                               = Fondra.Random.NextInteger
local NextNumber                                                = Fondra.Random.NextNumber
local WorldToScreenPoint                                        = Fondra.Camera.WorldToScreenPoint
local GetPlayers                                                = Fondra.Services.Players.GetPlayers
local Raycast                                                   = Fondra.Services.Workspace.Raycast

local RParams                                                   = RaycastParams.new()
local BParams                                                   = RaycastParams.new()
local TParams                                                   = RaycastParams.new()

local Toggles                                                   = getgenv().Toggles
local Options                                                   = getgenv().Options

local GTag                                                      = getrenv()._G.gTag
local Config                                                    = require(WaitForChild(Fondra.Services.ReplicatedStorage, "NewModules").Shared.Extensions.GetConfig)

local Projectiles                                               = { Forward = 0, Backward = 0, Left = 0, Right = 0, Current = { Object = nil, BodyVelocity = nil, BodyGyro = nil } }
local Fly                                                       = { Forward = 0, Backward = 0, Left = 0, Right = 0, Current = { BodyVelocity = nil, BodyGyro = nil } }
local Vars                                                      = {
    Alive                                                       = true,
    Downed                                                      = false,

    Gun                                                         = false,
    Melee                                                       = false,
    CharStats                                                   = nil,

    HiddenBody                                                  = {
        Animation                                               = Instance.new("Animation"),
        Loaded                                                  = nil
    }
}

do
    TParams.FilterType                                          = Enum.RaycastFilterType.Exclude
    TParams.IgnoreWater                                         = true
    TParams.RespectCanCollide 								    = true
    TParams.FilterDescendantsInstances                          = { Fondra.Camera }
end do
    BParams.FilterType                                          = Enum.RaycastFilterType.Exclude
    BParams.IgnoreWater                                         = true
    BParams.RespectCanCollide                                   = true
    BParams.FilterDescendantsInstances                          = { Fondra.Services.Workspace.Characters, Fondra.Camera }
end do
    RParams.FilterType                                          = Enum.RaycastFilterType.Exclude
    RParams.IgnoreWater                                         = true
    RParams.RespectCanCollide                                   = true
end do
    Vars.HiddenBody.Animation.Parent                            = Fondra.Camera
	Vars.HiddenBody.Animation.AnimationId                       = "rbxassetid://282574440"
end do
    Fondra.Cooldowns.Fly                                        = 0
    Fondra.Cooldowns.Stats                                      = 0
    Fondra.Cooldowns.Reload                                     = 0

    Fondra.Cooldowns.FakeLag                                    = 0
    Fondra.Cooldowns.RageBot                                    = 0

    Fondra.Cooldowns.FinishAura                                 = 0
    Fondra.Cooldowns.MeleeAura                                  = 0
    Fondra.Cooldowns.SprayAura                                  = 0

    Fondra.Cooldowns.BreakDoors                                 = 0
    Fondra.Cooldowns.BreakSafes                                 = 0
    Fondra.Cooldowns.BreakRegisters                             = 0
end

-- #Region // Projectile - Fly
Fondra.Functions.NewConnection("VPart Added", Fondra.Connections, Fondra.Services.Workspace.Debris.VParts.ChildAdded, function(Object)
    task.wait()

	if (Object.Name == "RPG_Rocket" and Toggles.RLController.Value) then
        if not FindFirstChild(Fondra.Client.Character, "RPG-7") then return end

		Fondra.Camera.CameraSubject 						    = Object
		Fondra.Client.Character.HumanoidRootPart.Anchored 	    = true

		pcall(function()
			Object.BodyForce:Destroy()
			Object.RotPart.BodyAngularVelocity:Destroy()
			Object.Sound:Destroy()
		end)
		
		local BV 											    = Instance.new("BodyVelocity", Object)
    	BV.MaxForce 										    = NewVector3(1e9, 1e9, 1e9)
    	BV.Velocity 										    = NewVector3()
    	
    	local BG 											    = Instance.new("BodyGyro", Object)
        BG.D 												    = 750
    	BG.P 												    = 50000
    	BG.MaxTorque 										    = NewVector3(1e4, 1e4, 1e4)

		Projectiles.Current.BodyVelocity					    = BV
		Projectiles.Current.BodyGyro						    = BG
		Projectiles.Current.Object							    = Object
	end

	if (Object.Name == "GrenadeLauncherGrenade" and Toggles.GLController.Value) then
        if not FindFirstChild(Fondra.Client.Character, "M320-1") then return end

		Fondra.Camera.CameraSubject 						    = Object
		Fondra.Client.Character.HumanoidRootPart.Anchored 	    = true

		pcall(function()
			Object.BodyForce:Destroy()
			Object.RotPart.BodyAngularVelocity:Destroy()
			Object.Sound:Destroy()
		end)
		
		local BV 											    = Instance.new("BodyVelocity", Object)
    	BV.MaxForce 										    = NewVector3(1e9, 1e9, 1e9)
    	BV.Velocity 										    = NewVector3()
    	
    	local BG 											    = Instance.new("BodyGyro", Object)
        BG.D 												    = 750
    	BG.P 												    = 50000
    	BG.MaxTorque 										    = NewVector3(1e4, 1e4, 1e4)

		Projectiles.Current.BodyVelocity					    = BV
		Projectiles.Current.BodyGyro						    = BG
		Projectiles.Current.Object							    = Object
	end

	if (Object.Name == "TransIgnore" and Toggles.C4Controller.Value) then
        if not FindFirstChild(Fondra.Client.Character, "C4") then return end

		Fondra.Camera.CameraSubject 						    = Object
		Fondra.Client.Character.HumanoidRootPart.Anchored 	    = true

		pcall(function()
			Object.BodyForce:Destroy()
			Object.RotPart.BodyAngularVelocity:Destroy()
			Object.Sound:Destroy()
		end)
		
		local BV 											    = Instance.new("BodyVelocity", Object)
    	BV.MaxForce 										    = NewVector3(1e9, 1e9, 1e9)
    	BV.Velocity 										    = NewVector3()

    	local BG 											    = Instance.new("BodyGyro", Object)
        BG.D 												    = 750
    	BG.P 												    = 50000
    	BG.MaxTorque 										    = NewVector3(1e4, 1e4, 1e4)

		Projectiles.Current.BodyVelocity					    = BV
		Projectiles.Current.BodyGyro						    = BG
		Projectiles.Current.Object							    = Object
	end
end)

Fondra.Functions.NewConnection("Debris Added", Fondra.Connections, Fondra.Services.Workspace.Debris.ChildAdded, function(Object)
    task.wait()

	if (not FindFirstChild(Object, "Creator")) then return end
	if (Object.Creator.Value ~= Fondra.Client) then return end

	Projectiles.Current.BodyVelocity						    = nil
	Projectiles.Current.BodyGyro							    = nil
	Projectiles.Current.Object								    = nil

	Fondra.Camera.CameraSubject 							    = Fondra.Client.Character.Humanoid
	Fondra.Client.Character.HumanoidRootPart.Anchored 		    = false
end)

Fondra.Functions.NewConnection("Input Began", Fondra.Connections, Fondra.Services.UserInputService.InputBegan, function(Key)
	if Key.KeyCode == Enum.KeyCode.W then
		Projectiles.Forward 	                                = 1
		Fly.Forward 	                                        = 1
	end

	if Key.KeyCode == Enum.KeyCode.S then
		Projectiles.Backward 	                                = -1
        Fly.Backward 	                                        = -1
	end

	if Key.KeyCode == Enum.KeyCode.D then
		Projectiles.Right 		                                = 1
        Fly.Right 	                                            = 1
	end

	if Key.KeyCode == Enum.KeyCode.A then
		Projectiles.Left 		                                = -1
        Fly.Left 	                                            = -1
	end
end)

Fondra.Functions.NewConnection("Input Ended", Fondra.Connections, Fondra.Services.UserInputService.InputEnded, function(Key)
	if Key.KeyCode == Enum.KeyCode.W then
		Projectiles.Forward 	                                = 0
		Fly.Forward 	                                        = 0
	end

	if Key.KeyCode == Enum.KeyCode.S then
		Projectiles.Backward 	                                = 0
        Fly.Backward 	                                        = 0
	end

	if Key.KeyCode == Enum.KeyCode.D then
		Projectiles.Right 		                                = 0
        Fly.Right 	                                            = 0
	end

	if Key.KeyCode == Enum.KeyCode.A then
		Projectiles.Left 		                                = 0
        Fly.Left 	                                            = 0
	end
end)
-- #EndRegion

-- #Region // Checks Functions
Fondra.Functions.EquippedGun                                    = function(Tool, Table)
    local Tool                                                  = Tool

    if not Tool then return end
    if not IsA(Tool, "Tool") then return end

    if not FindFirstChild(Tool, "Client") then return end
    if not FindFirstChild(Tool, "Config") then return end
    if not FindFirstChild(Tool, "Gun") then return end

    if Table then
        return { Object = Tool, Config = require(Tool.Config) }
    end

    return true
end

Fondra.Functions.EquippedMelee                                  = function(Tool, Table)
    local Tool                                                  = Tool

    if not Tool then return end
    if not IsA(Tool, "Tool") then return end

    if not FindFirstChild(Tool, "Client") then return end
    if not FindFirstChild(Tool, "Config") then return end
    if not FindFirstChild(Tool, "Melee") then return end

    if Table then
        return { Object = Tool, Config = require(Tool.Config) }
    end

    return true
end

Fondra.Functions.ValidCheck                                     = function(Character)
    local Character                                             = Character

    if not Character then return end

    if not FindFirstChild(Character, "Humanoid") then return false end
    if not FindFirstChild(Character, "HumanoidRootPart") then return false end
    if FindFirstChild(Character, "Humanoid").Health <= 0 then return false end

    return true
end

Fondra.Functions.ForceFieldCheck                                = function(Character)
    local Character                                             = Character

    if not Character then return end

    return FindFirstChildWhichIsA(Character, "ForceField") ~= nil
end

Fondra.Functions.DownedCheck                                    = function(Character)
    if not FindFirstChild(Fondra.Services.ReplicatedStorage.CharStats, Character.Name) then return true end

    return Fondra.Services.ReplicatedStorage.CharStats[Character.Name].Downed.Value
end

Fondra.Functions.FriendlyCheck                                  = function(Player)
    return Player.IsFriendsWith(Player, Fondra.Client.UserId)
end

Fondra.Functions.VisibleCheck                                   = function(Character, Limb, Method)
	if (Method == "Wallbang") and (Character.HumanoidRootPart.Position - Fondra.Client.Character.HumanoidRootPart.Position).Magnitude < 15 then return true end
    if (Method == "None") then return true end

    if not Vars.Gun then return false end
    if not Vars.Gun.Object then return false end
    if not Vars.Gun.Config then return false end

    local FPS                                                   = Fondra.Functions.FP() and getgenv().ViewModelTool
    local Tool                                                  = FindFirstChildWhichIsA(Fondra.Client.Character, "Tool")
	local Handle 												= FindFirstChild(FPS and FPS or Tool, "WeaponHandle") or FindFirstChild(FPS and FPS or Tool, "Handle")
	local FirePosition 											= Handle and FindFirstChild(Handle, "FirePos")

    if not Tool then return false end
    if not Handle then return false end
    if not FirePosition then return false end

    local FOffset                                               = (Method == "Wallbang") and CFrame.new(0, Toggles.InvertAim.Value and -Options.ShootOffsetY.Value or Options.ShootOffsetY.Value, 0) or CFrame.new()
    local LOffset                                               = (Method == "Wallbang") and CFrame.new(0, Toggles.InvertLimb.Value and -Options.LimbOffsetY.Value or Options.LimbOffsetY.Value, 0) or CFrame.new()
    
    local FireOffset                                            = (FirePosition.WorldCFrame * FOffset).p
    local HitOffset                                             = (Limb.CFrame * LOffset).p
    
    local Result                                                = Fondra.Functions.Raycast(FireOffset, HitOffset - FireOffset, {
		Fondra.Client.Character,
		Fondra.Camera,
        Character,

		Fondra.Services.Workspace.Debris,
		Fondra.Services.Workspace.Filter,
		Fondra.Services.Workspace.Characters,
		Fondra.Services.Workspace.Map.Parts.Grinders,
		
		FindFirstChild(Fondra.Services.Workspace.Map, "VendingMachines"),
		FindFirstChild(Fondra.Services.Workspace.Map, "StreetLights"),
		FindFirstChild(Fondra.Services.Workspace.Map, "BredMakurz"),
		FindFirstChild(Fondra.Services.Workspace.Map, "Security"),
		FindFirstChild(Fondra.Services.Workspace.Map, "Doors"),
		FindFirstChild(Fondra.Services.Workspace.Map, "Shopz"),
		FindFirstChild(Fondra.Services.Workspace.Map, "ATMz")
	}, Method)

    if Result then
        return false
    else
        return true
    end
end
-- #EndRegion

-- #Region // Fondra Functions
Fondra.Functions.RandomString                                   = function(Length)
    local Result    = ""

    for i = 1, Length do
        Result = Result .. string.char(NextInteger(Fondra.Random, 97, 122))
    end

    return Result
end

Fondra.Functions.SmoothOscillation                              = function(Minimum, Maximum)
    local Time                                                  = tick()
    local Speed                                                 = 0.45
    local Range                                                 = Maximum - Minimum
    local Oscillation                                           = (math.sin((Time * math.pi / Speed) + 0) + 1) / 2

    return Minimum + Oscillation * Range
end

Fondra.Functions.Tracer                                         = function(FirePosition, HitPosition, Color)
    local Part1                                                 = Instance.new("Part", Fondra.Camera.Bullets)
    Part1.Size                                                  = NewVector3(0.25, 0.25, 0.25)
    Part1.Transparency                                          = 1
    Part1.CanCollide                                            = false
    Part1.CFrame                                                = CFrame.new(FirePosition)
    Part1.Anchored                                              = true
        
    local Part2                                                 = Instance.new("Part", Fondra.Camera.Bullets)
    Part2.Size                                                  = NewVector3(0.25, 0.25, 0.25)
    Part2.Transparency                                          = 0
    Part2.CanCollide                                            = false
    Part2.CFrame                                                = CFrame.new(HitPosition)
    Part2.Anchored                                              = true
    Part2.Color                                                 = Options.MainColor.Value
    
    local Attachment0                                           = Instance.new("Attachment", Part1)
    local Attachment1                                           = Instance.new("Attachment", Part2)
    
    local Beam                                                  = Instance.new("Beam", Part1)
    Beam.FaceCamera                                             = true
    Beam.Color                                                  = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color), ColorSequenceKeypoint.new(1, Color), })
    Beam.Attachment0                                            = Attachment0
    Beam.Attachment1                                            = Attachment1
    Beam.LightEmission                                          = 0
    Beam.LightInfluence                                         = 0
    Beam.Width0                                                 = 0.05
    Beam.Width1                                                 = 0.05

    task.delay(2.5, function()
        for i = 0.5, 1, 0.02 do
            task.wait()

            Beam.Transparency                                   = NumberSequence.new(i)
            Part2.Transparency                                  = i
        end

        Part1:Destroy()
        Part2:Destroy()
    end)
end

Fondra.Functions.ReturnInteractiveProp                          = function(Folder, Max)
    local Prop                                                  = nil
    local Distance                                              = Max or math.huge

    local Client                                                = Fondra.Client
    local Character                                             = Client.Character

    if not Client then return end
    if not Character then return end

    if not FindFirstChild(Character, "HumanoidRootPart") then return end
    if not FindFirstChild(Character, "Humanoid") then return end

    for Index, Object in next, Fondra.Services.Workspace.Map[Folder]:GetChildren() do
        if not FindFirstChild(Object, "MainPart") then continue end

        if (Object.MainPart.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end

        Prop                                                    = Object
        Distance                                                = (Object.MainPart.Position - Character.HumanoidRootPart.Position).Magnitude
    end

    return Prop
end

Fondra.Functions.ReturnCash                                     = function(Max)
    local Cash                                                  = nil
    local Distance                                              = Max or math.huge

    local Client                                                = Fondra.Client
    local Character                                             = Client.Character

    if not Client then return end
    if not Character then return end

    if not FindFirstChild(Character, "HumanoidRootPart") then return end
    if not FindFirstChild(Character, "Humanoid") then return end

    for Index, Object in next, Fondra.Services.Workspace.Filter.SpawnedBread:GetChildren() do
        if (Object.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end

        Cash                                                    = Object
        Distance                                                = (Object.Position - Character.HumanoidRootPart.Position).Magnitude
    end

    return Cash
end

Fondra.Functions.ReturnScrap                                    = function(Max)
    local Scrap                                                 = nil
    local Distance                                              = Max or math.huge

    local Client                                                = Fondra.Client
    local Character                                             = Client.Character

    if not Client then return end
    if not Character then return end

    if not FindFirstChild(Character, "HumanoidRootPart") then return end
    if not FindFirstChild(Character, "Humanoid") then return end

    for Index, Object in next, Fondra.Services.Workspace.Filter.SpawnedPiles:GetChildren() do
        if not string.find(Object.Name, "S") then continue end
        if not Object.PrimaryPart then continue end
        if (Object.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end

        Scrap                                                   = Object
        Distance                                                = (Object.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude
    end

    return Scrap
end

Fondra.Functions.ReturnCrate                                    = function(Max)    
    local Crate                                                 = nil
    local Distance                                              = Max or math.huge

    local Client                                                = Fondra.Client
    local Character                                             = Client.Character

    if not Client then return end
    if not Character then return end

    if not FindFirstChild(Character, "HumanoidRootPart") then return end
    if not FindFirstChild(Character, "Humanoid") then return end

    for Index, Object in next, Fondra.Services.Workspace.Filter.SpawnedPiles:GetChildren() do
        if not string.find(Object.Name, "C") then continue end
        if not Object.PrimaryPart then continue end
        if (Object.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end

        Crate                                                   = Object
        Distance                                                = (Object.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude
    end

    return Crate
end

Fondra.Functions.ReturnTool                                     = function(Max)
    local Tool                                                  = nil
    local Distance                                              = Max or math.huge

    local Client                                                = Fondra.Client
    local Character                                             = Client.Character

    if not Client then return end
    if not Character then return end

    if not FindFirstChild(Character, "HumanoidRootPart") then return end
    if not FindFirstChild(Character, "Humanoid") then return end

    for Index, Object in next, Fondra.Services.Workspace.Filter.SpawnedTools:GetChildren() do
        if not Object.PrimaryPart then continue end
        if (Object.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end

        Tool                                                    = Object
        Distance                                                = (Object.PrimaryPart.Position - Character.HumanoidRootPart.Position).Magnitude
    end

    return Tool
end

Fondra.Functions.ReturnBreadMaker                               = function(Type, Max)
    local BreakMaker                                            = nil
    local Distance                                              = Max or math.huge

    local Client                                                = Fondra.Client
    local Character                                             = Client.Character

    if not Client then return end
    if not Character then return end

    if not FindFirstChild(Character, "HumanoidRootPart") then return end
    if not FindFirstChild(Character, "Humanoid") then return end

    for Index, Object in next, Fondra.Services.Workspace.Map.BredMakurz:GetChildren() do
        if not FindFirstChild(Object, "MainPart") then continue end
        if not FindFirstChild(Object, "Values") then continue end

        if not string.find(Object.Name, Type) then continue end
        if Object.Values.Broken.Value then continue end

        if (Object.MainPart.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end
        
        BreakMaker                                              = Object
        Distance                                                = (Object.MainPart.Position - Character.HumanoidRootPart.Position).Magnitude
    end

    return BreakMaker
end

Fondra.Functions.ReturnDoor                                     = function(Max)
    local Door                                                  = nil
    local Distance                                              = Max or math.huge

    local Client                                                = Fondra.Client
    local Character                                             = Client.Character

    if not Client then return end
    if not Character then return end

    if not FindFirstChild(Character, "HumanoidRootPart") then return end
    if not FindFirstChild(Character, "Humanoid") then return end

    for Index, Object in next, Fondra.Services.Workspace.Map.Doors:GetChildren() do
        if not FindFirstChild(Object, "DFrame") then continue end
        if not FindFirstChild(Object, "Values") then continue end
        if not FindFirstChild(Object.Values, "Locked") then continue end
        if not FindFirstChild(Object.Values, "Broken") then continue end

        if Object.Values.Broken.Value then continue end
        if not Object.Values.Locked.Value then continue end

        if (Object.DFrame.Position - Character.HumanoidRootPart.Position).Magnitude > Distance then continue end
        
        Door                                                    = Object
        Distance                                                = (Object.DFrame.Position - Character.HumanoidRootPart.Position).Magnitude
    end

    return Door
end

Fondra.Functions.LocalCharacter                                 = function(Character)
    local HumanoidRootPart                                      = WaitForChild(Character, "HumanoidRootPart")
    local Humanoid                                              = WaitForChild(Character, "Humanoid")
    local Torso                                                 = WaitForChild(Character, "Torso")
    local Head                                                  = WaitForChild(Character, "Head")
    local Part                                                  = WaitForChild(Torso, "Part")

    task.wait(0.5)

    for _, Connection in pairs(getconnections(HumanoidRootPart.ChildAdded)) do
        Connection:Disable()
    end

    for _, Connection in pairs(getconnections(HumanoidRootPart.DescendantAdded)) do
        Connection:Disable()
    end

    for _, Object in next, GetChildren(Torso) do
        if not IsA(Object, "Motor6D") then continue end

        Object:GetPropertyChangedSignal("Enabled"):Connect(function(Value)
            if not Toggles.Fly.Value and not Toggles.WalkSpeed.Value and not Toggles.JumpPower.Value then return end
            if Value then return end

            Object.Enabled                                      = true
        end)
    end

    Head.ChildAdded:Connect(function(Object)
        task.wait()

        if not Toggles.Fly.Value and not Toggles.WalkSpeed.Value and not Toggles.JumpPower.Value then return end
        if not string.find(Object.Name, "Scream") then return end

        Object:Destroy()
    end)

    Vars.HiddenBody.Loaded                                      = Humanoid:LoadAnimation(Vars.HiddenBody.Animation)
    Vars.Alive                                                  = true
    Vars.Downed                                                 = false

    Vars.Gun                                                    = { Object = nil, Config = nil }
    Vars.Melee                                                  = { Object = nil, Config = nil }
    Vars.CharStats                                              = WaitForChild(Fondra.Services.ReplicatedStorage.CharStats, Character.Name)

    Character.ChildAdded:Connect(function(Tool)
        if not IsA(Tool, "Tool") then return end

        Vars.Gun                                                = Fondra.Functions.EquippedGun(Tool, true)
        Vars.Melee                                              = Fondra.Functions.EquippedMelee(Tool, true)
    end)

    Character.ChildRemoved:Connect(function(Tool)
        if not IsA(Tool, "Tool") then return end

        Vars.Gun                                                = { Object = nil, Config = nil }
        Vars.Melee                                              = { Object = nil, Config = nil }
    end)

    Humanoid.HealthChanged:Connect(function()
        Vars.Alive                                              = Fondra.Functions.ValidCheck(Character)
        Vars.Downed                                             = Fondra.Functions.DownedCheck(Character)
    end)

    Part.CanCollide                                             = false
    Fondra.Functions.SpinBot(Fondra.Client, Character)
    Fondra.Functions.HiddenBody(Fondra.Client, Character)
end

Fondra.Functions.Shoot                                          = function(Target)
    if not isrbxactive() then return end

    if not Vars.Gun then return end
    if not Vars.Gun.Object then return end
    if not Vars.Gun.Config then return end

    if not Toggles.TriggerBot.Value then return end
    if Options.TriggerBotShootChance.Value <= NextInteger(Fondra.Random, 1, 100) then return end

    local Character                                             = Target
	local Target												= Fondra.Services.Players:GetPlayerFromCharacter(Target)
	local Tool 													= FindFirstChildWhichIsA(Fondra.Client.Character, "Tool")

	if Fondra.Functions.ForceFieldCheck(Character) then return end
	if Fondra.Functions.DownedCheck(Character) and Toggles.TriggerBotDowned.Value then return end
	if Fondra.Functions.FriendlyCheck(Target) and Toggles.TriggerBotFriendly.Value then return end

	Tool:Activate()

	task.delay(0, function()
    	if not FindFirstChildWhichIsA(Fondra.Client.Character, "Tool") then return end

        Tool:Deactivate()
    end)
end

Fondra.Functions.GunAnimation                                   = function(Tool, Name)
    -- // Remake
end

Fondra.Functions.GunSound                                       = function(Tool, Directory, Name)
    if not FindFirstChild(Tool, "WeaponHandle") then return end
    if not FindFirstChild(Tool.WeaponHandle, Directory) then return end
    if not FindFirstChild(Tool.WeaponHandle[Directory], Name) then return end

    local Clone                                                 = Tool.WeaponHandle[Directory][Name]:Clone()
    Clone.Name                                                  = string.format("%s_Clone", Name)
    Clone.Parent                                                = Fondra.Client.Character.HumanoidRootPart
    Clone.PlaybackSpeed                                         = NextNumber(Fondra.Random, 0.8, 1.2)
    Clone:Play()

    Fondra.Services.Debris:AddItem(Clone, Clone.TimeLength)
end

Fondra.Functions.Raycast										= function(Origin, Direction, Blacklist, Method)
	RParams.FilterDescendantsInstances                     	 	= Blacklist

    if Fondra.Loader.Mode == "Developers" then Fondra.Functions.Tracer(Origin, Origin + Direction, Color3.fromRGB(255, 0, 0)) end

	local Result 												= Raycast(Fondra.Services.Workspace, Origin, Direction, RParams)
    local Resulted                                              = Result and Result.Instance
    local Name                                                  = Resulted and Resulted.Name

	if Result and Resulted ~= nil then
        if Method ~= "Wallbang" then return true end

		table.insert(Blacklist, Resulted)

		if FindFirstChild(Resulted, "FilterV") then
			return Fondra.Functions.Raycast(Origin, Direction, Blacklist, Method)
		end

        if Resulted:GetAttribute("RayHandlerIG") then
			return Fondra.Functions.Raycast(Origin, Direction, Blacklist, Method)
		end

        if Name == ("Street" or "DoorBase") then
			return Fondra.Functions.Raycast(Origin, Direction, Blacklist, Method)
		end

		if Resulted:IsDescendantOf(Fondra.Services.Workspace.Map.Parts) and Resulted.Transparency >= 1 and not Resulted.CanCollide then
			return Fondra.Functions.Raycast(Origin, Direction, Blacklist, Method)
		end

        if
            Resulted.Transparency >= 1 
            and not Resulted.CanCollide 
            and Name ~= "MainPart" 
            and Name ~= "DoorBase" 
        then
            Result.Parent                                       = Fondra.Services.Workspace.Filter.Parts

            return Fondra.Functions.Raycast(Origin, Direction, Blacklist, Method)
        end
 
		if
            GTag(Resulted, "MainIgnorePart") or 
            GTag(Resulted, "MainIgnorePart_1") or 
            GTag(Resulted, "MainIgnorePart_2") or 
            GTag(Resulted, "MainIgnorePart_3") 
        then
			return Fondra.Functions.Raycast(Origin, Direction, Blacklist)
		end

		return true
	else
		return false
	end
end

Fondra.Functions.Return                                         = function(Methods, Checks, Lengths, Limbs)
    local Methods                                               = Methods or { Get = "Character", Part = "Random", Visible = "Default" }
    local Checks                                                = Checks or { Downed = true, Friendly = true }
	local Limbs 												= Limbs or {}

    local Target, Distance, Limb								= nil, nil, nil

    if (Methods.Get == "Mouse") then
        for Index, Player in next, GetPlayers(Fondra.Services.Players) do
			if Player == Fondra.Client then continue end

            if not Fondra.Functions.ValidCheck(Player.Character) then continue end
            if Fondra.Functions.ForceFieldCheck(Player.Character) then continue end
            if Checks.Downed and Fondra.Functions.DownedCheck(Player.Character) then continue end
            if Checks.Friendly and Fondra.Functions.FriendlyCheck(Player) then continue end

			local Data 										    = {}
            local Total                                         = #Limbs <= 0 and { Player.Character["Torso"] } or {}
            local Selected                                      = nil

            local Vector, OnScreen                              = WorldToScreenPoint(Fondra.Camera, Player.Character.HumanoidRootPart.Position)
            local MouseBetween                                  = (NewVector2(Fondra.Mouse.X, Fondra.Mouse.Y) - NewVector2(Vector.X, Vector.Y)).Magnitude
            local CharacterBetween                              = (Player.Character.HumanoidRootPart.Position - Fondra.Client.Character.HumanoidRootPart.Position).Magnitude

			if not OnScreen then continue end

            for Index, Object in next, Limbs do
                if not FindFirstChild(Player.Character, Object) then continue end
        
				local Limb 									    = FindFirstChild(Player.Character, Object)
				local Vector, OnScreen                          = WorldToScreenPoint(Fondra.Camera, Limb.Position)
				local Difference	                            = (NewVector2(Fondra.Mouse.X, Fondra.Mouse.Y) - NewVector2(Vector.X, Vector.Y)).Magnitude

                table.insert(Total, Limb)

				if not OnScreen then continue end

				Data[Player.Character[Object]]				    = Difference
            end

            if not Selected then Selected = Player.Character["Torso"] end
            if not Distance then Distance = Lengths.Mouse end

            if (MouseBetween <= Distance) and (CharacterBetween <= Lengths.Character) then
				for Limb, Difference in next, Data do
					if not Limb then continue end
					if not Difference then continue end
					if Difference >= Distance then continue end

					Distance								    = Difference
					Selected								    = Limb
				end

                if Checks.Visible and not Fondra.Functions.VisibleCheck(Player.Character, Selected, Methods.Visible) then continue end

                Target                                          = Player.Character
                Distance                                        = MouseBetween
                Limb                                            = Selected
            end
        end
    end

    if (Methods.Get == "Character") then
        for Index, Player in next, GetPlayers(Fondra.Services.Players) do
			if Player == Fondra.Client then continue end                          

            if not Fondra.Functions.ValidCheck(Player.Character) then continue end
            if Fondra.Functions.ForceFieldCheck(Player.Character) then continue end
            if Checks.Downed and Fondra.Functions.DownedCheck(Player.Character) then continue end
            if Checks.Friendly and Fondra.Functions.FriendlyCheck(Player) then continue end

            local Total                                         = #Limbs <= 0 and { Player.Character["Torso"] } or {}
            local Selected                                      = nil
            local CharacterBetween                              = (Player.Character.HumanoidRootPart.Position - Fondra.Client.Character.HumanoidRootPart.Position).Magnitude

            for Index, Object in next, Limbs do
                if not FindFirstChild(Player.Character, Object) then continue end
        
                table.insert(Total, Player.Character[Object])
            end

            if not Selected then Selected = Total[NextInteger(Fondra.Random, 1, #Total)] end
            if not Distance then Distance = Lengths.Character end

            if (CharacterBetween <= Distance) then
                if Checks.Visible and not Fondra.Functions.VisibleCheck(Player.Character, Selected, Methods.Visible) then continue end

                Target                                          = Player.Character
                Distance                                        = CharacterBetween
                Limb                                            = Selected
            end
        end
    end

    if not Target then return end
    if not Distance then return end
    if not Limb then return end

    return Target, Distance, Limb
end
-- #EndRegion

-- #Region // Main Functions
Fondra.Functions.ProjectileController                           = function(Client, Character)
    if not Client then return end
    if not Character then return end

    if not Projectiles.Current.BodyVelocity then return end
	if not Projectiles.Current.BodyGyro then return end
	if not Projectiles.Current.Object then return end

    if not isnetworkowner(Projectiles.Current.Object) then
        Projectiles.Current.BodyVelocity:Destroy()
        Projectiles.Current.BodyGyro:Destroy()
        Projectiles.Current.Object:Destroy()       
        
        Projectiles.Current.BodyVelocity                        = nil
        Projectiles.Current.BodyGyro                            = nil
        Projectiles.Current.Object                              = nil

        return
    end

	Projectiles.Current.BodyGyro.CFrame 					    = Fondra.Camera.CFrame
    Projectiles.Current.BodyVelocity.Velocity				    = ((Fondra.Camera.CFrame.LookVector * Projectiles.Forward) + (Fondra.Camera.CFrame.LookVector * Projectiles.Backward) + (Fondra.Camera.CFrame.RightVector * Projectiles.Right) + (Fondra.Camera.CFrame.RightVector * Projectiles.Left)) * Options.ProjectileSpeed.Value
	Fondra.Camera.CFrame 									    = Projectiles.Current.Object.CFrame * CFrame.new(NewVector3(0, 2, 3))
end

Fondra.Functions.FlyController                                  = function(Client, Character)
    if not Client then return end
    if not Character then return end

    if not FindFirstChild(Character, "HumanoidRootPart") then return end
    if not FindFirstChild(Character, "Humanoid") then return end

    if not Toggles.Fly.Value then return end
    if not Fly.Current then return end
    if not Fly.Current.BodyGyro then return end
    if not Fly.Current.BodyVelocity then return end
    
    Character.Humanoid.AutoRotate                               = false
	Fly.Current.BodyGyro.CFrame 					            = Fondra.Camera.CFrame
    Fly.Current.BodyVelocity.Velocity				            = ((Fondra.Camera.CFrame.LookVector * Fly.Forward) + (Fondra.Camera.CFrame.LookVector * Fly.Backward) + (Fondra.Camera.CFrame.RightVector * Fly.Right) + (Fondra.Camera.CFrame.RightVector * Fly.Left)) * Options.FlySpeed.Value
    
    if ((tick() - Fondra.Cooldowns.Fly) > 1) and (Options.FlyMethod.Value == "Bypass") then
        Fondra.Cooldowns.Fly                                    = tick()
        Fondra.Services.ReplicatedStorage.Events.__DFfDD:FireServer(
            "-r__r2", 
            NewVector3(0, 0, 0), 
            Character.HumanoidRootPart.CFrame
        )
    end
end

Fondra.Functions.Stats                                          = function(Client, Character)
    if not Client then return end
    if not Character then return end
    if not Toggles.WalkSpeed.Value and not Toggles.JumpPower.Value then return end

    local Stats                                                 = FindFirstChild(Fondra.Services.ReplicatedStorage.CharStats, Client.Name)
    local Humanoid                                              = FindFirstChild(Character, "Humanoid")
    local HumanoidRootPart                                      = FindFirstChild(Character, "HumanoidRootPart")
    
    if not Stats then return end
    if not Humanoid then return end
    if not HumanoidRootPart then return end

    Stats.RagdollTime.Value                                     = 0
    Stats.RagdollTime.RagdollSwitch2.Value                      = false
    Stats.RagdollTime.RagdollSwitch.Value                       = false
    Stats.RagdollTime.SRagdolled.Value                          = false

    if ((tick() - Fondra.Cooldowns.Stats) > 1) and (Options.StatsMethod.Value == "Bypass") then
        Fondra.Cooldowns.Stats                                  = tick()
        Fondra.Services.ReplicatedStorage.Events.__DFfDD:FireServer(
            "-r__r2", 
            NewVector3(0, 0, 0), 
            Character.HumanoidRootPart.CFrame
        )
    end
end

Fondra.Functions.BHop                                           = function(Client, Character)
    if not Client then return end
    if not Character then return end
    if not Toggles.BHop.Value then return end
    if not FindFirstChild(Character, "HumanoidRootPart") then return end

    local Result                                                = Raycast(Fondra.Services.Workspace, Character.HumanoidRootPart.Position, NewVector3(0, -3.25, 0), BParams)

    if not Result then return end
    if not Result.Instance then return end

    Character.HumanoidRootPart.Velocity                         = NewVector3(Character.HumanoidRootPart.Velocity.X, 32.5, Character.HumanoidRootPart.Velocity.Z)
end

Fondra.Functions.Fly                                            = function(Client, Character)
    if not Client then return end
    if not Character then return end
    
    if not FindFirstChild(Character, "Humanoid") then return end
    if not FindFirstChild(Character, "HumanoidRootPart") then return end

    if Toggles.Fly.Value then
        if Fly.Current.BodyGyro then return end
        if Fly.Current.BodyVelocity then return end

        Fly.Current.BodyVelocity                                = Instance.new("BodyVelocity", Character.HumanoidRootPart)
        Fly.Current.BodyGyro                                    = Instance.new("BodyGyro", Character.HumanoidRootPart)

        Fly.Current.BodyGyro.MaxTorque                          = NewVector3(math.huge, math.huge, math.huge)
        Fly.Current.BodyGyro.D                                  = 500
        Fly.Current.BodyGyro.P                                  = 90000

        Fly.Current.BodyVelocity.P                              = 1250
        Fly.Current.BodyVelocity.MaxForce                       = NewVector3(math.huge, math.huge, math.huge)
        Fly.Current.BodyVelocity.Velocity                       = NewVector3(0, 0, 0)

        Fly.Current.BodyGyro.Name                               = Fondra.Functions.RandomString(30)
        Fly.Current.BodyVelocity.Name                           = Fondra.Functions.RandomString(30)
    end
    
    if not Toggles.Fly.Value then
        if not Fly.Current.BodyGyro then return end
        if not Fly.Current.BodyVelocity then return end

        Fly.Current.BodyGyro:Destroy()
        Fly.Current.BodyVelocity:Destroy()

        Fly.Current.BodyGyro                                    = nil
        Fly.Current.BodyVelocity                                = nil

        Character.Humanoid.AutoRotate                           = true
    end
end

Fondra.Functions.SpinBot                                        = function(Client, Character)
    if not Client then return end
    if not Character then return end
    if not FindFirstChild(Character, "HumanoidRootPart") then return end

    if Toggles.SBot.Value then
        if FindFirstChild(Character.HumanoidRootPart, "SpinBot") then 
            Character.HumanoidRootPart.SpinBot.AngularVelocity  = NewVector3(0, Options.SpinSpeed.Value ,0)

            return 
        end

        local Angular                                           = Instance.new("BodyAngularVelocity")
        Angular.Name                                            = "SpinBot"
        Angular.Parent                                          = Character.HumanoidRootPart
        Angular.MaxTorque                                       = NewVector3(0, math.huge, 0)
        Angular.AngularVelocity                                 = NewVector3(0, Options.SpinSpeed.Value ,0)
    end
    
    if not Toggles.SBot.Value then
        if not FindFirstChild(Character.HumanoidRootPart, "SpinBot") then return end

        Character.HumanoidRootPart.SpinBot:Destroy()
    end
end

Fondra.Functions.HiddenBody                                     = function(Client, Character)
    if not Client then return end
    if not Character then return end
    if not FindFirstChild(Character, "Humanoid") then return end
    if not FindFirstChild(Character, "HumanoidRootPart") then return end

    if Toggles.HiddenBody.Value then
        if not Vars.HiddenBody.Loaded then return end

        Character.HumanoidRootPart.CFrame                       = Character.HumanoidRootPart.CFrame * CFrame.new(0, -1.5, 0)
        Character.Humanoid.HipHeight                            = -1.975

        Vars.HiddenBody.Loaded:Play(0.01, 1, 0.01)
    end
    
    if not Toggles.HiddenBody.Value then
        if not Vars.HiddenBody.Loaded then return end

        Vars.HiddenBody.Loaded:Stop()
    end
end

Fondra.Functions.FakeLag                                        = function(Client, Character)
    if not Client then return end
    if not Character then return end
    if not Toggles.FLag.Value then return end

    if (tick() - Fondra.Cooldowns.FakeLag) > Options.LagAmount.Value then
        Character.Archivable                                    = true
        Fondra.Cooldowns.FakeLag                                = tick()

        if Toggles.FLagVisual.Value then
            getgenv().FLagVisual:SetPrimaryPartCFrame(Fondra.Client.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0.01, 0))
        end

        Fondra.Services.NetworkClient:SetOutgoingKBPSLimit(9e9)

        return
    end

    Fondra.Services.NetworkClient:SetOutgoingKBPSLimit(1)
end

Fondra.Functions.TriggerBot                                     = function(Client, Character)
    if not Client then return end
    if not Character then return end
    if not Toggles.TriggerBot.Value then return end

	local Delay 												= (Options.TriggerBotDelay.Value / 1000)
	local Randomized 											= (NextNumber(Fondra.Random, 0, Options.TriggerBotDelayBS.Value) / 1000)

	local Point 												= Fondra.Camera:ScreenPointToRay(Fondra.Mouse.X, Fondra.Mouse.Y)
    local Result 												= Raycast(Fondra.Services.Workspace, Point.Origin, Point.Direction * 500, TParams)
	
	if not Result then return end
	if not Result.Instance then return end
	if not Result.Instance.Parent then return end
	if not Result.Instance.Parent.Parent then return end

	local Target 												= Result.Instance
	local Player 												= Fondra.Services.Players:GetPlayerFromCharacter(Target.Parent)

    if Target.Name == "Handle" then
		TParams:AddToFilter(Target)

        return
    end

    if Target.Parent.Parent ~= Fondra.Services.Workspace.Characters then return end
    if not table.find(Options.TriggerBotParts:GetActiveValues(), Target.Name) then return end
	if not Fondra.Functions.VisibleCheck(Target.Parent, Target, "Default") then return end
	if (Player.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude >= Options.TriggerBotDistance.Value then return end

    task.delay(Delay + Randomized, function()
		Fondra.Functions.Shoot(Target.Parent)
	end)
end

Fondra.Functions.AutoPickScraps                                 = function(Client, Character)
    if not Toggles.AutoPickScraps.Value then return end
    if Fondra.Cooldowns.PickUp then return end

    if not Client then return end
    if not Character then return end

    local Scrap                                                 = Fondra.Functions.ReturnScrap(Options.AutoPickRange.Value)

    if not Scrap then return end

    Fondra.Cooldowns.PickUp                                     = true

    task.delay(0.25 + Options.AutoPickDelay.Value, function()
        if not Scrap then Fondra.Cooldowns.PickUp = false return end

        Fondra.Services.ReplicatedStorage.Events.PIC_PU:FireServer(string.reverse(Scrap:GetAttribute("jzu")))

        Fondra.Cooldowns.PickUp                                 = false
    end)
end

Fondra.Functions.AutoPickCrates                                 = function(Client, Character)
    if not Toggles.AutoPickCrates.Value then return end
    if Fondra.Cooldowns.PickUp then return end

    if not Client then return end
    if not Character then return end

    local Crate                                                 = Fondra.Functions.ReturnCrate(Options.AutoPickRange.Value)

    if not Crate then return end

    Fondra.Cooldowns.PickUp                                     = true

    task.delay(0.25 + Options.AutoPickDelay.Value, function()
        if not Crate then Fondra.Cooldowns.PickUp = false return end

        Fondra.Services.ReplicatedStorage.Events.PIC_PU:FireServer(string.reverse(Crate:GetAttribute("jzu")))

        Fondra.Cooldowns.PickUp                                 = false
    end)
end

Fondra.Functions.AutoPickTools                                  = function(Client, Character)
    if not Toggles.AutoPickTools.Value then return end
    if Fondra.Cooldowns.PickUp then return end

    if not Client then return end
    if not Character then return end

    local Tool                                                  = Fondra.Functions.ReturnTool(Options.AutoPickRange.Value)

    if not Tool then return end

    Fondra.Cooldowns.PickUp                                     = true

    task.delay(0.25 + Options.AutoPickDelay.Value, function()
        if not Tool then Fondra.Cooldowns.PickUp = false return end

        Fondra.Services.ReplicatedStorage.Events.PIC_TLO:FireServer(Tool.PrimaryPart)
        
        Fondra.Cooldowns.PickUp                                 = false
    end)
end 

Fondra.Functions.AutoPickCash                                   = function(Client, Character)
    if not Toggles.AutoPickCash.Value then return end
    if Fondra.Cooldowns.PickUp then return end

    if not Client then return end
    if not Character then return end

    local Cash                                                  = Fondra.Functions.ReturnCash(Options.AutoPickRange.Value)

    if not Cash then return end

    Fondra.Cooldowns.PickUp                                     = true

    task.delay(0.25 + Options.AutoPickDelay.Value, function()
        if not Cash then Fondra.Cooldowns.PickUp = false return end

        Fondra.Services.ReplicatedStorage.Events.CZDPZUS:FireServer(Cash) 
        Fondra.Cooldowns.PickUp                                 = false
    end)
end 

Fondra.Functions.AutoBreakDoors                                 = function(Client, Character)
    if not Toggles.BreakDoors.Value then return end
    if tick() - Fondra.Cooldowns.BreakDoors <= 0.65 then return end

    if not Client then return end
    if not Character then return end

    local Door                                                  = Fondra.Functions.ReturnDoor(10)
    local Tool                                                  = FindFirstChildWhichIsA(Client.Character, "Tool")
    local Seed                                                  = nil

    if not Door then return end
    if not Tool then return end

    Fondra.Cooldowns.BreakDoors                                 = tick()

    if (Options.DoorMethod.Value == "Lockpick" or Options.DoorMethod.Value == "Both") and Tool.Name == "Lockpick" then
        do
            Seed = Tool.Remote:InvokeServer("S", Door, "d")
            Tool.Remote:InvokeServer("D", Door, "d", Seed)
            Tool.Remote:InvokeServer("C")
        end

        task.delay(0.5, function()
            Door.Events.Toggle:FireServer("Open", Door.Knob1)
        end)
    end

    if (Options.DoorMethod.Value == "Lockpick" or Options.DoorMethod.Value == "Both") and Tool.Name ~= "Lockpick" and FindFirstChild(Character, "Right Leg") and Tool then
        do
            Seed = Fondra.Services.ReplicatedStorage.Events["XMHH.2"]:InvokeServer(
                "\240\159\141\158", 
                tick(), 
                Tool, 
                "DZDRRRKI",
                Door, 
                "Door"
            )
        end
        
        task.delay(0.5, function()
            Fondra.Services.ReplicatedStorage.Events["XMHH2.2"]:FireServer(
                "\240\159\141\158", 
                tick(), 
                Tool, 
                "2389ZFX34", 
                Seed, 
                false, 
                Character["Right Leg"], 
                Door.DoorBase, 
                Door, 
                Door.DoorBase.Position, 
                Door.DoorBase.Position
            )
        end)
    end
end

Fondra.Functions.AutoBreakSafes                                 = function(Client, Character)
    if not Toggles.BreakSafes.Value then return end
    if tick() - Fondra.Cooldowns.BreakSafes <= 0.65 then return end

    if not Client then return end
    if not Character then return end

    local Safe                                                  = Fondra.Functions.ReturnBreadMaker("Safe", 15)
    local Tool                                                  = FindFirstChildWhichIsA(Client.Character, "Tool")
    local Seed                                                  = nil

    if not Safe then return end
    if not Tool then return end

    Fondra.Cooldowns.BreakSafes                                 = tick()

    if (Options.SafeMethod.Value == "Lockpick" or Options.SafeMethod.Value == "Both") and Tool.Name == "Lockpick" then
        Seed = Tool.Remote:InvokeServer("S", Safe, "s")
        Tool.Remote:InvokeServer("D", Safe, "s", Seed)
        Tool.Remote:InvokeServer("C")
    end

    if (Options.SafeMethod.Value == "Melee" or Options.SafeMethod.Value == "Both") and Tool.Name == "Crowbar" then
        do
            Seed = Fondra.Services.ReplicatedStorage.Events["XMHH.2"]:InvokeServer(
                "\240\159\141\158", 
                tick(), 
                Tool, 
                "DZDRRRKI",
                Safe, 
                "Register"
            )
        end
        
        task.delay(0.5, function()
            Fondra.Services.ReplicatedStorage.Events["XMHH2.2"]:FireServer(
                "\240\159\141\158", 
                tick(), 
                Tool, 
                "2389ZFX34", 
                Seed, 
                false, 
                Tool.Handle, 
                Safe.MainPart, 
                Safe, 
                Safe.MainPart.Position, 
                Safe.MainPart.Position
            )
        end)
    end
end

Fondra.Functions.AutoBreakRegisters                             = function(Client, Character)
    if not Toggles.BreakRegisters.Value then return end
    if tick() - Fondra.Cooldowns.BreakRegisters <= 0.65 then return end

    if not Client then return end
    if not Character then return end

    local Register                                              = Fondra.Functions.ReturnBreadMaker("Register", 15)
    local Tool                                                  = FindFirstChildWhichIsA(Client.Character, "Tool")
    local Seed                                                  = nil

    if not Register then return end
    if not Tool then return end

    Fondra.Cooldowns.BreakRegisters                             = tick()

    if FindFirstChild(Character, "Right Arm") then
        Seed = Fondra.Services.ReplicatedStorage.Events["XMHH.2"]:InvokeServer(
            "\240\159\141\158", 
            tick(), 
            Tool, 
            "DZDRRRKI",
            Register, 
            "Register"
        )
        
        task.delay(0.5, function()
            Fondra.Services.ReplicatedStorage.Events["XMHH2.2"]:FireServer(
                "\240\159\141\158", 
                tick(), 
                Tool, 
                "2389ZFX34", 
                Seed, 
                false, 
                Character["Right Arm"], 
                Register.MainPart, 
                Register, 
                Register.MainPart.Position, 
                Register.MainPart.Position
            )
        end)
    end
end

Fondra.Functions.AutoPickUp                                     = function(Client, Character)
    Fondra.Functions.AutoPickScraps(Client, Character)
    Fondra.Functions.AutoPickCrates(Client, Character)
    Fondra.Functions.AutoPickTools(Client, Character)
    Fondra.Functions.AutoPickCash(Client, Character)
end

Fondra.Functions.AutoBreak                                      = function(Client, Character)
    Fondra.Functions.AutoBreakDoors(Client, Character)
    Fondra.Functions.AutoBreakSafes(Client, Character)
    Fondra.Functions.AutoBreakRegisters(Client, Character)
end

Fondra.Functions.Reload                                         = function(Client, Character)
    if not Client then return end
    if not Character then return end

    if tick() - Fondra.Cooldowns.Reload < 0.25 then return end
    if not Toggles.InstantReload.Value then return end

    if not Vars.Gun then return end
    if not Vars.Gun.Object then return end
    if not Vars.Gun.Config then return end

    Fondra.Cooldowns.Reload                                     = tick()

    local Tool                                                  = Vars.Gun.Object
    local Config                                                = Vars.Gun.Config
    local Values                                                = Tool.Values

    if (Values.Ammo.Value < (Config.MagSize - 1)) or (Values.StoredAmmo.Value ~= Config.StoredAmmo) then
        Fondra.Services.ReplicatedStorage.Events.GNX_R:FireServer(tick(), "KLWE89U0", Tool)
        Fondra.Services.ReplicatedStorage.Events.GNX_R:FireServer(tick(), "KLWE89U0", Tool)
    end
end

Fondra.Functions.SprayAura                                      = function(Client, Character)
    if not Client then return end
    if not Character then return end
	
    if Vars.Downed then return end
    if not Toggles.SprayAura.Value then return end
    if tick() - Fondra.Cooldowns.SprayAura < 0.05 then return end

    local Target, Distance, Limb                                = Fondra.Functions.Return({ Get = "Character", Part = "Random", Visible = "None" }, { Downed = Toggles.SprayAuraDowned.Value, Friendly = Toggles.SprayAuraFriendly.Value, Visible = false }, { Character = Options.SprayAuraDistance.Value }, { "Torso" })
    local Tool                                                  = FindFirstChildWhichIsA(Character, "Tool")

    if not Target then return end
    if not Distance then return end
    if not Limb then return end

    if not Tool then return end
    if Tool.Name ~= "Pepper-spray" then return end

    local Origin                                                = Character.HumanoidRootPart.Position
    local End                                                   = Limb.Position
    local Result                                                = NewVector3(End.X, Origin.Y, End.Z)

    Fondra.Cooldowns.SprayAura                                  = tick()
    Character.HumanoidRootPart.CFrame                           = CFrame.lookAt(Origin, Result)
    
    Tool.RemoteEvent:FireServer("Spray", true)
    Tool.RemoteEvent:FireServer("Hit", Target)
    Tool.RemoteEvent:FireServer("Spray", false)
end

Fondra.Functions.MeleeAura                                      = function(Client, Character)
    if not Client then return end
    if not Character then return end

    if Vars.Downed then return end
    if not Vars.Melee then return end
    if not Vars.Melee.Object then return end
    if not Vars.Melee.Config then return end

    if not Toggles.MeleeAura.Value then return end
    if tick() - Fondra.Cooldowns.MeleeAura < Vars.Melee.Config.Mains["S1"].DebounceTime / 3 then return end

    local Target, Distance, Limb                                = Fondra.Functions.Return({ Get = "Character", Part = "Random", Visible = "None" }, { Downed = Toggles.MeleeAuraDowned.Value, Friendly = Toggles.MeleeAuraFriendly.Value, Visible = false }, { Character = Options.MeleeAuraDistance.Value }, Options.MeleeAuraParts:GetActiveValues())
    local Tool                                                  = Vars.Melee.Object
    local Config                                                = Vars.Melee.Config
    local Handle                                                = FindFirstChild(Tool, "Handle") or FindFirstChild(Tool, "WeaponHandle") or FindFirstChild(Character, "Right Arm")

    if not Target then return end
    if not Distance then return end
    if not Limb then return end

    if not Tool then return end
    if not Handle then return end

    Fondra.Cooldowns.MeleeAura                                  = tick()

    local Seed                                                  = Fondra.Services.ReplicatedStorage.Events["XMHH.2"]:InvokeServer(
        "\240\159\141\158", 
        tick(), 
        Tool, 
        "43TRFWX", 
        "Normal", 
        tick(), 
        true
    )

    task.delay(Config.Mains["S1"].DebounceTime / 3, function()
        for i = 1, Config.Mains["S1"].MaxHits do
            Fondra.Services.ReplicatedStorage.Events["XMHH2.2"]:FireServer(
                "\240\159\141\158", 
                tick(), 
                Tool, 
                "2389ZFX34",
                Seed, 
                true, 
                Handle,
                Limb, 
                Target, 
                Handle.Position, 
                Limb.Position
            )
        end
    end)
end

Fondra.Functions.FinishAura                                     = function(Client, Character)
    if not Client then return end
    if not Character then return end

    if Vars.Downed then return end
    if not Vars.Melee then return end
    if not Vars.Melee.Object then return end
    if not Vars.Melee.Config then return end
    
    if not Toggles.FinishAura.Value then return end
    if tick() - Fondra.Cooldowns.FinishAura < 0.35 then return end

    local Target, Distance, Limb                                = Fondra.Functions.Return({ Get = "Character", Part = "Random", Visible = "None" }, { Downed = false, Friendly = Toggles.FinishAuraFriendly.Value, Visible = false }, { Character = Options.FinishAuraDistance.Value }, { "Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg" })
    local Tool                                                  = Vars.Melee.Object
    local Config                                                = Vars.Melee.Config
    local Handle                                                = FindFirstChild(Character, "Right Leg")

    if not Target then return end
    if not Distance then return end
    if not Limb then return end

    if not Tool then return end
    if not Handle then return end

    Fondra.Cooldowns.FinishAura                                 = tick()

    local Seed                                                  = Fondra.Services.ReplicatedStorage.Events["XMHH.2"]:InvokeServer(
        "\240\159\141\158", 
        tick(), 
        Tool, 
        "EXECQX"
    )

    task.delay(0.25, function()   
        Fondra.Services.ReplicatedStorage.Events["XMHH2.2"]:FireServer(
            "\240\159\141\158", 
            tick(), 
            Tool, 
            "2389ZFX34", 
            Seed, 
            false, 
            Handle, 
            Limb, 
            Target, 
            Handle.Position, 
            Limb.Position
        )
    end)
end

Fondra.Functions.RageBot                                        = function(Client, Character)
    if not Client then return end
    if not Character then return end

    if not Vars.Gun then return end
    if not Vars.Gun.Object then return end
    if not Vars.Gun.Config then return end

    if not Toggles.RageBot.Value then return end
    if Vars.Downed then return end

    local Tool                                                  = Vars.Gun.Object
    local Config                                                = Vars.Gun.Config

    local FPS                                                   = Fondra.Functions.FP() and getgenv().ViewModelTool
	local Handle 												= FindFirstChild(FPS and FPS or Tool, "WeaponHandle") or FindFirstChild(FPS and FPS or Tool, "Handle")

    if not Tool then return end
    if not Config then return end
    if Options.RageBotMode.Value == "Hold" and not Fondra.Services.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end

    if ((tick() - Fondra.Cooldowns.RageBot) > ((Toggles.RageBotFasterHit.Value and 0.15) or (Toggles.RageBotInstantHit.Value and 0.005) or (1 / Config.FireRate))) and (Tool.Values.SERVER_Ammo.Value > 0) then
        Fondra.Cooldowns.RageBot                                = tick()

        local Target, Distance, Limb                            = Fondra.Functions.Return({ Get = "Character", Part = "Random", Visible = "Wallbang" }, { Downed = Toggles.RageBotDowned.Value, Friendly = Toggles.RageBotFriendly.Value, Visible = true }, { Character = Options.RageBotDistance.Value }, Options.RageBotParts:GetActiveValues())
        
        if not Target then return end
        if not Distance then return end
        if not Limb then return end

        if Toggles.RageBotAnimation.Value then Fondra.Functions.GunAnimation(Tool, "Fire") end
        if Toggles.RageBotSound.Value then Fondra.Functions.GunSound(Tool, "Muzzle", "FireSound1") end
        if Toggles.RageBotNotify.Value then Library:Notify(string.format("%s, %s Meters, %s", Target.Name, math.floor(Distance), Limb.Name)) end

        local FOffset                                           = CFrame.new(0, Toggles.InvertAim.Value and -Options.ShootOffsetY.Value or Options.ShootOffsetY.Value, 0)
        local LOffset                                           = CFrame.new(0, Toggles.InvertLimb.Value and -Options.LimbOffsetY.Value or Options.LimbOffsetY.Value, 0)

        local FireOffset                                        = (Handle.FirePos.WorldCFrame * FOffset).p
        local HitOffset                                         = (Limb.CFrame * LOffset).p

        local HitPositions                                      = {}
        local Key                                               = Fondra.Functions.RandomString(30)..0

        for Index = 1, Config.BulletsPerShot do table.insert(HitPositions, CFrame.new(FireOffset, HitOffset).LookVector) end

        Fondra.Services.ReplicatedStorage.Events.GNX_S:FireServer(
            tick(),
            Key,
            Tool,
            "FDS9I83",
            FireOffset,
            HitPositions,
            false
        )
                
        task.delay(0.1, function()
            for Index, HitPosition in next, HitPositions do Fondra.Services.ReplicatedStorage.Events.ZFKLF_H:FireServer(
                "\240\159\141\175",
                Tool,
                Key,
                Index,
                Limb,
                HitOffset,
                HitPosition,
                nil,
                nil
            ) end
    
            Fondra.Functions.Tracer(FireOffset, HitOffset, Options.AccentColor.Value)
    
            Tool.Hitmarker:Fire(Limb)
            Tool.Values.Ammo.Value                              = Tool.Values.SERVER_Ammo.Value - 1
            Tool.Values.StoredAmmo.Value                        = Tool.Values.SERVER_StoredAmmo.Value
        end)
    end
end
-- #EndRegion

-- #Region // Hooks
for Index, Data in next, getgc(true) do
    if typeof(Data) == "table" and typeof(rawget(Data, "CX1")) == "function" then
        Data.CX1 = function() end

		continue
    end

    if typeof(Data) == "table" and rawget(Data, "Detected") and typeof(rawget(Data, "Detected")) == "function" then    
		hookfunction(Data["Detected"], function(Action, Info, NoCrash)
            if rawequal(Action, "_") then return true end
            if rawequal(Info, "_") then return true end

            return task.wait(9e9)
        end)

		continue
    end

    if typeof(Data) == "function" and debug.getinfo(Data).name == "S_Get" then
        local Old; Old = hookfunction(Data, function(...)
            if Toggles.Stamina.Value then
                return 100, 100
            end

            return Old(...)
        end)

		continue
    end

    if type(Data) == "table" and rawget(Data, "XIIX") then
        local Old; Old                                          = hookfunction(getproto(Data.XIIX, 63, true)[1], function(...)
            local Arguments                                     = {...}

            if (Toggles.AntiAim.Value or Toggles.HiddenHead.Value or Toggles.HiddenBody.Value) and Arguments[1] == Fondra.Client.Character then
                local Method                                    = Options.AntiAimMethod.Value
                local HeadAngle                                 = nil
                local ArmAngle                                  = nil

                if Method == "Down" then
                    HeadAngle                                   = -57
                    ArmAngle                                    = -360
                end

                if Method == "Up" then
                    HeadAngle                                   = 57
                    ArmAngle                                    = 360
                end

                if Method == "Random" then
                    HeadAngle                                   = Fondra.Functions.SmoothOscillation(-57, 57)
                    ArmAngle                                    = Fondra.Functions.SmoothOscillation(-360, 360)
                end

                if Toggles.HiddenHead.Value then HeadAngle = -math.huge end
                if Toggles.HiddenBody.Value then HeadAngle = -57 end
                
                if ArmAngle then Arguments[2] = NewVector3(1, math.rad(100), 0) end
                if ArmAngle then Arguments[3] = NewVector3(0, math.rad(-ArmAngle), 0) end
                if HeadAngle then Arguments[4] = NewVector3(0, math.rad(HeadAngle), 0) end
            end

            return Old(table.unpack(Arguments))
        end)

        continue
    end
end

local Namecall; Namecall                                        = hookmetamethod(game, "__namecall", function(Self, ...)
    local Arguments                                             = {...}
    local Name                                                  = tostring(Self)
    local Method                                                = getnamecallmethod()
    local Calling                                               = getcallingscript() and getcallingscript().Name or nil

    if Method == "UnequipTools" and not checkcaller() and Toggles.Fly.Value and Calling ~= "Backpack" then
		return
    end

    if (Calling == "Client" or Calling == "ControlModule") and not checkcaller() and (Arguments[4] == "FDS9I83") and (Vars.Alive and not Vars.Downed and Vars.Gun and Vars.Gun.Object and Vars.Gun.Config and Vars.CharStats) and (Toggles.LegitBot.Value) then        
        local Chance                                            = NextInteger(Fondra.Random, 1, 100)
        local Target, Distance, Limb                            = Fondra.Functions.Return({ Get = "Mouse", Part = "Random", Visible = "Check" }, { Downed = Toggles.LegitBotDowned.Value, Friendly = Toggles.LegitBotFriendly.Value, Visible = true }, { Character = Options.LegitBotDistance.Value, Mouse = Options.LegitBotRadius.Value }, Options.LegitBotParts.GetActiveValues(Options.LegitBotParts))
        local HitPositions                                      = {}

        if not Target or not Distance or not Limb then return Namecall(Self, unpack(Arguments)) end

        for Index = 1, Vars.Gun.Config.BulletsPerShot do 
            local LN                                            = 1
            local SpreadMove                                    = 0

            if Vars.Gun.Config.Customs and Vars.Gun.Config.Customs.LaserEnabled then
                LN                                              = Vars.Gun.Config.Customs.LaserAccuracy
            end

            local Spread                                        = (Vars.Gun.Config.Spread * (0.5 * 1 * 0.5) * 0.5 * 0.5 * LN)	

            if Vars.Gun.Config.SniperEnabled then Spread = Spread + SpreadMove end
            if FindFirstChild(Vars.CharStats.Currents, "RBTMVB") then Spread = Spread * 0.5 end
            
            Spread                                              = Spread * 22

            local XSpread                                       = NextNumber(Fondra.Random, -Spread, Spread)
            local YSpread                                       = NextNumber(Fondra.Random, -Spread, Spread)

            local Direction                                     = CFrame.new(Fondra.Camera.CFrame.Position, Limb.CFrame.Position)
            local Offset                                        = Direction * CFrame.Angles(math.rad(XSpread / 100), math.rad(YSpread / 100), 0)

            table.insert(HitPositions, Offset.LookVector) 
        end

        Arguments[6]                                            = HitPositions

        return Namecall(Self, unpack(Arguments))
    end

    if Method == "Raycast" and not checkcaller() and (Vars.Alive and not Vars.Downed and Vars.Gun and Vars.Gun.Object and Vars.Gun.Config) and (Toggles.LegitBot.Value) then    
        if (Calling ~= "Visuals") then return Namecall(Self, unpack(Arguments)) end
        
        local Chance                                            = NextInteger(Fondra.Random, 1, 100)
        local Target, Distance, Limb                            = Fondra.Functions.Return({ Get = "Mouse", Part = "Random", Visible = "Check" }, { Downed = Toggles.LegitBotDowned.Value, Friendly = Toggles.LegitBotFriendly.Value, Visible = true }, { Character = Options.LegitBotDistance.Value, Mouse = Options.LegitBotRadius.Value }, Options.LegitBotParts.GetActiveValues(Options.LegitBotParts))

        if not Target or not Distance or not Limb then return Namecall(Self, unpack(Arguments)) end

        Arguments[2]                                            = (Limb.Position - Arguments[1]).Unit * 1000000000

        return Namecall(Self, unpack(Arguments))
    end

    if Method == "FireServer" and not checkcaller() then
        local Disablers                                         = Options.Disablers.GetActiveValues(Options.Disablers)

        if Name == "TK_DGM" and Arguments[2] == "Drown" and table.find(Disablers, "Drowning") then return end
        if Name == "__DFfDD" and Arguments[1] == "G_Gh" and table.find(Disablers, "Grinders") then return end
        if Name == "__DFfDD" and Arguments[1] == "BHHh" and table.find(Disablers, "Barbwires") then return end
        if Name == "__DFfDD" and Arguments[1] == "__--r" or Arguments[1] == "-r__r2" and table.find(Disablers, "Ragdoll") then return end
        if Name == "__DFfDD" and Arguments[1] == "FlllD" or Arguments[1] == "FllH" and table.find(Disablers, "Fall Damage") then return end
    end

    if Method == "InvokeServer" and not checkcaller() then if Name == "Remote" and Arguments[1] == "E" and Toggles.NoFail.Value then return end end

    return Namecall(Self, unpack(Arguments))
end)

local NewIndex; NewIndex										= hookmetamethod(game, "__newindex", function(Self, Index, Value)
	local Name 													= tostring(Self)
	local Method 												= tostring(Index)
	local Result 												= tostring(Value)
	local Sky 													= Fondra.SkyBoxes[Options.SelectedSkyBox.Value] or nil

	-- Lighting
	if (Name == "Lighting") and (Method == "Ambient") and (Self == Fondra.Services.Lighting) and (Toggles.Ambience.Value) then
		return NewIndex(Self, Index, Options.AmbienceColor1.Value or Value)
	end

	if (Name == "Lighting") and (Method == "OutdoorAmbient") and (Self == Fondra.Services.Lighting) and (Toggles.Ambience.Value) then
		return NewIndex(Self, Index, Options.AmbienceColor2.Value or Value)
	end

	if (Name == "Lighting") and (Method == "ColorShift_Bottom") and (Self == Fondra.Services.Lighting) and (Toggles.Shift.Value) then
		return NewIndex(Self, Index, Options.ShiftColor1.Value or Value)
	end

	if (Name == "Lighting") and (Method == "ColorShift_Top") and (Self == Fondra.Services.Lighting) and (Toggles.Shift.Value) then
		return NewIndex(Self, Index, Options.ShiftColor2.Value or Value)
	end

	if (Name == "Lighting") and (Method == "GlobalShadows") and (Self == Fondra.Services.Lighting) then
		return NewIndex(Self, Index, Toggles.ShadowMap.Value)
	end

	if (Name == "Lighting") and (Method == "ClockTime") and (Self == Fondra.Services.Lighting) and (Toggles.ForceTime.Value) then
		return NewIndex(Self, Index, Options.SelectedTime.Value)
	end
	
	if (Name == "Lighting") and (Method == "GeographicLatitude") and (Self == Fondra.Services.Lighting) and (Toggles.ForceLatitude.Value) then
		return NewIndex(Self, Index, Options.SelectedLatitude.Value)
	end

	if (Name == "Lighting") and (Method == "EnvironmentDiffuseScale") and (Self == Fondra.Services.Lighting) and (Toggles.ForceDiffuse.Value) then
		return NewIndex(Self, Index, Options.SelectedDiffuse.Value)
	end

	-- Atmosphere
	if (Name == "Atmosphere") and (Method == "Decay") and (Self.Parent == Fondra.Services.Lighting) and (Toggles.SkyBox.Value) then
		return NewIndex(Self, Index, Sky and Sky["Data"]["Atmos"]["Decay"] or Value)
	end

	if (Name == "Atmosphere") and (Method == "Color") and (Self.Parent == Fondra.Services.Lighting) and (Toggles.SkyBox.Value) then
		return NewIndex(Self, Index, Sky and Sky["Data"]["Atmos"]["Color"] or Value)
	end

	if (Name == "Atmosphere") and (Method == "Glare") and (Self.Parent == Fondra.Services.Lighting) and (Toggles.SkyBox.Value) then
		return NewIndex(Self, Index, Sky and Sky["Data"]["Atmos"]["Glare"] or Value)
	end

	if (Name == "Atmosphere") and (Method == "Haze") and (Self.Parent == Fondra.Services.Lighting) and (Toggles.SkyBox.Value) then
		return NewIndex(Self, Index, Sky and Sky["Data"]["Atmos"]["Haze"] or Value)
	end

	-- Viewmodel
	if (Name == "Left Arm") and (Method == "Color") and (Self.Parent == getgenv().ViewModel) and (Toggles.Viewmodel.Value) and Fondra.Functions.FP() then
		return NewIndex(Self, Index, Options.ViewmodelLArmColor.Value or Value)
	end

	if (Name == "Right Arm") and (Method == "Color") and (Self.Parent == getgenv().ViewModel) and (Toggles.Viewmodel.Value) and Fondra.Functions.FP() then
		return NewIndex(Self, Index, Options.ViewmodelRArmColor.Value or Value)
	end

	if (Name == "Left Arm") and (Method == "Transparency") and (Self.Parent == getgenv().ViewModel) and (Toggles.Viewmodel.Value) and Fondra.Functions.FP() then
		return NewIndex(Self, Index, Options.ViewmodelLArmTransparency.Value or Value)
	end

	if (Name == "Right Arm") and (Method == "Transparency") and (Self.Parent == getgenv().ViewModel) and (Toggles.Viewmodel.Value) and Fondra.Functions.FP() then
		return NewIndex(Self, Index, Options.ViewmodelRArmTransparency.Value or Value)
	end

	if (Name == "Left Arm" or Name == "Right Arm") and (Method == "Material") and (Self.Parent == getgenv().ViewModel) and (Toggles.Viewmodel.Value) and Fondra.Functions.FP() then
		return NewIndex(Self, Index, Enum.Material[Options.ViewmodelArmsMaterial.Value] or Value)
	end

    -- Character
	if (Name == "HumanoidRootPart" or Name == "Torso" or Name == "Head") and (Method == "CanCollide") and (Self.Parent == Fondra.Client.Character) and (Toggles.Noclip.Value) then
		return NewIndex(Self, Index, false)
	end

    if (Name == "Humanoid") and (Method == "HipHeight") and (Self.Parent == Fondra.Client.Character) and (Toggles.HiddenBody.Value) then
		return NewIndex(Self, Index, -1.975)
	end

    if (Name == "Humanoid") and (Method == "WalkSpeed") and (Self.Parent == Fondra.Client.Character) and (Toggles.WalkSpeed.Value) then
		return NewIndex(Self, Index, Options.WalkSpeed.Value or Value)
	end

    if (Name == "Humanoid") and (Method == "JumpPower") and (Self.Parent == Fondra.Client.Character) and (Toggles.JumpPower.Value) then
		return NewIndex(Self, Index, Options.JumpPower.Value or Value)
	end

    if (Name == "ROTROOT") and (Method == "Parent") and (Result == "Currents") and (Toggles.SprayAura.Value) then
		return NewIndex(Self, Index, nil)
	end

	return NewIndex(Self, Index, Value)
end)

local Index; Index                                             	= hookmetamethod(game, "__index", function(Self, Value)
	local Name 													= tostring(Self)
	local Method 												= tostring(Value)
	local Calling 												= getcallingscript()
    
	if (Name == "FP_Offset") and (Method == "Value") and (not checkcaller()) and (Toggles.Viewmodel.Value) then
        return NewVector3(Options.ViewmodelXOffset.Value / 7, Options.ViewmodelYOffset.Value / 7, Options.ViewmodelZOffset.Value / 7)
    end

    if (Name == "Ammo") and (Method == "Value") and (string.find(Self.Parent.Name, "Pepper")) and (not checkcaller()) and (Toggles.InfinitePepperSpray.Value) then
        return 100
    end
  
    return Index(Self, Value)
end)

hookfunction(Config, function(Tool)
    local GunData                                               = {}
    local Config                                                = require(WaitForChild(Tool, "Config"))

    for Index, Value in next, Config do
        if (Index == "Recoil") or (string.find(Index, "_Max")) or (string.find(Index, "_Min")) then
            GunData[Index]                                      = Value * (Options.RecoilPercentage.Value / 100)

            continue
        end

        if (Index == "Spread") then
            GunData[Index]                                      = Value * (Options.SpreadPercentage.Value / 100)

            continue
        end

        GunData[Index]                                          = Value
    end

    return GunData
end)

Fondra.Hooks.Namecall                                           = Namecall
Fondra.Hooks.NewIndex                                           = NewIndex
Fondra.Hooks.Index                                              = Index
-- #EndRegion

-- #Region // Handler
task.spawn(Fondra.Functions.LocalCharacter, Fondra.Client.Character)

Options.SelectedSkyBox:SetValues(Fondra.Functions.GetSkyBoxes())
Options.SelectedSkyBox:SetValue("Default")
--Options.SelectedHitMarker:SetValues(Fondra.Functions.GetHitMarkers())
--Options.SelectedHitMarker:SetValue("Default")

Toggles.RageBot:OnChanged(function(V)
    if not V then return end

    if Toggles.LegitBot.Value then Toggles.LegitBot:SetValue(false) Library:Notify("Turned off LegitBot because RageBot has been turned on.") end
end)

Toggles.LegitBot:OnChanged(function(V)
    if not V then return end

    if Toggles.RageBot.Value then Toggles.RageBot:SetValue(false) Library:Notify("Turned off RageBot because LegitBot has been turned on.") end
end)

Toggles.Fly:OnChanged(function(V)
    Fondra.Functions.Fly(Fondra.Client, Fondra.Client.Character)
end)

Toggles.HiddenBody:OnChanged(function(V)
    Fondra.Functions.HiddenBody(Fondra.Client, Fondra.Client.Character)
end)

Toggles.SBot:OnChanged(function(V)
    Fondra.Functions.SpinBot(Fondra.Client, Fondra.Client.Character)
end)

Toggles.FLag:OnChanged(function(V)
    if getgenv().FLagVisual then getgenv().FLagVisual:Destroy() end
    Fondra.Services.NetworkClient:SetOutgoingKBPSLimit(9e9)
end)

Toggles.FLagVisual:OnChanged(function(V)
    if not V then if getgenv().FLagVisual then getgenv().FLagVisual:Destroy() end return end

    local Model                                                 = Instance.new("Model")
    local Limbs                                                 = {
        ["Head"]                                                = Instance.new("Part"),
        ["Torso"]                                               = Instance.new("Part"),
        ["Left Arm"]                                            = Instance.new("Part"),
        ["Right Arm"]                                           = Instance.new("Part"),
        ["Left Leg"]                                            = Instance.new("Part"),
        ["Right Leg"]                                           = Instance.new("Part")
    }

    Limbs["Head"].Parent                                        = Model
    Limbs["Head"].Size                                          = NewVector3(1, 1, 1)
    Limbs["Head"].Position                                      = NewVector3(0, -0.45, 0)
    Limbs["Head"].CanCollide									= false
    Limbs["Head"].Anchored										= true

    Limbs["Torso"].Parent                                       = Model
    Limbs["Torso"].Size                                         = NewVector3(2, 2, 1)
    Limbs["Torso"].Position                                     = NewVector3(0, -2, 0)
    Limbs["Torso"].CanCollide									= false
    Limbs["Torso"].Anchored										= true

    Limbs["Left Arm"].Parent                                    = Model
    Limbs["Left Arm"].Size                                      = NewVector3(1, 2, 1)
    Limbs["Left Arm"].Position                                  = NewVector3(-1.55, -2, 0)
    Limbs["Left Arm"].CanCollide								= false
    Limbs["Left Arm"].Anchored									= true

    Limbs["Right Arm"].Parent                                   = Model
    Limbs["Right Arm"].Size                                     = NewVector3(1, 2, 1)
    Limbs["Right Arm"].Position                                 = NewVector3(1.55, -2, 0)
    Limbs["Right Arm"].CanCollide								= false
    Limbs["Right Arm"].Anchored									= true

    Limbs["Left Leg"].Parent                                    = Model
    Limbs["Left Leg"].Size                                      = NewVector3(1, 2, 1)
    Limbs["Left Leg"].Position                                  = NewVector3(-0.5, -4.05, 0)
    Limbs["Left Leg"].CanCollide								= false
    Limbs["Left Leg"].Anchored									= true

    Limbs["Right Leg"].Parent                                   = Model
    Limbs["Right Leg"].Size                                     = NewVector3(1, 2, 1)
    Limbs["Right Leg"].Position                                 = NewVector3(0.5, -4.05, 0)
    Limbs["Right Leg"].CanCollide								= false
    Limbs["Right Leg"].Anchored									= true

    for i, v in next, Limbs do
        v.Name 													= i
        v.Transparency											= 0.5
        v.Material 												= Enum.Material.ForceField
        v.Color													= Color3.fromRGB(0, 0, 255)

        local SpecialMesh 										= Instance.new("SpecialMesh")
        SpecialMesh.Parent										= v
        SpecialMesh.Scale										= v.Size
        SpecialMesh.MeshType									= Enum.MeshType.Brick
        SpecialMesh.TextureId									= "rbxassetid://2163189692"
        SpecialMesh.VertexColor									= NewVector3(0, 0.45, 1)
    end

    Model.Name													= "FakeLagVisual"
    Model.Parent												= Fondra.Camera
    Model.PrimaryPart											= Limbs["Torso"]

    getgenv().FLagVisual                                        = Model
    
    if not Toggles.FLag.Value then return end

    getgenv().FLagVisual:SetPrimaryPartCFrame(Fondra.Client.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0.01, 0))
end)

Toggles.ChatLogs:OnChanged(function(V)
    local ChatFrame                                             = Fondra.Client.PlayerGui.Chat.Frame
	ChatFrame.ChatChannelParentFrame.Visible                    = V
	ChatFrame.ChatBarParentFrame.Position                       = V and (ChatFrame.ChatChannelParentFrame.Position + UDim2.new(UDim.new(), ChatFrame.ChatChannelParentFrame.Size.Y)) or (UDim2.new(0, 0, 0, 0))
end)

Options.SpinSpeed:OnChanged(function(V)
    Fondra.Functions.SpinBot(Fondra.Client, Fondra.Client.Character)
end)

Fondra.Functions.NewConnection("Character Added", Fondra.Connections, Fondra.Client.CharacterAdded, Fondra.Functions.LocalCharacter)
Fondra.Functions.NewConnection("Mouse Move", Fondra.Connections, Fondra.Mouse.Move, function()
	local Gun 													= (Vars.Gun and Vars.Gun.Object and Vars.Gun.Config) and true or false

    Fondra.Data.FOV.Position									= Fondra.Services.UserInputService:GetMouseLocation()
    Fondra.Data.FOV.Color                                       = Options.AccentColor.Value
    Fondra.Data.FOV.Radius                                      = Options.LegitBotRadius.Value
    Fondra.Data.FOV.Visible										= Toggles.LegitBotFOV.Value and Toggles.LegitBot.Value and Gun
end)

Fondra.Functions.NewConnection("Main", Fondra.Connections, Fondra.Services.RunService.Heartbeat, function(Delta)
    Fondra.Functions.ProjectileController(Fondra.Client, Fondra.Client.Character)
    Fondra.Functions.FlyController(Fondra.Client, Fondra.Client.Character)

    if Vars.Alive then
        Fondra.Functions.BHop(Fondra.Client, Fondra.Client.Character)
        Fondra.Functions.Stats(Fondra.Client, Fondra.Client.Character)
        Fondra.Functions.FakeLag(Fondra.Client, Fondra.Client.Character)
        Fondra.Functions.TriggerBot(Fondra.Client, Fondra.Client.Character)

        Fondra.Functions.AutoPickUp(Fondra.Client, Fondra.Client.Character)
        Fondra.Functions.AutoBreak(Fondra.Client, Fondra.Client.Character)
        Fondra.Functions.Reload(Fondra.Client, Fondra.Client.Character)

        Fondra.Functions.RageBot(Fondra.Client, Fondra.Client.Character)
        Fondra.Functions.SprayAura(Fondra.Client, Fondra.Client.Character)
        Fondra.Functions.MeleeAura(Fondra.Client, Fondra.Client.Character)
        Fondra.Functions.FinishAura(Fondra.Client, Fondra.Client.Character)
    end
end)

Library:Notify(string.format("Loaded Main.lua in %.4f MS", tick() - Fondra.Data.Start))
Library.SaveManager:LoadAutoloadConfig()
-- #EndRegion
