local file = io.open("input.txt", "r")

if file == nil then
    os.exit(1);
end

local function findMax(str)
    local max = 0
    local pos = 1

    for i = 1, #str do
        local digit = assert(tonumber(str:sub(i, i)))
        if digit > max then
            max = digit
            pos = i
        end
    end

    return max, pos
end

local answer = 0
local SIZE <const> = 12

for line in file:lines() do
    local curr = 1
    local result = {}

    for i = 1, SIZE do
        local str = line:sub(curr, #line - (SIZE - i))
        local max, pos = findMax(str)

        table.insert(result, max)
        curr = curr + pos
    end

    answer = answer + tonumber(table.concat(result))
end

print(answer)
