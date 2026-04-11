mathWorker = {}

function mathWorker.lerp(a, b, t)
    return a + (b - a) * t
end

function mathWorker.tileDistance(a, b)
    return (((a.tileX - b.tileX) ^ 2) + ((a.tileY - b.tileY) ^ 2)) ^ 0.5
end

function mathWorker.positionDistance(a, b)
    return (((a.x - b.x) ^ 2) + ((a.y - b.y) ^ 2)) ^ 0.5
end

function mathWorker.normalise(x, y)
    local length = math.sqrt(x ^ 2 + y ^ 2)
    if length == 0 then
        return x, y
    end
    local xNormalsied = x / length
    local yNormalsied = y / length

    return xNormalsied, yNormalsied
end

function mathWorker.getAngle(x1, y1, x2, y2) -- returns radians
    --yes I made this function just so I don't have to disable the diagnostics everywhere
    ---@diagnostic disable-next-line: deprecated
    local ang = math.atan2(y2 - y1, x2 - x1)
    if ang < 0 then
        ang = ang + math.pi * 2
    end

    return ang
end

return mathWorker