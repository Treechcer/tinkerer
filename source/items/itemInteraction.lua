itemInteraction = {}

function itemInteraction.breakEntity()
    local entIndex = entities.isEntityOnTile(player.cursor.tileX, player.cursor.tileY)
    local item = inventory.hotBar.items[inventory.hotBar.selectedItem].item
    if entIndex >= 1 and entities.canWeDamage(entIndex, itemIndex[item].weakness, itemIndex[item].strength) then
        entities.damageEntity(entIndex, itemIndex[item].attack)
    end
end

return itemInteraction