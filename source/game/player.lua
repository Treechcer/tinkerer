local game = require("source.game.game")

player = {
    position = {
        x = 0,
        y = 0
    },
    size = {
        width = 48,
        height = 96
    },
    cursor = {
        x = love.mouse.getX(),
        y = love.mouse.getY(),

        tileX = 0,
        tileY = 0,

        frameNum = 0,
    },
    camera = {
        x = 0,
        y = 0,
    },
    atributes = {
        speed = 250
    }
}

function player.init() -- initialises the position of player
    player.position.x = math.floor(game.width / 2 - player.size.width / 2)
    player.position.y = math.floor(game.height / 2 - player.size.height / 2)
end

function player.cursor.updatePos() -- updates mouse position every frame - even calculates the tiles it's on
    player.cursor.x = love.mouse.getX()
    player.cursor.y = love.mouse.getY()

    player.cursor.tileX = math.floor(player.cursor.x / map.tileSize)
    player.cursor.tileY = math.floor(player.cursor.y / map.tileSize)
end

return player