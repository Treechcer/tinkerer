inventory = {
    hotBar = {
        maxItems = 4,
        --items = {},
        boxSize = 50, --pixels
        paddingBottom = 15,
        itemPad = 3,
        selectedItem = 1,
        lastTime = 0,
        coolDown = 0.2,
        numberPad = 15,
        moveVal = 0,
        moveItem = false,
        moving = false
    },
    inventoryBar = {
        inventory = {
            {},
            {},
            {},
            {
                { item = "hammer", count = 1 },
                { item = "rock", count = 5 }
            },
        } --this is sectioned into 4 x 4 inventory parts, the last one is hotbar but it kinda supports getting different sizes yk
    },
    itemsOutsideOfInventory = {
        coins = 999999999999,
    },
    functions = {}
}

function inventory.functions.renderHotbar()
    --TODO fix the number color and stuff not important rn
    local hotbar = inventory.hotBar
    local i = inventory.inventoryBar.inventory
    local inventoryHB = i[#i]
    local totalWidth = hotbar.maxItems * hotbar.boxSize
    local startX = (game.width - totalWidth) / 2
    local y = game.height - hotbar.boxSize - hotbar.paddingBottom

    for i = 1, hotbar.maxItems do
        if (i == inventory.hotBar.selectedItem) then
            love.graphics.setColor(0.7, 0.5, 1)
        else
            love.graphics.setColor(0.8, 0.8, 0.8)
        end
        love.graphics.rectangle("fill", startX + (i - 1) * hotbar.boxSize, y, hotbar.boxSize, hotbar.boxSize)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", startX + (i - 1) * hotbar.boxSize, y, hotbar.boxSize, hotbar.boxSize)
        if inventoryHB[i] ~= nil then
            love.graphics.setColor(1, 1, 1)
            local spr = spw.sprites[inventoryHB[i].item].sprs
            love.graphics.draw(spr, startX + (i - 1) * hotbar.boxSize + hotbar.itemPad, y + hotbar.itemPad, 0,
                (hotbar.boxSize - hotbar.itemPad * 2) / spr:getWidth(),
                (hotbar.boxSize - hotbar.itemPad * 2) / spr:getHeight())
            love.graphics.setColor(1,1,1)
            love.graphics.print(math.floor(inventoryHB[i].count),
                startX + (i) * hotbar.boxSize - hotbar.numberPad,
                y + hotbar.boxSize - hotbar.numberPad)
        end
    end

    love.graphics.setColor(1, 1, 1)
end

function inventory.functions.update(dt)
    inventory.hotBar.lastTime = inventory.hotBar.lastTime + dt
end

function inventory.functions.addNewItem(item, count)
    local i = inventory.inventoryBar.inventory
    if (inventory.hotBar.maxItems > #i[#i]) then
        if count <= itemIndex[item].maxStackSize then
            table.insert(i[#i], { item = item, count = count })
        else
            table.insert(i[#i], { item = item, count = itemIndex[item].maxStackSize })
            inventory.functions.addItem(item, count - itemIndex[item].maxStackSize)
        end
    end
end

function inventory.functions.addItem(item, count)
    print(item, count)

    if count <= 0 then
        return
    end

    local found = false
    local i = inventory.inventoryBar.inventory

    for index, value in ipairs(i[#i]) do
        if value.item == item and value.count < itemIndex[item].maxStackSize then
            if itemIndex[item].maxStackSize < value.count + count then
                local overflow = (itemIndex[item].maxStackSize - (value.count + count)) * (-1)
                value.count = itemIndex[item].maxStackSize
                print(itemIndex[item].maxStackSize)
                print(value.count)
                print(count)
                inventory.functions.addNewItem(item, overflow)
            else
                value.count = value.count + count
            end
            found = true
            break
        end
    end

    if not found then
        inventory.functions.addNewItem(item, count)
    end
end


function inventory.functions.itemMove(dt)
    local i = inventory.inventoryBar.inventory

    if i[#i][inventory.hotBar.selectedItem] == nil then
        return
    end

    local item = itemIndex[i[#i][inventory.hotBar.selectedItem].item]
    if inventory.hotBar.moveVal >= item.attackRotation then
        inventory.hotBar.moveItem = false
    end

    if inventory.hotBar.moveItem then
        inventory.hotBar.moveVal = inventory.hotBar.moveVal + dt * item.speedAttackMultiplayer
        inventory.hotBar.moving = true
    elseif (not inventory.hotBar.moveItem) and (inventory.hotBar.moveVal >= 0) then
        inventory.hotBar.moveVal = inventory.hotBar.moveVal - dt * item.speedAttackMultiplayer
        inventory.hotBar.moving = true
    else
        inventory.hotBar.moving = false
    end
end

return inventory