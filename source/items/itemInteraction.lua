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
            return itemInteraction.hit(value)
            --c = c + 1
        end
    else
        return itemInteraction.hit(entIndexs)
    end


    inventory.hotBar.moveItem = true
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