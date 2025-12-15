local file = assert(io.open("input-test.txt", "r"))

local function calc_area(p1, p2)
    local width = math.abs(p2.x - p1.x) + 1
    local height = math.abs(p2.y - p1.y) + 1
    return width * height
end

local points = {}

for line in file:lines() do
    local x, y = line:match("(%d+),(%d+)")
    table.insert(points, { x = tonumber(x), y = tonumber(y) })
end

-- Precompute polygon AABB
local poly_minx, poly_miny, poly_maxx, poly_maxy = math.huge, math.huge, -math.huge, -math.huge
for _, p in ipairs(points) do
    poly_minx = math.min(poly_minx, p.x)
    poly_miny = math.min(poly_miny, p.y)
    poly_maxx = math.max(poly_maxx, p.x)
    poly_maxy = math.max(poly_maxy, p.y)
end

-------------------------------------------------------------------------

-- Fast inclusive-boundary ray-casting
local function point_in_poly(px, py)
    local inside = false
    local n = #points
    local j = n
    for i = 1, n do
        local vi = points[i]
        local vj = points[j]
        if ((vi.y > py) ~= (vj.y > py)) and
            (px <= vi.x + (vj.x - vi.x) * (py - vi.y) / (vj.y - vi.y + 1e-10)) then
            inside = not inside
        end
        -- On edge → inside
        local cross = (vj.x - vi.x) * (py - vi.y) - (px - vi.x) * (vj.y - vi.y)
        if math.abs(cross) < 1e-8 then return true end
        j = i
    end
    return inside
end

local function rect_in_poly(c1, c2)
    local minx = math.min(c1.x, c2.x)
    local miny = math.min(c1.y, c2.y)
    local maxx = math.max(c1.x, c2.x)
    local maxy = math.max(c1.y, c2.y)

    -- AABB reject
    if maxx < poly_minx or minx > poly_maxx or maxy < poly_miny or miny > poly_maxy then
        return false
    end

    return point_in_poly(minx, miny) and
        point_in_poly(maxx, miny) and
        point_in_poly(maxx, maxy) and
        point_in_poly(minx, maxy)
end

-------------------------------------------------------------------------


local rectangles = {}

for i = 1, #points - 1 do
    for j = i + 1, #points do
        local p1, p2 = points[i], points[j]
        local area = calc_area(p1, p2)
        table.insert(rectangles, { area = area, p1 = p1, p2 = p2 })
    end
end

table.sort(rectangles, function(a, b)
    return a.area > b.area
end)

-- for _, r in ipairs(all_rectangles) do print(r.area, "|", r.p1.x, ",", r.p1.y, " ", r.p2.x, ",", r.p2.y) end

print(string.format("There are %d rectangles to check and the polygon has %d points", #rectangles, #points))

for _, r in ipairs(rectangles) do
    local p1, p2 = r.p1, r.p2

    if (rect_in_poly(p1, p2)) then
        print("yes")
        print(r.area)
        break
    else
        print("nope")
    end
end
