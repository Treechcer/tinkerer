chunks = require("game.chunks")

map = {
    blockSize = 48,
    chunks = {
    },
}

function map.isOnGround(x, y, width, height)
    local left = x
    local right = x + width
    local top = y
    local bottom = y + height

    for chunkY, rowChunks in ipairs(map.chunks) do
        for chunkX, chunk in ipairs(rowChunks) do
            for by = 1, #chunk.land do
                for bx = 1, #chunk.land[by] do
                    local tile = chunk.land[by][bx]
                    if tile == 1 then
                        local worldX = (chunkX-1) * #chunk.land[by] * map.blockSize + (bx-1) * map.blockSize
                        local worldY = (chunkY-1) * #chunk.land * map.blockSize + (by-1) * map.blockSize

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

function map.getBlockPos(x, y)
    local blockX = math.floor(x / map.blockSize) * map.blockSize
    local blockY = math.floor(y / map.blockSize) * map.blockSize

    return blockX, blockY
end

function map.getWorldPos(x, y)
    local worldX = (x - game.width / 2) * camera.zoom + camera.x - player.width / 2
    local worldY = (y - game.height / 2) * camera.zoom + camera.y - player.height / 2

    return worldX, worldY
end

function map.init()

    local rows = { -- "default" island
        {{land = chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land =chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "snow"}},
        {{land = chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land =chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "snow"}},
        {{land = chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land =chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "snow"}},
        {{land = chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.landd, biome = "grass"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "snow"}},
        {{land = chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "snow"}},
        {{land = chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "snow"}},
        {{land = chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "snow"}},
    }

    map.generate(rows[1])
    map.generate(rows[2])
    map.generate(rows[3])
    map.generate(rows[4])
    map.generate(rows[5])
    map.generate(rows[6])
    map.generate(rows[7])
end

function map.screenPosToBlock(x, y)
    local worldX, worldY = map.getWorldPos(x, y)
    local blockX, blockY = map.getBlockPos(worldX, worldY)

    return blockX, blockY
end

return map