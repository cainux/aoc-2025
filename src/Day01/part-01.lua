local file = io.open("input.txt", "r")

if file == nil then
    os.exit(1);
end

local dial = 50
local answer = 0

for line in file:lines() do
    local direction = line:sub(1, 1)
    local amount = tonumber(string.sub(line, 2))

    if amount > 99 then
        amount = amount % 100
    end

    if direction == "L" then
        dial = dial - amount
        if dial < 0 then
            dial = 100 + dial
        end
    else
        dial = dial + amount
        if dial > 99 then
            dial = dial - 100
        end
    end

    -- print(string.format("The dial is rotated %s to point at %d", line, dial))

    if dial == 0 then
        answer = answer + 1
    end

end

print(string.format("Answer: %s", answer))
