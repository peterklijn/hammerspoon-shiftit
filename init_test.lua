local lu = require('luaunit')
local shiftit = require('init')
local hsmocks = require('hammerspoon_mocks')

-- disable lint errors for mutating global variable TestShiftIt:
-- luacheck: ignore 112

TestShiftIt = {} -- luacheck: ignore 111

function TestShiftIt.setUp()
    shiftit.hs = hsmocks
    hsmocks:reset()
end

function TestShiftIt.testBindDefault()
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

function TestShiftIt.testResizeWindowInStepsStickingToSides()
    local tests = {
        {
            desc = 'increase window sticking to left',
            before = { x = 0, y = 0, w = 600, h = 800 },
            expect = { x = 0, y = 0, w = 700, h = 800 },
            increase = true,
        },
        {
            desc = 'decrease window sticking to left',
            before = { x = 0, y = 0, w = 600, h = 800 },
            expect = { x = 0, y = 0, w = 500, h = 800 },
            increase = false,
        },
        {
            desc = 'increase window sticking to right',
            before = { x = 600, y = 0, w = 600, h = 800 },
            expect = { x = 500, y = 0, w = 700, h = 800 },
            increase = true,
        },
        {
            desc = 'decrease window sticking to right',
            before = { x = 600, y = 0, w = 600, h = 800 },
            expect = { x = 700, y = 0, w = 500, h = 800 },
            increase = false,
        },
        {
            desc = 'increase window sticking to top',
            before = { x = 0, y = 0, w = 1200, h = 400 },
            expect = { x = 0, y = 0, w = 1200, h = 466 },
            increase = true,
        },
        {
            desc = 'decrease window sticking to top',
            before = { x = 0, y = 0, w = 1200, h = 400 },
            expect = { x = 0, y = 0, w = 1200, h = 334 },
            increase = false,
        },
        {
            desc = 'increase window sticking to bottom',
            before = { x = 0, y = 400, w = 1200, h = 400 },
            expect = { x = 0, y = 334, w = 1200, h = 466 },
            increase = true,
        },
        {
            desc = 'decrease window sticking to bottom',
            before = { x = 0, y = 400, w = 1200, h = 400 },
            expect = { x = 0, y = 466, w = 1200, h = 334 },
            increase = false,
        },
    }
    for _, test in pairs(tests) do
        hsmocks.window.rect = test.before
        shiftit:resizeWindowInSteps(test.increase)
        lu.assertEquals(hsmocks.window.rect, test.expect, test.desc)
    end
end

function TestShiftIt.testResizeWindowInStepsStickingToCorners()
    local tests = {
        {
            desc = 'increase window sticking to left top',
            before = { x = 0, y = 0, w = 600, h = 400 },
            expect = { x = 0, y = 0, w = 700, h = 466 },
            increase = true,
        },
        {
            desc = 'decrease window sticking to left top',
            before = { x = 0, y = 0, w = 600, h = 400 },
            expect = { x = 0, y = 0, w = 500, h = 334 },
            increase = false,
        },
        {
            desc = 'increase window sticking to right top',
            before = { x = 600, y = 0, w = 600, h = 400 },
            expect = { x = 500, y = 0, w = 700, h = 466 },
            increase = true,
        },
        {
            desc = 'decrease window sticking to right top',
            before = { x = 600, y = 0, w = 600, h = 400 },
            expect = { x = 700, y = 0, w = 500, h = 334 },
            increase = false,
        },
        {
            desc = 'increase window sticking to left bottom',
            before = { x = 0, y = 400, w = 600, h = 400 },
            expect = { x = 0, y = 334, w = 700, h = 466 },
            increase = true,
        },
        {
            desc = 'decrease window sticking to left bottom',
            before = { x = 0, y = 400, w = 600, h = 400 },
            expect = { x = 0, y = 466, w = 500, h = 334 },
            increase = false,
        },
        {
            desc = 'increase window sticking to right bottom',
            before = { x = 0, y = 400, w = 600, h = 400 },
            expect = { x = 0, y = 334, w = 700, h = 466 },
            increase = true,
        },
        {
            desc = 'decrease window sticking to right bottom',
            before = { x = 600, y = 400, w = 600, h = 400 },
            expect = { x = 700, y = 466, w = 500, h = 334 },
            increase = false,
        },
    }
    for _, test in pairs(tests) do
        hsmocks.window.rect = test.before
        shiftit:resizeWindowInSteps(test.increase)
        lu.assertEquals(hsmocks.window.rect, test.expect, test.desc)
    end
end

os.exit(lu.LuaUnit.run())
