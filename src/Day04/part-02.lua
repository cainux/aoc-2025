local function read2DArray(filename)
    local file = assert(io.open(filename, "r"))

    local grid = {}

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

    return grid, width, height
end

local function printGrid(grid)
    for y = 1, #grid do
        for x = 1, #grid[y] do
            io.write(grid[y][x])
        end
        io.write("\n")
    end
end

local function getSurrounding(grid, width, height, y, x)
    local result = {}

    -- Check all 8 directions: top-left to bottom-right
    local directions = {
        { -1, -1 }, { -1, 0 }, { -1, 1 }, -- top row
        { 0,  -1 }, { 0, 1 },             -- middle row (skip center)
        { 1, -1 }, { 1, 0 }, { 1, 1 }     -- bottom row
    }

    for _, dir in ipairs(directions) do
        local dy, dx = dir[1], dir[2]
        local ny, nx = y + dy, x + dx

        -- Check bounds
        if ny >= 1 and ny <= height and nx >= 1 and nx <= width then
            table.insert(result, grid[ny][nx])
        end
    end

    return table.concat(result)
end

local grid, width, height = read2DArray("input.txt")
local answer = 0
local to_remove = {}

repeat
    while #to_remove > 0 do
        local pair = table.remove(to_remove)
        local y = pair[1]
        local x = pair[2]
        grid[y][x] = '.'
        answer = answer + 1
    end

    -- printGrid(grid)
    -- print()

    for y = 1, #grid do
        for x = 1, #grid[y] do
            if (grid[y][x] == '@') then
                local surround = getSurrounding(grid, width, height, y, x)
                local count = select(2, surround:gsub("@", "@"))
                if (count < 4) then
                    table.insert(to_remove, { y, x })
                end
            end
        end
    end
until #to_remove == 0

print(answer)
