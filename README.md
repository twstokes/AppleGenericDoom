## What is this?

The goal of this project is to take [doomgeneric](https://github.com/ozkl/doomgeneric) and port it over to Apple devices.

### TODO:
- Watch sound? 
-- Add SDL frameworks (see macOS target)
-- Add compiler flag: `-DFEATURE_SOUND`
-- Add i_sdlsound and i_sdlmusic to Watch target
- Use bundled asset WAD on macOS



### Loading WAD files

Until this has been figured out, drop a WAD file in ~/Library/Containers/com.tannr.AppleGenericDoom/Data and it'll automatically be detected (e.g. doom1.wad) on macOS. On WatchOS it will look for the bundled asset.
