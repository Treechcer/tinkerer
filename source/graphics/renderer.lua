player = require("source.game.player")
spw = require("source.assets.sprites.spriteWorker")
map = require("source.world.map")

renderer = {}

function renderer.mapRender()
    local tileSize = map.tileSize
    local chunkGrid = map.map.chunks

    for chunkY, row in pairs(chunkGrid) do
        for chunkX, chunk in pairs(row) do
            for tileY, tileRow in pairs(chunk) do
                for tileX, tile in pairs(tileRow) do
                    if tile == 1 then
                        love.graphics.setColor(0.5,0.5,0.5)
                        local worldX = ((chunkX - 1) * #chunk[1] + (tileX - 1)) * tileSize
                        local worldY = ((chunkY - 1) * #chunk + (tileY - 1)) * tileSize

                        local CHx, CHy = renderer.getAbsolutePos(worldX, worldY)

                        love.graphics.rectangle("fill", CHx, CHy, tileSize, tileSize)
                    end
                end
            end
        end
    end

    love.graphics.setColor(1,1,1)
end

function renderer.gameStateRenderer() -- rendere everything when it's gamestate
    --love.graphics.rectangle("fill", player.cursor.tileX * map.tileSize, player.cursor.tileY * map.tileSize, map.tileSize, map.tileSize)
    renderer.mapRender()
    cursor = spw.sprites.cursor
    love.graphics.draw(cursor.sprs[cursor.index], player.cursor.tileX * map.tileSize, player.cursor.tileY * map.tileSize,
    0, map.tileSize / cursor.sprs[cursor.index]:getWidth(), map.tileSize / cursor.sprs[cursor.index]:getHeight())

    x, y = renderer.getAbsolutePos(player.position.x, player.position.y)
    love.graphics.rectangle("fill", x, y, player.size.width, player.size.height)

    love.graphics.rectangle("fill", player.position.absX * map.tileSize, player.position.absY * map.tileSize,
        map.tileSize, map.tileSize)
end

function renderer.menuStateRenderer() -- render when it's menu time

end

function renderer.getAbsolutePos(x, y) -- this gets the absolute postion relative to camera
    tempX = x - player.camera.x
    tempY = y - player.camera.y

    return tempX, tempY
end

function renderer.calculateTile(x, y)
    local xT = math.floor(x / map.tileSize)
    local yT = math.floor(y / map.tileSize)

    return xT,yT
end

return renderer