local chunks = require("source.world.chunks")
local chunkGenerate = require("source.world.chunkGenerate")

math.randomseed(os.time())

map = { -- this will be the things to see the whole map, generate it etc.
    tileSize = 48,
    chunkWidth = #chunks[1][1],
    chunkHeight = #chunks[1],
    chunkWidthNum = 9,
    chunkHeightNum = 9,
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
    for y = 1, map.chunkWidthNum do
        map.map.chunks[y] = {}
        for x = 1, map.chunkHeightNum do
            local isMiddle = (x == math.ceil(map.chunkWidthNum / 2)) and (y == math.ceil(map.chunkHeightNum / 2))
            table.insert(map.map.chunks[y], chunkGenerate.f.makeChunk(isMiddle))
            --map.map.chunks[y][x] = chunkGenerate.f.makeChunk(true)
        end
    end
end

function map.f.buyIsland(chX, chY)
    local mapData = map.map.chunks[chY][chX]

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

return map