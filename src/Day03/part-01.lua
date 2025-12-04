local file = io.open("input.txt", "r")

if file == nil then
    os.exit(1);
end

local answer = 0

for line in file:lines() do
    local highest = 0
    for i = 1, #line - 1 do
        for y = i + 1, #line do
            local pair = string.format("%s%s", line:sub(i, i), line:sub(y, y))
            local value = assert(tonumber(pair))
            if value > highest then
                highest = value
            end
        end
    end
    -- print(highest)
    answer = answer + highest
end

print(answer)
