-- Import with the following command:
-- local tools = require('dev_tools')

print('Dev tools loaded')

local dev_tools = {}

-- temp code for printing tables (dicts)
function dev_tools.dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k, v in pairs(o) do
            if type(k) ~= 'number' then k = '"' .. k .. '"' end
            s = s .. '[' .. k .. '] = ' .. dev_tools.dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

return dev_tools
