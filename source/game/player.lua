player = {
    position = {
        x = 50,
        y = 50
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
    }
}

function player.cursor.updatePos()
    player.cursor.x = love.mouse.getX()
    player.cursor.y = love.mouse.getY()

    player.cursor.tileX = math.floor(player.cursor.x / map.tileSize)
    player.cursor.tileY = math.floor(player.cursor.y / map.tileSize)
end

return player