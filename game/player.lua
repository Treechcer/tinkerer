map = require("game.map")

player = {
    x = 0,
    y = 0,
    width = 32,
    height = 32,
    speed = 100,
    cursorPos = {
        x = 0,
        y = 0
    }
}

function player.init()
    local camera = require("game.camera")
    local map = require("game.map")

    player.x = (map.blockSize * ((#map.chunks * 9) - 5)) / 2
    player.y = (map.blockSize * ((#map.chunks * 9) - 5)) / 2
    camera.x = player.x + (player.width / 2)
    camera.y = player.y + (player.height / 2)
end

function player.cursor(sprites)
    local camera = require("game.camera")
    local map = require("game.map")
    local game = require("game.game")

    local x, y = love.mouse.getPosition()

    local blockX, blockY = map.screenPosToBlock(x, y)

    local adjPos = camera.calculateZoom(blockX, blockY, map.blockSize, map.blockSize)

    local frame = math.floor(love.timer.getTime() * 7.5) % #sprites.cursor + 1

    player.cursorPos.x = math.floor(blockX / map.blockSize)
    player.cursorPos.y = math.floor(blockY / map.blockSize)

    love.graphics.setColor(1,1,1)
    love.graphics.draw(sprites.cursor[frame], adjPos.x, adjPos.y, 0, adjPos.width / sprites.cursor[frame]:getWidth(), adjPos.height / sprites.cursor[frame]:getHeight())
end

return player