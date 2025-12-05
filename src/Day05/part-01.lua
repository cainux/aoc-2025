local file = assert(io.open("input.txt", "r"))

local ranges = {}
local ingredients = {}

local reading_ranges = true

for line in file:lines() do
    if (line == "") then
        reading_ranges = false
    end

    if reading_ranges then
        local bottom, top = line:match("(%d+)-(%d+)")
        table.insert(ranges, { bottom = tonumber(bottom), top = tonumber(top) })
    else
        table.insert(ingredients, tonumber(line))
    end
end

local fresh = 0

for _, i in ipairs(ingredients) do
    for _, r in ipairs(ranges) do
        if (i >= r.bottom and i <= r.top) then
            fresh = fresh + 1
            break
        end
    end
end

print(fresh)
