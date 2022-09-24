local ChangeHistoryService = game:GetService("ChangeHistoryService")
local Selection = game:GetService('Selection')

local PluginToolbar = plugin:CreateToolbar("QTpi")
local PluginBtn = PluginToolbar:CreateButton("Serialize", "Serialize To Modulescript", "rbxassetid://5016313061")

function SerializeKeyframes(_Sequence)
	local Sequence = _Sequence:GetChildren()
	local SerealizedString = "{"
	for _, Object in pairs(Sequence) do
		local Data = ""
		for _, Pose in pairs(Object:GetDescendants()) do
			local CF = Pose.CFrame
			local X, Y, Z = CF:ToEulerAnglesXYZ()
			Data ..= "[\""..Pose.Name.."\"] = { CFrame = CFrame.new("..CF.Position.X..", "..CF.Position.Y..", "..CF.Position.Z..") * CFrame.Angles("..X..", "..Y..", "..Z.."), EasingStyle = \""..Pose.EasingStyle.Name.."\", EasingDirection = \""..Pose.EasingDirection.Name.."\" },"
		end 
		SerealizedString ..= "{Time = "..Object.Time..", Sequence = {"..Data.."}},\
"
	end
	return SerealizedString .. "}"
end

PluginBtn.ClickableWhenViewportHidden = true
PluginBtn.Click:Connect(function()
	local _Selection = Selection:Get()[1]
	if _Selection then
		if _Selection:IsA('KeyframeSequence') then
			local SerializedKeyframes = SerializeKeyframes(_Selection)
			local ModuleScript = Instance.new('ModuleScript', _Selection.Parent)
			ModuleScript.Source = "return "..SerializedKeyframes
			ModuleScript.Name = _Selection.Name .. "Anim"
			Selection:Set(ModuleScript)
			ChangeHistoryService:SetWaypoint("Converted sequence.")
		else
			print('The selected object must be a keyframesequence.')
		end
	else
		print('There\'s nothing selected!')
	end
end)
