--[[

  KeyframeEmulator V1.0.0
    Written by nonraymonable
    Find bugs? Report them at https://github.com/QTpiV2/qtpi/issues! (Please make sure you mention that it's an issue with this specific library)

--]]

local TS = game:GetService('TweenService')
local RS = game:GetService('RunService')

local KeyframeEmulator = {}

local OriginalJoints = {}
local JointsToMap = {
    -- NOTE: THIS ONLY SUPPORTS R15. FEEL FREE TO SEND IN A PR THAT ADDS THE R15 JOINT LIST. I WAS TOO LAZY.
	[Enum.HumanoidRigType.R6] = {
		["Torso"] = "Root Hip",
		["Head"] = "Neck",
		["Left Arm"] = "Left Shoulder",
		["Right Arm"] = "Right Shoulder",
		["Left Leg"] = "Left Hip",
		["Right Leg"] = "Right Hip"
	}
}

function KeyframeEmulator:GenerateAnimationTweens(Character, Sequence)
    local Humanoid = Character:FindFirstChildOfClass('Humanoid')
	local PretweenAnimation = {}
	for i = 1, #Sequence do
		local Keyframe = Sequence[i]
		PretweenAnimation[Keyframe.Time] = {}
		for Pose, PoseData in pairs(Keyframe.Sequence) do
			local Joint = JointsToMap[Humanoid.RigType][Pose]
			if Joint and Sequence[i - 1] then
				PretweenAnimation[Keyframe.Time][Joint] = TS:Create(
					Character:FindFirstChild(Joint, true),
					TweenInfo.new(Keyframe.Time - Sequence[i - 1].Time, Enum.EasingStyle[PoseData.EasingStyle], Enum.EasingDirection[PoseData.EasingDirection]),
					{
						C0 = OriginalJoints[Joint] * PoseData.CFrame
					}
				)
			elseif Joint then
				PretweenAnimation[Keyframe.Time][Joint] = TS:Create(
					Character:FindFirstChild(Joint, true),
					TweenInfo.new(Sequence[2].Time - Sequence[1].Time, Enum.EasingStyle[PoseData.EasingStyle], Enum.EasingDirection[PoseData.EasingDirection]),
					{
						C0 = OriginalJoints[Joint] * PoseData.CFrame
					}
				)
			end
		end
	end
	return PretweenAnimation
end

function KeyframeEmulator:ReweldJoints(Character)
    for _, Object in pairs(Character:GetDescendants()) do
        if Object:IsA('Motor6D') then
            local ReplacementWeld = Instance.new('Weld', Object.Parent)
            ReplacementWeld.Name = Object.Name
            ReplacementWeld.Part0 = Object.Part0
            ReplacementWeld.Part1 = Object.Part1
            ReplacementWeld.C0 = Object.C0
            ReplacementWeld.C1 = Object.C1
            OriginalJoints[ReplacementWeld.Name] = ReplacementWeld.C0
            Object:Destroy()
        end
    end
end


function KeyframeEmulator:GetAnimationLength(Animation)
	local MaximumTime = 0
	for Time, _ in pairs(Animation) do
		if MaximumTime < Time then
			MaximumTime = Time
		end
	end
	return MaximumTime
end

function KeyframeEmulator:SerializeKeyframes(_Sequence)
    -- NOTE: FIGURED I'D LEAVE THIS IN, IN CASE SOMEONE WANTS TO USE THIS WITH ANIMATIONS THAT WEREN'T PRE-SERIALIZED
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

function KeyframeEmulator:LoadAnimation(Character, Animation)
    KeyframeEmulator:ReweldJoints(Character)
    local AnimationTweens = KeyframeEmulator:GenerateAnimationTweens(Character, Animation)
    local Event

    local RanAnimations = {}
    local LastTick = tick()
    local AnimationLength = KeyframeEmulator:GetAnimationLength(AnimationTweens)
    local AnimationTime = 0

    return {
        Play = function()
            if Event then return end
            LastTick = tick()
            Event = RS.Heartbeat:Connect(function()
                AnimationTime = AnimationTime + (tick() - LastTick)
                LastTick = tick()
                if AnimationTime > AnimationLength then
                    AnimationTime = 0
                    RanAnimations = {}
                end
                for Time, Tweens in pairs(AnimationTweens) do
                    if Time <= AnimationTime and not RanAnimations[Time] then
                        RanAnimations[Time] = true
                        for _, Pose in pairs(Tweens) do
                            Pose:Play()
                        end
                        break
                    end
                end
            end)
        end,
        Stop = function()
            if Event then
                Event:Disconnect()
                Event = nil
                AnimationTime = 0
                RanAnimations = {}
            end
        end
    }
end

return KeyframeEmulator
