local file = io.open("input.txt", "r")

if file == nil then
    os.exit(1);
end

local line = file:read("*all")
file:close()

local function test(input)
    local str = tostring(input)
    local len = #str

    if (len % 2 ~= 0) then
        return false
    end

    local mid = len / 2
    local first = str:sub(1, mid)
    local second = str:sub(mid + 1)

    return first == second
end

local pairs = {}
local answer = 0

for pair in string.gmatch(line, "([^,]+)") do
    table.insert(pairs, pair)
end

for _, v in ipairs(pairs) do
    local start_val, end_val = tonumber(v:match("(%d+)")), tonumber(v:match("%d+-(%d+)"))

    print(string.format("%d to %d", start_val, end_val))

    for id = start_val, end_val do
        if (test(id)) then
            print(string.format("  invalid ID found %d", id))
            answer = answer + id
        end
    end
end

print(string.format("Answer: %d", answer))
