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
    for y = 1, map.chunkWidthNum do
        map.map.chunks[y] = {}
        for x = 1, map.chunkHeightNum do
            table.insert(map.map.chunks[y], chunkGenerate.f.makeChunk(true))
            --map.map.chunks[y][x] = chunkGenerate.f.makeChunk(true)
        end
    end
end

function map.f.buyIsland(chX, chY)
    local mapData = map.map.chunks[chY][chX]
    local coins = inventory.itemsOutsideOfInventory.coins
    if coins >= mapData.price then
        mapData.owned = true
        inventory.itemsOutsideOfInventory.coins = inventory.itemsOutsideOfInventory.coins - mapData.price
    end
end

return map