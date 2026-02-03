chunkGenerate = {
    f = {},
    data = {
        chunkNames = biomeData.chunkNames,
        chunkNums = #chunks
    }
}

local function swaperoo()
    local function isInTable(table, val)
        for key, value in pairs(table) do
            if value == val then
                return true
            end
        end

        return false
    end

    local tab = {}
    local l = #chunkGenerate.data.chunkNames
    local indxs = {}
    for i = 1, l do
        while true do
            local temp = math.random(1, l)

            if not isInTable(indxs, temp) then
                table.insert(indxs, temp)
                break
            end 
        end
    end

    for index, value in ipairs(indxs) do
        tab[index] = chunkGenerate.data.chunkNames[value]
    end

    --grass is ALWAYS the starter biome!

    if tab[1] ~= "grass" then
        for i = 2, #tab do
            if tab[i] == "grass" then
                local temporary = tab[i]
                tab[i] = tab[1]
                tab[1] = temporary
                break
            end
        end
    end

    return tab
end

--tables.writeTable(chunkGenerate.data.chunkNames)

chunkGenerate.data.chunkNames = swaperoo()

--tables.writeTable(chunkGenerate.data.chunkNames)

---@param middle boolean?
function chunkGenerate.f.makeChunk(middle, x, y)
    middle = middle or false
    local t = {}
    t.chunkData = chunks[math.random(1, chunkGenerate.data.chunkNums)]
    --t.biome = chunkGenerate.data.chunkNames[math.random(1, #chunkGenerate.data.chunkNames)]
    
    if (x >= 3 and x <= 5) and (y >= 3 and y <= 5) then
        t.biome = chunkGenerate.data.chunkNames[1]
    elseif (x >= 1 and x <= 2) and (y >= 0 and y <= 7) and not (y == 7 and x == 2) and not (y == 1 and x == 2) then
        t.biome = chunkGenerate.data.chunkNames[2]
    elseif y <= 7 and y > 5 and not (x == 7) and not (x == 7 and y == 6) or (x == 7 and y == 7) then
        t.biome = chunkGenerate.data.chunkNames[3]
    elseif (x >= 6 and x <= 7) and (y >= 0 and y < 7) and not (y == 1 and x == 6) then
        t.biome = chunkGenerate.data.chunkNames[4]
    else
        t.biome = chunkGenerate.data.chunkNames[5]
    end
    
    t.owned = middle
    --t.colorScheme = {1,1,1}
    t.price = 10

    return t
end

return chunkGenerate