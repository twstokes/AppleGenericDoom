## What is this?

The goal of this project is to take [doomgeneric](https://github.com/ozkl/doomgeneric) and port it over to Apple devices. This was mostly a weekend hack and may not progress any further.

| macOS | Apple Watch |
| - | - |
| <img alt="Doom on macOS" src="https://github.com/twstokes/AppleGenericDoom/assets/2092798/b3e671bb-238d-4067-9666-a1beea965c1e"> | <img alt="Doom on Apple Watch" src="https://github.com/twstokes/AppleGenericDoom/assets/2092798/a31010e4-a992-4891-8333-1f56dff07c15"> |

- macOS has sound via SDL2
- watchOS currently does not have sound

### TODO:
- Add controls
- Watch sound? 
  - Add SDL frameworks (see macOS target)
  - Add compiler flag: `-DFEATURE_SOUND`
  - Add i_sdlsound and i_sdlmusic to Watch target
- Use bundled asset WAD on macOS
- Get MIDIs going



### Loading WAD files

Until this has been figured out, drop a WAD file in ~/Library/Containers/com.tannr.AppleGenericDoom/Data and it'll automatically be detected (e.g. doom1.wad) on macOS. On watchOS it will look for the bundled asset.
