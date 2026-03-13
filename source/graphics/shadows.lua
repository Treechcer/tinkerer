shadows = {
    angle = 0,
    offset = {x = 0, y = 0},
    strenght = 0.35,
    functions = {},
    shadows = {
        --{pos ={x, y}, sprite = spriteName, width, height}
    }
}

function shadows.functions.newShadow(x, y, spriteName)
    spriteName = "circle"
    table.insert(shadows.shadows, {pos = {x = x, y = y}, sprite = spriteName})
end

function shadows.functions.render()
    love.graphics.setColor(0, 0, 0, shadows.strenght)
    for key, value in pairs(shadows.shadows) do
        local x,y = value.pos.x - shadows.offset.x, value.pos.y - shadows.offset.y
        x, y = renderer.getAbsolutePos(x, y)
        local spr = spw.sprites[value.sprite].sprs
        love.graphics.draw(spr, x, y, shadows.angle, (map.tileSize * 0.9) / spr:getWidth(), (map.tileSize * 0.9) / spr:getHeight())
    end
    love.graphics.setColor(1,1,1)
end

return shadows