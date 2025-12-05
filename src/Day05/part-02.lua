local file = assert(io.open("input.txt", "r"))

local input_ranges = {}

for line in file:lines() do
    if (line == "") then
        break
    end

    local floor, ceiling = line:match("(%d+)-(%d+)")
    table.insert(input_ranges, { floor = tonumber(floor), ceiling = tonumber(ceiling) })
end

local function reduce(ranges)
    local result = {}
    local mutated = false

    for _, r in ipairs(ranges) do
        local overlap_found = false

        for _, f in ipairs(result) do
            if (r.floor <= f.ceiling and f.floor <= r.ceiling) then
                overlap_found = true
                mutated = true
                local new_min = math.min(r.floor, f.floor)
                local new_max = math.max(r.ceiling, f.ceiling)
                f.floor = new_min
                f.ceiling = new_max
                break
            end
        end
        if (not overlap_found) then
            table.insert(result, r)
        end
    end

    return result, mutated
end

local mutated = false
local final_ranges = input_ranges

repeat
    local r, m = reduce(final_ranges)
    final_ranges = r
    mutated = m
until not mutated

local answer = 0

for _, f in ipairs(final_ranges) do
    -- print(string.format("%d-%d", f.floor, f.ceiling))
    local range_size = (f.ceiling - f.floor) + 1
    answer = answer + range_size
end

print()
print(string.format("ANSWER: %d", answer))
