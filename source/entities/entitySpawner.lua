entitySpawner = {
    func = {},
    timeToSpawn = 1, --seconds
    lastTimeSpawned = 0,
    possibleSpawns = {
        "rock", "snow"
    },
}

function entitySpawner.func.spawn()
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

return entitySpawner