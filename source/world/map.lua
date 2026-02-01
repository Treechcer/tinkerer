local chunks = require("source.world.chunks")
local chunkGenerate = require("source.world.chunkGenerate")

math.randomseed(os.time())

map = { -- this will be the things to see the whole map, generate it etc.
    tileSize = 48,
    chunkWidth = #chunks[1][1],
    chunkHeight = #chunks[1],
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
        inventory.itemsOutsideOfInventory.coins = inventory.itemsOutsideOfInventory.coins - mapData.price
        return true
    end

    return false
end

function map.f.accesibleTile(tileX, tileY)
    --local chX = math.floor(tileX / map.chunkWidth)
    --local chY = math.floor(tileY / map.chunkHeight)

    tileX = tileX + 1
    tileY = tileY + 1

    local chX = math.floor((tileX - 1) / map.chunkWidth) + 1
    local chY = math.floor((tileY - 1) / map.chunkHeight) + 1

    local mapData = map.map.chunks[chY][chX]

    if mapData == nil then
        return false
    end

    if not mapData.owned then
        return false
    end

    local specificTileX = tileX - ((chX - 1) * map.chunkWidth)
    local specificTileY = tileY - ((chY - 1) * map.chunkHeight)
    if map.map.chunks[chY][chX].chunkData[specificTileY][specificTileX] == 1 then
        return true
    end

    return false
end

return map