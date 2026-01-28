entityInteractivity = {
    f = {}
}

function entityInteractivity.f.interact(keys)
    local index = entities.isEntityOnTile(player.cursor.tileX, player.cursor.tileY, player.cursor.width, player.cursor.width)

    if index == -1 then
        return false
    end

    for _, key in ipairs(keys) do
        if love.keyboard.isDown(key) then
            local f = entitiesIndex[entities.ents[index].index].interactivityKeys[key]

            if f ~= nil then
                f(entities.ents[index])
            end
        end
    end
end

return entityInteractivity