
local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local outline = Instance.new("Highlight")
outline.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
outline.FillTransparency = 1
outline.OutlineColor = Color3.new(1, 1, 0)

local runLifting = false
local target = nil
local liftThread = nil

-- click to start lift
mouse.Button1Up:Connect(function()
	if mouse.Target then
		local model = mouse.Target:FindFirstAncestorOfClass("Model")
		if model and model:FindFirstChild("Humanoid") then
			target = model
			camera.CameraSubject = model.Humanoid
			runLifting = true

			if liftThread then
				task.cancel(liftThread)
			end

			liftThread = task.spawn(function()
				local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				local thrp = target:FindFirstChild("HumanoidRootPart")

				if not hrp or not thrp then return end

				hrp.Anchored = false

				-- start under target
				local currentCFrame = thrp.CFrame * CFrame.Angles(math.rad(90), 0, 0) + thrp.CFrame.UpVector * -6

				while runLifting and target and target:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") do
					-- move up a bit each time
					currentCFrame = currentCFrame + Vector3.new(0, 2, 0)
					local tween = ts:Create(hrp, TweenInfo.new(0.05, Enum.EasingStyle.Linear), {CFrame = currentCFrame})
					tween:Play()
					tween.Completed:Wait()
					task.wait(0.01)
				end

				-- reset
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					player.Character.HumanoidRootPart.Anchored = false
				end
			end)
		end
	end
end)

-- Q to stop
uis.InputBegan:Connect(function(input, gpe)
	if input.KeyCode == Enum.KeyCode.Q then
		runLifting = false
		target = nil
		outline.Parent = nil
		if liftThread then
			task.cancel(liftThread)
			liftThread = nil
		end
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			camera.CameraSubject = player.Character.Humanoid
			player.Character.HumanoidRootPart.Anchored = false
		end
	end
end)

-- outline + stop velocity
runService.RenderStepped:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") and runLifting == true then
		char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
	end

	if mouse.Target then
		local model = mouse.Target:FindFirstAncestorOfClass("Model")
		if model and model:FindFirstChild("Humanoid") then
			outline.Parent = model
		else
			outline.Parent = nil
		end
	end
end)



