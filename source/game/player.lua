player = {
    position = {
        x = 50,
        y = 50
    },
    cursor = {
        x = love.mouse.getX(),
        y = love.mouse.getY()
    }
}

function player.cursor.updatePos()
    player.cursor.x = love.mouse.getX()
    player.cursor.y = love.mouse.getY()
end

return player