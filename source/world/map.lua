local chunks = require("source.world.chunks")

math.randomseed(os.time())

map = { -- this will be the things to see the whole map, generate it etc.
    tileSize = 48,
    chunkWidth = #chunks.chunk1[1],
    chunkHeight = #chunks.chunk1,
    chunkWidthNum = 0,
    chunkHeightNum = 0,
    map = {
        chunks = {
            { { chunkData = chunks.chunk4, biome = "hill",  owned = false, colorScheme = { math.random(), math.random(), math.random(), math.random() }, price = 10 }, { chunkData = chunks.chunk1, biome = "void",  owned = false, colorScheme = { math.random(), math.random(), math.random(), math.random() }, price = 10 }, { chunkData = chunks.chunk1, biome = "snow",  owned = false, colorScheme = { math.random(), math.random(), math.random(), math.random() }, price = 10  } },
            { { chunkData = chunks.chunk1, biome = "grass", owned = false, colorScheme = { math.random(), math.random(), math.random(), math.random() }, price = 10 }, { chunkData = chunks.chunk1, biome = "sand",  owned = true,  colorScheme = { math.random(), math.random(), math.random(), math.random() }, price = 10 }, { chunkData = chunks.chunk1, biome = "void",  owned = false, colorScheme = { math.random(), math.random(), math.random(), math.random() }, price = 10  } },
            { { chunkData = chunks.chunk1, biome = "snow",  owned = false, colorScheme = { math.random(), math.random(), math.random(), math.random() }, price = 10 }, { chunkData = chunks.chunk1, biome = "grass", owned = false, colorScheme = { math.random(), math.random(), math.random(), math.random() }, price = 10 }, { chunkData = chunks.chunk1, biome = "grass", owned = false, colorScheme = { math.random(), math.random(), math.random(), math.random() }, price = 10  } }
         },
        data = {
            buildings = {},
        }
    },
    f = {}
}

function map.f.buyIsland(chX, chY)
    local mapData = map.map.chunks[chY][chX]
    local coins = inventory.itemsOutsideOfInventory.coins
    if coins >= mapData.price then
        mapData.owned = true
        inventory.itemsOutsideOfInventory.coins = inventory.itemsOutsideOfInventory.coins - mapData.price
    end
end

map.chunkHeightNum = #map.map.chunks
map.chunkWidthNum = #map.map.chunks[1]

return map