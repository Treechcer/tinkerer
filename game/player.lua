player = {
    x = 0,
    y = 0,
    width = 32,
    height = 32,
    speed = 100
}

function player.init()
    camera = require("game.camera")
    map = require("game.map")
    player.x = (map.blockSize * ((#map.chunks * 9) - 5)) / 2
    player.y = (map.blockSize * ((#map.chunks * 9) - 5)) / 2
    camera.x = player.x + (player.width / 2)
    camera.y = player.y + (player.height / 2)
end

return player