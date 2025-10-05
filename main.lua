love = require("love")

_G.ver = "0.0.23"

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

    map.init()
    player.init()

    spawner.createObject(30, 30, "rock", {hp = 5})
end

function love.draw()
    love.graphics.setBackgroundColor(0,0,1)
    --love.graphics.print(player.cursorPos.x, 50, 50)
    --love.graphics.print(player.cursorPos.y, 50, 75)

    for chunkY, rowChunks in ipairs(map.chunks) do
        for chunkX, chunk in ipairs(rowChunks) do
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

                        status, err = pcall(function ()
                            if chunk.land[by][bx + 1] ~= 1 then
                                tempSize = camera.calculateZoom(1,1,1,2.5)
                                love.graphics.setLineWidth(tempSize.width)
                                love.graphics.line(adjPos.x + adjPos.width, adjPos.y, adjPos.x + adjPos.width, adjPos.y + adjPos.height)
                            end
                        end)

                        status, err = pcall(function ()
                            if chunk.land[by][bx - 1] ~= 1 then
                                tempSize = camera.calculateZoom(1,1,1,2)
                                love.graphics.setLineWidth(tempSize.width)
                                love.graphics.line(adjPos.x, adjPos.y, adjPos.x, adjPos.y + adjPos.height)
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
        end
    end

    love.graphics.setColor(1, 1, 1)
    adjPos = camera.calculateZoom(player.x, player.y, player.height, player.width)
    love.graphics.rectangle("fill", adjPos.x, adjPos.y, adjPos.width, adjPos.height)
    player.drawItem(spriteLoader)

    spawner.drawObjs(spriteLoader)

    player.cursor(spriteLoader)
    player.drawInventory(spriteLoader)
end

function love.update(dt)
    if love.keyboard.isDown("q") then
        camera.zoom = camera.zoom + (1 * dt)
        if camera.zoom >= 1.80 then
            camera.zoom = 1.80
        end
    elseif love.keyboard.isDown("e") then
        camera.zoom = camera.zoom - (1 * dt)
        if camera.zoom <= 0.5 then
            camera.zoom = 0.5
        end
    end

    mov = {x = 0, y = 0}

    if love.keyboard.isDown("w") then
        if map.isGround(player.x + (2 * player.width / 3), player.y - (player.speed * dt) + (2 * player.height / 3)) and map.isGround(player.x + (player.width / 3), player.y - (player.speed * dt) + (player.height / 3)) then
            mov.y = - (player.speed * dt)
            --player.y = player.y - (player.speed * dt)
            --camera.y = camera.y - (player.speed * dt)
        end
    elseif love.keyboard.isDown("s") then
        if map.isGround(player.x + (2 * player.width / 3), player.y + (player.speed * dt) + (2 * player.height / 3)) and map.isGround(player.x + (player.width / 3), player.y + (player.speed * dt) + (player.height / 3)) then
            mov.y = (player.speed * dt)
            --player.y = player.y + (player.speed * dt)
            --camera.y = camera.y + (player.speed * dt)
        end
    end

    if love.keyboard.isDown("a") then
        if map.isGround(player.x - (player.speed * dt) + (2 * player.width / 3), player.y + (2 * player.height / 3)) and map.isGround(player.x - (player.speed * dt) + (player.width / 3), player.y + (player.height / 3)) then
            mov.x = - (player.speed * dt)
            --player.x = player.x - (player.speed * dt)
            --camera.x = camera.x - (player.speed * dt)
        end
    elseif love.keyboard.isDown("d") then
        if map.isGround(player.x + (player.speed * dt) + (2 * player.width / 3), player.y + (2 * player.height / 3)) and map.isGround(player.x + (player.speed * dt) + (player.width / 3), player.y + (player.height / 3)) then
            mov.x = (player.speed * dt)
            --player.x = player.x + (player.speed * dt)
            --camera.x = camera.x + (player.speed * dt)
        end
    end

    if mov.x ~= 0 and mov.y ~= 0 then
        local nx, ny = mathLib.normaliseVec(mov.x, mov.y)
        mov.x = nx * player.speed * dt
        mov.y = ny * player.speed * dt
    end

    player.x = player.x + mov.x
    player.y = player.y + mov.y
    camera.x = camera.x + mov.x
    camera.y = camera.y + mov.y


    if love.mouse.isDown(1) and spawner.checkCollision(player.cursorPos.x, player.cursorPos.y) and (player.mine.cooldown <= player.mine.lastMined) and not player.animation.play then
        spawner.damgeObejct(player.cursorPos.x, player.cursorPos.y, player.mine.damage)
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

    if player.animation.play then
        player.itemAnimation(dt)
    end
    player.cooldown(dt)
    actionDelay.delayCounter(dt)
end