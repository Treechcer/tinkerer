player = {
    x = 0,
    y = 0,
    width = 25,
    height = 25,
    speed = 100
}

function player.init()
    game = require("game.game")
    player.x = game.width / 2
    player.y = game.height / 2
end

return player