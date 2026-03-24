local chunks = require("source.world.chunks")
local chunkGenerate = require("source.world.chunkGenerate")

math.randomseed(os.time())

map = { -- this will be the things to see the whole map, generate it etc.
    tileSize = 48,
    chunkWidth = #chunks[1].data[1],
    chunkHeight = #chunks[1].data,
    chunkWidthNum = 7,
    chunkHeightNum = 7,
    map = {
        chunks = {
            --{ chunkGenerate.f.makeChunk(), chunkGenerate.f.makeChunk(),     chunkGenerate.f.makeChunk() },
            --{ chunkGenerate.f.makeChunk(), chunkGenerate.f.makeChunk(true), chunkGenerate.f.makeChunk() },
            --{ chunkGenerate.f.makeChunk(), chunkGenerate.f.makeChunk(),     chunkGenerate.f.makeChunk() }
         },
        data = {
            buildings = {},
        }
    },
    f = {}
}

function map.f.init()
    for y = 1, map.chunkHeightNum do
        map.map.chunks[y] = {}
        for x = 1, map.chunkWidthNum do
            local isMiddle = (x == math.ceil(map.chunkWidthNum / 2)) and (y == math.ceil(map.chunkHeightNum / 2))
            table.insert(map.map.chunks[y], chunkGenerate.f.makeChunk(isMiddle, x, y))
            --map.map.chunks[y][x] = chunkGenerate.f.makeChunk(true)
        end
    end

    --tables.writeTable(map.map.chunks)
end

function map.f.buyIsland(chX, chY)
    --checking by the chunk prevents crashes on the bottom row

    local mapData = map.map.chunks[chY]

    if mapData == nil then
        return false
    end

    mapData = map.map.chunks[chY][chX]

    if mapData == nil then
        return false
    end

    local coins = inventory.itemsOutsideOfInventory.coins
    if coins >= mapData.price then
        mapData.owned = true
        if chunks[mapData.chunkIndex].execute ~= nil then
            chunks[mapData.chunkIndex].execute()
        end
        inventory.itemsOutsideOfInventory.coins = inventory.itemsOutsideOfInventory.coins - mapData.price
        return true
    end

    return false
end

function map.f.accesibleTile(tileX, tileY)
    tileX = math.floor(tileX)
    tileY = math.floor(tileY)

    local chX = math.floor(tileX / map.chunkWidth) + 1
    local chY = math.floor(tileY / map.chunkHeight) + 1

    --love.graphics.print(tostring(chX) .. " " .. tostring(chY), 10, 10)

    if chX < 1 or chX > map.chunkWidthNum or chY < 1 or chY > map.chunkHeightNum then
        return false
    end

    local chunk = map.map.chunks[chY][chX]
    if not chunk then
        return false
    end

    if not chunk.owned then
        return false
    end

    local localX = (tileX % map.chunkWidth) + 1
    local localY = (tileY % map.chunkHeight) + 1

    local chunkData = chunk.chunkData
    if chunkData and chunkData[localY] and chunkData[localY][localX] then
        return chunkData[localY][localX] == 1
    end

    return false
end

return map