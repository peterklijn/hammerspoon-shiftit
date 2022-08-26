local lu = require('luaunit')
local shiftit = require('init')
local hsmocks = require('hammerspoon_mocks')

-- disable lint errors for mutating global variable TestShiftIt:
-- luacheck: ignore 112

TestShiftIt = {} -- luacheck: ignore 111

function TestShiftIt.setUp()
    hsmocks:reset()
end

function TestShiftIt.testBindDefault()
    shiftit.hs = hsmocks
    shiftit:bindHotkeys({})
    lu.assertEquals(#hsmocks.hotkey.bindings, 16)

    local expected = {
        'left', 'right', 'up', 'down',
        '1', '2', '3', '4', 'm',
        'f', 'z', 'c', 'n', 'p',
        '=', '-',
    }
    for i, item in pairs(expected) do
        lu.assertEquals(hsmocks.hotkey.bindings[i][1], shiftit.mash)
        lu.assertEquals(hsmocks.hotkey.bindings[i][2], item)
    end
end

function TestShiftIt.testBindOverrideVimKeys()
    shiftit.hs = hsmocks
    shiftit:bindHotkeys({
        left = { { 'ctrl', 'alt', 'cmd' }, 'h' },
        down = { { 'ctrl', 'alt', 'cmd' }, 'j' },
        up = { { 'ctrl', 'alt', 'cmd' }, 'k' },
        right = { { 'ctrl', 'alt', 'cmd' }, 'l' },
    })
    lu.assertEquals(#hsmocks.hotkey.bindings, 16)

    local expected = {
        'h', 'l', 'k', 'j',
        '1', '2', '3', '4', 'm',
        'f', 'z', 'c', 'n', 'p',
        '=', '-',
    }
    for i, item in pairs(expected) do
        lu.assertEquals(hsmocks.hotkey.bindings[i][1], shiftit.mash)
        lu.assertEquals(hsmocks.hotkey.bindings[i][2], item)
    end
end

os.exit(lu.LuaUnit.run())
