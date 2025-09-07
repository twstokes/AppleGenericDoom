## What is this?

The goal of this project is to take [doomgeneric](https://github.com/ozkl/doomgeneric) and port it over to Apple devices. This was mostly a weekend hack and may not progress any further.

| macOS | Apple Watch |
| - | - |
| <img alt="DOOM on macOS" src="https://github.com/twstokes/AppleGenericDoom/assets/2092798/40b54b8c-ac1b-49a7-bbc7-c0674d4b82fe"> | <img alt="DOOM on watchOS" src="https://github.com/twstokes/AppleGenericDoom/assets/2092798/cf3ae161-735a-422a-9ad8-1fd11f6f83f6"> |




- macOS has sound via SDL2
- watchOS: experimental SFX sound scaffolding (AVFoundation). Music is disabled for now.

## Controls

The Watch app has touch controls.

The full screen is divided into a 3x3 grid:

```
left  |  up  |  right 
----------------------
left  |  up  |  right
----------------------
action | down | fire
----------------------
```

**Action** changes based on game state: ENTER (Menu) or USE (In-Game)

**Fire** also changes based on game state: ESCAPE (Menu) or FIRE (In-Game)

Controls can be adjusted in `TouchToKeyManager.swift`. 

## TODO:
- Add macOS controls
- Watch sound
  - AVFoundation-based SFX backend is scaffolded for watchOS (no music yet)
  - Music will require a softsynth or pre-rendered tracks
- Get MIDIs going
