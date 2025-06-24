
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")


local LocalPlayer = Players.LocalPlayer
local targetPlayer = nil
local isFlinging = false
local isTouchFlingEnabled = false
local originalCameraSubject = nil
local hiddenfling = false
local flingThread


local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TouchFlingPremium"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")


local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.389, 0, 0.428, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 220)
MainFrame.Parent = ScreenGui


local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame


local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Parent = MainFrame

local UICornerTitle = Instance.new("UICorner")
UICornerTitle.CornerRadius = UDim.new(0, 8)
UICornerTitle.Parent = TitleBar


local TitleText = Instance.new("TextLabel")
TitleText.Name = "TitleText"
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.Size = UDim2.new(1, -20, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "Touch Fling Premium"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.TextSize = 16
TitleText.Parent = TitleBar


local TouchFlingButton = Instance.new("TextButton")
TouchFlingButton.Name = "TouchFlingButton"
TouchFlingButton.BackgroundColor3 = Color3.fromRGB(255, 59, 59)
TouchFlingButton.Position = UDim2.new(0.5, -55, 0.25, -15)
TouchFlingButton.Size = UDim2.new(0, 110, 0, 40)
TouchFlingButton.Font = Enum.Font.GothamSemibold
TouchFlingButton.Text = "Touch Fling: OFF"
TouchFlingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TouchFlingButton.TextSize = 16
TouchFlingButton.Parent = MainFrame

local UICornerTouch = Instance.new("UICorner")
UICornerTouch.CornerRadius = UDim.new(0, 6)
UICornerTouch.Parent = TouchFlingButton


local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SearchBox.Position = UDim2.new(0.5, -75, 0.5, -15)
SearchBox.Size = UDim2.new(0, 150, 0, 30)
SearchBox.Font = Enum.Font.GothamSemibold
SearchBox.PlaceholderText = "Enter player name..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextSize = 14
SearchBox.Parent = MainFrame

local UICornerSearch = Instance.new("UICorner")
UICornerSearch.CornerRadius = UDim.new(0, 6)
UICornerSearch.Parent = SearchBox


local TargetButton = Instance.new("TextButton")
TargetButton.Name = "TargetButton"
TargetButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
TargetButton.Position = UDim2.new(0.5, -55, 0.75, -15)
TargetButton.Size = UDim2.new(0, 110, 0, 40)
TargetButton.Font = Enum.Font.GothamSemibold
TargetButton.Text = "Target Fling"
TargetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetButton.TextSize = 16
TargetButton.Parent = MainFrame

local UICornerTarget = Instance.new("UICorner")
UICornerTarget.CornerRadius = UDim.new(0, 6)
UICornerTarget.Parent = TargetButton


local function Message(_Title, _Text, Time)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = _Title,
        Text = _Text,
        Duration = Time
    })
end


local function SkidFling(TargetPlayer)
    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid
    local TRootPart
    local THead
    local Accessory
    local Handle

    if TCharacter:FindFirstChildOfClass("Humanoid") then
        THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    end
    if THumanoid and THumanoid.RootPart then
        TRootPart = THumanoid.RootPart
    end
    if TCharacter:FindFirstChild("Head") then
        THead = TCharacter.Head
    end
    if TCharacter:FindFirstChildOfClass("Accessory") then
        Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    end
    if Accessory and Accessory:FindFirstChild("Handle") then
        Handle = Accessory.Handle
    end

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        
        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
        
        local SFBasePart = function(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0

            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        
                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until not isFlinging or tick() > Time + TimeToWait
        end
        
        workspace.FallenPartsDestroyHeight = 0/0
        
        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
        
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        
        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart and not THead then
            SFBasePart(TRootPart)
        elseif not TRootPart and THead then
            SFBasePart(THead)
        elseif not TRootPart and not THead and Accessory and Handle then
            SFBasePart(Handle)
        else
            return Message("Error Occurred", "Target is missing everything", 5)
        end
        
        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        
        repeat
            RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
            Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
            Humanoid:ChangeState("GettingUp")
            table.foreach(Character:GetChildren(), function(_, x)
                if x:IsA("BasePart") then
                    x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                end
            end)
            task.wait()
        until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
        workspace.FallenPartsDestroyHeight = getgenv().FPDH
    else
        return Message("Error Occurred", "Random error", 5)
    end
end


local function IIMAWH_fake_script()
	local script = Instance.new('LocalScript', TextButton)

	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	
	local toggleButton = script.Parent
	local hiddenfling = false
	local flingThread 
	if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
		local detection = Instance.new("Decal")
		detection.Name = "juisdfj0i32i0eidsuf0iok"
		detection.Parent = ReplicatedStorage
	end
	
	local function fling()
		local lp = Players.LocalPlayer
		local c, hrp, vel, movel = nil, nil, nil, 0.1
	
		while hiddenfling do
			RunService.Heartbeat:Wait()
			c = lp.Character
			hrp = c and c:FindFirstChild("HumanoidRootPart")
	
			if hrp then
				vel = hrp.Velocity
				hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
				RunService.RenderStepped:Wait()
				hrp.Velocity = vel
				RunService.Stepped:Wait()
				hrp.Velocity = vel + Vector3.new(0, movel, 0)
				movel = -movel
			end
		end
	end
	
	toggleButton.MouseButton1Click:Connect(function()
		hiddenfling = not hiddenfling
		toggleButton.Text = hiddenfling and "Touch Fling: ON" or "Touch Fling: OFF"
	
		if hiddenfling then
			flingThread = coroutine.create(fling)
			coroutine.resume(flingThread)
		else
			hiddenfling = false
		end
	end)
	
end


local function updatePlayerSearch()
    local searchText = SearchBox.Text:lower()
    
    if searchText == "all" then
        targetPlayer = "all"
        Message("All Players Mode", "Will target all players in sequence", 3)
        return
    end
    
    if #searchText >= 3 then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Name:lower():sub(1, #searchText) == searchText then
                SearchBox.Text = player.Name
                targetPlayer = player.Name
                break
            end
        end
    else
        targetPlayer = nil
    end
end


local function targetFling()
    if not targetPlayer then 
        Message("Error", "Please enter a valid player name (3+ characters) or 'all'", 3)
        return 
    end
    
    if not isFlinging then
        isFlinging = true
        TargetButton.BackgroundColor3 = Color3.fromRGB(59, 255, 59)
        originalCameraSubject = workspace.CurrentCamera.CameraSubject
        
        
        local animationTween = TweenService:Create(TargetButton, TweenInfo.new(0.3), 
            {BackgroundTransparency = 0.3})
        animationTween:Play()
        
        coroutine.wrap(function()
            while isFlinging do
                if targetPlayer == "all" then 
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and not isFlinging then break end
                        if player ~= LocalPlayer then
                            local targetCharacter = player.Character
                            if targetCharacter and targetCharacter:FindFirstChild("Humanoid") then
                                workspace.CurrentCamera.CameraSubject = targetCharacter.Humanoid
                                SkidFling(player)
                                task.wait(1) 
                            end
                        end
                    end
                else

                    local targetPlayerObject = Players:FindFirstChild(targetPlayer)
                    if targetPlayerObject then
                        local targetCharacter = targetPlayerObject.Character
                        if targetCharacter and targetCharacter:FindFirstChild("Humanoid") then
                            workspace.CurrentCamera.CameraSubject = targetCharacter.Humanoid
                            SkidFling(targetPlayerObject)
                        end
                    end
                end
                RunService.Heartbeat:Wait()
            end
        end)()
    else
        isFlinging = false
        TargetButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        workspace.CurrentCamera.CameraSubject = originalCameraSubject
        

        local animationTween = TweenService:Create(TargetButton, TweenInfo.new(0.3), 
            {BackgroundTransparency = 0})
        animationTween:Play()
    end
end


SearchBox.Changed:Connect(updatePlayerSearch)
TargetButton.MouseButton1Click:Connect(targetFling)
TouchFlingButton.MouseButton1Click:Connect(toggleTouchFling)


local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)


local function hiddenFling()
    local lp = LocalPlayer
    local c, hrp, vel, movel = nil, nil, nil, 0.1

    while hiddenfling do
        RunService.Heartbeat:Wait()
        c = lp.Character
        hrp = c and c:FindFirstChild("HumanoidRootPart")

        if hrp then
            vel = hrp.Velocity
            hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
            RunService.Stepped:Wait()
            hrp.Velocity = vel + Vector3.new(0, movel, 0)
            movel = -movel
        end
    end
end


TouchFlingButton.MouseButton1Click:Connect(function()
    hiddenfling = not hiddenfling
    TouchFlingButton.Text = hiddenfling and "Touch Fling: ON" or "Touch Fling: OFF"
    TouchFlingButton.BackgroundColor3 = hiddenfling and Color3.fromRGB(59, 255, 59) or Color3.fromRGB(255, 59, 59)

    if hiddenfling then
        flingThread = coroutine.create(hiddenFling)
        coroutine.resume(flingThread)
    else
        hiddenfling = false
    end
end)


if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
    local detection = Instance.new("Decal")
    detection.Name = "juisdfj0i32i0eidsuf0iok"
    detection.Parent = ReplicatedStorage
end


if not getgenv().Welcome then 
    Message("Touch Fling", "By 09gw discord", 5) 
    getgenv().Welcome = true
end

print("Touch Fling script loaded successfully!")
