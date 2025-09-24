player = {
    x = 0,
    y = 0,
    width = 25,
    height = 25,
    speed = 100
}

function player.init()
    game = require("game.game")
    player.x = 0
    player.y = 0
end

return player