local Set = require("pl.Set")
local tablex = require("pl.tablex")
local scribe = require("lulu.scribe")

local FILENAME <const> = "input-test.txt"
local PAIR_COUNTS <const> = {
    ["input.txt"] = 1000,
    ["input-test.txt"] = 10,
}
local file = assert(io.open(FILENAME, "r"))

local function distanceSquared(pos1, pos2)
    local dx = pos2.x - pos1.x
    local dy = pos2.y - pos1.y
    local dz = pos2.z - pos1.z
    return dx * dx + dy * dy + dz * dz
end

local function closestPairs(positions, count)
    local pairs = {}

    for i = 1, #positions - 1 do
        for j = i + 1, #positions do
            table.insert(pairs, {
                pos1 = positions[i],
                pos2 = positions[j],
                idx1 = i,
                idx2 = j,
                distanceSquared = distanceSquared(positions[i], positions[j])
            })
        end
    end

    table.sort(pairs, function(a, b) return a.distanceSquared < b.distanceSquared end)

    local result = {}

    for i = 1, math.min(count, #pairs) do
        table.insert(result, Set({ pairs[i].idx1, pairs[i].idx2 }))
    end

    return result
end

local function mergePairsIntoSets(pairs)
    local sets = {}

    for _, pairSet in ipairs(pairs) do
        local toMerge = {}

        for i, existingSet in ipairs(sets) do
            if not Set.isempty(Set.intersection(pairSet, existingSet)) then
                pairSet = Set.union(pairSet, existingSet)
                table.insert(toMerge, i)
            end
        end

        for i = #toMerge, 1, -1 do
            table.remove(sets, toMerge[i])
        end

        table.insert(sets, pairSet)
    end

    return sets
end

local positions = {}

for line in file:lines() do
    local parts = {}
    for part in line:gmatch("([^,]+)") do
        table.insert(parts, part)
    end
    table.insert(positions, {
        x = tonumber(parts[1]),
        y = tonumber(parts[2]),
        z = tonumber(parts[3]),
    })
end

local pairs = closestPairs(positions, PAIR_COUNTS[FILENAME])
local sets = mergePairsIntoSets(pairs)

table.sort(sets, function(a, b) return #a > #b end)

local result = {}

for i = 1, 3 do
    table.insert(result, sets[i])
end

scribe.putln("%T", result)

local answer = tablex.reduce(function(acc, val)
    return acc * #val
end, result, 1)

print(answer)
