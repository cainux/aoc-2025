local file = io.open("input.txt", "r")

if file == nil then
    os.exit(1);
end

local dial = 50
local answer = 0

for line in file:lines() do
    local direction = line:sub(1, 1)
    local amount = tonumber(string.sub(line, 2))

    if direction == "L" then
        for i = 1, amount do
            dial = dial - 1
            if dial == 0 then
                answer = answer + 1
            end
            if dial < 0 then
                dial = 99
            end
        end
    else
        for i = 1, amount do
            dial = dial + 1
            if dial > 99 then
                dial = 0
            end
            if dial == 0 then
                answer = answer + 1
            end
        end
    end

    -- print(string.format("The dial is rotated %s to point at %d", line, dial))
end

print(string.format("Answer: %s", answer))
-- incorrect answers:
-- 6580
-- 5493
-- 3174
