bitLib = require("bit")

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

function bit.addBit(t)
    finalBit = 0
    for key, value in pairs(t) do
        finalBit = bitLib.bor(finalBit, value)
    end

    return finalBit
end

function bit.timesBit(t)
    finalBit = bit.maxBit
    for key, value in pairs(t) do
        finalBit = bitLib.band(finalBit, value)
    end

    return finalBit
end

return bit