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
            { {chunkData = chunks.chunk1, biome = "hill", colorScheme = {math.random(),math.random(),math.random(),math.random()}}, {chunkData = chunks.chunk1, biome = "void", colorScheme = {math.random(),math.random(),math.random(),math.random()}}, {chunkData = chunks.chunk1, biome = "snow", colorScheme = {math.random(),math.random(),math.random(),math.random()}} },
            { {chunkData = chunks.chunk1, biome = "grass", colorScheme = {math.random(),math.random(),math.random(),math.random()}}, {chunkData = chunks.chunk1, biome = "sand", colorScheme = {math.random(),math.random(),math.random(),math.random()}}, {chunkData = chunks.chunk1, biome = "void", colorScheme = {math.random(),math.random(),math.random(),math.random()}} },
            { {chunkData = chunks.chunk1, biome = "snow", colorScheme = {math.random(),math.random(),math.random(),math.random()}}, {chunkData = chunks.chunk1, biome = "grass", colorScheme = {math.random(),math.random(),math.random(),math.random()}}, {chunkData = chunks.chunk1, biome = "grass", colorScheme = {math.random(),math.random(),math.random(),math.random()}} }
         },
        data = {
            buildings = {},
        }
    }
}

map.chunkHeightNum = #map.map.chunks
map.chunkWidthNum = #map.map.chunks[1]

return map