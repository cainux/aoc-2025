local file = assert(io.open("input.txt", "r"))

local rows = {}

for line in file:lines() do
    local row = {}
    for part in line:gmatch("%S+") do
        table.insert(row, part)
    end
    table.insert(rows, row)
end

local width = #rows[1]
local height = #rows

local operations = {
    ['+'] = function(a, b) return a + b end,
    ['*'] = function(a, b) return a * b end
}

local answer = 0

for x = 1, width do
    local op = operations[rows[height][x]]
    local acc = rows[1][x]
    for y = 2, height - 1 do
        local value = rows[y][x]
        acc = op(acc, value)
    end
    answer = answer + acc
end

print(answer)
