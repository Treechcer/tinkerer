--NOTE: NPCs can be hostile or friendly, some can move peromanently and serach (for example) for player or somethign else

--NOTE2: npcs are just entities with more code

npcs = {
    npcIndexes = {},
    functions = {}
}

function npcs.functions.changeIndexByOne(index)
    for key, value in pairs(npcs.npcIndexes) do
        if index <= value then
           entities.ents[value] = value - 1
        end
    end
end

function npcs.functions.makeNewOne()
    --I have to think about how to implement them into the entities, idk if this is the best way
    entitiesIndex.f.addIndex("chicken", true, 2, 4, 0, {}, 1, 1, nil, {}, {})
    table.insert(npcs.npcIndexes, #entities.ents)
end

function npcs.functions.spawn()
    entities.makeNewOne(player.position.tileX, player.position.tileY, "chicken")
end

function npcs.functions.init()
    npcs.functions.makeNewOne()
end

return npcs