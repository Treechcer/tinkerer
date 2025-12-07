player = require("source.game.player")
spw = require("source.assets.sprites.spriteWorker")

renderer = {}

function renderer.gameStateRenderer() -- rendere everything when it's gamestate
    --love.graphics.rectangle("fill", player.cursor.tileX * map.tileSize, player.cursor.tileY * map.tileSize, map.tileSize, map.tileSize)
    cursor = spw.sprites.cursor
    love.graphics.draw(cursor.sprs[cursor.index], player.cursor.tileX * map.tileSize, player.cursor.tileY * map.tileSize,
    0, map.tileSize / cursor.sprs[cursor.index]:getWidth(), map.tileSize / cursor.sprs[cursor.index]:getHeight())

    x, y = renderer.getAbsolutePos(player.position.x, player.position.y)
    love.graphics.rectangle("fill", x, y, player.size.width, player.size.height)
end

function renderer.menuStateRenderer() -- render when it's menu time

end

function renderer.getAbsolutePos(x, y) -- this gets the absolute postion relative to camera 
    tempX = x + player.camera.x
    tempY = y + player.camera.y
    
    return tempX, tempY
end

return renderer