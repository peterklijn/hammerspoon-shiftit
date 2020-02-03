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
    xu = math.max(screen.x, x - wStep)
    w = w + (x-xu)
    x=xu
    yu = math.max(screen.y, y - hStep)
    h = h + (y - yu)
    y = yu
    w = math.min(screen.w - x + screen.x, w + wStep)
    h = math.min(screen.h - y + screen.y, h + hStep)
  else
    noChange = true
    notMinWidth = w > wStep * 3
    notMinHeight = h > hStep * 3
    
    snapLeft = x <= screen.x
    snapTop = y <= screen.y
    -- add one pixel in case of odd number of pixels
    snapRight = (x + w + 1) >= (screen.x + screen.w)
    snapBottom = (y + h + 1) >= (screen.y + screen.h)

    b2n = { [true]=1, [false]=0 }
    totalSnaps = b2n[snapLeft] + b2n[snapRight] + b2n[snapTop] + b2n[snapBottom]

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
hs.hotkey.bind(mash, 'f', function() hs.window.focusedWindow():toggleFullScreen() end)
hs.hotkey.bind(mash, 'z', function() hs.window.focusedWindow():toggleZoom() end)
hs.hotkey.bind(mash, 'c', function() hs.window.focusedWindow():centerOnScreen(nil, true, 0) end)
hs.hotkey.bind(mash, 'n', function() hs.window.focusedWindow():moveToScreen(hs.window.focusedWindow():screen():next(),false, true, 0) end)

hs.hotkey.bind(mash, '=', function() resizeWindowInSteps(true)  end)
hs.hotkey.bind(mash, '-', function() resizeWindowInSteps(false)  end)
