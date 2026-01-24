building = {
    f = {},

}

function building.f.build(tileX, tileY, width, height, enName)
    if entities.isEntityOnTile(tileX, tileY, width, height) ~= -1 then
        return false
    end

    local en = entitiesIndex[enName]

    --tables.writeTable(en)

    entities.makeNewOne(tileX, tileY, enName, en.HP, en.drop, en.width, en.height, en.xp)
    return true
end

function building.f.render(sprite, x, y, width, height)
    love.graphics.setColor(0.35,1,0.35,0.75)
    love.graphics.draw(sprite, x, y, 0, width / sprite:getWidth(), height / sprite:getHeight())
    love.graphics.setColor(1,1,1,1)
end

return building