chunks = require("game.chunks")

map = {
    blockSize = 50,
    chunks = {
        {chunks.land, chunks.noLand, chunks.noLand},
        {chunks.land, chunks.noLand, chunks.noLand},
        {chunks.land, chunks.noLand, chunks.noLand},
        {chunks.land, chunks.noLand, chunks.noLand},
        {chunks.land, chunks.noLand, chunks.noLand},
        {chunks.land, chunks.noLand, chunks.noLand},
        {chunks.land, chunks.noLand, chunks.noLand},
        {chunks.land, chunks.noLand, chunks.noLand},
        {chunks.land, chunks.noLand, chunks.noLand},
        {chunks.noLand, chunks.land, chunks.noLand},
        {chunks.noLand, chunks.land, chunks.noLand},
        {chunks.noLand, chunks.land, chunks.noLand},
        {chunks.noLand, chunks.land, chunks.noLand},
        {chunks.noLand, chunks.land, chunks.noLand},
        {chunks.noLand, chunks.land, chunks.noLand},
        {chunks.noLand, chunks.land, chunks.noLand},
        {chunks.noLand, chunks.land, chunks.noLand},
        {chunks.noLand, chunks.land, chunks.noLand},
        {chunks.noLand, chunks.noLand, chunks.noLand},
        {chunks.noLand, chunks.noLand, chunks.noLand},
        {chunks.noLand, chunks.noLand, chunks.noLand},
        {chunks.noLand, chunks.noLand, chunks.noLand},
        {chunks.noLand, chunks.noLand, chunks.noLand},
        {chunks.noLand, chunks.noLand, chunks.noLand},
        {chunks.noLand, chunks.noLand, chunks.noLand},
        {chunks.noLand, chunks.noLand, chunks.noLand},
        {chunks.noLand, chunks.noLand, chunks.noLand},
    }
}

function map.isOnGround(x, y, width, height)
    local left = x
    local right = x + width
    local top = y
    local bottom = y + height
    for chunkY, rowChunks in ipairs(map.chunks) do
        for chunkX, chunk in ipairs(rowChunks) do
            for blockIndex, tile in ipairs(chunk) do
                if tile == 1 then
                    local worldX = (chunkX-1) * #chunk * map.blockSize + (blockIndex-1) * map.blockSize
                    local worldY = (chunkY-1) * map.blockSize
                    local blockLeft   = worldX
                    local blockRight  = worldX + map.blockSize
                    local blockTop    = worldY
                    local blockBottom = worldY + map.blockSize
                    if right > blockLeft and left < blockRight and bottom > blockTop and top < blockBottom then
                        return true
                    end
                end
            end
        end
    end

    return false
end



return map