map = require("game.map")

uiData = {
    playerInventory = {
        size = 35,
        space = 5,
        lineSize = 2.5
    },
    interactible = {
        width = map.blockSize,
        height = map.blockSize,
        draw = false,
        delta = 10
    }
}

function uiData.interactibleDraw(x, y)
    local camera = require("game.camera")
    local adjPos = camera.calculateZoom(x, y, uiData.interactible.width, uiData.interactible.height)
    local tempD = uiData.interactible.delta / camera.zoom
    love.graphics.rectangle("fill", adjPos.x + tempD / 2, adjPos.y + tempD / 2, adjPos.width - tempD, adjPos.height - tempD)
    love.graphics.setColor(0,0,0)
    local font = love.graphics.getFont()
    love.graphics.print("F", adjPos.x + tempD / 2 + (adjPos.width - tempD) / 2 - (font:getWidth("F") / 2), adjPos.y + tempD / 2 + (adjPos.height - tempD) / 2 - (font:getHeight() / 2))
end

return uiData