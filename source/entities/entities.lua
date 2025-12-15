entities = {
    ents = { { tileX = 1, tileY = 1, index = "rock", health = 5, drop = {item = "rock", count = 14} } }, --all entity data stored here!
}

function entities.makeNewOne(tileX, tileY, index, health, drop)
    table.insert(entities.ents, {tileX = tileX, tileY = tileY, index = index, health = health, drop = drop})
end

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
            local posX, posY = renderer.getAbsolutePos(value.tileX * map.tileSize, value.tileY * map.tileSize)
            if value.index ~= nil then
                love.graphics.setColor(defaultColor)
                local spr = spriteWorker.sprites[entitiesIndex[value.index].spwName].sprs
                love.graphics.draw(spr, posX, posY, 0, map.tileSize / spr:getWidth(), map.tileSize / spr:getHeight())
            else
                love.graphics.setColor(value.col or defaultColor)
                love.graphics.rectangle("fill", posX, posY, map.tileSize,
                    map.tileSize)
            end
        end
    end
end

function entities.isEntityOnTile(tileX,tileY)
    for index, value in ipairs(entities.ents) do
        if value.tileX == tileX and value.tileY == tileY then
            return index
        end
    end

    return -1
end

function entities.canWeDamage(indexEnt, attackWeakness, attackStrength)
    local enIndex = entitiesIndex[entities.ents[indexEnt].index]
    if enIndex.strengthMin <= attackStrength and bit.timesBit({attackWeakness, enIndex.weakness}) > 0 then
        return true
    end
    return false
end

function entities.damageEntity(entityIndex, damageNumber)
    local en = entities.ents[entityIndex]
    en.health = en.health - damageNumber
    if en.health <= 0 then
        if en.drop ~= nil then
            inventory.functions.addItem(en.drop.item, en.drop.count)
        end
        table.remove(entities.ents, entityIndex)
    end
end

return entities