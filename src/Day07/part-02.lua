local INPUT_FILENAME <const> = "input.txt"
local MANIFOLD <const> = 'S'
local SPACE <const> = '.'
local SPLITTER <const> = '^'

local function load(fileName)
    local file = assert(io.open(fileName, "r"))
    local rows = {}

    for line in file:lines() do
        local row = {}
        for c in line:gmatch(".") do
            table.insert(row, c)
        end
        table.insert(rows, row)
    end

    local height = #rows
    local width = #rows[#rows]

    return rows, height, width
end

local function printState(rows)
    local PAD <const> = 3
    for _, row in ipairs(rows) do
        for _, col in ipairs(row) do
            io.write(string.format("%"..PAD.."s", tostring(col)))
        end
        io.write("\n")
    end
end

local rows, height, width = load(INPUT_FILENAME)

for y = 1, height do
    local curr_row = rows[y]
    local next_row = rows[y + 1]
    for x = 1, width do
        local curr_col = curr_row[x]

        if (curr_col == MANIFOLD) then
            next_row[x] = 1
        elseif (type(curr_col) == "number" and next_row) then
            local south = next_row[x]
            if (south == SPACE) then
                next_row[x] = curr_col
            elseif (south == SPLITTER) then
                local south_west = next_row[x - 1]
                local south_east = next_row[x + 1]

                if (south_west) then
                    if (type(south_west) == "number") then
                        next_row[x - 1] = next_row[x - 1] + curr_col
                    else
                        next_row[x - 1] = curr_col
                    end
                end
                if (south_east) then
                    if (type(south_east) == "number") then
                        next_row[x + 1] = next_row[x + 1] + curr_col
                    else
                        next_row[x + 1] = curr_col
                    end
                end
            elseif (type(south) == "number") then
                next_row[x] = next_row[x] + curr_col
            end
        end
    end
end

local answer = 0

for _, i in ipairs(rows[#rows]) do
    if (type(i) == "number") then
        answer = answer + i
    end
end

-- printState(rows)
print(answer)
