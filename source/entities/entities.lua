entities = {
    ents = {{tileX = 1, tileY = 1, col = {.5,.5,.5,1}}}, --all entity data stored here!
}

function entities.render()
    for key, value in pairs(entities.ents) do
        local dx = value.tileX - player.position.tileX
        local dy = value.tileY - player.position.tileY
        local d = dx*dx + dy*dy
        love.graphics.print(d, 10, 45)
        if d <= settings.graphic.renderDistance^2 then
            love.graphics.setColor(value.col or {1,1,1,1})
            posX, posY = renderer.getAbsolutePos(value.tileX * map.tileSize, value.tileY * map.tileSize)
            love.graphics.rectangle("fill", posX, posY, map.tileSize,
            map.tileSize)
        end
    end
end

return entities