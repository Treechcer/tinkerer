shadows = {
    angle = -0.5,
    offset = {x = -5, y = -2},
    strenght = 0.35,
    functions = {},
    shadows = {
        --{pos ={x, y}, sprite = spriteName, width, height}
    }
}

function shadows.functions.newShadow(x, y, spriteName, width, height)
    spriteName = spriteName or "circle"
    width = width or 1
    height = height or 1
    table.insert(shadows.shadows, {pos = {x = x, y = y}, sprite = spriteName, width = width, height = height})
end

function shadows.functions.render()
    love.graphics.setColor(0, 0, 0, shadows.strenght)
    for key, value in pairs(shadows.shadows) do
        local x,y = value.pos.x - shadows.offset.x, value.pos.y - shadows.offset.y
        x, y = renderer.getAbsolutePos(x, y)
        local spr = spw.sprites[value.sprite].sprs
        local rotate = (value.sprite == "circle") and 0 or shadows.angle
        love.graphics.draw(spr, x, y, rotate, (map.tileSize * 0.9) / spr:getWidth() * value.width, (map.tileSize * 0.9) / spr:getHeight() * value.height, spr:getWidth() / 2, spr:getHeight() / 2)
    end
    love.graphics.setColor(1,1,1)
end

function shadows.functions.updateShadow(index, x, y)
    shadows.shadows[index].pos.x = x
    shadows.shadows[index].pos.y = y
end

--shadows.functions.newShadow(player.position.x, player.position.y, "circle", 1, 1)

return shadows