--code from my other repo, raycasting minigame

local bit = require("bit")

noiseLib = {
    seed = os.time(),
}

function noiseLib.generation(x, y)
    xl = math.floor(x)
    xr = math.floor(x) + 1

    yl = math.floor(y)
    yr = math.floor(y) + 1

    tx = x - xl
    ty = y - yl

    local c00 = noiseLib.ran(xl, yl)
    local c01 = noiseLib.ran(xr, yl)
    local c10 = noiseLib.ran(xl, yr)
    local c11 = noiseLib.ran(xr, yr)

    local t1 = noiseLib.lerp(c00, c01, tx)
    local t2 = noiseLib.lerp(c10, c11, tx)

    return noiseLib.lerp(t1, t2, ty)
end

function noiseLib.ran(x,y)
    local result = x * 8660254037 + y * 20194423349 + noiseLib.seed * 30000101111
    result = bit.band(result, 0xffffffff)
    result = bit.bxor(result, bit.rshift(result, 13))
    result = bit.band(result * 1274126177, 0xffffffff)
    result = bit.bxor(result, bit.rshift(result, 16))
    return bit.band(result, 0x7fffffff) / 0x7fffffff
end

function noiseLib.lerp(a,b,t)
    return (a + (b - a) * t)
end

return noiseLib