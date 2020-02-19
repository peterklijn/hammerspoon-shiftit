# Hammerspoon ShiftIt

A [ShiftIt](https://github.com/fikovnik/ShiftIt) like [Hammerspoon](http://www.hammerspoon.org) window management configuration.

![Hammerspoon ShiftIt demo video](https://github.com/peterklijn/hammerspoon-shiftit/blob/master/images/shiftit-demo.gif?raw=true)

## Installation

**Step 1**

Install Hammerspoon if you haven't yet. Download the [latest release here](https://github.com/Hammerspoon/hammerspoon/releases/latest) and drag it to `/Applications`.

Alternatively you can install it using brew:
```bash
brew cask install hammerspoon 
```

**Step 2**

Make sure Hammerspoon is started (You should see the a Hammerspoon logo in your menubar).

Download the [ShiftIt spoon](https://github.com/peterklijn/hammerspoon-shiftit/raw/master/Spoons/ShiftIt.spoon.zip). Unzip it and open the spoon.

Hammerspoon should prompt that the newly installed spoon is now available.

*Alternatively you can use [SpoonInstall](#spooninstall)*

**Step 3**

Click on the Hammerspoon menubar icon and click on 'Open Config'. An `init.lua` file should now open in your editor of choice.

Paste the following configuration in the `init.lua` file, save it and close it.

```lua
hs.loadSpoon("ShiftIt")
spoon.ShiftIt:bindHotkeys({})
```

Click on the Hammerspoon menubar icon again, and click on 'Reload Config'.

The ShiftIt spoon is now ready to use, enjoy.

## Usage (default keys)

- `ctrl + alt + cmd + left` Snap current window to the left half to the screen
- `ctrl + alt + cmd + right` Snap current window to the right half to the screen
- `ctrl + alt + cmd + up` Snap current window to the top half to the screen
- `ctrl + alt + cmd + down` Snap current window to the bottom half to the screen

![Hammerspoon ShiftIt snap sides demo](https://github.com/peterklijn/hammerspoon-shiftit/blob/master/images/shiftit-demo-snap-sides.gif?raw=true)

- `ctrl + alt + cmd + 1` Snap current window to the left top quarter to the screen
- `ctrl + alt + cmd + 2` Snap current window to the right top quarter to the screen
- `ctrl + alt + cmd + 3` Snap current window to the left bottom quarter to the screen
- `ctrl + alt + cmd + 4` Snap current window to the right bottom quarter to the screen

![Hammerspoon ShiftIt snap corners demo](https://github.com/peterklijn/hammerspoon-shiftit/blob/master/images/shiftit-demo-snap-corners.gif?raw=true)

- `ctrl + alt + cmd + M` Maximise current window
- `ctrl + alt + cmd + C` Centralize current window
- `ctrl + alt + cmd + -` Make current window smaller
- `ctrl + alt + cmd + =` Make current window bigger

![Hammerspoon ShiftIt increase decrease demo](https://github.com/peterklijn/hammerspoon-shiftit/blob/master/images/shiftit-demo-increase-decrease.gif?raw=true)

- `ctrl + alt + cmd + F` Toggle full screen for current window
- `ctrl + alt + cmd + Z` Toggle zoom for current window

- `ctrl + alt + cmd + N` Move current window to next screen



## Configuration

The default key mapping looks like this:

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

### Overriding key mappings

You can pass the part of the key mappings that you want to override to the `bindHotkeys()` function. For example:

```lua
spoon.ShiftIt:bindHotkeys({
  upleft = {{ 'ctrl', 'alt', 'cmd' }, 'q' },
  upright = {{ 'ctrl', 'alt', 'cmd' }, 'w' },
});
```

## Alternative installations

### SpoonInstall

If you use [SpoonInstall](https://www.hammerspoon.org/Spoons/SpoonInstall.html):

- Load the spoon as following using the repository `https://github.com/peterklijn/hammerspoon-shiftit`.
- Add this config to your `~/.hammerspoon/init.lua`
 ```lua
SpoonInstall:andUse("ShiftIt", {})
```
