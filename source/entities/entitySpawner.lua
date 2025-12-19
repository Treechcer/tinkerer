entitySpawner = {
    func = {},
    timeToSpawn = 1, --seconds
    lastTimeSpawned = 0,
    possibleSpawns = {
        "rock",
    },
    maxSpawns = 3
}

function entitySpawner.func.spawn(dt)
    entitySpawner.lastTimeSpawned = entitySpawner.lastTimeSpawned + dt

    if not (entitySpawner.lastTimeSpawned >= entitySpawner.timeToSpawn) then
        return
    end

    entitySpawner.lastTimeSpawned = 0

    spawns = math.random(1, entitySpawner.maxSpawns)
    
    for i=0,spawns do
        local item = entitiesIndex[entitySpawner.possibleSpawns[math.random(1, #entitySpawner.possibleSpawns)]]

        local tileX = math.floor(math.random(1, map.chunkWidth * map.chunkWidthNum)) - 1
        local tileY = math.floor(math.random(1, map.chunkHeight * map.chunkHeightNum)) - 1

        if not renderer.checkCollsion(renderer.getWorldPos(tileX, tileY)) then
            return
        end

        if entities.isEntityOnTile(tileX, tileY) ~= -1 then
            return
        end
        --tables.writeTable(entitiesIndex)

        entities.makeNewOne(tileX, tileY, item.entityName, item.HP, item.drop)
    end
end

return entitySpawner