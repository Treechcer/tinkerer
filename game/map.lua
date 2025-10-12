chunks = require("game.chunks")

map = {
    blockSize = 48,
    chunks = {
    },
}

function map.isGround(x, y)
    local tileX = math.floor(x / map.blockSize) + 1
    local tileY = math.floor(y / map.blockSize) + 1
    local block = map.chunks[math.floor((tileY - 1) / #map.chunks[1][1].land) + 1][math.floor((tileX - 1) / #map.chunks[1][1].land) + 1].land[(tileY - 1) % #map.chunks[1][1].land + 1][(tileX - 1) % #map.chunks[1][1].land + 1]

    if block == 0 then
        return false
    elseif block == 1 then
        
        return true
    end
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
    noiseLib = require("libraries.noiseLib")

    --local rows = { -- "default" island
    --    {{land = chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land =chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "snow"}},
    --    {{land = chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land =chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "snow"}},
    --    {{land = chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land =chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "snow"}},
    --    {{land = chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.special, biome = "grass"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "snow"}},
    --    {{land = chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "snow"}},
    --    {{land = chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "snow"}},
    --    {{land = chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "snow"}},
    --}
    
    -- 7x7
    local rows = {
        
    }

    for y = 1, 7 do
        local row = {}
        for x = 1, 7 do

            --temp biome making, it'll be different later, it's here mostly for test or something

            if (x % 7 == 3 or x % 7 == 4 or x % 7 == 5) and (y == 3 or y == 4 or y == 5) then
                biome = "grass"
            elseif (x % 7 == 1 or x % 7 == 2) and (y == 2 or y == 3 or y == 4 or y == 5 or y == 6) and not (x % 7 == 2 and (y == 6 or y == 2)) then
                biome = "sand"
            elseif (x % 7 == 6 or x % 7 == 0) and (y == 2 or y == 3 or y == 4 or y == 5 or y == 6) and not (x % 7 == 6 and (y == 6 or y == 2)) then
                biome = "rocky"
            elseif y == 6 or y == 7 then
                biome = "snow"
            else
                biome = "void"
            end

            if x == 4 and y == 4 then
                table.insert(row, {land = chunks.specialPrefabs.starter, biome = "grass"})
            else
                table.insert(row, {land = chunks.prefabs[math.ceil(noiseLib.generation(x,y) * chunks.count)], biome = biome})
            end
        end
        table.insert(rows, row)
    end

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