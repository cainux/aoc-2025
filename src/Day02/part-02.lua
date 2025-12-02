local file = io.open("input.txt", "r")

if file == nil then
    os.exit(1);
end

local line = file:read("*all")
file:close()

local function test(input)
    local str = tostring(input)
    local len = #str

    for p_len = 1, len / 2 do
        if len % p_len == 0 then
            local p = str:sub(1, p_len)
            local repeats = len / p_len
            local recon = string.rep(p, repeats)

            if recon == str then
                return true
            end
        end
    end

end

local pairs = {}
local answer = 0

for pair in string.gmatch(line, "([^,]+)") do
    table.insert(pairs, pair)
end

for _, v in ipairs(pairs) do
    local start_val, end_val = tonumber(v:match("(%d+)")), tonumber(v:match("%d+-(%d+)"))

    -- print(string.format("%d to %d", start_val, end_val))

    for id = start_val, end_val do
        if (test(id)) then
            print(string.format("  invalid ID found %d", id))
            answer = answer + id
        end
    end
end

print(string.format("Answer: %d", answer))
