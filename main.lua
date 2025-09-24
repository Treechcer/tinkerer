love = require("love")

_G.ver = "0.0.3"

function love.load()
    player = require("game.player")
    camera = require("game.camera")
    game = require("game.game")
    map = require("game.map")

    player.init()
    map.generate({chunks.landd, chunks.landd, chunks.noLandd})
    map.generate({chunks.landd, chunks.noLandd, chunks.landd})
    map.generate({chunks.noLandd, chunks.landd, chunks.noLandd})
end

function love.draw()
    love.graphics.setColor(0.5, 0.5, 0.5)
    for chunkY, rowChunks in ipairs(map.chunks) do
        for chunkX, chunk in ipairs(rowChunks) do
            for by = 1, #chunk do 
                for bx = 1, #chunk[by] do
                    local tile = chunk[by][bx]
                    if tile == 1 then
                        local worldX = (chunkX-1) * #chunk[by] * map.blockSize + (bx-1) * map.blockSize
                        local worldY = (chunkY-1) * #chunk     * map.blockSize + (by-1) * map.blockSize
                        local adjPos = camera.calculateZoom(worldX, worldY, map.blockSize, map.blockSize)
                        love.graphics.rectangle("fill", adjPos.x, adjPos.y, adjPos.width, adjPos.height)
                    end
                end
            end
        end
    end

    love.graphics.setColor(1, 1, 1)
    adjPos = camera.calculateZoom(player.x, player.y, player.height, player.width)
    love.graphics.rectangle("fill", adjPos.x, adjPos.y, adjPos.width, adjPos.height)
end

function love.update(dt)
    if love.keyboard.isDown("q") then
        camera.zoom = camera.zoom + (1 * dt)
    elseif love.keyboard.isDown("e") then
        camera.zoom = camera.zoom - (1 * dt)
    end

    if love.keyboard.isDown("w") then
        if map.isOnGround(player.x, player.y - (player.speed * dt), (player.width / 2), (player.height / 2)) then
            player.y = player.y - (player.speed * dt)
            camera.y = camera.y - (player.speed * dt)
        end
    elseif love.keyboard.isDown("s") then
        if map.isOnGround(player.x, player.y + (player.speed * dt) + (player.height / 2), (player.width / 2), (player.height / 2)) then
            player.y = player.y + (player.speed * dt)
            camera.y = camera.y + (player.speed * dt)
        end
    end

    if love.keyboard.isDown("a") then
        if map.isOnGround(player.x - (player.speed * dt), player.y, (player.width / 2), (player.height / 2)) then
            player.x = player.x - (player.speed * dt)
            camera.x = camera.x - (player.speed * dt)
        end
    elseif love.keyboard.isDown("d") then
        if map.isOnGround(player.x + (player.speed * dt) + (player.width / 2), player.y, (player.width / 2), (player.height / 2)) then
            player.x = player.x + (player.speed * dt)
            camera.x = camera.x + (player.speed * dt)
        end
    end
end