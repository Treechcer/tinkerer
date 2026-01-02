itemInteraction = {}

function itemInteraction.breakEntity()

    if inventory.hotBar.moving then
        return
    end

    local entIndexs = entities.isEntityOnTileTableRet(player.cursor.tileX - (player.cursor.width / 2),
    player.cursor.tileY - (player.cursor.height / 2),
    player.cursor.width,
    player.cursor.height)
    if type(entIndexs) == "table" then
        --local c = 1
        table.sort(entIndexs, function(x, y) return x > y end)
        for index, value in ipairs(entIndexs) do
            --print("hit?", c, " ", #entIndexs)
            inventory.hotBar.moveItem = itemInteraction.hit(value)
            return inventory.hotBar.moveItem
            --c = c + 1
        end
    else
        inventory.hotBar.moveItem = itemInteraction.hit(entIndexs)
        return inventory.hotBar.moveItem
    end
end

function itemInteraction.hit(entIndex)
    local item = inventory.hotBar.items[inventory.hotBar.selectedItem].item
    if entIndex >= 1 and entities.canWeDamage(entIndex, itemIndex[item].weakness, itemIndex[item].strength) then
        entities.damageEntity(entIndex, itemIndex[item].attack)
        return true
    end

    return false
end

return itemInteraction