chunks = require("game.chunks")

map = {
    blockSize = 50,
    chunks = {
    }
}

function map.isOnGround(x, y, width, height)
    local left = x
    local right = x + width
    local top = y
    local bottom = y + height

    for chunkY, rowChunks in ipairs(map.chunks) do
        for chunkX, chunk in ipairs(rowChunks) do
            for by = 1, #chunk do
                for bx = 1, #chunk[by] do
                    local tile = chunk[by][bx]
                    if tile == 1 then
                        local worldX = (chunkX-1) * #chunk[by] * map.blockSize + (bx-1) * map.blockSize
                        local worldY = (chunkY-1) * #chunk     * map.blockSize + (by-1) * map.blockSize

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
    end

    return false
end


function map.generate(rows)
    table.insert(map.chunks, rows)
end

return map