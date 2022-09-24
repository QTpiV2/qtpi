--[[

KeyframeEmulator Sample (No HTTP Requests)

--]]

local SerializedAnimation = require(script.Animation) -- This would be the modulescript generated from the plugin.

local KeyframeEmulator = require(script.KeyframeEmulator)
local Animation = KeyframeEmulator:LoadAnimation(script.Parent, Serialized)

Animation.Play() -- Play the animation.
