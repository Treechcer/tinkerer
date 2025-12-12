local chunks = require("source.world.chunks")

math.randomseed(os.time())

map = { -- this will be the things to see the whole map, generate it etc.
    tileSize = 48,
    chunkWidth = #chunks.chunk1[1],
    chunkHeight = #chunks.chunk1,
    map = {
        chunks = {
            { {chunkData = chunks.chunk1, biome = "test", colorScheme = {math.random(),math.random(),math.random(),math.random()}}, {chunkData = chunks.chunk1, biome = "test", colorScheme = {math.random(),math.random(),math.random(),math.random()}}, {chunkData = chunks.chunk1, biome = "test", colorScheme = {math.random(),math.random(),math.random(),math.random()}} },
            { {chunkData = chunks.chunk1, biome = "test", colorScheme = {math.random(),math.random(),math.random(),math.random()}}, {chunkData = chunks.chunk1, biome = "test", colorScheme = {math.random(),math.random(),math.random(),math.random()}}, {chunkData = chunks.chunk1, biome = "test", colorScheme = {math.random(),math.random(),math.random(),math.random()}} },
            { {chunkData = chunks.chunk1, biome = "test", colorScheme = {math.random(),math.random(),math.random(),math.random()}}, {chunkData = chunks.chunk1, biome = "test", colorScheme = {math.random(),math.random(),math.random(),math.random()}}, {chunkData = chunks.chunk1, biome = "test", colorScheme = {math.random(),math.random(),math.random(),math.random()}} }
         },
        data = {
            buildings = {},
        }
    }
}

return map