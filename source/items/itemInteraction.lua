itemInteraction = {}

function itemInteraction.breakEntity()
    local entIndex = entities.isEntityOnTile(player.cursor.tileX, player.cursor.tileY)
    if entIndex >= 1 then
        entities.damageEntity(entIndex, 1)
        --TODO: add checking "permisios" if you can attack it and make it do correct ammount of damage
    end
end

return itemInteraction