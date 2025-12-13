entities = {
    ents = {{tileX = 1, tileY = 1, col = {.5,.5,.5,1}}}, --all entity data stored here!
}

function entities.render()
    local renderDistance = settings.graphic.renderDistance^2
    local defaultColor = { 1, 1, 1, 1 }
    local px, py = player.position.tileX, player.position.tileY
    for index, value in ipairs(entities.ents) do
        local dx = value.tileX - px
        local dy = value.tileY - py
        local d = dx*dx + dy*dy
        --love.graphics.print(d, 10, 45)
        if d <= renderDistance then
            love.graphics.setColor(value.col or defaultColor)
            local posX, posY = renderer.getAbsolutePos(value.tileX * map.tileSize, value.tileY * map.tileSize)
            love.graphics.rectangle("fill", posX, posY, map.tileSize,
            map.tileSize)
        end
    end
end

return entities