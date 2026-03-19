--NOTE: NPCs can be hostile or friendly, some can move peromanently and serach (for example) for player or somethign else

--NOTE2: npcs are just entities with more code

npcs = {
    npcIndexes = {},
    functions = {}
}

function npcs.functions.passiveAI(npc)
    if npc.path == nil or npc.path == {} then
        npc.path = pathfinding.functions.startMoving({x = npc.tileX, y = npc.tileY}, {x = npc.tileX + 1, y = npc.tileY - 2})
    end

    return npc
end

function npcs.functions.changeIndexByOne(index)
    local rm = false
    for key, value in pairs(npcs.npcIndexes) do
        if index <= value.index then
           entities.ents[value.index] = value.index - 1
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
    entitiesIndex.f.addIndex("chicken", true, 2, 5, 0, {}, 1, 1, nil, {}, {})
end

function npcs.functions.spawn()
    --print(player.position.tileX, player.position.tileY)
    entities.makeNewOne(player.position.tileX, player.position.tileY, "chicken", 5, {}, 1, 1, {})
    table.insert(npcs.npcIndexes, {index = #entities.ents, npc = "chicken", ai = "passiveAI"})
end

function npcs.functions.init()
    npcs.functions.makeNewIndex()

    npcs.functions.spawn()
end

function npcs.functions.loop()
    for key, value in pairs(npcs.npcIndexes) do
        local path = entities.ents[value.index].path
        if path == nil or path == {} then
            entities.ents[value.index] = npcs.functions[value.ai](entities.ents[value.index])
            tables.writeTable(entities.ents[value.index])
            path = entities.ents[value.index].path
        end
        --pathfinding.functions.visualisePath(path)
    end
end

return npcs