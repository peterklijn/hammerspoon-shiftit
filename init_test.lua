local lu = require('luaunit')
local shiftit = require('init')
local hsmocks = require('hammerspoon_mocks')

-- disable lint errors for mutating global variable TestShiftIt:
-- luacheck: ignore 112

TestShiftIt = {} -- luacheck: ignore 111
shiftit.hs = hsmocks

function TestShiftIt.setUp()
    hsmocks:reset()
    shiftit:setSteps({ 50 }, { 50 }, true)
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

function TestShiftIt.testResizeWindowInStepsEdgeCases()
    local tests = {
        {
            desc = 'does not exceed screen width',
            before = { x = 5, y = 200, w = 1190, h = 400 },
            expect = { x = 0, y = 134, w = 1200, h = 532 },
            increase = true,
        },
        {
            desc = 'does not exceed screen height',
            before = { x = 200, y = 5, w = 800, h = 790 },
            expect = { x = 100, y = 0, w = 1000, h = 800 },
            increase = true,
        },
        {
            desc = 'does not exceed screen size',
            before = { x = 5, y = 5, w = 1190, h = 790 },
            expect = { x = 0, y = 0, w = 1200, h = 800 },
            increase = true,
        },
        {
            desc = 'does not become too narrow',
            before = { x = 0, y = 0, w = 300, h = 800 },
            expect = { x = 0, y = 66, w = 300, h = 668 },
            increase = false,
        },
        {
            desc = 'does not become too short',
            before = { x = 0, y = 0, w = 1200, h = 198 },
            expect = { x = 100, y = 0, w = 1000, h = 198 },
            increase = false,
        },
        {
            desc = 'does not become too tiny',
            before = { x = 100, y = 100, w = 300, h = 198 },
            expect = { x = 100, y = 100, w = 300, h = 198 },
            increase = false,
        },
    }
    for _, test in pairs(tests) do
        hsmocks.window.rect = test.before
        shiftit:resizeWindowInSteps(test.increase)
        lu.assertEquals(hsmocks.window.rect, test.expect, test.desc)
    end
end

function TestShiftIt.testInitialiseSteps()
    lu.assertEquals(shiftit.moveStepsX, { 50 })
    lu.assertEquals(shiftit.moveStepsY, { 50 })
    lu.assertEquals(shiftit.nextStepsX, { [50] = 50 })
    lu.assertEquals(shiftit.nextStepsY, { [50] = 50 })

    shiftit:setSteps({ 80, 60, 40 }, { 75, 50, 25 }, true)
    lu.assertEquals(shiftit.moveStepsX, { 80, 60, 40 })
    lu.assertEquals(shiftit.moveStepsY, { 75, 50, 25 })
    lu.assertEquals(shiftit.nextStepsX, { [40] = 80, [60] = 40, [80] = 60 })
    lu.assertEquals(shiftit.nextStepsY, { [25] = 75, [50] = 25, [75] =50 })
end

function TestShiftIt.testDefaultWindowShifts()
    local tests = {
        {
            desc = 'shift to the left',
            action = function () shiftit:left() end,
            expect = { x = 0, y = 0, w = 600, h = 800 },
        },
        {
            desc = 'shift to the right',
            action = function() shiftit:right() end,
            expect = { x = 600, y = 0, w = 600, h = 800 },
        },
        {
            desc = 'shift to the top',
            action = function() shiftit:up() end,
            expect = { x = 0, y = 0, w = 1200, h = 400 },
        },
        {
            desc = 'shift to the bottom',
            action = function() shiftit:down() end,
            expect = { x = 0, y = 400, w = 1200, h = 400 },
        },
        {
            desc = 'shift to the left top',
            action = function() shiftit:upleft() end,
            expect = { x = 0, y = 0, w = 600, h = 400 },
        },
        {
            desc = 'shift to the right top',
            action = function() shiftit:upright() end,
            expect = { x = 600, y = 0, w = 600, h = 400 },
        },
        {
            desc = 'shift to the left bottom',
            action = function() shiftit:botleft() end,
            expect = { x = 0, y = 400, w = 600, h = 400 },
        },
        {
            desc = 'shift to the right bottom',
            action = function() shiftit:botright() end,
            expect = { x = 600, y = 400, w = 600, h = 400 },
        },
    }
    for _, test in pairs(tests) do
        hsmocks:reset()
        test.action()
        lu.assertEquals(hsmocks.window.rect, test.expect, test.desc)
    end
end

os.exit(lu.LuaUnit.run())
