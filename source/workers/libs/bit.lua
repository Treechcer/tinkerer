--bitLib = require("bit")

bit = {
    BIT1 = 1,
    BIT2 = 2,
    BIT4 = 4,
    BIT8 = 8,
    BIT16 = 16,
    BIT32 = 32,
    BIT64 = 64,
    BIT128 = 128,
    BIT256 = 256,
    BIT512 = 512,
    BIT1024 = 1024,

    maxBit = 2047
}

function bor(a, b)
    local result = 0
    local bitval = 1
    while a > 0 or b > 0 do
        if a % 2 == 1 or b % 2 == 1 then
            result = result + bitval
        end
        a = math.floor(a / 2)
        b = math.floor(b / 2)
        bitval = bitval * 2
    end
    return result
end

function band(a, b)
    local result = 0
    local bitval = 1
    while a > 0 and b > 0 do
        if a % 2 == 1 and b % 2 == 1 then
            result = result + bitval
        end
        a = math.floor(a / 2)
        b = math.floor(b / 2)
        bitval = bitval * 2
    end
    return result
end

function bit.addBit(t)
    finalBit = 0
    for key, value in pairs(t) do
        finalBit = bor(finalBit, value)
    end

    return finalBit
end

function bit.timesBit(t)
    finalBit = bit.maxBit
    for key, value in pairs(t) do
        finalBit = band(finalBit, value)
    end

    return finalBit
end

return bit