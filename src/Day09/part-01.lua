local pretty = require("pl.pretty")
local file = assert(io.open("input.txt", "r"))

local function calcArea(p1, p2)
    local width = math.abs(p2.x - p1.x) + 1
    local height = math.abs(p2.y - p1.y) + 1
    return width * height
end

local points = {}

for line in file:lines() do
    local x, y = line:match("(%d+),(%d+)")
    table.insert(points, { x = x, y = y })
end

local largest = 0

for i = 1, #points - 1 do
    for j = i + 1, #points do
        local area = calcArea(points[i], points[j])
        if (area > largest) then
            largest = area
        end
    end
end

print(largest)
