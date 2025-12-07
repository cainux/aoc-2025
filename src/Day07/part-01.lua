local INPUT_FILENAME <const> = "input.txt"
local MANIFOLD <const> = 'S'
local SPACE <const> = '.'
local BEAM <const> = '|'
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
    for _, row in ipairs(rows) do
        for _, col in ipairs(row) do
            io.write(col)
        end
        io.write("\n")
    end
end

local rows, height, width = load(INPUT_FILENAME)
local answer = 0

for y = 1, height do
    local curr_row = rows[y]
    local next_row = rows[y + 1]
    for x = 1, width do
        local curr_col = curr_row[x]

        if (curr_col == MANIFOLD) then
            next_row[x] = BEAM
        elseif (curr_col == BEAM and next_row) then
            local next_pos = next_row[x]
            if (next_pos == SPACE) then
                next_row[x] = BEAM
            elseif (next_pos == SPLITTER) then
                answer = answer + 1
                if (next_row[x - 1]) then
                    next_row[x - 1] = BEAM
                end
                if (next_row[x + 1]) then
                    next_row[x + 1] = BEAM
                end
            end
        end
    end
end

printState(rows)
print()
print(answer)
