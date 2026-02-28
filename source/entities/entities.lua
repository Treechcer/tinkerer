entities = {
    ents = { }, --all entity data stored here!
}

function entities.makeNewOne(tileX, tileY, index, health, drop, width, height, xp)
    width = width or 1
    height = height or 1
    killTime = entitiesIndex[index].killTime
    health = health or entitiesIndex[index].HP
    drop = drop or entitiesIndex[index].drop
    xp = xp or entitiesIndex[index].xp

    table.insert(entities.ents, { tileX = tileX, tileY = tileY, index = index, health = health, drop = drop, width = width, height = height, xp = xp, killTime = killTime })
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
                --tables.writeTable(entitiesIndex[value.index])
                local spr = entitiesIndex[value.index].getSprite(value)
                love.graphics.draw(spr, posX, posY, 0, map.tileSize / spr:getWidth() * value.width, map.tileSize / spr:getHeight() * value.height)
            else
                love.graphics.setColor(value.col or defaultColor)
                love.graphics.rectangle("fill", posX, posY, map.tileSize, map.tileSize)
            end
        end
    end
end

function entities.isEntityOnTile(tileX, tileY, width, height)
    width = width or 1
    height = height or 1

    for index, value in ipairs(entities.ents) do
        if renderer.AABB(tileX, tileY, width, height, value.tileX, value.tileY, value.width, value.height) then
            return index
        end
    end

    return -1
end

function entities.isNonWalkableEntityOnTile(tileX, tileY, width, height)
    width = width or 1
    height = height or 1

    for index, value in ipairs(entities.ents) do
        if renderer.AABB(tileX, tileY, width, height, value.tileX, value.tileY, value.width, value.height) and value.walkable then
            return index
        end
    end

    return -1
end

function entities.isEntityOnTileTableRet(tileX, tileY, width, height)
    width = width or 1
    height = height or 1
    local tbl = {}
    for index, value in ipairs(entities.ents) do
        --if value.tileX == tileX and value.tileY == tileY then
        --    return index
        --end
        --if (width ~= 1) then
        --    print(tileX, tileY, width, height, value.tileX, value.tileY, value.width, value.height)
        --end

        if renderer.AABB(tileX, tileY, width, height, value.tileX, value.tileY, value.width, value.height) then
            if width ~= 1 or height ~= 1 then
                table.insert(tbl, index)
            else
                return index
            end
        end
    end

    if next(tbl) ~= nil then
        return tbl
    end

    return -1
end

function entities.canWeDamage(indexEnt, attackWeakness, attackStrength)
    local enIndex = entitiesIndex[entities.ents[indexEnt].index]
    --tables.writeTable(enIndex)
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
            --not yet implemented kianfiao
            --local bonus = player.atributes[en.luck]
            for __, val in ipairs(en.drop) do
                --tables.writeTable(val)
                inventory.functions.addItem(val.item, val.baseCount)
            end
        end

        if en.xp ~= nil then
            skills.f.addXP(en.xp)
            --tables.writeTable(en.xp)
            --for index, value in ipairs(en.xp) do
            --    print(value)
            --    skills.f.addXP(value)
            --end
        end

        --print(en.xp)

        table.remove(entities.ents, entityIndex)
    end
end

function entities.updateAll(dt)
    for index, value in ipairs(entities.ents) do
        if entitiesIndex[value.index] ~= nil then
            --tables.writeTable(entitiesIndex[value.index])
            if entitiesIndex[value.index].update ~= nil then
                entitiesIndex[value.index].update(value, dt)
            end
        end
    end
end

function entities.kill(index)
    table.remove(entities.ents, index)
end

function entities.special()
    for key, value in pairs(entities.ents) do
        if entitiesIndex[value.index].run ~= nil then
            entitiesIndex[value.index].run(value)
        end
    end
end

return entities