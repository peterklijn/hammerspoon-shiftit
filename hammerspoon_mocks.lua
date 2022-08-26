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

local mocks = {
    hotkey = hotkey
}

function mocks:reset()
    self.hotkey.bindings = {}
end

return mocks
