player = require("source.game.player")
spw = require("source.assets.sprites.spriteWorker")

renderer = {}

function renderer.gameStateRenderer()
    --love.graphics.rectangle("fill", player.cursor.tileX * map.tileSize, player.cursor.tileY * map.tileSize, map.tileSize, map.tileSize)
    cursor = spw.sprites.cursor
    love.graphics.draw(cursor.sprs[cursor.index], player.cursor.tileX * map.tileSize, player.cursor.tileY * map.tileSize,
        0, map.tileSize / cursor.sprs[cursor.index]:getWidth(), map.tileSize / cursor.sprs[cursor.index]:getHeight())

    love.graphics.rectangle("fill", player.position.x, player.position.y, player.size.width, player.size.height)
end

function renderer.menuStateRenderer()

end

return renderer