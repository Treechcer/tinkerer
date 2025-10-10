chunks = require("game.chunks")

map = {
    blockSize = 48,
    chunks = {
    },
}

function printTable(t, indent, visited)
    indent = indent or 0
    visited = visited or {}

    if visited[t] then
        print(string.rep(" ", indent) .. "*circular reference*")
        return
    end
    visited[t] = true

    if type(t) ~= "table" then
        print(string.rep(" ", indent) .. tostring(t))
        return
    end

    for k, v in pairs(t) do
        local keyStr = tostring(k)
        if type(v) == "table" then
            print(string.rep(" ", indent) .. keyStr .. " = {")
            printTable(v, indent + 2, visited)
            print(string.rep(" ", indent) .. "}")
        else
            print(string.rep(" ", indent) .. keyStr .. " = " .. tostring(v))
        end
    end
end

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

    local rows = { -- "default" island
        {{land = chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land =chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "snow"}},
        {{land = chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land =chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "snow"}},
        {{land = chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land =chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "snow"}},
        {{land = chunks.noLandd, biome = "snow"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.special, biome = "grass"}, {land = chunks.noLandd, biome = "sand"}, {land = chunks.noLandd, biome = "grass"}, {land = chunks.noLandd, biome = "snow"}},
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