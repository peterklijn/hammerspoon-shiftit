local lu = require('luaunit')

local hotkey = {
    bindings = {},
}

local defaultScreenRect = { x = 0, y = 0, w = 1200, h = 800 }
local defaultWindowRect = { x = 100, y = 100, w = 1000, h = 600 }

function hotkey.bind(mods, key, fn)
    lu.assertNotNil(mods)
    lu.assertNotNil(key)
    lu.assertIsFunction(fn)
    table.insert(hotkey.bindings, { mods, key, fn })
end

local screen = {
    rect = defaultScreenRect,
}

function screen:frame()
    return self.rect
end

local window = {
    rect = defaultWindowRect,
    _id = 42,
    _screen = screen,
}

function window.focusedWindow()
    return window
end

function window:frame()
    return self.rect
end

function window:id()
    return self._id
end

function window:screen()
    return self._screen
end

function window:move(rect, _, _, _)
    lu.assertIsNumber(rect.x)
    lu.assertIsNumber(rect.y)
    lu.assertIsNumber(rect.w)
    lu.assertIsNumber(rect.h)
    -- If the position contains a period (.), it is a relative coordinate
    -- so multiple it with the screen size
    if string.match(tostring(rect.x), '%.') ~= nil then
        rect = {
            x = self._screen.rect.x + (rect.x * self._screen.rect.w),
            y = self._screen.rect.y + (rect.y * self._screen.rect.h),
            w = rect.w * self._screen.rect.w,
            h = rect.h * self._screen.rect.h,
        }
    end
    self.rect = rect
end

local mocks = {
    hotkey = hotkey,
    window = window,
}

function mocks:reset()
    self.hotkey.bindings = {}
    self.window.rect = defaultWindowRect
    self.window._id = 42
    self.window._screen.rect = defaultScreenRect
end

return mocks
