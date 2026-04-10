--NOTE: NPCs can be hostile or friendly, some can move peromanently and serach (for example) for player or somethign else

--NOTE2: npcs are just entities with more code

npcs = {
    npcIndexes = {},
    functions = {}
}

function npcs.functions.passiveAI(npc)
    if npc.path == nil or npc.path == {} then
        npc.path = pathfinding.functions.startMoving({x = npc.tileX, y = npc.tileY}, {x = npc.tileX + math.random(-3, 3), y = npc.tileY + math.random(-3, 3)})
    end

    return npc
end

function npcs.functions.changeIndexByOne(index)
    local rm = false
    for key, value in pairs(npcs.npcIndexes) do
        if index <= value.index then
           value.index = value.index - 1

            if value.index <= 0 then
                rm = true
            end
        elseif index == value.index then
            rm = true
        end
    end

    if rm then
        table.remove(npcs.npcIndexes, index)
    end
end

function npcs.functions.makeNewIndex()
    --I have to think about how to implement them into the entities, idk if this is the best way
    entitiesIndex.f.addIndex("chicken", true, 2, 5, 0, {}, 1, 1, nil, {}, {}, nil, nil, nil, nil, nil, {shadowIndexSprite = "circle"})
end

function npcs.functions.spawn()
    --print(player.position.tileX, player.position.tileY)
    entities.makeNewOne(player.position.tileX, player.position.tileY, "chicken", 5, {}, 1, 1, {}, false)
    entities.ents[#entities.ents].isNPC = true
    table.insert(npcs.npcIndexes, {index = #entities.ents, npc = "chicken", ai = "passiveAI", timeToMove = 0.2})

    local npc = npcs.npcIndexes[#entities.ents]
    local shadowPos = shadows.shadows[entities.ents[npc.index].shadowIndex].pos
    shadowPos.x, shadowPos.y = shadowPos.x + (0.5 * map.tileSize), shadowPos.y + (0.65 * map.tileSize)

    local en = entities.ents[#entities.ents]
    en.jumpySpace = 0
    en.screenSide = 0
end

function npcs.functions.init()
    npcs.functions.makeNewIndex()

    npcs.functions.spawn()
end

function npcs.functions.loop()
    for key, value in pairs(npcs.npcIndexes) do
        --tables.writeTable(value)
        local path = entities.ents[value.index].path
        if path == nil or path == {} then
            entities.ents[value.index] = npcs.functions[value.ai](entities.ents[value.index])
            --tables.writeTable(entities.ents[value.index])
            path = entities.ents[value.index].path
        end

        npcs.functions.move(value)
        --pathfinding.functions.visualisePath(path)
    end
end

function npcs.functions.move(npc)
    local en = entities.ents[npc.index]
    local path = en.path
    if path == nil or path[1] == nil or path[2] == nil then
        en.path = nil
        entities.ents[npc.index] = npcs.functions[npc.ai](entities.ents[npc.index])
        path = entities.ents[npc.index].path
        en.state = "standing"
        npc.lastmove = 0
        return
    end

    if not map.f.accesibleTile(path[2].x, path[2].y) or entities.isNonWalkableEntityOnTile(path[2].x, path[2].y, 1, 1) ~= -1 then
        en.path = nil
        entities.ents[npc.index] = npcs.functions[npc.ai](entities.ents[npc.index])
        return
    end

    local dt = love.timer.getDelta()

    --tables.writeTable(en)

    local add = specialAnimations.functions.jumpyMovement({rotateM = en.rotateM, xP = en.tileX * map.tileSize, yP = en.tileY * map.tileSize, spr = spw.sprites[en.index].sprs, state = "walking", width = entitiesIndex[en.index].width, height = entitiesIndex[en.index].height, jumpySpace = en.jumpySpace, walking = true, screenSide = 1, moveLeft = en.moveLeft, moveDown = en.moveDown}, en)

    entities.ents[npc.index].height = entitiesIndex[en.index].height
    entities.ents[npc.index].width = entitiesIndex[en.index].width

    --print("SA" .. entities.ents[npc.index].width)

    npc.lastmove = npc.lastmove or 0
    npc.lastmove = npc.lastmove + dt
    if npc.lastmove < npc.timeToMove then
        return
    end

    --tables.writeTable(en)

    for key, value in pairs(add) do
        en[key] = value
    end

    --tables.writeTable(path)

    entities.ents[npc.index].moveX = entities.ents[npc.index].moveX or 0
    entities.ents[npc.index].moveY = entities.ents[npc.index].moveY or 0

    local dx, dy = (path[1].x - path[2].x) * (-1), (path[1].y - path[2].y) * (-1)
    
    local mvx, mvy = (dt * dx), (dt * dy)

    entities.ents[npc.index].moveX, entities.ents[npc.index].moveY = entities.ents[npc.index].moveX + mvx, entities.ents[npc.index].moveY + mvy
    entities.ents[npc.index].tileX, entities.ents[npc.index].tileY = entities.ents[npc.index].tileX + mvx, entities.ents[npc.index].tileY + mvy

    local shadowPos = shadows.shadows[entities.ents[npc.index].shadowIndex].pos

    shadowPos.x, shadowPos.y = shadowPos.x + (mvx * map.tileSize), shadowPos.y + (mvy * map.tileSize)

    local rm = false
    if entities.ents[npc.index].moveY >= 1 then
        entities.ents[npc.index].moveY = 0
        --en.tileY = en.tileY + 1
        --table.remove(path, 1)
        rm = true
    elseif entities.ents[npc.index].moveY <= -1 then
        entities.ents[npc.index].moveY = 0
        --en.tileY = en.tileY - 1
        rm = true
        --table.remove(path, 1)
    end

    if entities.ents[npc.index].moveX >= 1 then
        entities.ents[npc.index].moveX = 0
        --en.tileX = en.tileX + 1
        rm = true
        --table.remove(path, 1)
    elseif entities.ents[npc.index].moveX <= -1 then
        entities.ents[npc.index].moveX = 0
        --en.tileX = en.tileX - 1
        rm = true
        --table.remove(path, 1)
    end

    if rm then
        shadowPos.x, shadowPos.y = (en.path[2].x + 0.5) * map.tileSize, (en.path[2].y + 0.85) * map.tileSize -- idk why 0.85 works, it should be 0.65 because that's how it's created?
        en.tileX, en.tileY = en.path[2].x, en.path[2].y
        table.remove(en.path, 1)
    end

    --print(en.tileX, en.tileY)

    --love.event.quit()

    --print(en.moveX, en.moveY)
end

return npcs