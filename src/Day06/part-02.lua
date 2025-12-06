local function rotate(filename)
    local grid = {}
    local file = assert(io.open(filename, "r"))

    for line in file:lines() do
        local row = {}
        for i = 1, #line do
            row[i] = line:sub(i, i)
        end
        table.insert(grid, row)
    end

    file:close()

    local height = #grid
    local width = height > 0 and #grid[1] or 0

    local rotated = {}

    for x = width, 1, -1 do
        local newRow = {}
        for y = 1, height do
            table.insert(newRow, grid[y][x])
        end
        table.insert(rotated, newRow)
    end

    return rotated
end

local operations = {
    ['+'] = function(a, b) return a + b end,
    ['*'] = function(a, b) return a * b end
}

local function calc(list, op)
    local result = list[1]
    local operation = operations[op]
    for i, val in ipairs(list) do
        if (i > 1) then
            result = operation(result, val)
        end
    end
    return result
end

local rows = rotate("input.txt")
local list = {}
local answer = 0

for _, row in ipairs(rows) do
    local value = table.concat(row)
    local last = row[#row]
    if (last:match("[+*]")) then
        value = value:sub(1, #value - 1)
        table.insert(list, tonumber(value))
        local result = calc(list, last)
        answer = answer + result
        list = {}
    else
        table.insert(list, tonumber(value))
    end
end

print(answer)
