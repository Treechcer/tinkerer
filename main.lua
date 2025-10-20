love = require("love")

_G.ver = "0.0.36"

function love.load()
    love.graphics.setDefaultFilter("nearest")

    player = require("game.player")
    camera = require("game.camera")
    game = require("game.game")
    map = require("game.map")
    spawner = require("game.spawner")
    spriteLoader = require("sprites.spriteLoader")
    actionDelay = require("game.actionDelay")
    mathLib = require("libraries.mathLib")
    itemIdex = require("game.itemIndex")
    soundLoader = require("sounds.soundLoader")

    map.init()
    player.init()

    --spawner.createObject(30, 32, "rock", {hp = 5, drop = {count = 5, item = "rock"}, dmgType = "stoneDMG"}, false, true, 1, 1)
    --spawner.createObject(30, 31, "rock", {hp = 5, drop = {count = 5, item = "rock"}, dmgType = "stoneDMG"}, false, false, 1, 1)
end

function love.draw()
    love.graphics.setBackgroundColor(0,0,1)
    --love.graphics.print(player.cursorPos.x, 50, 50)
    --love.graphics.print(player.cursorPos.y, 50, 75)
    --love.graphics.print(math.floor(player.x / map.blockSize), 50, 50)
    --love.graphics.print(math.floor(player.y / map.blockSize), 50, 75)

    for chunkY, rowChunks in ipairs(map.chunks) do
        for chunkX, chunk in ipairs(rowChunks) do
            if not chunk.owned then
                goto continue
            end
            for by = 1, #chunk.land do
                for bx = 1, #chunk.land[by] do
                    local tile = chunk.land[by][bx]
                    if tile == 1 then
                        love.graphics.setColor(1, 1, 1)
                        local worldX = (chunkX-1) * #chunk.land[by] * map.blockSize + (bx-1) * map.blockSize
                        local worldY = (chunkY-1) * #chunk.land * map.blockSize + (by-1) * map.blockSize
                        local adjPos = camera.calculateZoom(worldX, worldY, map.blockSize, map.blockSize)

                        love.graphics.draw(spriteLoader[chunk.biome], adjPos.x, adjPos.y, 0, adjPos.width / spriteLoader[chunk.biome]:getWidth(), adjPos.width / spriteLoader[chunk.biome]:getHeight())
                        love.graphics.setColor(0, 0, 0)

                        --Outline in Y

                        status, err = pcall(function()
                            local rightTile
                            if bx < #chunk.land[by] then
                                rightTile = chunk.land[by][bx + 1]
                            else
                                local rightChunk = map.chunks[chunkY] and map.chunks[chunkY][chunkX + 1]
                                if rightChunk then
                                    rightTile = rightChunk.land[by][1]
                                else
                                    rightTile = 0
                                end
                            end

                            if rightTile ~= 1 then
                                local tempSize = camera.calculateZoom(1, 1, 1, 2.5)
                                love.graphics.setLineWidth(tempSize.width)
                                love.graphics.line(
                                    adjPos.x + adjPos.width, adjPos.y,
                                    adjPos.x + adjPos.width, adjPos.y + adjPos.height
                                )
                            end
                        end)

                        status, err = pcall(function()
                            local leftTile
                            if bx > 1 then
                                leftTile = chunk.land[by][bx - 1]
                            else
                                local leftChunk = map.chunks[chunkY] and map.chunks[chunkY][chunkX - 1]
                                if leftChunk then
                                    leftTile = leftChunk.land[by][#leftChunk.land[by]]
                                else
                                    leftTile = 0
                                end
                            end

                            if leftTile ~= 1 then
                                local tempSize = camera.calculateZoom(1, 1, 1, 2)
                                love.graphics.setLineWidth(tempSize.width)
                                love.graphics.line(
                                    adjPos.x, adjPos.y,
                                    adjPos.x, adjPos.y + adjPos.height
                                )
                            end
                        end)

                        --Outline in X
                    
                        status, err = pcall(function()
                            local belowTile
                            if by < #chunk.land then
                                belowTile = chunk.land[by + 1][bx]
                            else
                                belowChunk = map.chunks[chunkY + 1] and map.chunks[chunkY + 1][chunkX]
                                if belowChunk then
                                    belowTile = belowChunk.land[1][bx]
                                else
                                    belowTile = 0
                                end
                            end
                            if belowTile ~= 1 then
                                tempSize = camera.calculateZoom(1,1,1,2)
                                love.graphics.setLineWidth(tempSize.width)
                                love.graphics.line(adjPos.x, adjPos.y + adjPos.height, adjPos.x + adjPos.height, adjPos.y + adjPos.height)
                            end
                        end)

                        status, err = pcall(function()
                            local aboveTile
                            if by > 1 then
                                aboveTile = chunk.land[by - 1][bx]
                            else
                                local aboveChunk = map.chunks[chunkY - 1] and map.chunks[chunkY - 1][chunkX]
                                if aboveChunk then
                                    aboveTile = aboveChunk.land[#aboveChunk.land][bx]
                                else
                                    aboveTile = 0
                                end
                            end
                            if aboveTile ~= 1 then
                                local tempSize = camera.calculateZoom(1,1,1,2)
                                love.graphics.setLineWidth(tempSize.width)
                                love.graphics.line(adjPos.x, adjPos.y, adjPos.x + adjPos.width, adjPos.y)
                            end
                        end)

                        --love.graphics.rectangle("fill", adjPos.x, adjPos.y, adjPos.width, adjPos.height)
                    end
                end
            end
            ::continue::
        end
    end

    love.graphics.setColor(1, 1, 1)
    adjPos = camera.calculateZoom(player.x, player.y, player.height, player.width)
    love.graphics.rectangle("fill", adjPos.x, adjPos.y, adjPos.width, adjPos.height)

    spawner.drawObjs(spriteLoader)
    player.drawItem(spriteLoader)

    player.cursor(spriteLoader)
    player.drawInventory(spriteLoader)
    if uiData.interactible.draw then
        uiData.interactibleDraw(player.cursorPos.x * map.blockSize, player.cursorPos.y * map.blockSize)
    end
end

function love.update(dt)
    spawner.spawnRandomObject()
    if love.keyboard.isDown("q") then
        camera.zoom = camera.zoom + (1 * dt)
        if camera.zoom >= 50 then
            camera.zoom = 50
        end
    elseif love.keyboard.isDown("e") then
        camera.zoom = camera.zoom - (1 * dt)
        if camera.zoom <= 0.5 then
            camera.zoom = 0.5
        end
    end

    --print(spawner.objCol(math.floor(player.x / map.blockSize), math.floor(player.y / map.blockSize)))

    mov = {x = 0, y = 0}

    --old movement code lol

    --[[if love.keyboard.isDown("w") then
        if map.isGround(player.x + (2 * player.width / 3), player.y - (player.speed * dt) + (2 * player.height / 3))
        and map.isGround(player.x + (player.width / 3), player.y - (player.speed * dt) + (player.height / 3))
        and not spawner.objCol(math.floor(player.x / map.blockSize), math.floor(player.y / map.blockSize), player.width, player.height) then
            mov.y = - (player.speed * dt)
            --player.y = player.y - (player.speed * dt)
            --camera.y = camera.y - (player.speed * dt)
        end
    elseif love.keyboard.isDown("s") then
        if map.isGround(player.x + (2 * player.width / 3), player.y + (player.speed * dt) + (2 * player.height / 3)) and map.isGround(player.x + (player.width / 3), player.y + (player.speed * dt) + (player.height / 3))
        and not spawner.objCol(math.floor(player.x / map.blockSize), math.floor(player.y / map.blockSize), player.width, player.height) then
            mov.y = (player.speed * dt)
            --player.y = player.y + (player.speed * dt)
            --camera.y = camera.y + (player.speed * dt)
        end
    end

    if love.keyboard.isDown("a") then
        if map.isGround(player.x - (player.speed * dt) + (2 * player.width / 3), player.y + (2 * player.height / 3)) and map.isGround(player.x - (player.speed * dt) + (player.width / 3), player.y + (player.height / 3))
        and not spawner.objCol(math.floor(player.x / map.blockSize), math.floor(player.y / map.blockSize), player.width, player.height) then
            mov.x = - (player.speed * dt)
            --player.x = player.x - (player.speed * dt)
            --camera.x = camera.x - (player.speed * dt)
        end
    elseif love.keyboard.isDown("d") then
        if map.isGround(player.x + (player.speed * dt) + (2 * player.width / 3), player.y + (2 * player.height / 3)) and map.isGround(player.x + (player.speed * dt) + (player.width / 3), player.y + (player.height / 3))
        and not spawner.objCol(math.floor(player.x / map.blockSize), math.floor(player.y / map.blockSize), player.width, player.height) then
            mov.x = (player.speed * dt)
            --player.x = player.x + (player.speed * dt)
            --camera.x = camera.x + (player.speed * dt)
        end
    end]]

    if love.keyboard.isDown("w") then
        mov.y = - (player.speed * dt)
    elseif love.keyboard.isDown("s") then
        mov.y = (player.speed * dt)

    end

    if love.keyboard.isDown("a") then
        mov.x = -(player.speed * dt)
    elseif love.keyboard.isDown("d") then
        mov.x = (player.speed * dt)
    end

    if mov.x ~= 0 or mov.y ~= 0 then
        local nx, ny = mathLib.normaliseVec(mov.x, mov.y)
        local nextX = player.x + nx * player.speed * dt
        local nextY = player.y + ny * player.speed * dt

        local canMoveX = map.isGround(nextX + player.width / 2, player.y + player.height / 2) and not spawner.objCol(nextX, player.y, player.width, player.height)
        if canMoveX then
            player.x = nextX
            camera.x = camera.x + nx * player.speed * dt
        end

        local canMoveY = map.isGround(player.x + player.width / 2, nextY + player.height / 2) and not spawner.objCol(player.x, nextY, player.width, player.height)
        if canMoveY then
            player.y = nextY
            camera.y = camera.y + ny * player.speed * dt
        end
    end

    if love.mouse.isDown(1) and spawner.checkCollision(player.cursorPos.x, player.cursorPos.y) and (player.mine.cooldown <= player.mine.lastMined) and not player.animation.play then
        love.audio.play(soundLoader.miscSounds.hitSound)
        soundLoader.miscSounds.hitSound:setPitch(math.random(60, 140) / 100)
        
        dmg = spawner.getDmgNum(player.cursorPos.x, player.cursorPos.y)
        --print(dmg)
        spawner.damgeObejct(player.cursorPos.x, player.cursorPos.y, dmg)
        player.mine.lastMined = 0

        player.animation.time = 0
        player.animation.timeToChangeCoe = player.mine.cooldown / 2
        player.animation.animLength = player.mine.cooldown
        player.animation.play = true
    elseif love.mouse.isDown(1) and not player.animation.play then
        player.mine.lastMined = 0

        player.animation.time = 0
        player.animation.timeToChangeCoe = player.mine.cooldown / 2
        player.animation.animLength = player.mine.cooldown
        player.animation.play = true
    end

    if love.mouse.isDown(2) then
        itemIdex.makeItemUsable(player.inventory.currentEquip)
    end

    if spawner.checkCollision(player.cursorPos.x, player.cursorPos.y) then
        local obj = spawner.getObject(player.cursorPos.x, player.cursorPos.y)
        if obj.isInteractable then
            uiData.interactible.draw = true
        end
    elseif not spawner.checkCollision(player.cursorPos.x, player.cursorPos.y) and uiData.interactible.draw then
        uiData.interactible.draw = false
    end

    if player.animation.play then
        player.itemAnimation(dt)
    end
    player.cooldown(dt)
    actionDelay.delayCounter(dt)
end

function love.wheelmoved(x, y)
    if player.inventory.lastItemSwitch >= player.inventory.itemSwitchCD and y > 0 then
        player.inventory.inventoryIndex = player.inventory.inventoryIndex + 1
        if player.inventory.inventoryIndex >= #player.inventory.items then
            player.inventory.inventoryIndex = #player.inventory.items
        else
            player.inventory.lastItemSwitch = 0
        end
        player.inventory.currentEquip = player.inventory.items[player.inventory.inventoryIndex].name

        itemIdex.changeCursor(player.inventory.currentEquip)
    elseif player.inventory.lastItemSwitch >= player.inventory.itemSwitchCD and y < 0 then
        player.inventory.inventoryIndex = player.inventory.inventoryIndex - 1
        if player.inventory.inventoryIndex <= 1 then
            player.inventory.inventoryIndex = 1
        else
            player.inventory.lastItemSwitch = 0
        end
        player.inventory.currentEquip = player.inventory.items[player.inventory.inventoryIndex].name

        itemIdex.changeCursor(player.inventory.currentEquip)
    end
end