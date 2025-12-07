local chunks = require("source.world.chunks")

map = { -- this will be the things to see the whole map, generate it etc.
    tileSize = 48,
    map = {
        chunks = {
            { chunks.chunk1, chunks.chunk1, chunks.chunk1 },
            { chunks.chunk1, chunks.chunk1, chunks.chunk1 },
            { chunks.chunk1, chunks.chunk1, chunks.chunk1 }
         },
        data = {
            buildings = {},
        }
    }
}

return map