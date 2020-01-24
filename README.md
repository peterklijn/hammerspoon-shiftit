# Hammerspoon-ShiftIt

A [ShiftIt](https://github.com/fikovnik/ShiftIt) like [Hammerspoon](http://www.hammerspoon.org) window management configuration.

## Installation

**Step 1**

Verify that you have no current Hammerspoon configuration by going to `~/.hammerspoon` and look for an `init.lua` file. 
If you have an `init.lua` config file, remove (or more) it.

**Step 2**

Make a Symbolic link from the `init.lua` in this repo to the Hammerspoon directory:

```
ln -s ~/your/path/to/hammerspoon-shiftit/init.lua ~/.hammerspoon/init.lua
```

**Step 3**

Reload the Hammerspoon configuration by clicking on the Hammerspoon icon in the menu bar and selecting 'Reload Config'.

## Usage

- `ctrl + alt + cmd + left` Snap current window to the left half to the screen
- `ctrl + alt + cmd + right` Snap current window to the right half to the screen
- `ctrl + alt + cmd + up` Snap current window to the top half to the screen
- `ctrl + alt + cmd + down` Snap current window to the bottom half to the screen


- `ctrl + alt + cmd + 1` Snap current window to the left top quarter to the screen
- `ctrl + alt + cmd + 2` Snap current window to the right top quarter to the screen
- `ctrl + alt + cmd + 3` Snap current window to the left bottom quarter to the screen
- `ctrl + alt + cmd + 4` Snap current window to the right bottom quarter to the screen


- `ctrl + alt + cmd + M` Maximise current window
- `ctrl + alt + cmd + F` Toggle full screen for current window
- `ctrl + alt + cmd + Z` Toggle zoom for current window
- `ctrl + alt + cmd + C` Centralize current window
- `ctrl + alt + cmd + N` Move current window to next screen


- `ctrl + alt + cmd + -` Make current window smaller
- `ctrl + alt + cmd + =` Make current window bigger
