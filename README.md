# HammerspoonShiftIt

A [ShiftIt](https://github.com/fikovnik/ShiftIt) like [Hammerspoon](http://www.hammerspoon.org) window management configuration.

## Installation

**Step 0**

Install Hammerspoon if you haven't yet. One of the ways to do it:
```bash
brew cask install hammerspoon 
```

**Step 1**

Verify that you already have a Hammerspoon configuration by going to `~/.hammerspoon` and look for an `init.lua` file. If it doesn't exist, create it.

**Step 2**

If you use [SpoonInstall](https://www.hammerspoon.org/Spoons/SpoonInstall.html):
 - Load a spoon as following using the repository [https://github.com/peterkljin/hammerspoon-shiftit](https://github.com/peterkljin/hammerspoon-shiftit):
 - Add this config to your `~/.hammerspoon/init.lua`
 ```lua
SpoonInstall:andUse("HammerspoonShiftit", {
    hotkeys = { 
        ...
    }
})
```

Or alternatively use a classic way:
 - Download and install [https://github.com/peterkljin/hammerspoon-shiftit/raw/master/Spoons/HammerspoonShiftit.spoon.zip](https://github.com/peterklijn/hammerspoon-shiftit/raw/master/Spoons/HammerspoonShiftit.spoon.zip)
 - Add the following configuration to your `~/.hammerspoon/init.lua`

```lua
hs.loadSpoon("HammerspoonShiftit")
spoon.HammerspoonShiftit:bindHotkeys({
     ...
});
```

**Step 3**

Reload the Hammerspoon configuration by clicking on the Hammerspoon icon in the menu bar and selecting 'Reload Config'.

## Configuration

The default key mapping looks like 
```lua
{
  left = {{ 'ctrl', 'alt', 'cmd' }, 'left' },
  right = {{ 'ctrl', 'alt', 'cmd' }, 'right' },
  up = {{ 'ctrl', 'alt', 'cmd' }, 'up' },
  down = {{ 'ctrl', 'alt', 'cmd' }, 'down' },
  upleft = {{ 'ctrl', 'alt', 'cmd' }, '1' },
  upright = {{ 'ctrl', 'alt', 'cmd' }, '2' },
  botleft = {{ 'ctrl', 'alt', 'cmd' }, '3' },
  botright = {{ 'ctrl', 'alt', 'cmd' }, '4' },
  maximum = {{ 'ctrl', 'alt', 'cmd' }, 'm' },
  toggleFullScreen = {{ 'ctrl', 'alt', 'cmd' }, 'f' },
  toggleZoom = {{ 'ctrl', 'alt', 'cmd' }, 'z' },
  center = {{ 'ctrl', 'alt', 'cmd' }, 'c' },
  nextScreen = {{ 'ctrl', 'alt', 'cmd' }, 'n' },
  resizeOut = {{ 'ctrl', 'alt', 'cmd' }, '=' },
  resizeIn = {{ 'ctrl', 'alt', 'cmd' }, '-' }
}

```

You can pass any part of overrides of this configuration to `bindHotkeys()` function.
E.g. 
```lua
spoon.HammerspoonShiftit:bindHotkeys({
  upleft = {{ 'ctrl', 'alt', 'cmd' }, 'q' },
  upright = {{ 'ctrl', 'alt', 'cmd' }, 'w' },
});
```
or
```lua
spoon.HammerspoonShiftit:bindHotkeys({});
```
or
```lua
spoon.HammerspoonShiftit:bindHotkeys(nil);
```

## Usage (default keys)

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
