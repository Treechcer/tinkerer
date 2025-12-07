love = require("love")

function love.load()
    player = require("source.game.player")
    map = require("source.world.map")
    REF = require("source.game.runEveryFrame")
end

function love.draw()
    love.graphics.rectangle("fill", player.cursor.x, player.cursor.y, map.tileSize, map.tileSize)
end

function love.update(dt)
    REF.everyFrameStart(dt)

    REF.everyFrameEnd(dt)
end