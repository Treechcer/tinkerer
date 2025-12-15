entitySpawner = {
    func = {},
    timeToSpawn = 1, --seconds
    lastTimeSpawned = 0
}

function entitySpawner.func.spawn()
    tileX = math.floor(math.random(1, map.chunkWidth * map.chunkWidthNum)) - 1
    tileY = math.floor(math.random(1, map.chunkHeight * map.chunkHeightNum)) - 1

    if not renderer.checkCollsion(renderer.getWorldPos(tileX, tileY)) then
        return
    end

    if entities.isEntityOnTile(tileX, tileY) >= 1 then
        return
    end

    entities.makeNewOne(tileX, tileY, "rock", 5, {item = "rock", count = 3})
end

return entitySpawner