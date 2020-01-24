units = {
  right50       = { x = 0.50, y = 0.00, w = 0.50, h = 1.00 },
  left50        = { x = 0.00, y = 0.00, w = 0.50, h = 1.00 },
  top50         = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
  bot50         = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
  
  upleft50      = { x = 0.00, y = 0.00, w = 0.50, h = 0.50 },
  upright50     = { x = 0.50, y = 0.00, w = 0.50, h = 0.50 },
  botleft50     = { x = 0.00, y = 0.50, w = 0.50, h = 0.50 },
  botright50    = { x = 0.50, y = 0.50, w = 0.50, h = 0.50 },
  
  maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 },
}

function resizeWindowInSteps(increment)
  screen = hs.window.focusedWindow():screen():frame()
  window = hs.window.focusedWindow():frame()
  wStep = math.floor(screen.w / 12)
  hStep = math.floor(screen.h / 12)
  x = window.x
  y = window.y
  w = window.w
  h = window.h
  if increment then
    x = math.max(screen.x, window.x - wStep)
    y = math.max(screen.y, window.y - hStep)
    w = math.min(screen.w - x + screen.x, window.w + wStep * 2)
    h = math.min(screen.h - y + screen.y, window.h + hStep * 2)
  else
    noChange = true
    notMinWidth = w > wStep * 3
    notMinHeight = h > hStep * 3
    if x > screen.x and notMinWidth then
      x = x + wStep
      w = w - wStep
      noChange = false
    end
    if y > screen.y and notMinHeight then
      y = y + hStep
      h = h - hStep
      noChange = false
    end
    -- add one pixel in case of odd number of pixels
    if (x + w + 1) < screen.w and notMinWidth then
      w = w - wStep
      noChange = false
    end
    -- add one pixel in case of odd number of pixels
    if (y + h + 1) < screen.h and notMinHeight then
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

mash = { 'ctrl', 'alt', 'cmd' }
hs.hotkey.bind(mash, 'left', function() hs.window.focusedWindow():move(units.left50, nil, true, 0) end)
hs.hotkey.bind(mash, 'right', function() hs.window.focusedWindow():move(units.right50, nil, true, 0) end)
hs.hotkey.bind(mash, 'up', function() hs.window.focusedWindow():move(units.top50, nil, true, 0) end)
hs.hotkey.bind(mash, 'down', function() hs.window.focusedWindow():move(units.bot50, nil, true, 0) end)

hs.hotkey.bind(mash, '1', function() hs.window.focusedWindow():move(units.upleft50, nil, true, 0) end)
hs.hotkey.bind(mash, '2', function() hs.window.focusedWindow():move(units.upright50, nil, true, 0) end)
hs.hotkey.bind(mash, '3', function() hs.window.focusedWindow():move(units.botleft50, nil, true, 0) end)
hs.hotkey.bind(mash, '4', function() hs.window.focusedWindow():move(units.botright50, nil, true, 0) end)

hs.hotkey.bind(mash, 'm', function() hs.window.focusedWindow():move(units.maximum, nil, true, 0) end)
hs.hotkey.bind(mash, 'c', function() hs.window.focusedWindow():centerOnScreen(nil, true, 0) end)
hs.hotkey.bind(mash, 'n', function() hs.window.focusedWindow():moveToScreen(hs.window.focusedWindow():screen():next(),false, true, 0) end)

hs.hotkey.bind(mash, '=', function() resizeWindowInSteps(true)  end)
hs.hotkey.bind(mash, '-', function() resizeWindowInSteps(false)  end)
