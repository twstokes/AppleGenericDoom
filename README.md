## What is this?

The goal of this project is to take [doomgeneric](https://github.com/ozkl/doomgeneric) and port it over to Apple devices.

### TODO:
- implement the functions identified [here](https://github.com/ozkl/doomgeneric#porting)
- interface nicely to Swift so we don't have to do as much in C
- consider bringing in doomgeneric as a Git submodule and only adding the files we need to compile


### Loading WAD files

Until this has been figured out, drop a WAD file in ~/Library/Containers/com.tannr.AppleGenericDoom/Data and it'll automatically be detected (e.g. doom1.wad).
