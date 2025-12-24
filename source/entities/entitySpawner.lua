entitySpawner = {
    func = {},
    timeToSpawn = 1, --seconds
    lastTimeSpawned = 0,
    maxSpawns = 5
}

function entitySpawner.func.init()
    entitySpawner.possibleSpawns = {
        grass = biomeData.grass.spawns,
        sand  = biomeData.sand.spawns,
        void  = biomeData.void.spawns,
        snow  = biomeData.sand.spawns,
        hill  = biomeData.hill.spawns
    }
end

function entitySpawner.func.spawn(dt)
    entitySpawner.lastTimeSpawned = entitySpawner.lastTimeSpawned + dt

    if not (entitySpawner.lastTimeSpawned >= entitySpawner.timeToSpawn) then
        return
    end

    entitySpawner.lastTimeSpawned = 0

    spawns = math.random(1, entitySpawner.maxSpawns)

    for i=0,spawns do
        local tileX = math.floor(math.random(1, map.chunkWidth * map.chunkWidthNum)) - 1
        local tileY = math.floor(math.random(1, map.chunkHeight * map.chunkHeightNum)) - 1

        local chunkX = math.ceil(tileX / map.chunkWidth)
        local chunkY = math.ceil(tileY / map.chunkHeight)
        --print(map.chunkWidth, " / ", tileX, " : ", chunkX, " ", map.chunkHeight, " / ", tileY, " : ", chunkY)
        
        chunkX = chunkX ~= 0 and chunkX or 1
        chunkY = chunkY ~= 0 and chunkY or 1

        local biome = map.map.chunks[chunkY][chunkX].biome

        --print(biome)
        --tables.writeTable(entitySpawner.possibleSpawns)
        local item = entitiesIndex[entitySpawner.possibleSpawns[biome][math.random(1, #entitySpawner.possibleSpawns[biome])]]

        --if not renderer.checkCollsion(renderer.getWorldPos(tileX, tileY)) then
        --    return
        --end
        if entities.isEntityOnTile(tileX, tileY, item.width, item.height) == -1 and renderer.checkCollsionWidthHeight(tileX, tileY, item.width, item.height) then
            entities.makeNewOne(tileX, tileY, item.entityName, item.HP, item.drop, item.width, item.height)
        end
        --tables.writeTable(entitiesIndex)
    end
end

return entitySpawner