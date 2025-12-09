local tablex = require("pl.tablex")
local scribe = require("lulu.scribe")

local FILENAME <const> = "input.txt"
local file = assert(io.open(FILENAME, "r"))

local function distance(pos1, pos2)
    local dx = pos2.x - pos1.x
    local dy = pos2.y - pos1.y
    local dz = pos2.z - pos1.z
    return dx * dx + dy * dy + dz * dz
end

local function calculateEdges(points)
    local edges = {}

    for i = 1, #points - 1 do
        for j = i + 1, #points do
            table.insert(edges, {
                idx1 = i,
                idx2 = j,
                distance = distance(points[i], points[j])
            })
        end
    end

    table.sort(edges, function(a, b) return a.distance < b.distance end)

    return edges
end

local function find(sets, elem)
    for _, set in ipairs(sets) do
        if (tablex.find(set, elem)) then
            return set
        end
    end
    scribe.putln("%T", sets)
    error(string.format("element %d not found in any sets", elem))
end

local function merge(arr1, arr2)
    local result = tablex.deepcopy(arr1)
    for _, v in ipairs(arr2) do
        if (not tablex.find(result, v)) then
            table.insert(result, v)
        end
    end
    return result
end

local function mst(edges, points)
    local sets = {}
    local last_edge

    for i = 1, #points do
        table.insert(sets, { i })
    end

    for _, e in ipairs(edges) do
        local a = e.idx1
        local b = e.idx2
        local seta = assert(find(sets, a))
        local setb = assert(find(sets, b))

        if (seta ~= setb) then
            local merged = merge(seta, setb)
            local set_a_pos = tablex.find(sets, seta)
            local set_b_pos = tablex.find(sets, setb)

            sets[set_a_pos] = merged
            table.remove(sets, set_b_pos)
            last_edge = e
        end
    end

    return sets, last_edge
end

local points = {}

for line in file:lines() do
    local parts = {}
    for part in line:gmatch("([^,]+)") do
        table.insert(parts, part)
    end
    table.insert(points, {
        x = tonumber(parts[1]),
        y = tonumber(parts[2]),
        z = tonumber(parts[3]),
    })
end

local edges = calculateEdges(points)
local _, last_edge = mst(edges, points)

print(points[last_edge.idx1].x * points[last_edge.idx2].x)

-- Shout out to: https://substack.com/home/post/p-181050535 for explaining this one. Never heard of MST!
