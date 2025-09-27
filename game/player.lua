player = {
    x = 0,
    y = 0,
    width = 25,
    height = 25,
    speed = 100
}

function player.init()
    camera = require("game.camera")
    map = require("game.map")
    player.x = (map.blockSize * ((#map.chunks * 9) - 5)) / 2
    player.y = (map.blockSize * ((#map.chunks * 9) - 5)) / 2
    camera.x = player.x
    camera.y = player.y
end

return player