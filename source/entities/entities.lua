entities = {
    ents = { }, --all entity data stored here!
    num = 1,
}

function entities.makeNewOne(tileX, tileY, index, health, drop, width, height, xp, isDrop)
    isDrop = isDrop or false
    local shadowIndex = nil
    tileX = tonumber(tileX)
    tileY = tonumber(tileY)
    if isDrop then
        width = width or 1
        height = height or 1
        killTime = 0
        health = 0
        drop = drop
        xp = nil
        typeE = "droppedItem"

        console.commands.debugPrint("mild", "This is created as droppedItem: " .. index)
    else
        width = width or 1
        height = height or 1
        killTime = entitiesIndex[index].killTime
        health = health or entitiesIndex[index].HP
        drop = drop or entitiesIndex[index].drop
        xp = xp or entitiesIndex[index].xp
        typeE = entitiesIndex[index].typeE or "entity"
        shadowIndexSprite = entitiesIndex[index].shadowIndexSprite
        if entitiesIndex[index].shadows then
            --print(shadowIndexSprite)
            shadowIndex = shadows.functions.newShadow(tileX * map.tileSize, (tileY + 0.25) * map.tileSize --[[+ ((height - 1) * map.tileSize)]], shadowIndexSprite, width, height)
        end
    end
    --print(tileX, tileY, index)

    table.insert(entities.ents, { tileX = tileX, tileY = tileY, index = index, health = health, drop = drop, width = width, height = height, xp = xp, killTime = killTime, shadowIndex = shadowIndex, typeE = typeE, enNum = entities.num })
    entities.num = entities.num + 1 -- primary key of some sorts, might not be reliabe after I add saves?
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
                local spr
                if entitiesIndex[value.index] then
                    spr = entitiesIndex[value.index].getSprite(value)
                else
                    spr = spw.sprites[value.index].sprs

                    --TODO: Test
                    -- this was programmed during power outage on phone, test this later
                    -- this is here to prevent technically possible thing that it COULS be an table because anim. sprites

                    if type(spr) == "table" then
                        spr = spw.sprites[value.index].sprs[value.index]
                    end

                end
                if value.isNPC then
                    --local x, y = renderer.getAbsolutePos(value.tileX * map.tileSize, value.tileY * map.tileSize)
                    local yMV = spr:getHeight() * 1.2
                    --print(value.moveX, value.moveY)
                    local h, w = value.height * map.tileSize, value.width * map.tileSize
                    love.graphics.draw(spr,
                        posX + w / 2 --[[+ ((value.moveX or 0) * map.tileSize)]],
                        posY + h / 2 + yMV + 25 - (value.jumpySpace) --[[+ ((value.moveY or 0) * map.tileSize)]],
                        (value.rotateM or 0),
                        (w / spr:getWidth()) * (value.screenSide),
                        h / spr:getHeight(),
                        spr:getWidth() / 2,
                        yMV
                    )
                elseif value.isDroppedItem then
                    local offsetY = value.offsetY or 0
                    specialDraws.f.outline(spr, posX, posY + offsetY, 0, map.tileSize / spr:getWidth() * (value.width or 1), map.tileSize / spr:getHeight() * (value.height or 1))
                else
                    --cooked this to fix problem, realised it was broken elsewhere....
                    --if spr == nil then
                    --    tables.writeTable(entitiesIndex[value.index])
                    --    spr = entitiesIndex[value.index].getSprite(value)
                    --end

                    local scalatorX, scalatorY = (value.scaleX ~= nil) and value.scaleX or value.width, (value.scaleY ~= nil) and value.scaleY or value.height
                    local scaleX, scaleY = map.tileSize / spr:getWidth() * (scalatorX or 1), map.tileSize / spr:getHeight() * (scalatorY or 1)

                    if value.index == "tree" then
                        print(scalatorX, value.width, value.scaleX, " | ", scalatorY, value.height, value.scaleY)
                    end

                    love.graphics.draw(spr, posX + map.tileSize / 2, posY + map.tileSize / 2, value.rotate or 0, scaleX, scaleY , spr:getWidth() / 2, spr:getHeight() / 2)
                    if value.weakness ~= 0 then
                        entities.drawHealthBar(value.tileX, value.tileY, value.width, value.height, value.health, entitiesIndex[value.index].HP)
                    end
                    
                end
                love.graphics.setColor(1,1,1)
            else
                love.graphics.setColor(value.col or defaultColor)
                love.graphics.rectangle("fill", posX, posY, map.tileSize, map.tileSize)
                love.graphics.setColor(1,1,1)
            end
        end
    end
end

function entities.isEntityOnTile(tileX, tileY, width, height)
    width = width or 1
    height = height or 1

    for index, value in ipairs(entities.ents) do
        --print(tileX, tileY, width, height, value.tileX, value.tileY, value.width, value.height)
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
        if renderer.AABB(tileX, tileY, width, height, value.tileX, value.tileY, value.width, value.height) then
            if not entitiesIndex[value.index].walkable then
                if value.isDroppedItem then
                    return -1
                end
                return index
            else
                return -1
            end
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
            if entitiesIndex[en.index].shadows then
                table.remove(shadows.shadows, en.shadowIndex)
            end

            if building.data[en.index].refs ~= nil then
                local index = 1
                for key, value in pairs(building.data[en.index].refs) do
                    if value.num == en.num and en.tileX == value.tileX and en.tileY == value.tileY then
                        table.remove(building.data[en.index].refs, index)
                    end

                    index = index + 1
                end
            end

            table.remove(entities.ents, entityIndex)
            entities.moveByOneIndexAllSubClasses(entityIndex)
            
            --not yet implemented
            --local bonus = player.atributes[en.luck]
            for __, val in ipairs(en.drop) do
                --tables.writeTable(val)
                --inventory.functions.addItem(val.item, val.baseCount)
                --this crashes game?

                droppedItems.f.create(en.tileX, en.tileY, val.item, val.baseCount)
                --droppedItems.items[#droppedItems.items].id = droppedItems.items[#droppedItems.items].id - 1
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
    end
end

function entities.drawHealthBar(tileX, tileY, enWidth, enHeight, hpNow, hpMax)
    if hpNow / hpMax ~= 1 then
        local screenX, screenY = renderer.getAbsolutePos((tileX + (enWidth / 2)) * map.tileSize - map.tileSize * (1/3), (tileY + enHeight) * map.tileSize)
        --print(screenX, screenY)
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("fill", screenX, screenY, map.tileSize * (2/3), 10)
        love.graphics.setColor(1,1,1)
        love.graphics.setShader(shaderWorker.shaders.lerpShader)
        --love.graphics.rectangle("fill", screenX + 2, screenY + 2, map.tileSize * (2/3) * (hpNow / hpMax) - 4, 10 - 4)
        local spr = spw.getSprite("red")
        love.graphics.draw(spr, screenX + 2, screenY + 2, 0, (map.tileSize * (2/3) * (hpNow / hpMax) - 4) / spr:getWidth(), (10 - 4) / spr:getHeight())
        love.graphics.setShader()
    end
    --print(tileX, tileY, enWidth, enHeight, hpNow, hpMax)
end

function entities.moveByOneIndexAllSubClasses(index)
    npcs.functions.changeIndexByOne(index)
    entities.shiftShadowOne(index)
    droppedItems.f.changeIndexByOne(index)
    entityCleaner.f.removeIndex(index)
end

function entities.shiftShadowOne(index)
    for i = index, #entities.ents do
        local en = entities.ents[i]
        if en.shadowIndex ~= nil then
           en.shadowIndex = en.shadowIndex - 1
        end
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
    entities.moveByOneIndexAllSubClasses(index)
end

function entities.special()
    for key, value in pairs(entities.ents) do
        if entitiesIndex[value.index] ~= nil and entitiesIndex[value.index].run ~= nil then
            entitiesIndex[value.index].run(value)
        end
    end
end

function entities.getAllEntitiesByIndex(index) -- this return all indices of all entities with of the same type (rock, tree...)
    local ret = {}

    for index_, value in ipairs(entities.ents) do
        if value.index == index then
            table.insert(ret, index_)
        end
    end

    return ret
end

return entities