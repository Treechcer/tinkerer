game = require("game.game")

camera = {
    x = 0,
    y = 0,
    zoom = 1
}

function camera.calculateZoom(x, y, height, width)
    --(player.x - camera.x) / camera.zoom + (game.width / 2) * (1 / camera.zoom)
    --(player.y - camera.y) / camera.zoom + (game.height / 2) * (1 / camera.zoom)
    --player.width / camera.zoom 
    --player.height / camera.zoom

    posX = (x - camera.x) / camera.zoom  * (1 / camera.zoom)
    posY = (y - camera.y) / camera.zoom * (1 / camera.zoom)
    pWidth = width / camera.zoom
    pHeight = height / camera.zoom

    return {x = posX, y = posY, height = pHeight, width = pWidth}
end

return camera