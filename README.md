## What is this?

The goal of this project is to take [doomgeneric](https://github.com/ozkl/doomgeneric) and port it over to Apple devices. This was mostly a weekend hack and may not progress any further.

| macOS | Apple Watch |
| - | - |
| <img alt="DOOM on macOS" src="https://github.com/twstokes/AppleGenericDoom/assets/2092798/40b54b8c-ac1b-49a7-bbc7-c0674d4b82fe"> | <img alt="DOOM on watchOS" src="https://github.com/twstokes/AppleGenericDoom/assets/2092798/cf3ae161-735a-422a-9ad8-1fd11f6f83f6"> |




- macOS has sound via SDL2
- watchOS currently does not have sound

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
- Watch sound? - Probably not going to happen via SDL due to missing support from frameworks like [Audio Toolbox](https://developer.apple.com/documentation/audiotoolbox/)
  - Add SDL frameworks (see macOS target)
  - Add compiler flag: `-DFEATURE_SOUND`
  - Add i_sdlsound and i_sdlmusic to Watch target
- Get MIDIs going

