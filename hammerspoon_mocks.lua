local lu = require('luaunit')

local hotkey = {
    bindings = {},
}

function hotkey.bind(mods, key, fn)
    lu.assertNotNil(mods)
    lu.assertNotNil(key)
    lu.assertIsFunction(fn)
    table.insert(hotkey.bindings, { mods, key, fn })
end

local screen = {
    rect = { x = 0, y = 0, w = 1200, h = 800 },
}

function screen:frame()
    return self.rect
end

local window = {
    rect = { x = 0, y = 0, w = 1200, h = 800 },
    _screen = screen,
}

function window.focusedWindow()
    return window
end

function window:frame()
    return self.rect
end

function window:screen()
    return self._screen
end

function window:move(rect, _, _, _)
    lu.assertIsNumber(rect.x)
    lu.assertIsNumber(rect.y)
    lu.assertIsNumber(rect.w)
    lu.assertIsNumber(rect.h)
    self.rect = rect
end

local mocks = {
    hotkey = hotkey,
    window = window,
}

function mocks:reset()
    self.hotkey.bindings = {}
end

return mocks
