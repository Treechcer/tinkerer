entityCleaner = {
    f = {},
    lastClean = 0,
    cdToClean = 1,
    indexesToDelete = {}
}

function entityCleaner.f.update(dt)
    entityCleaner.lastClean = entityCleaner.lastClean + dt

    if entityCleaner.lastClean >= entityCleaner.cdToClean then
        for index, value in ipairs(entities.ents) do
            --tables.writeTable(entitiesIndex[value.index])
            if entitiesIndex[value.index].isCleanUp(value, entityCleaner.lastClean) then
                table.insert(entityCleaner.indexesToDelete, index)
            end
        end

        for i = #entityCleaner.indexesToDelete, 1, -1 do
            table.remove(entities.ents, entityCleaner.indexesToDelete[i])
            entities.moveByOneIndexAllSubClasses(i)
        end

        entityCleaner.lastClean = 0
    end
end

function entityCleaner.f.removeIndex(index)
    for index_, value in ipairs(entityCleaner.indexesToDelete) do
        if value == index then
            table.remove(entitiesIndex.indexesToDelete, index)
            break
        end
    end
end

return entityCleaner