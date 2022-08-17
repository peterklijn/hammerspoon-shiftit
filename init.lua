--- === HammerspoonShiftIt ===
---
--- Manages windows and positions in MacOS with key binding from ShiftIt.
---
--- Download: [https://github.com/peterklijn/hammerspoon-shiftit/raw/master/Spoons/HammerspoonShiftIt.spoon.zip](https://github.com/peterklijn/hammerspoon-shiftit/raw/master/Spoons/HammerspoonShiftIt.spoon.zip)

local obj = {}
obj.__index = obj

-- Metadata
obj.name = "HammerspoonShiftIt"
obj.version = "1.0"
obj.author = "Peter Klijn"
obj.homepage = "https://github.com/peterklijn/hammerspoon-shiftit"
obj.license = ""

obj.mash = { 'ctrl', 'alt', 'cmd' }
obj.mapping = {
  left = { obj.mash, 'left' },
  right = { obj.mash, 'right' },
  up = { obj.mash, 'up' },
  down = { obj.mash, 'down' },
  upleft = { obj.mash, '1' },
  upright = { obj.mash, '2' },
  botleft = { obj.mash, '3' },
  botright = { obj.mash, '4' },
  maximum = { obj.mash, 'm' },
  toggleFullScreen = { obj.mash, 'f' },
  toggleZoom = { obj.mash, 'z' },
  center = { obj.mash, 'c' },
  nextScreen = { obj.mash, 'n' },
  previousScreen = { obj.mash, 'p' },
  resizeOut = { obj.mash, '=' },
  resizeIn = { obj.mash, '-' },
}

local units = {
  right50       = { x = 0.50, y = 0.00, w = 0.50, h = 1.00 },
  left50        = { x = 0.00, y = 0.00, w = 0.50, h = 1.00 },
  top50         = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
  bot50         = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
  
  right33       = { x = 0.67, y = 0.00, w = 0.33, h = 1.00 },
  left33        = { x = 0.00, y = 0.00, w = 0.33, h = 1.00 },

  upleft50      = { x = 0.00, y = 0.00, w = 0.50, h = 0.50 },
  upright50     = { x = 0.50, y = 0.00, w = 0.50, h = 0.50 },
  botleft50     = { x = 0.00, y = 0.50, w = 0.50, h = 0.50 },
  botright50    = { x = 0.50, y = 0.50, w = 0.50, h = 0.50 },

  upleft33      = { x = 0.00, y = 0.00, w = 0.33, h = 0.50 },
  upright33     = { x = 0.67, y = 0.00, w = 0.33, h = 0.50 },
  botleft33     = { x = 0.00, y = 0.50, w = 0.33, h = 0.50 },
  botright33    = { x = 0.67, y = 0.50, w = 0.33, h = 0.50 },

  maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 },
}

local relatedUnits = {}

function move(unit) hs.window.focusedWindow():move(unit, nil, true, 0) end

function moveToggle(unit)
  -- Fetch alternative unit, if any
  newUnit = relatedUnits[unit]

  before = hs.window.focusedWindow():frame()
  move(unit)
  after = hs.window.focusedWindow():frame()

  -- if the window is not moved or resized, it was already at the required location
  -- if an alernative location is configured, move the window to that location
  if before == after and newUnit then
    move(newUnit)
  end
end

local function resizeWindowInSteps(increment)
  local screen = hs.window.focusedWindow():screen():frame()
  local window = hs.window.focusedWindow():frame()
  local wStep = math.floor(screen.w / 12)
  local hStep = math.floor(screen.h / 12)
  local x = window.x
  local y = window.y
  local w = window.w
  local h = window.h
  if increment then
    local xu = math.max(screen.x, x - wStep)
    w = w + (x - xu)
    x = xu
    local yu = math.max(screen.y, y - hStep)
    h = h + (y - yu)
    y = yu
    w = math.min(screen.w - x + screen.x, w + wStep)
    h = math.min(screen.h - y + screen.y, h + hStep)
  else
    local noChange = true
    local notMinWidth = w > wStep * 3
    local notMinHeight = h > hStep * 3

    local snapLeft = x <= screen.x
    local snapTop = y <= screen.y
    -- add one pixel in case of odd number of pixels
    local snapRight = (x + w + 1) >= (screen.x + screen.w)
    local snapBottom = (y + h + 1) >= (screen.y + screen.h)

    local b2n = { [true] = 1, [false] = 0 }
    local totalSnaps = b2n[snapLeft] + b2n[snapRight] + b2n[snapTop] + b2n[snapBottom]

    if notMinWidth and (totalSnaps <= 1 or not snapLeft) then
      x = x + wStep
      w = w - wStep
      noChange = false
    end
    if notMinHeight and (totalSnaps <= 1 or not snapTop) then
      y = y + hStep
      h = h - hStep
      noChange = false
    end
    if notMinWidth and (totalSnaps <= 1 or not snapRight) then
      w = w - wStep
      noChange = false
    end
    if notMinHeight and (totalSnaps <= 1 or not snapBottom) then
      h = h - hStep
      noChange = false
    end
    if noChange then
      x = notMinWidth and x + wStep or x
      y = notMinHeight and y + hStep or y
      w = notMinWidth and w - wStep * 2 or w
      h = notMinHeight and h - hStep * 2 or h
    end
  end
  hs.window.focusedWindow():move({x=x, y=y, w=w, h=h}, nil, true, 0)
end

function obj:left() moveToggle(units.left50, nil, true, 0) end
function obj:right() moveToggle(units.right50, nil, true, 0) end
function obj:up() moveToggle(units.top50, nil, true, 0) end
function obj:down() moveToggle(units.bot50, nil, true, 0) end
function obj:upleft() moveToggle(units.upleft50, nil, true, 0) end
function obj:upright() moveToggle(units.upright50, nil, true, 0) end
function obj:botleft() moveToggle(units.botleft50, nil, true, 0) end
function obj:botright() moveToggle(units.botright50, nil, true, 0) end

function obj:maximum() move(units.maximum, nil, true, 0) end

function obj:toggleFullScreen() hs.window.focusedWindow():toggleFullScreen() end
function obj:toggleZoom() hs.window.focusedWindow():toggleZoom() end
function obj:center() hs.window.focusedWindow():centerOnScreen(nil, true, 0) end
function obj:nextScreen() hs.window.focusedWindow():moveToScreen(hs.window.focusedWindow():screen():next(), false, true, 0) end
function obj:previousScreen() hs.window.focusedWindow():moveToScreen(hs.window.focusedWindow():screen():previous(), false, true, 0) end

function obj:resizeOut() resizeWindowInSteps(true) end
function obj:resizeIn() resizeWindowInSteps(false) end

--- HammerspoonShiftIt:bindHotkeys(mapping)
--- Method
--- Binds hotkeys for HammerspoonShiftIt
---
--- Parameters:
---  * mapping - A table containing hotkey modifier/key details (everything is optional) for the following items:
---   * left
---   * right
---   * up
---   * down
---   * upleft
---   * upright
---   * botleft
---   * botright
---   * maximum
---   * toggleFullScreen
---   * toggleZoom
---   * center
---   * nextScreen
---   * previousScreen
---   * resizeOut
---   * resizeIn
function obj:bindHotkeys(mapping)

  if (mapping) then
    for k, v in pairs(mapping) do self.mapping[k] = v end
  end

  hs.hotkey.bind(self.mapping.left[1], self.mapping.left[2], function() self:left() end)
  hs.hotkey.bind(self.mapping.right[1], self.mapping.right[2], function() self:right() end)
  hs.hotkey.bind(self.mapping.up[1], self.mapping.up[2], function() self:up() end)
  hs.hotkey.bind(self.mapping.down[1], self.mapping.down[2], function() self:down() end)
  hs.hotkey.bind(self.mapping.upleft[1], self.mapping.upleft[2], function() self:upleft() end)
  hs.hotkey.bind(self.mapping.upright[1], self.mapping.upright[2], function() self:upright() end)
  hs.hotkey.bind(self.mapping.botleft[1], self.mapping.botleft[2], function() self:botleft() end)
  hs.hotkey.bind(self.mapping.botright[1], self.mapping.botright[2], function() self:botright() end)
  hs.hotkey.bind(self.mapping.maximum[1], self.mapping.maximum[2], function() self:maximum() end)
  hs.hotkey.bind(self.mapping.toggleFullScreen[1], self.mapping.toggleFullScreen[2], function() self:toggleFullScreen() end)
  hs.hotkey.bind(self.mapping.toggleZoom[1], self.mapping.toggleZoom[2], function() self:toggleZoom() end)
  hs.hotkey.bind(self.mapping.center[1], self.mapping.center[2], function() self:center() end)
  hs.hotkey.bind(self.mapping.nextScreen[1], self.mapping.nextScreen[2], function() self:nextScreen() end)
  hs.hotkey.bind(self.mapping.previousScreen[1], self.mapping.previousScreen[2], function() self:previousScreen() end)
  hs.hotkey.bind(self.mapping.resizeOut[1], self.mapping.resizeOut[2], function() self:resizeOut() end)
  hs.hotkey.bind(self.mapping.resizeIn[1], self.mapping.resizeIn[2], function() self:resizeIn() end)

  return self
end

function obj:enableThreeColumnGrid()
  print(units)
  relatedUnits = {
    [units.left50] = units.left33,
    [units.right50] = units.right33,
    [units.upleft50] = units.upleft33,
    [units.upright50] = units.upright33,
    [units.botleft50] = units.botleft33,
    [units.botright50] = units.botright33,
  }
end

return obj
