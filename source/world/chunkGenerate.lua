chunkGenerate = {
    f = {},
    data = {
        chunkNames = biomeData.chunkNames,
        chunkNums = #chunks
    }
}
---@param middle boolean?
function chunkGenerate.f.makeChunk(middle, x, y)
    middle = middle or false
    local t = {}
    t.chunkData = chunks[math.random(1, chunkGenerate.data.chunkNums)]
    --t.biome = chunkGenerate.data.chunkNames[math.random(1, #chunkGenerate.data.chunkNames)]
    
    if (x >= 3 and x <= 5) and (y >= 3 and y <= 5) then
        t.biome = "grass"
    elseif (x >= 1 and x <= 2) and (y >= 0 and y <= 7) and not (y == 7 and x == 2) and not (y == 1 and x == 2) then
        t.biome = "snow"
    elseif y <= 7 and y >= 5 then
        t.biome = "hill"
    elseif (x >= 6 and x <= 7) and (y >= 0 and y <= 7) and not (y == 7 and x == 6) and not (y == 1 and x == 6) then
        t.biome = "sand"
    else
        t.biome = "void"
    end
    
    t.owned = middle
    --t.colorScheme = {1,1,1}
    t.price = 10

    return t
end

return chunkGenerate