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

return mathWorker