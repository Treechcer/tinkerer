chunkGenerate = {
    f = {},
    data = {
        chunkNames = biomeData.chunkNames,
        chunkNums = #chunks
    }
}
---@param middle boolean?
function chunkGenerate.f.makeChunk(middle)
    middle = middle or false
    local t = {}
    t.chunkData = chunks[math.random(1, chunkGenerate.data.chunkNums)]
    t.biome = chunkGenerate.data.chunkNames[math.random(1, #chunkGenerate.data.chunkNames)]
    t.owned = middle
    --t.colorScheme = {1,1,1}
    t.price = 10

    return t
end

return chunkGenerate