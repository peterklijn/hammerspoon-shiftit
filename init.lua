--- === HammerspoonShiftIt ===
---
--- Manages windows and positions in MacOS with key binding from ShiftIt.
---
--- Download: https://github.com/peterklijn/hammerspoon-shiftit/raw/master/Spoons/ShiftIt.spoon.zip

local obj = {
  hs = hs
}
obj.__index = obj

-- Metadata
obj.name = "HammerspoonShiftIt"
obj.version = "1.0"
obj.author = "Peter Klijn"
obj.homepage = "https://github.com/peterklijn/hammerspoon-shiftit"
obj.license = "https://github.com/peterklijn/hammerspoon-shiftit/blob/master/LICENSE.md"

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
  left  = function(x, y) return { x = 0.00, y = 0.00, w = x / 100, h = 1.00 } end,
  right = function(x, y) return { x = 1 - (x / 100), y = 0.00, w = x / 100, h = 1.00 } end,
  top   = function(x, y) return { x = 0.00, y = 0.00, w = 1.00, h = y / 100 } end,
  bot   = function(x, y) return { x = 0.00, y = 1 - (y / 100), w = 1.00, h = y / 100 } end,

  upleft   = function(x, y) return { x = 0.00, y = 0.00, w = x / 100, h = y / 100 } end,
  upright  = function(x, y) return { x = 1 - (x / 100), y = 0.00, w = x / 100, h = y / 100 } end,
  botleft  = function(x, y) return { x = 0.00, y = 1 - (y / 100), w = x / 100, h = y / 100 } end,
  botright = function(x, y) return { x = 1 - (x / 100), y = 1 - (y / 100), w = x / 100, h = y / 100 } end,

  maximum = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 },
}

local relatedUnits = {}

local latestMove = {
  windowId = -1,
  direction = 'unknown',
  stepX = -1,
  stepY = -1,
}

function obj:move(unit) self.hs.window.focusedWindow():move(unit, nil, true, 0) end

function obj:moveToggle(unit)
  local windowId = self.hs.window.focusedWindow():id()
  local sameMoveAction = latestMove.windowId == windowId and latestMove.direction == unit
  if sameMoveAction then
    latestMove.stepX = obj.nextStepsX[latestMove.stepX]
    latestMove.stepY = obj.nextStepsY[latestMove.stepY]
  else
    latestMove.stepX = obj.moveStepsX[1]
    latestMove.stepY = obj.moveStepsY[1]
  end
  latestMove.windowId = windowId
  latestMove.direction = unit

  local before = self.hs.window.focusedWindow():frame()
  self:move(unit(latestMove.stepX, latestMove.stepY))

  if not sameMoveAction then
    -- if the window is not moved or resized, it was already at the required location
    -- if an alernative location is configured, move the window to that location
    local after = self.hs.window.focusedWindow():frame()
    if before == after then
      self:moveToggle(unit)
    end
  end
end

function obj:resizeWindowInSteps(increment)
  local screen = self.hs.window.focusedWindow():screen():frame()
  local window = self.hs.window.focusedWindow():frame()
  local wStep = math.floor(screen.w / 12)
  local hStep = math.floor(screen.h / 12)
  local x, y, w, h = window.x, window.y, window.w, window.h

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
  self:move({ x = x, y = y, w = w, h = h })
end

function obj:left() self:moveToggle(units.left) end

function obj:right() self:moveToggle(units.right) end

function obj:up() self:moveToggle(units.top) end

function obj:down() self:moveToggle(units.bot) end

function obj:upleft() self:moveToggle(units.upleft) end

function obj:upright() self:moveToggle(units.upright) end

function obj:botleft() self:moveToggle(units.botleft) end

function obj:botright() self:moveToggle(units.botright) end

function obj:maximum() self:move(units.maximum) end

function obj:toggleFullScreen() self.hs.window.focusedWindow():toggleFullScreen() end

function obj:toggleZoom() self.hs.window.focusedWindow():toggleZoom() end

function obj:center() self.hs.window.focusedWindow():centerOnScreen(nil, true, 0) end

function obj:nextScreen()
  self.hs.window.focusedWindow():moveToScreen(self.hs.window.focusedWindow():screen():next(), false, true, 0)
end

function obj:prevScreen()
  self.hs.window.focusedWindow():moveToScreen(self.hs.window.focusedWindow():screen():previous(), false, true, 0)
end

function obj:resizeOut() self:resizeWindowInSteps(true) end

function obj:resizeIn() self:resizeWindowInSteps(false) end

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

  self.hs.hotkey.bind(self.mapping.left[1], self.mapping.left[2], function() self:left() end)
  self.hs.hotkey.bind(self.mapping.right[1], self.mapping.right[2], function() self:right() end)
  self.hs.hotkey.bind(self.mapping.up[1], self.mapping.up[2], function() self:up() end)
  self.hs.hotkey.bind(self.mapping.down[1], self.mapping.down[2], function() self:down() end)
  self.hs.hotkey.bind(self.mapping.upleft[1], self.mapping.upleft[2], function() self:upleft() end)
  self.hs.hotkey.bind(self.mapping.upright[1], self.mapping.upright[2], function() self:upright() end)
  self.hs.hotkey.bind(self.mapping.botleft[1], self.mapping.botleft[2], function() self:botleft() end)
  self.hs.hotkey.bind(self.mapping.botright[1], self.mapping.botright[2], function() self:botright() end)
  self.hs.hotkey.bind(self.mapping.maximum[1], self.mapping.maximum[2], function() self:maximum() end)
  self.hs.hotkey.bind(self.mapping.toggleFullScreen[1], self.mapping.toggleFullScreen[2], function()
    self:toggleFullScreen()
  end)
  self.hs.hotkey.bind(self.mapping.toggleZoom[1], self.mapping.toggleZoom[2], function() self:toggleZoom() end)
  self.hs.hotkey.bind(self.mapping.center[1], self.mapping.center[2], function() self:center() end)
  self.hs.hotkey.bind(self.mapping.nextScreen[1], self.mapping.nextScreen[2], function() self:nextScreen() end)
  self.hs.hotkey.bind(self.mapping.previousScreen[1], self.mapping.previousScreen[2], function() self:prevScreen() end)
  self.hs.hotkey.bind(self.mapping.resizeOut[1], self.mapping.resizeOut[2], function() self:resizeOut() end)
  self.hs.hotkey.bind(self.mapping.resizeIn[1], self.mapping.resizeIn[2], function() self:resizeIn() end)

  return self
end

local function join(items, separator)
  local res = ''
  for _, item in pairs(items) do
    if res ~= '' then
      res = res .. separator
    end
    res = res .. item
  end
  return res
end

function obj:setSteps(stepsX, stepsY, skip_print)
  if #stepsX < 1 or #stepsY < 1 then
    print('Invalid arguments in setSteps, both dimensions should have at least 1 step')
    return
  end
  local function listToNextMap(list)
    local res = {}
    for i, item in ipairs(list) do
      local prev = (list[i - 1] == nil and list[#list] or list[i - 1])
      res[prev] = item
    end
    return res
  end

  self.moveStepsX = stepsX
  self.moveStepsY = stepsY
  self.nextStepsX = listToNextMap(stepsX)
  self.nextStepsY = listToNextMap(stepsY)

  if not skip_print then
    print('Steps for horizontal:', join(stepsX, ' -> '))
    print('Steps for vertical:', join(stepsY, ' -> '))
  end
end

-- Set default steps to 50%, as it's the ShiftIt default
obj:setSteps({ 50 }, { 50 }, true)

return obj
