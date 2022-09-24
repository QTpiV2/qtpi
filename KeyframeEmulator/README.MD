<h1 align="center">

QTpi KeyframeEmulator

</h1>

A library designed to emulate keyframe animations, in a scenario where you can't upload animations and CFrame-based animators just aren't cutting it.

**Note: There is a plugin available for this. Please scroll down to the 'Plugin' section for more details.**

## Notes (before we begin)
 - This, currently, will loop animations until you stop them.
 - Currently, R15 isn't supported. Feel free to send in a PR request to fix it, if you know how!
 - No, this doesn't support other Animation to Modulescript plugins. You must use the supplied one.
 - Yes, I will add minification to the modulified animations soon. Be patient.

## Documentation

#### Simple Methods

`KeyframeEmulator:LoadAnimation(Character, Animation)`<br>
Loads an animation on a character. Returns the following:
```lua
LoadedAnimation.Play()
LoadedAnimation.Stop()
```
It's obvious what all of this does.

#### Advanced Methods (not necessary)

`KeyframeEmulator:SerializeKeyframes(KeyframeSequence)`<br>
Converts a KeyframeSequence into a large string-table. Will be minified in the future.

`KeyframeEmulator:GetAnimationLength(Tweens)`<br>
Returns the length of the animation. Used for playback.

`KeyframeEmulator:ReweldJoints(Character)`<br>
Simply rewelds if possible.

`KeyframeEmulator:GenerateAnimationTweens(Character, AnimationTable)`<br>
Gives you tweens for animation playback.

## Plugin

In order to serialize KeyframeSequences, you must install a plugin.

### How do I install it?
1. Download the RBXM file of the plugin from [here](https://github.com/QTpiV2/qtpi/blob/main/KeyframeEmulator/plugin/plugin.rbxm?raw=true).
2. Open a Roblox Studio empty baseplate (or anywhere), and right click on "Workspace" in your Explorer Window.
3. Select "Insert from file..." and insert the RBXM file you just downloaded.
4. Right click on the newly inserted Script, and select "Save as local plugin..."
5. On the Windows prompt, simply press Save.
6. A new plugin should appear in the plugins bar. You can delete the Script that was inserted and close the file.

### How do I use it?
1. Find your KeyframeSequence, and select it in the "Explorer" window.
2. On the PLUGINS toolbar, find the "KeyframeEmulator" section, and click "Serialize".

**Note that ModuleScripts generated from KeyframeEmulator cannot be exchanged back into a KeyframeSequence, so store your animations appropriately.**

Because people are paranoid, and don't trust me with these kinds of things, the source for said plugin is directly available [here](https://github.com/QTpiV2/qtpi/blob/main/KeyframeEmulator/plugin/source.lua).
