player = require("source.game.player")
spw = require("source.assets.sprites.spriteWorker")
map = require("source.world.map")

renderer = {}

function renderer.mapRender()
    local tileSize = map.tileSize
    local chunkGrid = map.map.chunks

    for chunkY, row in pairs(chunkGrid) do
        for chunkX, chunk in pairs(row) do
            for tileY, tileRow in pairs(chunk.chunkData) do
                for tileX, tile in pairs(tileRow) do
                    if tile == 1 then
                        love.graphics.setColor(chunk.colorScheme)
                        local worldX = ((chunkX - 1) * #chunk.chunkData[1] + (tileX - 1)) * tileSize
                        local worldY = ((chunkY - 1) * #chunk.chunkData + (tileY - 1)) * tileSize

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
    entities.render()
    cursor = spw.sprites.cursor

    local sx, sy = renderer.getAbsolutePos(renderer.getWorldPos(player.cursor.tileX, player.cursor.tileY))
    if (renderer.checkCollsion(renderer.getWorldPos(player.cursor.tileX, player.cursor.tileY))) then
        love.graphics.draw(cursor.sprs[cursor.index], sx, sy,
            0, map.tileSize / cursor.sprs[cursor.index]:getWidth(), map.tileSize / cursor.sprs[cursor.index]:getHeight())
    end
        x, y = renderer.getAbsolutePos(player.position.x, player.position.y)
        love.graphics.rectangle("fill", x, y, player.size.width, player.size.height)
    --love.graphics.rectangle("fill", player.position.absX * map.tileSize, player.position.absY * map.tileSize,
    --    map.tileSize, map.tileSize)
    inventory.functions.renderHotbar()

    local xT, yT = renderer.getAbsolutePos(player.position.x, player.position.y)

    if inventory.hotBar.items[inventory.hotBar.selectedItem] ~= nil then
        local spr = spw.sprites[inventory.hotBar.items[inventory.hotBar.selectedItem].item].sprs
        local bonus = (player.cursor.screenSide == -1) and map.tileSize or 0
        love.graphics.draw(spr,
        xT + (map.tileSize * player.cursor.screenSide) + bonus + 1 / 2 * (map.tileSize * player.cursor.screenSide),
            yT + player.size.height / 3, inventory.hotBar.moveVal,
            map.tileSize / spr:getWidth() * player.cursor.screenSide,
            map.tileSize / spr:getHeight(),
            spr:getWidth() / 2,
            spr:getHeight() / 2)
    end
end

function renderer.menuStateRenderer() -- render when it's menu time

end

function renderer.getWorldPos(x,y) -- this gets you world position **from tile**
    wx = x * map.tileSize
    wy = y * map.tileSize

    return wx, wy
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

function renderer.checkCollsion(worldXpos, worldYpos)
    local xTile, yTile = renderer.calculateTile(worldXpos, worldYpos)
    xTile = xTile + 1
    yTile = yTile + 1

    if xTile <= 0 or yTile <= 0 then
        return false
    end

    local chunkX = math.floor((xTile - 1) / map.chunkWidth) + 1
    local chunkY = math.floor((yTile - 1) / map.chunkHeight) + 1

    local tileInChunkX = ((xTile - 1) % map.chunkWidth) + 1
    local tileInChunkY = ((yTile - 1) % map.chunkHeight) + 1

    local chunk = map.map.chunks[chunkY] and map.map.chunks[chunkY][chunkX]

    if not chunk then
        return false
    end
    return not (chunk.chunkData[tileInChunkY][tileInChunkX] == 0)
end

return renderer