--[[

KeyframeEmulator Sample

Additional Notes:
 [1]: You don't have to load this from a URL. You can plug the module directly, but if you do, make sure to either wrap it in a function or remove the "return" statement at the beginning.

--]]

local Success, SerializedAnimation = pcall(function()
      return game:GetService('HttpService'):GetAsync('https://raw.githubusercontent.com/QTpiV2/qtpi/main/KeyframeEmulator/anim_sample/walk.lua') -- Check NOTES 1
end)
if not Success then print('Failed to download animation') end
SerializedAnimation = loadstring(SerializedAnimation)()

local Success, KeyframeEmulator = pcall(function()
      return game:GetService('HttpService'):GetAsync('https://raw.githubusercontent.com/QTpiV2/qtpi/main/KeyframeEmulator/module.lua')
end)
if not Success then print('Failed to download emulator') end
KeyframeEmulator = loadstring(KeyframeEmulator)()
local Animation = KeyframeEmulator:LoadAnimation(owner.Character, SerializedAnimation)

Animation.Play() -- Play the animation.
