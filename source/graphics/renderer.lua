player = require("source.player.player")
spw = require("source.workers.spriteWorker")
map = require("source.world.map")

renderer = {}

function renderer.mapRender()
    local tileSize = map.tileSize
    local chunkGrid = map.map.chunks

    for chunkY, row in pairs(chunkGrid) do
        for chunkX, chunk in pairs(row) do
            if chunk.owned then
                for tileY, tileRow in pairs(chunk.chunkData) do
                    for tileX, tile in pairs(tileRow) do
                        if tile == 1 then
                            --love.graphics.setColor(chunk.colorScheme)
                            local worldX = ((chunkX - 1) * #chunk.chunkData[1] + (tileX - 1)) * tileSize
                            local worldY = ((chunkY - 1) * #chunk.chunkData + (tileY - 1)) * tileSize

                            local CHx, CHy = renderer.getAbsolutePos(worldX, worldY)

                            --love.graphics.rectangle("fill", CHx, CHy, tileSize, tileSize)
                            local sprt = biomeData[chunk.biome].sprite
                            --print(sprt)
                            love.graphics.draw(sprt, CHx, CHy, 0, tileSize / sprt:getWidth(), tileSize / sprt:getHeight())
                        end
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

    --love.graphics.print(player.vals.state, 10, 10)

    x, y = renderer.getAbsolutePos(player.position.x, player.position.y)
    if player.vals.walking and player.vals.state == "walking" then
        dudeSpr = spw.sprites.dudeWalking.sprs[spw.sprites.dudeWalking.index]
    elseif player.vals.state == "sitting" then
        dudeSpr = spw.sprites.dude_sitting.sprs
    else
        dudeSpr = spw.sprites.dude.sprs[1]
    end

    love.graphics.draw(dudeSpr, x + player.size.width / 2, y + player.size.height / 2, 0, (player.size.width / dudeSpr:getWidth()) * (player.cursor.screenSide), player.size.height / dudeSpr:getHeight(), dudeSpr:getWidth() / 2, dudeSpr:getHeight() / 2)
    --love.graphics.rectangle("fill", x, y, player.size.width, player.size.height)
    --love.graphics.rectangle("fill", player.position.absX * map.tileSize, player.position.absY * map.tileSize,
    --    map.tileSize, map.tileSize)

    local xT, yT = renderer.getAbsolutePos(player.position.x, player.position.y)
    local i = inventory.inventoryBar.inventory

    local cursorHeight, cursorWidth = player.cursor.height, player.cursor.width

    if i[#i][inventory.hotBar.selectedItem] ~= nil and next(i[#i][inventory.hotBar.selectedItem]) ~= nil then
        local moveX = player.floatyMovement.timeX / player.floatyMovement.maxTimeX
        local moveY = player.floatyMovement.timeY / player.floatyMovement.maxTimeY

        player.floatyMovement.x = mathWorker.lerp(player.floatyMovement.x, player.floatyMovement.maxX, (moveX < 1) and moveX or 1)
        player.floatyMovement.y = mathWorker.lerp(player.floatyMovement.y, player.floatyMovement.maxY, (moveY < 1) and moveY or 1)
        local itemName = i[#i][inventory.hotBar.selectedItem].item

        local spr = spw.sprites[itemName].sprs
        love.graphics.draw(spr,
            (game.width / 2) + ((player.size.width * 0.75 + (map.tileSize * itemIndex[itemName].width / 5)) * player.cursor.screenSide) + player.floatyMovement.x,
            yT + player.size.height / 3 + player.floatyMovement.y,
            inventory.hotBar.moveVal * player.cursor.screenSide,
            (map.tileSize * itemIndex[itemName].width) / spr:getWidth() * player.cursor.screenSide,
            (map.tileSize * itemIndex[itemName].height) / spr:getHeight(),
            spr:getWidth() / 2,
            spr:getHeight() / 2)
        if itemIndex[itemName].buildable then

            cursorHeight, cursorWidth = itemIndex[itemName].height, itemIndex[itemName].width

            sx, sy = renderer.getAbsolutePos(renderer.getWorldPos(player.cursor.tileX, player.cursor.tileY))

            if entities.isEntityOnTile(player.cursor.tileX, player.cursor.tileY, itemIndex[itemName].width, itemIndex[itemName].height) == -1 and building.f.canBuild(itemName) then
                building.f.render(spr, sx, sy, 1 * map.tileSize, 1 * map.tileSize, itemName)
            else
                building.f.renderIncorrect(spr, sx, sy, 1 * map.tileSize, 1 * map.tileSize, itemName)
            end
        end
        
        --local itemName = i[#i][inventory.hotBar.selectedItem].item
        --local enData = entitiesIndex[itemName]
        --building.f.build(player.cursor.tileX, player.cursor.tileY, enData.width, enData.height, itemName)
        
        --love.graphics.print(inventory.hotBar.moveVal * player.cursor.screenSide, 10, 75)
    end

    local cursorWorldPosX, cursorWorldPosY = renderer.getWorldPos(player.cursor.tileX + (math.ceil(cursorWidth / 2) - 1), player.cursor.tileY + (math.ceil(cursorWidth / 2) - 1))
    if (renderer.checkCollsion(cursorWorldPosX, cursorWorldPosY)) then
        local cursor = spw.sprites.cursor
        local sx, sy = renderer.getAbsolutePos(renderer.getWorldPos(player.cursor.tileX, player.cursor.tileY))
        love.graphics.draw(cursor.sprs[cursor.index], sx, sy,
            0, (map.tileSize * cursorWidth) / cursor.sprs[cursor.index]:getWidth(),
            (map.tileSize * cursorHeight) / cursor.sprs[cursor.index]:getHeight())
    elseif not renderer.getChunkData(cursorWorldPosX, cursorWorldPosY, "owned") then
        local xTile = math.floor(cursorWorldPosX / map.tileSize) + 1
        local yTile = math.floor(cursorWorldPosY / map.tileSize) + 1

        local chunkX = math.floor((xTile - 1) / map.chunkWidth) + 1
        local chunkY = math.floor((yTile - 1) / map.chunkHeight) + 1

        player.cursor.chunkX = chunkX
        player.cursor.chunkY = chunkY

        if not (chunkX <= 0 or chunkY <= 0) and chunkY <= map.chunkHeightNum and chunkX <= map.chunkWidthNum then
            local worldX = (chunkX - 1) * map.chunkWidth * map.tileSize
            local worldY = (chunkY - 1) * map.chunkHeight * map.tileSize

            local absX, absY = renderer.getAbsolutePos(worldX, worldY)

            --love.graphics.rectangle("fill", absX, absY, map.chunkWidth * map.tileSize, map.chunkHeight * map.tileSize)
            local cursorBuyer = spw.sprites.cursorBuy
            local spr = cursorBuyer.sprs[cursorBuyer.index]
            love.graphics.draw(spr, absX, absY, 0, (map.chunkWidth * map.tileSize) / spr:getWidth(), (map.chunkWidth * map.tileSize) / spr:getHeight())

            --map.f.buyIsland(chunkX, chunkY)
        end
    end

    inventory.functions.renderHotbar()
    inventory.functions.renderWholeInventory()
    --ENABLE THIS FOR PSP RELEASE!!! IF THERE EVER BE ONE!
    --if game.os == "PSP" then -- not rewriting the while functions just because PSP
    --    inventory.functions.click()
    --end

    inventory.functions.renderItemOnCursor(renderer.getAbsolutePos(player.cursor.x, player.cursor.y))
    skillUI.f.render()
end

function renderer.menuStateRenderer() -- render when it's menu time

end

function renderer.getWorldPos(x,y) -- this gets you world position **from tile**
    local wx = x * map.tileSize
    local wy = y * map.tileSize

    return wx, wy
end

function renderer.getAbsolutePos(x, y) -- this gets the absolute postion relative to camera 
    local tempX = x - player.camera.x
    local tempY = y - player.camera.y

    return tempX, tempY
end

function renderer.calculateTile(x, y)
    local xT = math.floor(x / map.tileSize)
    local yT = math.floor(y / map.tileSize)

    return xT,yT
end

function renderer.checkCollsionWidthHeight(tileX, tileY, width, height)
    for x=0, width - 1 do
        for y=0, height - 1 do
            local worldXpos, worldYpos = renderer.getWorldPos(tileX + x, tileY + y)
            if not renderer.checkCollsion(worldXpos, worldYpos) then
                return false
            end
        end
    end

    return true
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

    return chunk.chunkData[tileInChunkY][tileInChunkX] ~= 0 and chunk.owned
end

function renderer.getChunkData(worldXpos, worldYpos, atr) --uses worldPos
    local xTile, yTile = renderer.calculateTile(worldXpos, worldYpos)
    local xTile = xTile + 1
    local yTile = yTile + 1

    if xTile <= 0 or yTile <= 0 then
        return nil
    end

    local chunkX = math.floor((xTile - 1) / map.chunkWidth) + 1
    local chunkY = math.floor((yTile - 1) / map.chunkHeight) + 1

    local chunk = map.map.chunks[chunkY] and map.map.chunks[chunkY][chunkX]

    if not chunk then
        return nil
    end

    return chunk[atr]
end

function renderer.AABB(aX, aY, aW, aH, bX, bY, bW, bH)
    if aX < bX + bW and aX + aW > bX and aY < bY + bH and aY + aH > bY then
        return true
    end

    return false
end

return renderer